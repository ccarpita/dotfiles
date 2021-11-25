# Haskell stuff, using stack environments to provide local
# package contexts
_ghci() {
  # Use local stack environment if available
  if [[ -f stack.yaml ]]; then
    stack ghci --verbosity silent
    return 0
  fi

  # Use standard dev environment
  if [[ ! -d ~/dev/haskell ]]; then
    mkdir -p ~/dev/haskell
    (
      cd ~/dev/haskell || exit
      stack new simple
      stack init
    )
  fi
  (
    cd ~/dev/haskell || exit
    stack ghci --verbosity silent
  )
  return 0
}

if type stack &>/dev/null; then
  alias ghc='stack ghc --verbosity silent -- '
  alias ghci='_ghci '
fi

