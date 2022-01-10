#!/usr/bin/env bash

export USE_CCACHE=1
export CCACHE_CPP2=1
export CCACHE_COMPRESS=1

DERIVED_DATA="$HOME/Library/Developer/Xcode/DerivedData"

export DYLD_LIBRARY_PATH="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib"
if [[ "$(uname -s)" == "Darwin" ]] && [[ -z "$SDKROOT" ]]; then
  export SDKROOT=$(xcrun -show-sdk-path)
fi

function cmake-build () {
  local buildtype="${1:-Ninja}"
  local dir="${2:-build}"
  shift
  shift
  if [ -n "$BUILD_DIR" ]; then
    dir="$BUILD_DIR"
  fi
  if [ -n "$CMAKE_BUILD_CLEAN" ]; then
    rm -rf "$dir"
  fi
  mkdir -p "$dir"
  (
    set -e
    set -x
    cd "$dir"
    cmake .. -G "$buildtype" -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE:-Debug}" "$@"
  )
}

alias print-clang-stdlib="echo | clang -std=c++11 -stdlib=libc++ -v -E -x c++ -"

alias symbolicatecrash=/Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/symbolicatecrash

function cmake-xcode () {
  cmake-build Xcode build-xcode "$@"
}
alias cmx=cmake-xcode
function cmx-offline () {
  cmake-xcode -DOPTION_OFFLINE=1 "$@"
}
function cmx-clean () {
  CMAKE_BUILD_CLEAN=1 cmake-xcode "$@"
}

alias cmxb='cmx && cd build && time xcodebuild -jobs 5 -target ads'

function cmake-ninja () {
  cmake-build Ninja build -DUSE_ADDRESS_SANITIZER="${USE_ADDRESS_SANITIZER:-Off}" -DBUILD_ORBIT=On -DBUILD_TESTING=On "$@"
}

function cmake-ninja-asan () {
  USE_ADDRESS_SANITIZER=On cmake-ninja "$@"
}
function cmake-ninja-coverage () {
  CMAKE_BUILD_TYPE=Coverage cmake-ninja "$@"
}

function cmn() {
  cmake-ninja "$@"
}
function cmn-coverage() {
  CMAKE_BUILD_TYPE=Coverage cmake-ninja "$@"
}
function cmn-clean() {
  CMAKE_BUILD_CLEAN=1 cmake-ninja "$@"
}

xcodebuild-default() {
  time xcodebuild -jobs 4 "$@"
}

xcodebuild-workspace-target() {
  xcodebuild-default -workspace "$1" -target "$2"
}

xcodebuild-target() {
  xcodebuild-default -target "$1"
}

cmake-xcode-refresh() {
  cmake .. -G Xcode
}
alias cmxrefresh=cmake-xcode-refresh

cmake-xcode-cpp11-refresh() {
  cmake .. -G Xcode -DUSE_C++11=ON
}

xcode-clear-derived-data() {
  if ! [ -d "$DERIVED_DATA" ]; then
    echo "Derived Data not found: $DERIVED_DATA"
    return
  fi
  echo "Clearing DerivedData at $DERIVED_DATA ($(du -sh "$DERIVED_DATA" | cut -f1))"
  prompt "Press <ENTER> to continue..."
  rm -rf "$DERIVED_DATA"
}

xcode-xcresults() {
  fd xcresult "$DERIVED_DATA"
}
