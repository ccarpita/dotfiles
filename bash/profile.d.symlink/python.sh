pip-install-with-trace() {
  time python -m trace -c -f pip-install.trace $(pyenv which pip) install "$@"
}

pybuild-openssl() {
  if [[ -d "$HOME/lib/openssl-1.1-static" ]]; then
    echo "$HOME/lib/openssl-1.1-static"
  elif [[ "$(uname)" == "Darwin" ]]; then
    echo "$(brew --prefix openssl@1.1)"
  else
    echo "/usr/local/lib"
  fi
}

pybuild-static() {
./configure --disable-shared --enable-optimizations --prefix "$(pwd)/dist" --with-openssl="$(pybuild-openssl)"
  # LDFLAGS="-static" CFLAGS="-static" CPPFLAGS="-static"
}
