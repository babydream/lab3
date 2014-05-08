
/*============================================================================

This C source file is part of the SoftFloat IEC/IEEE Floating-point Arithmetic
Package, Release 2b.

Written by John R. Hauser.

THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort has
been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT TIMES
RESULT IN INCORRECT BEHAVIOR.  USE OF THIS SOFTWARE IS RESTRICTED TO PERSONS
AND ORGANIZATIONS WHO CAN AND WILL TAKE FULL RESPONSIBILITY FOR ALL LOSSES,
COSTS, OR OTHER PROBLEMS THEY INCUR DUE TO THE SOFTWARE, AND WHO FURTHERMORE
EFFECTIVELY INDEMNIFY THE AUTHOR, JOHN HAUSER, (possibly via similar legal
warning) AGAINST ALL LOSSES, COSTS, OR OTHER PROBLEMS INCURRED BY THEIR
CUSTOMERS AND CLIENTS DUE TO THE SOFTWARE.

Derivative works are acceptable, even for commercial purposes, so long as
(1) the source code for the derivative work includes prominent notice that
the work is derivative, and (2) the source code includes prominent notice with
these four paragraphs for those parts of this code that are retained.

=============================================================================*/

#include <stdbool.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "fail.h"
#include "softfloat.h"
#include "functions.h"

enum { minIterations = 1000 };

static const char *functionNamePtr;
#ifdef FLOATX80
static int_fast8_t roundingPrecision;
#endif
static int_fast8_t roundingCode;
static int_fast8_t tininessCode;
static bool usesExact;
static int_fast8_t exact;

static void reportTime( int_fast64_t count, clock_t clockTicks )
{
    static const char *roundingModeNames[ NUM_ROUNDINGMODES ] = {
        0,
        ", rounding nearest/even",
        ", rounding toward zero (minMag)",
        ", rounding down (min)",
        ", rounding up (max)",
        ", rounding nearest/away (nearest_maxMag)"
    };

    printf(
        "%9.4f Mop/s: %s",
        count / ( (float) clockTicks / CLOCKS_PER_SEC ) / 1000000,
        functionNamePtr
    );
    if ( roundingCode ) {
#ifdef FLOATX80
        if ( roundingPrecision ) {
            printf( ", precision %d", (int) roundingPrecision );
        }
#endif
        fputs( roundingModeNames[ roundingCode ], stdout );
        if ( tininessCode ) {
            fputs(
                ( tininessCode == TININESS_BEFORE_ROUNDING )
                    ? ", tininess before rounding"
                    : ", tininess after rounding",
                stdout
            );
        }
    }
    if ( usesExact ) fputs( exact ? ", exact" : ", not exact", stdout );
    fputc( '\n', stdout );
    fflush( stdout );

}

union ui32_f32 { uint32_t ui; float32_t f; };
union ui64_f64 { uint64_t ui; float64_t f; };

enum { numInputs_ui32 = 32 };

static const uint32_t inputs_ui32[ numInputs_ui32 ] = {
    0x00004487, 0x405CF80F, 0x00000000, 0x000002FC,
    0x000DFFFE, 0x0C8EF795, 0x0FFFEE01, 0x000006CA,
    0x00009BFE, 0x00B79D1D, 0x60001002, 0x00000049,
    0x0BFF7FFF, 0x0000F37A, 0x0011DFFE, 0x00000006,
    0x000FDFFA, 0x0000082F, 0x10200003, 0x2172089B,
    0x00003E02, 0x000019E8, 0x0008FFFE, 0x000004A4,
    0x00208002, 0x07C42FBF, 0x0FFFE3FF, 0x040B9F13,
    0x40000008, 0x0001BF56, 0x000017F6, 0x000A908A
};

