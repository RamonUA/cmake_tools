# ///////////////////////////////////////////////////////// #
# ////////// Macro for finding Apple framework //////////// #
# ///////////////////////////////////////////////////////// #

# Macro to load apple framework´s; Call after ADD_EXECUTABLE or ADD_LIBRARY
MACRO(link_ios_framework)
    	SET(NAME ${ARGV0})
    	SET(PROJ_NAME ${ARGV1})
    		FIND_LIBRARY (FRAMEWORK_${NAME}
                  	NAMES ${NAME}
                  	PATHS ${CMAKE_OSX_SYSROOT}/System/Library
                  	PATH_SUFFIXES Frameworks
                  	NO_DEFAULT_PATH)
    	MARK_AS_ADVANCED(FRAMEWORK_${NAME})
    	IF (${FRAMEWORK_${NAME}} STREQUAL FRAMEWORK_${NAME}-NOTFOUND)
       		MESSAGE (ERROR ": Framework ${NAME} not found")
    	ELSE (${FRAMEWORK_${NAME}} STREQUAL FRAMEWORK_${NAME}-NOTFOUND)
        	TARGET_LINK_LIBRARIES (${PROJ_NAME} ${FRAMEWORK_${NAME}})
        	MESSAGE (STATUS "Framework ${NAME} found at ${FRAMEWORK_${NAME}}")
    	ENDIF (${FRAMEWORK_${NAME}} STREQUAL FRAMEWORK_${NAME}-NOTFOUND)
ENDMACRO(link_ios_framework)

MACRO(link_ios_sdk)
    	SET(NAME ${ARGV0})
    	SET(PROJ_NAME ${ARGV1})
    		FIND_LIBRARY (DYLIB_${NAME}
                  	NAMES ${NAME}
                  	PATHS ${CMAKE_OSX_SYSROOT}/usr/
                  	PATH_SUFFIXES lib
                  	NO_DEFAULT_PATH)
    	MARK_AS_ADVANCED(DYLIB_${NAME})
    	IF (${DYLIB_${NAME}} STREQUAL DYLIB_${NAME}-NOTFOUND)
       		MESSAGE (ERROR ": dylib ${NAME} not found at DYLIB_${NAME} ")
    	ELSE (${DYLIB_${NAME}} STREQUAL DYLIB_${NAME}-NOTFOUND)
        	TARGET_LINK_LIBRARIES (${PROJ_NAME} ${DYLIB_${NAME}})
        	MESSAGE (STATUS "dylib ${NAME} found at ${DYLIB_${NAME}}")
    	ENDIF (${DYLIB_${NAME}} STREQUAL DYLIB_${NAME}-NOTFOUND)
ENDMACRO(link_ios_sdk)