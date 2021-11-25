#!/usr/bin/env bash

if [[ $is_osx -eq 1 ]]; then
    alias psa="ps aux"
else
    alias psa="ps -ww -A -F"
fi
alias psp="ps -ww -F -p"
alias psg="psa | grep "
alias ps-top-cpu="ps aux | sort -nr -k 3 | head -10"
alias ps-top-mem="ps aux | sort -nr -k 4 | head -10"


