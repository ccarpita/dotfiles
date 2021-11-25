#!/usr/bin/env bash



function brew-install () {
  if ! type "$1" &>/dev/null; then
    brew install "${2:-$1}"
  fi
}

if-not-exist-then() {
  if ! type "$1" &>/dev/null; then
    shift
    "$@"
  fi
}

install-ffmpeg() {
  brew install ffmpeg \
    --with-fdk-aac \
    --with-ffplay \
    --with-freetype \
    --with-libass \
    --with-libquvi \
    --with-libvorbis \
    --with-libvpx \
    --with-opus \
    --with-x265
}

install-brew-tools() {
  if ! type brew &>/dev/null; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  brew-install ripgrep
  brew-install jq
  brew-install coreutils
  brew-install avprobe libav
  brew-install imagemagick
  if-not-exist-then ffmpeg install-ffmpeg
}

bootstrap-software() {
  if [ $is_osx -eq 1 ]; then
    install-brew-tools
  fi
}
