#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM ubuntu:focal

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Restore man command
    && yes | unminimize 2>&1 

ENV LANG="C.UTF-8"

RUN dpkg --add-architecture i386

# Install basic build tools
RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        make \
        unzip \
        git \
        git-lfs \
        screen \
        python3 \
        python3-pip \
        build-essential \
        cmake \
        clang \
        gdb \
        python3-dev \
        # Stuff that Codespaces may or may not rely on
        swig3.0 \
        software-properties-common \
        # By default pip is not available in the buildpacks image
        python-pip-whl \
        # This sets up a graphical environment and VNC for Xilinx GUI tools
        tigervnc-standalone-server \
        xfce4 \
        # Vivado and Vitis dependencies
        libgl1-mesa-glx \
        libgl1-mesa-dri \
        libgl1-mesa-dev \
        default-jre \
        libtinfo5 \
        libstdc++6:i386 \
        dpkg-dev:i386 \
        libgtk2.0-0:i386 \
        libncurses5 \
    && rm -rf /var/lib/apt/lists/* \
    # This is the folder containing 'links' to benv and build script generator
    && apt-get update \
    && apt-get upgrade -y \
    && add-apt-repository universe \
    && rm -rf /var/lib/apt/lists/*

# TODO: Copy in a default xstartup for VNC

# Verify expected build and debug tools are present
RUN apt-get update \
    # Install tools and shells not in common script
    && apt-get install -yq vim vim-doc xtail software-properties-common libsecret-1-dev \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y \
    # Move first run notice to right spot
    && mkdir -p "/usr/local/etc/vscode-dev-containers/"

# Default to bash shell (other shells available at /usr/bin/fish and /usr/bin/zsh)
ENV SHELL=/bin/bash \
    DOCKER_BUILDKIT=1

# Remove scripts now that we're done with them
RUN apt-get clean -y && rm -rf /tmp/scripts

# Mount for docker-in-docker 
VOLUME [ "/var/lib/docker" ]

# Fire Docker/Moby script if needed
ENTRYPOINT [ "/usr/local/share/docker-init.sh", "/usr/local/share/ssh-init.sh"]
CMD [ "sleep", "infinity" ]

# [Optional] Install debugger for development of Codespaces - Not in resulting image by default
ARG DeveloperBuild
RUN if [ -z $DeveloperBuild ]; then \
        echo "not including debugger" ; \
    else \
        curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /vsdbg ; \
    fi
