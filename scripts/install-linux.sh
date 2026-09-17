#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

set -e

section "Installing Linux packages"

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

step "Installing packages"
echo "${PACKAGES[*]}"
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

ok "Linux packages installed successfully"
