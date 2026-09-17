#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/lib.sh"

set -e

section "Setting up shell environment"

setup_fish() {
    step "Fish shell"

    local fish_path
    if [[ $(uname -s) == "Darwin" ]]; then
        fish_path="$(brew --prefix)/bin/fish"
        if ! grep -qF "$fish_path" /etc/shells; then
            echo "$fish_path" | sudo tee -a /etc/shells
        fi
        if [ "$(dscl . -read /Users/$(whoami) UserShell | awk '{print $2}')" != "$fish_path" ]; then
            sudo chsh -s "$fish_path" "$(whoami)"
        fi
    else
        fish_path="$(which fish)"
        if [[ "$SHELL" != *"fish"* ]]; then
            chsh -s "$fish_path" || true
        fi
    fi

    local tide_already_installed=false
    if fish -c "type -q tide" &>/dev/null; then
        tide_already_installed=true
    fi

    if ! fish -c "type -q fisher" &>/dev/null; then
        echo "Installing Fisher and plugins..."
        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install" < "$ROOT/fish/fish_plugins"
    else
        skip "Fisher already installed, updating plugins"
        fish -c "fisher install" < "$ROOT/fish/fish_plugins"
    fi

    if [ "$tide_already_installed" = false ]; then
        echo "Configuring Tide prompt..."
        fish -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Dotted --prompt_connection_andor_frame_color=Darkest --prompt_spacing=Compact --icons='Few icons' --transient=No"
    else
        skip "Tide already configured"
    fi

    ok "Fish shell ready"
}

install_tpm() {
    step "TPM (Tmux Plugin Manager)"
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        ok "TPM installed"
    else
        skip "TPM already installed"
    fi
}

install_claude_code() {
    step "Claude Code"
    if command -v claude &>/dev/null; then
        skip "Already installed ($(claude --version))"
    else
        curl -fsSL https://claude.ai/install.sh | bash
        ok "Claude Code installed"
    fi
}

main() {
    setup_fish
    install_tpm
    install_claude_code

    ok "Shell environment ready"
}

main
