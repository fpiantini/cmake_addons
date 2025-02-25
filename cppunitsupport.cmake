# *********************************************************************************
# cppunitsupport.cmake: Add CPPUNIT support to a CMake Project
# -----
# By F. Piantini - 20220926
#
# Credits:
#   - Craig Scott: https://crascit.com/2015/07/25/cmake-gtest/
#   - https://github.com/dlaperriere/cmake_cppunit
#
# *********************************************************************************

include(FindCPPUNIT)

# download & build cppunit
if( NOT CPPUNIT_FOUND )

   configure_file( ${CMAKE_MODULE_PATH}/DownloadCPPUNIT.cmake.in ${CMAKE_BINARY_DIR}/cppunit-download/CMakeLists.txt )

   MESSAGE(STATUS "Downloading CppUnit")
   execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
     WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/cppunit-download )

   execute_process(COMMAND ${CMAKE_COMMAND} --build .
     WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/cppunit-download )

   MESSAGE(STATUS "cmake CppUnit for ${CMAKE_GENERATOR}")
   execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
     WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/cppunit-src)

   IF(${CMAKE_GENERATOR} MATCHES "Visual Studio")
     MESSAGE(STATUS "Build debug version of CppUnit")
     execute_process(COMMAND ${CMAKE_COMMAND} --build . --target cppunit --config Debug
       WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/cppunit-src )
   ENDIF(${CMAKE_GENERATOR} MATCHES "Visual Studio")

   MESSAGE(STATUS "Build release version of CppUnit")
   execute_process(COMMAND ${CMAKE_COMMAND} --build . --target cppunit --config Release
     WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/cppunit-src )

   add_subdirectory(${CMAKE_BINARY_DIR}/cppunit-src ${CMAKE_BINARY_DIR}/cppunit-build)

   #include_directories(${CPPUNIT_INCLUDE_DIR})

endif(NOT CPPUNIT_FOUND)

