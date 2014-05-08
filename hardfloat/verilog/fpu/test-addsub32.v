
`define round_nearest_even 2'b00

module test;

    reg  [31:0] a, b;
    wire [4:0]  exceptionFlags;
    wire [31:0] z;
    reg  [31:0] z_exp;
    reg  [4:0] flagsExp;
    integer count;

    fpu_tst_addsub32
        fpu_tst_addsub32(
            .io_a(a),
	    .io_b(b),
	    .io_rounding_mode(`round_nearest_even),
	    .io_op(1'b0),
            .io_out(z),
            .io_exception_flags(exceptionFlags)
        );

   always begin
      count = $fscanf('h80000000, "%x %x %x %x", a, b, z_exp, flagsExp);
      if (count < 3) $finish(0);
      #1;
      $display("%x %x %x %x", a, b, z, exceptionFlags);
      #1;
   end

endmodule
