
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
#include <fenv.h>
#include <math.h>
#include "softfloat.h"
#include "systfloat_config.h"
#include "systfloat.h"

/*** INCLUDE OTHER LIBRARY FUNCTIONS FROM C-1999. ***/

#pragma STDC FENV_ACCESS ON

void systfloat_setRoundingMode( int_fast8_t roundingMode )
{

    fesetround(
          ( roundingMode == softfloat_round_nearest_even ) ? FE_TONEAREST
        : ( roundingMode == softfloat_round_minMag       ) ? FE_TOWARDZERO
        : ( roundingMode == softfloat_round_min          ) ? FE_DOWNWARD
        : FE_UPWARD
    );

}

int_fast8_t systfloat_clearExceptionFlags( void )
{
    int systExceptionFlags;
    int_fast8_t exceptionFlags;

    systExceptionFlags =
        fetestexcept(
            FE_INVALID | FE_DIVBYZERO | FE_OVERFLOW | FE_UNDERFLOW | FE_INEXACT
        );
    feclearexcept(
        FE_INVALID | FE_DIVBYZERO | FE_OVERFLOW | FE_UNDERFLOW | FE_INEXACT );
    exceptionFlags = 0;
    if ( systExceptionFlags & FE_INVALID ) {
        exceptionFlags |= softfloat_flag_invalid;
    }
    if ( systExceptionFlags & FE_DIVBYZERO ) {
        exceptionFlags |= softfloat_flag_infinity;
    }
    if ( systExceptionFlags & FE_OVERFLOW ) {
        exceptionFlags |= softfloat_flag_overflow;
    }
    if ( systExceptionFlags & FE_UNDERFLOW ) {
        exceptionFlags |= softfloat_flag_underflow;
    }
    if ( systExceptionFlags & FE_INEXACT ) {
        exceptionFlags |= softfloat_flag_inexact;
    }
    return exceptionFlags;

}

union f32_f { float32_t f32; float f; };
union f64_d { float64_t f64; double d; };

float32_t syst_ui32_to_f32( uint_fast32_t a )
{
    union f32_f uZ;

    uZ.f = a;
    return uZ.f32;

}

float64_t syst_ui32_to_f64( uint_fast32_t a )
{
    union f64_d uZ;

    uZ.d = a;
    return uZ.f64;

}

float32_t syst_ui64_to_f32( uint_fast64_t a )
{
    union f32_f uZ;

    uZ.f = a;
    return uZ.f32;

}

float64_t syst_ui64_to_f64( uint_fast64_t a )
{
    union f64_d uZ;

    uZ.d = a;
    return uZ.f64;

}

float32_t syst_i32_to_f32( int_fast32_t a )
{
    union f32_f uZ;

    uZ.f = a;
    return uZ.f32;

}

float64_t syst_i32_to_f64( int_fast32_t a )
{
    union f64_d uZ;

    uZ.d = a;
    return uZ.f64;

}

float32_t syst_i64_to_f32( int_fast64_t a )
{
    union f32_f uZ;

    uZ.f = a;
    return uZ.f32;

}

float64_t syst_i64_to_f64( int_fast64_t a )
{
    union f64_d uZ;

    uZ.d = a;
    return uZ.f64;

}

uint_fast32_t syst_f32_to_ui32_rx_minMag( float32_t a )
{
    union f32_f uA;

    uA.f32 = a;
    return (uint32_t) uA.f;

}

uint_fast64_t syst_f32_to_ui64_rx_minMag( float32_t a )
{
    union f32_f uA;

    uA.f32 = a;
    return (uint64_t) uA.f;

}

int_fast32_t syst_f32_to_i32_rx_minMag( float32_t a )
{
    union f32_f uA;

    uA.f32 = a;
    return (int32_t) uA.f;

}

int_fast64_t syst_f32_to_i64_rx_minMag( float32_t a )
{
    union f32_f uA;

    uA.f32 = a;
    return (int64_t) uA.f;

}

float64_t syst_f32_to_f64( float32_t a )
{
    union f32_f uA;
    union f64_d uZ;

    uA.f32 = a;
    uZ.d = uA.f;
    return uZ.f64;

}

