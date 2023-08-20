# Autoware-CARLA Simulation Docker Helper

This repository provides Dockerfile and helper packages for integrating Autoware and Carla simulation environment. 


## Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage of Autoware-CARLA Simulation Docker](#usage-of-autoware-carla-simulation-docker)
- [Usage of Helper Packages](#usage-of-helper-packages)
- [Notice](#notice)




https://github.com/Lamfurst/sim_helper/assets/66519297/ebe369fb-e65d-4d77-8089-86d0c855eea5

## Introduction
This repository combines the power of Autoware and Carla simulation to create a comprehensive environment for developing and testing autonomous driving algorithms. It includes Dockerfile setup for easy deployment and three helper packages to enhance simulation capabilities. These packages are:
- auto_reroute_py: a python package that automatically reroute the vehicle to follow waypoints and loop through the map.
- gnss_localizer: a package that provides the GNSS information to autoware using the position of the vehicle in the CARLA.
- traffic_light_bridge: a package that provides the traffic light information to autoware using the traffic light state information in the CARLA. 

## Prerequisites

Before using this package, ensure that you have the following prerequisites installed:

- [Docker Engine](https://docs.docker.com/engine/install/ubuntu/)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- [rocker](https://github.com/osrf/rocker/#installation)

## Installation
1. Clone this repository
    ```bash
    git clone --recursive  https://github.com/Lamfurst/sim_helper.git
    ```

2. build docker image from Dockerfile
    
    ```bash
    cd sim_helper/docker
    docker build -t autoware_carla:latest .
    ```
3. Download Release Version **0.9.13** of Carla from [here](https://github.com/carla-simulator/carla/releases) and extract it.
    
4. Put the map folder under your $HOME
    
    ```bash
    cd $HOME
    mkdir autoware_map
    ```
## Usage of Autoware-CARLA Simulation Docker
1. Run the CarlaUE4.sh script with the following parameters:
    
    ```bash
    cd folder/carla/is/installed
    ./CarlaUE4.sh -quality-level=Epic -world-port=2000 -resx=800 -resy=600
    ```
2. Use rocker to open docker
    
    ```bash
    rocker --nvidia --x11 --volume $HOME/autoware_map:/home/autoware_carla/autoware_map -- autoware_carla:latest
    ```
    
3. In the container opens tmux
    ```bash
    tmux
    ```

4. In the tmux run the following commands to launch Autoware:
    
    ```bash
    cd op_carla/op_bridge/op_scripts/ && ./run_exploration_mode_ros2.sh
    ```

## Usage of Helper Packages
This package provides launch script with the ability to launch different components with configurable options.

### Prerequisites
1. If you want to use gnss_locaizer helper function, modify the remapping rules in this launch file 'autoware/src/universe/autoware.universe/launch/tier4_localization_launch/launch/pose_twist_fusion_filter/pose_twist_fusion_filter.launch.xml' in the following way:

```xml
      <!-- <arg name="input_pose_with_cov_name" value="/localization/pose_estimator/pose_with_covariance"/> -->
      <arg name="input_pose_with_cov_name" value="/localization/pose_estimator/gnss/pose_with_covariance"/>
```

### Usage
1. Open another window in tmux using Ctrl+B and then %.

2. Run the script by executing the following command in the new window:

    ```bash
    ./launch_script.sh [OPTIONS]
    ```

### Options
You can use the following options to control which components are launched:

- `--gnss=true`: Launch the GNSS localizer component.
- `--traffic-light=true`: Launch the traffic light bridge component.
- `--auto-reroute=true`: Launch the auto reroute component.

If an option is not specified, the corresponding component will not be launched.

### Examples
1. Launch only the traffic light bridge component:
   ```bash
   ./launch_script.sh --traffic-light=true
   ```

2. Launch the GNSS localizer and auto reroute components:
   ```bash
   ./launch_script.sh --gnss=true --auto-reroute=true
   ```

3. Run the script without launching any components:
   ```bash
   ./launch_script.sh
   ```

## Notice
- Build docker image from dockerfile takes a long time, please be patient.
- If some error encountered when building docker image, please try to build again. Sometimes the compilation of autoware fails for the first time.
- If you want to add some traffic or pedestrians in the simulation, you can run the following command in the host machine
    ```bash
    cd folder/carla/is/installed
    python3 /home/artemis/Workspace/carla-0.9.13/PythonAPI/examples/generate_traffic.py --asynch --safe -n 50 -w 100
    ```

## License
This repository is licensed under the MIT license. See [LICENSE](LICENSE) for details.