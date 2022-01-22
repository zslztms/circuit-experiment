`timescale 1ns / 1ps


module forwardunit(
input regwriteW,regwriteM,[4:0] ra1E,ra2E,waW,waM,
output reg [1:0] frs1,frs2
);
always@(*)
begin
    if(regwriteM & (waM!=0) & (waM == ra1E)) 
    begin
        frs1 = 2'b01;
    end
    else if(regwriteW & (waW!=0) & (waW == ra1E)) 
    begin
        frs1 = 2'b10;
    end
    else
    begin
        frs1 = 2'b00;
    end

    if(regwriteM & (waM!=0) & (waM == ra2E)) 
    begin
        frs2 = 2'b01;
    end
    else if(regwriteW & (waW!=0) & (waW == ra2E)) 
    begin
        frs2 = 2'b10;
    end
    else
    begin
        frs2 = 2'b00;
    end
end
endmodule

module hazardunit(
input comp,[4:0] waE,ra1D,ra2D,[6:0] opcodeE,
output reg pc_if_id_en,if_id_flush,id_ex_flush
);
always@(*)
begin
    //load-use hazard
    if (opcodeE==7'b0000011 & ((waE==ra1D)|(waE==ra2D)) & waE!=0)
    begin
        pc_if_id_en=0;
        if_id_flush=0;
        id_ex_flush=1;
    end
    //branch hazard AND jal !!!(don't forget jal must flush too !)
    else if((opcodeE==7'b1100011& comp) | (opcodeE==7'b1101111))
    begin
        pc_if_id_en=1;
        if_id_flush=1;
        id_ex_flush=1;
    end
    else
    begin
        pc_if_id_en=1;
        if_id_flush=0;
        id_ex_flush=0;
    end
end

endmodule
