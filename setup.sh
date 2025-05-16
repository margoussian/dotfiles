#!/usr/bin/env bash
ROOT="$(pwd)"

set -e

main() {

  stow .

  if [[ $(uname -s) == "Darwin" ]]; then
    "$ROOT/install-macos-fonts.sh"
    "$ROOT/config-macos.sh"
    "$ROOT/install-macos-dev-apps.sh"
    "$ROOT/install-macos-desktop-apps.sh"
  elif [[ $(uname -s) == "Linux" ]]; then
    "$ROOT/install-linux.sh"
  fi
}

main

echo All Done!
echo Restarting shell
exec "$(which $SHELL)" -l
