cmake_minimum_required(VERSION 3.6)

set(PROJECT_NAME npl-demo)

project(${PROJECT_NAME})

if(CMAKE_HOST_WIN32)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /DEBUG /utf-8 /EHsc /MDd")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /DEBUG /utf-8 /Zi /EHsc /MD")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /DEBUG")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /DEBUG")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /DEBUG /OPT:REF /OPT:ICF")
set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DEBUG /OPT:REF /OPT:ICF")

if(CMAKE_CL_64)
	set(Npl_TARGET X64)
else()
	set(Npl_TARGET X86)
endif()

add_definitions(-DUNICODE -D_UNICODE)

# set configuration types
if(CMAKE_CONFIGURATION_TYPES) # multiconfig generator?
    set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE) 
else()
    if(NOT CMAKE_BUILD_TYPE)
        message("Defaulting to release build.")
        set(CMAKE_BUILD_TYPE Release CACHE STRING "" FORCE)
    endif()
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY HELPSTRING "Choose the type of build")
    # set the valid options for cmake-gui drop-down list
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug;Release")
endif()

file(GLOB ${PROJECT_NAME}_HEADER_FILES *.h)
file(GLOB ${PROJECT_NAME}_SOURCE_FILES *.cpp)
file(GLOB ${PROJECT_NAME}_IMGUI_FILES imgui/*)

source_group("Header Files" FILES ${${PROJECT_NAME}_HEADER_FILES})
source_group("Source Files" FILES ${${PROJECT_NAME}_SOURCE_FILES})
source_group("Imgui Files"  FILES ${${PROJECT_NAME}_IMGUI_FILES})

link_directories("$ENV{DXSDK_DIR}/Lib/$(PlatformTarget)")

set(NPL_SDK "../" CACHE PATH "")
get_filename_component(NPL_SDK_ABSOLUTE ${NPL_SDK} ABSOLUTE)

add_library(npl-base SHARED IMPORTED) # or STATIC instead of SHARED
set_target_properties(npl-base PROPERTIES
    IMPORTED_LOCATION "${NPL_SDK_ABSOLUTE}/bin/${Npl_TARGET}/npl-base.dll"
    IMPORTED_IMPLIB "${NPL_SDK_ABSOLUTE}/lib/${Npl_TARGET}/npl-base.lib"
)

add_library(npl-sdk SHARED IMPORTED) # or STATIC instead of SHARED
set_target_properties(npl-sdk PROPERTIES
    IMPORTED_LOCATION "${NPL_SDK_ABSOLUTE}/bin/${Npl_TARGET}/npl-sdk.dll"
    IMPORTED_IMPLIB "${NPL_SDK_ABSOLUTE}/lib/${Npl_TARGET}/npl-sdk.lib"
    INTERFACE_INCLUDE_DIRECTORIES "${NPL_SDK_ABSOLUTE}/include/"
)

add_executable(${PROJECT_NAME} 
	${${PROJECT_NAME}_SOURCE_FILES} 
	${${PROJECT_NAME}_HEADER_FILES} 
	${${PROJECT_NAME}_IMGUI_FILES}
)

target_link_libraries(${PROJECT_NAME} 
	npl-base 
	npl-sdk 
	d3d11.lib 
	d3dcompiler.lib 
	dxgi.lib
)

endif()
