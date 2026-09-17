#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

set -e

section "Installing macOS packages"

install_xcode_tools() {
    step "Xcode command line tools"
    if xcode-select --version &>/dev/null; then
        skip "Already installed"
    else
        xcode-select --install
        ok "Xcode command line tools installed"
    fi
}

install_homebrew() {
    step "Homebrew"
    if brew --version &>/dev/null; then
        skip "Already installed ($(brew --version | head -1))"
        brew update
    else
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
    brew update
    brew upgrade --cask
    brew cleanup || true

    ok "Homebrew ready ($(brew --version | head -1))"
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
        skip "$cask already installed"
    fi
}

install_dev_tools() {
    step "Development tools"

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
    install_cask_if_absent "zed" "/Applications/Zed.app"
    install_cask_if_absent "1password" "/Applications/1Password.app"
    install_cask_if_absent "qlmarkdown" "/Applications/QLMarkdown.app"
    install_cask_if_absent "suspicious-package" "/Applications/Suspicious Package.app"
    install_cask_if_absent "quicklook-csv" "$HOME/Library/QuickLook/QuickLookCSV.qlgenerator"
    install_cask_if_absent "obsidian" "/Applications/Obsidian.app"

    ok "Development tools installed"
}

install_desktop_apps() {
    step "Desktop apps"

    install_cask_if_absent "firefox" "/Applications/Firefox.app"

    ok "Desktop apps installed"
}

install_fonts() {
    step "Fonts"
    brew install --cask font-jetbrains-mono-nerd-font
    ok "JetBrains Mono Nerd Font installed"
}

main() {
    install_xcode_tools
    install_homebrew
    install_dev_tools
    install_desktop_apps
    install_fonts

    ok "macOS packages installed successfully"
}

main
