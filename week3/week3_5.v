module d_ff_synrst_high(input d,c,rst,output q,q_n);
always @(posedge c)
begin
    if (rst==1){
        q<=0;
        q_n<=1;
    }
    else{
        q<=d;
        q_n<=~d;
    }
end
endmodule

module d_ff_asynrst_high(input d,c,rst,output reg q,q_n);
always @(posedge c,posedge rst)
begin
    if (rst==1){
        q<=0;
        q_n<=1;
    }
    else{
        q<=d;
        q_n<=~d;
    }
end
endmodule