# Common Dotfiles

![A bunny falls over at a desk](http://clk.pw/bunny)

## Installation

```bash
export DOTFILES="$HOME/.dotfiles"
git clone git@github.com:ccarpita/dotfiles "$DOTFILES"
source "$DOTFILES/script/bootstrap"
```

## Components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.

## Thanks

This was forked without shame from an internal repo, itself forked from https://github.com/holman/dotfiles.git


