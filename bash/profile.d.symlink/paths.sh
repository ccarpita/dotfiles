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
  /opt/android-sdk/platform-tools
  $DOTFILES/bin
  ./node_modules/.bin
  ./bin
  $HOME/.cargo/bin
  $HOME/.pyenv/bin
  $HOME/.pyenv/shims

)


if [[ $is_linux -eq 1 ]] && [[ "$(uname -i)" == "x86_64" ]]; then
  paths+=($HOME/.dotfiles/bin-linux-x86_64)
elif [[ $is_osx -eq 1 ]]; then
  paths+=(/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin)
fi

for comp in ${paths[@]}; do
  PATH="$comp:$PATH"
done
alias path-reset="source ~/.profile.d/paths.sh"
