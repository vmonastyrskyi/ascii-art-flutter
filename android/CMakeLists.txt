cmake_minimum_required(VERSION 3.10.2)

# opencv
set(OpenCV_STATIC ON)
set(OpenCV_DIR $ENV{OPENCV_ANDROID}/sdk/native/jni)
find_package (OpenCV REQUIRED)

add_library(
    # Sets the name of the library.
    native_opencv
    # Provides a relative path to your source file(s).
    SHARED
    ../native_opencv/native_opencv.cpp
)

find_library(log-lib log)

target_link_libraries( # Specifies the target library.
    native_opencv
    ${OpenCV_LIBS}
    ${log-lib}
)