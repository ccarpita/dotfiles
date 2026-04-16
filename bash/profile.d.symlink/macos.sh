
codesign-identities() {
  security find-identity -v -p codesigning
}

screen-sharing() {
    open '/System/Library/CoreServices/Applications/Screen Sharing.app'
}

spotlight-index-reset() {
    sudo mdutil -i on /
    sudo mdutil -E /
}

ICLOUD_HOME="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

icloud-evict() {
  find "$ICLOUD_HOME" -type f -exec brctl evict {} \;
}

