// File: usb_to_bluejay_if.v
// Generated by MyHDL 0.11
// Date: Thu Mar  5 16:32:50 2020


`timescale 1ns/10ps

module usb_to_bluejay_if (
    reset_i,
    clk_i,
    data_i,
    next_line_rdy_i,
    next_frame_rdy_i,
    fifo_empty_i,
    fifo_output_enable_o,
    get_next_word_o,
    reset_o,
    clk_o,
    data_o,
    next_line_rdy_o,
    next_frame_rdy_o,
    fifo_empty_o,
    get_next_word_i
);
// Ports
// I/O pins:
// --------
// Control:
// reset_i              : Reset line
// USB-Fifo Side:
// clk_i                : 100MHz input clock from USB Chip
// data_i               : 32-bit input data FIFO from USB
// next_line_rdy_i      : line to indicate that a new line of data is available, active-high for 1 cycle
// next_frame_rdy_i     : line to indicate that the entire frame has been output, active-high for 1 cycle
// fifo_empty_i         : flag to indicate whether or not the FIFO is empty, active-low
// fifo_output_enable_o : line to turn on the outputting of the FIFO, active-low
// get_next_word_o      : line to pull next data word out of FIFO, active-low
// reset_o              : line to reset USB3 chip, active-low
// Bluejay Data Interface:
// clk_o                : Pipe USB FIFO clock out to rest of FPGA
// data_o               : Route 32-bit input data FIFO to Bluejay Data Interface
// next_line_rdy_o      : line to indicate that a new line of data is available, active-high for 1 cycle
// next_frame_rdy_o     : line to indicate that the entire frame has been output, active-high for 1 cycle
// fifo_empty_o         : flag to indicate whether or not the FIFO is empty, active-high
// get_next_word_i      : line to pull next data word out of FIFO, active-high

input reset_i;
input clk_i;
input [31:0] data_i;
input next_line_rdy_i;
input next_frame_rdy_i;
input fifo_empty_i;
output fifo_output_enable_o;
wire fifo_output_enable_o;
output get_next_word_o;
wire get_next_word_o;
output reset_o;
wire reset_o;
output clk_o;
wire clk_o;
output [31:0] data_o;
wire [31:0] data_o;
output next_line_rdy_o;
wire next_line_rdy_o;
output next_frame_rdy_o;
wire next_frame_rdy_o;
output fifo_empty_o;
wire fifo_empty_o;
input get_next_word_i;





assign clk_o = clk_i;
assign data_o = data_i;
assign next_line_rdy_o = next_line_rdy_i;
assign next_frame_rdy_o = next_frame_rdy_i;
assign fifo_empty_o = (!fifo_empty_i);
assign reset_o = (!reset_i);
assign fifo_output_enable_o = 1'b0;



assign get_next_word_o = (!get_next_word_i);

endmodule
