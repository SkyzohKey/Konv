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

# Build the config file.
configure_file(
  Config.vala.in
  ${CMAKE_CURRENT_BINARY_DIR}/Config.vala
)

# Compile resources.
include (GResources)
glib_compile_resources (GLIB_RESOURCES_KONV
  SOURCE
    ../data/konv.gresource.xml
)

vala_precompile (VALA_C ${EXEC_NAME}
  # List the sources files that needs to be compiled.
  ${CMAKE_CURRENT_BINARY_DIR}/Config.vala

  #pthread/pthread.h
  core/ToxSession.vala

  Konv.vala
  gui/components/HeaderBar.vala
  gui/components/SettingsListBox.vala
  gui/components/TabContainer.vala
  gui/components/TabNavbar.vala
  gui/widgets/BaseView.vala
  gui/widgets/WelcomeView.vala
  gui/windows/MainWindow.vala
  gui/windows/SettingsWindow.vala

  # List the package that we need.
  PACKAGES
    gtk+-3.0
    json-glib-1.0
    libtoxcore
    #libsoup-2.4

  # Valac options
  OPTIONS
    --vapidir="${CMAKE_SOURCE_DIR}/src/vapis"
    --target-glib="2.38"
    --gresources=${CMAKE_SOURCE_DIR}/data/konv.gresource.xml
    --disable-warnings # Remove this in development.
)

# Tell CMake to build the executable.
add_executable (${EXEC_NAME} ${VALA_C} ${GLIB_RESOURCES_KONV})

# Link.
target_link_libraries (${EXEC_NAME} ${DEPS_LIBRARIES})

# Install the executable in the proper location.
install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)
