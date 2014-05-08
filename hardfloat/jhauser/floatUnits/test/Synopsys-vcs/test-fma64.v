
`define round_nearest_even 2'b00

module test;

    reg  [63:0] a, b, c;
    wire [64:0] recodedA, recodedB, recodedC, recodedZ;
    wire [4:0]  exceptionFlags;
    wire [63:0] z;
    reg  [63:0] z_exp;
    reg  [7:0] flagsExp;
    integer count;

    float64ToRecodedFloat64 recodeA( a, recodedA );
    float64ToRecodedFloat64 recodeB( b, recodedB );
    float64ToRecodedFloat64 recodeC( c, recodedC );
    mulAddSubRecodedFloat64
        mulAddSubRecodedFloat64(
            2'b00,
            recodedA,
            recodedB,
            recodedC,
            `round_nearest_even,
            recodedZ,
            exceptionFlags
        );
    recodedFloat64ToFloat64 recodeZ( recodedZ, z );

    initial begin
	$vcdpluson;
	#10;
	$vcdplusoff;
    end

    always begin
	count = $fscanf('h80000000, "%x %x %x %x %x", a, b, c, z_exp, flagsExp);
	if (count < 5) $finish;
 
        #1;
	$display("%x %x %x %x %x", a, b, c, z, exceptionFlags);
        #1;

    end

endmodule

