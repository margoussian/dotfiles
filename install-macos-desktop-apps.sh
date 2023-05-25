#!/usr/bin/env bash
echo Installing desktop apps

set -e

brew install --cask \
    librewolf \
    firefox \
    slack
