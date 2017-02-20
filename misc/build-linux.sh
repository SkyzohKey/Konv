#!/bin/bash

function install_deps {
  sudo add-apt-repository -y ppa:vala-team/ppa
  sudo add-apt-repository -y ppa:rebuntu16/glade-3.19+-trusty
  sudo apt-get update
  sudo apt-get install -y build-essential vala-0.30 valac libgtk-3-dev libjson-glib-dev libsoup2.4-dev

  # Ruby is needed to lint code.
  sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -sSL https://get.rvm.io | bash -s stable
  source ~/.rvm/scripts/rvm
  rvm install 2.4.0
  rvm use 2.4.0 --default
  ruby -v
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
