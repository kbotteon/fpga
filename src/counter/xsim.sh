#!/usr/bin/env bash
WORK_DIR="./.xsim"

ROOT_DIR="$(pwd)"
mkdir -p ${WORK_DIR}

##############################
# Working in WORK_DIR
##############################
cd ${WORK_DIR}

touch xsim.log

xvlog --incr --relax -L uvm -prj ${ROOT_DIR}/xsim.prj 2>&1 | tee ./xsim.log

xelab --incre --debug typical --relax --mt 8 -L work -L uvm -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_behav work.tb work.glbl 2>&1 | tee ./xsim.log

xsim tb_behav -key {Behavioral:sim_1:Functional:tb} -tclbatch ${ROOT_DIR}/xsim.tcl 2>&1 | tee ./xsim.log

cd ${ROOT_DIR}
##############################
