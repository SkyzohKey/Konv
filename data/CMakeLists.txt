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
