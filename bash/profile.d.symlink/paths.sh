#!/usr/bin/env bash

export PATH="/bin"

paths=(
  /sbin
  /usr/bin
  /usr/sbin
  /opt/local/bin
  /opt/local/sbin
  /usr/local/sbin
  /usr/local/bin
  /snap/bin
  /opt/homebrew/opt/rustup
  /opt/homebrew/bin
  $DOTFILES/bin
  $HOME/bin
  $HOME/.local/bin
  $HOME/go/bin
  ./node_modules/.bin
  ./bin
)

for comp in ${paths[@]}; do
  PATH="$comp:$PATH"
done
alias path-reset="source ~/.profile.d/paths.sh"
