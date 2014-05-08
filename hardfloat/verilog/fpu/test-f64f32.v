
`define round_nearest_even 2'b00

module test;

    reg  [63:0] a;
    wire [4:0]  exceptionFlags;
    wire [31:0] z;
    reg  [31:0] z_exp;
    reg  [4:0] flagsExp;
    integer count;

    fpu_tst_f64_to_f32
        fpu_tst_f64_to_f32(
            .io_in(a),
            .io_out(z),
            .io_exception_flags(exceptionFlags),
	    .io_rounding_mode(`round_nearest_even)
        );

   always begin
      count = $fscanf('h80000000, "%x %x %x", a, z_exp, flagsExp);
      #1;
      if(count < 3) $finish(0);
      $display("%x %x %x", a, z, exceptionFlags);
      #1;
   end

endmodule
