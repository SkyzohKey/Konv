# Build the config file.
configure_file(
  Config.vala.in
  ${CMAKE_CURRENT_BINARY_DIR}/Config.vala
)

# Compile resources.
include (GResource)
GLIB_COMPILE_RESOURCES (GLIB_RESOURCES_KONV
  SOURCE
    ../data/konv.gresource.xml
)

vala_precompile (VALA_C ${EXEC_NAME}
  # List the sources files that needs to be compiled.
  ${CMAKE_CURRENT_BINARY_DIR}/Config.vala
  Konv.vala
  gui/components/HeaderBar.vala
  gui/components/TabContainer.vala
  gui/components/TabNavbar.vala
  gui/windows/MainWindow.vala

  # List the package that we need.
  PACKAGES
    gtk+-3.0
    json-glib-1.0
    #libtoxcore
    #libtoxav
    #libsoup-2.4

  # Valac options
  OPTIONS
    --vapidir="${CMAKE_SOURCE_DIR}/vapis"
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
