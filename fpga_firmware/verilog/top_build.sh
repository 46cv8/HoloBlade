#!/bin/bash

cd ~/shares/HoloBlade/fpga_firmware/verilog/

target_dir="./build/$1"
mkdir -p $target_dir

echo -e "\n====================================================\nYosys Synthesis\n====================================================\n"
yosys top.ys | tee $target_dir/yosys.log
mv top.json $target_dir/top.json

pnr_random_seed=$(python -c "import random;print(random.randint(0, 2147483647))")
echo -e "\n====================================================\nNextPNR Place and Route (using random seed $pnr_random_seed)\n====================================================\n"
nextpnr-ice40 --hx4k --json $target_dir/top.json --pcf ./phys/pinout_nextpnr.pcf --asc $target_dir/top.asc --package tq144 --log $target_dir/nextpnr.log --freq 100 --opt-timing --seed $pnr_random_seed

#echo -e "\n====================================================\nIceBox Explain Decompile FPGA Image\n====================================================\n"
#icebox_explain $target_dir/top.asc > $target_dir/top.icebox_explain.txt

echo -e "\n====================================================\nIcePack Build Binary FPGA Image\n====================================================\n"
icepack $target_dir/top.asc $target_dir/top.bin

echo -e "\n====================================================\nIceProg Program Binary FPGA Image\n====================================================\n"
#iceprog $target_dir/top.bin

echo -e "\n\n    Target DIR: $target_dir\n    Used PNR Random Seed: $pnr_random_seed\n"
