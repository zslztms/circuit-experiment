`timescale 1ns / 1ps

module week7_3(
input clk,
input rst,
output reg [3:0] d,
output reg [2:0] an
);
reg [3:0] s0;
reg [3:0] s1;
reg [3:0] s2;
reg [3:0] min;
reg [13:0] cnt;
reg [26:0] real_clk;
wire pulse_100hz = (cnt == 14'h1);
wire pulse_10hz = (real_clk == 27'b000101111101011110000100000);

always@(posedge clk)
begin
    real_clk <= real_clk + 17'b1;
    cnt <= cnt + 14'b1;

    if(rst)
    begin
        s0 <= 4;
        s1 <= 3;
        s2 <= 2;
        min <= 1;
    end
    
    if (pulse_100hz)
    begin
        an[1:0] <= an[1:0]+1;
    end
    
    if(pulse_10hz)
    begin
        real_clk <= 0;
        s0 <= s0 + 1;
    
        if(s0 >= 9)
        begin
            s0 <= 0;
            s1 <= s1+1;
        end
        
        if(s1 >= 9)
        begin 
            s1 <= 0;
            s2 <= s2+1;
        end
        
        if(s2 >= 5)
        begin 
            s2 <= 0;
            min <= min + 1;
        end
    end

    if(pulse_100hz)
    begin
        if(an == 3'b000)
        d <= s1;
        else if(an == 3'b001)
        d <= s2;
        else if(an == 3'b010)
        d <= min;
        else if(an == 3'b011)
        d <= s0;
    end
end


endmodule
