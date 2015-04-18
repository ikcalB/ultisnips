#!/usr/bin/env bash

set -ex

EXTRA_OPTIONS=""
if [[ $VIM_VERSION == "74" ]]; then
   VIM_BINARY="/home/travis/bin/vim"
elif [[ $VIM_VERSION == "NEOVIM" ]]; then
   VIM_BINARY="/usr/bin/nvim"
   EXTRA_OPTIONS="--vimrc nvimrc"
fi
   
./test_all.py -v --plugins --interface tmux --session vim --vim $VIM_BINARY $EXTRA_OPTIONS
