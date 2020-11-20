#!/bin/bash

cd ~/shares/HoloBlade/fpga_firmware/verilog/
yosys top.ys > ./build/yosys.log
nextpnr-ice40 --hx4k --json ./build/top.json --pcf ./phys/pinout_nextpnr.pcf --asc ./build/top.asc --package tq144 --log ./build/nextpnr.log
icebox_explain ./build/top.asc > ./build/top.icebox_explain.txt
icepack ./build/top.asc ./build/top.bin
iceprog ./build/top.bin

