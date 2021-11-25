#!/usr/bin/env bash

if [[ -n "$BASH_VERSION" ]]; then
  function complete-command() {
    if ! type -p "complete" &>/dev/null; then
      return
    fi
    local cmd="$1"
    local comp="$2"
    local ifs="${3:-\$'\\n'}"
    local compgen_opt="${4:--W}"
    shift
    shift
    eval "
  __complete_${cmd} () {
    local cur=\"\${COMP_WORDS[\$COMP_CWORD]}\"
    local oldifs=\"\$IFS\"
    IFS=$ifs
    COMPREPLY=( \$( compgen $compgen_opt \"\$($comp)\" -- \$cur ) )
    IFS=\"\$oldifs\"
    return 0
  }
  complete -F __complete_${cmd} \"$cmd\"
  "
  }
else
  complete-command() {
    echo "Cannot complete: non-bash"
  }
  if [[ "$SHELL" =~ zsh ]]; then
    zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    fpath=(~/.zsh $fpath)
    autoload -Uz compinit && compinit
  fi
fi


