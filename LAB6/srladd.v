module srladd(
  input clk, rst, x, y,
  output z
  );
    localparam S0 = 0, S1 = 1;
    reg st, st_next;
    always @(*)
      case(st)
        S0: if(x == 0 && y == 0) st_next = S0;
            else if(x == 0 && y == 1) st_next = S0;
            else if(x == 1 && y == 0) st_next = S0;
            else if(x == 1 && y == 1) st_next = S1;
        S1: if(x == 0 && y == 0) st_next = S0;
            else if(x == 0 && y == 1) st_next = S1;
            else if(x == 1 && y == 0) st_next = S1;
            else if(x == 1 && y == 1) st_next = S1;
    endcase
    
    assign z = x^y^st;
    
    always @(posedge clk, negedge rst) begin
      if(~rst) st <= S0;
      else st <= st_next;
    allend
endmodule

module srladd_tb();
  reg clk,rst,x,y;
  wire z;
  
  srladd inst1(.clk(clk), .rst(rst), .x(x), .y(y), .z(z));
  
  localparam clk_period = 40;
  localparam rst_duration = 10;
  localparam rn_cycles = 5;
  
  initial begin
    rst = 0;
    #rst_duration rst = ~rst;
  end
  
  initial begin
    clk = 0;
    repeat(2 * rn_cycles) #(clk_period / 2) clk = ~clk;
  end
  
  initial begin
    x = 0;
    repeat(5) #clk_period x = ~x;
  end
  
  initial begin
    y = 0;
    #(2*clk_period) y = ~y;
    #(2*clk_period) y = ~y;
  end
endmodule