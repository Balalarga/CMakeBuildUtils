cmake_minimum_required(VERSION 3.20)

macro(DefineDefaultModule ModuleName SourceDir)
    file(GLOB_RECURSE PROJECT_SOURCES
        ${SourceDir}/*.cpp
        ${SourceDir}/*.h
        ${SourceDir}/*.hpp)
    add_library(${ModuleName} ${PROJECT_SOURCES})
    target_include_directories(${ModuleName} PUBLIC ${SourceDir})
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

macro(DefineFolderNamedModule SourceDir)
    get_filename_component(ModuleName ${CMAKE_CURRENT_SOURCE_DIR} NAME)
    project(${ModuleName} LANGUAGES CXX)
    file(GLOB_RECURSE PROJECT_SOURCES
        ${SourceDir}/*.cpp
        ${SourceDir}/*.h
        ${SourceDir}/*.hpp)
    add_library(${ModuleName} ${PROJECT_SOURCES})
    target_include_directories(${ModuleName} PRIVATE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${SourceDir}/${ModuleName}>
        $<INSTALL_INTERFACE:${SourceDir}/${ModuleName}>)
    target_include_directories(${ModuleName} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${SourceDir}>
        $<INSTALL_INTERFACE:${SourceDir}>)
endmacro()

macro(AddInterfaceModules Target BaseDir)
    ListOfDirectChildDirectories(MODULES_LIST ${BaseDir})
    foreach(MODULE ${MODULES_LIST})
        add_subdirectory(${MODULES_DIR}/${MODULE})
        target_include_directories(${Target} INTERFACE ${MODULE})
        target_link_libraries(${Target} INTERFACE ${MODULE})
        get_property(MODULE_TARGET DIRECTORY ${MODULES_DIR}/${MODULE} PROPERTY BUILDSYSTEM_TARGETS)
        set_target_properties(${MODULE_TARGET} PROPERTIES FOLDER ${Target})
        message("Submodule ${MODULE} added to ${Target}")
    endforeach()
endmacro()
