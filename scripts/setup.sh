#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

set -e

main() {
  cd "$ROOT"

  if [[ $(uname -s) == "Darwin" ]]; then
    "$ROOT/scripts/install-macos.sh"
  elif [[ $(uname -s) == "Linux" ]]; then
    "$ROOT/scripts/install-linux.sh"
  fi

  # Stow runs after packages (stow is now installed) but before shell setup,
  # so symlinks are in place before anything creates real config files.
  stow --restow .

  if [[ $(uname -s) == "Darwin" ]]; then
    "$ROOT/scripts/config-macos.sh"
  fi

  "$ROOT/scripts/setup-shell.sh"
}

main

echo "All Done!"
echo "Restarting shell..."
exec "$(which $SHELL)" -l
