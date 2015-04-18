#!/usr/bin/env bash

# Installs a known version of vim in the travis test runner.
set -ex

VIM_VERSION=$1; shift
PYTHON_VERSION=$1; shift

repeat_transiently_failing_command () {
   COMMAND=$1; shift

   set +e
   until ${COMMAND}; do
      sleep 10
   done
   set -e
}

build_vanilla_vim () {
   URL=$1; shift;

   mkdir vim_build
   pushd vim_build

   curl $URL -o vim.tar.bz2
   tar xjf vim.tar.bz2
   cd vim${VIM_VERSION}

   PYTHON_BUILD_CONFIG=""
   if [[ $PYTHON_VERSION =~ "Python 2." ]]; then
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

   # Dirty hack, since PATH seems to be ignored.
   ln -sf /home/travis/bin/vim /usr/bin/vim
}

build_neovim () {
   SHA=$1; shift

   git clone https://github.com/neovim/neovim.git vim_build
   pushd vim_build

   git checkout $SHA
   repeat_transiently_failing_command "make CMAKE_EXTRA_FLAGS=\"-DCMAKE_INSTALL_PREFIX:PATH=$HOME/neovim\" install"

   popd 
   rm -rf vim_build

   # Dirty hack, since PATH seems to be ignored.
   ln -sf /home/travis/neovim/bin/nvim /usr/bin/vim
}

# Clone the dependent plugins we want to use.
./test_all.py --clone-plugins

# Install tmux (> 1.8) and vim. 
repeat_transiently_failing_command "add-apt-repository ppa:kalakris/tmux -y"
repeat_transiently_failing_command "apt-get update -qq"
repeat_transiently_failing_command "apt-get install -qq -y tmux xclip gdb"

if [[ $VIM_VERSION == "74" ]]; then
   build_vanilla_vim ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
elif [[ $VIM_VERSION == "NEOVIM" ]]; then
   build_neovim a88e2f4fd4c3e10aabd41e758cc845332be013da
else
   echo "Unknown VIM_VERSION: $VIM_VERSION"
   exit 1
fi

vim --version