float32_t syst_f32_add( float32_t a, float32_t b )
{
    union f32_f uA, uB, uZ;

    uA.f32 = a;
    uB.f32 = b;
    uZ.f = uA.f + uB.f;
    return uZ.f32;

}

float32_t syst_f32_sub( float32_t a, float32_t b )
{
    union f32_f uA, uB, uZ;

    uA.f32 = a;
    uB.f32 = b;
    uZ.f = uA.f - uB.f;
    return uZ.f32;

}

float32_t syst_f32_mul( float32_t a, float32_t b )
{
    union f32_f uA, uB, uZ;

    uA.f32 = a;
    uB.f32 = b;
    uZ.f = uA.f * uB.f;
    return uZ.f32;

}

float32_t syst_f32_div( float32_t a, float32_t b )
{
    union f32_f uA, uB, uZ;

    uA.f32 = a;
    uB.f32 = b;
    uZ.f = uA.f / uB.f;
    return uZ.f32;

}

bool syst_f32_eq( float32_t a, float32_t b )
{
    union f32_f uA, uB;

    uA.f32 = a;
    uB.f32 = b;
    return ( uA.f == uB.f );

}

bool syst_f32_le( float32_t a, float32_t b )
{
    union f32_f uA, uB;

    uA.f32 = a;
    uB.f32 = b;
    return ( uA.f <= uB.f );

}

bool syst_f32_lt( float32_t a, float32_t b )
{
    union f32_f uA, uB;

    uA.f32 = a;
    uB.f32 = b;
    return ( uA.f < uB.f );

}

uint_fast32_t syst_f64_to_ui32_rx_minMag( float64_t a )
{
    union f64_d uA;

    uA.f64 = a;
    return (uint32_t) uA.d;

}

uint_fast64_t syst_f64_to_ui64_rx_minMag( float64_t a )
{
    union f64_d uA;

    uA.f64 = a;
    return (uint64_t) uA.d;

}

int_fast32_t syst_f64_to_i32_rx_minMag( float64_t a )
{
    union f64_d uA;

    uA.f64 = a;
    return (int32_t) uA.d;

}

int_fast64_t syst_f64_to_i64_rx_minMag( float64_t a )
{
    union f64_d uA;

    uA.f64 = a;
    return (int64_t) uA.d;

}

float32_t syst_f64_to_f32( float64_t a )
{
    union f64_d uA;
    union f32_f uZ;

    uA.f64 = a;
    uZ.f = uA.d;
    return uZ.f32;

}

float64_t syst_f64_add( float64_t a, float64_t b )
{
    union f64_d uA, uB, uZ;

    uA.f64 = a;
    uB.f64 = b;
    uZ.d = uA.d + uB.d;
    return uZ.f64;

}

float64_t syst_f64_sub( float64_t a, float64_t b )
{
    union f64_d uA, uB, uZ;

    uA.f64 = a;
    uB.f64 = b;
    uZ.d = uA.d - uB.d;
    return uZ.f64;

}

float64_t syst_f64_mul( float64_t a, float64_t b )
{
    union f64_d uA, uB, uZ;

    uA.f64 = a;
    uB.f64 = b;
    uZ.d = uA.d * uB.d;
    return uZ.f64;

}

float64_t syst_f64_div( float64_t a, float64_t b )
{
    union f64_d uA, uB, uZ;

    uA.f64 = a;
    uB.f64 = b;
    uZ.d = uA.d / uB.d;
    return uZ.f64;

}

float64_t syst_f64_sqrt( float64_t a )
{
    union f64_d uA, uZ;

    uA.f64 = a;
    uZ.d = sqrt( uA.d );
    return uZ.f64;

}

bool syst_f64_eq( float64_t a, float64_t b )
{
    union f64_d uA, uB;

    uA.f64 = a;
    uB.f64 = b;
    return ( uA.d == uB.d );

}

bool syst_f64_le( float64_t a, float64_t b )
{
    union f64_d uA, uB;

    uA.f64 = a;
    uB.f64 = b;
    return ( uA.d <= uB.d );

}

bool syst_f64_lt( float64_t a, float64_t b )
{
    union f64_d uA, uB;

    uA.f64 = a;
    uB.f64 = b;
    return ( uA.d < uB.d );

}

