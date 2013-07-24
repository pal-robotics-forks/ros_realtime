cmake_minimum_required(VERSION 2.8.3)
project(rosrt)
find_package(catkin REQUIRED COMPONENTS
  roscpp
  roslib
  rosatomic
  allocators
  lockfree
  std_msgs
  rostest
  rosunit
)
find_package(Boost REQUIRED COMPONENTS thread)
find_package(xenomai_ros QUIET)

catkin_package(
    DEPENDS Boost
    CATKIN_DEPENDS roscpp roslib rosatomic allocators lockfree std_msgs
    INCLUDE_DIRS include
    LIBRARIES ${PROJECT_NAME}
)

include_directories(include ${Boost_INCLUDE_DIRS} ${catkin_INCLUDE_DIRS})

if (Xenomai_FOUND)
  add_xenomai_flags()
endif()

add_library(${PROJECT_NAME}
  src/init.cpp
  src/malloc.cpp
  src/publisher.cpp
  src/simple_gc.cpp
  src/subscriber.cpp
)

target_link_libraries(${PROJECT_NAME}
  ${catkin_LIBRARIES}
  ${Boost_LIBRARIES}
)

if (Xenomai_FOUND)
  target_link_libraries(${PROJECT_NAME}
    ${Xenomai_LIBRARY_NATIVE}
    ${Xenomai_LIBRARY_XENOMAI}
    pthread
  )
endif()

if (GTEST_FOUND)
  include_directories(${GTEST_INCLUDE_DIRS})
  link_directories(${GTEST_LIBRARY_DIRS})

  add_executable(test_publisher EXCLUDE_FROM_ALL test/test_publisher.cpp)
  target_link_libraries(test_publisher ${PROJECT_NAME} ${GTEST_LIBRARIES})
  add_rostest(test/test_publisher.xml)

  add_executable(test_subscriber EXCLUDE_FROM_ALL test/test_subscriber.cpp)
  target_link_libraries(test_subscriber ${PROJECT_NAME} ${GTEST_LIBRARIES})
  add_rostest(test/test_subscriber.xml)

  catkin_add_gtest(test_malloc_wrappers test/test_malloc_wrappers.cpp)
  target_link_libraries(test_malloc_wrappers ${PROJECT_NAME} ${GTEST_LIBRARIES})

  add_library(test_malloc_wrappers_so EXCLUDE_FROM_ALL test/test_malloc_wrappers_so.cpp)

  add_executable(test_publisher_no_initialize EXCLUDE_FROM_ALL test/test_publisher_no_initialize.cpp)
  target_link_libraries(test_publisher_no_initialize ${PROJECT_NAME} ${GTEST_LIBRARIES})
  add_rostest(test/test_publisher_no_initialize.xml)

  add_executable(test_filtered_subscriber EXCLUDE_FROM_ALL test/test_filtered_subscriber.cpp)
  target_link_libraries(test_filtered_subscriber ${PROJECT_NAME} ${GTEST_LIBRARIES})
  add_rostest(test/test_filtered_subscriber.xml)

  add_dependencies(tests
    test_publisher
    test_subscriber
    test_malloc_wrappers_so
    test_publisher_no_initialize
    test_filtered_subscriber
  )
endif()
