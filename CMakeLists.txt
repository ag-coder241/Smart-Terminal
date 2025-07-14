cmake_minimum_required(VERSION 3.19)
project(smart_terminal_cpp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)

add_library(st_lib
    src/SmartTerminal.cpp
)
target_include_directories(st_lib PUBLIC include)

add_executable(smart_term_cpp src/SmartTerminal.cpp)
target_link_libraries(smart_term_cpp st_lib)
