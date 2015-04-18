#!/usr/bin/env bash

set -ex

echo $(which python)
echo ${VIM_BINARY}
echo ${VIM_VERSION}
echo ${TRAVIS_PYTHON_VERSION}

EXTRA_OPTIONS=""
if [[ $VIM_VERSION == "NEOVIM" ]]; then
   EXTRA_OPTIONS="--vimrc nvimrc"
   cat nvimrc
fi

   
./test_all.py -v --plugins --interface tmux --session vim --vim $VIM_BINARY $EXTRA_OPTIONS

