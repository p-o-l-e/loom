cmake_minimum_required(VERSION 3.5)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
endif()

project(FIELD)

# Vulkan — headers vendored in third_party/vulkan, library from system
set(Vulkan_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/third_party/vulkan)
find_package(Vulkan REQUIRED)
include_directories(${Vulkan_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}/third_party/vulkan ${CMAKE_SOURCE_DIR})

set( GLFW_BUILD_DOCS OFF CACHE BOOL  "GLFW lib only" )
set( GLFW_INSTALL OFF CACHE BOOL  "GLFW lib only" )

add_subdirectory(glfw build/glfw)
add_subdirectory(s7 build/s7)

# Compile GLSL shaders to SPIR-V at build time
set(SHADER_DIR ${CMAKE_SOURCE_DIR}/shaders)
set(SHADER_SOURCES
    ${SHADER_DIR}/layer.vert
    ${SHADER_DIR}/layer.frag
    ${SHADER_DIR}/line.vert
    ${SHADER_DIR}/line.frag
)
set(SHADER_OUTPUTS "")
foreach(SHADER ${SHADER_SOURCES})
    get_filename_component(SHADER_NAME ${SHADER} NAME)
    set(SPV_OUTPUT ${SHADER_DIR}/${SHADER_NAME}.spv)
    add_custom_command(
        OUTPUT ${SPV_OUTPUT}
        COMMAND glslangValidator -V ${SHADER} -o ${SPV_OUTPUT}
        DEPENDS ${SHADER}
        COMMENT "Compiling shader ${SHADER_NAME} -> SPIR-V"
        VERBATIM
    )
    list(APPEND SHADER_OUTPUTS ${SPV_OUTPUT})
endforeach()

add_custom_target(shaders ALL DEPENDS ${SHADER_OUTPUTS})

add_executable(loom main.c)
add_dependencies(loom shaders)

target_link_libraries(loom ${Vulkan_LIBRARIES} glfw s7)

target_compile_options(loom PRIVATE
    -Wall
    -Wextra
    -Wpedantic
    -O3
    $<$<CONFIG:Debug>:-g>
)
