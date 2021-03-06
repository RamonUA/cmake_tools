IF(TARGET_PLATFORM STREQUAL TARGET_WIN32)

  SET(CMAKE_USE_RELATIVE_PATHS ON CACHE INTERNAL "" FORCE)

ENDIF()

IF(TARGET_PLATFORM STREQUAL TARGET_LINUX)

  SET(CMAKE_USE_RELATIVE_PATHS ON CACHE INTERNAL "" FORCE)
  IF(NOT MSVC)
    SET(CMAKE_CXX_FLAGS_DEBUG          "-O0 -gdwarf-4") # -gdwarf-4
    SET(CMAKE_CXX_FLAGS_MINSIZEREL     "-Os -DNDEBUG")
    SET(CMAKE_CXX_FLAGS_RELEASE        "-O4 -DNDEBUG")
    SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g")
    IF(${PROJ_NAME}_BUILD_PROFILE)
      IF(TARGET_PLATFORM STREQUAL TARGET_LINUX)
	MESSAGE("Profiling active")
	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg")
	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pg")
	SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg")
      ENDIF()
    ENDIF()
  ENDIF()

ENDIF()

IF(TARGET_PLATFORM STREQUAL TARGET_MAC)

ENDIF()

IF(TARGET_PLATFORM STREQUAL TARGET_ANDROID)

  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -fPIC" )
  
  SET(ANDROID_LIB_DEPS GLESv2 log android)
  
  # API ANDROID
  IF(TARGET_PLATFORM STREQUAL TARGET_ANDROID)
    IF(ANDROID_NATIVE_API_LEVEL STREQUAL "8")
      SET(ANDROID_NATIVE_API_LEVEL "9" CACHE STRING "Api min to compile" FORCE)
    ENDIF(ANDROID_NATIVE_API_LEVEL STREQUAL "8")
  ENDIF(TARGET_PLATFORM STREQUAL TARGET_ANDROID)
  #SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -pedantic -Wextra")
  
ENDIF()

IF(TARGET_PLATFORM STREQUAL TARGET_IOS)
	# TODO REVIEW, could overload toolchain info and make fail propertly
	# Add Macros
	#include( IosMacros.cmake )

	SET(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -Wall -O0 -x objective-c++ ") #Obj
	#SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g3") # Debug Info
	SET(CMAKE_CXX_FLAGS "--sysroot ${CMAKE_OSX_SYSROOT} ${CMAKE_CXX_FLAGS}") 
	#SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -arch armv7 armv7s") 
	
	# Architecture
	SET(IOS_ARCH armv7 armv7s)
	SET(CMAKE_OSX_ARCHITECTURES ${IOS_ARCH} CACHE string "Build architecture for iOS")
	
	# Add std to flags. Must be all project same
	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++ ")
	SET(CMAKE_SIZEOF_VOID_P 4)
	SET(IPHONEOS_DEPLOYMENT_TARGET "7.0")
	
	# XCode Attributes
	set(XCODE_ATTRIBUTE_SDKROOT iphoneos)
  	set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++11")
  	set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++")
	set(XCODE_ATTRIBUTE_GCC_UNROLL_LOOPS "YES")
	set(XCODE_ATTRIBUTE_LLVM_VECTORIZE_LOOPS "YES")
	set(XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer")
	set(XCODE_ATTRIBUTE_GCC_PRECOMPILE_PREFIX_HEADER "YES")
	set(MACOSX_BUNDLE_GUI_IDENTIFIER "com.yourcompany.\${PRODUCT_NAME:rfc1034identifier}")
  	add_definitions(-mno-thumb)
  	set(CMAKE_OSX_ARCHITECTURES "$(ARCHS_STANDARD_INCLUDING_64_BIT)")

  #set(CMAKE_OSX_ARCHITECTURES ${ARCHS_STANDARD_32_BIT})
  # armv7 only
  ##set(CMAKE_OSX_ARCHITECTURES ${ARCHS_UNIVERSAL_IPHONE_OS})	
ENDIF()