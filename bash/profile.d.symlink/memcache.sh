#!/usr/bin/env zsh

memcache-key-dump() {
  host=${1:-localhost}
  echo 'stats items'  | nc $host 11211  | grep -oe ':[0-9]*:' | grep -o \\d\\+ | sort | uniq | xargs -L1 -I{} bash -c "echo 'stats cachedump {} 1000' | nc $host 11211"
}


