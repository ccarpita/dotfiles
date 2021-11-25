#!/usr/bin/env bash

session() {
  local name="$1"
  local wd="$2"
  if [[ -z "$wd" ]]; then
    if [[ -d "$HOME/dev/$name" ]]; then
      wd="$HOME/dev/$name"
    else
      wd="."
    fi
  fi
  if cd "$wd"; then
    tmux attach -t "$name" || tmux new -s "$name" "$SHELL"
  fi
}

if [ $ITERM_SESSION_ID ]; then
  precmd() {
    dev_dir=${PWD:gs/\/Users\/ccarpita\/dev\///}
    dev_dir=${dev_dir%%/*}
    git_info=$(git_prompt_branch)
    if [[ -n "$git_info" ]]; then
      git_info=" ($git_info)"
    fi
    echo -ne "\033];${dev_dir}${git_info}\007"
  }
fi
