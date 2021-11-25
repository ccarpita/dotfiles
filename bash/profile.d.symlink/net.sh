#!/usr/bin/env bash

export PITANODE="li1746-15.members.linode.com"
alias jump-pitanode="ssh -A \$PITANODE"
alias jump-tidaleffect="ssh tidaleffect.com"

alias simple-http-server="python -mSimpleHTTPServer"

urlencode() {
  python -c "import urllib; print urllib.quote('''$1''')"
}

alias vnc-start="tightvncserver -nolisten tcp -localhost -geometry 1024x786 :1"

# Pretty-prints any json file, supports stripping /* multiline comments */
json-pretty() {
  local file="${1:-/dev/stdin}"
  node -e 'var fs=require("fs");console.log(JSON.stringify(JSON.parse(fs.readFileSync(process.argv[1], {"encoding": "utf8"}).replace(/\/\*[\s\S]*?\*\//gm, "")), null, 2));' "$file"
}

git-to-epub () {
  local author="${1:Unknown}"
  local title=""
  if [[ -z "$2" ]]; then
    title=$(git remote -v | head -n 1 | cut -f1 -d' ' | grep -o '[a-z\-\.]\+\.git' | sed 's/\.git//')
    if [[ -z "$title" ]]; then
      title=Unknown
    fi
  fi
  local i=0
  {
    echo "---"
    echo "title: $title"
    echo "author: $author"
    echo "language: en-US"
    echo "..."
  } > ~/.pandoc.txt
  local files
  declare -a files
  if [[ -f "README.md" ]] ; then
    files+=(README.md)
  fi
  pandoc -S -o "$title.epub" ~/.pandoc.txt "${files[@]}"
}

p12-to-pem() {
  # Decrypt a P12 key into a PEM file
  local p12file="$1"
  local pass="${2:-notasecret}"
  local pemfile="${3:-$p12file.pem}"
  echo "performing openssl pkcs12 on $p12file -> $pemfile"
  openssl pkcs12 -in "$p12file" -passin "pass:$pass" -nodes -out "$pemfile"
}

my-ip() {
  curl -s ifconfig.me
}

host-cert-info() {
  local host="$1"
  local port="${2:-443}"
  echo | openssl s_client \
    -showcerts \
    -servername "$host" \
    -connect "$host:$port" \
    2>/dev/null \
    | openssl x509 -inform pem -noout -text
}
