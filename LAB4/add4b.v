module add4b(
        input [3:0] x,
        input [3:0] y,
        input ci,
        output co,
        output [3:0] z
);
  wire c1, c2, c3;
  fac inst0 (.x(x[0]), .y(y[0]), .ci(ci), .co(c1), .z(z[0]));
  fac inst1 (.x(x[1]), .y(y[1]), .ci(c1), .co(c2), .z(z[1]));
  fac inst2 (.x(x[2]), .y(y[2]), .ci(c2), .co(c3), .z(z[2]));
  fac inst3 (.x(x[3]), .y(y[3]), .ci(c3), .co(c0), .z(z[3]));
endmodule

module add4b_tb;
  reg [3:0] x, y;
  reg ci;
  wire [3:0] z;
  wire co;
  
  add4b add4b_i(.x(x), .y(y), .z(z), .co(co));
  
  integer k;
  
  initial begin
    {x, y, ci} = 0;
    
    $display("time\tx\ty\tci\tz\tco");
    $monitor("%4b\t%4b\t%b\t%4b\t%b\t", x, y, ci, z, co);
    
    for(k = 1; k < 512; k = k+1)
      #20 {x, y, ci} = k;
    #20;
  end
endmodule        