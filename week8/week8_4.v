`timescale 1ns / 1ps

module d_out4(input clk,[3:0] seq,cnt,state,output reg [3:0] d,reg [2:0] an);
wire c50hz0,c50hz1,c50hz2,c50hz3,c50hz5,c50hz7;
reg [20:0] count;

always @(posedge clk)
begin
    count <= count + 21'b1;
end

assign c50hz0 = (count == 21'b0_0011111111_1111111111);
assign c50hz1 = (count == 21'b0_0111111111_1111111111);
assign c50hz2 = (count == 21'b0_1011111111_1111111111);
assign c50hz3 = (count == 21'b0_1111111111_1111111111);
//assign c50hz4 = (count == 21'b1_0011111111_1111111111);
assign c50hz5 = (count == 21'b1_0111111111_1111111111);
//assign c50hz6 = (count == 21'b1_1011111111_1111111111);
assign c50hz7 = (count == 21'b1_1111111111_1111111111);

always @(posedge clk)
begin
    if (c50hz0)
    begin
        d<={3'b000,seq[0]};
        an<=3'b000;
    end
    if (c50hz1)
    begin
        d<={3'b000,seq[1]};
        an<=3'b001;
    end
    if (c50hz2)
    begin
        d<={3'b000,seq[2]};
        an<=3'b010;
    end
    if (c50hz3)
    begin
        d<={3'b000,seq[3]};
        an<=3'b011;
    end


    if (c50hz5)
    begin
        d<=cnt;
        an<=3'b101;
    end


    if (c50hz7)
    begin
        d<=state;
        an<=3'b111;
    end
end

endmodule



module week8_4(input clk,sw,button,output [3:0] d, [2:0] an);
reg [3:0] curr_seq,next_seq,curr_cnt,next_cnt,curr_state,next_state;

always@(*)
begin
    next_seq[3:1]=curr_seq[2:0];
    next_seq[0]=sw;
    next_cnt=curr_cnt+1'b1;
    if (curr_state==4'h0)
    begin
        if (sw==0) next_state=4'h0;
        else       next_state=4'h1;
    end
    else if (curr_state==4'h1)
    begin
        if (sw==0) next_state=4'h0;
        else       next_state=4'h2;
    end
    else if (curr_state==4'h2)
    begin
        if (sw==0) next_state=4'h3;
        else       next_state=4'h1;
    end
    else if (curr_state==4'h3)
    begin
        if (sw==0) next_state=4'h0;
        else       next_state=4'h1;
    end
    else next_state=4'h0;
end

always@(posedge button)
begin
    curr_seq<=next_seq;
    curr_state<=next_state;
end

always@(negedge button)
begin
    if (curr_seq==4'b1100) curr_cnt<=next_cnt;
end

d_out4 d_out4(clk,curr_seq,curr_cnt,curr_state,d,an);

endmodule
