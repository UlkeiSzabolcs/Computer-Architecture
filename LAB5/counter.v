module counter #(
  parameter w = 8
  )(
  input clk, rst,c_up,c_dn,
  output reg [w-1:0] q
  );
  
  always @ (posedge clk, rst) begin
    if(rst == 0)
      q <= 0;
    else if(c_up == 1 && clk == 1)
      q <= q + 2;
    else if(c_dn == 1 && clk == 1)
      q <= q - 1;
  end
endmodule

module counter_tb; //w=3
  reg clk, rst, c_up, c_dn;
  wire [2:0] q;
  
  localparam CLK_PERIOD = 10;
  localparam RUNNING_CYCLES = 14;
  
  counter #(.w(3)) inst1(.clk(clk), .rst(rst), .c_up(c_up), .c_dn(c_dn), .q(q));
  
  initial begin
    clk = 0;
    repeat(2 * RUNNING_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
  end
  
  initial begin
    c_up = 1;
    #CLK_PERIOD c_up = ~c_up;
    #(2*CLK_PERIOD) c_up = ~c_up;
    #(4*CLK_PERIOD) c_up = ~c_up;
    #(5*CLK_PERIOD) c_up = ~c_up;
  end
  
  initial begin
    c_dn = 0;
    #(2*CLK_PERIOD) c_dn = ~c_dn;
    #(2*CLK_PERIOD) c_dn = ~c_dn;
    #(3*CLK_PERIOD) c_dn = ~c_dn;
    #(5*CLK_PERIOD) c_dn = ~c_dn;
  end
  
  initial begin
    rst = 0;
    #2 rst = ~rst;
  end
  
endmodule