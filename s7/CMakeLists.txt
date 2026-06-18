cmake_minimum_required(VERSION 3.5)

add_library(s7 INTERFACE)

target_sources(s7 INTERFACE
  ${CMAKE_CURRENT_LIST_DIR}/s7.c

)
