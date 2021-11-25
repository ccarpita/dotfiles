#!/usr/bin/env bash

ulimit -n 16384

set-launchctl () {
  local env="$1"
  if type launchctl &>/dev/null; then
    eval "launchctl setenv $env \"\$env\"" 2>/dev/null
  fi
}
set-launchctl PATH
set-launchctl ANDROID_HOME
set-launchctl ANDROID_NDK

if command -v reattach-to-user-namespace &>/dev/null; then
  alias open="reattach-to-user-namespace open "
fi

alias wifi-off="networksetup -setairportpower en0 off"
alias wifi-on="networksetup -setairportpower en0 on"
alias wifi-scan="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport scan"
alias wifi-hw="networksetup -listallhardwareports"

alias osx-dock-keep-hidden="defaults write com.apple.dock autohide-delay -float 2; killall Dock"
alias virtualenv="python /usr/local/lib/python2.7/site-packages/virtualenv.py"

function wifi-join () {
  local ssid="$1"
  local pass="$2"
  networksetup -setairportnetwork en0 "$ssid" "$pass"
}

function num-cpus() {
  sysctl -n machdep.cpu.core_count
}

macos-disable-desktop() {
  defaults write com.apple.finder CreateDesktop false
}
