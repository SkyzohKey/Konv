macro(add_glib_marshal outsources outincludes name prefix)
  find_package(GLibTools REQUIRED)
  add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
    COMMAND ${GLIB-GENMARSHAL_EXECUTABLE} --header "--prefix=${prefix}"
            "${CMAKE_CURRENT_SOURCE_DIR}/${name}.list"
            > "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
    DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${name}.list"
  )
  add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${name}.c"
    COMMAND ${GLIB-GENMARSHAL_EXECUTABLE} --body "--prefix=${prefix}"
            "${CMAKE_CURRENT_SOURCE_DIR}/${name}.list"
            > "${CMAKE_CURRENT_BINARY_DIR}/${name}.c"
    DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${name}.list"
            "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
  )
  list(APPEND ${outsources} "${CMAKE_CURRENT_BINARY_DIR}/${name}.c")
  list(APPEND ${outincludes} "${CMAKE_CURRENT_BINARY_DIR}/${name}.h")
endmacro(add_glib_marshal)

macro(add_glib_enumtypes outsources outheaders name)
    set(files ${ARGN})
	add_custom_command(
	  OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
	  COMMAND ${GLIB-MKENUMS_EXECUTABLE} ARGS --template ${name}".h.template"
          ${files}
		  > "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
	  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	  DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${name}.h.template"
		${files}
	)
	add_custom_command(
		OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${name}.c"
		COMMAND ${GLIB-MKENUMS_EXECUTABLE} ARGS --template ${name}".c.template"
                ${files}
			> "${CMAKE_CURRENT_BINARY_DIR}/${name}.c"
		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${name}.c.template"
			${files}
	)
	list(APPEND ${outsources} "${CMAKE_CURRENT_BINARY_DIR}/${name}.c")
	list(APPEND ${outheaders} "${CMAKE_CURRENT_BINARY_DIR}/${name}.h")
endmacro(add_glib_enumtypes)

