##
## CMakeList.txt
##
## 'Meta Description' of the project building rules for ExtractDebugInfos

# Min cmake version
cmake_minimum_required(VERSION 3.5)

# Name of our project
project(ExtractDebugInfos LANGUAGES NONE)

# Set variables for install directories
set(CMAKE_INSTALL_PREFIX /usr/local)
message("PREFIX=${CMAKE_INSTALL_PREFIX}")
set(BINDIR "${CMAKE_INSTALL_PREFIX}/bin" CACHE PATH "Installation directory for binaries")
message("BINDIR=${BINDIR}")

# Set variables for used commands
find_program(OBJCOPY_CMD objcopy DOC "Path to the objcopy command")
find_program(STRIP_CMD   strip   DOC "Path to the strip command")
find_program(CHMOD_CMD   chmod   DOC "Path to the chmod command")

# Set variables for used commands
set(EXTRACT_DEBUG_INFOS_CMD "extract-debug-infos.sh" CACHE STRING "Path for the shell script that implement extract-debug-infos")
set(EXTRACT_DEBUG_INFOS_FROM_DIR_CMD "extract-debug-infos-from-dir.sh" CACHE STRING "Path for the shell script that implement extract-debug-infos-from-dir")
set(EXTRACT_DEBUG_INFOS_FROM_TREE_CMD "extract-debug-infos-from-tree.sh" CACHE STRING "Path for the shell script that implement extract-debug-infos-from-tree")

add_executable(extract-debug-infos.sh IMPORTED)
add_executable(extract-debug-infos-from-dir.sh IMPORTED)
add_executable(extract-debug-infos-from-tree.sh IMPORTED)

# Process extract-debug-infos.sh.in for generating extract-debug-infos.sh
configure_file(extract-debug-infos.sh.cmake extract-debug-infos.sh)

# Process extract-debug-infos-from-dir.sh.cmake for generating extract-debug-infos-from-dir.sh
configure_file(extract-debug-infos-from-dir.sh.cmake extract-debug-infos-from-dir.sh)

# Process extract-debug-infos-from-tree.sh.cmake for generating extract-debug-infos-from-tree.sh
configure_file(extract-debug-infos-from-tree.sh.cmake extract-debug-infos-from-tree.sh)

# Install targets
install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/extract-debug-infos.sh
  DESTINATION ${BINDIR})
install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/extract-debug-infos-from-dir.sh
  DESTINATION ${BINDIR})
install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/extract-debug-infos-from-tree.sh
  DESTINATION ${BINDIR})
