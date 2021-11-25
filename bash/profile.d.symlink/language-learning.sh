#!/usr/bin/env bash

alias trans-swedish='trans -s sv '
alias say-swedish='say -vAlva '
say-multi-swede () {
  say -v Alva "$1"
  say -v Klara "$1"
  say -v Oskar "$1"
}

super-swede () {
  {
    say-multi-swede "$1" &>/dev/null
  } &
  disown
  trans-swedish "$1"
}
