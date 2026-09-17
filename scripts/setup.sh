#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/lib.sh"

set -e

# Config directory that .stowrc targets.
CONFIG="$HOME/.config"

# One-time migration, and a standing guard against regressions.
#
# Before --no-folding was set in .stowrc, stow collapsed each package into a
# single directory symlink (~/.config/fish -> this repo), so everything
# fisher, tide and zed wrote to ~/.config landed inside the working tree.
#
# Simply restowing does NOT undo this: stow has no concept of git, so it
# happily symlinks those stray files back out of the repo, leaving the tree
# dirty *and* making the mess load-bearing. Detect the folded layout, undo
# it, and move the tool-generated files to where they belong first.
unfold_stow_packages() {
  local path pkg target resolved expected folded=()

  for path in "$ROOT"/*/; do
    pkg="$(basename "$path")"
    [[ "$pkg" == "scripts" ]] && continue
    target="$CONFIG/$pkg"

    # Only a symlink resolving back to this repo's package dir is a fold.
    # Normalise *both* sides: readlink -f expands every symlinked path
    # component (on macOS /var -> /private/var), so comparing a resolved
    # path against an unresolved $ROOT silently never matches.
    [[ -L "$target" ]] || continue
    resolved="$(readlink -f "$target" 2>/dev/null || true)"
    expected="$(readlink -f "$ROOT/$pkg" 2>/dev/null || true)"
    [[ -n "$resolved" && "$resolved" == "$expected" ]] && folded+=("$pkg")
  done

  (( ${#folded[@]} )) || return 0

  section "Migrating folded stow layout"
  echo "Symlinked directly into the repo: ${folded[*]}"

  step "Removing folded symlinks"
  stow -D .

  # Whatever git does not track -- untracked or ignored -- is tool-generated
  # state whose real home is ~/.config. Move it before restowing, or stow
  # will just link it straight back out of the repo.
  step "Moving tool-generated files out of the repo"
  local rel moved=0
  while IFS= read -r rel; do
    [[ -n "$rel" && -e "$ROOT/$rel" ]] || continue
    mkdir -p "$CONFIG/$(dirname "$rel")"
    mv "$ROOT/$rel" "$CONFIG/$rel"
    moved=$((moved + 1))
  done < <(git -C "$ROOT" ls-files --others -- "${folded[@]}")

  # git cannot track empty directories, so any left behind are residue.
  local i
  for i in 1 2 3 4 5; do
    find "$ROOT" -path "$ROOT/.git" -prune -o -type d -empty -print0 2>/dev/null |
      xargs -0 rmdir 2>/dev/null || true
  done

  ok "Moved $moved file(s) to $CONFIG"
}

# stow refuses to overwrite a real file sitting where it wants to place a
# symlink -- and it aborts *every* package when that happens, not just the one
# that clashed. Apps that write a default config on first launch cause this:
# Zed creates ~/.config/zed/settings.json, fish creates a config.fish stub. So
# launching Zed once before setup runs is enough to make the whole stow bail
# out, which shows up as "none of my dotfiles loaded".
#
# Move any such file into a timestamped backup so the repo copy wins. Nothing
# is ever deleted. Conflicts come from `stow --simulate` so we reuse stow's own
# ignore rules rather than reimplementing them.
relocate_stow_conflicts() {
  local backup conflicts rel attempt
  backup="$CONFIG-replaced-by-dotfiles-$(date +%Y%m%d-%H%M%S)"

  for attempt in 1 2 3; do
    conflicts="$(stow --simulate --restow . 2>&1 |
      sed -n -e 's/.*existing target \(.*\) since.*/\1/p' \
             -e 's/.*existing target is not owned by stow: \(.*\)/\1/p' \
             -e 's/.*existing target is neither a link nor a directory: \(.*\)/\1/p')"

    [[ -n "$conflicts" ]] || return 0

    step "Clearing conflicting config"
    echo "Found existing config where dotfiles symlinks belong."
    echo "Backing up to $backup"
    while IFS= read -r rel; do
      [[ -n "$rel" && -e "$CONFIG/$rel" ]] || continue
      mkdir -p "$backup/$(dirname "$rel")"
      mv "$CONFIG/$rel" "$backup/$rel"
      echo "  moved $rel"
    done <<<"$conflicts"
  done
}

main() {
  cd "$ROOT"

  if [[ $(uname -s) == "Darwin" ]]; then
    "$ROOT/scripts/install-macos.sh"
  elif [[ $(uname -s) == "Linux" ]]; then
    "$ROOT/scripts/install-linux.sh"
  fi

  # stow refuses to run if its --target (~/.config, set in .stowrc) is absent,
  # which is the default state on a fresh macOS install.
  mkdir -p "$CONFIG"

  section "Linking config"

  unfold_stow_packages
  relocate_stow_conflicts

  # Stow runs after packages (stow is now installed) but before shell setup,
  # so config is in place before fisher/tide/zed start up.
  #
  # --no-folding (set in .stowrc) is load-bearing: without it stow "folds" a
  # package whose target dir is absent into a single directory symlink
  # (~/.config/fish -> this repo). Every file fisher, tide or zed then writes
  # into ~/.config lands inside the repo and shows up as untracked noise.
  # With --no-folding, stow creates real directories and links only leaf
  # files, so tool-generated state stays in ~/.config where it belongs.
  step "Stowing dotfiles into ~/.config"
  stow --restow .
  ok "Config linked"

  if [[ $(uname -s) == "Darwin" ]]; then
    "$ROOT/scripts/config-macos.sh"
  fi

  "$ROOT/scripts/setup-shell.sh"
}

main

section "All done!"
echo "Restarting shell..."
exec "$(which $SHELL)" -l
