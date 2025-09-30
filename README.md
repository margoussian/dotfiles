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
- Symlinks configuration files to `~/.config/` using GNU Stow
- Platform-specific setup (macOS system preferences, etc.)

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

1. **Machine-Specific Config**: Copy and customize locals file
   ```bash
   cp ~/.config/fish/locals.fish.example ~/.config/fish/locals.fish
   # Edit with machine-specific settings
   ```

2. **GitHub CLI**: Authenticate with GitHub
   ```bash
   gh auth login
   ```
