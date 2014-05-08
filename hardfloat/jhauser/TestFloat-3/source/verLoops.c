
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
#include <stdlib.h>
#include <stdio.h>
#include "fail.h"
#include "softfloat.h"
#include "readHex.h"
#include "verCases.h"
#include "writeCase.h"
#include "verLoops.h"

int_fast8_t *verLoops_trueFlagsPtr;

static bool atEndOfInput( void )
{
    int i;

    i = fgetc( stdin );
    if ( i == EOF ) {
        if ( ! ferror( stdin ) && feof( stdin ) ) return true;
        fail( "Error reading input" );
    }
    ungetc( i, stdin );
    return false;
/*** REMOVE. ***/
#if 0
        return
               ( ( i < '0' ) || ( '9' < i ) )
            && ( ( i < 'A' ) || ( 'F' < i ) )
            && ( ( i < 'a' ) || ( 'f' < i ) );
#endif

}

static void failFromBadInput( void )
{

    fail( "Invalid input format" );

}

static void readVerInput_bool( bool *aPtr )
{

    if ( ! readHex_bool( aPtr, ' ' ) ) failFromBadInput();

}

static void readVerInput_ui32( uint_fast32_t *aPtr )
{
    uint32_t a;

    if ( ! readHex_ui32( &a, ' ' ) ) failFromBadInput();
    *aPtr = a;

}

static void readVerInput_ui64( uint_fast64_t *aPtr )
{
    uint64_t a;

    if ( ! readHex_ui64( &a, ' ' ) ) failFromBadInput();
    *aPtr = a;

}

static void readVerInput_i32( int_fast32_t *aPtr )
{
    union { uint32_t ui; int32_t i; } uA;

    if ( ! readHex_ui32( &uA.ui, ' ' ) ) failFromBadInput();
    *aPtr = uA.i;

}

static void readVerInput_i64( int_fast64_t *aPtr )
{
    union { uint64_t ui; int64_t i; } uA;

    if ( ! readHex_ui64( &uA.ui, ' ' ) ) failFromBadInput();
    *aPtr = uA.i;

}

static void readVerInput_f32( float32_t *aPtr )
{
    union { uint32_t ui; float32_t f; } uA;

    if ( ! readHex_ui32( &uA.ui, ' ' ) ) failFromBadInput();
    *aPtr = uA.f;

}

static void readVerInput_f64( float64_t *aPtr )
{
    union { uint64_t ui; float64_t f; } uA;

    if ( ! readHex_ui64( &uA.ui, ' ' ) ) failFromBadInput();
    *aPtr = uA.f;

}

static void readVerInput_flags( int_fast8_t *flagsPtr )
{
    uint8_t commonFlags;
    int_fast8_t flags;

    if ( ! readHex_ui8( &commonFlags, '\n' ) || ( 0x20 <= commonFlags ) ) {
        failFromBadInput();
    }
    flags = 0;
    if ( commonFlags & 0x10 ) flags |= softfloat_flag_invalid;
    if ( commonFlags & 0x08 ) flags |= softfloat_flag_infinity;
    if ( commonFlags & 0x04 ) flags |= softfloat_flag_overflow;
    if ( commonFlags & 0x02 ) flags |= softfloat_flag_underflow;
    if ( commonFlags & 0x01 ) flags |= softfloat_flag_inexact;
    *flagsPtr = flags;

}

