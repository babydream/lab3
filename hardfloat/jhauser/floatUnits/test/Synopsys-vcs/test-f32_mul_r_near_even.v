
`define round_nearest_even 2'b00

//*** MOVE TO A HEADER?
extern "C" void readHex_ui32_sp( output bit [31:0] );
extern "C" void readHex_ui32_n( output bit [31:0] );
extern "C" void writeHex_ui8_sp( input bit [31:0] );
extern "C" void writeHex_ui32_sp( input bit [31:0] );
extern "C" void writeHex_ui8_n( input bit [31:0] );
extern "C" void writeHex_ui32_n( input bit [31:0] );


module test;

    reg  [31:0] a, b;
    wire [32:0] recodedA, recodedB, recodedZ;
    wire [4:0] exceptionFlags;
    wire [31:0] z;

    float32ToRecodedFloat32 recodeA( a, recodedA );
    float32ToRecodedFloat32 recodeB( b, recodedB );
    mulRecodedFloat32
        mulRecodedFloat32(
            recodedA, recodedB, `round_nearest_even, recodedZ, exceptionFlags
        );
    recodedFloat32ToFloat32 recodeZ( recodedZ, z );

    always begin

        readHex_ui32_sp( a );
        readHex_ui32_n( b );
        #1;
        writeHex_ui32_sp( a );
        writeHex_ui32_sp( b );
        writeHex_ui32_sp( z );
        writeHex_ui8_n( exceptionFlags );
        #1;

    end

endmodule

