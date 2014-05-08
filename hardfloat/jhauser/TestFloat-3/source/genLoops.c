
/*
===============================================================================

This C source file is part of TestFloat, Release 2a, a package of programs
for testing the correctness of floating-point arithmetic complying to the
IEC/IEEE Standard for Floating-Point.

Written by John R. Hauser.  More information is available through the Web
page `http://HTTP.CS.Berkeley.EDU/~jhauser/arithmetic/TestFloat.html'.

THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
TIMES RESULT IN INCORRECT BEHAVIOR.  USE OF THIS SOFTWARE IS RESTRICTED TO
PERSONS AND ORGANIZATIONS WHO CAN AND WILL TAKE FULL RESPONSIBILITY FOR ANY
AND ALL LOSSES, COSTS, OR OTHER PROBLEMS ARISING FROM ITS USE.

Derivative works are acceptable, even for commercial purposes, so long as
(1) they include prominent notice that the work is derivative, and (2) they
include prominent notice akin to these four paragraphs for those parts of
this code that are retained.

===============================================================================
*/

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include "fail.h"
#include "softfloat.h"
#include "genCases.h"
#include "writeHex.h"
#include "genLoops.h"

volatile bool genLoops_stop = false;

bool genLoops_forever;
bool genLoops_givenCount;
uint_fast64_t genLoops_count;
int_fast8_t *genLoops_trueFlagsPtr;

union ui32_f32 { uint32_t ui; float32_t f; };
union ui64_f64 { uint64_t ui; float64_t f; };

static void checkEnoughCases( void )
{

    if ( genLoops_givenCount && ( genLoops_count < genCases_total ) ) {
        if ( 2000000000 <= genCases_total ) {
            fail(
                "Too few cases; minimum is %lu%09lu",
                (unsigned long) ( genCases_total / 1000000000 ),
                (unsigned long) ( genCases_total % 1000000000 )
            );
        } else {
            fail(
                "Too few cases; minimum is %lu", (unsigned long) genCases_total
            );
        }
    }

}

static void writeGenOutput_flags( int_fast8_t flags )
{
    int_fast8_t commonFlags;

    commonFlags = 0;
    if ( flags & softfloat_flag_invalid   ) commonFlags |= 0x10;
    if ( flags & softfloat_flag_infinity  ) commonFlags |= 0x08;
    if ( flags & softfloat_flag_overflow  ) commonFlags |= 0x04;
    if ( flags & softfloat_flag_underflow ) commonFlags |= 0x02;
    if ( flags & softfloat_flag_inexact   ) commonFlags |= 0x01;
    writeHex_ui8( commonFlags, '\n' );

}

static bool writeGenOutputs_bool( bool z, int_fast8_t flags )
{

    writeHex_bool( z, ' ' );
    writeGenOutput_flags( flags );
    if ( genLoops_givenCount ) {
        --genLoops_count;
        if ( ! genLoops_count ) return true;
    }
    return false;

}

static bool writeGenOutputs_ui32( uint_fast32_t z, int_fast8_t flags )
{

    writeHex_ui32( z, ' ' );
    writeGenOutput_flags( flags );
    if ( genLoops_givenCount ) {
        --genLoops_count;
        if ( ! genLoops_count ) return true;
    }
    return false;

}

static bool writeGenOutputs_ui64( uint_fast64_t z, int_fast8_t flags )
{

    writeHex_ui64( z, ' ' );
    writeGenOutput_flags( flags );
    if ( genLoops_givenCount ) {
        --genLoops_count;
        if ( ! genLoops_count ) return true;
    }
    return false;

}

void gen_a_ui32( void )
{

    genCases_ui32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_ui32_a_next();
        writeHex_ui32( genCases_ui32_a, '\n' );
        if ( genLoops_givenCount ) {
            --genLoops_count;
            if ( ! genLoops_count ) break;
        }
    }

}

void gen_a_ui64( void )
{

    genCases_ui64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_ui64_a_next();
        writeHex_ui64( genCases_ui64_a, '\n' );
        if ( genLoops_givenCount ) {
            --genLoops_count;
            if ( ! genLoops_count ) break;
        }
    }

}

