module mux2s #(
        parameter w = 8
        )(
        input [w-1:0] d0, d1, d2, d3,
        input [1:0] s,
        output [w-1:0] o
        );                              
  assign o = s[1] ? (s[0] ? d3:d2) : (s[0] ? d1:d0);
  
endmodule

module mux2s_tb; //w=3
  reg [2:0] d0, d1, d2, d3;
  reg [1:0] s;
  wire [2:0] o;
  
  mux2s #(.w(3)) inst1(.d0(d0), .d1(d1), .d2(d2), .d3(d3), .s(s), .o(o));
  
  integer k;
  initial begin
    
    $display("time\td0\td1\td2\td3\ts\to");
    $monitor("%4t\t%b\t%b\t%b\t%b\t%b\t%b",$time,d0,d1,d2,d3,s,o);
    
    {d0, d1, d2, d3, s} = 0; //14 biti
    repeat(999)
      #20 {d0, d1, d2, d3, s} = $urandom_range(1,16383);
    #20;
  end
endmodule