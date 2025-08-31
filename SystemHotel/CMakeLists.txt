cmake_minimum_required(VERSION 3.16)

project(QUANLYKHACHSAN VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Tìm Qt6
find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 QuickLayouts Network )

set(HOME_DIR $ENV{HOME})
set(PKG_PATH ${CMAKE_CURRENT_SOURCE_DIR}/Pkg)
set(LIB_PATH ${CMAKE_CURRENT_SOURCE_DIR}/Libs)
set(PATH_LIB_SOCKET ${LIB_PATH}/SocketIO_bin/libsioclient.a)

set(QML_IMPORT_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
set(QML_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")

file(GLOB CPP_SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/main.cpp"
    "${PKG_PATH}/*/*/src/*.cpp"
    "${PKG_PATH}/*/src/*.cpp"
)

file(GLOB HEADERS 
    "${PKG_PATH}/*/*/inc/*.h"
    "${PKG_PATH}/*/inc/*.h"
)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/Pkg
    ${LIB_PATH}/SocketIO_bin/src
    ${PKG_PATH}/MVC
    ${PKG_PATH}/Protocols
    ${PKG_PATH}/Utils
    ${PKG_PATH}/Common
)

# Nếu có file qrc (QML resources)
set(QML_RESOURCES ${CMAKE_CURRENT_SOURCE_DIR}/Pkg/MVC/Views/resources.qrc)

# Tạo target executable
add_executable(${PROJECT_NAME} ${CPP_SOURCES} ${HEADERS} ${QML_RESOURCES})

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_definitions(-DDEBUG_MODE)
endif()

if(BUILD_VIRTUAL)
    add_definitions(-DBUILD_VIRTUAL)
endif()

# Thêm Qt6 libraries và các thư viện cần thiết (loại bỏ link boost)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Core Qt6::Quick Qt6::Qml Qt6::QuickControls2 ${OpenCV_LIBS} ${PATH_LIB_SOCKET} ${OPENSSL_LIBRARIES})

# Đăng ký resource với Qt6
qt6_add_resources(QML_RESOURCES_ADDED ${QML_RESOURCES})
target_sources(${PROJECT_NAME} PRIVATE ${QML_RESOURCES_ADDED})

add_definitions(-DQT_NO_KEYWORDS)

target_compile_definitions(${PROJECT_NAME} PRIVATE
    QT_DEPRECATED_WARNINGS
)

target_compile_options(${PROJECT_NAME} PRIVATE
    -Wno-deprecated-declarations
)

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/bin)
endif()