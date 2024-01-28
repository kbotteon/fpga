# Xilinx tools rely on Ubuntu 20.04
FROM ubuntu:20.04

RUN dpkg --add-architecture i386

# Update the system and install the basic
# (Modern) Git is covered by devcontainer.json
RUN \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        make \
        unzip \
        screen \
        tmux \
        software-properties-common

# Install FPGA tooling dependencies
# (Modern) Python is covered by devcontainer.json
RUN \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        clang \
        gdb \
        # This sets up a graphical environment and VNC for Xilinx GUI tools
        tigervnc-common \
        tigervnc-standalone-server \
        xfce4 \
        xfce4-terminal \
        dbus-x11 \
        # Vivado and Vitis dependencies
        libgl1-mesa-glx \
        libgl1-mesa-dri \
        libgl1-mesa-dev \
        default-jre \
        libtinfo5 \
        libstdc++6:i386 \
        dpkg-dev:i386 \
        libgtk2.0-0:i386 \
        libncurses5

# Set up open source FPGA tools like GHDL and Verilator
RUN \
    apt-get update && apt-get install -y --no-install-recommends \
    # Manually handle Verilator dependencies in case building from source
    git help2man perl python3 make autoconf g++ flex bison ccache \
    libgoogle-perftools-dev numactl perl-doc libfl2 libfl-dev zlibc \
    zlib1g zlib1g-dev \
    # Install these to view output
    ghdl gtkwave

# Build the latest and greatest Verilator from source
RUN \
    git clone --recursive -b v4.228 https://github.com/verilator/verilator /usr/local/src/verilator \
    && cd /usr/local/src/verilator \
    && autoconf \
    && ./configure --prefix=/usr/local \
    && make -j `nproc` && \
    make install
