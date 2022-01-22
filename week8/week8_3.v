`timescale 1ns / 1ps


module d_out(input clk,[31:0] data,output reg [3:0] d,reg [2:0] an);
wire c50hz0,c50hz1,c50hz2,c50hz3,c50hz4,c50hz5,c50hz6,c50hz7;
reg [20:0] count;

always @(posedge clk)
begin
    count <= count + 21'b1;
end
assign c50hz0 = (count == 21'b0_0011111111_1111111111);
assign c50hz1 = (count == 21'b0_0111111111_1111111111);
assign c50hz2 = (count == 21'b0_1011111111_1111111111);
assign c50hz3 = (count == 21'b0_1111111111_1111111111);
assign c50hz4 = (count == 21'b1_0011111111_1111111111);
assign c50hz5 = (count == 21'b1_0111111111_1111111111);
assign c50hz6 = (count == 21'b1_1011111111_1111111111);
assign c50hz7 = (count == 21'b1_1111111111_1111111111);

always @(posedge clk)
begin
    if (c50hz0)
    begin
        d<=data[3:0];
        an<=3'b000;
    end
    if (c50hz1)
    begin
        d<=data[7:4];
        an<=3'b001;
    end
    if (c50hz2)
    begin
        d<=data[11:8];
        an<=3'b010;
    end
    if (c50hz3)
    begin
        d<=data[15:12];
        an<=3'b011;
    end
    if (c50hz4)
    begin
        d<=data[19:16];
        an<=3'b100;
    end
    if (c50hz5)
    begin
        d<=data[23:20];
        an<=3'b101;
    end
    if (c50hz6)
    begin
        d<=data[27:24];
        an<=3'b110;
    end
    if (c50hz7)
    begin
        d<=data[31:28];
        an<=3'b111;
    end
end

endmodule



module week8_3(input clk,sw,button,rst_sw,output [3:0] d, [2:0] an);
reg [31:0] curr_state,next_state_p,next_state_n;

always@(*)
begin
    next_state_p = curr_state + 1;
    next_state_n = curr_state - 1;
end

always@(posedge button)
begin
    if (rst_sw == 1) curr_state<=32'h1F; 
    else
    begin
        if (sw == 1) curr_state<=next_state_p;
        else         curr_state<=next_state_n;
    end
end

d_out d_out(clk,curr_state,d,an);

endmodule
