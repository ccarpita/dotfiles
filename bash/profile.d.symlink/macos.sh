
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

export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`
