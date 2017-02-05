install(DIRECTORY org.kde.amos.desktop DESTINATION ${CMAKE_INSTALL_PREFIX}/share/plasma/look-and-feel)

file(GLOB_RECURSE QML_SRCS org.kde.amos.desktop/*)
add_custom_target(PackageFiles ALL echo SOURCES ${QML_SRCS})