void gen_a_i32( void )
{

    genCases_i32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_i32_a_next();
        writeHex_ui32( genCases_i32_a, '\n' );
        if ( genLoops_givenCount ) {
            --genLoops_count;
            if ( ! genLoops_count ) break;
        }
    }

}

void gen_a_i64( void )
{

    genCases_i64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_i64_a_next();
        writeHex_ui64( genCases_i64_a, '\n' );
        if ( genLoops_givenCount ) {
            --genLoops_count;
            if ( ! genLoops_count ) break;
        }
    }

}

void gen_a_f32( void )
{
    union ui32_f32 a;

    genCases_f32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_a_next();
        a.f = genCases_f32_a;
        writeHex_ui32( a.ui, '\n' );
        if ( genLoops_givenCount ) {
            --genLoops_count;
            if ( ! genLoops_count ) break;
        }
    }

}

void gen_ab_f32( void )
{
    union ui32_f32 u;

    genCases_f32_ab_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_ab_next();
        u.f = genCases_f32_a;
        writeHex_ui32( u.ui, ' ' );
        u.f = genCases_f32_b;
        writeHex_ui32( u.ui, '\n' );
        if ( genLoops_givenCount ) {
            --genLoops_count;
            if ( ! genLoops_count ) break;
        }
    }

}

void gen_abc_f32( void )
{
    union ui32_f32 u;

    genCases_f32_abc_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_abc_next();
        u.f = genCases_f32_a;
        writeHex_ui32( u.ui, ' ' );
        u.f = genCases_f32_b;
        writeHex_ui32( u.ui, ' ' );
        u.f = genCases_f32_c;
        writeHex_ui32( u.ui, '\n' );
        if ( genLoops_givenCount ) {
            --genLoops_count;
            if ( ! genLoops_count ) break;
        }
    }

}

void gen_a_f64( void )
{
    union ui64_f64 a;

    genCases_f64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_a_next();
        a.f = genCases_f64_a;
        writeHex_ui64( a.ui, '\n' );
        if ( genLoops_givenCount ) {
            --genLoops_count;
            if ( ! genLoops_count ) break;
        }
    }

}

void gen_ab_f64( void )
{
    union ui64_f64 u;

    genCases_f64_ab_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_ab_next();
        u.f = genCases_f64_a;
        writeHex_ui64( u.ui, ' ' );
        u.f = genCases_f64_b;
        writeHex_ui64( u.ui, '\n' );
        if ( genLoops_givenCount ) {
            --genLoops_count;
            if ( ! genLoops_count ) break;
        }
    }

}

void gen_abc_f64( void )
{
    union ui64_f64 u;

    genCases_f64_abc_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_abc_next();
        u.f = genCases_f64_a;
        writeHex_ui64( u.ui, ' ' );
        u.f = genCases_f64_b;
        writeHex_ui64( u.ui, ' ' );
        u.f = genCases_f64_c;
        writeHex_ui64( u.ui, '\n' );
        if ( genLoops_givenCount ) {
            --genLoops_count;
            if ( ! genLoops_count ) break;
        }
    }

}

void gen_a_ui32_z_f32( float32_t trueFunction( uint_fast32_t ) )
{
    union ui32_f32 trueZ;
    int_fast8_t trueFlags;

    genCases_ui32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_ui32_a_next();
        writeHex_ui32( genCases_ui32_a, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ.f = trueFunction( genCases_ui32_a );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( trueZ.ui, trueFlags ) ) break;
    }

}

void gen_a_ui32_z_f64( float64_t trueFunction( uint_fast32_t ) )
{
    union ui64_f64 trueZ;
    int_fast8_t trueFlags;

    genCases_ui32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_ui32_a_next();
        writeHex_ui32( genCases_ui32_a, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ.f = trueFunction( genCases_ui32_a );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( trueZ.ui, trueFlags ) ) break;
    }

}

void gen_a_ui64_z_f32( float32_t trueFunction( uint_fast64_t ) )
{
    union ui32_f32 trueZ;
    int_fast8_t trueFlags;

    genCases_ui64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_ui64_a_next();
        writeHex_ui64( genCases_ui64_a, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ.f = trueFunction( genCases_ui64_a );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( trueZ.ui, trueFlags ) ) break;
    }

}

