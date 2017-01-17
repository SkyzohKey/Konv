#!/bin/bash

####
## Temporary build.sh script for Konv.
## TODO: Setup an approriate build system (CMake/Autotools/Waf).
####

BASE_PWD=$(pwd)
SOURCE_PWD="$BASE_PWD/src"
echo "Current working directory: $BASE_PWD"
echo "Current sources directory: $SOURCE_PWD"

# Delete old build.
rm -rf build/
mkdir -p build/

# Rebuild the gresources.
cd "$BASE_PWD/data/"
glib-compile-resources konv.gresource.xml --target="$BASE_PWD/build/resources.c" --generate-source
cd ..

# Rebuild.
valac --target-glib=2.38 --vapidir=src/vapis --output build/Konv \
      --debug --thread --pkg gtk+-3.0 --pkg glib-2.0 \
      --gresources=data/konv.gresource.xml \
      $(find $SOURCE_PWD -type f -name "*.vala") build/resources.c && \

# Debug it, if no errors occured.
G_MESSAGES_DEBUG=all GOBJECT_DEBUG=instance-count gdb -ex run ./build/Konv
