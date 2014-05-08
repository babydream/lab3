
`define round_nearest_even 2'b00

//*** MOVE TO A HEADER?
extern "C" void readHex_ui64_sp( output bit [63:0] );
extern "C" void readHex_ui64_n( output bit [63:0] );
extern "C" void writeHex_ui8_sp( input bit [31:0] );
extern "C" void writeHex_ui64_sp( input bit [63:0] );
extern "C" void writeHex_ui8_n( input bit [31:0] );
extern "C" void writeHex_ui64_n( input bit [63:0] );


module test;

    reg  [63:0] a, b;
    wire [64:0] recodedA, recodedB, recodedZ;
    wire [4:0]  exceptionFlags;
    wire [63:0] z;

    float64ToRecodedFloat64 recodeA( a, recodedA );
    float64ToRecodedFloat64 recodeB( b, recodedB );
    mulRecodedFloat64
        mulRecodedFloat64(
            recodedA, recodedB, `round_nearest_even, recodedZ, exceptionFlags
        );
    recodedFloat64ToFloat64 recodeZ( recodedZ, z );

    always begin

        readHex_ui64_sp( a );
        readHex_ui64_n( b );
        #1;
        writeHex_ui64_sp( a );
        writeHex_ui64_sp( b );
        writeHex_ui64_sp( z );
        writeHex_ui8_n( exceptionFlags );
        #1;

    end

endmodule

