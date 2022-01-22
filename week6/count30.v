module count30(input clk,rst,output [7:0] outled);
    reg [29:0] led;
    always @(posedge clk,posedge rst)
    begin
        if (rst == 1) led<=30'b00_0000_0000_0000_0000_0000_0000_0000;
        else led<=led + 30'b00_0000_0000_0000_0000_0000_0000_0001;
    end
    assign outled=led[29:22];
endmodule