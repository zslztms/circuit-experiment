module week5_2();
reg clk,rst_n,d;
wire q;

initial 
begin
    clk=0;
    rst_n=0;
    d=0;
    #12.5 d=1;
    #15 rst_n=1;
    #10 d=0;
    #17.5 $stop;
end

always #5 clk = ~clk;

d_ff_r d_ff_r0(clk,rst_n,d,q);

endmodule