cmake_minimum_required(VERSION 2.8.3)
project(lockfree)
find_package(catkin REQUIRED COMPONENTS 
  rosatomic
  rosconsole
  roslib
  allocators
)
find_package(Boost REQUIRED)

catkin_package(
    DEPENDS rosatomic Boost
    CATKIN_DEPENDS rosatomic rosconsole roslib allocators
    INCLUDE_DIRS include
    LIBRARIES ${PROJECT_NAME}
)

include_directories(include ${Boost_INCLUDE_DIR} ${catkin_INCLUDE_DIRS})

add_library(${PROJECT_NAME} src/free_list.cpp)
target_link_libraries(${PROJECT_NAME} ${catkin_LIBRARIES})

catkin_add_gtest(test_object_pool test/test_object_pool.cpp)
target_link_libraries(test_object_pool ${PROJECT_NAME})

catkin_add_gtest(test_freelist test/test_freelist.cpp)
target_link_libraries(test_freelist ${PROJECT_NAME})
