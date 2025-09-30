#!/usr/bin/env bash
echo "Installing Linux packages..."

set -e

# Install essential packages
PACKAGES=(
    stow
    fish
    git
    git-extras
    tmux
    fzf
    bat
    eza
    dust
    ripgrep
    jq
    neovim
    btop
    fastfetch
    github-cli
    lazydocker
    lazygit
    alacritty
)

echo "Installing packages: ${PACKAGES[*]}"
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# Set fish as default shell
if [[ "$SHELL" != *"fish"* ]]; then
    echo "Setting fish as default shell..."
    chsh -s $(which fish)
fi

echo "Linux packages installed successfully"
