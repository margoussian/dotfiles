#### Install Xcode Command Line Tools

```bash
xcode-select --install
```

#### Install Homebrew (http://brew.sh)

```bash
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
```

#### Install Homebrew formulae

```bash
brew bundle ~/.dotfiles/homebrew/Brewfile
```

#### Install native apps with `brew cask`

```bash
brew bundle ~/.dotfiles/homebrew/Caskfile
```

#### Sensible OS X defaults and Sublime Configs

When setting up a new Mac, you may want to set some sensible OS X defaults:

```bash
./.dotfiles/.osx
```
