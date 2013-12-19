cmake_minimum_required(VERSION 2.8.3)
project(allocators)

find_package(catkin REQUIRED)
find_package(Boost REQUIRED)

catkin_package(
  DEPENDS Boost
  INCLUDE_DIRS include
)

include_directories(include ${Boost_INCLUDE_DIRS})

install(DIRECTORY include/${PROJECT_NAME}/
  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
  FILES_MATCHING PATTERN "*.h")

catkin_add_gtest(test_aligned_alloc test/test_aligned_alloc.cpp)
