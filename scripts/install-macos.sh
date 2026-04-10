#!/usr/bin/env bash
echo "Installing macOS packages..."

set -e

install_xcode_tools() {
    if xcode-select --version &>/dev/null; then
        echo "Xcode command line tools already installed. Skipping."
    else
        echo "Installing Xcode command line tools"
        xcode-select --install
    fi
}

install_homebrew() {
    if brew --version &>/dev/null; then
        echo "Homebrew already installed, updating from version $(brew --version)"
        brew update
    else
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
    brew update
    brew upgrade --cask
    brew cleanup || true

    echo "Homebrew version: $(brew --version)"
}

brewover() {
    if brew ls --versions "$1" &>/dev/null; then
        brew upgrade "$1" 2>/dev/null || true
    else
        brew install "$1"
    fi
}

install_cask_if_absent() {
    local cask="$1"
    local app_path="$2"
    if ! [ -e "$app_path" ]; then
        brew install --cask "$cask"
    else
        echo "$cask already installed, skipping."
    fi
}

install_dev_tools() {
    echo "Installing development tools..."

    brewover python || true
    brewover awscli || true
    brewover go || true

    brew bundle --file=- <<-EOS
	brew "git"
	brew "git-extras"
	brew "ruby"
	brew "jq"
	brew "diff-so-fancy"
	brew "eza"
	brew "dust"
	brew "nvm"
	brew "ssh-copy-id"
	brew "m-cli"
	brew "tmux"
	brew "bat"
	brew "ripgrep"
	brew "fzf"
	brew "neovim"
	brew "btop"
	brew "fastfetch"
	brew "gh"
	brew "lazydocker"
	brew "lazygit"
	brew "uv"
	brew "stow"
	brew "fish"
	brew "zoxide"
	EOS

    install_cask_if_absent "imageoptim" "/Applications/ImageOptim.app"
    install_cask_if_absent "ghostty" "/Applications/Ghostty.app"
    install_cask_if_absent "1password" "/Applications/1Password.app"
    install_cask_if_absent "qlmarkdown" "/Applications/QLMarkdown.app"
    install_cask_if_absent "suspicious-package" "/Applications/Suspicious Package.app"
    install_cask_if_absent "quicklook-csv" "$HOME/Library/QuickLook/QuickLookCSV.qlgenerator"
}

install_desktop_apps() {
    echo "Installing desktop apps..."

    install_cask_if_absent "firefox" "/Applications/Firefox.app"
}

install_fonts() {
    echo "Installing JetBrains Mono font..."
    brew install --cask font-jetbrains-mono
}

main() {
    install_xcode_tools
    install_homebrew
    install_dev_tools
    install_desktop_apps
    install_fonts

    echo "macOS packages installed successfully"
}

main
