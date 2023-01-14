# Here are registered all external projects
#
# Usage:
# add_dependencies(TARGET externalProjectName)
# target_link_libraries(TARGET PRIVATE ExternalLibraryName)

include(GNUInstallDirs)
include(ExternalProject)

set(EXTERNAL_PROJECTS_PREFIX ${CMAKE_BINARY_DIR}/external-projects)
set(EXTERNAL_PROJECTS_INSTALL_PREFIX ${EXTERNAL_PROJECTS_PREFIX}/installed)
set(RESTC_EXTERNAL_INSTALLED_LIB_DIR ${EXTERNAL_PROJECTS_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR})
link_directories(${RESTC_EXTERNAL_INSTALLED_LIB_DIR})

ExternalProject_Add(
    externalRapidJson
    PREFIX "${EXTERNAL_PROJECTS_PREFIX}"
    GIT_REPOSITORY "https://github.com/Tencent/rapidjson.git"
    GIT_TAG "master"
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD ON
    LOG_INSTALL ON
    )

set(EXTERNAL_RAPIDJSON_INCLUDE_DIR ${EXTERNAL_PROJECTS_PREFIX}/src/externalRapidJson/include/rapidjson)

ExternalProject_Add(
    externalLest
    PREFIX "${EXTERNAL_PROJECTS_PREFIX}"
    GIT_REPOSITORY "https://github.com/martinmoene/lest.git"
    GIT_TAG "master"
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD ON
    LOG_INSTALL ON
    )

ExternalProject_Add(externalLogfault
    PREFIX "${EXTERNAL_PROJECTS_PREFIX}"
    GIT_REPOSITORY "https://github.com/jgaa/logfault.git"
    GIT_TAG "master"
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTERNAL_PROJECTS_INSTALL_PREFIX}
    )

message(STATUS "EXTERNAL_RAPIDJSON_INCLUDE_DIR: ${EXTERNAL_RAPIDJSON_INCLUDE_DIR}")

if (INSTALL_RAPIDJSON_HEADERS)
    install(DIRECTORY ${EXTERNAL_RAPIDJSON_INCLUDE_DIR} DESTINATION include)
endif()

include_directories(
     ${EXTERNAL_PROJECTS_PREFIX}/src/externalRapidJson/include
     ${EXTERNAL_PROJECTS_PREFIX}/src/externalLest/include
     ${EXTERNAL_PROJECTS_PREFIX}/installed/include
    )

if (NOT DEFINED GTEST_TAG)
    set(GTEST_TAG "main")
endif()

message("GTEST_TAG: ${GTEST_TAG}")

if (WIN32)
    set(GTEST_EXTRA_ARGS "-Dgtest_force_shared_crt=TRUE")
endif()

ExternalProject_Add(googletest
    #GIT_TAG "main"
    GIT_TAG "${GTEST_TAG}"
    PREFIX "${EXTERNAL_PROJECTS_PREFIX}"
    GIT_REPOSITORY https://github.com/google/googletest.git
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${EXTERNAL_PROJECTS_INSTALL_PREFIX}
        -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        ${GTEST_EXTRA_ARGS}
)
set(GTEST_LIB_DIR ${RESTC_EXTERNAL_INSTALLED_LIB_DIR})

