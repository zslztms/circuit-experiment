`timescale 1ns / 1ps
module alu//don't need to output z (signal of zero)
#(parameter WIDTH = 32)
(
input [WIDTH-1:0] a, b,	//两操作数
input [2:0] f,			//操作功能
output reg [WIDTH-1:0] y 	//运算结果
);

always@(*)
begin
    case(f)
        3'b000: y=a+b;
        3'b001: y=a-b;
        3'b010: y=a&b;
        3'b011: y=a|b;
        3'b100: y=a^b;
        3'b101: y=a<<b;
        3'b110: y=a>>b;
        default: y=32'b00000000_00000000_00000000_00000000;
    endcase
end
endmodule