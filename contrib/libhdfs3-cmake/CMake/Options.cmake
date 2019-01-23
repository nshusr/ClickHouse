OPTION(ENABLE_SSE "enable SSE4.2 buildin function" ON)

INCLUDE (CheckFunctionExists)
CHECK_FUNCTION_EXISTS(dladdr HAVE_DLADDR)
CHECK_FUNCTION_EXISTS(nanosleep HAVE_NANOSLEEP)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-strict-aliasing")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-strict-aliasing")

IF(ENABLE_SSE STREQUAL ON AND NOT PPC64LE AND NOT ARCH_AARCH64 AND NOT ARCH_ARM)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -msse4.2")
ENDIF(ENABLE_SSE STREQUAL ON)

IF(NOT TEST_HDFS_PREFIX)
SET(TEST_HDFS_PREFIX "./" CACHE STRING "default directory prefix used for test." FORCE)
ENDIF(NOT TEST_HDFS_PREFIX)

ADD_DEFINITIONS(-DTEST_HDFS_PREFIX="${TEST_HDFS_PREFIX}")
ADD_DEFINITIONS(-D__STDC_FORMAT_MACROS)
ADD_DEFINITIONS(-D_GNU_SOURCE)
ADD_DEFINITIONS(-D_GLIBCXX_USE_NANOSLEEP)

TRY_COMPILE(STRERROR_R_RETURN_INT
	${CMAKE_CURRENT_BINARY_DIR}
	${HDFS3_ROOT_DIR}/CMake/CMakeTestCompileStrerror.cpp
    CMAKE_FLAGS "-DCMAKE_CXX_LINK_EXECUTABLE='echo not linking now...'"
	OUTPUT_VARIABLE OUTPUT)

MESSAGE(STATUS "Checking whether strerror_r returns an int")

IF(STRERROR_R_RETURN_INT)
	MESSAGE(STATUS "Checking whether strerror_r returns an int -- yes")
ELSE(STRERROR_R_RETURN_INT)
	MESSAGE(STATUS "Checking whether strerror_r returns an int -- no")
ENDIF(STRERROR_R_RETURN_INT)

TRY_COMPILE(HAVE_STEADY_CLOCK
	${CMAKE_CURRENT_BINARY_DIR}
	${HDFS3_ROOT_DIR}/CMake/CMakeTestCompileSteadyClock.cpp
    CMAKE_FLAGS "-DCMAKE_CXX_LINK_EXECUTABLE='echo not linking now...'"
	OUTPUT_VARIABLE OUTPUT)

TRY_COMPILE(HAVE_NESTED_EXCEPTION
	${CMAKE_CURRENT_BINARY_DIR}
	${HDFS3_ROOT_DIR}/CMake/CMakeTestCompileNestedException.cpp
    CMAKE_FLAGS "-DCMAKE_CXX_LINK_EXECUTABLE='echo not linking now...'"
	OUTPUT_VARIABLE OUTPUT)

SET(HAVE_BOOST_CHRONO 0)
SET(HAVE_BOOST_ATOMIC 0)

SET(HAVE_STD_CHRONO 1)
SET(HAVE_STD_ATOMIC 1)
