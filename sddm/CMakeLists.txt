install(DIRECTORY amos DESTINATION ${CMAKE_INSTALL_PREFIX}/share/sddm/themes/)

file(GLOB_RECURSE QML_SRCS amos/*)
add_custom_target(SDDM_THEME_QML ALL echo SOURCES ${QML_SRCS})
