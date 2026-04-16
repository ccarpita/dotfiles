#!/usr/bin/env bash

# Print out debug messages to help in diagnosing performance issues
# with this Bash file
export PROFILE_DEBUG=${PROFILE_DEBUG:-0}

is_osx=0
is_linux=0
if [[ "$(uname)" == "Darwin" ]]; then
  is_osx=1
elif [[ "$(uname)" == "Linux" ]]; then
  is_linux=1
fi

is-bash() {
  ps -p $$ -o command | tail -1 | grep -q bash
}

is-zsh() {
  ps -p $$ -o command | tail -1 | grep -q zsh
}

time-ms() {
  if [[ $is_osx -eq 1 ]]; then
    if command -v gdate &>/dev/null; then
      gdate +%s%3N
    else
      date +%s000
    fi
  else
    date +%s%3N
  fi
}

last_ms=
debug() {
  if [[ $PROFILE_DEBUG -ne 1 ]]; then
    return
  fi
  diff_str=""
  diff_ms=0
  total_ms=0
  if [ -z "$last_ms" ]; then
    last_ms=$(time-ms)
    first_ms=$(time-ms)
  else
    current_ms=$(time-ms)
    diff_ms=$(((current_ms - last_ms)))
    total_ms=$(((current_ms - first_ms)))
    last_ms=$current_ms
  fi
  if [[ $PROFILE_DEBUG -eq 1 ]]; then
    diff_str="[${total_ms}ms] [+${diff_ms}ms] "
    echo "$diff_str$@" >&2
  fi
}

debug "Profile Init"

addpath() {
    if [ "$1" = "" ] ; then
        echo "usage: addpath <path> [after]"
    elif ! echo "$PATH" | grep -F -q "$1" ; then
        if [ "$2" = "after" ] ; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi
    fi
}

addprecmd() {
  fn="$1"
  if ! [[ "${precmd_functions[@]}" =~ "$fn" ]]; then
    precmd_functions=("${precmd_functions[@]}" "$fn")
  fi
}

include() {
  debug "Try source: $1"
  if [[ -f "$HOME/.profile.d/$1.sh" ]]; then
    source "$HOME/.profile.d/$1.sh"
  elif [[ -f "$1" ]]; then
    source "$1"
  else
    return
  fi
  debug "Sourced: $1"
}

export DOTFILES=$HOME/.dotfiles
dots() {
  if [[ -d ~/.dotfiles ]]; then
    (
      cd ~/.dotfiles && git pull
    )
  fi
  if [ -d ~/dev/dotfiles-personal ]; then
    (
      cd ~/dev/dotfiles-personal && git pull
    )
  fi
}

prompt() {
  message="$1"
  result=""
  if is-zsh; then
    vared -p "$message: " result
  else
    read -p "$message: " result
  fi
  echo "$result"
}
