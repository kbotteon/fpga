#!/usr/bin/env bash

mkdir -p /workspaces/tmp
mkdir -p /workspaces/tmp/dot-ssh
mkdir -p /workspaces/tools

ln -s ${PWD}/.devcontainer/persist ${HOME}/persist
ln -s /workspaces/tmp/dot-ssh ${HOME}/.ssh
