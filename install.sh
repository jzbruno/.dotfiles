#!/usr/bin/env sh

# symlink dotfiles
./link.sh

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install applications
brew bundle --file ./homebrew/Brewfile

# configure os
./macos/Defaultsfile
