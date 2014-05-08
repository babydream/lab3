
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
#include "softfloat.h"

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

extern const char *verCases_functionNamePtr;
extern int_fast8_t verCases_roundingPrecision;
extern int_fast8_t verCases_roundingCode;
extern int_fast8_t verCases_tininessCode;
extern bool verCases_usesExact, verCases_exact;
extern bool verCases_checkNaNs;
extern uint_fast32_t verCases_maxErrorCount;
extern bool verCases_errorStop;

void verCases_writeFunctionName( FILE * );

extern volatile bool verCases_stop;

extern bool verCases_anyErrors;

void verCases_exitWithStatus( void );

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

INLINE bool f32_same( float32_t a, float32_t b )
{
    union { uint32_t ui; float32_t f; } uA, uB;
    uA.f = a;
    uB.f = b;
    return ( uA.ui == uB.ui );
}

INLINE bool f32_isNaN( float32_t a )
{
    union { uint32_t ui; float32_t f; } uA;
    uA.f = a;
    return 0x7F800000 < ( uA.ui & 0x7FFFFFFF );
}

INLINE bool f64_same( float64_t a, float64_t b )
{
    union { uint64_t ui; float64_t f; } uA, uB;
    uA.f = a;
    uB.f = b;
    return ( uA.ui == uB.ui );
}

INLINE bool f64_isNaN( float64_t a )
{
    union { uint64_t ui; float64_t f; } uA;
    uA.f = a;
    return
        UINT64_C( 0x7FF0000000000000 )
            < ( uA.ui & UINT64_C( 0x7FFFFFFFFFFFFFFF ) );
}


/*** OUT-OF-DATE. ***/

#ifdef FLOATX80

INLINE bool fx80_same( floatx80_t a, floatx80_t b )
{
     return ( a.high == b.high ) && ( a.low == b.low );
}

INLINE bool fx80_isNaN( floatx80_t a )
{
    return ( ( a.high & 0x7FFF ) == 0x7FFF ) && a.low;
}

#endif

#ifdef FLOAT128

INLINE bool f128_same( float128_t a, float128_t b )
{
    return ( a.high == b.high ) && ( a.low == b.low );
}

INLINE bool f128_isNaN( float128_t a )
{
    uint_fast64_t absAHigh;
    absAHigh = a.high & UINT64_C( 0x7FFFFFFFFFFFFFFF );
    return
           ( UINT64_C( 0x7FFF000000000000 ) < absAHigh )
        || ( ( absAHigh == UINT64_C( 0x7FFF000000000000 ) ) && a.low );
}

#endif



extern uint_fast32_t verCases_tenThousandsCount, verCases_errorCount;

void verCases_writeTestsPerformed( int );
void verCases_perTenThousand( void );
void verCases_writeErrorFound( int );

