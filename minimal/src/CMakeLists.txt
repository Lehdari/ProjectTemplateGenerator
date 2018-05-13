#   add sources

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} SUB_SOURCES)

set(BINARY_SOURCES
    ${BINARY_SOURCES}
    ${SUB_SOURCES}
    PARENT_SCOPE)

#   add headers

file(GLOB SUB_HEADERS "*.hpp")

set(BINARY_HEADERS
    ${BINARY_HEADERS}
    ${SUB_HEADERS}
    PARENT_SCOPE)
