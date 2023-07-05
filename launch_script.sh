#!/bin/bash
cd gnss_localizer
./launch_script.sh
sleep 5

cd ../traffic_light_bridge
./launch_script.sh 

cd ../auto_reroute_py
./launch_script.sh true

