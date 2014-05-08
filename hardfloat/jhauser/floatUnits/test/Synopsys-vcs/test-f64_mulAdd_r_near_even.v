
`define round_nearest_even 2'b00

//*** MOVE TO A HEADER?
extern "C" void readHex_ui64_sp( output bit [63:0] );
extern "C" void readHex_ui64_n( output bit [63:0] );
extern "C" void writeHex_ui8_sp( input bit [31:0] );
extern "C" void writeHex_ui64_sp( input bit [63:0] );
extern "C" void writeHex_ui8_n( input bit [31:0] );
extern "C" void writeHex_ui64_n( input bit [63:0] );


module test;

    reg  [63:0] a, b, c;
    wire [64:0] recodedA, recodedB, recodedC, recodedZ;
    wire [4:0]  exceptionFlags;
    wire [63:0] z;

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

    always begin

        readHex_ui64_sp( a );
        readHex_ui64_sp( b );
        readHex_ui64_n( c );
        #1;
        writeHex_ui64_sp( a );
        writeHex_ui64_sp( b );
        writeHex_ui64_sp( c );
        writeHex_ui64_sp( z );
        writeHex_ui8_n( exceptionFlags );
        #1;

    end

endmodule

