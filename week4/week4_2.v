module test(
input [4:0] a,
output reg [4:0] b);
always@(*)
b = a;
endmodule