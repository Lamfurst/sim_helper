cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
project(voxel_grid)

find_package(PCL 1.2 REQUIRED)
find_package(Eigen3 REQUIRED)  # Add this line to find Eigen

include_directories(
  ${PCL_INCLUDE_DIRS}
  ${Eigen3_INCLUDE_DIRS}  # Add this line to include Eigen headers
)

link_directories(${PCL_LIBRARY_DIRS})
add_definitions(${PCL_DEFINITIONS})

add_executable(voxel_grid voxel_grid.cpp)
target_link_libraries(voxel_grid ${PCL_LIBRARIES} Eigen3::Eigen)  # Add Eigen3::Eigen to target_link_libraries