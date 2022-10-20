module cordic(
  input clk, rst_b, bgn,
  input [15:0] theta,
  output [15:0] cos,
  output fin
  );
  
  function [15:0] MUX(input s, input [15:0] d1,d0);
    begin
      MUX = (s) ? d1:d0;
    end
  endfunction
  
  function [15:0] ArRSh(input[15:0] i, input [3:0] p);
    reg [31:0] t;
    begin
      t = {{16{i[15]}},i} >> p;
      ArRSh = t[15:0];
    end
  endfunction
  
  function [15:0] AddSub(input add, input [15:0] a,b);
    begin
      AddSub = MUX(add,a+b,a-b);
    end
  endfunction
  
  wire [15:0] x,y,z,k;
  wire [3;0] itr;
  wire init, ld;
  
  rgst #(.w(16)) i0(.clk(clk), .rst_b(rst_b), .clr(1'd0), .ld(ld),
    .q(x), .d(MUX(init,16'h25dd,AddSub(z[15],x,ArRSh(y,itr)))));
    
  rgst #(.w(16)) i1(.clk(clk), .rst_b(rst_b), .clr(1'd0), .ld(ld),
    .q(x), .d(MUX(init,16'h25dd,AddSub(z[15],x,ArRSh(y,itr)))));
    
  cntr #(.w(4)) i2(/..../);
  
  cordicctrl i3(/..../);
  
  rgst #(.w(16)) i4(.clk(clk), .rst_b(rst_b), .clr(1'd0), .ld(ld),
    .q(x), .d(MUX(init,16'h25dd,AddSub(z[15],x,ArRSh(y,itr)))));
    
  rom #(.aw(4), .dw(16), .file("cordic_atan.txt")) i5(.clk(~clk),
    .rst_b(rst_b), addr(itr), .data(k));
    
  assign cos = x;
endmodule

module cordic_tb;
  reg clk, rst_b, bgn,
  reg [15:0] theta,
  wire [15:0] cos,
  wire fin;
  
  function real ToRad(input real deg);
    begin
      ToRad = deg * 3.14159265359/180.0;
    end
  endfunction
  
  function ToInt(input real r);
    begin
      ToInt = $rtoi(r * (2**14));
    end
  endfunction
endmodule