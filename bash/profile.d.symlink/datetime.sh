#!/usr/bin/env bash

alias date="date -u"
alias dt="date +%Y-%m-%d"
alias dtms="date +%Y-%m-%d_%H-%M-%S"

function date-from-epoch() {
  for i in "$@"; do
    date -d "@$i"
  done
}


