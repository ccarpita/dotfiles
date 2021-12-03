#!/usr/bin/env zsh

# This script defines the zsh PROMPT variable, but is safe to include in bash shells

# magic: http://www.dotfiles.org/~_why/.zshrc
set_title() {
  a=${(V)1//\%/\%\%}
  a=$(print -Pn "%40>...>$a" | tr -d "\n")
  case $TERM in
  screen)
    print -Pn "\ek$a:$3\e\\"
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$2\a"
    ;;
  esac
}

git_prompt_branch() {
  # get shortcode (bail if not found)
  local shortcode=$(git rev-parse --short HEAD 2>/dev/null)
  [[ "$shortcode" == "" ]] && return

  # get and test branch name
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  # render unpushed / unpulled arrows
  if [[ "$branch" != "" ]]; then
    local remote_branch=$(git rev-parse --abbrev-ref @'{u}' 2>/dev/null)
    if [[ "$remote_branch" != "" ]]; then
      local arrows=""
      (( $(command git rev-list --right-only --count HEAD...@'{u}' 2>/dev/null) > 0 )) && arrows='⇣'
      (( $(command git rev-list --left-only --count HEAD...@'{u}' 2>/dev/null) > 0 )) && arrows+='⇡'
      [[ "$arrows" != "" ]] && arrows=" ${arrows}"
    fi
  else
    branch="@$shortcode"
  fi
  echo "$branch"
}

git_prompt_info() {
  branch=$(git_prompt_branch)
  if [[ -z "$branch" ]]; then
    return
  fi
  # TODO: slowwwwwwwwww
  # # dirty check + associated color
  # command test -n "$(git status --porcelain 2>/dev/null | tail -n 1)" &>/dev/null
  # (($? == 0)) && git_color=red || git_color=green
  git_color="magenta"

  # output git info
  echo " %F{$git_color}${branch}%f%F{magenta}${arrows}%f"
}

virtualenv_info() {
  [[ -z "$VIRTUAL_ENV" ]] && return
  VENV="$VIRTUAL_ENV"
  if [[ -n "$WORKON_HOME" ]]; then
      VENV="${VENV/$WORKON_HOME\//env:}"
  fi
  echo "$VENV" | sed -e "s/.*\/envs\///" 2>/dev/null
}


ps1_git_branch() {
  branch="$(git_prompt_branch)"
  if [ -n "$branch" ]; then
    echo -e " [🌈 $branch]"
  fi
  echo ""
}

ps1_venv() {
  info="$(pyenv version-name 2>/dev/null ||:)"
  if [[ -n "$info" ]]; then
    echo -e " [🐍 $info]"
  fi
  echo ""
}

ps1_user_host() {
  ps1_user="$(whoami)"
  if [[ "$ps1_user" == "ccarpita" ]]; then
    ps1_user=""
  fi
  echo "$ps1_user@"
}

ps1_prompt() {
  ext=""
  red=$(tput setaf 1)
  green=$(tput setaf 2)
  yellow=$(tput setaf 3)
  blue=$(tput setaf 4)
  magenta=$(tput setaf 5)
  cyan=$(tput setaf 6)
  reset=$(tput sgr0)
  for item in "$@"; do
    if [[ "$item" == "--ext" ]]; then
      ext=" \[$green\][💻 \$(uname -m)]\[$reset\]\[$green\]\$(ps1_venv)\[$reset\]\[$yellow\]\$(ps1_git_branch)\[$reset\]"
    fi
  done
  echo -e "\[$green\]\$(ps1_user_host)\[$reset\]:\[$blue\]\w\[$reset\]$ext\n❯ "
}

# path + git info + cursor (red if last command failed, otherwise yellow)
prompt_on() {
  export PROMPT=$'\n%F{blue}%~%f$(virtualenv_info)$(git_prompt_info)\n%(?.%F{yellow}.%F{red})❯%f '
  export PS1="$(ps1_prompt --ext)"
}

prompt_off() {
  export PROMPT=$'\n%F{blue}%~%f\n%(?.%F{yellow}.%F{red})❯%f '
  export PS1="$(ps1_prompt)"
}

prompt_on
