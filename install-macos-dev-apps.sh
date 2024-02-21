#!/usr/bin/env bash
echo "Intalling MacOS Dev Apps"

set -e

brewover() {
    if brew ls --versions "$1"; then
        brew upgrade "$1";
    else
        brew install "$1";
    fi
}

if [[ $(xcode-select --version) ]]; then
  echo "Xcode command line tools already installed. Skipping."
else
  echo "Installing Xcode commandline tools"
  $(xcode-select --install)
fi

if [[ $(brew --version) ]] ; then
    echo "Homebrew is already installed, attempting to update Homebrew from version $(brew --version)"
    brew update
else
    echo "Attempting to install Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

brew update; brew upgrade --cask; brew cleanup || true

echo "Effective Homebrew version:"
brew --version

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
EOS

brew install --cask imageoptim iterm2 1password aerial qlstephen qlmarkdown quicklook-json quicklook-csv qlimagesize webpquicklook suspicious-package

brew install fish

echo "$(brew --prefix)/bin/fish" | sudo tee -a /etc/shells
sudo -v
sudo chsh -s /usr/local/bin/fish $(whoami)

fish_add_path /opt/homebrew/bin

# fisher for completions. 4.1.0
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

brew install --cask \
    visual-studio-code

ln -sf /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code /usr/local/bin/code

code --install-extension lunaryorn.fish-ide --force

# visual studio code config
ln -sf $(pwd)/prefs/visual-studio-code/settings.json "$HOME/Library/Application Support/Code/User/settings.json"

# only installed when macos, so not in the base template
git config --global core.editor "code -w -n"
git config --global core.pager "diff-so-fancy | less --tabs=1,5 -R"
git config --global pull.rebase true
git config --global rebase.autoStash true

echo '1. Execute this to add ssh key (w/passphrase) to keychain:  ssh-add -K ~/.ssh/id_rsa'
echo '2. Then git config --global user.name "Your Name"'
echo '3. Then git config --global user.email "Your_Email@...com"'
echo '4. Create a git Personal Access token, then:  "hub browse" and enter git user and Access token to configure hub to use that'
echo '5. Configure Slack accounts'
echo '6. Configure 1Password'
echo '7. Install IDEs'
