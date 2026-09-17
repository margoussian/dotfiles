## Prerequisites

- Git
- Sudo access (for package installation)

## Quick Install

### With git

```bash
git clone http://github.com/margoussian/dotfiles && cd dotfiles && ./scripts/setup.sh
```

### Without git

```bash
curl -sL https://github.com/margoussian/dotfiles/archive/master.tar.gz | tar xz && cd dotfiles-master && ./scripts/setup.sh
```

## What It Does

- Installs essential CLI tools and dependencies
- Configures Fish as the default shell
- Symlinks configuration files to `~/.config/` using GNU Stow, with
  `--no-folding` so real directories are created and only tracked files are
  linked (see [Stow layout](#stow-layout))
- Platform-specific setup (macOS system preferences, etc.)

## Stow Layout

Stow runs with `--no-folding` (set in `.stowrc`). Without it, Stow collapses a
package whose target directory does not yet exist into a single *directory*
symlink -- `~/.config/fish -> this repo`. Everything fisher, tide and Zed then
write to `~/.config` lands inside the working tree, filling the repo with
untracked files. With `--no-folding`, Stow creates real directories and links
only leaf files, so tool-generated state stays in `~/.config`.

### Upgrading a machine set up before this fix

`./scripts/setup.sh` repairs the old layout automatically:

```bash
cd ~/Projects/dotfiles
git status          # commit or discard local changes first
git pull
./scripts/setup.sh
```

It removes the folded symlinks, moves tool-generated files out to `~/.config`,
and restows so only tracked config is linked. Re-running it is a no-op.

Note that anything *untracked* inside a package directory is treated as
tool-generated and moved to `~/.config`, so commit any work you mean to keep
before running it.

## Platform-Specific Notes

### macOS
- Requires Homebrew (installed automatically if missing)
- Sets system defaults (dark mode, Finder preferences, etc.)
- Installs Ghostty as the terminal emulator

### Linux (Arch)
- Uses `pacman` for package management
- Installs Alacritty as the terminal emulator
- Requires restart or re-login for shell changes to take effect

## Manual Steps After Installation

1. **Restart Shell**: Log out and back in, or restart your terminal for shell changes to take effect

2. **Tmux Plugins**: First time launching tmux, install plugins
   - Press `prefix` + <kbd>I</kbd> (capital I) to install plugins
   - Default prefix is `Ctrl+a`

3. **Machine-Specific Config**: Copy and customize locals file (optional)
   ```bash
   cp ~/.config/fish/locals.fish.example ~/.config/fish/locals.fish
   # Edit with machine-specific settings, aliases, environment variables
   ```

4. **GitHub CLI**: Authenticate with GitHub
   ```bash
   gh auth login
   ```

## Verify Installation

After completing setup, verify everything works:

- [ ] Open a new terminal - Fish should be your default shell
- [ ] Check prompt - Tide prompt should be configured
- [ ] Test aliases: `ls`, `cat`, `v`, `zed`
- [ ] Git commands work with your identity
- [ ] Tmux launches with correct theme and settings
