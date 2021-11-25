
ffmpeg-mp4-to-gif() {
  mp4="$1"
  scale_width="${2:-480}"
  ffmpeg -i "$mp4" -vf \
    "fps=10,scale=$scale_width:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -loop 0 \
    "$mp4.gif"
}
