#!/bin/bash

# git
ln -sf $(pwd)/git/.gitignore $HOME/.gitignore
ln -sf $(pwd)/git/.gitconfig $HOME/.gitconfig

# tmux
ln -sf $(pwd)/prefs/tmux.conf $HOME/.tmux.conf

# mkdir -p $HOME/.config/fish
# ln -sf $(pwd)/fish/functions "$HOME/.config/fish"
# ln -sf $(pwd)/fish/config.fish "$HOME/.config/fish/config.fish"

# ln -sf $(pwd)/bin $HOME