void gen_a_ui64_z_f64( float64_t trueFunction( uint_fast64_t ) )
{
    union ui64_f64 trueZ;
    int_fast8_t trueFlags;

    genCases_ui64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_ui64_a_next();
        writeHex_ui64( genCases_ui64_a, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ.f = trueFunction( genCases_ui64_a );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( trueZ.ui, trueFlags ) ) break;
    }

}

void gen_a_i32_z_f32( float32_t trueFunction( int_fast32_t ) )
{
    union ui32_f32 trueZ;
    int_fast8_t trueFlags;

    genCases_i32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_i32_a_next();
        writeHex_ui32( genCases_i32_a, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ.f = trueFunction( genCases_i32_a );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( trueZ.ui, trueFlags ) ) break;
    }

}

void gen_a_i32_z_f64( float64_t trueFunction( int_fast32_t ) )
{
    union ui64_f64 trueZ;
    int_fast8_t trueFlags;

    genCases_i32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_i32_a_next();
        writeHex_ui32( genCases_i32_a, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ.f = trueFunction( genCases_i32_a );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( trueZ.ui, trueFlags ) ) break;
    }

}

void gen_a_i64_z_f32( float32_t trueFunction( int_fast64_t ) )
{
    union ui32_f32 trueZ;
    int_fast8_t trueFlags;

    genCases_i64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_i64_a_next();
        writeHex_ui64( genCases_i64_a, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ.f = trueFunction( genCases_i64_a );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( trueZ.ui, trueFlags ) ) break;
    }

}

void gen_a_i64_z_f64( float64_t trueFunction( int_fast64_t ) )
{
    union ui64_f64 trueZ;
    int_fast8_t trueFlags;

    genCases_i64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_i64_a_next();
        writeHex_ui64( genCases_i64_a, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ.f = trueFunction( genCases_i64_a );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( trueZ.ui, trueFlags ) ) break;
    }

}

