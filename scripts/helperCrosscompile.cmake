# --------------------------------------------------------------
# Indicate CMake 2.7 and above that we don't want to mix relative
#  and absolute paths in linker lib lists.
# Run "cmake --help-policy CMP0003" for more information.
# --------------------------------------------------------------
IF(COMMAND cmake_policy)
  #cmake_policy(SET CMP0003 NEW)
ENDIF()

# 1º Select only one target to compile the code, easier for cross-compiling
# Try to auto detect and set the target parameter
# ------------------------------------------------------------------------------------------------------
SET(TARGET_PLATFORM CACHE STRING "TARGET_NONE")
SET_PROPERTY(CACHE TARGET_PLATFORM PROPERTY STRINGS "TARGET_NONE" "TARGET_ANDROID" "TARGET_WIN32" "TARGET_LINUX" "TARGET_IOS" "TARGET_APPLE")	# List with targets types

MESSAGE("* Autodetecting platform . . .")

IF(NOT CMAKE_TOOLCHAIN_FILE)
  IF(WIN32)
    MESSAGE("     Win32 detected.")
    SET(TARGET_PLATFORM TARGET_WIN32 CACHE STRING "Target Platform" FORCE)
  ELSEIF(APPLE)
    MESSAGE("     APPLE detected.")
    SET(TARGET_PLATFORM TARGET_APPLE CACHE STRING "Target Platform" FORCE)
  ELSE(WIN32)
    MESSAGE("     Linux detected.")
    SET(TARGET_PLATFORM TARGET_LINUX CACHE STRING "Target Platform" FORCE)
  ENDIF(WIN32)
ELSE()
  IF(APPLE)
    MESSAGE("     iOS detected.")
    SET(TARGET_PLATFORM TARGET_IOS CACHE STRING "Target Platform" FORCE)
  ELSE(APPLE)
    MESSAGE("     Android detected.")
    SET(TARGET_PLATFORM TARGET_ANDROID CACHE STRING "Target Platform" FORCE)
  ENDIF(APPLE)
ENDIF()
MESSAGE("")

# 2º Configuration (Release, debug)
# ------------------------------------------------------------------------------------------------------
SET(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configs" FORCE)
IF(DEFINED CMAKE_BUILD_TYPE AND CMAKE_VERSION VERSION_GREATER "2.8")
  SET_PROPERTY(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${CMAKE_CONFIGURATION_TYPES})
ENDIF()

# 3º Configuration type configuration, (Shared, static)
# ------------------------------------------------------------------------------------------------------
SET(${PROJ_MAIN_NAME}_LIB_TYPE "STATIC" CACHE STRING "Type of lib")
SET_PROPERTY(CACHE ${PROJ_MAIN_NAME}_LIB_TYPE PROPERTY STRINGS "SHARED" "STATIC")

# 4º Add these standard paths to the search paths for FIND_LIBRARY
# to find libraries from these locations first
# ------------------------------------------------------------------------------------------------------
 if(UNIX AND NOT ANDROID)
   if(X86_64 OR CMAKE_SIZEOF_VOID_P EQUAL 8)
     if(EXISTS /lib64)
       list(APPEND CMAKE_LIBRARY_PATH /lib64)
     else()
       list(APPEND CMAKE_LIBRARY_PATH /lib)
     endif()
     if(EXISTS /usr/lib64)
       list(APPEND CMAKE_LIBRARY_PATH /usr/lib64)
     else()
       list(APPEND CMAKE_LIBRARY_PATH /usr/lib)
     endif()
   elseif(X86 OR CMAKE_SIZEOF_VOID_P EQUAL 4)
     if(EXISTS /lib32)
       list(APPEND CMAKE_LIBRARY_PATH /lib32)
     else()
       list(APPEND CMAKE_LIBRARY_PATH /lib)
     endif()
     if(EXISTS /usr/lib32)
       list(APPEND CMAKE_LIBRARY_PATH /usr/lib32)
     else()
       list(APPEND CMAKE_LIBRARY_PATH /usr/lib)
     endif()
   endif()
 endif()
 
# 5º Support C++11 crossplatform
# ------------------------------------------------------------------------------------------------------
 macro(CHECK_FOR_CXX11_COMPILER _VAR)
    message(STATUS "Checking for C++11 compiler")
    set(${_VAR})
    if((MSVC AND (MSVC10 OR MSVC11 OR MSVC12)) OR
       (CMAKE_COMPILER_IS_GNUCXX AND NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 4.6) OR
       (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND NOT ${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 3.1))
        message(STATUS "Checking for C++11 compiler - available")
		# Add C++11 support
		SET(${_VAR} TRUE)
    else()
        message(STATUS "Checking for C++11 compiler - unavailable")
		# Add C++11 support
		SET(${_VAR} FALSE)
    endif()
endmacro()

# Sets the appropriate flag to enable C++11 support
macro(ENABLE_CXX11)
    # Compiler-specific C++11 activation.
	IF("${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU")
		SET(CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS} ")
		IF(NOT (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.7 OR 
			CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 4.7 OR 
			DEFINED CMAKE_TOOLCHAIN_FILE))
			MESSAGE("${PROJECT_NAME} requires g++ 4.7 or greater, your version is ${CMAKE_CXX_COMPILER_VERSION}")
		ELSE()
			MESSAGE("${PROJECT_NAME} GNU compiler use C++11")
		ENDIF()
	elseif ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libstdc++")
		find_package(LLVM REQUIRED CONFIG)
		MESSAGE("${PROJECT_NAME} Clang compiler use C++11")
	else ()
		MESSAGE("${PROJECT_NAME} c++11 works")	
	endif ()
endmacro()

macro(ENABLE_SSE)
	IF("${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU")
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -msse2")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -msse2")
	elseif (MSVC)
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /arch:SSE2")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /arch:SSE2")
	endif()	
endmacro()