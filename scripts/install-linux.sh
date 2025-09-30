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

# Install Fisher plugin manager
echo "Installing Fisher plugin manager..."
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

# Install TPM (Tmux Plugin Manager)
echo "Installing TPM (Tmux Plugin Manager)..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM already installed, skipping..."
fi

echo "Linux packages installed successfully"
