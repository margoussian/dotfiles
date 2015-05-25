#!/usr/bin/env sh

touch ~/.hushlogin

ln -s .dotfiles/.bash_profile ~/.bash_profile
ln -s .dotfiles/.bashrc ~/.bashrc
ln -s .dotfiles/.gitconfig ~/.gitconfig
ln -s .dotfiles/.editorconfig ~/.editorconfig
ln -s .dotfiles/.inputrc ~/.inputrc
