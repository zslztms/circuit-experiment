`timescale 1ns / 1ps

module regfile_writefirst(input clk,we,[4:0] wa,ra1,ra2,ra3,[31:0] wd,output [31:0] rd1,rd2,rd3);
reg [31:0] regfile[0:31];

integer i;//initialize all regfile to 0
    initial 
     begin
        for(i = 0; i < 32; i = i + 1)  regfile[i] <= 0;
     end
//attention! read output must be pure combinational!
assign rd1 = (we&(wa==ra1)&(wa!=0)) ? wd : regfile[ra1];
assign rd2 = (we&(wa==ra2)&(wa!=0)) ? wd : regfile[ra2];
assign rd3 = (we&(wa==ra3)&(wa!=0)) ? wd : regfile[ra3];

always@ (posedge clk) 
begin
    if (we && (wa!=0))
    begin
        regfile[wa] <= wd;
    end
end

endmodule
