module count32(input clk,rst,output [7:0] outled);
    reg [31:0] led;
    always @(posedge clk,posedge rst)
    begin
        if (rst == 1) led<=32'b0000_0000_0000_0000_0000_0000_0000_0000;
        else led<=led + 32'b0000_0000_0000_0000_0000_0000_0000_0001;
    end
    assign outled=led[31:24];
endmodule