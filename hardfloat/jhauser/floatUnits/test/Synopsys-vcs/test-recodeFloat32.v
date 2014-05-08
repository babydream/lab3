
//*** MOVE TO A HEADER?
extern "C" void readHex_ui32_sp( output bit [31:0] );
extern "C" void readHex_ui32_n( output bit [31:0] );
extern "C" void writeHex_ui8_sp( input bit [31:0] );
extern "C" void writeHex_ui32_sp( input bit [31:0] );
extern "C" void writeHex_ui8_n( input bit [31:0] );
extern "C" void writeHex_ui32_n( input bit [31:0] );


module test;

    reg  [31:0] a;
    wire [32:0] recoded;
    wire [31:0] z;

    float32ToRecodedFloat32 recodeIn( a, recoded );
    recodedFloat32ToFloat32 recodeOut( recoded, z );

    always begin

        readHex_ui32_n( a );
        #1;
        writeHex_ui32_sp( a );
        writeHex_ui32_sp( z );
        writeHex_ui8_n( a == z );
        #1;

    end

endmodule

