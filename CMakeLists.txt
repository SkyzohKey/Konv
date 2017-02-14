##
# Copyright (c) 2017 SkyzohKey <skyzohkey@konv.im>
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##

# Project name.
project (konv C)

# CMake Minimum version allowed.
cmake_minimum_required (VERSION 2.6)

# Tell CMake where it can find modules.
list (APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
list (APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/src")

# Let's define some useful vars.
set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDIR "${DATADIR}/${PROJECT_NAME}")
set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")
SET (GETTEXT_PATH "${CMAKE_INSTALL_PREFIX}/${COMMON_DATA_DIR}/locale")

set (EXEC_NAME "${PROJECT_NAME}")
set (APP_NAME "Konv")
set (DESKTOP_ICON "tox")
set (RELEASE_NAME "Secure P2P instant messenger")
set (VERSION "0.1.0")
set (VERSION_INFO "looneypig")

add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")

# Load PkgConfig.
find_package (PkgConfig)

# Check for the package Konv needs to compile/run.
pkg_check_modules (DEPS REQUIRED
  gtk+-3.0
  json-glib-1.0
  #libtoxcore
  #libtoxav
  #libsoup-2.4
)

add_definitions (${DEPS_CFLAGS})
link_libraries (${DEPS_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS})

# Make sure we have Valac before.
find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.30" MINIMUM)
include (ValaPrecompile)

add_subdirectory ("data")
add_subdirectory ("po")
add_subdirectory ("src")

# Install the .desktop file.
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/${PROJECT_NAME}.desktop DESTINATION ${DATADIR}/applications/)
