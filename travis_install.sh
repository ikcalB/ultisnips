#!/usr/bin/env bash

# Installs a known version of vim in the travis test runner.
set -ex

PYTHON_EXECUTABLE=$(which python)

build_vanilla_vim () {
   local URL=$1; shift;

   mkdir vim_build
   pushd vim_build

   curl $URL -o vim.tar.bz2
   tar xjf vim.tar.bz2
   cd vim${VIM_VERSION}

   local PYTHON_BUILD_CONFIG=""
   if [[ $TRAVIS_PYTHON_VERSION =~ "2." ]]; then
      PYTHON_BUILD_CONFIG="--enable-pythoninterp"
   else
      PYTHON_BUILD_CONFIG="--enable-python3interp"
   fi
   ./configure \
      --prefix=${HOME} \
      --disable-nls \
      --disable-sysmouse \
      --disable-gpm \
      --enable-gui=no \
      --enable-multibyte \
      --with-features=huge \
      --with-tlib=ncurses \
      --without-x \
      ${PYTHON_BUILD_CONFIG}

   make install
   popd

   rm -rf vim_build

   VIM_BINARY="/home/travis/bin/vim"
}

# Clone the dependent plugins we want to use.
./test_all.py --clone-plugins

if [[ $VIM_VERSION == "74" ]]; then
   build_vanilla_vim ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
elif [[ $VIM_VERSION == "NEOVIM" ]]; then
   VIM_BINARY="/usr/bin/nvim"

   cat > nvimrc << EOF
let g:python_host_prog="$PYTHON_EXECUTABLE"
EOF

else
   echo "Unknown VIM_VERSION: $VIM_VERSION"
   exit 1
fi

export VIM_BINARY

vim --version
