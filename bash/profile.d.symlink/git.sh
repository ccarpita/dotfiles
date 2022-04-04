#!/usr/bin/env bash

alias g="git "
alias gb="git branch"
alias gs="git status"
alias gco="git checkout"
alias gca="git commit --amend"
alias gl="git log --pretty=\"format:%Cgreen%h%Creset : %Cblue[%ae] %cI%Creset %s\""
alias gll="git log --pretty=\"format:%Cgreen%H%Creset : %Cblue[%ae] %cI%Creset %s%n%b\" --name-status"
alias gls="git log --stat"
alias glp="git log -p --decorate --color | less -R"
alias glpn="git log -p --decorate --color --name-only"
alias gsu="git submodule update --init --recursive"
alias gss="git submodule sync --recursive"
alias gd="g diff --color-words --word-diff-regex='[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+'"
alias gdw="gd --color-words --word-diff-regex='[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+'"
alias gdc="g diff --cached"
alias gdwc="gdw --cached"

git-current-branch() {
  git rev-parse --abbrev-ref HEAD
}

git-push() {
  git push --tags origin "$(git-current-branch)"
}

git-is-clean() {
  if git status | grep 'working.*clean' &>/dev/null; then
    return 0
  fi
  return 1
}

git-pull() {
  local current_branch
  current_branch=$(git-current-branch)
  local branch=${current_branch:-develop}
  if git-is-clean; then
    if git remote | grep upstream &>/dev/null; then
      git fetch upstream
      git pull upstream "$branch"
    else
      git pull origin "$branch"
    fi
  else
    echo "working directory not clean!" >&2
    git status
  fi
}

git-pull-request() {
  local messagefile="/tmp/pr-message.$$"
  local args=('--push' '--file' "$messagefile" "--edit" "--draft")
  local tpl="$HOME/.pull-request-message"
  local next_arg=""
  local base_branch="develop"
  for arg in "$@"; do
    case "$next_arg" in
      base_branch)
        base_branch="$arg"
        next_arg=""
        continue
        ;;
    esac
    next_arg=""
    case "$arg" in
      -b|--base)
        next_arg=base_branch
        ;;
    esac
  done
  git fetch
  git log --pretty=format:%B --right-only "origin/$base_branch"... > "$messagefile"
  if [[ -f "$tpl" ]]; then
    cat "$tpl" >> "$messagefile"
  fi
  GITHUB_TOKEN="$GITHUB_HUB_TOKEN" hub pull-request "${args[@]}" "$@"
}

alias pull=git-pull

rebase() {
  (
    pushd "$(git rev-parse --show-toplevel)" &>/dev/null
    trunk=develop
    [ -f .git/default-branch ] && trunk=$(cat .git/default-branch)
    git fetch origin && git rebase -i origin/"$trunk"
  )
}

recent-branches() {
  local num="${1:-7}"
  git for-each-ref --sort=-committerdate refs/heads/ --format '%(refname)' | cut -d/ -f3-100 | head "-$num"
}

clone() {
  git clone --recursive -j8 "$@"
}

git-remove-local-branch() {
    git config --unset "branch.$1.remote"
    git config --unset "branch.$1.merge"
    git branch -D "$1"
}

branch-changes() {
    git diff --name-only "$(git merge-base "$1" master)..$1"
}

git-clean-all() {
  if [ "$1" == "commit" ]; then
    git clean -dffx
    git submodule foreach git clean -dffx
  else
    git clean -dffxn
    git submodule foreach git clean -dffxn
    echo "Run 'git-clean-all commit' to remove"
  fi
}

git-authors() {
  git ls-tree --name-only -z -r HEAD |xargs -0 -n1 git blame --line-porcelain|grep "^author "|sort|uniq -c|sort -nr
}


git-delete-merged-branches() {
  # shellcheck disable=SC2063
  main_branch="origin/main"
  if git remote -v | grep -qE "ButterflyNetwork"; then
    main_branch="origin/develop"
  fi
  git branch --merged "$main_branch" | grep -v '^\(+\|\*\| *master\| *develop\| *production\)' | xargs -n 1 git branch -d
}

git-last-merge() {
  git show :/^Merge -q --pretty=%t
}

git-rebase-from-last-merge() {
  git rebase -i --autosquash "$(git-last-merge)"
}

git-bump-submodule() {
  local path="$1"
  local wd
  local name
  wd=$(pwd)
  [ -z "$path" ] && return
  name=$(basename "$path")
  git checkout -b "bump-$name" || return
  cd "$path" || return
  local orig
  orig=$(git rev-list HEAD -1)
  git checkout master || return
  pull || return
  local new
  new=$(git rev-list HEAD -1)
  if [ "$new" == "$orig" ]; then
    echo "No changes to submodule: $path"
    cd "$wd" || return
    return
  fi
  git shortlog "${orig}..HEAD" --no-merge > "$wd/.submodule-bump-shortlog"
  cd "$wd" || return
  git add "$path"
  git commit -t '.submodule-bump-shortlog'
}

git-rewrite-email-history() {
  from=$1
  to=$2
  git filter-branch --env-filter "
    if [ \$GIT_AUTHOR_EMAIL == '$from' ]; then
      GIT_AUTHOR_EMAIL=$to;
    fi;
    export GIT_AUTHOR_EMAIL
  "
}
