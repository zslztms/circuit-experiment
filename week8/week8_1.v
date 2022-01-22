module test(input clk,rst,output led);
reg [1:0] cnt_curr;
reg [1:0] cnt_next;
 
always@(*)
begin
    cnt_next = cnt_curr + 1;
end

always@(posedge clk, posedge rst)
begin
    if(rst)
    cnt_curr <= 2'b0;
    else
    cnt_curr <= cnt_next;
end

assign led = (cnt_curr==2'b11) ? 1'b1 : 1'b0;

endmodule