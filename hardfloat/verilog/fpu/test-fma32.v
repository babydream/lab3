
`define round_nearest_even 2'b00

module test;

    reg  [31:0] a, b, c;
    wire [4:0]  exceptionFlags;
    wire [31:0] z;
    reg  [31:0] z_exp;
    reg  [7:0] flagsExp;
    integer count;

    fpu_tst_muladd32
        fpu_tst_muladd32(
            .io_op(1'b0),
            .io_rounding_mode(`round_nearest_even),
            .io_a(a),
	    .io_b(b),
	    .io_c(c),
            .io_out(z),
            .io_exception_flags(exceptionFlags)
        );

   //initial begin
   //   $vcdpluson;
   //   #10;
   //   $vcdplusoff;
   //end
   always begin
      count = $fscanf('h80000000, "%x %x %x %x %x", a, b, c, z_exp, flagsExp);
      if (count < 5) $finish(0);
      #1;
      $display("%x %x %x %x %x", a, b, c, z, exceptionFlags);
      #1;
   end

endmodule