#if defined FLOATX80 && defined LONG_DOUBLE_IS_FLOATX80

union fx80_ld { floatx80_t fx80; long double ld; };

floatx80_t syst_ui32_to_fx80( uint_fast32_t a )
{
    union fx80_ld uZ;

    uZ.ld = a;
    return uZ.fx80;

}

floatx80_t syst_ui64_to_fx80( uint_fast64_t a )
{
    union fx80_ld uZ;

    uZ.ld = a;
    return uZ.fx80;

}

floatx80_t syst_i32_to_fx80( int_fast32_t a )
{
    union fx80_ld uZ;

    uZ.ld = a;
    return uZ.fx80;

}

floatx80_t syst_i64_to_fx80( int_fast64_t a )
{
    union fx80_ld uZ;

    uZ.ld = a;
    return uZ.fx80;

}

floatx80_t syst_f32_to_fx80( float32_t a )
{
    union f32_f uA;
    union fx80_ld uZ;

    uA.f32 = a;
    uZ.ld = uA.f;
    return uZ.fx80;

}

floatx80_t syst_f64_to_fx80( float64_t a )
{
    union f64_d uA;
    union fx80_ld uZ;

    uA.f64 = a;
    uZ.ld = uA.d;
    return uZ.fx80;

}

uint_fast32_t syst_fx80_to_ui32_rx_minMag( floatx80_t a )
{
    union fx80_ld uA;

    uA.fx80 = a;
    return (uint32_t) uA.ld;

}

uint_fast64_t syst_fx80_to_ui64_rx_minMag( floatx80_t a )
{
    union fx80_ld uA;

    uA.fx80 = a;
    return (uint64_t) uA.ld;

}

int_fast32_t syst_fx80_to_i32_rx_minMag( floatx80_t a )
{
    union fx80_ld uA;

    uA.fx80 = a;
    return (int32_t) uA.ld;

}

int_fast64_t syst_fx80_to_i64_rx_minMag( floatx80_t a )
{
    union fx80_ld uA;

    uA.fx80 = a;
    return (int64_t) uA.ld;

}

float32_t syst_fx80_to_f32( floatx80_t a )
{
    union fx80_ld uA;
    union f32_f uZ;

    uA.fx80 = a;
    uZ.f = uA.ld;
    return uZ.f32;

}

float64_t syst_fx80_to_f64( floatx80_t a )
{
    union fx80_ld uA;
    union f64_d uZ;

    uA.fx80 = a;
    uZ.d = uA.ld;
    return uZ.f64;

}

floatx80_t syst_fx80_add( floatx80_t a, floatx80_t b )
{
    union fx80_ld uA, uB, uZ;

    uA.fx80 = a;
    uB.fx80 = b;
    uZ.ld = uA.ld + uB.ld;
    return uZ.fx80;

}

floatx80_t syst_fx80_sub( floatx80_t a, floatx80_t b )
{
    union fx80_ld uA, uB, uZ;

    uA.fx80 = a;
    uB.fx80 = b;
    uZ.ld = uA.ld - uB.ld;
    return uZ.fx80;

}

floatx80_t syst_fx80_mul( floatx80_t a, floatx80_t b )
{
    union fx80_ld uA, uB, uZ;

    uA.fx80 = a;
    uB.fx80 = b;
    uZ.ld = uA.ld * uB.ld;
    return uZ.fx80;

}

floatx80_t syst_fx80_div( floatx80_t a, floatx80_t b )
{
    union fx80_ld uA, uB, uZ;

    uA.fx80 = a;
    uB.fx80 = b;
    uZ.ld = uA.ld / uB.ld;
    return uZ.fx80;

}

bool syst_fx80_eq( floatx80_t a, floatx80_t b )
{
    union fx80_ld uA, uB;

    uA.fx80 = a;
    uB.fx80 = b;
    return ( uA.ld == uB.ld );

}

bool syst_fx80_le( floatx80_t a, floatx80_t b )
{
    union fx80_ld uA, uB;

    uA.fx80 = a;
    uB.fx80 = b;
    return ( uA.ld <= uB.ld );

}

