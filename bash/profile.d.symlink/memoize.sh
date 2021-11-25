#!/usr/bin/env zsh

ttl-file () {
  local ttl="$1"
  local file="$2"
  [[ -f "$file" ]] || return 1
  [[ -n "$NOCACHE" ]] && return 1
  [[ "$ttl" == "0" ]] && return 0
  local mtime
  mtime=$(stat -f %m "$file" 2>/dev/null)
  [[ -n "$mtime" ]] || return 2
  local epoch
  epoch=$(date +%s)
  ((epoch - mtime <= ttl)) && return 0
  return 3
}

memoize-ttl() {
  local ttl="$1"
  local name="$2"
  local cmd="$3"
  mkdir -p "$HOME/.memoized"
  local fname="$HOME/.memoized/$name"
  if ! ttl-file "$ttl" "$fname"; then
    echo "evaluating $cmd" >&2
    eval "$cmd" > "${fname}.tmp" && mv "${fname}.tmp" "${fname}"
  fi
  [[ -f "$fname" ]] && cat "$fname"
}
