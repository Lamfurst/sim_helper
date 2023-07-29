# sim_helper
This is a helper package for the carla-autoware simulation. It contains the following packages:
- traffic_light_bridge
- gnss_localizer
- traffic_light_bridge


https://github.com/Lamfurst/sim_helper/assets/66519297/ebe369fb-e65d-4d77-8089-86d0c855eea5


## Prerequisites

Before using this package, ensure that you have the following prerequisites installed:

- ROS2 (Robot Operating System)
- CARLA simulator
- AutoWare Universe
- Follow Dr. Hatem's instructions to install the [Autoware-CARLA bridge and open planner](https://www.youtube.com/watch?v=EFH-vVxn180)
- tmux

## Installation
1. Follow the [doc](https://docs.ros.org/en/foxy/Tutorials/Beginner-Client-Libraries/Creating-A-Workspace/Creating-A-Workspace.html) to create a ROS2 workspace
2. Clone this repository into your src folder under your workspace
    ```shell
    cd <your_workspace>/src
    ```
3. Build your workspace using `colcon build --symlink-install`

## Configuration
See submodules for detail configuration.

## Usage
1. Launch Carla and Autoware
2. Launch the sim_helper by running launch_script.sh
    ```shell
    ./launch_script.sh
    ```
