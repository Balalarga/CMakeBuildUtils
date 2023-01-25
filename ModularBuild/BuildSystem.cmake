cmake_minimum_required(VERSION 3.20)

set(MODULAR_BUILD_SOURCE_DIR Source)

macro(DefineDefaultModule ModuleName)
    project(${ModuleName} LANGUAGES CXX)
    file(GLOB_RECURSE PROJECT_SOURCES
        ${MODULAR_BUILD_SOURCE_DIR}/*.cpp
        ${MODULAR_BUILD_SOURCE_DIR}/*.h
        ${MODULAR_BUILD_SOURCE_DIR}/*.hpp)
    add_library(${ModuleName} ${PROJECT_SOURCES})
    target_include_directories(${ModuleName} PRIVATE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${MODULAR_BUILD_SOURCE_DIR}/${ModuleName}>
        $<INSTALL_INTERFACE:${MODULAR_BUILD_SOURCE_DIR}/${ModuleName}>)
    target_include_directories(${ModuleName} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${MODULAR_BUILD_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${MODULAR_BUILD_SOURCE_DIR}>)
endmacro()

macro(AddPublicModuleDependencies ModuleName)
    set(DependencyModules ${ARGN})
    message("${ModuleName} public dependencies:")
    foreach(Module ${DependencyModules})
        message("  ${Module}")
        target_link_libraries(${ModuleName} LINK_PUBLIC ${Module})
        target_include_directories(${ModuleName} PUBLIC ${Module})
    endforeach()
endmacro()

macro(AddPrivateModuleDependencies ModuleName)
    set(DependencyModules ${ARGN})
    message("${ModuleName} private dependencies:")
    foreach(Module ${DependencyModules})
        message("  ${Module}")
        target_link_libraries(${ModuleName} LINK_PRIVATE ${Module})
        target_include_directories(${ModuleName} PRIVATE ${Module})
    endforeach()
endmacro()

macro(DefineFolderNamedModule)
    get_filename_component(ModuleName ${CMAKE_CURRENT_SOURCE_DIR} NAME)
    project(${ModuleName} LANGUAGES CXX)
    file(GLOB_RECURSE PROJECT_SOURCES
        ${MODULAR_BUILD_SOURCE_DIR}/*.cpp
        ${MODULAR_BUILD_SOURCE_DIR}/*.h
        ${MODULAR_BUILD_SOURCE_DIR}/*.hpp)
    add_library(${ModuleName} ${PROJECT_SOURCES})
    target_include_directories(${ModuleName} PRIVATE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${MODULAR_BUILD_SOURCE_DIR}/${ModuleName}>
        $<INSTALL_INTERFACE:${MODULAR_BUILD_SOURCE_DIR}/${ModuleName}>)
    target_include_directories(${ModuleName} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${MODULAR_BUILD_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${MODULAR_BUILD_SOURCE_DIR}>)
endmacro()
