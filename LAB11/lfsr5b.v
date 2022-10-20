module lfsr5b(
  input clk, rst_b,
  output [4:0] q
  );

  d_ff inst1(.set_b(rst_b), .rst_b(1'd1), .d(q[4]), .clk(clk), .q(q[0]));
  d_ff inst2(.set_b(rst_b), .rst_b(1'd1), .d(q[0]), .clk(clk), .q(q[1]));
  d_ff inst3(.set_b(rst_b), .rst_b(1'd1), .d(q[4] ^ q[1]), .clk(clk), .q(q[2]));
  d_ff inst4(.set_b(rst_b), .rst_b(1'd1), .d(q[2]), .clk(clk), .q(q[3]));
  d_ff inst5(.set_b(rst_b), .rst_b(1'd1), .d(q[3]), .clk(clk), .q(q[4]));

endmodule

module lfsr5b_tb;
  
  reg clk,rst_b;
  wire [4:0] q;
  
  localparam CLK_PERIOD = 100, RUNNING_CYCLES = 35, RST_DURATION = 25;
  
  lfsr5b inst(.clk(clk), .rst_b(rst_b), .q(q));
  
  initial begin
    clk = 0;
    repeat(2 * RUNNING_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
  end
  
  initial begin
    rst_b = 0;
    #(RST_DURATION) rst_b = ~rst_b;
  end
  
endmodule