module d_ff_synset(input d,c,set,output reg q,q_n);
always @(posedge c)
begin
    if (set==1){
        q<=1;
        q_n<=0;
    }
    else{
        q<=d;
        q_n<=~d;
    }
end
endmodule