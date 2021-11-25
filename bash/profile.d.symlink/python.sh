pip-install-with-trace() {
  time python -m trace -c -f pip-install.trace $(pyenv which pip) install "$@"
}
