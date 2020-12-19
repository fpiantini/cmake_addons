# *********************************************************************************
# addgtestsupport.cmake: Add googletest support to a CMake Project
# -----
# By F. Piantini - 20201114
#
# Credits:
#   - Craig Scott: https://crascit.com/2015/07/25/cmake-gtest/
#
# *********************************************************************************

# -------------- Download and unpack googletest at configure time ------------
set(gtestDir "${CMAKE_BINARY_DIR}/googletest-download")

# --- Prepare CMakeLists.txt for googletest ---------------------------------------
configure_file(${CMAKE_CURRENT_LIST_DIR}/googletest.CMakeLists.txt.in ${gtestDir}/CMakeLists.txt)
# info on configure_file()
# - from https://cmake.org/cmake/help/latest/command/configure_file.html (20201114)
#
# Copy a file to another location and modify its contents.
#
# configure_file(<input> <output>
#               [COPYONLY] [ESCAPE_QUOTES] [@ONLY]
#               [NO_SOURCE_PERMISSIONS]
#               [NEWLINE_STYLE [UNIX|DOS|WIN32|LF|CRLF] ])
#
# Copies an <input> file to an <output> file and substitutes variable values
# referenced as @VAR@ or ${VAR} in the input file content. Each variable
# reference will be replaced with the current value of the variable,
# or the empty string if the variable is not defined. [...]
#
# With the configure_file() line above, the CMakeLists.txt.in is copied
# in <build_dir>/googletest-download/CMakeLists.txt doing substitution
# ---------------------------------------------------------------------------------

# --- Build the googletest target -------------------------------------------------
# This is done done immediatly at the invocation of the cmake command to prepare
# the project. The execute_process instructions force CMake to immediately fully
# process the googletest CMakeLists.txt file we generate with the configure_file
# command rather than waiting until build time.

# Specify the build system generator used by subsequent build commands
# using the CMAKE_GENERATOR environment variable
execute_process(COMMAND "${CMAKE_COMMAND}" -G "${CMAKE_GENERATOR}" .
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/googletest-download"
)

# Build the google test target with the cmake --build command
execute_process(COMMAND "${CMAKE_COMMAND}" --build .
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/googletest-download"
)
# ---------------------------------------------------------------------------------

# --- Optional: Visual Studio optimization ----------------------------------------
# Prevent GoogleTest from overriding our compiler/linker options when building
# with Visual Studio.
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
# ---------------------------------------------------------------------------------

# --- Add googletest directly to build --------------------------------------------
# This adds the following targets: gtest, gtest_main, gmock and gmock_main
add_subdirectory("${CMAKE_BINARY_DIR}/googletest-src"
                 "${CMAKE_BINARY_DIR}/googletest-build"
)
# ---------------------------------------------------------------------------------

# --- Add header search path dependencies -----------------------------------------
# The gtest/gmock targets carry these paths automatically when using CMake 2.8.11
# or later. Otherwise we have to add them here ourselves.
if(CMAKE_VERSION VERSION_LESS 2.8.11)
    include_directories("${gtest_SOURCE_DIR}/include"
                        "${gmock_SOURCE_DIR}/include"
    )
endif()
# ---------------------------------------------------------------------------------


