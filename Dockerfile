FROM osrf/ros:melodic-desktop-full

# Install pip
RUN apt-get update && \ 
    apt-get install -y python-pip python-dev build-essential

# Install Tensorflow, Keras
RUN pip install ipython Cython numpy scipy scikit-image Pillow h5py tensorflow keras

# Install some niceties
RUN apt-get install -y less wget nano

# Install dependency for tmkit
RUN apt-get install -y autoreconf

# Make bash execute ros setup
RUN echo 'source /opt/ros/melodic/setup.bash' >> /root/.bashrc 

# Create ROS ws
RUN mkdir -p /root/catkin_ws/src && cd /root/catkin_ws

# Install dependencies
RUN apt-get install lidsdl-image1.2-dev && \
    apt-get install libsdl-dev && \
    apt-get install ros-melodic-moveit-core && \
    apt-get install ros-melodic-tf2-sensor-msgs

# Install Fetch Melodic
RUN cd /root/catkin_ws/src && \
    git clone https://github.com/fetchrobotics/fetch_ros.git && \
    git clone https://github.com/fetchrobotics/fetch_gazebo.git && \
    git clone https://github.com/ros-planning/navigation.git && \
    git clone https://github.com/ros-planning/navigation_msgs.git

# Install moveit
#RUN rosdep update && \
#    apt-get update && \
#    apt-get dist-upgrade && \
#    apt install ros-melodic-moveit

# Create moveit ws
#RUN mkdir -p /root/ws_moveit/src && \
#    rosdep install -y --from-paths . --ignore-src --rosdistro melodic && \
#    cd /root/ws_moveit && \
#    catkin config --extend /opt/ros/melodic && \
#    catkin build && \
#    source /root/ws_moveit/devel/setup.bash

# Install tmkit dependencies (found at: tmkit.kavrakilab.org/installation.html)
# 1) Amino
#   a) Install Amino dependencies (found at: amino.kavrakilab.org/installation.html)
RUN apt-get install build-essential gfortran \
    autoconf automake libtool autoconf-archive autotools-dev \
    maxima libblas-dev liblapack-dev \
    libglew-dev libsdl2-dev \
    libfcl-dev libompl-dev \
    sbcl \
    default-jdk \
    blender flex povray libav-tools
RUN wget https://beta.quicklisp.org/quicklisp.lisp
RUN sbcl --load quicklisp.lisp \
    --eval '(quicklisp-quickstart:install)' \
    --eval '(ql:add-to-init-file)' \
    --eval '(quit)' \

#   b) Install Amino
RUN mkdir -p ~/amino && \
    cd ~/amino && \
    git clone --recursive https://github.com/golems/amino.git && \
    cd amino && \
    autoreconf -i && \
    ./configure && \
    make && 
    make install

# 2) Z3
RUN mkdir -p ~/z3 && \
    cd ~/z3 && \
    git clone https://github.com/Z3Prover/z3.git && \
    cd z3 && \
    python scripts/mk_make.py && \
    cd build & \
    make && \
    make install

# Install tmkit
RUN mkdir -p ~/tmkit && \
    cd ~/tmkit && \
    git clone https://github.com/kavrakilab/tmkit.git && \
    cd tmsmt && \
    autoreconf -i && \
    ./configure && \
    make && \
    make install

# Install a VNC X-server, Frame buffer, and windows manager
RUN apt-get install -y x11vnc xvfb fluxbox

# Finally, install wmctrl needed for bootstrap script
RUN apt-get install -y wmctrl 

# Copy bootstrap script and make sure it runs
COPY bootstrap.sh /

CMD '/bootstrap.sh'
