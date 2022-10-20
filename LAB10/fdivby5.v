module fdivby5(
  input clr, rst_b, c_up, clk,
  output fdclk
  );
  wire [2:0] d;
  wire [2:0] q;
  wire clr_rgst;
  
  rgst #(.w(3)) inst1(.clk(clk), .rst_b(rst_b), .ld(c_up), .clr(clr | q[2]), .d(d), .q(q)); 
  
  assign d[0] = ~q[0];
  assign d[1] = q[1] ^ q[0];
  assign d[2] = q[2] ^ (q[1] & q[0]);
  
  assign fdclk = ~(|q);
endmodule

module fdivby5_tb;
  reg clr, rst_b, c_up, clk;
  wire fdclk;
  
  fdivby5 inst1(.clk(clk), .clr(clr), .rst_b(rst_b), .c_up(c_up), .fdclk(fdclk));
  
  localparam CLK_PERIOD = 100, RUNNING_CYCLES = 15, RST_DURATION = 25;
  
  initial begin
    c_up = 1;
    rst_b = 0;
    #RST_DURATION rst_b = ~rst_b;
  end
  
  initial begin
    $display("time\tclk\trst_b\tclr\tc_up\tfdclk");
    $monitor("%5t\t%b\t%b\t%b\t%b\t%b",$time, clk, rst_b, clr, c_up, fdclk);
    clk = 0;
    repeat(RUNNING_CYCLES * 2) #(CLK_PERIOD / 2) clk = ~clk;
  end
  
  initial begin
    clr = 0;
    #(6 * CLK_PERIOD) clr = ~clr;
    #(1 * CLK_PERIOD) clr = ~clr;
    #(5 * CLK_PERIOD) clr = ~clr;
    #(1 * CLK_PERIOD) clr = ~clr;
  end
  
endmodule