module mlopadd(
  input clk, rst, b,
  input [7:0] x,
  output [31:0] a
  );
  
  wire [7:0] impar;
  
  rgst #(.w(8)) inst1(.clk(clk), .rst(rst_b), .clr(1'd0), .ld(1'd1), .d(x), .q(impar));
  rgst #(.w(32)) inst2(.clk(clk), .rst(rst_b), .clr(1'd0), .ld(1'd1), .d(a + impar), .q(a));
  
endmodule

module mlopadd_tb;
  reg vlk,rst;
  reg [7:0] x;
  reg[31:0] a;
  mlopadd inst(.clk(clk), .rst(rst), .x(x), .a(a));
  localparam CLK_PERIOD = 100, RUNNING_CYCLES = 101, RST_DURATION = 25;
  
  initial begin
    //$display("time
    clk = 0;
    repeat(2 * RUNNING_CYCLES) #(CLK_PERIOD / 2) clk = ~clk;
  end
  initial begin
    rst = 0;
    #RST_DURATION rst = 1;
  end
  integer k;
  initial begin
    x = 1;
    for(k = 3; k < 200; k = k+2)
      #CLK_PERIOD x = k;
  end
endmodule