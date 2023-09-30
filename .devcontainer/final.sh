#!/usr/bin/env bash

# These persist between start/stop/rebuild but not delete/create
mkdir -p /workspaces/tmp
mkdir -p /workspaces/tools

# For the life of a Codespace, retain installed ssh keys and config
mkdir -p /workspaces/tmp/dot-ssh
chmod 700 /workspaces/tmp/dot-ssh

# Set up the default xstartup
mkdir -p ${HOME}/.vnc
chmod 755 ${HOME}/.vnc
cp ${PWD}/.devcontainer/persist/xstartup ${HOME}/.vnc/

# Link tracked persistent container files into home directory
ln -s ${PWD}/.devcontainer/persist ${HOME}/persist

# Use the semi-persistent .ssh between start/stop/rebuild
ln -s /workspaces/tmp/dot-ssh ${HOME}/.ssh
