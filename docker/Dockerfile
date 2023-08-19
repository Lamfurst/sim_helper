FROM ghcr.io/autowarefoundation/autoware-universe:galactic-latest-cuda-amd64

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

# Build Autoware
RUN source /opt/ros/galactic/setup.bash \
    && cd autoware && colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release

# Install carla
# RUN pip install --user pygame numpy && pip3 install --user pygame numpy \
#     && apt-get update \
#     && apt-get install -y software-properties-common \
#     && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1AF1527DE64CB8D9 \
#     && add-apt-repository "deb [arch=amd64] http://dist.carla.org/carla $(lsb_release -sc) main" \
#     && apt-get update \
#     && apt-get install carla-simulator=0.9.13 \
#     && rm -rf /var/lib/apt/lists/*

# Install missing dependencies
RUN pip install py_trees \
    && pip install networkx \
    && pip install tabulate \
    && pip install transforms3d \
    && apt update \
    && apt install -y ros-galactic-sensor-msgs-py \
    && rm -rf /var/lib/apt/lists/*

RUN echo 'source /opt/ros/galactic/setup.bash' >> ~/.bashrc && \
    echo 'source /home/autoware_carla/autoware/install/setup.bash' >> ~/.bashrc && \
    echo 'export SCENARIO_RUNNER_ROOT=/home/autoware_carla/op_carla/scenario_runner' >> ~/.bashrc && \
    echo 'export LEADERBOARD_ROOT=/home/autoware_carla/op_carla/op_bridge' >> ~/.bashrc && \
    echo 'export TEAM_CODE_ROOT=/home/autoware_carla/op_carla/op_agent' >> ~/.bashrc

# Copy local PythonAPI into container
COPY ./PythonAPI ${HOMEDIR}/carla_root/PythonAPI

# Append environment variable exports to .bashrc
RUN echo 'export CARLA_ROOT=${HOMEDIR}/carla_root/' >> ~/.bashrc && \
    echo 'export PYTHONPATH=$PYTHONPATH:${CARLA_ROOT}/PythonAPI' >> ~/.bashrc && \
    echo 'export PYTHONPATH=$PYTHONPATH:${CARLA_ROOT}/PythonAPI/util' >> ~/.bashrc && \
    echo 'export PYTHONPATH=$PYTHONPATH:${CARLA_ROOT}/PythonAPI/carla' >> ~/.bashrc && \
    echo 'export PYTHONPATH=$PYTHONPATH:${CARLA_ROOT}/PythonAPI/carla/agents' >> ~/.bashrc && \
    echo 'export PYTHONPATH=$PYTHONPATH:$CARLA_ROOT/PythonAPI/carla/dist/carla-0.9.13-py3.7-linux-x86_64.egg' >> ~/.bashrc

# Build a new workspace and copy sim_helper folder into that workspace
RUN source /opt/ros/galactic/setup.bash \
    && cd ${HOMEDIR} \
    && mkdir -p ${HOMEDIR}/sim_helper_ws/src \
    && cp -r ${HOMEDIR}/sim_helper ${HOMEDIR}/sim_helper_ws/src \
    && cd ${HOMEDIR}/sim_helper_ws \
    && colcon build --symlink-install

CMD ["/bin/bash"]