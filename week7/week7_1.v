`timescale 1ns / 1ps

module week7_1(input [3:0] sw,output [7:0] out);
dist_mem_gen_0 rom(.a (sw),.spo (out));
endmodule