static void time_a_ui32_z_f32( float32_t function( uint_fast32_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            function( inputs_ui32[ inputNum ] );
            inputNum = ( inputNum + 1 ) & ( numInputs_ui32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        function( inputs_ui32[ inputNum ] );
        inputNum = ( inputNum + 1 ) & ( numInputs_ui32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_a_ui32_z_f64( float64_t function( uint_fast32_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            function( inputs_ui32[ inputNum ] );
            inputNum = ( inputNum + 1 ) & ( numInputs_ui32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        function( inputs_ui32[ inputNum ] );
        inputNum = ( inputNum + 1 ) & ( numInputs_ui32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

enum { numInputs_i32 = 32 };

static const int32_t inputs_i32[ numInputs_i32 ] = {
    -0x00004487,  0x405CF80F,  0x00000000, -0x000002FC,
    -0x000DFFFE,  0x0C8EF795, -0x0FFFEE01,  0x000006CA,
     0x00009BFE, -0x00B79D1D, -0x60001002, -0x00000049,
     0x0BFF7FFF,  0x0000F37A,  0x0011DFFE,  0x00000006,
    -0x000FDFFA, -0x0000082F,  0x10200003, -0x2172089B,
     0x00003E02,  0x000019E8,  0x0008FFFE, -0x000004A4,
    -0x00208002,  0x07C42FBF,  0x0FFFE3FF,  0x040B9F13,
    -0x40000008,  0x0001BF56,  0x000017F6,  0x000A908A
};

static void time_a_i32_z_f32( float32_t function( int_fast32_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            function( inputs_i32[ inputNum ] );
            inputNum = ( inputNum + 1 ) & ( numInputs_i32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        function( inputs_i32[ inputNum ] );
        inputNum = ( inputNum + 1 ) & ( numInputs_i32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_a_i32_z_f64( float64_t function( int_fast32_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            function( inputs_i32[ inputNum ] );
            inputNum = ( inputNum + 1 ) & ( numInputs_i32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        function( inputs_i32[ inputNum ] );
        inputNum = ( inputNum + 1 ) & ( numInputs_i32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#ifdef FLOATX80

static void time_a_i32_z_fx80( floatx80_t function( int_fast32_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            function( inputs_i32[ inputNum ] );
            inputNum = ( inputNum + 1 ) & ( numInputs_i32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        function( inputs_i32[ inputNum ] );
        inputNum = ( inputNum + 1 ) & ( numInputs_i32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#endif

#ifdef FLOAT128

static void time_a_i32_z_f128( float128_t function( int_fast32_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            function( inputs_i32[ inputNum ] );
            inputNum = ( inputNum + 1 ) & ( numInputs_i32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        function( inputs_i32[ inputNum ] );
        inputNum = ( inputNum + 1 ) & ( numInputs_i32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#endif

enum { numInputs_ui64 = 32 };

static const int64_t inputs_ui64[ numInputs_ui64 ] = {
    UINT64_C( 0x04003C0000000001 ),
    UINT64_C( 0x0000000003C589BC ),
    UINT64_C( 0x00000000400013FE ),
    UINT64_C( 0x0000000000186171 ),
    UINT64_C( 0x0000000000010406 ),
    UINT64_C( 0x000002861920038D ),
    UINT64_C( 0x0000000010001DFF ),
    UINT64_C( 0x22E5F0F387AEC8F0 ),
    UINT64_C( 0x00007C0000010002 ),
    UINT64_C( 0x00756EBD1AD0C1C7 ),
    UINT64_C( 0x0003FDFFFFFFFFBE ),
    UINT64_C( 0x0007D0FB2C2CA951 ),
    UINT64_C( 0x0007FC0007FFFFFE ),
    UINT64_C( 0x0000001F942B18BB ),
    UINT64_C( 0x0000080101FFFFFE ),
    UINT64_C( 0x000000000000F688 ),
    UINT64_C( 0x000000000008BFFF ),
    UINT64_C( 0x0000000006F5AF08 ),
    UINT64_C( 0x0021008000000002 ),
    UINT64_C( 0x0000000000000003 ),
    UINT64_C( 0x3FFFFFFFFF80007D ),
    UINT64_C( 0x0000000000000078 ),
    UINT64_C( 0x0007FFFFFF802003 ),
    UINT64_C( 0x1BBC775B78016AB0 ),
    UINT64_C( 0x0006FFE000000002 ),
    UINT64_C( 0x0002B89854671BC1 ),
    UINT64_C( 0x0000010001FFFFE2 ),
    UINT64_C( 0x00000000000FB103 ),
    UINT64_C( 0x07FFFFFFFFFFF7FF ),
    UINT64_C( 0x00036155C7076FB0 ),
    UINT64_C( 0x00000020FBFFFFFE ),
    UINT64_C( 0x0000099AE6455357 )
};

static void time_a_ui64_z_f32( float32_t function( uint_fast64_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            function( inputs_ui64[ inputNum ] );
            inputNum = ( inputNum + 1 ) & ( numInputs_ui64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        function( inputs_ui64[ inputNum ] );
        inputNum = ( inputNum + 1 ) & ( numInputs_ui64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_a_ui64_z_f64( float64_t function( uint_fast64_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            function( inputs_ui64[ inputNum ] );
            inputNum = ( inputNum + 1 ) & ( numInputs_ui64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        function( inputs_ui64[ inputNum ] );
        inputNum = ( inputNum + 1 ) & ( numInputs_ui64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

enum { numInputs_i64 = 32 };

static const int64_t inputs_i64[ numInputs_i64 ] = {
    -INT64_C( 0x04003C0000000001 ),
     INT64_C( 0x0000000003C589BC ),
     INT64_C( 0x00000000400013FE ),
     INT64_C( 0x0000000000186171 ),
    -INT64_C( 0x0000000000010406 ),
    -INT64_C( 0x000002861920038D ),
     INT64_C( 0x0000000010001DFF ),
    -INT64_C( 0x22E5F0F387AEC8F0 ),
    -INT64_C( 0x00007C0000010002 ),
     INT64_C( 0x00756EBD1AD0C1C7 ),
     INT64_C( 0x0003FDFFFFFFFFBE ),
     INT64_C( 0x0007D0FB2C2CA951 ),
     INT64_C( 0x0007FC0007FFFFFE ),
     INT64_C( 0x0000001F942B18BB ),
     INT64_C( 0x0000080101FFFFFE ),
    -INT64_C( 0x000000000000F688 ),
     INT64_C( 0x000000000008BFFF ),
     INT64_C( 0x0000000006F5AF08 ),
    -INT64_C( 0x0021008000000002 ),
     INT64_C( 0x0000000000000003 ),
     INT64_C( 0x3FFFFFFFFF80007D ),
     INT64_C( 0x0000000000000078 ),
    -INT64_C( 0x0007FFFFFF802003 ),
     INT64_C( 0x1BBC775B78016AB0 ),
    -INT64_C( 0x0006FFE000000002 ),
    -INT64_C( 0x0002B89854671BC1 ),
    -INT64_C( 0x0000010001FFFFE2 ),
    -INT64_C( 0x00000000000FB103 ),
     INT64_C( 0x07FFFFFFFFFFF7FF ),
    -INT64_C( 0x00036155C7076FB0 ),
     INT64_C( 0x00000020FBFFFFFE ),
     INT64_C( 0x0000099AE6455357 )
};

static void time_a_i64_z_f32( float32_t function( int_fast64_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            function( inputs_i64[ inputNum ] );
            inputNum = ( inputNum + 1 ) & ( numInputs_i64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        function( inputs_i64[ inputNum ] );
        inputNum = ( inputNum + 1 ) & ( numInputs_i64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_a_i64_z_f64( float64_t function( int_fast64_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            function( inputs_i64[ inputNum ] );
            inputNum = ( inputNum + 1 ) & ( numInputs_i64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        function( inputs_i64[ inputNum ] );
        inputNum = ( inputNum + 1 ) & ( numInputs_i64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#ifdef FLOATX80

static void time_a_i64_z_fx80( floatx80_t function( int_fast64_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            function( inputs_i64[ inputNum ] );
            inputNum = ( inputNum + 1 ) & ( numInputs_i64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        function( inputs_i64[ inputNum ] );
        inputNum = ( inputNum + 1 ) & ( numInputs_i64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#endif

#ifdef FLOAT128

static void time_a_i64_z_f128( float128_t function( int_fast64_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            function( inputs_i64[ inputNum ] );
            inputNum = ( inputNum + 1 ) & ( numInputs_i64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        function( inputs_i64[ inputNum ] );
        inputNum = ( inputNum + 1 ) & ( numInputs_i64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#endif

enum { numInputs_f32 = 32 };

static const uint32_t inputs_F32UI[ numInputs_f32 ] = {
    0x4EFA0000, 0xC1D0B328, 0x80000000, 0x3E69A31E,
    0xAF803EFF, 0x3F800000, 0x17BF8000, 0xE74A301A,
    0x4E010003, 0x7EE3C75D, 0xBD803FE0, 0xBFFEFF00,
    0x7981F800, 0x431FFFFC, 0xC100C000, 0x3D87EFFF,
    0x4103FEFE, 0xBC000007, 0xBF01F7FF, 0x4E6C6B5C,
    0xC187FFFE, 0xC58B9F13, 0x4F88007F, 0xDF004007,
    0xB7FFD7FE, 0x7E8001FB, 0x46EFFBFF, 0x31C10000,
    0xDB428661, 0x33F89B1F, 0xA3BFEFFF, 0x537BFFBE
};

static void
 time_a_f32_z_ui32_rx(
     uint_fast32_t function( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, roundingMode, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, roundingMode, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f32_z_ui64_rx(
     uint_fast64_t function( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, roundingMode, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, roundingMode, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f32_z_i32_rx(
     int_fast32_t function( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, roundingMode, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, roundingMode, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f32_z_i64_rx(
     int_fast64_t function( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, roundingMode, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, roundingMode, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f32_z_ui32_x(
     uint_fast32_t function( float32_t, bool ), bool exact )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f32_z_ui64_x(
     uint_fast64_t function( float32_t, bool ), bool exact )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f32_z_i32_x(
     int_fast32_t function( float32_t, bool ), bool exact )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f32_z_i64_x(
     int_fast64_t function( float32_t, bool ), bool exact )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_a_f32_z_f64( float64_t function( float32_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f );
            inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f );
        inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#ifdef FLOATX80

static void time_a_f32_z_fx80( floatx80_t function( float32_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f );
            inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f );
        inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#endif

#ifdef FLOAT128

static void time_a_f32_z_f128( float128_t function( float32_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f );
            inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f );
        inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#endif

static void
 time_az_f32_rx(
     float32_t function( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, roundingMode, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, roundingMode, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_abz_f32( float32_t function( float32_t, float32_t ) )
{
    int_fast64_t count;
    int inputNumA, inputNumB;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA, uB;
    clock_t endClock;

    count = 0;
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNumA ];
            uB.ui = inputs_F32UI[ inputNumB ];
            function( uA.f, uB.f );
            inputNumA = ( inputNumA + 1 ) & ( numInputs_f32 - 1 );
            if ( ! inputNumA ) ++inputNumB;
            inputNumB = ( inputNumB + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNumA ];
        uB.ui = inputs_F32UI[ inputNumB ];
        function( uA.f, uB.f );
        inputNumA = ( inputNumA + 1 ) & ( numInputs_f32 - 1 );
        if ( ! inputNumA ) ++inputNumB;
        inputNumB = ( inputNumB + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_abcz_f32( float32_t function( float32_t, float32_t, float32_t ) )
{
    int_fast64_t count;
    int inputNumA, inputNumB, inputNumC;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA, uB, uC;
    clock_t endClock;

    count = 0;
    inputNumA = 0;
    inputNumB = 0;
    inputNumC = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNumA ];
            uB.ui = inputs_F32UI[ inputNumB ];
            uC.ui = inputs_F32UI[ inputNumC ];
            function( uA.f, uB.f, uC.f );
            inputNumA = ( inputNumA + 1 ) & ( numInputs_f32 - 1 );
            if ( ! inputNumA ) ++inputNumB;
            inputNumB = ( inputNumB + 1 ) & ( numInputs_f32 - 1 );
            if ( ! inputNumB ) ++inputNumC;
            inputNumC = ( inputNumC + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNumA = 0;
    inputNumB = 0;
    inputNumC = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNumA ];
        uB.ui = inputs_F32UI[ inputNumB ];
        uC.ui = inputs_F32UI[ inputNumC ];
        function( uA.f, uB.f, uC.f );
        inputNumA = ( inputNumA + 1 ) & ( numInputs_f32 - 1 );
        if ( ! inputNumA ) ++inputNumB;
        inputNumB = ( inputNumB + 1 ) & ( numInputs_f32 - 1 );
        if ( ! inputNumB ) ++inputNumC;
        inputNumC = ( inputNumC + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_ab_f32_z_bool( bool function( float32_t, float32_t ) )
{
    int_fast64_t count;
    int inputNumA, inputNumB;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA, uB;
    clock_t endClock;

    count = 0;
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNumA ];
            uB.ui = inputs_F32UI[ inputNumB ];
            function( uA.f, uB.f );
            inputNumA = ( inputNumA + 1 ) & ( numInputs_f32 - 1 );
            if ( ! inputNumA ) ++inputNumB;
            inputNumB = ( inputNumB + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNumA ];
        uB.ui = inputs_F32UI[ inputNumB ];
        function( uA.f, uB.f );
        inputNumA = ( inputNumA + 1 ) & ( numInputs_f32 - 1 );
        if ( ! inputNumA ) ++inputNumB;
        inputNumB = ( inputNumB + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static const uint32_t inputs_F32UI_pos[ numInputs_f32 ] = {
    0x4EFA0000, 0x41D0B328, 0x00000000, 0x3E69A31E,
    0x2F803EFF, 0x3F800000, 0x17BF8000, 0x674A301A,
    0x4E010003, 0x7EE3C75D, 0x3D803FE0, 0x3FFEFF00,
    0x7981F800, 0x431FFFFC, 0x4100C000, 0x3D87EFFF,
    0x4103FEFE, 0x3C000007, 0x3F01F7FF, 0x4E6C6B5C,
    0x4187FFFE, 0x458B9F13, 0x4F88007F, 0x5F004007,
    0x37FFD7FE, 0x7E8001FB, 0x46EFFBFF, 0x31C10000,
    0x5B428661, 0x33F89B1F, 0x23BFEFFF, 0x537BFFBE
};

static void time_az_f32_pos( float32_t function( float32_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui32_f32 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI_pos[ inputNum ];
            function( uA.f );
            inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI_pos[ inputNum ];
        function( uA.f );
        inputNum = ( inputNum + 1 ) & ( numInputs_f32 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

enum { numInputs_f64 = 32 };

static const uint64_t inputs_F64UI[ numInputs_f64 ] = {
    UINT64_C( 0x422FFFC008000000 ),
    UINT64_C( 0xB7E0000480000000 ),
    UINT64_C( 0xF3FD2546120B7935 ),
    UINT64_C( 0x3FF0000000000000 ),
    UINT64_C( 0xCE07F766F09588D6 ),
    UINT64_C( 0x8000000000000000 ),
    UINT64_C( 0x3FCE000400000000 ),
    UINT64_C( 0x8313B60F0032BED8 ),
    UINT64_C( 0xC1EFFFFFC0002000 ),
    UINT64_C( 0x3FB3C75D224F2B0F ),
    UINT64_C( 0x7FD00000004000FF ),
    UINT64_C( 0xA12FFF8000001FFF ),
    UINT64_C( 0x3EE0000000FE0000 ),
    UINT64_C( 0x0010000080000004 ),
    UINT64_C( 0x41CFFFFE00000020 ),
    UINT64_C( 0x40303FFFFFFFFFFD ),
    UINT64_C( 0x3FD000003FEFFFFF ),
    UINT64_C( 0xBFD0000010000000 ),
    UINT64_C( 0xB7FC6B5C16CA55CF ),
    UINT64_C( 0x413EEB940B9D1301 ),
    UINT64_C( 0xC7E00200001FFFFF ),
    UINT64_C( 0x47F00021FFFFFFFE ),
    UINT64_C( 0xBFFFFFFFF80000FF ),
    UINT64_C( 0xC07FFFFFE00FFFFF ),
    UINT64_C( 0x001497A63740C5E8 ),
    UINT64_C( 0xC4BFFFE0001FFFFF ),
    UINT64_C( 0x96FFDFFEFFFFFFFF ),
    UINT64_C( 0x403FC000000001FE ),
    UINT64_C( 0xFFD00000000001F6 ),
    UINT64_C( 0x0640400002000000 ),
    UINT64_C( 0x479CEE1E4F789FE0 ),
    UINT64_C( 0xC237FFFFFFFFFDFE )
};

static void
 time_a_f64_z_ui32_rx(
     uint_fast32_t function( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, roundingMode, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, roundingMode, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f64_z_ui64_rx(
     uint_fast64_t function( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, roundingMode, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, roundingMode, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f64_z_i32_rx(
     int_fast32_t function( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, roundingMode, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, roundingMode, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f64_z_i64_rx(
     int_fast64_t function( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, roundingMode, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, roundingMode, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f64_z_ui32_x(
     uint_fast32_t function( float64_t, bool ), bool exact )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f64_z_ui64_x(
     uint_fast64_t function( float64_t, bool ), bool exact )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f64_z_i32_x(
     int_fast32_t function( float64_t, bool ), bool exact )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_a_f64_z_i64_x(
     int_fast64_t function( float64_t, bool ), bool exact )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F32UI[ inputNum ];
            function( uA.f, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F32UI[ inputNum ];
        function( uA.f, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_a_f64_z_f32( float32_t function( float64_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F64UI[ inputNum ];
            function( uA.f );
            inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F64UI[ inputNum ];
        function( uA.f );
        inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#ifdef FLOATX80

static void time_a_f64_z_fx80( floatx80_t function( float64_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F64UI[ inputNum ];
            function( uA.f );
            inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F64UI[ inputNum ];
        function( uA.f );
        inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#endif

#ifdef FLOAT128

static void time_a_f64_z_f128( float128_t function( float64_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F64UI[ inputNum ];
            function( uA.f );
            inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F64UI[ inputNum ];
        function( uA.f );
        inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#endif

static void
 time_az_f64_rx(
     float64_t function( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F64UI[ inputNum ];
            function( uA.f, roundingMode, exact );
            inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F64UI[ inputNum ];
        function( uA.f, roundingMode, exact );
        inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_abz_f64( float64_t function( float64_t, float64_t ) )
{
    int_fast64_t count;
    int inputNumA, inputNumB;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA, uB;
    clock_t endClock;

    count = 0;
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F64UI[ inputNumA ];
            uB.ui = inputs_F64UI[ inputNumB ];
            function( uA.f, uB.f );
            inputNumA = ( inputNumA + 1 ) & ( numInputs_f64 - 1 );
            if ( ! inputNumA ) ++inputNumB;
            inputNumB = ( inputNumB + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F64UI[ inputNumA ];
        uB.ui = inputs_F64UI[ inputNumB ];
        function( uA.f, uB.f );
        inputNumA = ( inputNumA + 1 ) & ( numInputs_f64 - 1 );
        if ( ! inputNumA ) ++inputNumB;
        inputNumB = ( inputNumB + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void
 time_abcz_f64( float64_t function( float64_t, float64_t, float64_t ) )
{
    int_fast64_t count;
    int inputNumA, inputNumB, inputNumC;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA, uB, uC;
    clock_t endClock;

    count = 0;
    inputNumA = 0;
    inputNumB = 0;
    inputNumC = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F64UI[ inputNumA ];
            uB.ui = inputs_F64UI[ inputNumB ];
            uC.ui = inputs_F64UI[ inputNumC ];
            function( uA.f, uB.f, uC.f );
            inputNumA = ( inputNumA + 1 ) & ( numInputs_f64 - 1 );
            if ( ! inputNumA ) ++inputNumB;
            inputNumB = ( inputNumB + 1 ) & ( numInputs_f64 - 1 );
            if ( ! inputNumB ) ++inputNumC;
            inputNumC = ( inputNumC + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNumA = 0;
    inputNumB = 0;
    inputNumC = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F64UI[ inputNumA ];
        uB.ui = inputs_F64UI[ inputNumB ];
        uC.ui = inputs_F64UI[ inputNumC ];
        function( uA.f, uB.f, uC.f );
        inputNumA = ( inputNumA + 1 ) & ( numInputs_f64 - 1 );
        if ( ! inputNumA ) ++inputNumB;
        inputNumB = ( inputNumB + 1 ) & ( numInputs_f64 - 1 );
        if ( ! inputNumB ) ++inputNumC;
        inputNumC = ( inputNumC + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_ab_f64_z_bool( bool function( float64_t, float64_t ) )
{
    int_fast64_t count;
    int inputNumA, inputNumB;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA, uB;
    clock_t endClock;

    count = 0;
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F64UI[ inputNumA ];
            uB.ui = inputs_F64UI[ inputNumB ];
            function( uA.f, uB.f );
            inputNumA = ( inputNumA + 1 ) & ( numInputs_f64 - 1 );
            if ( ! inputNumA ) ++inputNumB;
            inputNumB = ( inputNumB + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F64UI[ inputNumA ];
        uB.ui = inputs_F64UI[ inputNumB ];
        function( uA.f, uB.f );
        inputNumA = ( inputNumA + 1 ) & ( numInputs_f64 - 1 );
        if ( ! inputNumA ) ++inputNumB;
        inputNumB = ( inputNumB + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static const uint64_t inputs_F64UI_pos[ numInputs_f64 ] = {
    UINT64_C( 0x422FFFC008000000 ),
    UINT64_C( 0x37E0000480000000 ),
    UINT64_C( 0x73FD2546120B7935 ),
    UINT64_C( 0x3FF0000000000000 ),
    UINT64_C( 0x4E07F766F09588D6 ),
    UINT64_C( 0x0000000000000000 ),
    UINT64_C( 0x3FCE000400000000 ),
    UINT64_C( 0x0313B60F0032BED8 ),
    UINT64_C( 0x41EFFFFFC0002000 ),
    UINT64_C( 0x3FB3C75D224F2B0F ),
    UINT64_C( 0x7FD00000004000FF ),
    UINT64_C( 0x212FFF8000001FFF ),
    UINT64_C( 0x3EE0000000FE0000 ),
    UINT64_C( 0x0010000080000004 ),
    UINT64_C( 0x41CFFFFE00000020 ),
    UINT64_C( 0x40303FFFFFFFFFFD ),
    UINT64_C( 0x3FD000003FEFFFFF ),
    UINT64_C( 0x3FD0000010000000 ),
    UINT64_C( 0x37FC6B5C16CA55CF ),
    UINT64_C( 0x413EEB940B9D1301 ),
    UINT64_C( 0x47E00200001FFFFF ),
    UINT64_C( 0x47F00021FFFFFFFE ),
    UINT64_C( 0x3FFFFFFFF80000FF ),
    UINT64_C( 0x407FFFFFE00FFFFF ),
    UINT64_C( 0x001497A63740C5E8 ),
    UINT64_C( 0x44BFFFE0001FFFFF ),
    UINT64_C( 0x16FFDFFEFFFFFFFF ),
    UINT64_C( 0x403FC000000001FE ),
    UINT64_C( 0x7FD00000000001F6 ),
    UINT64_C( 0x0640400002000000 ),
    UINT64_C( 0x479CEE1E4F789FE0 ),
    UINT64_C( 0x4237FFFFFFFFFDFE )
};

static void time_az_f64_pos( float64_t function( float64_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    union ui64_f64 uA;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            uA.ui = inputs_F64UI_pos[ inputNum ];
            function( uA.f );
            inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        uA.ui = inputs_F64UI_pos[ inputNum ];
        function( uA.f );
        inputNum = ( inputNum + 1 ) & ( numInputs_f64 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#ifdef FLOATX80

*** MORE HERE.

enum { numInputs_fx80 = 32 };

static const struct {
    bits16 high;
    bits64 low;
} inputs_fx80[ numInputs_fx80 ] = {
    { 0xC03F, UINT64_C( 0xA9BE15A19C1E8B62 ) },
    { 0x8000, UINT64_C( 0x0000000000000000 ) },
    { 0x75A8, UINT64_C( 0xE59591E4788957A5 ) },
    { 0xBFFF, UINT64_C( 0xFFF0000000000040 ) },
    { 0x0CD8, UINT64_C( 0xFC000000000007FE ) },
    { 0x43BA, UINT64_C( 0x99A4000000000000 ) },
    { 0x3FFF, UINT64_C( 0x8000000000000000 ) },
    { 0x4081, UINT64_C( 0x94FBF1BCEB5545F0 ) },
    { 0x403E, UINT64_C( 0xFFF0000000002000 ) },
    { 0x3FFE, UINT64_C( 0xC860E3C75D224F28 ) },
    { 0x407E, UINT64_C( 0xFC00000FFFFFFFFE ) },
    { 0x737A, UINT64_C( 0x800000007FFDFFFE ) },
    { 0x4044, UINT64_C( 0xFFFFFF80000FFFFF ) },
    { 0xBBFE, UINT64_C( 0x8000040000001FFE ) },
    { 0xC002, UINT64_C( 0xFF80000000000020 ) },
    { 0xDE8D, UINT64_C( 0xFFFFFFFFFFE00004 ) },
    { 0xC004, UINT64_C( 0x8000000000003FFB ) },
    { 0x407F, UINT64_C( 0x800000000003FFFE ) },
    { 0xC000, UINT64_C( 0xA459EE6A5C16CA55 ) },
    { 0x8003, UINT64_C( 0xC42CBF7399AEEB94 ) },
    { 0xBF7F, UINT64_C( 0xF800000000000006 ) },
    { 0xC07F, UINT64_C( 0xBF56BE8871F28FEA ) },
    { 0xC07E, UINT64_C( 0xFFFF77FFFFFFFFFE ) },
    { 0xADC9, UINT64_C( 0x8000000FFFFFFFDE ) },
    { 0xC001, UINT64_C( 0xEFF7FFFFFFFFFFFF ) },
    { 0x4001, UINT64_C( 0xBE84F30125C497A6 ) },
    { 0xC06B, UINT64_C( 0xEFFFFFFFFFFFFFFF ) },
    { 0x4080, UINT64_C( 0xFFFFFFFFBFFFFFFF ) },
    { 0x87E9, UINT64_C( 0x81FFFFFFFFFFFBFF ) },
    { 0xA63F, UINT64_C( 0x801FFFFFFEFFFFFE ) },
    { 0x403C, UINT64_C( 0x801FFFFFFFF7FFFF ) },
    { 0x4018, UINT64_C( 0x8000000000080003 ) }
};

static void time_a_fx80_z_f32( float32_t function( floatx80_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_fx80[ inputNum ].low;
            a.high = inputs_fx80[ inputNum ].high;
            function( a );
            inputNum = ( inputNum + 1 ) & ( numInputs_fx80 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_fx80[ inputNum ].low;
        a.high = inputs_fx80[ inputNum ].high;
        function( a );
        inputNum = ( inputNum + 1 ) & ( numInputs_fx80 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_a_fx80_z_f64( float64_t function( floatx80_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_fx80[ inputNum ].low;
            a.high = inputs_fx80[ inputNum ].high;
            function( a );
            inputNum = ( inputNum + 1 ) & ( numInputs_fx80 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_fx80[ inputNum ].low;
        a.high = inputs_fx80[ inputNum ].high;
        function( a );
        inputNum = ( inputNum + 1 ) & ( numInputs_fx80 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#ifdef FLOAT128

static void time_a_fx80_z_f128( float128_t function( floatx80_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_fx80[ inputNum ].low;
            a.high = inputs_fx80[ inputNum ].high;
            function( a );
            inputNum = ( inputNum + 1 ) & ( numInputs_fx80 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_fx80[ inputNum ].low;
        a.high = inputs_fx80[ inputNum ].high;
        function( a );
        inputNum = ( inputNum + 1 ) & ( numInputs_fx80 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#endif

static void time_az_fx80( floatx80_t function( floatx80_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_fx80[ inputNum ].low;
            a.high = inputs_fx80[ inputNum ].high;
            function( a );
            inputNum = ( inputNum + 1 ) & ( numInputs_fx80 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_fx80[ inputNum ].low;
        a.high = inputs_fx80[ inputNum ].high;
        function( a );
        inputNum = ( inputNum + 1 ) & ( numInputs_fx80 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_abz_fx80( floatx80_t function( fx80, floatx80_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_fx80[ inputNumA ].low;
            a.high = inputs_fx80[ inputNumA ].high;
            b.low = inputs_fx80[ inputNumB ].low;
            b.high = inputs_fx80[ inputNumB ].high;
            function( a, b );
            inputNumA = ( inputNumA + 1 ) & ( numInputs_fx80 - 1 );
            if ( ! inputNumA ) ++inputNumB;
            inputNumB = ( inputNumB + 1 ) & ( numInputs_fx80 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_fx80[ inputNumA ].low;
        a.high = inputs_fx80[ inputNumA ].high;
        b.low = inputs_fx80[ inputNumB ].low;
        b.high = inputs_fx80[ inputNumB ].high;
        function( a, b );
        inputNumA = ( inputNumA + 1 ) & ( numInputs_fx80 - 1 );
        if ( ! inputNumA ) ++inputNumB;
        inputNumB = ( inputNumB + 1 ) & ( numInputs_fx80 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_ab_fx80_z_bool( bool function( fx80, floatx80_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_fx80[ inputNumA ].low;
            a.high = inputs_fx80[ inputNumA ].high;
            b.low = inputs_fx80[ inputNumB ].low;
            b.high = inputs_fx80[ inputNumB ].high;
            function( a, b );
            inputNumA = ( inputNumA + 1 ) & ( numInputs_fx80 - 1 );
            if ( ! inputNumA ) ++inputNumB;
            inputNumB = ( inputNumB + 1 ) & ( numInputs_fx80 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_fx80[ inputNumA ].low;
        a.high = inputs_fx80[ inputNumA ].high;
        b.low = inputs_fx80[ inputNumB ].low;
        b.high = inputs_fx80[ inputNumB ].high;
        function( a, b );
        inputNumA = ( inputNumA + 1 ) & ( numInputs_fx80 - 1 );
        if ( ! inputNumA ) ++inputNumB;
        inputNumB = ( inputNumB + 1 ) & ( numInputs_fx80 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static const struct {
    bits16 high;
    bits64 low;
} inputs_fx80_pos[ numInputs_fx80 ] = {
    { 0x403F, UINT64_C( 0xA9BE15A19C1E8B62 ) },
    { 0x0000, UINT64_C( 0x0000000000000000 ) },
    { 0x75A8, UINT64_C( 0xE59591E4788957A5 ) },
    { 0x3FFF, UINT64_C( 0xFFF0000000000040 ) },
    { 0x0CD8, UINT64_C( 0xFC000000000007FE ) },
    { 0x43BA, UINT64_C( 0x99A4000000000000 ) },
    { 0x3FFF, UINT64_C( 0x8000000000000000 ) },
    { 0x4081, UINT64_C( 0x94FBF1BCEB5545F0 ) },
    { 0x403E, UINT64_C( 0xFFF0000000002000 ) },
    { 0x3FFE, UINT64_C( 0xC860E3C75D224F28 ) },
    { 0x407E, UINT64_C( 0xFC00000FFFFFFFFE ) },
    { 0x737A, UINT64_C( 0x800000007FFDFFFE ) },
    { 0x4044, UINT64_C( 0xFFFFFF80000FFFFF ) },
    { 0x3BFE, UINT64_C( 0x8000040000001FFE ) },
    { 0x4002, UINT64_C( 0xFF80000000000020 ) },
    { 0x5E8D, UINT64_C( 0xFFFFFFFFFFE00004 ) },
    { 0x4004, UINT64_C( 0x8000000000003FFB ) },
    { 0x407F, UINT64_C( 0x800000000003FFFE ) },
    { 0x4000, UINT64_C( 0xA459EE6A5C16CA55 ) },
    { 0x0003, UINT64_C( 0xC42CBF7399AEEB94 ) },
    { 0x3F7F, UINT64_C( 0xF800000000000006 ) },
    { 0x407F, UINT64_C( 0xBF56BE8871F28FEA ) },
    { 0x407E, UINT64_C( 0xFFFF77FFFFFFFFFE ) },
    { 0x2DC9, UINT64_C( 0x8000000FFFFFFFDE ) },
    { 0x4001, UINT64_C( 0xEFF7FFFFFFFFFFFF ) },
    { 0x4001, UINT64_C( 0xBE84F30125C497A6 ) },
    { 0x406B, UINT64_C( 0xEFFFFFFFFFFFFFFF ) },
    { 0x4080, UINT64_C( 0xFFFFFFFFBFFFFFFF ) },
    { 0x07E9, UINT64_C( 0x81FFFFFFFFFFFBFF ) },
    { 0x263F, UINT64_C( 0x801FFFFFFEFFFFFE ) },
    { 0x403C, UINT64_C( 0x801FFFFFFFF7FFFF ) },
    { 0x4018, UINT64_C( 0x8000000000080003 ) }
};

static void time_az_fx80_pos( floatx80_t function( floatx80_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_fx80_pos[ inputNum ].low;
            a.high = inputs_fx80_pos[ inputNum ].high;
            function( a );
            inputNum = ( inputNum + 1 ) & ( numInputs_fx80 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_fx80_pos[ inputNum ].low;
        a.high = inputs_fx80_pos[ inputNum ].high;
        function( a );
        inputNum = ( inputNum + 1 ) & ( numInputs_fx80 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#endif

#ifdef FLOAT128

enum { numInputs_f128 = 32 };

static const struct {
    bits64 high, low;
} inputs_f128[ numInputs_f128 ] = {
    { UINT64_C( 0x3FDA200000100000 ), UINT64_C( 0x0000000000000000 ) },
    { UINT64_C( 0x3FFF000000000000 ), UINT64_C( 0x0000000000000000 ) },
    { UINT64_C( 0x85F14776190C8306 ), UINT64_C( 0xD8715F4E3D54BB92 ) },
    { UINT64_C( 0xF2B00000007FFFFF ), UINT64_C( 0xFFFFFFFFFFF7FFFF ) },
    { UINT64_C( 0x8000000000000000 ), UINT64_C( 0x0000000000000000 ) },
    { UINT64_C( 0xBFFFFFFFFFE00000 ), UINT64_C( 0x0000008000000000 ) },
    { UINT64_C( 0x407F1719CE722F3E ), UINT64_C( 0xDA6B3FE5FF29425B ) },
    { UINT64_C( 0x43FFFF8000000000 ), UINT64_C( 0x0000000000400000 ) },
    { UINT64_C( 0x401E000000000100 ), UINT64_C( 0x0000000000002000 ) },
    { UINT64_C( 0x3FFED71DACDA8E47 ), UINT64_C( 0x4860E3C75D224F28 ) },
    { UINT64_C( 0xBF7ECFC1E90647D1 ), UINT64_C( 0x7A124FE55623EE44 ) },
    { UINT64_C( 0x0DF7007FFFFFFFFF ), UINT64_C( 0xFFFFFFFFEFFFFFFF ) },
    { UINT64_C( 0x3FE5FFEFFFFFFFFF ), UINT64_C( 0xFFFFFFFFFFFFEFFF ) },
    { UINT64_C( 0x403FFFFFFFFFFFFF ), UINT64_C( 0xFFFFFFFFFFFFFBFE ) },
    { UINT64_C( 0xBFFB2FBF7399AFEB ), UINT64_C( 0xA459EE6A5C16CA55 ) },
    { UINT64_C( 0xBDB8FFFFFFFFFFFC ), UINT64_C( 0x0000000000000400 ) },
    { UINT64_C( 0x3FC8FFDFFFFFFFFF ), UINT64_C( 0xFFFFFFFFF0000000 ) },
    { UINT64_C( 0x3FFBFFFFFFDFFFFF ), UINT64_C( 0xFFF8000000000000 ) },
    { UINT64_C( 0x407043C11737BE84 ), UINT64_C( 0xDDD58212ADC937F4 ) },
    { UINT64_C( 0x8001000000000000 ), UINT64_C( 0x0000001000000001 ) },
    { UINT64_C( 0xC036FFFFFFFFFFFF ), UINT64_C( 0xFE40000000000000 ) },
    { UINT64_C( 0x4002FFFFFE000002 ), UINT64_C( 0x0000000000000000 ) },
    { UINT64_C( 0x4000C3FEDE897773 ), UINT64_C( 0x326AC4FD8EFBE6DC ) },
    { UINT64_C( 0xBFFF0000000FFFFF ), UINT64_C( 0xFFFFFE0000000000 ) },
    { UINT64_C( 0x62C3E502146E426D ), UINT64_C( 0x43F3CAA0DC7DF1A0 ) },
    { UINT64_C( 0xB5CBD32E52BB570E ), UINT64_C( 0xBCC477CB11C6236C ) },
    { UINT64_C( 0xE228FFFFFFC00000 ), UINT64_C( 0x0000000000000000 ) },
    { UINT64_C( 0x3F80000000000000 ), UINT64_C( 0x0000000080000008 ) },
    { UINT64_C( 0xC1AFFFDFFFFFFFFF ), UINT64_C( 0xFFFC000000000000 ) },
    { UINT64_C( 0xC96F000000000000 ), UINT64_C( 0x00000001FFFBFFFF ) },
    { UINT64_C( 0x3DE09BFE7923A338 ), UINT64_C( 0xBCC8FBBD7CEC1F4F ) },
    { UINT64_C( 0x401CFFFFFFFFFFFF ), UINT64_C( 0xFFFFFFFEFFFFFF80 ) }
};

static void time_a_f128_z_f32( float32_t function( float128_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_f128[ inputNum ].low;
            a.high = inputs_f128[ inputNum ].high;
            function( a );
            inputNum = ( inputNum + 1 ) & ( numInputs_f128 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_f128[ inputNum ].low;
        a.high = inputs_f128[ inputNum ].high;
        function( a );
        inputNum = ( inputNum + 1 ) & ( numInputs_f128 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_a_f128_z_f64( float64_t function( float128_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_f128[ inputNum ].low;
            a.high = inputs_f128[ inputNum ].high;
            function( a );
            inputNum = ( inputNum + 1 ) & ( numInputs_f128 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_f128[ inputNum ].low;
        a.high = inputs_f128[ inputNum ].high;
        function( a );
        inputNum = ( inputNum + 1 ) & ( numInputs_f128 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#ifdef FLOATX80

static void time_a_f128_z_fx80( floatx80_t function( float128_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_f128[ inputNum ].low;
            a.high = inputs_f128[ inputNum ].high;
            function( a );
            inputNum = ( inputNum + 1 ) & ( numInputs_f128 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_f128[ inputNum ].low;
        a.high = inputs_f128[ inputNum ].high;
        function( a );
        inputNum = ( inputNum + 1 ) & ( numInputs_f128 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#endif

static void time_az_f128( float128_t function( float128_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_f128[ inputNum ].low;
            a.high = inputs_f128[ inputNum ].high;
            function( a );
            inputNum = ( inputNum + 1 ) & ( numInputs_f128 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_f128[ inputNum ].low;
        a.high = inputs_f128[ inputNum ].high;
        function( a );
        inputNum = ( inputNum + 1 ) & ( numInputs_f128 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_abz_f128( float128_t function( f128, float128_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_f128[ inputNumA ].low;
            a.high = inputs_f128[ inputNumA ].high;
            b.low = inputs_f128[ inputNumB ].low;
            b.high = inputs_f128[ inputNumB ].high;
            function( a, b );
            inputNumA = ( inputNumA + 1 ) & ( numInputs_f128 - 1 );
            if ( ! inputNumA ) ++inputNumB;
            inputNumB = ( inputNumB + 1 ) & ( numInputs_f128 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_f128[ inputNumA ].low;
        a.high = inputs_f128[ inputNumA ].high;
        b.low = inputs_f128[ inputNumB ].low;
        b.high = inputs_f128[ inputNumB ].high;
        function( a, b );
        inputNumA = ( inputNumA + 1 ) & ( numInputs_f128 - 1 );
        if ( ! inputNumA ) ++inputNumB;
        inputNumB = ( inputNumB + 1 ) & ( numInputs_f128 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static void time_ab_f128_z_bool( bool function( f128, float128_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_f128[ inputNumA ].low;
            a.high = inputs_f128[ inputNumA ].high;
            b.low = inputs_f128[ inputNumB ].low;
            b.high = inputs_f128[ inputNumB ].high;
            function( a, b );
            inputNumA = ( inputNumA + 1 ) & ( numInputs_f128 - 1 );
            if ( ! inputNumA ) ++inputNumB;
            inputNumB = ( inputNumB + 1 ) & ( numInputs_f128 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNumA = 0;
    inputNumB = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_f128[ inputNumA ].low;
        a.high = inputs_f128[ inputNumA ].high;
        b.low = inputs_f128[ inputNumB ].low;
        b.high = inputs_f128[ inputNumB ].high;
        function( a, b );
        inputNumA = ( inputNumA + 1 ) & ( numInputs_f128 - 1 );
        if ( ! inputNumA ) ++inputNumB;
        inputNumB = ( inputNumB + 1 ) & ( numInputs_f128 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

static const struct {
    bits64 high, low;
} inputs_f128_pos[ numInputs_f128 ] = {
    { UINT64_C( 0x3FDA200000100000 ), UINT64_C( 0x0000000000000000 ) },
    { UINT64_C( 0x3FFF000000000000 ), UINT64_C( 0x0000000000000000 ) },
    { UINT64_C( 0x05F14776190C8306 ), UINT64_C( 0xD8715F4E3D54BB92 ) },
    { UINT64_C( 0x72B00000007FFFFF ), UINT64_C( 0xFFFFFFFFFFF7FFFF ) },
    { UINT64_C( 0x0000000000000000 ), UINT64_C( 0x0000000000000000 ) },
    { UINT64_C( 0x3FFFFFFFFFE00000 ), UINT64_C( 0x0000008000000000 ) },
    { UINT64_C( 0x407F1719CE722F3E ), UINT64_C( 0xDA6B3FE5FF29425B ) },
    { UINT64_C( 0x43FFFF8000000000 ), UINT64_C( 0x0000000000400000 ) },
    { UINT64_C( 0x401E000000000100 ), UINT64_C( 0x0000000000002000 ) },
    { UINT64_C( 0x3FFED71DACDA8E47 ), UINT64_C( 0x4860E3C75D224F28 ) },
    { UINT64_C( 0x3F7ECFC1E90647D1 ), UINT64_C( 0x7A124FE55623EE44 ) },
    { UINT64_C( 0x0DF7007FFFFFFFFF ), UINT64_C( 0xFFFFFFFFEFFFFFFF ) },
    { UINT64_C( 0x3FE5FFEFFFFFFFFF ), UINT64_C( 0xFFFFFFFFFFFFEFFF ) },
    { UINT64_C( 0x403FFFFFFFFFFFFF ), UINT64_C( 0xFFFFFFFFFFFFFBFE ) },
    { UINT64_C( 0x3FFB2FBF7399AFEB ), UINT64_C( 0xA459EE6A5C16CA55 ) },
    { UINT64_C( 0x3DB8FFFFFFFFFFFC ), UINT64_C( 0x0000000000000400 ) },
    { UINT64_C( 0x3FC8FFDFFFFFFFFF ), UINT64_C( 0xFFFFFFFFF0000000 ) },
    { UINT64_C( 0x3FFBFFFFFFDFFFFF ), UINT64_C( 0xFFF8000000000000 ) },
    { UINT64_C( 0x407043C11737BE84 ), UINT64_C( 0xDDD58212ADC937F4 ) },
    { UINT64_C( 0x0001000000000000 ), UINT64_C( 0x0000001000000001 ) },
    { UINT64_C( 0x4036FFFFFFFFFFFF ), UINT64_C( 0xFE40000000000000 ) },
    { UINT64_C( 0x4002FFFFFE000002 ), UINT64_C( 0x0000000000000000 ) },
    { UINT64_C( 0x4000C3FEDE897773 ), UINT64_C( 0x326AC4FD8EFBE6DC ) },
    { UINT64_C( 0x3FFF0000000FFFFF ), UINT64_C( 0xFFFFFE0000000000 ) },
    { UINT64_C( 0x62C3E502146E426D ), UINT64_C( 0x43F3CAA0DC7DF1A0 ) },
    { UINT64_C( 0x35CBD32E52BB570E ), UINT64_C( 0xBCC477CB11C6236C ) },
    { UINT64_C( 0x6228FFFFFFC00000 ), UINT64_C( 0x0000000000000000 ) },
    { UINT64_C( 0x3F80000000000000 ), UINT64_C( 0x0000000080000008 ) },
    { UINT64_C( 0x41AFFFDFFFFFFFFF ), UINT64_C( 0xFFFC000000000000 ) },
    { UINT64_C( 0x496F000000000000 ), UINT64_C( 0x00000001FFFBFFFF ) },
    { UINT64_C( 0x3DE09BFE7923A338 ), UINT64_C( 0xBCC8FBBD7CEC1F4F ) },
    { UINT64_C( 0x401CFFFFFFFFFFFF ), UINT64_C( 0xFFFFFFFEFFFFFF80 ) }
};

static void time_az_f128_pos( float128_t function( float128_t ) )
{
    int_fast64_t count;
    int inputNum;
    clock_t startClock;
    int_fast64_t i;
    clock_t endClock;

    count = 0;
    inputNum = 0;
    startClock = clock();
    do {
        for ( i = minIterations; i; --i ) {
            a.low = inputs_f128_pos[ inputNum ].low;
            a.high = inputs_f128_pos[ inputNum ].high;
            function( a );
            inputNum = ( inputNum + 1 ) & ( numInputs_f128 - 1 );
        }
        count += minIterations;
    } while ( clock() - startClock < CLOCKS_PER_SEC );
    inputNum = 0;
    startClock = clock();
    for ( i = count; i; --i ) {
        a.low = inputs_f128_pos[ inputNum ].low;
        a.high = inputs_f128_pos[ inputNum ].high;
        function( a );
        inputNum = ( inputNum + 1 ) & ( numInputs_f128 - 1 );
    }
    endClock = clock();
    reportTime( count, endClock - startClock );

}

#endif

static void
 timeFunctionInstance(
     int_fast8_t functionCode, int_fast8_t roundingMode, bool exact )
{
    float32_t ( *function_abz_f32 )( float32_t, float32_t );
    bool ( *function_ab_f32_z_bool )( float32_t, float32_t );
    float64_t ( *function_abz_f64 )( float64_t, float64_t );
    bool ( *function_ab_f64_z_bool )( float64_t, float64_t );

    switch ( functionCode ) {
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case UI32_TO_F32:
        time_a_ui32_z_f32( ui32_to_f32 );
        break;
     case UI32_TO_F64:
        time_a_ui32_z_f64( ui32_to_f64 );
        break;
     case UI64_TO_F32:
        time_a_ui64_z_f32( ui64_to_f32 );
        break;
     case UI64_TO_F64:
        time_a_ui64_z_f64( ui64_to_f64 );
        break;
     case I32_TO_F32:
        time_a_i32_z_f32( i32_to_f32 );
        break;
     case I32_TO_F64:
        time_a_i32_z_f64( i32_to_f64 );
        break;
     case I64_TO_F32:
        time_a_i64_z_f32( i64_to_f32 );
        break;
     case I64_TO_F64:
        time_a_i64_z_f64( i64_to_f64 );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case F32_TO_UI32:
        time_a_f32_z_ui32_rx( f32_to_ui32, roundingMode, exact );
        break;
     case F32_TO_UI64:
        time_a_f32_z_ui64_rx( f32_to_ui64, roundingMode, exact );
        break;
     case F32_TO_I32:
        time_a_f32_z_i32_rx( f32_to_i32, roundingMode, exact );
        break;
     case F32_TO_I64:
        time_a_f32_z_i64_rx( f32_to_i64, roundingMode, exact );
        break;
     case F32_TO_UI32_R_MINMAG:
        time_a_f32_z_ui32_x( f32_to_ui32_r_minMag, exact );
        break;
     case F32_TO_UI64_R_MINMAG:
        time_a_f32_z_ui64_x( f32_to_ui64_r_minMag, exact );
        break;
     case F32_TO_I32_R_MINMAG:
        time_a_f32_z_i32_x( f32_to_i32_r_minMag, exact );
        break;
     case F32_TO_I64_R_MINMAG:
        time_a_f32_z_i64_x( f32_to_i64_r_minMag, exact );
        break;
     case F32_TO_F64:
        time_a_f32_z_f64( f32_to_f64 );
        break;
     case F32_ROUNDTOINT:
        time_az_f32_rx( f32_roundToInt, roundingMode, exact );
        break;
     case F32_ADD:
        function_abz_f32 = f32_add;
        goto time_abz_f32;
     case F32_SUB:
        function_abz_f32 = f32_sub;
        goto time_abz_f32;
     case F32_MUL:
        function_abz_f32 = f32_mul;
        goto time_abz_f32;
     case F32_DIV:
        function_abz_f32 = f32_div;
        goto time_abz_f32;
     case F32_REM:
        function_abz_f32 = f32_rem;
     time_abz_f32:
        time_abz_f32( function_abz_f32 );
        break;
     case F32_MULADD:
        time_abcz_f32( f32_mulAdd );
        break;
     case F32_SQRT:
        time_az_f32_pos( f32_sqrt );
        break;
     case F32_EQ:
        function_ab_f32_z_bool = f32_eq;
        goto time_ab_f32_z_bool;
     case F32_LE:
        function_ab_f32_z_bool = f32_le;
        goto time_ab_f32_z_bool;
     case F32_LT:
        function_ab_f32_z_bool = f32_lt;
        goto time_ab_f32_z_bool;
     case F32_EQ_SIGNALING:
        function_ab_f32_z_bool = f32_eq_signaling;
        goto time_ab_f32_z_bool;
     case F32_LE_QUIET:
        function_ab_f32_z_bool = f32_le_quiet;
        goto time_ab_f32_z_bool;
     case F32_LT_QUIET:
        function_ab_f32_z_bool = f32_lt_quiet;
     time_ab_f32_z_bool:
        time_ab_f32_z_bool( function_ab_f32_z_bool );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case F64_TO_UI32:
        time_a_f64_z_ui32_rx( f64_to_ui32, roundingMode, exact );
        break;
     case F64_TO_UI64:
        time_a_f64_z_ui64_rx( f64_to_ui64, roundingMode, exact );
        break;
     case F64_TO_I32:
        time_a_f64_z_i32_rx( f64_to_i32, roundingMode, exact );
        break;
     case F64_TO_I64:
        time_a_f64_z_i64_rx( f64_to_i64, roundingMode, exact );
        break;
     case F64_TO_UI32_R_MINMAG:
        time_a_f64_z_ui32_x( f64_to_ui32_r_minMag, exact );
        break;
     case F64_TO_UI64_R_MINMAG:
        time_a_f64_z_ui64_x( f64_to_ui64_r_minMag, exact );
        break;
     case F64_TO_I32_R_MINMAG:
        time_a_f64_z_i32_x( f64_to_i32_r_minMag, exact );
        break;
     case F64_TO_I64_R_MINMAG:
        time_a_f64_z_i64_x( f64_to_i64_r_minMag, exact );
        break;
     case F64_TO_F32:
        time_a_f64_z_f32( f64_to_f32 );
        break;
     case F64_ROUNDTOINT:
        time_az_f64_rx( f64_roundToInt, roundingMode, exact );
        break;
     case F64_ADD:
        function_abz_f64 = f64_add;
        goto time_abz_f64;
     case F64_SUB:
        function_abz_f64 = f64_sub;
        goto time_abz_f64;
     case F64_MUL:
        function_abz_f64 = f64_mul;
        goto time_abz_f64;
     case F64_DIV:
        function_abz_f64 = f64_div;
        goto time_abz_f64;
     case F64_REM:
        function_abz_f64 = f64_rem;
     time_abz_f64:
        time_abz_f64( function_abz_f64 );
        break;
     case F64_MULADD:
        time_abcz_f64( f64_mulAdd );
        break;
     case F64_SQRT:
        time_az_f64_pos( f64_sqrt );
        break;
     case F64_EQ:
        function_ab_f64_z_bool = f64_eq;
        goto time_ab_f64_z_bool;
     case F64_LE:
        function_ab_f64_z_bool = f64_le;
        goto time_ab_f64_z_bool;
     case F64_LT:
        function_ab_f64_z_bool = f64_lt;
        goto time_ab_f64_z_bool;
     case F64_EQ_SIGNALING:
        function_ab_f64_z_bool = f64_eq_signaling;
        goto time_ab_f64_z_bool;
     case F64_LE_QUIET:
        function_ab_f64_z_bool = f64_le_quiet;
        goto time_ab_f64_z_bool;
     case F64_LT_QUIET:
        function_ab_f64_z_bool = f64_lt_quiet;
     time_ab_f64_z_bool:
        time_ab_f64_z_bool( function_ab_f64_z_bool );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
#ifdef FLOATX80
     case FX80_TO_UI32:
        time_a_fx80_z_ui32_rx( fx80_to_ui32, roundingMode, exact );
        break;
     case FX80_TO_UI64:
        time_a_fx80_z_ui64_rx( fx80_to_ui64, roundingMode, exact );
        break;
     case FX80_TO_I32:
        time_a_fx80_z_i32_rx( fx80_to_i32, roundingMode, exact );
        break;
     case FX80_TO_I64:
        time_a_fx80_z_i64_rx( fx80_to_i64, roundingMode, exact );
        break;
     case FX80_TO_UI32_R_MINMAG:
        time_a_fx80_z_ui32_x( fx80_to_ui32_r_minMag, exact );
        break;
     case FX80_TO_UI64_R_MINMAG:
        time_a_fx80_z_ui64_x( fx80_to_ui64_r_minMag, exact );
        break;
     case FX80_TO_I32_R_MINMAG:
        time_a_fx80_z_i32_x( fx80_to_i32_r_minMag, exact );
        break;
     case FX80_TO_I64_R_MINMAG:
        time_a_fx80_z_i64_x( fx80_to_i64_r_minMag, exact );
        break;
     case FX80_TO_F32:
        time_a_fx80_z_f32( fx80_to_f32 );
        break;
     case FX80_TO_F64:
        time_a_fx80_z_f64( fx80_to_f64 );
        break;
#endif
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
#ifdef FLOAT128
     case F128_TO_UI32:
        time_a_f128_z_ui32_rx( f128_to_ui32, roundingMode, exact );
        break;
     case F128_TO_UI64:
        time_a_f128_z_ui64_rx( f128_to_ui64, roundingMode, exact );
        break;
     case F128_TO_I32:
        time_a_f128_z_i32_rx( f128_to_i32, roundingMode, exact );
        break;
     case F128_TO_I64:
        time_a_f128_z_i64_rx( f128_to_i64, roundingMode, exact );
        break;
     case F128_TO_UI32_R_MINMAG:
        time_a_f128_z_ui32_x( f128_to_ui32_r_minMag, exact );
        break;
     case F128_TO_UI64_R_MINMAG:
        time_a_f128_z_ui64_x( f128_to_ui64_r_minMag, exact );
        break;
     case F128_TO_I32_R_MINMAG:
        time_a_f128_z_i32_x( f128_to_i32_r_minMag, exact );
        break;
     case F128_TO_I64_R_MINMAG:
        time_a_f128_z_i64_x( f128_to_i64_r_minMag, exact );
        break;
     case F128_TO_F32:
        time_a_f128_z_f32( f128_to_f32 );
        break;
     case F128_TO_F64:
        time_a_f128_z_f64( f128_to_f64 );
        break;
#endif
    }

}

enum { EXACT_FALSE = 1, EXACT_TRUE };

static void
 timeFunction(
     int_fast8_t functionCode,
     int_fast8_t roundingPrecisionIn,
     int_fast8_t roundingCodeIn,
     int_fast8_t tininessCodeIn,
     int_fast8_t exactCodeIn
 )
{
    uint_fast8_t functionAttribs;
    int_fast8_t roundingPrecision, exactCode, roundingMode, tininessMode;

    functionNamePtr = functionInfos[ functionCode ].namePtr;
    functionAttribs = functionInfos[ functionCode ].attribs;
    roundingPrecision = 32;
    for (;;) {
        if ( ! ( functionAttribs & FUNC_EFF_ROUNDINGPRECISION ) ) {
            roundingPrecision = 0;
        } else if ( roundingPrecisionIn ) {
            roundingPrecision = roundingPrecisionIn;
        }
#ifdef FLOATX80
        if ( roundingPrecision ) {
            floatx80_roundingPrecision = roundingPrecision;
        }
#endif
        for (
            roundingCode = 1; roundingCode < NUM_ROUNDINGMODES; ++roundingCode
        ) {
            if (
                ! ( functionAttribs
                        & ( FUNC_ARG_ROUNDINGMODE | FUNC_EFF_ROUNDINGMODE ) )
            ) {
                roundingCode = 0;
            } else if ( roundingCodeIn ) {
                roundingCode = roundingCodeIn;
            }
            if ( roundingCode ) {
                roundingMode = roundingModes[ roundingCode ];
                if ( functionAttribs & FUNC_EFF_ROUNDINGMODE ) {
                    softfloat_roundingMode = roundingMode;
                }
            }
            for (
                exactCode = EXACT_FALSE; exactCode <= EXACT_TRUE; ++exactCode
            ) {
                if ( ! ( functionAttribs & FUNC_ARG_EXACT ) ) {
                    exactCode = 0;
                } else if ( exactCodeIn ) {
                    exactCode = exactCodeIn;
                }
                exact = ( exactCode == EXACT_TRUE );
                usesExact = ( exactCode != 0 );
                for (
                    tininessCode = 1;
                    tininessCode < NUM_TININESSMODES;
                    ++tininessCode
                ) {
                    if (
                        ! ( functionAttribs
                                & ( roundingPrecision
                                        && ( roundingPrecision < 80 )
                                        ? FUNC_EFF_TININESSMODE_REDUCEDPREC
                                        : FUNC_EFF_TININESSMODE ) )
                    ) {
                        tininessCode = 0;
                    } else if ( tininessCodeIn ) {
                        tininessCode = tininessCodeIn;
                    }
                    if ( tininessCode ) {
                        tininessMode = tininessModes[ tininessCode ];
                        softfloat_detectTininess = tininessMode;
                    }
                    timeFunctionInstance( functionCode, roundingMode, exact );
                    if ( tininessCodeIn || ! tininessCode ) break;
                }
                if ( exactCodeIn || ! exactCode ) break;
            }
            if ( roundingCodeIn || ! roundingCode ) break;
        }
        if ( roundingPrecisionIn || ! roundingPrecision ) break;
        if ( roundingPrecision == 80 ) {
            break;
        } else if ( roundingPrecision == 64 ) {
            roundingPrecision = 80;
        } else if ( roundingPrecision == 32 ) {
            roundingPrecision = 64;
        }
    }

}

int main( int argc, char *argv[] )
{
    bool haveFunctionArg;
    int_fast8_t functionCode, numOperands;
    int_fast8_t roundingPrecision, roundingCode, tininessCode, exactCode;
    const char *argPtr;

    fail_programName = "timesoftfloat";
    if ( argc <= 1 ) goto writeHelpMessage;
    haveFunctionArg = false;
    functionCode = 0;
    numOperands = 0;
    roundingPrecision = 0;
    roundingCode = 0;
    tininessCode = 0;
    exactCode = 0;
    for (;;) {
        --argc;
        if ( ! argc ) break;
        argPtr = *++argv;
        if ( ! argPtr ) break;
        if ( argPtr[ 0 ] == '-' ) ++argPtr;
        if (
            ! strcmp( argPtr, "help" ) || ! strcmp( argPtr, "-help" )
                || ! strcmp( argPtr, "h" )
        ) {
 writeHelpMessage:
            fputs(
"timesoftfloat [<option>...] <function>\n"
"  <option>:  (* is default)\n"
"    -help            --Write this message and exit.\n"
#ifdef FLOATX80
"    -precision32     --Only time rounding precision equivalent to float32_t.\n"
"    -precision64     --Only time rounding precision equivalent to float64_t.\n"
"    -precision80     --Only time maximum rounding precision.\n"
#endif
"    -rnear_even      --Only time rounding to nearest/even.\n"
"    -rminmag         --Only time rounding to minimum magnitude (toward zero).\n"
"    -rmin            --Only time rounding to minimum (down).\n"
"    -rmax            --Only time rounding to maximum (up).\n"
"    -rnear_even      --Only time rounding to nearest/maximum magnitude\n"
"                         (nearest/away).\n"
"    -tininessbefore  --Only time underflow tininess detected before rounding.\n"
"    -tininessafter   --Only time underflow tininess detected after rounding.\n"
"    -notexact        --Only time non-exact rounding to integer (no inexact\n"
"                         exception).\n"
"    -exact           --Only time exact rounding to integer (allow inexact\n"
"                         exception).\n"
"  <function>:\n"
"    <int>_to_<float>            <float>_add         <float>_eq\n"
"    <float>_to_<int>            <float>_sub         <float>_le\n"
"    <float>_to_<int>_r_minMag   <float>_mul         <float>_lt\n"
"    <float>_to_<float>          <float>_mulAdd      <float>_eq_signaling\n"
"    <float>_roundToInt          <float>_mulSub      <float>_le_quiet\n"
"                                <float>_mulRevSub   <float>_lt_quiet\n"
"                                <float>_div\n"
"                                <float>_rem\n"
"                                <float>_sqrt\n"
"    -all1            --All unary functions.\n"
"    -all2            --All binary functions.\n"
"  <int>:\n"
"    ui32             --Unsigned 32-bit integer.\n"
"    ui64             --Unsigned 64-bit integer.\n"
"    i32              --Signed 32-bit integer.\n"
"    i64              --Signed 64-bit integer.\n"
"  <float>:\n"
"    f32              --Binary 32-bit floating-point (single precision).\n"
"    f64              --Binary 64-bit floating-point (double precision).\n"
#ifdef FLOATX80
"    fx80             --Binary 80-bit extended floating-point.\n"
#endif
#ifdef FLOAT128
"    f128             --Binary 128-bit floating-point (quadruple precision).\n"
#endif
                ,
                stdout
            );
            return EXIT_SUCCESS;
#ifdef FLOATX80
        } else if ( ! strcmp( argPtr, "precision32" ) ) {
            roundingPrecision = 32;
        } else if ( ! strcmp( argPtr, "precision64" ) ) {
            roundingPrecision = 64;
        } else if ( ! strcmp( argPtr, "precision80" ) ) {
            roundingPrecision = 80;
#endif
        } else if (
               ! strcmp( argPtr, "rnear_even" )
            || ! strcmp( argPtr, "rneareven" )
            || ! strcmp( argPtr, "rnearest_even" )
        ) {
            roundingCode = ROUND_NEAREST_EVEN;
        } else if (
            ! strcmp( argPtr, "rminmag" ) || ! strcmp( argPtr, "rminMag" )
        ) {
            roundingCode = ROUND_MINMAG;
        } else if ( ! strcmp( argPtr, "rmin" ) ) {
            roundingCode = ROUND_MIN;
        } else if ( ! strcmp( argPtr, "rmax" ) ) {
            roundingCode = ROUND_MAX;
        } else if (
               ! strcmp( argPtr, "rnear_maxmag" )
            || ! strcmp( argPtr, "rnear_maxMag" )
            || ! strcmp( argPtr, "rnearmaxmag" )
            || ! strcmp( argPtr, "rnearest_maxmag" )
            || ! strcmp( argPtr, "rnearest_maxMag" )
        ) {
            roundingCode = ROUND_NEAREST_MAXMAG;
        } else if ( ! strcmp( argPtr, "tininessbefore" ) ) {
            tininessCode = TININESS_BEFORE_ROUNDING;
        } else if ( ! strcmp( argPtr, "tininessafter" ) ) {
            tininessCode = TININESS_AFTER_ROUNDING;
        } else if ( ! strcmp( argPtr, "notexact" ) ) {
            exactCode = EXACT_FALSE;
        } else if ( ! strcmp( argPtr, "exact" ) ) {
            exactCode = EXACT_TRUE;
        } else if ( ! strcmp( argPtr, "all1" ) ) {
            haveFunctionArg = true;
            functionCode = 0;
            numOperands = 1;
        } else if ( ! strcmp( argPtr, "all2" ) ) {
            haveFunctionArg = true;
            functionCode = 0;
            numOperands = 2;
        } else {
            functionCode = 1;
            while ( strcmp( argPtr, functionInfos[ functionCode ].namePtr ) ) {
                ++functionCode;
                if ( functionCode == NUM_FUNCTIONS ) {
                    fail( "Invalid argument `%s'", *argv );
                }
            }
            haveFunctionArg = true;
        }
    }
    if ( ! haveFunctionArg ) fail( "Function argument required" );
    if ( functionCode ) {
        timeFunction(
            functionCode,
            roundingPrecision,
            roundingCode,
            tininessCode,
            exactCode
        );
    } else {
        if ( numOperands == 1 ) {
            for (
                functionCode = 1; functionCode < NUM_FUNCTIONS; ++functionCode
            ) {
                if ( functionInfos[ functionCode ].attribs & FUNC_ARG_UNARY ) {
                    timeFunction(
                        functionCode,
                        roundingPrecision,
                        roundingCode,
                        tininessCode,
                        exactCode
                    );
                }
            }
        } else {
            for (
                functionCode = 1; functionCode < NUM_FUNCTIONS; ++functionCode
            ) {
                if (
                    functionInfos[ functionCode ].attribs & FUNC_ARG_BINARY
                ) {
                    timeFunction(
                        functionCode,
                        roundingPrecision,
                        roundingCode,
                        tininessCode,
                        exactCode
                    );
                }
            }
        }
    }
    return EXIT_SUCCESS;

}

