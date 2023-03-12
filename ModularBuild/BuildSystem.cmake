
macro(DefineDefaultModule ModuleName)
    cmake_minimum_required(VERSION 3.20)
    project(${ModuleName} LANGUAGES CXX)
    file(GLOB_RECURSE PROJECT_SOURCES Source/*.cpp Source/*.h Source/*.hpp)
    add_library(${ModuleName} ${PROJECT_SOURCES})
    target_include_directories(${ModuleName} PRIVATE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Source/${ModuleName}>
        $<INSTALL_INTERFACE:Source/${ModuleName}>)
    target_include_directories(${ModuleName} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Source>
        $<INSTALL_INTERFACE:Source>)
endmacro()

macro(AddPublicModuleDependency ModuleName)
    set(DependencyModules ${ARGN})
    foreach(Module ${DependencyModules})
        target_link_libraries(${ModuleName} LINK_PUBLIC ${Module})
        target_include_directories(${ModuleName} PUBLIC ${Module})
    endforeach()
endmacro()

macro(DefineFolderLibraryWithDeps)
    cmake_minimum_required(VERSION 3.20)
    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    get_filename_component(ModuleName ${CMAKE_CURRENT_SOURCE_DIR} NAME)
    project(${ModuleName} LANGUAGES CXX)
    file(GLOB_RECURSE PROJECT_SOURCES ${ModuleName}/*.cpp ${ModuleName}/*.h ${ModuleName}/*.hpp)
    add_library(${ModuleName} ${PROJECT_SOURCES})
    target_include_directories(${ModuleName} PRIVATE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${ModuleName}>
        $<INSTALL_INTERFACE:${ModuleName}>)
    target_include_directories(${ModuleName} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:>)
    set(DependencyModules ${ARGN})
    foreach(Module ${DependencyModules})
        target_link_libraries(${ModuleName} LINK_PUBLIC ${Module})
        target_include_directories(${ModuleName} PUBLIC ${Module})
    endforeach()
endmacro()

macro(DefineFolderAppWithDeps)
    cmake_minimum_required(VERSION 3.20)
    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    get_filename_component(ModuleName ${CMAKE_CURRENT_SOURCE_DIR} NAME)
    project(${ModuleName} LANGUAGES CXX)
    file(GLOB_RECURSE PROJECT_SOURCES ${ModuleName}/*.cpp ${ModuleName}/*.h ${ModuleName}/*.hpp)
    add_executable(${ModuleName} ${PROJECT_SOURCES})
    target_include_directories(${ModuleName} PRIVATE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${ModuleName}>
        $<INSTALL_INTERFACE:${ModuleName}>)
    target_include_directories(${ModuleName} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:>)
    set(DependencyModules ${ARGN})
    foreach(Module ${DependencyModules})
        target_link_libraries(${ModuleName} LINK_PUBLIC ${Module})
        target_include_directories(${ModuleName} PUBLIC ${Module})
    endforeach()
endmacro()
