# FindOpenCASCADE.cmake

# input vars:
# Environment variable CASROOT will be the default root for OpenCASCADE
# > CASROOT would be the ROOT of the OpenCASCADE installation. 'inc' directory should be in CASROOT
# > CASLIB would be the directory pointing to the optimized libraries
# > CASLIB_DEBUG would be the directory pointing to the debug libraries

# The following vars will be defined
# > OpenCASCADE_FOUND if OCC has been found
# > OpenCASCADE_INCLUDE_DIR to the include directories
# > OpenCASCADE_LIBS with the list of optimized OpenCASCADE libraries (including the paths)
# > OpenCASCADE_LIBS_DEBUG with the list of debug OpenCASCADE libraries (including the paths)
# > OpenCASCADE_[toolkitname] i.e OpenCASCADE_TKernel points to a specific COMPONENT

# {OpenCASCADE_FOUND} is cached, this block should execute only once
if( NOT OpenCASCADE_FOUND STREQUAL TRUE )

	message( STATUS "------ FindOpenCASCADE -------")
	message( STATUS "-- Starting to look for OpenCASCADE")

	################### Get sys platform and compiler ###################

	if (WIN32 OR CYGWIN)
		if(${CMAKE_SIZEOF_VOID_P} MATCHES "8") #The system is 64bits, otherwise matches 4
			set(OCC_SYS_NAME win64)
		else(${CMAKE_SIZEOF_VOID_P} MATCHES "8")
			set(OCC_SYS_NAME win32)
		endif(${CMAKE_SIZEOF_VOID_P} MATCHES "8")
		if(MSVC)
			if(CMAKE_CL_64) #Check system name to match to the desired compilation
				set(OCC_SYS_NAME win64)
			endif(CMAKE_CL_64)
			if(MSVC12)
				set(OCC_COMPILER_NAME "vc12")
			elseif(MSVC11)
				set(OCC_COMPILER_NAME "vc11")
			elseif(MSVC10)
				set(OCC_COMPILER_NAME "vc10")
			elseif(MSVC90)
				set(OCC_COMPILER_NAME "vc9")
			else(MSVC12)
				message(FATAL_ERROR "Unsupported Windows Compiler!")
			endif(MSVC12)
		endif(MSVC)
	else(WIN32 OR CYGWIN)
		#Platforrm in APPLE and LINUX
		if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin") #Apple
			if(${CMAKE_SIZEOF_VOID_P} MATCHES "8")
				set(OCC_SYS_NAME mac64)
			else(${CMAKE_SIZEOF_VOID_P} MATCHES "8")
				set(OCC_SYS_NAME mac32)
			endif(${CMAKE_SIZEOF_VOID_P} MATCHES "8")
			set(OCC_SYS_NAME mac64)
		elseif(${CMAKE_SYSTEM_NAME} MATCHES "Linux") #Linux
			if(${CMAKE_SIZEOF_VOID_P} MATCHES "8")
				set(OCC_SYS_NAME lin64)
			else(${CMAKE_SIZEOF_VOID_P} MATCHES "8")
				set(OCC_SYS_NAME lin32)
			endif(${CMAKE_SIZEOF_VOID_P} MATCHES "8")
		else(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
			set(OCC_SYS_NAME ${CMAKE_SYSTEM_NAME})
		endif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
		#Compiler name
		if (${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang")
			set(OCC_COMPILER_NAME clang)
		elseif (${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
			set(OCC_COMPILER_NAME gcc)
		elseif (${CMAKE_CXX_COMPILER_ID} STREQUAL "Intel")
			set(OCC_COMPILER_NAME intel)
		endif(${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang")
	endif(WIN32 OR CYGWIN)

	message( STATUS "-- Detected platform: " ${OCC_SYS_NAME} " compiler: " ${OCC_COMPILER_NAME})

	################ Find in the paths where OpenCascade should be installed #############

	if(WIN32)
		if(CYGWIN OR MINGW)
	    	find_path(OpenCASCADE_INCLUDE_DIR Standard_Version.hxx
	    		PATHS ENV CASROOT PATH_SUFFIXES inc include
		        /usr/include/opencascade
		        /usr/local/include/opencascade
		        /opt/opencascade/include
		        /opt/opencascade/inc
	      	)
			find_library(OpenCASCADE_TKernel TKernel 
				HINTS ENV CASROOT ENV CASLIB PATH_SUFFIXES lib ${OCC_SYS_NAME}/lib
				/usr/lib
				/usr/local/lib
				/opt/opencascade/lib
			)
			find_library(OpenCASCADE_debug_TKernel TKernel
				HINTS ENV CASROOT ENV CASLIB_DEBUG PATH_SUFFIXES libd ${OCC_SYS_NAME}/libd
				/usr/libd
				/usr/local/libd
				/opt/opencascade/libd
				NO_CMAKE_SYSTEM_PATH
			)
	    else(CYGWIN OR MINGW)
	      find_path(OpenCASCADE_INCLUDE_DIR Standard_Version.hxx
	      	PATHS ENV CASROOT PATH_SUFFIXES inc include
	        "[HKEY_LOCAL_MACHINE\\SOFTWARE\\SIM\\OCC\\2;Installation Path]/include"
	      )
	      find_library(OpenCASCADE_TKernel TKernel
	      	HINTS ENV CASROOT ENV CASLIB PATH_SUFFIXES lib ${OCC_SYS_NAME}/lib ${OCC_SYS_NAME}/${OCC_COMPILER_NAME}/lib
	        "[HKEY_LOCAL_MACHINE\\SOFTWARE\\SIM\\OCC\\2;Installation Path]/lib"
	      )
	      find_library(OpenCASCADE_debug_TKernel TKernel
	      	HINTS ENV CASROOT ENV CASLIB_DEBUG PATH_SUFFIXES libd ${OCC_SYS_NAME}/libd ${OCC_SYS_NAME}/${OCC_COMPILER_NAME}/libd
	        "[HKEY_LOCAL_MACHINE\\SOFTWARE\\SIM\\OCC\\2;Installation Path]/libd"
	        NO_CMAKE_SYSTEM_PATH
	      )
	    endif(CYGWIN OR MINGW)
	else(WIN32)
	    find_path(OpenCASCADE_INCLUDE_DIR Standard_Version.hxx
	    	PATHS ENV CASROOT PATH_SUFFIXES inc include
			/usr/include/opencascade
			/usr/local/include/opencascade
			/opt/opencascade/include
			/opt/opencascade/inc
	    )
	    find_library(OpenCASCADE_TKernel TKernel
	    	HINTS ENV CASROOT ENV CASLIB PATH_SUFFIXES lib ${OCC_SYS_NAME}/lib ${OCC_SYS_NAME}/${OCC_COMPILER_NAME}/lib
			/usr/lib
			/usr/local/lib
			/opt/opencascade/lib
	    )
	    find_library(OpenCASCADE_debug_TKernel TKernel
	    	HINTS ENV CASROOT ENV CASLIB_DEBUG PATH_SUFFIXES libd ${OCC_SYS_NAME}/libd ${OCC_SYS_NAME}/${OCC_COMPILER_NAME}/libd
			/usr/libd
			/usr/local/libd
			/opt/opencascade/libd
			NO_CMAKE_SYSTEM_PATH
	    )
	endif(WIN32)

	#If library found define OpenCASCADE_LIBRARY_DIR and OpenCASCADE_LIBRARY_DEBUG
	if(NOT OpenCASCADE_TKernel STREQUAL OpenCASCADE_TKernel-NOTFOUND )
	    get_filename_component( OpenCASCADE_LIBRARY_DIR ${OpenCASCADE_TKernel} PATH CACHE)
	endif(NOT OpenCASCADE_TKernel STREQUAL OpenCASCADE_TKernel-NOTFOUND)
	if(NOT OpenCASCADE_debug_TKernel STREQUAL OpenCASCADE_debug_TKernel-NOTFOUND)
		get_filename_component( OpenCASCADE_LIBRARY_DIR_DEBUG ${OpenCASCADE_debug_TKernel} PATH CACHE)
	endif(NOT OpenCASCADE_debug_TKernel STREQUAL OpenCASCADE_debug_TKernel-NOTFOUND)

	if(NOT OpenCASCADE_INCLUDE_DIR STREQUAL OpenCASCADE_INCLUDE_DIR-NOTFOUND)
		if(DEFINED OpenCASCADE_LIBRARY_DIR OR DEFINED OpenCASCADE_LIBRARY_DIR_DEBUG)
			set(OpenCASCADE_FOUND TRUE)
		else(DEFINED OpenCASCADE_LIBRARY_DIR OR DEFINED OpenCASCADE_LIBRARY_DIR_DEBUG)
			set(OpenCASCADE_FOUND FALSE CACHE INTERNAL "OpenCASCADE Libraries Found?" FORCE )
		endif(DEFINED OpenCASCADE_LIBRARY_DIR OR DEFINED OpenCASCADE_LIBRARY_DIR_DEBUG)
	endif(NOT OpenCASCADE_INCLUDE_DIR STREQUAL OpenCASCADE_INCLUDE_DIR-NOTFOUND)

	############ OpenCASCADE Community edition ##################

	if(NOT OpenCASCADE_FOUND STREQUAL TRUE)
		message(STATUS "-- OpenCASCADE not found! Looking for OpenCASCADE Community Edition")
		if(NOT DEFINED OCE_DIR)
			# Check for OSX needs to come first because UNIX evaluates to true on OSX
			if( ${CMAKE_SYSTEM_NAME} MATCHES "Darwin" )
				set(OCE_HINTS "/usr/local/opt/oce/")
			elseif( ${CMAKE_SYSTEM_NAME} MATCHES UNIX)
				set(OCE_HINTS "/usr/local/share/cmake/")
			elseif( ${CMAKE_SYSTEM_NAME} MATCHES WIN32)
				file(GLOB "[cC]:/OCE*/share/cmake" OCE_DIRS)
				if(OCE_DIRS)
					list(GET 0 OCE_HINTS)
				endif(OCE_DIRS)
			endif( ${CMAKE_SYSTEM_NAME} MATCHES "Darwin" )
		endif(NOT DEFINED OCE_DIR)

		find_package(OCE HINTS ${OCE_HINTS} QUIET)
		if(OCE_FOUND)
			set(OpenCASCADE_INCLUDE_DIR ${OCE_INCLUDE_DIRS} CACHE PATH "OpenCASCADE includes" FORCE)
			set(OpenCASCADE_FOUND TRUE)
			message(STATUS "-- OpenCASCADE Community Edition found!")
		else(OCE_FOUND)
			message(STATUS "-- OpenCASCADE Community Edition not found!!")
		endif(OCE_FOUND)
	endif(NOT OpenCASCADE_FOUND STREQUAL TRUE)

	############# Show the OpenCASCADE version detectected #############

	if( OpenCASCADE_FOUND STREQUAL TRUE )
		# Obtain OpenCASCADE version
		if(NOT OpenCASCADE_INCLUDE_DIR STREQUAL OpenCASCADE_INCLUDE_DIR-NOTFOUND )
			file(STRINGS ${OpenCASCADE_INCLUDE_DIR}/Standard_Version.hxx OCC_MAJOR
				REGEX "#define OCC_VERSION_MAJOR.*"
			)
			string(REGEX MATCH "[0-9]+" OCC_MAJOR ${OCC_MAJOR})
			file(STRINGS ${OpenCASCADE_INCLUDE_DIR}/Standard_Version.hxx OCC_MINOR
				REGEX "#define OCC_VERSION_MINOR.*"
			)
			string(REGEX MATCH "[0-9]+" OCC_MINOR ${OCC_MINOR})
			file(STRINGS ${OpenCASCADE_INCLUDE_DIR}/Standard_Version.hxx OCC_MAINT
				REGEX "#define OCC_VERSION_MAINTENANCE.*"
			)
			string(REGEX MATCH "[0-9]+" OCC_MAINT ${OCC_MAINT})

			set(OpenCASCADE_VERSION_STRING "${OCC_MAJOR}.${OCC_MINOR}.${OCC_MAINT}")
		endif(NOT OpenCASCADE_INCLUDE_DIR STREQUAL OpenCASCADE_INCLUDE_DIR-NOTFOUND)
		message(STATUS "-- Found OpenCASCADE/OCE version: " ${OpenCASCADE_VERSION_STRING})
		message(STATUS "-- OpenCASCADE/OCE include directory: " ${OpenCASCADE_INCLUDE_DIR})
		message(STATUS "-- OpenCASCADE/OCE shared libraries directory: " ${OpenCASCADE_LIBRARY_DIR})
	else( OpenCASCADE_FOUND STREQUAL TRUE )
		message(FATAL_ERROR "-- OpenCASCADE not found!! Note: Try to set OpenCASCADE root directory on CMAKE_PREFIX_PATH or set CASROOT environment variable!!")
	endif( OpenCASCADE_FOUND STREQUAL TRUE )
	message(STATUS "------------------------------")
endif( NOT OpenCASCADE_FOUND STREQUAL TRUE )

# This block will execute every time FindOpenCASCADE is called
if (OpenCASCADE_FOUND STREQUAL TRUE)
	if( DEFINED OpenCASCADE_FIND_COMPONENTS )
		if(NOT OCE_FOUND)
			#Optimized libraries
			if(DEFINED OpenCASCADE_LIBRARY_DIR)
				foreach( _libname ${OpenCASCADE_FIND_COMPONENTS} )
					find_library( OpenCASCADE_${_libname} ${_libname} ${OpenCASCADE_LIBRARY_DIR} NO_DEFAULT_PATH)
					set( _foundLib ${OpenCASCADE_${_libname}} )
					if( _foundLib STREQUAL OpenCASCADE_${libname}-NOTFOUND )
						message( FATAL_ERROR "Cannot find ${_libname} in ${OpenCASCADE_LIBRARY_DIR}!!")
					endif( _foundLib STREQUAL OpenCASCADE_${libname}-NOTFOUND )
					set( OpenCASCADE_LIBS ${OpenCASCADE_LIBS} ${_foundLib})
					mark_as_advanced(${_foundLib})
				endforeach( _libname ${OpenCASCADE_FIND_COMPONENTS} )
			endif(DEFINED OpenCASCADE_LIBRARY_DIR)

			#Debug libraries
			if(DEFINED OpenCASCADE_LIBRARY_DIR_DEBUG)
				foreach( _libname ${OpenCASCADE_FIND_COMPONENTS} )
					find_library( OpenCASCADE_debug_${_libname} ${_libname} ${OpenCASCADE_LIBRARY_DIR_DEBUG} NO_DEFAULT_PATH)
					set( _foundLib ${OpenCASCADE_debug_${_libname}} )
					if( _foundLib STREQUAL OpenCASCADE_debug_${libname}-NOTFOUND )
						message( FATAL_ERROR "Cannot find ${_libname} in ${OpenCASCADE_LIBRARY_DIR_DEBUG}!!")
					endif( _foundLib STREQUAL OpenCASCADE_debug_${libname}-NOTFOUND )
					set( OpenCASCADE_LIBS_DEBUG ${OpenCASCADE_LIBS_DEBUG} ${_foundLib})
					mark_as_advanced(${_foundLib})
				endforeach( _libname ${OpenCASCADE_FIND_COMPONENTS} )
			endif(DEFINED OpenCASCADE_LIBRARY_DIR_DEBUG)
		else(NOT OCE_FOUND)
			find_package(OCE HINTS ${OCE_HINTS} COMPONENTS ${OpenCASCADE_FIND_COMPONENTS})
			set( OpenCASCADE_LIBS ${OpenCASCADE_LIBS} ${OpenCASCADE_FIND_COMPONENTS} )
			list(REMOVE_DUPLICATES OpenCASCADE_LIBS)
		endif(NOT OCE_FOUND)

		#OS definitions
		if(UNIX)
			add_definitions( -DLIN -DLININTEL )
		endif(UNIX)
		#Definitions for 64 bits
		if( NOT CMAKE_SIZEOF_VOID_P EQUAL 4 )
			add_definitions( -D_OCC64 )
			if(UNIX)
				add_definitions( -m64 )
			endif(UNIX)
		endif( NOT CMAKE_SIZEOF_VOID_P EQUAL 4 )
		#Environment definitions
		if(CYGWIN)
			add_definitions(-DOCC_CONVERT_SIGNALS)
		elseif(MSVC)
			add_definitions(-DWNT)
		endif(CYGWIN)

		find_path(OpenCASCADE_CONFIG_H "config.h" PATHS ${OpenCASCADE_INCLUDE_DIR} NO_DEFAULT_PATH)
		if(NOT OpenCASCADE_CONFIG_H)
			add_definitions(-DHAVE_NO_OCC_CONFIG_H)
		else(NOT OpenCASCADE_CONFIG_H)	
			add_definitions( -DHAVE_CONFIG_H -DHAVE_IOSTREAM -DHAVE_FSTREAM -DHAVE_LIMITS_H -DHAVE_IOMANIP )
		endif(NOT OpenCASCADE_CONFIG_H)

	else( DEFINED OpenCASCADE_FIND_COMPONENTS )
		message( AUTHOR_WARNING "Developer must specify required libraries to link against in the cmake file, i.e. find_package( OpenCASCADE REQUIRED COMPONENTS TKernel TKBRep) . Otherwise no libs will be added - linking against ALL OCC libraries is slow!")
	endif( DEFINED OpenCASCADE_FIND_COMPONENTS )
endif( OpenCASCADE_FOUND STREQUAL TRUE )
