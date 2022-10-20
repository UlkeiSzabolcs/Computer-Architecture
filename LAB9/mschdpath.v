module mschdpath(
  input clk,rst_b,ld_mreg,upd_mreg,
  input [511:0] blk,
  output [31:0] m0
);
  function [31:0] MUX(input s, input [31:0] d1,d0);
    begin
      MUX=(s) ? d1 : d0;
    end
  endfunction
  function [31:0] RotireDr(input [31:0] x, input [4:0] p);
    reg [63:0] t;
    begin
      t={x,x} >> p;
      RotireDr=t[31:0];
    end
  endfunction
  function [31:0] Sigma0(input [31:0] x);
    begin
      Sigma0=RotireDr(x,7) ^ RotireDr(x,18) ^ (x >> 3);
    end
  endfunction
  function [31:0] Sigma1(input [31:0] x);
    begin
      Sigma1=RotireDr(x,17) ^ RotireDr(x,19) ^ (x >> 10);
    end
  endfunction
  wire [31:0] m[16]; //m[0] ... m[15]
  generate
    genvar i;
    for (i=0; i<16; i=i+1) begin:v
      if (i < 15)
        rgst #(.w(32)) gu(.clk(clk),.rst_b(rst_b),.clr(1'd0),.ld(upd_mreg),.q(m[i])
           .d(MUX(ld_mreg,blk[511-32*i:480-32*i],m[i+1])));
      else
        rgst #(.w(32)) gu(.clk(clk),.rst_b(rst_b),.clr(1'd0),.ld(upd_mreg),.q(m[i])
           .d(MUX(ld_mreg,blk[511-32*i:480-32*i],m[0]+Sigma0(m[1])+m[9]+Sigma1(m[14]))));
    end
  endgenerate
  assign m0=m[0];
endmodule