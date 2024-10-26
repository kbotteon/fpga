# Xilinx tools rely on Ubuntu 22.04
FROM ubuntu:22.04

# Set up a baseline environment
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        make unzip screen tmux vim software-properties-common \
        # FPGA tool dependencies
        build-essential cmake clang gdb \
        tigervnc-common tigervnc-standalone-server xfce4 xfce4-terminal dbus-x11 \
        libgl1-mesa-glx libgl1-mesa-dri libgl1-mesa-dev default-jre libtinfo5 \
        libstdc++6:i386 dpkg-dev:i386 libgtk2.0-0:i386 libncurses5 \
        # Open-source FPGA tools and dependencies for GHDL, Verilator, etc.
        git help2man perl python3 autoconf g++ flex bison ccache \
        libgoogle-perftools-dev numactl perl-doc libfl2 libfl-dev zlibc \
        zlib1g zlib1g-dev ghdl gtkwave \
    # Clean up apt cache to reduce image size
    && rm -rf /var/lib/apt/lists/*

# Build and install the latest Verilator from source
RUN git clone --recursive -b v4.228 https://github.com/verilator/verilator /usr/local/src/verilator \
    && cd /usr/local/src/verilator \
    && autoconf \
    && ./configure --prefix=/usr/local \
    && make -j$(nproc) \
    && make install
