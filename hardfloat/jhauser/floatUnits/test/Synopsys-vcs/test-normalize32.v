
//*** MOVE TO A HEADER?
extern "C" void readHex_ui32_sp( output bit [31:0] );
extern "C" void readHex_ui32_n( output bit [31:0] );
extern "C" void writeHex_ui8_sp( input bit [31:0] );
extern "C" void writeHex_ui32_sp( input bit [31:0] );
extern "C" void writeHex_ui8_n( input bit [31:0] );
extern "C" void writeHex_ui32_n( input bit [31:0] );


module test;

    reg  [31:0] a;
    wire [4:0]  count;
    wire [31:0] z;

    normalize32 normalize32( a, count, z );

    always begin

        readHex_ui32_n( a );
        #1;
        writeHex_ui8_sp( count );
        writeHex_ui32_n( z );
        #1;

    end

endmodule

