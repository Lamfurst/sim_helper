FROM ghcr.io/autowarefoundation/autoware-universe:galactic-latest-cuda-amd64 AS prepare_stage

WORKDIR /home/autoware_carla

ENV HOMEDIR /home/autoware_carla

RUN git clone --recursive  https://github.com/Lamfurst/sim_helper.git

RUN git clone https://github.com/autowarefoundation/autoware.git -b galactic \
    && cd autoware && mkdir src \
    && git apply ../sim_helper/patch/autoware_repo.patch \
    && vcs import src < autoware.repos

RUN mkdir op_carla && cd op_carla \
    && git clone https://github.com/hatem-darweesh/op_bridge.git -b ros2 \
    && git clone https://github.com/hatem-darweesh/op_agent.git -b ros2 \
    && git clone https://github.com/hatem-darweesh/scenario_runner.git \
    && cd op_bridge && git apply ${HOMEDIR}/sim_helper/patch/op_bridge_op_scripts.patch \
    && cd ../op_agent && git apply ${HOMEDIR}/sim_helper/patch/op_agent.patch \
    && cp ${HOMEDIR}/sim_helper/patch/change_files/autoware.launch.xml \
        ${HOMEDIR}/autoware/src/launcher/autoware_launch/autoware_launch/launch/ \
    && cp ${HOMEDIR}/sim_helper/patch/change_files/gnss.launch.xml \
        ${HOMEDIR}/autoware/src/sensor_kit/sample_sensor_kit_launch/sample_sensor_kit_launch/launch \
    && cp ${HOMEDIR}/sim_helper/patch/change_files/sensor_kit_calibration.yaml \
        ${HOMEDIR}/autoware/src/sensor_kit/sample_sensor_kit_launch/sample_sensor_kit_description/config \
    && cp ${HOMEDIR}/sim_helper/patch/change_files/sensors_calibration.yaml \
        ${HOMEDIR}/autoware/src/sensor_kit/sample_sensor_kit_launch/sample_sensor_kit_description/config

FROM prepare_stage AS build_stage
# Build Autoware
RUN source /opt/ros/galactic/setup.bash \
    && cd autoware && colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release

# Copy local PythonAPI into container
COPY ./PythonAPI ${HOMEDIR}/carla_root/PythonAPI

# Install missing dependencies
RUN pip install py_trees \
    && pip install networkx \
    && pip install tabulate \
    && pip install transforms3d \
    && apt update \
    && apt install -y ros-galactic-sensor-msgs-py \
    && apt install -y ros-galactic-tf-transformations \
    && rm -rf /var/lib/apt/lists/*

# Append environment variable exports to .bashrc
RUN echo 'source /opt/ros/galactic/setup.bash' >> ~/.bashrc && \
    echo 'source /home/autoware_carla/autoware/install/setup.bash' >> ~/.bashrc && \
    echo 'export SCENARIO_RUNNER_ROOT=/home/autoware_carla/op_carla/scenario_runner' >> ~/.bashrc && \
    echo 'export LEADERBOARD_ROOT=/home/autoware_carla/op_carla/op_bridge' >> ~/.bashrc && \
    echo 'export TEAM_CODE_ROOT=/home/autoware_carla/op_carla/op_agent' >> ~/.bashrc && \
    echo 'export CARLA_ROOT=${HOMEDIR}/carla_root/' >> ~/.bashrc && \
    echo 'export PYTHONPATH=$PYTHONPATH:${CARLA_ROOT}/PythonAPI' >> ~/.bashrc && \
    echo 'export PYTHONPATH=$PYTHONPATH:${CARLA_ROOT}/PythonAPI/util' >> ~/.bashrc && \
    echo 'export PYTHONPATH=$PYTHONPATH:${CARLA_ROOT}/PythonAPI/carla' >> ~/.bashrc && \
    echo 'export PYTHONPATH=$PYTHONPATH:${CARLA_ROOT}/PythonAPI/carla/agents' >> ~/.bashrc && \
    echo 'export PYTHONPATH=$PYTHONPATH:$CARLA_ROOT/PythonAPI/carla/dist/carla-0.9.13-py3.7-linux-x86_64.egg' >> ~/.bashrc

FROM build_stage AS final_stage
RUN cd ${HOMEDIR}/sim_helper && git pull --recurse-submodules

# Build a new workspace and copy sim_helper folder into that workspace
RUN source /opt/ros/galactic/setup.bash \
    && cd ${HOMEDIR} \
    && mkdir -p ${HOMEDIR}/sim_helper_ws/src \
    && cp -r ${HOMEDIR}/sim_helper ${HOMEDIR}/sim_helper_ws/src \
    && cd ${HOMEDIR}/sim_helper_ws \
    && colcon build --symlink-install

RUN apt update \
    && apt install tmux \
    && rm -rf /var/lib/apt/lists/*

FROM final_stage AS final_stage2
RUN cd ${HOMEDIR}/sim_helper && git pull --recurse-submodules



CMD ["/bin/bash"]