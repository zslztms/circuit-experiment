`timescale 1ns / 1ps

module week7_2(input clk,rst,[7:0] sw,output reg [3:0] d,reg [2:0] an);
wire c100hz1,c100hz2;
reg [19:0] count;
always @(posedge clk)
begin
    if (rst) count<=20'b0;
    else count <= count + 20'b1;
end
assign c100hz1 = (count == 20'b1111111111_1111111111);
assign c100hz2 = (count == 20'b0111111111_1111111111);
always @(posedge clk)
begin
    if (c100hz1)
    begin
        d<=sw[3:0];
        an<=3'b000;
    end
    if (c100hz2)
    begin
        d<=sw[7:4];
        an<=3'b001;
    end
end

endmodule
