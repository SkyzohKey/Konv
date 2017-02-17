#!/bin/bash

function install_deps {
  sudo add-apt-repository -y ppa:vala-team/ppa
  sudo add-apt-repository -y ppa:rebuntu16/glade-3.19+-trusty
  sudo apt-get update
  sudo apt-get install -y build-essential vala-0.30 valac libgtk-3-dev libjson-glib-dev libsoup2.4-dev
}

function build {
  mkdir -p build/
  cd build/
  cmake .. -DCMAKE_INSTALL_PREFIX=/usr
  make
}

function install {
  sudo make install
}

if [[ "$1" == "--deps" ]]; then
  install_deps
elif [[ "$1" == "--build" ]]; then
  build
elif [[ "$1" == "--install" ]]; then
  install
fi
