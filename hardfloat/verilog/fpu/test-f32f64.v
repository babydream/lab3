
`define round_nearest_even 2'b00

module test;

    reg  [31:0] a;
    wire [4:0]  exceptionFlags;
    wire [63:0] z;
    reg  [63:0] z_exp;
    reg  [4:0] flagsExp;
    integer count;

    fpu_tst_f32_to_f64
        fpu_tst_f32_to_f64(
            .io_in(a),
            .io_out(z),
            .io_exception_flags(exceptionFlags)
        );

   always begin
      count = $fscanf('h80000000, "%x %x %x", a, z_exp, flagsExp);
      if (count < 3) $finish(0);
      #1;
      $display("%x %x %x", a, z, exceptionFlags);
      #1;
   end

endmodule
