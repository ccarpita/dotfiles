#!/usr/bin/env bash

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
alias rg="rg --hidden -g '!.git'"
alias fd="fd -HI"

if [[ $is_osx -eq 1 ]]; then
    alias ls="ls -G"
else
    alias ls="ls --color=auto"
fi
alias cd="cd -P"
alias cdl="cd -L"
alias ll='ls -lF'
alias lsd='ls --color=none -d */'
alias lss="ls -l -S -r -h"
alias diffonly='diff --suppress-common-lines'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -lrt'
alias lth="ls -lt | head"
alias ..="cd .."
alias ~="cd ~"

alias pwd="pwd -P"

alias less-mru='less $(ls -rt | tail -n 1)'


lessz() {
  local file=shift
  gunzip -c "$file" | less "$@"
}

function find-name-matching () {
  local matchtype="$1"
  shift
  local i=0
  local cmd="find ."
  for arg in "$@"; do
    local or=""
    if (( i > 0 )); then
      or='-or'
    fi
    local matchstr=""
    if [[ "$matchtype" == "begin" ]]; then
      matchstr="$arg*"
    elif [[ "$matchtype" == "end" ]]; then
      matchstr="*$arg"
    elif [[ "$matchtype" == "any" ]]; then
      matchstr="*$arg*"
    elif [[ "$matchtype" == "exact" ]]; then
      matchstr="$arg"
    else
      echo "usage: find-name-matching <begin|end|any|exact> <word1> [<word2> ...]" >&2
      return 1
    fi
    cmd="$cmd $or $FIND_NAME_ARGS -name '$matchstr'"
    i=$((i+1))
  done
  eval "$cmd"
}
alias find-name-any="find-name-matching any"
alias find-name-begin="find-name-matching begin"
alias find-name-end="find-name-matching end"
alias find-name-exact="find-name-matching exact"
alias fn="find-name-any"

function cat-files-like() {
  for file in $(fn "$@"); do
    if [[ -f "$file" ]]; then
      echo ">>> $file"
      cat "$file"
    fi
  done
}

vimfzf() {
  local search="$1"
  local result
  result=$(fzf --query "$search")
  if [ "$result" != "" ]; then
    vim "$result"
  fi
}
alias vf=vimfzf

vimprofile() {
  vim ~/.vimrc
}

function find-replace () {
  local find="$1"
  local repl="$2"
  if [ -z "$repl" ]; then
    echo "usage: find-replace <find> <replace>" >&2
    return 1
  fi
  find . -type f -exec sed -i "s/$find/$repl/g" \{\} \;
}

alias find-trailing-spaces="rg ' +$' -C 2 -G '\.(c|h|cpp|py|js|json)$'"

