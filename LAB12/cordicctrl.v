module cordicctrl(
  input clk, rst_b, bgn,
  input [3:0] itr,
  output ld, init, fin
  );
  
  localparam WAIT = 2'd0;
  localparam EXEC = 2'd1;
  localparam END = 2'd2;
  
  reg [1:0] st;
  reg [1:0] st_nxt;
  
  always @(*)
    case(st)
      WAIT: if(!bgn) st_nxt = WAIT;
        else st_nxt = EXEC;
      EXEC: if(&itr) st_nxt = END;
        else st_nxt = EXEC;
      END: st_nxt = WAIT;
    endcase
  
  assign ld = (st == WAIT & bgn) | (st == EXEC);
  assign init = st == WAIT & bgn;
  assign fin = (st == END);
  
  always @(posedge clk, negedge rst_b)
    if(!rst_b) st <= WAIT;
    else  st <= st_nxt;
  
endmodule

module cordicctrl_tb;
  reg clk,rst_b,bgn;
  reg [3:0] itr;
  wire ld, init, fin;
  
  cordicctrl inst(.clk(clk), .rst_b(rst_b), .bgn(bgn), .itr(itr), .ld(ld), .init(init), .fin(fin));
  
  localparam CLK_PERIOD=100, RUNNING_CYCLES=17, RST_DURATION=25;
  initial begin
    clk=0;
    repeat (2*RUNNING_CYCLES) #(CLK_PERIOD/2) clk=~clk;
  end
  
  initial begin
    rst_b=0;
    #RST_DURATION rst_b=1;
  end
  
  initial begin
    bgn = 1;
    #(CLK_PERIOD) bgn = ~bgn;
  end
  
  initial begin
    itr = 0;
    repeat (RUNNING_CYCLES) #(CLK_PERIOD) itr = itr + 1;
  end
endmodule