bool syst_fx80_lt( floatx80_t a, floatx80_t b )
{
    union fx80_ld uA, uB;

    uA.fx80 = a;
    uB.fx80 = b;
    return ( uA.ld < uB.ld );

}

#endif

#if defined FLOAT128 && defined LONG_DOUBLE_IS_FLOAT128

union f128_ld { float128_t f128; long double ld; };

float128_t syst_ui32_to_f128( uint_fast32_t a )
{
    union f128_ld uZ;

    uZ.ld = a;
    return uZ.f128;

}

float128_t syst_ui64_to_f128( uint_fast64_t a )
{
    union f128_ld uZ;

    uZ.ld = a;
    return uZ.f128;

}

float128_t syst_i32_to_f128( int_fast32_t a )
{
    union f128_ld uZ;

    uZ.ld = a;
    return uZ.f128;

}

float128_t syst_i64_to_f128( int_fast64_t a )
{
    union f128_ld uZ;

    uZ.ld = a;
    return uZ.f128;

}

float128_t syst_f32_to_f128( float32_t a )
{
    union f32_f uA;
    union f128_ld uZ;

    uA.f32 = a;
    uZ.ld = uA.f;
    return uZ.f128;

}

float128_t syst_f64_to_f128( float64_t a )
{
    union f64_d uA;
    union f128_ld uZ;

    uA.f64 = a;
    uZ.ld = uA.d;
    return uZ.f128;

}

uint_fast32_t syst_f128_to_ui32_rx_minMag( float128_t a )
{
    union f128_ld uA;

    uA.f128 = a;
    return (uint32_t) uA.ld;

}

uint_fast64_t syst_f128_to_ui64_rx_minMag( float128_t a )
{
    union f128_ld uA;

    uA.f128 = a;
    return (uint64_t) uA.ld;

}

int_fast32_t syst_f128_to_i32_rx_minMag( float128_t a )
{
    union f128_ld uA;

    uA.f128 = a;
    return (int32_t) uA.ld;

}

int_fast64_t syst_f128_to_i64_rx_minMag( float128_t a )
{
    union f128_ld uA;

    uA.f128 = a;
    return (int64_t) uA.ld;

}

float32_t syst_f128_to_f32( float128_t a )
{
    union f128_ld uA;
    union f32_f uZ;

    uA.f128 = a;
    uZ.f = uA.ld;
    return uZ.f32;

}

float64_t syst_f128_to_f64( float128_t a )
{
    union f128_ld uA;
    union f64_d uZ;

    uA.f128 = a;
    uZ.d = uA.ld;
    return uZ.f64;

}

float128_t syst_f128_add( float128_t a, float128_t b )
{
    union f128_ld uA, uB, uZ;

    uA.f128 = a;
    uB.f128 = b;
    uZ.ld = uA.ld + uB.ld;
    return uZ.f128;

}

float128_t syst_f128_sub( float128_t a, float128_t b )
{
    union f128_ld uA, uB, uZ;

    uA.f128 = a;
    uB.f128 = b;
    uZ.ld = uA.ld - uB.ld;
    return uZ.f128;

}

float128_t syst_f128_mul( float128_t a, float128_t b )
{
    union f128_ld uA, uB, uZ;

    uA.f128 = a;
    uB.f128 = b;
    uZ.ld = uA.ld * uB.ld;
    return uZ.f128;

}

float128_t syst_f128_div( float128_t a, float128_t b )
{
    union f128_ld uA, uB, uZ;

    uA.f128 = a;
    uB.f128 = b;
    uZ.ld = uA.ld / uB.ld;
    return uZ.f128;

}

bool syst_f128_eq( float128_t a, float128_t b )
{
    union f128_ld uA, uB;

    uA.f128 = a;
    uB.f128 = b;
    return ( uA.ld == uB.ld );

}

bool syst_f128_le( float128_t a, float128_t b )
{
    union f128_ld uA, uB;

    uA.f128 = a;
    uB.f128 = b;
    return ( uA.ld <= uB.ld );

}

bool syst_f128_lt( float128_t a, float128_t b )
{
    union f128_ld uA, uB;

    uA.f128 = a;
    uB.f128 = b;
    return ( uA.ld < uB.ld );

}

#endif

