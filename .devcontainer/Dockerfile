# Xilinx tools rely on Ubuntu 22.04
FROM ubuntu:22.04

RUN dpkg --add-architecture i386

# Set up a baseline environment
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    # Common packages
    make unzip screen tmux vim software-properties-common build-essential \
    cmake clang gdb git python3 bison \
    # VNC
    tigervnc-common tigervnc-standalone-server tigervnc-tools xfce4 \
    xfce4-terminal \
    # Clean up apt cache to reduce image size
    && rm -rf /var/lib/apt/lists/*

# Set up FPGA tools
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    # FPGA tool dependencies
    dbus-x11 libgl1-mesa-glx libgl1-mesa-dri libgl1-mesa-dev default-jre \
    libtinfo5 libstdc++6:i386 dpkg-dev:i386 libgtk2.0-0:i386 libncurses5 \
    # Open-source FPGA tools and dependencies for GHDL, Verilator, etc.
    help2man perl autoconf flex ccache libgoogle-perftools-dev numactl \
    perl-doc libfl2 libfl-dev zlib1g zlib1g zlib1g-dev ghdl gtkwave \
    # Clean up apt cache to reduce image size
    && rm -rf /var/lib/apt/lists/*

# Build and install the latest Verilator from source
RUN git clone --recursive -b v4.228 https://github.com/verilator/verilator /usr/local/src/verilator \
    && cd /usr/local/src/verilator \
    && autoconf \
    && ./configure --prefix=/usr/local \
    && make -j$(nproc) \
    && make install
