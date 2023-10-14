#!/usr/bin/env bash
mkdir -p work
touch ./work/xsim.log
xvlog --incr --relax -L uvm -prj xsim.prj 2>&1 | tee work/xsim.log
xelab --incre --debug typical --relax --mt 8 -L work -L uvm -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_behav work.tb work.glbl 2>&1 | tee work/xsim.log
xsim tb_behav -key {Behavioral:sim_1:Functional:tb} -tclbatch xsim.tcl 2>&1 | tee work/xsim.log
