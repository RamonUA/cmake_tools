MACRO(PRINTBASICINFO PROJ_NAME)
# Test printing
MESSAGE(" ")
MESSAGE(STATUS "--- Project: ${PROJ_NAME} information ------------------------------------------")
MESSAGE(STATUS "--------------------------------------------------------------------------------")
MESSAGE(STATUS "*** Include directories:")
  # Include DIRECTORIES
  GET_PROPERTY(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
  FOREACH(dir ${dirs})
    MESSAGE(STATUS " * '${dir}'")
  ENDFOREACH()

MESSAGE(STATUS "--------------------------------------------------------------------------------")
MESSAGE(STATUS "*** Link directories:")
  # Link DIRECTORIES
  GET_PROPERTY(targetdirlinks DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY LINK_DIRECTORIES)
  FOREACH(linkdir ${targetdirlinks})
    MESSAGE(STATUS " * '${linkdir}'")
  ENDFOREACH()

MESSAGE(STATUS "--------------------------------------------------------------------------------")
MESSAGE(STATUS "*** Link libraries:")
  # Linking against
  GET_TARGET_PROPERTY(libtargets ${PROJ_NAME} LINK_LIBRARIES)
  FOREACH(libtarget ${libtargets})
    MESSAGE(STATUS " * '${libtarget}'")
  ENDFOREACH()
  
MESSAGE(STATUS "--------------------------------------------------------------------------------")
MESSAGE(" ")
ENDMACRO()