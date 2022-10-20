module rom #(parameter aw = 10, dw = 8, file = "rom_file_with_hex_content.txt")(
  input clk, rst_b,
  input[aw - 1:0] addr,
  output reg [dw - 1:0] data
  );
  reg [dw - 1:0] mem[0:2**aw - 1];
  initial
    $readmemh(file, mem, 0, 2**aw - 1);
    
  always @(posedge clk, negedge rst_b)
    if(rst_b == 0) data <= 0;
    else data <= mem[addr];
  
endmodule

module rom_tb;
  reg clk,rst_b;
  reg [9:0] addr;
  wire [7:0] data;
  
  rom inst(.clk(clk), .rst_b(rst_b), .addr(addr), .data(data));
  
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
    addr = 0;
    repeat (RUNNING_CYCLES) #(CLK_PERIOD) addr = itr + 1;
  end
endmodule