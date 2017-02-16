#!/bin/bash

function install_deps {
  sudo add-apt-repository -y ppa:vala-team/ppa
  sudo apt-get update
  sudo apt-get install -y build-essential vala-0.30 valac libgtk-3-dev libjson-glib-dev libsoup2.4-dev
}

function build {
  mkdir build/
  cd build/
  cmake .. -DCMAKE_INSTALL_PREFIX=/usr
  make
}

if [[ "$1" == "--deps" ]]; then
  install_deps
elif [[ "$1" == "--build" ]]; then
  build
fi
