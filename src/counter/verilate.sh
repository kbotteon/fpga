verilator -sv -cc --timing ../../sim/tb_util.sv tb.sv counter.sv --top-module tb --trace --exe tb.cpp
make -C obj_dir -f Vtb.mk CFLAGS="-std=c++11" -j4 Vtb