void ver_a_ui32_z_f32( float32_t trueFunction( uint_fast32_t ) )
{
    int count;
    uint_fast32_t a;
    float32_t testZ;
    int_fast8_t testFlags;
    float32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_ui32( &a );
        readVerInput_f32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f32_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! f32_isNaN( trueZ )
                || ! f32_isNaN( testZ )
                || f32_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_ui32( a, "  " );
                writeCase_z_f32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void ver_a_ui32_z_f64( float64_t trueFunction( uint_fast32_t ) )
{
    int count;
    uint_fast32_t a;
    float64_t testZ;
    int_fast8_t testFlags;
    float64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_ui32( &a );
        readVerInput_f64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f64_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! f64_isNaN( trueZ )
                || ! f64_isNaN( testZ )
                || f64_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_ui32( a, "  " );
                writeCase_z_f64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#ifdef FLOATX80

void ver_a_ui32_z_fx80( floatx80_t trueFunction( uint_fast32_t ) )
{
    int count;
    uint_fast32_t a;
    floatx80_t testZ;
    int_fast8_t testFlags;
    floatx80_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_ui32( &a );
        readVerInput_fx80( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! fx80_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! fx80_isNaN( trueZ )
                || ! fx80_isNaN( testZ )
                || fx80_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_ui32( a, "  " );
                writeCase_z_fx80( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#endif

#ifdef FLOAT128

void ver_a_ui32_z_f128( float128_t trueFunction( uint_fast32_t ) )
{
    int count;
    uint_fast32_t a;
    float128_t testZ;
    int_fast8_t testFlags;
    float128_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_ui32( &a );
        readVerInput_f128( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f128_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! f128_isNaN( trueZ )
                || ! f128_isNaN( testZ )
                || f128_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_ui32( a, "  " );
                writeCase_z_f128( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#endif

void ver_a_ui64_z_f32( float32_t trueFunction( uint_fast64_t ) )
{
    int count;
    uint_fast64_t a;
    float32_t testZ;
    int_fast8_t testFlags;
    float32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_ui64( &a );
        readVerInput_f32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f32_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! f32_isNaN( trueZ )
                || ! f32_isNaN( testZ )
                || f32_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_ui64( a, "  " );
                writeCase_z_f32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void ver_a_ui64_z_f64( float64_t trueFunction( uint_fast64_t ) )
{
    int count;
    uint_fast64_t a;
    float64_t testZ;
    int_fast8_t testFlags;
    float64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_ui64( &a );
        readVerInput_f64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f64_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! f64_isNaN( trueZ )
                || ! f64_isNaN( testZ )
                || f64_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_ui64( a, "  " );
                writeCase_z_f64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#ifdef FLOATX80

void ver_a_ui64_z_fx80( floatx80_t trueFunction( uint_fast64_t ) )
{
    int count;
    uint_fast64_t a;
    floatx80_t testZ;
    int_fast8_t testFlags;
    floatx80_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_ui64( &a );
        readVerInput_fx80( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! fx80_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! fx80_isNaN( trueZ )
                || ! fx80_isNaN( testZ )
                || fx80_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_ui64( a, "  " );
                writeCase_z_fx80( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#endif

#ifdef FLOAT128

void ver_a_ui64_z_f128( float128_t trueFunction( uint_fast64_t ) )
{
    int count;
    uint_fast64_t a;
    float128_t testZ;
    int_fast8_t testFlags;
    float128_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_ui64( &a );
        readVerInput_f128( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f128_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! f128_isNaN( trueZ )
                || ! f128_isNaN( testZ )
                || f128_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_ui64( a, "  " );
                writeCase_z_f128( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#endif

void ver_a_i32_z_f32( float32_t trueFunction( int_fast32_t ) )
{
    int count;
    int_fast32_t a;
    float32_t testZ;
    int_fast8_t testFlags;
    float32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_i32( &a );
        readVerInput_f32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f32_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! f32_isNaN( trueZ )
                || ! f32_isNaN( testZ )
                || f32_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_i32( a, "  " );
                writeCase_z_f32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void ver_a_i32_z_f64( float64_t trueFunction( int_fast32_t ) )
{
    int count;
    int_fast32_t a;
    float64_t testZ;
    int_fast8_t testFlags;
    float64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_i32( &a );
        readVerInput_f64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f64_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! f64_isNaN( trueZ )
                || ! f64_isNaN( testZ )
                || f64_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_i32( a, "  " );
                writeCase_z_f64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#ifdef FLOATX80

void ver_a_i32_z_fx80( floatx80_t trueFunction( int_fast32_t ) )
{
    int count;
    int_fast32_t a;
    floatx80_t testZ;
    int_fast8_t testFlags;
    floatx80_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_i32( &a );
        readVerInput_fx80( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! fx80_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! fx80_isNaN( trueZ )
                || ! fx80_isNaN( testZ )
                || fx80_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_i32( a, "  " );
                writeCase_z_fx80( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#endif

#ifdef FLOAT128

void ver_a_i32_z_f128( float128_t trueFunction( int_fast32_t ) )
{
    int count;
    int_fast32_t a;
    float128_t testZ;
    int_fast8_t testFlags;
    float128_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_i32( &a );
        readVerInput_f128( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f128_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! f128_isNaN( trueZ )
                || ! f128_isNaN( testZ )
                || f128_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_i32( a, "  " );
                writeCase_z_f128( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#endif

void ver_a_i64_z_f32( float32_t trueFunction( int_fast64_t ) )
{
    int count;
    int_fast64_t a;
    float32_t testZ;
    int_fast8_t testFlags;
    float32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_i64( &a );
        readVerInput_f32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f32_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! f32_isNaN( trueZ )
                || ! f32_isNaN( testZ )
                || f32_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_i64( a, "  " );
                writeCase_z_f32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void ver_a_i64_z_f64( float64_t trueFunction( int_fast64_t ) )
{
    int count;
    int_fast64_t a;
    float64_t testZ;
    int_fast8_t testFlags;
    float64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_i64( &a );
        readVerInput_f64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f64_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! f64_isNaN( trueZ )
                || ! f64_isNaN( testZ )
                || f64_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_i64( a, "  " );
                writeCase_z_f64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#ifdef FLOATX80

void ver_a_i64_z_fx80( floatx80_t trueFunction( int_fast64_t ) )
{
    int count;
    int_fast64_t a;
    floatx80_t testZ;
    int_fast8_t testFlags;
    floatx80_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_i64( &a );
        readVerInput_fx80( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! fx80_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! fx80_isNaN( trueZ )
                || ! fx80_isNaN( testZ )
                || fx80_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_i64( a, "  " );
                writeCase_z_fx80( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#endif

#ifdef FLOAT128

void ver_a_i64_z_f128( float128_t trueFunction( int_fast64_t ) )
{
    int count;
    int_fast64_t a;
    float128_t testZ;
    int_fast8_t testFlags;
    float128_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_i64( &a );
        readVerInput_f128( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f128_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   verCases_checkNaNs
                || ! f128_isNaN( trueZ )
                || ! f128_isNaN( testZ )
                || f128_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_i64( a, "  " );
                writeCase_z_f128( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#endif

void
 ver_a_f32_z_ui32_rx(
     uint_fast32_t trueFunction( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int count;
    float32_t a;
    uint_fast32_t testZ;
    int_fast8_t testFlags;
    uint_fast32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_ui32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, roundingMode, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f32_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != 0xFFFFFFFF )
                || ( testZ != 0xFFFFFFFF )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( a, "  " );
                writeCase_z_ui32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f32_z_ui64_rx(
     uint_fast64_t trueFunction( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int count;
    float32_t a;
    uint_fast64_t testZ;
    int_fast8_t testFlags;
    uint_fast64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_ui64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, roundingMode, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f32_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != UINT64_C( 0xFFFFFFFFFFFFFFFF ) )
                || ( testZ != UINT64_C( 0xFFFFFFFFFFFFFFFF ) )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( a, "  " );
                writeCase_z_ui64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f32_z_i32_rx(
     int_fast32_t trueFunction( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int count;
    float32_t a;
    int_fast32_t testZ;
    int_fast8_t testFlags;
    int_fast32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_i32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, roundingMode, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f32_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != 0x7FFFFFFF )
                || ( ( testZ != 0x7FFFFFFF ) && ( testZ != -0x7FFFFFFF - 1 ) )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( a, "  " );
                writeCase_z_i32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f32_z_i64_rx(
     int_fast64_t trueFunction( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int count;
    float32_t a;
    int_fast64_t testZ;
    int_fast8_t testFlags;
    int_fast64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_i64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, roundingMode, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f32_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != INT64_C( 0x7FFFFFFFFFFFFFFF ) )
                || (    ( testZ != INT64_C( 0x7FFFFFFFFFFFFFFF ) )
                     && ( testZ != - INT64_C( 0x7FFFFFFFFFFFFFFF ) - 1 ) )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( a, "  " );
                writeCase_z_i64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f32_z_ui32_x(
     uint_fast32_t trueFunction( float32_t, bool ), bool exact )
{
    int count;
    float32_t a;
    uint_fast32_t testZ;
    int_fast8_t testFlags;
    uint_fast32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_ui32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f32_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != 0xFFFFFFFF )
                || ( testZ != 0xFFFFFFFF )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( a, "  " );
                writeCase_z_ui32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f32_z_ui64_x(
     uint_fast64_t trueFunction( float32_t, bool ), bool exact )
{
    int count;
    float32_t a;
    uint_fast64_t testZ;
    int_fast8_t testFlags;
    uint_fast64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_ui64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f32_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != UINT64_C( 0xFFFFFFFFFFFFFFFF ) )
                || ( testZ != UINT64_C( 0xFFFFFFFFFFFFFFFF ) )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( a, "  " );
                writeCase_z_ui64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f32_z_i32_x(
     int_fast32_t trueFunction( float32_t, bool ), bool exact )
{
    int count;
    float32_t a;
    int_fast32_t testZ;
    int_fast8_t testFlags;
    int_fast32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_i32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f32_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != 0x7FFFFFFF )
                || ( ( testZ != 0x7FFFFFFF ) && ( testZ != -0x7FFFFFFF - 1 ) )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( a, "  " );
                writeCase_z_i32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f32_z_i64_x(
     int_fast64_t trueFunction( float32_t, bool ), bool exact )
{
    int count;
    float32_t a;
    int_fast64_t testZ;
    int_fast8_t testFlags;
    int_fast64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_i64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f32_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != INT64_C( 0x7FFFFFFFFFFFFFFF ) )
                || (    ( testZ != INT64_C( 0x7FFFFFFFFFFFFFFF ) )
                     && ( testZ != - INT64_C( 0x7FFFFFFFFFFFFFFF ) - 1 ) )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( a, "  " );
                writeCase_z_i64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void ver_a_f32_z_f64( float64_t trueFunction( float32_t ) )
{
    int count;
    float32_t a;
    float64_t testZ;
    int_fast8_t testFlags;
    float64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_f64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f64_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f32_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! f64_isNaN( trueZ )
                || ! f64_isNaN( testZ )
                || f64_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( a, "  " );
                writeCase_z_f64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#ifdef FLOATX80

void ver_a_f32_z_fx80( floatx80_t trueFunction( float32_t ) )
{
    int count;
    float32_t a;
    floatx80_t testZ;
    int_fast8_t testFlags;
    floatx80_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_fx80( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! fx80_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f32_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! fx80_isNaN( trueZ )
                || ! fx80_isNaN( testZ )
                || fx80_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( a, "  " );
                writeCase_z_fx80( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#endif

#ifdef FLOAT128

void ver_a_f32_z_f128( float128_t trueFunction( float32_t ) )
{
    int count;
    float32_t a;
    float128_t testZ;
    int_fast8_t testFlags;
    float128_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_f128( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f128_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f32_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! f128_isNaN( trueZ )
                || ! f128_isNaN( testZ )
                || f128_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( a, "  " );
                writeCase_z_f128( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#endif

void ver_az_f32( float32_t trueFunction( float32_t ) )
{
    int count;
    float32_t a, testZ;
    int_fast8_t testFlags;
    float32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_f32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f32_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f32_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! f32_isNaN( trueZ )
                || ! f32_isNaN( testZ )
                || f32_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( a, "  " );
                writeCase_z_f32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_az_f32_rx(
     float32_t trueFunction( float32_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int count;
    float32_t a, testZ;
    int_fast8_t testFlags;
    float32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_f32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, roundingMode, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f32_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f32_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! f32_isNaN( trueZ )
                || ! f32_isNaN( testZ )
                || f32_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( a, "  " );
                writeCase_z_f32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void ver_abz_f32( float32_t trueFunction( float32_t, float32_t ) )
{
    int count;
    float32_t a, b, testZ;
    int_fast8_t testFlags;
    float32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_f32( &b );
        readVerInput_f32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, b );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f32_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   ! verCases_checkNaNs
                && ( f32_isSignalingNaN( a ) || f32_isSignalingNaN( b ) )
            ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! f32_isNaN( trueZ )
                || ! f32_isNaN( testZ )
                || f32_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_ab_f32( a, b, "  " );
                writeCase_z_f32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void ver_abcz_f32( float32_t trueFunction( float32_t, float32_t, float32_t ) )
{
    int count;
    float32_t a, b, c, testZ;
    int_fast8_t testFlags;
    float32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_f32( &b );
        readVerInput_f32( &c );
        readVerInput_f32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, b, c );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f32_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   ! verCases_checkNaNs
                && ( f32_isSignalingNaN( a ) || f32_isSignalingNaN( b )
                         || f32_isSignalingNaN( c ) )
            ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! f32_isNaN( trueZ )
                || ! f32_isNaN( testZ )
                || f32_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_abc_f32( a, b, c, "\n\t" );
                writeCase_z_f32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void ver_ab_f32_z_bool( bool trueFunction( float32_t, float32_t ) )
{
    int count;
    float32_t a, b;
    bool testZ;
    int_fast8_t testFlags;
    bool trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f32( &a );
        readVerInput_f32( &b );
        readVerInput_bool( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, b );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   ! verCases_checkNaNs
                && ( f32_isSignalingNaN( a ) || f32_isSignalingNaN( b ) )
            ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_ab_f32( a, b, "  " );
                writeCase_z_bool( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f64_z_ui32_rx(
     uint_fast32_t trueFunction( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int count;
    float64_t a;
    uint_fast32_t testZ;
    int_fast8_t testFlags;
    uint_fast32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_ui32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, roundingMode, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f64_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != 0xFFFFFFFF )
                || ( testZ != 0xFFFFFFFF )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f64( a, "  " );
                writeCase_z_ui32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f64_z_ui64_rx(
     uint_fast64_t trueFunction( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int count;
    float64_t a;
    uint_fast64_t testZ;
    int_fast8_t testFlags;
    uint_fast64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_ui64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, roundingMode, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f64_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != UINT64_C( 0xFFFFFFFFFFFFFFFF ) )
                || ( testZ != UINT64_C( 0xFFFFFFFFFFFFFFFF ) )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f64( a, "  " );
                writeCase_z_ui64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f64_z_i32_rx(
     int_fast32_t trueFunction( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int count;
    float64_t a;
    int_fast32_t testZ;
    int_fast8_t testFlags;
    int_fast32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_i32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, roundingMode, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f64_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != 0x7FFFFFFF )
                || ( ( testZ != 0x7FFFFFFF ) && ( testZ != -0x7FFFFFFF - 1 ) )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f64( a, "  " );
                writeCase_z_i32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f64_z_i64_rx(
     int_fast64_t trueFunction( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int count;
    float64_t a;
    int_fast64_t testZ;
    int_fast8_t testFlags;
    int_fast64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_i64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, roundingMode, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f64_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != INT64_C( 0x7FFFFFFFFFFFFFFF ) )
                || (    ( testZ != INT64_C( 0x7FFFFFFFFFFFFFFF ) )
                     && ( testZ != - INT64_C( 0x7FFFFFFFFFFFFFFF ) - 1 ) )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f64( a, "  " );
                writeCase_z_i64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f64_z_ui32_x(
     uint_fast32_t trueFunction( float64_t, bool ), bool exact )
{
    int count;
    float64_t a;
    uint_fast32_t testZ;
    int_fast8_t testFlags;
    uint_fast32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_ui32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f64_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != 0xFFFFFFFF )
                || ( testZ != 0xFFFFFFFF )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f64( a, "  " );
                writeCase_z_ui32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f64_z_ui64_x(
     uint_fast64_t trueFunction( float64_t, bool ), bool exact )
{
    int count;
    float64_t a;
    uint_fast64_t testZ;
    int_fast8_t testFlags;
    uint_fast64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_ui64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f64_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != UINT64_C( 0xFFFFFFFFFFFFFFFF ) )
                || ( testZ != UINT64_C( 0xFFFFFFFFFFFFFFFF ) )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f64( a, "  " );
                writeCase_z_ui64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f64_z_i32_x(
     int_fast32_t trueFunction( float64_t, bool ), bool exact )
{
    int count;
    float64_t a;
    int_fast32_t testZ;
    int_fast8_t testFlags;
    int_fast32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_i32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f64_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != 0x7FFFFFFF )
                || ( ( testZ != 0x7FFFFFFF ) && ( testZ != -0x7FFFFFFF - 1 ) )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f64( a, "  " );
                writeCase_z_i32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_a_f64_z_i64_x(
     int_fast64_t trueFunction( float64_t, bool ), bool exact )
{
    int count;
    float64_t a;
    int_fast64_t testZ;
    int_fast8_t testFlags;
    int_fast64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_i64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f64_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != INT64_C( 0x7FFFFFFFFFFFFFFF ) )
                || (    ( testZ != INT64_C( 0x7FFFFFFFFFFFFFFF ) )
                     && ( testZ != - INT64_C( 0x7FFFFFFFFFFFFFFF ) - 1 ) )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f64( a, "  " );
                writeCase_z_i64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void ver_a_f64_z_f32( float32_t trueFunction( float64_t ) )
{
    int count;
    float64_t a;
    float32_t testZ;
    int_fast8_t testFlags;
    float32_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_f32( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f32_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f64_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! f32_isNaN( trueZ )
                || ! f32_isNaN( testZ )
                || f32_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f64( a, "  " );
                writeCase_z_f32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#ifdef FLOATX80

void ver_a_f64_z_fx80( floatx80_t trueFunction( float64_t ) )
{
    int count;
    float64_t a;
    floatx80_t testZ;
    int_fast8_t testFlags;
    floatx80_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_fx80( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! fx80_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f64_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! fx80_isNaN( trueZ )
                || ! fx80_isNaN( testZ )
                || fx80_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f64( a, "  " );
                writeCase_z_fx80( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#endif

#ifdef FLOAT128

void ver_a_f64_z_f128( float128_t trueFunction( float64_t ) )
{
    int count;
    float64_t a;
    float128_t testZ;
    int_fast8_t testFlags;
    float128_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_f128( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f128_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f64_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! f128_isNaN( trueZ )
                || ! f128_isNaN( testZ )
                || f128_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f64( a, "  " );
                writeCase_z_f128( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

#endif

void ver_az_f64( float64_t trueFunction( float64_t ) )
{
    int count;
    float64_t a, testZ;
    int_fast8_t testFlags;
    float64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_f64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f64_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f64_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! f64_isNaN( trueZ )
                || ! f64_isNaN( testZ )
                || f64_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f64( a, "  " );
                writeCase_z_f64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void
 ver_az_f64_rx(
     float64_t trueFunction( float64_t, int_fast8_t, bool ),
     int_fast8_t roundingMode,
     bool exact
 )
{
    int count;
    float64_t a, testZ;
    int_fast8_t testFlags;
    float64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_f64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, roundingMode, exact );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f64_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if ( ! verCases_checkNaNs && f64_isSignalingNaN( a ) ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! f64_isNaN( trueZ )
                || ! f64_isNaN( testZ )
                || f64_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f64( a, "  " );
                writeCase_z_f64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void ver_abz_f64( float64_t trueFunction( float64_t, float64_t ) )
{
    int count;
    float64_t a, b, testZ;
    int_fast8_t testFlags;
    float64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_f64( &b );
        readVerInput_f64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, b );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f64_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   ! verCases_checkNaNs
                && ( f64_isSignalingNaN( a ) || f64_isSignalingNaN( b ) )
            ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! f64_isNaN( trueZ )
                || ! f64_isNaN( testZ )
                || f64_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_ab_f64( a, b, "\n\t" );
                writeCase_z_f64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void ver_abcz_f64( float64_t trueFunction( float64_t, float64_t, float64_t ) )
{
    int count;
    float64_t a, b, c, testZ;
    int_fast8_t testFlags;
    float64_t trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_f64( &b );
        readVerInput_f64( &c );
        readVerInput_f64( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, b, c );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ! f64_same( trueZ, testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   ! verCases_checkNaNs
                && ( f64_isSignalingNaN( a ) || f64_isSignalingNaN( b )
                         || f64_isSignalingNaN( c ) )
            ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   verCases_checkNaNs
                || ! f64_isNaN( trueZ )
                || ! f64_isNaN( testZ )
                || f64_isSignalingNaN( testZ )
                || ( trueFlags != testFlags )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_abc_f64( a, b, c, "\n\t" );
                writeCase_z_f64( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

void ver_ab_f64_z_bool( bool trueFunction( float64_t, float64_t ) )
{
    int count;
    float64_t a, b;
    bool testZ;
    int_fast8_t testFlags;
    bool trueZ;
    int_fast8_t trueFlags;

    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! atEndOfInput() ) {
        readVerInput_f64( &a );
        readVerInput_f64( &b );
        readVerInput_bool( &testZ );
        readVerInput_flags( &testFlags );
        *verLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( a, b );
        trueFlags = *verLoops_trueFlagsPtr;
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if (
                   ! verCases_checkNaNs
                && ( f64_isSignalingNaN( a ) || f64_isSignalingNaN( b ) )
            ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_ab_f64( a, b, "  " );
                writeCase_z_bool( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

