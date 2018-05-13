cmake_minimum_required(VERSION {{CMAKE_VERSION}})
project({{PROJECT_NAME}})

set(CMAKE_CXX_STANDARD {{CXX_STANDARD}})
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_subdirectory(src)

add_executable({{EXECUTABLE_NAME}} ${BINARY_SOURCES})
