module check(
  input [4:0] i,
  output o
  );
  
  assign o = i[0] & (~i[1]);
  
endmodule