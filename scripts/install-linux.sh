#!/usr/bin/env bash
echo "Installing Linux packages..."

set -e

PACKAGES=(
    stow
    fish
    git
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
    zoxide
)

echo "Installing packages: ${PACKAGES[*]}"
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

echo "Linux packages installed successfully"
