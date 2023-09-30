# FPGA Sandbox

## Quick Start

The `.devcontainer` configuration for this repo will set up a Codespaces capable of running Xilinx Vivado and Vitis tools, including GUIs via VNC, but it will not install the tools themselves as they are individually licensed and subject to a user agreement. However, you can download the installer yourself and expect setup to succeed in this environment.

### FPGA Compiler

The compiler package is large and consumes a fair amount of RAM when running, so we request an 8 Core, 32 GiB RAM, 64 GiB disk container. This will burn through your baseline core-hour allocation in 15-23 hours, depending on your plan, and then rack up costs at about $1/hour thereafter. Consider setting a low default Codespaces inactivity limit or simply buying a used desktop and installing Linux. Quality off-lease and refurbished hardware is often available at a steep discount from official vendor outlets.

### Embedded Linux Tools

This environment is not setup to run the `PetaLinux` toolchain, as that dependency list and package itself is very large. A combined install of Vivado, Vitis, and PetaLinux may not even fit in the largest Codespaces allocation of 128 GiB storage.

### VNC for GUIs

You can start start a VNC session as follows:
1. Open your Codespaces built from this repository in VSCode for source editing
1. From the command line, `vncserver -geometry 2560x1440 :1` or whatever resolution you prefer
1. VSCode will automatically create a port forward to 5901
1. Point a VNC viewer to localhost:5901 and connect

You will need to create an `xstartup` file in `~/.vnc/` until we get a default file configured.