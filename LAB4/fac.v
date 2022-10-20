module fac(
        input x, y, ci,
        output co, z
);
        assign z = x ^ y ^ ci;
        assign co = x&y | x&ci | y&ci;
endmodule

module fac_tb;
        reg x, y, ci;
        wire co, z;
        
        fac fac_i(.x(x), .y(y), .ci(ci), .co(co), .z(z));
        
        integer k;
        initial begin
                $display("time\tx\ty\tci\tco\tz");
                $monitor("%1t\t%b\t%b\t%b\t%b\t%b", $time, x, y, ci, co, z);
                {x, y, ci} = 0; //3biti
                for(k = 1; k < 8; k = k + 1)
                  #30 {x, y, ci} = k;
                #30;
        end
endmodule