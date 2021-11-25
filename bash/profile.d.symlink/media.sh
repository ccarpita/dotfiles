#!/usr/bin/env bash

alias unpack-srpm='rpm2cpio *srpm | cpio -idmv --no-absolute-filenames'
alias ripcd='cdda2wav -D 0,4,0 -B /tmp/'

calibre-debug () {
  mkdir -p ~/log/calibre
  /Applications/calibre.app/Contents/calibre-debug.app/Contents/MacOS/calibre -g &>"log/calibre/$(dtms).log"
}
alias ebook-convert='/Applications/calibre.app/Contents/MacOS/ebook-convert'


convert-to-gif() {
  local file="$1"
  if [[ -z "$file" ]]; then
    echo "usage: convert-to-gif <file> [<output>]" >&2
    return 1
  fi
  local fgif="${file}.gif"
  local output="${2:-$fgif}"
  ffmpeg -i "$file" -s 800:600 -pix_fmt rgb24 -r 16 -f gif - | gifsicle --optimize=3 --delay=3 > "$output"
}

convert-to-gif-using-palette() {
  local file="$1"
  if [[ -z "$file" ]]; then
    echo "usage: convert-to-gif-using-palette <file> [<output>]" >&2
    return 1
  fi
  local fgif="${file}.gif"
  local output="${2:-$fgif}"

  local palette="/tmp/palette.png"
  local filters="fps=15,scale=640:-1:flags=lanczos"

  ffmpeg -i "$file" -vf "$filters,palettegen" -y $palette
  ffmpeg -i "$file" -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y "$output"
}
