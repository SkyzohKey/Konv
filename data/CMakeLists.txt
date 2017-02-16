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

include (Translations)

# Configure .desktop
configure_file(
  im.konv.client.desktop.in.in
  ${CMAKE_CURRENT_BINARY_DIR}/im.konv.client.desktop.in
)

# Configure appdata.
configure_file(
  konv.appdata.xml.in.in
  ${CMAKE_CURRENT_BINARY_DIR}/konv.appdata.xml.in
)

# Translate .desktop
configure_file_translation(
  ${CMAKE_CURRENT_BINARY_DIR}/im.konv.client.desktop.in
  ${CMAKE_CURRENT_BINARY_DIR}/im.konv.client.desktop
  ${CMAKE_SOURCE_DIR}/po/
)

# Translate appdata.
configure_file_translation(
  ${CMAKE_CURRENT_BINARY_DIR}/konv.appdata.xml.in
  ${CMAKE_CURRENT_BINARY_DIR}/konv.appdata.xml
  ${CMAKE_SOURCE_DIR}/po/
)

# Install files.
install (FILES ${CMAKE_CURRENT_BINARY_DIR}/im.konv.client.desktop DESTINATION share/applications)
install (FILES ${CMAKE_CURRENT_BINARY_DIR}/konv.appdata.xml DESTINATION share/appdata)
