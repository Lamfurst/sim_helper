#!/bin/bash

gnome-terminal -- bash -c "
cd ./carla-0.9.13
./CarlaUE4.sh -quality-level=Epic -world-port=2000 -resx=800 -resy=600
"
sleep 8

gnome-terminal -- bash -c "
source ~/Workspace/autowarefoundation/carla-autoware-universe/autoware/install/setup.bash
cd ~/Workspace/autowarefoundation/op_bridge/op_scripts
./run_exploration_mode_ros2.sh > /home/artemis/Workspace/running_log/output.log
"