void
 gen_a_f32_z_ui32_rx(
     uint_fast32_t trueFunction( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    union ui32_f32 a;
    uint_fast32_t trueZ;
    int_fast8_t trueFlags;

    genCases_f32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_a_next();
        a.f = genCases_f32_a;
        writeHex_ui32( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f32_a, roundingMode, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f32_z_ui64_rx(
     uint_fast64_t trueFunction( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    union ui32_f32 a;
    uint_fast64_t trueZ;
    int_fast8_t trueFlags;

    genCases_f32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_a_next();
        a.f = genCases_f32_a;
        writeHex_ui32( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f32_a, roundingMode, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f32_z_i32_rx(
     int_fast32_t trueFunction( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    union ui32_f32 a;
    int_fast32_t trueZ;
    int_fast8_t trueFlags;

    genCases_f32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_a_next();
        a.f = genCases_f32_a;
        writeHex_ui32( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f32_a, roundingMode, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f32_z_i64_rx(
     int_fast64_t trueFunction( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    union ui32_f32 a;
    int_fast64_t trueZ;
    int_fast8_t trueFlags;

    genCases_f32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_a_next();
        a.f = genCases_f32_a;
        writeHex_ui32( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f32_a, roundingMode, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f32_z_ui32_x(
     uint_fast32_t trueFunction( float32_t, bool ), bool exact )
{
    union ui32_f32 a;
    uint_fast32_t trueZ;
    int_fast8_t trueFlags;

    genCases_f32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_a_next();
        a.f = genCases_f32_a;
        writeHex_ui32( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f32_a, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f32_z_ui64_x(
     uint_fast64_t trueFunction( float32_t, bool ), bool exact )
{
    union ui32_f32 a;
    uint_fast64_t trueZ;
    int_fast8_t trueFlags;

    genCases_f32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_a_next();
        a.f = genCases_f32_a;
        writeHex_ui32( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f32_a, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f32_z_i32_x( int_fast32_t trueFunction( float32_t, bool ), bool exact )
{
    union ui32_f32 a;
    int_fast32_t trueZ;
    int_fast8_t trueFlags;

    genCases_f32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_a_next();
        a.f = genCases_f32_a;
        writeHex_ui32( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f32_a, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f32_z_i64_x( int_fast64_t trueFunction( float32_t, bool ), bool exact )
{
    union ui32_f32 a;
    int_fast64_t trueZ;
    int_fast8_t trueFlags;

    genCases_f32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_a_next();
        a.f = genCases_f32_a;
        writeHex_ui32( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f32_a, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( trueZ, trueFlags ) ) break;
    }

}

void gen_a_f32_z_f64( float64_t trueFunction( float32_t ) )
{
    union ui32_f32 a;
    union ui64_f64 trueZ;
    int_fast8_t trueFlags;

    genCases_f32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_a_next();
        a.f = genCases_f32_a;
        writeHex_ui32( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ.f = trueFunction( genCases_f32_a );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( trueZ.ui, trueFlags ) ) break;
    }

}

void gen_az_f32( float32_t trueFunction( float32_t ) )
{
    union ui32_f32 u;
    int_fast8_t trueFlags;

    genCases_f32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_a_next();
        u.f = genCases_f32_a;
        writeHex_ui32( u.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        u.f = trueFunction( genCases_f32_a );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( u.ui, trueFlags ) ) break;
    }

}

void
 gen_az_f32_rx(
     float32_t trueFunction( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    union ui32_f32 u;
    int_fast8_t trueFlags;

    genCases_f32_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_a_next();
        u.f = genCases_f32_a;
        writeHex_ui32( u.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        u.f = trueFunction( genCases_f32_a, roundingMode, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( u.ui, trueFlags ) ) break;
    }

}

void gen_abz_f32( float32_t trueFunction( float32_t, float32_t ) )
{
    union ui32_f32 u;
    int_fast8_t trueFlags;

    genCases_f32_ab_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_ab_next();
        u.f = genCases_f32_a;
        writeHex_ui32( u.ui, ' ' );
        u.f = genCases_f32_b;
        writeHex_ui32( u.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        u.f = trueFunction( genCases_f32_a, genCases_f32_b );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( u.ui, trueFlags ) ) break;
    }

}

void gen_abcz_f32( float32_t trueFunction( float32_t, float32_t, float32_t ) )
{
    union ui32_f32 u;
    int_fast8_t trueFlags;

    genCases_f32_abc_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_abc_next();
        u.f = genCases_f32_a;
        writeHex_ui32( u.ui, ' ' );
        u.f = genCases_f32_b;
        writeHex_ui32( u.ui, ' ' );
        u.f = genCases_f32_c;
        writeHex_ui32( u.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        u.f = trueFunction( genCases_f32_a, genCases_f32_b, genCases_f32_c );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( u.ui, trueFlags ) ) break;
    }

}

void gen_ab_f32_z_bool( bool trueFunction( float32_t, float32_t ) )
{
    union ui32_f32 u;
    bool trueZ;
    int_fast8_t trueFlags;

    genCases_f32_ab_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f32_ab_next();
        u.f = genCases_f32_a;
        writeHex_ui32( u.ui, ' ' );
        u.f = genCases_f32_b;
        writeHex_ui32( u.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f32_a, genCases_f32_b );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_bool( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f64_z_ui32_rx(
     uint_fast32_t trueFunction( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    union ui64_f64 a;
    uint_fast32_t trueZ;
    int_fast8_t trueFlags;

    genCases_f64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_a_next();
        a.f = genCases_f64_a;
        writeHex_ui64( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f64_a, roundingMode, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f64_z_ui64_rx(
     uint_fast64_t trueFunction( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    union ui64_f64 a;
    uint_fast64_t trueZ;
    int_fast8_t trueFlags;

    genCases_f64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_a_next();
        a.f = genCases_f64_a;
        writeHex_ui64( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f64_a, roundingMode, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f64_z_i32_rx(
     int_fast32_t trueFunction( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    union ui64_f64 a;
    int_fast32_t trueZ;
    int_fast8_t trueFlags;

    genCases_f64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_a_next();
        a.f = genCases_f64_a;
        writeHex_ui64( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f64_a, roundingMode, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f64_z_i64_rx(
     int_fast64_t trueFunction( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    union ui64_f64 a;
    int_fast64_t trueZ;
    int_fast8_t trueFlags;

    genCases_f64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_a_next();
        a.f = genCases_f64_a;
        writeHex_ui64( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f64_a, roundingMode, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f64_z_ui32_x(
     uint_fast32_t trueFunction( float64_t, bool ), bool exact )
{
    union ui64_f64 a;
    uint_fast32_t trueZ;
    int_fast8_t trueFlags;

    genCases_f64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_a_next();
        a.f = genCases_f64_a;
        writeHex_ui64( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f64_a, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f64_z_ui64_x(
     uint_fast64_t trueFunction( float64_t, bool ), bool exact )
{
    union ui64_f64 a;
    uint_fast64_t trueZ;
    int_fast8_t trueFlags;

    genCases_f64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_a_next();
        a.f = genCases_f64_a;
        writeHex_ui64( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f64_a, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f64_z_i32_x( int_fast32_t trueFunction( float64_t, bool ), bool exact )
{
    union ui64_f64 a;
    int_fast32_t trueZ;
    int_fast8_t trueFlags;

    genCases_f64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_a_next();
        a.f = genCases_f64_a;
        writeHex_ui64( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f64_a, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( trueZ, trueFlags ) ) break;
    }

}

void
 gen_a_f64_z_i64_x( int_fast64_t trueFunction( float64_t, bool ), bool exact )
{
    union ui64_f64 a;
    int_fast64_t trueZ;
    int_fast8_t trueFlags;

    genCases_f64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_a_next();
        a.f = genCases_f64_a;
        writeHex_ui64( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f64_a, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( trueZ, trueFlags ) ) break;
    }

}

void gen_a_f64_z_f32( float32_t trueFunction( float64_t ) )
{
    union ui64_f64 a;
    union ui32_f32 trueZ;
    int_fast8_t trueFlags;

    genCases_f64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_a_next();
        a.f = genCases_f64_a;
        writeHex_ui64( a.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ.f = trueFunction( genCases_f64_a );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui32( trueZ.ui, trueFlags ) ) break;
    }

}

void gen_az_f64( float64_t trueFunction( float64_t ) )
{
    union ui64_f64 u;
    int_fast8_t trueFlags;

    genCases_f64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_a_next();
        u.f = genCases_f64_a;
        writeHex_ui64( u.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        u.f = trueFunction( genCases_f64_a );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( u.ui, trueFlags ) ) break;
    }

}

void
 gen_az_f64_rx(
     float64_t trueFunction( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    union ui64_f64 u;
    int_fast8_t trueFlags;

    genCases_f64_a_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_a_next();
        u.f = genCases_f64_a;
        writeHex_ui64( u.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        u.f = trueFunction( genCases_f64_a, roundingMode, exact );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( u.ui, trueFlags ) ) break;
    }

}

void gen_abz_f64( float64_t trueFunction( float64_t, float64_t ) )
{
    union ui64_f64 u;
    int_fast8_t trueFlags;

    genCases_f64_ab_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_ab_next();
        u.f = genCases_f64_a;
        writeHex_ui64( u.ui, ' ' );
        u.f = genCases_f64_b;
        writeHex_ui64( u.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        u.f = trueFunction( genCases_f64_a, genCases_f64_b );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( u.ui, trueFlags ) ) break;
    }

}

void gen_abcz_f64( float64_t trueFunction( float64_t, float64_t, float64_t ) )
{
    union ui64_f64 u;
    int_fast8_t trueFlags;

    genCases_f64_abc_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_abc_next();
        u.f = genCases_f64_a;
        writeHex_ui64( u.ui, ' ' );
        u.f = genCases_f64_b;
        writeHex_ui64( u.ui, ' ' );
        u.f = genCases_f64_c;
        writeHex_ui64( u.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        u.f = trueFunction( genCases_f64_a, genCases_f64_b, genCases_f64_c );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_ui64( u.ui, trueFlags ) ) break;
    }

}

void gen_ab_f64_z_bool( bool trueFunction( float64_t, float64_t ) )
{
    union ui64_f64 u;
    bool trueZ;
    int_fast8_t trueFlags;

    genCases_f64_ab_init();
    checkEnoughCases();
    while ( ! genLoops_stop && ( ! genCases_done || genLoops_forever ) ) {
        genCases_f64_ab_next();
        u.f = genCases_f64_a;
        writeHex_ui64( u.ui, ' ' );
        u.f = genCases_f64_b;
        writeHex_ui64( u.ui, ' ' );
        *genLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f64_a, genCases_f64_b );
        trueFlags = *genLoops_trueFlagsPtr;
        if ( writeGenOutputs_bool( trueZ, trueFlags ) ) break;
    }

}

