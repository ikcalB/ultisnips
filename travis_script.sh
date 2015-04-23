#!/usr/bin/env bash

set -ex

EXTRA_OPTIONS=""
if [[ $VIM_VERSION == "74" ]]; then
   VIM_BINARY="/home/travis/bin/vim"
elif [[ $VIM_VERSION == "NEOVIM" ]]; then
   VIM_BINARY="/usr/bin/nvim"
   EXTRA_OPTIONS="--vimrc nvimrc"
   cat > nvimrc << EOF
let g:python_host_prog="$(which python)"
EOF
fi

tmux new -d -s vim
   
./test_all.py -v --plugins --session vim --vim $VIM_BINARY $EXTRA_OPTIONS
