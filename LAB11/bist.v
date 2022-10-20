module bist(
  input clk, rst_b,
  output [3:0] sig
  );
  
  wire [4:0] q;
  wire i;
  
  lfsr5b inst1(.clk(clk), .rst_b(rst_b), .q(q));
  check inst2(.i(q), .o(i));
  sisr4b inst3(.clk(clk), .rst_b(rst_b), .i(i), .q(sig));
  
endmodule

module bist_tb;
  
  reg clk,rst_b;
  wire [3:0] sig;
  
  localparam CLK_PERIOD = 100, RUNNING_CYCLES = 31, RST_DURATION = 25;
  
  bist inst(.clk(clk), .rst_b(rst_b), .sig(sig));
  
  initial begin
    clk = 0;
    repeat(2 * RUNNING_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
  end
  
  initial begin
    rst_b = 0;
    #(RST_DURATION) rst_b = ~rst_b;
  end
  
endmodule