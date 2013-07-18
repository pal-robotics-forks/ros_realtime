cmake_minimum_required(VERSION 2.8.3)
project(rosatomic)

find_package(catkin REQUIRED)
find_package(Boost REQUIRED)

catkin_package(
  DEPENDS Boost
  INCLUDE_DIRS include
)

include_directories(include ${Boost_INCLUDE_DIRS})

catkin_add_gtest(utest test/utest.cpp)
