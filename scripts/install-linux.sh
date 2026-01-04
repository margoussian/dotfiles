#!/usr/bin/env bash
echo "Installing Linux packages..."

set -e

# Install essential packages
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

# Set fish as default shell
if [[ "$SHELL" != *"fish"* ]]; then
    echo "Setting fish as default shell..."
    chsh -s $(which fish) || true
fi

# Copy fish_plugins FIRST so Fisher can read it
# (We can't stow yet because the fish directory structure conflicts)
echo "Copying fish_plugins for Fisher..."
mkdir -p ~/.config/fish
cd "$(dirname "$0")/.."
cp fish/fish_plugins ~/.config/fish/fish_plugins

# Install Fisher plugin manager and all plugins from fish_plugins
echo "Installing Fisher and Fish plugins..."
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"

# Configure Tide prompt
echo "Configuring Tide prompt..."
fish -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Dotted --prompt_connection_andor_frame_color=Darkest --prompt_spacing=Compact --icons='Few icons' --transient=No"

# Install TPM (Tmux Plugin Manager)
echo "Installing TPM (Tmux Plugin Manager)..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM already installed, skipping..."
fi

echo "Linux packages installed successfully"
