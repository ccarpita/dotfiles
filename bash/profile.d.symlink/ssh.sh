#!/usr/bin/env bash

SSH_ENV="$HOME/.ssh/environment"

ssh-init() {
  if [[ "$SHELL" =~ "zsh" ]]; then
    ssh-agent zsh
  else
    eval $(ssh-agent)
  fi
  for key in $(ls ~/.ssh/id* | grep -v \.pub); do
    ssh-add "$key"
  done
}

start_agent() {
  echo "Initialising new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
ssh-agent-check() {
  if [ -f "${SSH_ENV}" ]; then
      . "${SSH_ENV}" > /dev/null
      {
        pid=$(pgrep ssh-agent)
        if [ -z "$pid" ]; then
            start_agent;
        fi
      } &
      disown
  else
      start_agent;
  fi
}

setup-remote-ssh-key() {
  host="$1"
  (
    set -x
    scp ~/.ssh/id_rsa.pub $host:
    ssh $host "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && rm id_rsa.pub"
  )
}

dns-refresh-macos() {
  sudo killall -HUP mDNSResponder
}

known-hosts() {
  cut -f1 -d, ~/.ssh/known_hosts | cut -f1 -d ' ' | sort
}

open-vnc() {
  for host in "$@"; do
    open vnc://$host
  done
}

open-screenshare() {
  open-vnc "$@"
}

complete-command open-vnc known-hosts
complete-command open-screenshare known-hosts
