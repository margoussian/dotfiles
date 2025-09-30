#!/usr/bin/env bash
echo "Installing macOS packages..."

set -e

install_xcode_tools() {
    if [[ $(xcode-select --version) ]]; then
        echo "Xcode command line tools already installed. Skipping."
    else
        echo "Installing Xcode commandline tools"
        xcode-select --install
    fi
}

install_homebrew() {
    if [[ $(brew --version) ]]; then
        echo "Homebrew is already installed, attempting to update from version $(brew --version)"
        brew update
    else
        echo "Attempting to install Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
    brew update
    brew upgrade --cask
    brew cleanup || true

    echo "Effective Homebrew version:"
    brew --version
}

brewover() {
    if brew ls --versions "$1"; then
        brew upgrade "$1"
    else
        brew install "$1"
    fi
}

install_dev_tools() {
    echo "Installing development tools..."

    brewover python || true
    brewover awscli || true
    brewover go || true

    brew bundle --file=- <<-EOS
	tap "homebrew/cask"
	brew "git"
	brew "git-extras"
	brew "ruby"
	brew "jq"
	brew "hub"
	brew "diff-so-fancy"
	brew "eza"
	brew "dust"
	brew "nvm"
	brew "ssh-copy-id"
	brew "m-cli"
	brew "tmux"
	brew "pyenv"
	brew "pyenv-virtualenvwrapper"
	brew "bat"
	brew "ripgrep"
	brew "fzf"
	brew "neovim"
	brew "btop"
	brew "fastfetch"
	brew "gh"
	brew "lazydocker"
	brew "lazygit"
	EOS

    brew install --cask imageoptim ghostty 1password aerial qlstephen qlmarkdown quicklook-json quicklook-csv qlimagesize webpquicklook suspicious-package visual-studio-code

    # Symlink VSCode CLI
    ln -sf /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code /usr/local/bin/code
}

install_desktop_apps() {
    echo "Installing desktop apps..."

    brew install --cask \
        librewolf \
        firefox \
        slack
}

install_fonts() {
    echo "Installing JetBrains Mono font..."

    curl -LO https://download.jetbrains.com/fonts/JetBrainsMono-1.0.0.zip 2>/dev/null
    unzip -o JetBrainsMono-1.0.0.zip -d ~/Library/Fonts/
    rm JetBrainsMono-1.0.0.zip
}

setup_fish() {
    echo "Setting up Fish shell..."

    brew install fish

    echo "$(brew --prefix)/bin/fish" | sudo tee -a /etc/shells
    sudo chsh -s /usr/local/bin/fish $(whoami)

    # Install Fisher plugin manager and all plugins from fish_plugins
    echo "Installing Fisher and Fish plugins..."
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"

    # Configure Tide prompt
    echo "Configuring Tide prompt..."
    fish -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Dotted --prompt_connection_andor_frame_color=Darkest --prompt_spacing=Compact --icons='Few icons' --transient=No"
}

install_tpm() {
    echo "Installing TPM (Tmux Plugin Manager)..."

    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        echo "TPM already installed, skipping..."
    fi
}

main() {
    install_xcode_tools
    install_homebrew
    install_dev_tools
    install_desktop_apps
    install_fonts
    setup_fish
    install_tpm

    echo "macOS packages installed successfully"
}

main
