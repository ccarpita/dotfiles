#!/usr/bin/env bash

path_reset() {
  if [[ -z "$PATH" ]]; then
    PATH="/usr/bin:/bin:/sbin"
  fi

  local os_paths=()
  if [[ "$(uname -s)" == "Darwin" ]]; then
    os_paths+=(/opt/homebrew/opt/rustup /opt/homebrew/bin)
  else
    os_paths+=(/snap/bin)
  fi

  # Entries later in the list take precedence
  local paths=(
    # Relative (can be unsafe, always override)
    ./node_modules/.bin

    # System
    /bin
    /sbin
    /usr/bin
    /usr/sbin
    /opt/local/bin
    /opt/local/sbin
    /usr/local/sbin
    /usr/local/bin

    # OS-specific
    ${os_paths[@]}

    # User
    ${DOTFILES:-$HOME/.dotfiles}/bin
    $HOME/.cargo/bin
    $HOME/.local/bin
    $HOME/go/bin
    $HOME/bin
  )

  local new_path=""
  for comp in ${paths[@]}; do
    new_path="$comp:$new_path"
  done

  PATH="$new_path"
}

path_reset

alias path-reset="path_reset "

