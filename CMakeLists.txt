cmake_minimum_required(VERSION 2.8)

PROJECT(CocoaOpenGL)

find_package(OpenGL REQUIRED)
find_library(COCOA_FRAMEWORK Cocoa REQUIRED)
find_library(CORE_FOUNDATION_FRAMEWORK CoreFoundation REQUIRED)
find_library(CORE_IMAGE_FRAMEWORK CoreImage REQUIRED)

add_executable(${PROJECT_NAME} MACOSX_BUNDLE
               ${PROJECT_NAME}.mm
               )

add_executable(${PROJECT_NAME}2 MACOSX_BUNDLE
               ${PROJECT_NAME}2.m
               create_window.h
               create_window.m
               MyGLView.h
               MyGLView.m
               MyWindow.h
               MyWindow.m
               )

target_link_libraries(${PROJECT_NAME}
                      ${OPENGL_gl_LIBRARY}
                      ${COCOA_FRAMEWORK}
                      ${CORE_FOUNDATION_FRAMEWORK}
                      ${CORE_IMAGE_FRAMEWORK}
                      )

target_link_libraries(${PROJECT_NAME}2
                      ${OPENGL_gl_LIBRARY}
                      ${COCOA_FRAMEWORK}
                      ${CORE_FOUNDATION_FRAMEWORK}
                      ${CORE_IMAGE_FRAMEWORK}
                      )
