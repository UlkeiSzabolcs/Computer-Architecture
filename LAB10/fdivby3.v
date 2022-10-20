module fdivby3(
  input clk, rst_b, clr, c_up,
  output fdclk
  );
  
  localparam S0 = 0;
  localparam S1 = 1;
  localparam S2 = 2;
  
  reg [2:0] st;
  wire [2:0] st_nxt;
  
  assign st_nxt[S0] = (st[S0] & ((~c_up) | clr)) | 
                      (st[S2] & (c_up | clr)) | 
                      (st[S1] & clr);
  assign st_nxt[S1] = (st[S1] & (~(c_up | clr))) | 
          	           (st[S0] & (c_up & (~clr)));
  assign st_nxt[S2] = (st[S2] & (~(c_up | clr))) | 
                      (st[S1] & (c_up & (~clr)));
  
  assign fdclk = st[S0];
  
  always @ (posedge clk, negedge rst_b)
    if(~rst_b) begin
      st <= 0;
      st[S0] = 1;
    end else 
      st <= st_nxt;
  
endmodule

module fdivby3_tb;
  reg clr, rst_b, c_up, clk;
  wire fdclk;
  
  fdivby3 inst1(.clk(clk), .clr(clr), .rst_b(rst_b), .c_up(c_up), .fdclk(fdclk));
  
  localparam CLK_PERIOD = 100, RUNNING_CYCLES = 17, RST_DURATION = 25;
  
  initial begin
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
    #(4 * CLK_PERIOD) clr = ~clr;
    #(1 * CLK_PERIOD) clr = ~clr;
  end
  
  initial begin
    c_up = 1;
    #(6 * CLK_PERIOD) c_up = ~c_up;
    #(1 * CLK_PERIOD) c_up = ~c_up;
    #(4 * CLK_PERIOD) c_up = ~c_up;
    #(2 * CLK_PERIOD) c_up = ~c_up;
  end
  
endmodule