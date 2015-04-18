#!/usr/bin/env bash

set -ex

echo $(which python)
echo ${VIM_VERSION}
echo ${TRAVIS_PYTHON_VERSION}

EXTRA_OPTIONS=""
if [[ $VIM_VERSION == "NEOVIM" ]]; then
   EXTRA_OPTIONS="--vimrc nvimrc"
fi

   
./test_all.py -v --plugins --interface tmux --session vim $EXTRA_OPTIONS

