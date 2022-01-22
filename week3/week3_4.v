`include week3_3.v
module bit4_10minus(input c,rst_n,output q[0:3]);
reg q_[0:3];
always @(q)
begin
    if (q==4'b0000){
        q_=4'b1001;
    }
    else{
        q_=q-4'b0001;
    }
end
reg4 r0(q_,c,rst_n,q);
endmodule