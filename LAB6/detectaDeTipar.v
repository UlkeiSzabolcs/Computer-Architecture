module detectaDeTipar(
  input clk, rst, i,
  output o
  );
  
  localparam S0 = 3'd0;
  localparam S1 = 3'd1;
  localparam S2 = 3'd2;
  localparam S3 = 3'd3;
  localparam S4 = 3'd4;
  localparam S5 = 3'd5;
  
  reg[2:0] st = 0;
  reg[2:0] st_next;
  
  always @ (*)
    case(st)
      S0: if(i == 0) st_next = S1;
          else st_next = S0;
      S1: if(i == 1) st_next = S2;
          else st_next = S0;
      S2: if(i == 1) st_next = S3;
          else st_next = S0;
      S3: if(i == 0) st_next = S4;
          else st_next = S0;
      S4: if(i == 1) st_next = S5;
          else st_next = S1;
      S5: if(i == 0) st_next = S1;
          else st_next = S3;
    endcase
assign o = (st == S5);
always begin @ (posedge clk, negedge rst)
  if(~rst) st <= S0;
  else st <= st_next;
end

endmodule

module detectaDeTipar_tb();
  reg clk,rst,i;
  wire o;
  
  detectaDeTipar inst1(.clk(clk), .rst(rst), .i(i), .o(o));
  
  localparam clk_period = 20;
  localparam rst_period = 2;
  localparam rn_cycles = 12;
  
  initial begin
    rst = 0;
    #rst_period rst = ~rst;
  end
  
  initial begin
    clk = 0;
    repeat(2 * rn_cycles) #(clk_period / 2) clk = ~clk;
  end
  
  initial begin
    i = 1;
    #clk_period i = ~i;
    #clk_period i = ~i;
    #(2*clk_period) i = ~i;
    #clk_period i = ~i;
    #(2*clk_period) i = ~i;
    #clk_period i = ~i;
    #(2*clk_period) i = ~i;
    #clk_period i = ~i;
    
  end
  
endmodule