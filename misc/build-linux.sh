#!/bin/bash

function install_deps {
  sudo add-apt-repository -y ppa:vala-team/ppa
  sudo add-apt-repository -y ppa:rebuntu16/glade-3.19+-trusty
  sudo apt-get update

  # Packages needed for building, linting, etc...
  sudo apt-get install -y build-essential vala-0.30 valac libgtk-3-dev libjson-glib-dev libsoup2.4-dev
  sudo apt-get install -y libtool autotools-dev checkinstall check git yasm
  sudo apt-get install -y libgdbm-dev libncurses5-dev automake libtool bison libffi-dev

  install_ruby
  install_libsodium
  install_libvpx
  install_libopus
  install_libtoxcore
}

function install_ruby {
  # Ruby is needed to lint code.
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -sSL https://get.rvm.io | bash -s stable
  source ~/.rvm/scripts/rvm
  rvm install 2.4.0
  rvm use 2.4.0 --default
  ruby -v
}
function install_libsodium {
  git clone https://github.com/jedisct1/libsodium.git
  cd libsodium
  git checkout tags/1.0.11
  ./autogen.sh
  ./configure && make check
  sudo checkinstall --default --install --pkgname libsodium --pkgversion 1.0.0 --nodoc
  sudo ldconfig
  cd ..
}
function install_libvpx {
  git clone https://chromium.googlesource.com/webm/libvpx
  cd libvpx
  ./configure
  make -j3
  sudo make install
  cd ..
}
function install_libopus {
  wget http://downloads.xiph.org/releases/opus/opus-1.0.3.tar.gz
  tar xvzf opus-1.0.3.tar.gz
  cd opus-1.0.3
  ./configure
  make -j3
  sudo make install
  cd ..
}
function install_libtoxcore {
  git clone https://github.com/TokTok/c-toxcore.git c-toxcore
  cd c-toxcore
  autoreconf -i
  ./configure
  make
  sudo make install
}

function build {
  mkdir -p build/
  cd build/
  cmake .. -DCMAKE_INSTALL_PREFIX=/usr
  make
}

function install {
  cd build/
  sudo make install
}

if [[ "$1" == "--deps" ]]; then
  install_deps
elif [[ "$1" == "--build" ]]; then
  build
elif [[ "$1" == "--install" ]]; then
  install
fi
