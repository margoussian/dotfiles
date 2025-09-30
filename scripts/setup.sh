#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

set -e

main() {

  cd "$ROOT"

  if [[ $(uname -s) == "Darwin" ]]; then
    "$ROOT/scripts/install-macos.sh"
    "$ROOT/scripts/config-macos.sh"
  elif [[ $(uname -s) == "Linux" ]]; then
    "$ROOT/scripts/install-linux.sh"
  fi

  stow .
}

main

echo All Done!
echo Restarting shell
exec "$(which $SHELL)" -l
