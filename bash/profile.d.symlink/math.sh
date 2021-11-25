#!/usr/bin/env bash

hex2dec() {
  node -e "console.log(parseInt(\"$1\", 16));"
}
