#!/usr/bin/env zsh

install_zsh_syntax_highlighting() {
  brew install zsh-syntax-highlighting
  source "${(%):-%x}"
}

zsh_syntax_highlighting=/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
if [[ -f "$zsh_syntax_highlighting" ]]; then
  source "$zsh_syntax_highlighting"
fi

