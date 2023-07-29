#!/bin/bash

# Split the window vertically and run the first command
tmux split-window -v
tmux send-keys "cd ./carla-0.9.13" C-m
tmux send-keys "./CarlaUE4.sh -quality-level=Epic -world-port=2000 -resx=800 -resy=600" C-m


sleep 8

# Split the window horizontally and run the second command
tmux split-window -h
tmux send-keys "source ~/Workspace/autowarefoundation/carla-autoware-universe/autoware/install/setup.bash" C-m
tmux send-keys "cd ~/Workspace/autowarefoundation/op_bridge/op_scripts" C-m
tmux send-keys "./run_exploration_mode_ros2.sh > /home/artemis/Workspace/running_log/output.log" C-m

# # Select the layout and adjust window sizes
# tmux select-layout even-vertical
# tmux resize-pane -U 10

# Switch to the first pane
tmux select-pane -t 0

# Attach to the tmux session
tmux attach-session
