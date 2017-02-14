macro(determine_fallback_version CMAKE_VERSION_MODULE_PATH)
    if(EXISTS ${CMAKE_SOURCE_DIR}/.git)
        #
        # Make a version containing the current version from git.
        #

        include(GetGitRevisionDescription)
        git_describe(VERSION_LONG --tags)

        #parse the version information into pieces.
        string(REGEX REPLACE "^v*([0-9]+)\\..*" "\\1" GIT_VERSION_MAJOR "${VERSION_LONG}")
        string(REGEX REPLACE "^v*[0-9]+\\.([0-9]+).*" "\\1" GIT_VERSION_MINOR "${VERSION_LONG}")
        string(REGEX REPLACE "^v*[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" GIT_VERSION_PATCH "${VERSION_LONG}")
        string(REGEX REPLACE "^v*[0-9]+\\.[0-9]+\\.[0-9]+(.*)" "\\1" GIT_VERSION_SHA1 "${VERSION_LONG}")
        set(VERSION_GIT "${GIT_VERSION_MAJOR}.${GIT_VERSION_MINOR}.${GIT_VERSION_PATCH}")
        configure_file(${CMAKE_VERSION_MODULE_PATH}/FallbackVersion.cmake.in ${CMAKE_VERSION_MODULE_PATH}/FallbackVersion.cmake)
    endif()
endmacro()
