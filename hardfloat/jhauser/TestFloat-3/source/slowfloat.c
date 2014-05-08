
/*============================================================================
|
| This C source file is part of TestFloat, Release 2a, a package of programs
| for testing the correctness of floating-point arithmetic complying to the
| IEC/IEEE Standard for Floating-Point.
|
| Written by John R. Hauser.  More information is available through the Web
| page `http://HTTP.CS.Berkeley.EDU/~jhauser/arithmetic/TestFloat.html'.
|
| THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
| has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
| TIMES RESULT IN INCORRECT BEHAVIOR.  USE OF THIS SOFTWARE IS RESTRICTED TO
| PERSONS AND ORGANIZATIONS WHO CAN AND WILL TAKE FULL RESPONSIBILITY FOR ANY
| AND ALL LOSSES, COSTS, OR OTHER PROBLEMS ARISING FROM ITS USE.
|
| Derivative works are acceptable, even for commercial purposes, so long as
| (1) they include prominent notice that the work is derivative, and (2) they
| include prominent notice akin to these four paragraphs for those parts of
| this code that are retained.
|
*============================================================================*/

#include <stdbool.h>
#include <stdint.h>
#include "softfloat.h"
#include "slowfloat.h"

int_fast8_t slowfloat_roundingMode;
int_fast8_t slowfloat_detectTininess;
int_fast8_t slowfloat_exceptionFlags;
#ifdef FLOATX80
int_fast8_t slow_fx80_rounding_precision;
#endif

union ui32_f32 { uint32_t ui; float32_t f; };
union ui64_f64 { uint64_t ui; float64_t f; };

struct bits128X { uint64_t v64, v0; };

struct floatX {
    bool isNaN;
    bool isInf;
    bool isZero;
    bool sign;
    int_fast32_t exp;
    struct bits128X sig;
};

static const struct floatX floatXNaN =
    { true, false, false, false, 0, { 0, 0 } };
static const struct floatX floatXPositiveZero =
    { false, false, true, false, 0, { 0, 0 } };
static const struct floatX floatXNegativeZero =
    { false, false, true, true, 0, { 0, 0 } };

static bool eq128( struct bits128X a, struct bits128X b )
{

    return ( a.v64 == b.v64 ) && ( a.v0 == b.v0 );

}

static bool le128( struct bits128X a, struct bits128X b )
{

    return ( a.v64 < b.v64 ) || ( ( a.v64 == b.v64 ) && ( a.v0 <= b.v0 ) );

}

static bool lt128( struct bits128X a, struct bits128X b )
{

    return ( a.v64 < b.v64 ) || ( ( a.v64 == b.v64 ) && ( a.v0 < b.v0 ) );

}

static struct bits128X shortShift128Left( struct bits128X a, int count )
{

    a.v64 = a.v64<<count | a.v0>>( ( - count ) & 63 );
    a.v0 <<= count;
    return a;

}

static struct bits128X shortShift128Right( struct bits128X a, int count )
{

    a.v0 = a.v64<<( ( - count ) & 63 ) | a.v0>>count;
    a.v64 >>= count;
    return a;

}

static struct bits128X shortShift128RightJam( struct bits128X a, int count )
{
    int negCount;
    uint64_t extra;

    negCount = ( - count ) & 63;
    extra = a.v0<<negCount;
    a.v0 = a.v64<<negCount | a.v0>>count | ( extra != 0 );
    a.v64 >>= count;
    return a;

}

static struct bits128X neg128( struct bits128X a )
{

    if ( ! a.v0 ) {
        a.v64 = - a.v64;
    } else {
        a.v64 = ~ a.v64;
        a.v0 = - a.v0;
    }
    return a;

}

static struct bits128X add128( struct bits128X a, struct bits128X b )
{

    a.v0 += b.v0;
    a.v64 += b.v64 + ( a.v0 < b.v0 );
    return a;

}

static struct floatX
 roundFloatXTo24(
     bool isTiny, struct floatX xZ, int_fast8_t roundingMode, bool exact )
{
    uint_fast32_t roundBits;

    xZ.sig.v64 |= ( xZ.sig.v0 != 0 );
    xZ.sig.v0 = 0;
    roundBits = (uint32_t) xZ.sig.v64;
    xZ.sig.v64 -= roundBits;
    if ( roundBits ) {
        if ( exact ) slowfloat_exceptionFlags |= softfloat_flag_inexact;
        if ( isTiny ) slowfloat_exceptionFlags |= softfloat_flag_underflow;
        switch ( roundingMode ) {
         case softfloat_round_nearest_even:
            if ( roundBits < 0x80000000 ) goto noIncrement;
            if (
                ( roundBits == 0x80000000 )
                    && ! ( xZ.sig.v64 & UINT64_C( 0x100000000 ) )
            ) {
                goto noIncrement;
            }
            break;
         case softfloat_round_minMag:
            goto noIncrement;
         case softfloat_round_min:
            if ( ! xZ.sign ) goto noIncrement;
            break;
         case softfloat_round_max:
            if ( xZ.sign ) goto noIncrement;
            break;
         case softfloat_round_nearest_maxMag:
            if ( roundBits < 0x80000000 ) goto noIncrement;
            break;
        }
        xZ.sig.v64 += UINT64_C( 0x100000000 );
        if ( xZ.sig.v64 == UINT64_C( 0x0100000000000000 ) ) {
            ++xZ.exp;
            xZ.sig.v64 = UINT64_C( 0x0080000000000000 );
        }
    }
 noIncrement:
    return xZ;

}

static struct floatX
 roundFloatXTo53(
     bool isTiny, struct floatX xZ, int_fast8_t roundingMode, bool exact )
{
    int_fast8_t roundBits;

    xZ.sig.v64 |= ( xZ.sig.v0 != 0 );
    xZ.sig.v0 = 0;
    roundBits = xZ.sig.v64 & 7;
    xZ.sig.v64 -= roundBits;
    if ( roundBits ) {
        if ( exact ) slowfloat_exceptionFlags |= softfloat_flag_inexact;
        if ( isTiny ) slowfloat_exceptionFlags |= softfloat_flag_underflow;
        switch ( roundingMode ) {
         case softfloat_round_nearest_even:
            if ( roundBits < 4 ) goto noIncrement;
            if ( ( roundBits == 4 ) && ! ( xZ.sig.v64 & 8 ) ) goto noIncrement;
            break;
         case softfloat_round_minMag:
            goto noIncrement;
         case softfloat_round_min:
            if ( ! xZ.sign ) goto noIncrement;
            break;
         case softfloat_round_max:
            if ( xZ.sign ) goto noIncrement;
            break;
         case softfloat_round_nearest_maxMag:
            if ( roundBits < 4 ) goto noIncrement;
            break;
        }
        xZ.sig.v64 += 8;
        if ( xZ.sig.v64 == UINT64_C( 0x0100000000000000 ) ) {
            ++xZ.exp;
            xZ.sig.v64 = UINT64_C( 0x0080000000000000 );
        }
    }
 noIncrement:
    return xZ;

}

static struct floatX
 roundFloatXTo64(
     bool isTiny, struct floatX xZ, int_fast8_t roundingMode, bool exact )
{
    int_fast64_t roundBits;

    roundBits = xZ.sig.v0 & UINT64_C( 0x00FFFFFFFFFFFFFF );
    xZ.sig.v0 -= roundBits;
    if ( roundBits ) {
        if ( exact ) slowfloat_exceptionFlags |= softfloat_flag_inexact;
        if ( isTiny ) slowfloat_exceptionFlags |= softfloat_flag_underflow;
        switch ( roundingMode ) {
         case softfloat_round_nearest_even:
            if ( roundBits < UINT64_C( 0x0080000000000000 ) ) goto noIncrement;
            if (
                ( roundBits == UINT64_C( 0x0080000000000000 ) )
                    && ! ( xZ.sig.v0 & UINT64_C( 0x0100000000000000 ) )
            ) {
                goto noIncrement;
            }
            break;
         case softfloat_round_minMag:
            goto noIncrement;
         case softfloat_round_min:
            if ( ! xZ.sign ) goto noIncrement;
            break;
         case softfloat_round_max:
            if ( xZ.sign ) goto noIncrement;
            break;
         case softfloat_round_nearest_maxMag:
            if ( roundBits < UINT64_C( 0x0080000000000000 ) ) goto noIncrement;
            break;
        }
        xZ.sig.v0 += UINT64_C( 0x0100000000000000 );
        xZ.sig.v64 += ! xZ.sig.v0;
        if ( xZ.sig.v64 == UINT64_C( 0x0100000000000000 ) ) {
            ++xZ.exp;
            xZ.sig.v64 = UINT64_C( 0x0080000000000000 );
        }
    }
 noIncrement:
    return xZ;

}

static struct floatX
 roundFloatXTo113(
     bool isTiny, struct floatX xZ, int_fast8_t roundingMode, bool exact )
{
    int_fast8_t roundBits;

    roundBits = xZ.sig.v0 & 0x7F;
    xZ.sig.v0 -= roundBits;
    if ( roundBits ) {
        if ( exact ) slowfloat_exceptionFlags |= softfloat_flag_inexact;
        if ( isTiny ) slowfloat_exceptionFlags |= softfloat_flag_underflow;
        switch ( roundingMode ) {
         case softfloat_round_nearest_even:
            if ( roundBits < 0x40 ) goto noIncrement;
            if ( ( roundBits == 0x40 ) && ! ( xZ.sig.v0 & 0x80 ) ) {
                goto noIncrement;
            }
            break;
         case softfloat_round_minMag:
            goto noIncrement;
         case softfloat_round_min:
            if ( ! xZ.sign ) goto noIncrement;
            break;
         case softfloat_round_max:
            if ( xZ.sign ) goto noIncrement;
            break;
         case softfloat_round_nearest_maxMag:
            if ( roundBits < 0x40 ) goto noIncrement;
            break;
        }
        xZ.sig.v0 += 0x80;
        xZ.sig.v64 += ! xZ.sig.v0;
        if ( xZ.sig.v64 == UINT64_C( 0x0100000000000000 ) ) {
            ++xZ.exp;
            xZ.sig.v64 = UINT64_C( 0x0080000000000000 );
        }
    }
 noIncrement:
    return xZ;

}

static struct floatX ui32ToFloatX( uint_fast32_t a )
{
    struct floatX xA;

    xA.isNaN = false;
    xA.isInf = false;
    xA.sign = false;
    xA.sig.v64 = a;
    xA.sig.v0 = 0;
    if ( a ) {
        xA.isZero = false;
        xA.exp = 31;
        xA.sig.v64 <<= 24;
        while ( xA.sig.v64 < UINT64_C( 0x0080000000000000 ) ) {
            --xA.exp;
            xA.sig.v64 <<= 1;
        }
    } else {
        xA.isZero = true;
    }
    return xA;

}

static uint_fast32_t
 floatXToUI32( struct floatX xA, int_fast8_t roundingMode, bool exact )
{
    int_fast8_t savedExceptionFlags;
    int_fast32_t shiftCount;
    uint_fast32_t z;

    if ( xA.isInf || xA.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
        return 0xFFFFFFFF;
    }
    if ( xA.isZero ) return 0;
    savedExceptionFlags = slowfloat_exceptionFlags;
    shiftCount = 52 - xA.exp;
    if ( 56 < shiftCount ) {
        xA.sig.v64 = 0;
        xA.sig.v0 = 1;
    } else {
        while ( 0 < shiftCount ) {
            xA.sig = shortShift128RightJam( xA.sig, 1 );
            --shiftCount;
        }
    }
    xA = roundFloatXTo53( false, xA, roundingMode, exact );
    xA.sig = shortShift128RightJam( xA.sig, 3 );
    z = xA.sig.v64;
    if ( ( shiftCount < 0 ) || xA.sig.v64>>32 || ( xA.sign && z ) ) {
        slowfloat_exceptionFlags =
            savedExceptionFlags | softfloat_flag_invalid;
        return 0xFFFFFFFF;
    }
    return z;

}

static struct floatX ui64ToFloatX( uint_fast64_t a )
{
    struct floatX xA;

    xA.isNaN = false;
    xA.isInf = false;
    xA.sign = false;
    xA.sig.v64 = 0;
    xA.sig.v0 = a;
    if ( a ) {
        xA.isZero = false;
        xA.exp = 63;
        xA.sig = shortShift128Left( xA.sig, 56 );
        while ( xA.sig.v64 < UINT64_C( 0x0080000000000000 ) ) {
            --xA.exp;
            xA.sig = shortShift128Left( xA.sig, 1 );
        }
    } else {
        xA.isZero = true;
    }
    return xA;

}

static uint_fast64_t
 floatXToUI64( struct floatX xA, int_fast8_t roundingMode, bool exact )
{
    int_fast8_t savedExceptionFlags;
    int_fast32_t shiftCount;
    uint_fast64_t z;

    if ( xA.isInf || xA.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
        return UINT64_C( 0xFFFFFFFFFFFFFFFF );
    }
    if ( xA.isZero ) return 0;
    savedExceptionFlags = slowfloat_exceptionFlags;
    shiftCount = 112 - xA.exp;
    if ( 116 < shiftCount ) {
        xA.sig.v64 = 0;
        xA.sig.v0 = 1;
    } else {
        while ( 0 < shiftCount ) {
            xA.sig = shortShift128RightJam( xA.sig, 1 );
            --shiftCount;
        }
    }
    xA = roundFloatXTo113( false, xA, roundingMode, exact );
    xA.sig = shortShift128RightJam( xA.sig, 7 );
    z = xA.sig.v0;
    if ( ( shiftCount < 0 ) || xA.sig.v64 || ( xA.sign && z ) ) {
        slowfloat_exceptionFlags =
            savedExceptionFlags | softfloat_flag_invalid;
        return UINT64_C( 0xFFFFFFFFFFFFFFFF );
    }
    return z;

}

static struct floatX i32ToFloatX( int_fast32_t a )
{
    struct floatX xA;

    xA.isNaN = false;
    xA.isInf = false;
    xA.sign = ( a < 0 );
    xA.sig.v64 = xA.sign ? - (uint64_t) a : a;
    xA.sig.v0 = 0;
    if ( a ) {
        xA.isZero = false;
        xA.exp = 31;
        xA.sig.v64 <<= 24;
        while ( xA.sig.v64 < UINT64_C( 0x0080000000000000 ) ) {
            --xA.exp;
            xA.sig.v64 <<= 1;
        }
    } else {
        xA.isZero = true;
    }
    return xA;

}

static int_fast32_t
 floatXToI32( struct floatX xA, int_fast8_t roundingMode, bool exact )
{
    int_fast8_t savedExceptionFlags;
    int_fast32_t shiftCount;
    union { uint32_t ui; int32_t i; } uZ;

    if ( xA.isInf || xA.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
        return ( xA.isInf & xA.sign ) ? -0x7FFFFFFF - 1 : 0x7FFFFFFF;
    }
    if ( xA.isZero ) return 0;
    savedExceptionFlags = slowfloat_exceptionFlags;
    shiftCount = 52 - xA.exp;
    if ( 56 < shiftCount ) {
        xA.sig.v64 = 0;
        xA.sig.v0 = 1;
    } else {
        while ( 0 < shiftCount ) {
            xA.sig = shortShift128RightJam( xA.sig, 1 );
            --shiftCount;
        }
    }
    xA = roundFloatXTo53( false, xA, roundingMode, exact );
    xA.sig = shortShift128RightJam( xA.sig, 3 );
    uZ.ui = xA.sig.v64;
    if ( xA.sign ) uZ.ui = - uZ.ui;
    if (
           ( shiftCount < 0 )
        || xA.sig.v64>>32
        || ( ( uZ.i != 0 ) && ( xA.sign != ( uZ.i < 0 ) ) )
    ) {
        slowfloat_exceptionFlags =
            savedExceptionFlags | softfloat_flag_invalid;
        return xA.sign ? -0x7FFFFFFF - 1 : 0x7FFFFFFF;
    }
    return uZ.i;

}

static struct floatX i64ToFloatX( int_fast64_t a )
{
    struct floatX xA;

    xA.isNaN = false;
    xA.isInf = false;
    xA.sign = ( a < 0 );
    xA.sig.v64 = 0;
    xA.sig.v0 = xA.sign ? - a : a;
    if ( a ) {
        xA.isZero = false;
        xA.exp = 63;
        xA.sig = shortShift128Left( xA.sig, 56 );
        while ( xA.sig.v64 < UINT64_C( 0x0080000000000000 ) ) {
            --xA.exp;
            xA.sig = shortShift128Left( xA.sig, 1 );
        }
    } else {
        xA.isZero = true;
    }
    return xA;

}

static int_fast64_t
 floatXToI64( struct floatX xA, int_fast8_t roundingMode, bool exact )
{
    int_fast8_t savedExceptionFlags;
    int_fast32_t shiftCount;
    union { uint64_t ui; int64_t i; } uZ;

    if ( xA.isInf || xA.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
        return
            ( xA.isInf & xA.sign ) ? - INT64_C( 0x7FFFFFFFFFFFFFFF ) - 1
                : INT64_C( 0x7FFFFFFFFFFFFFFF );
    }
    if ( xA.isZero ) return 0;
    savedExceptionFlags = slowfloat_exceptionFlags;
    shiftCount = 112 - xA.exp;
    if ( 116 < shiftCount ) {
        xA.sig.v64 = 0;
        xA.sig.v0 = 1;
    } else {
        while ( 0 < shiftCount ) {
            xA.sig = shortShift128RightJam( xA.sig, 1 );
            --shiftCount;
        }
    }
    xA = roundFloatXTo113( false, xA, roundingMode, exact );
    xA.sig = shortShift128RightJam( xA.sig, 7 );
    uZ.ui = xA.sig.v0;
    if ( xA.sign ) uZ.ui = - uZ.ui;
    if (
           ( shiftCount < 0 )
        || xA.sig.v64
        || ( ( uZ.i != 0 ) && ( xA.sign != ( uZ.i < 0 ) ) )
    ) {
        slowfloat_exceptionFlags =
            savedExceptionFlags | softfloat_flag_invalid;
        return
            xA.sign ? - INT64_C( 0x7FFFFFFFFFFFFFFF ) - 1
                : INT64_C( 0x7FFFFFFFFFFFFFFF );
    }
    return uZ.i;

}

static struct floatX f32ToFloatX( float32_t a )
{
    union ui32_f32 uA;
    uint_fast32_t uiA;
    int_fast16_t exp;
    struct floatX xA;

    uA.f = a;
    uiA = uA.ui;
    xA.isNaN = false;
    xA.isInf = false;
    xA.isZero = false;
    xA.sign = ( ( uiA & 0x80000000 ) != 0 );
    exp = uiA>>23 & 0xFF;
    xA.sig.v64 = uiA & 0x007FFFFF;
    xA.sig.v64 <<= 32;
    xA.sig.v0 = 0;
    if ( exp == 0xFF ) {
        if ( xA.sig.v64 ) {
            xA.isNaN = true;
        } else {
            xA.isInf = true;
        }
    } else if ( ! exp ) {
        if ( ! xA.sig.v64 ) {
            xA.isZero = true;
        } else {
            exp = 1 - 0x7F;
            do {
                --exp;
                xA.sig.v64 <<= 1;
            } while ( xA.sig.v64 < UINT64_C( 0x0080000000000000 ) );
            xA.exp = exp;
        }
    } else {
        xA.exp = exp - 0x7F;
        xA.sig.v64 |= UINT64_C( 0x0080000000000000 );
    }
    return xA;

}

static float32_t floatXToF32( struct floatX xZ )
{
    uint_fast32_t uiZ;
    struct floatX savedZ;
    bool isTiny;
    int_fast32_t exp;
    union ui32_f32 uZ;

    if ( xZ.isNaN ) {
        uiZ = 0xFFFFFFFF;
        goto uiZ;
    }
    if ( xZ.isInf ) {
        uiZ = xZ.sign ? 0xFF800000 : 0x7F800000;
        goto uiZ;
    }
    if ( xZ.isZero ) {
        uiZ = xZ.sign ? 0x80000000 : 0;
        goto uiZ;
    }
    while ( UINT64_C( 0x0100000000000000 ) <= xZ.sig.v64 ) {
        ++xZ.exp;
        xZ.sig = shortShift128RightJam( xZ.sig, 1 );
    }
    while ( xZ.sig.v64 < UINT64_C( 0x0080000000000000 ) ) {
        --xZ.exp;
        xZ.sig = shortShift128Left( xZ.sig, 1 );
    }
    savedZ = xZ;
    isTiny =
        ( slowfloat_detectTininess == softfloat_tininess_beforeRounding )
            && ( xZ.exp + 0x7F <= 0 );
    xZ = roundFloatXTo24( isTiny, xZ, slowfloat_roundingMode, true );
    exp = xZ.exp + 0x7F;
    if ( 0xFF <= exp ) {
        slowfloat_exceptionFlags |=
            softfloat_flag_overflow | softfloat_flag_inexact;
        if ( xZ.sign ) {
            switch ( slowfloat_roundingMode ) {
             case softfloat_round_nearest_even:
             case softfloat_round_min:
             case softfloat_round_nearest_maxMag:
                uiZ = 0xFF800000;
                break;
             case softfloat_round_minMag:
             case softfloat_round_max:
                uiZ = 0xFF7FFFFF;
                break;
            }
        } else {
            switch ( slowfloat_roundingMode ) {
             case softfloat_round_nearest_even:
             case softfloat_round_max:
             case softfloat_round_nearest_maxMag:
                uiZ = 0x7F800000;
                break;
             case softfloat_round_minMag:
             case softfloat_round_min:
                uiZ = 0x7F7FFFFF;
                break;
            }
        }
        goto uiZ;
    }
    if ( exp <= 0 ) {
        isTiny = true;
        xZ = savedZ;
        exp = xZ.exp + 0x7F;
        if ( exp < -27 ) {
            xZ.sig.v0 = ( xZ.sig.v64 != 0 ) || ( xZ.sig.v0 != 0 );
            xZ.sig.v64 = 0;
        } else {
            while ( exp <= 0 ) {
                ++exp;
                xZ.sig = shortShift128RightJam( xZ.sig, 1 );
            }
        }
        xZ = roundFloatXTo24( isTiny, xZ, slowfloat_roundingMode, true );
        exp = ( UINT64_C( 0x0080000000000000 ) <= xZ.sig.v64 ) ? 1 : 0;
    }
    uiZ = (uint_fast32_t) exp<<23;
    if ( xZ.sign ) uiZ |= 0x80000000;
    uiZ |= xZ.sig.v64>>32 & 0x007FFFFF;
 uiZ:
    uZ.ui = uiZ;
    return uZ.f;

}

static struct floatX f64ToFloatX( float64_t a )
{
    union ui64_f64 uA;
    uint_fast64_t uiA;
    int_fast16_t exp;
    struct floatX xA;

    uA.f = a;
    uiA = uA.ui;
    xA.isNaN = false;
    xA.isInf = false;
    xA.isZero = false;
    xA.sign = ( ( uiA & UINT64_C( 0x8000000000000000 ) ) != 0 );
    exp = uiA>>52 & 0x7FF;
    xA.sig.v64 = uiA & UINT64_C( 0x000FFFFFFFFFFFFF );
    xA.sig.v0 = 0;
    if ( exp == 0x7FF ) {
        if ( xA.sig.v64 ) {
            xA.isNaN = true;
        } else {
            xA.isInf = true;
        }
    } else if ( ! exp ) {
        if ( ! xA.sig.v64 ) {
            xA.isZero = true;
        } else {
            exp = 1 - 0x3FF;
            do {
                --exp;
                xA.sig.v64 <<= 1;
            } while ( xA.sig.v64 < UINT64_C( 0x0010000000000000 ) );
            xA.exp = exp;
        }
    } else {
        xA.exp = exp - 0x3FF;
        xA.sig.v64 |= UINT64_C( 0x0010000000000000 );
    }
    xA.sig.v64 <<= 3;
    return xA;

}

static float64_t floatXToF64( struct floatX xZ )
{
    uint_fast64_t uiZ;
    struct floatX savedZ;
    bool isTiny;
    int_fast32_t exp;
    union ui64_f64 uZ;

    if ( xZ.isNaN ) {
        uiZ = UINT64_C( 0xFFFFFFFFFFFFFFFF );
        goto uiZ;
    }
    if ( xZ.isInf ) {
        uiZ =
            xZ.sign ? UINT64_C( 0xFFF0000000000000 )
                : UINT64_C( 0x7FF0000000000000 );
        goto uiZ;
    }
    if ( xZ.isZero ) {
        uiZ = xZ.sign ? UINT64_C( 0x8000000000000000 ) : 0;
        goto uiZ;
    }
    while ( UINT64_C( 0x0100000000000000 ) <= xZ.sig.v64 ) {
        ++xZ.exp;
        xZ.sig = shortShift128RightJam( xZ.sig, 1 );
    }
    while ( xZ.sig.v64 < UINT64_C( 0x0080000000000000 ) ) {
        --xZ.exp;
        xZ.sig = shortShift128Left( xZ.sig, 1 );
    }
    savedZ = xZ;
    isTiny =
        ( slowfloat_detectTininess == softfloat_tininess_beforeRounding )
            && ( xZ.exp + 0x3FF <= 0 );
    xZ = roundFloatXTo53( isTiny, xZ, slowfloat_roundingMode, true );
    exp = xZ.exp + 0x3FF;
    if ( 0x7FF <= exp ) {
        slowfloat_exceptionFlags |=
            softfloat_flag_overflow | softfloat_flag_inexact;
        if ( xZ.sign ) {
            switch ( slowfloat_roundingMode ) {
             case softfloat_round_nearest_even:
             case softfloat_round_min:
             case softfloat_round_nearest_maxMag:
                uiZ = UINT64_C( 0xFFF0000000000000 );
                break;
             case softfloat_round_minMag:
             case softfloat_round_max:
                uiZ = UINT64_C( 0xFFEFFFFFFFFFFFFF );
                break;
            }
        } else {
            switch ( slowfloat_roundingMode ) {
             case softfloat_round_nearest_even:
             case softfloat_round_max:
             case softfloat_round_nearest_maxMag:
                uiZ = UINT64_C( 0x7FF0000000000000 );
                break;
             case softfloat_round_minMag:
             case softfloat_round_min:
                uiZ = UINT64_C( 0x7FEFFFFFFFFFFFFF );
                break;
            }
        }
        goto uiZ;
    }
    if ( exp <= 0 ) {
        isTiny = true;
        xZ = savedZ;
        exp = xZ.exp + 0x3FF;
        if ( exp < -56 ) {
            xZ.sig.v0 = ( xZ.sig.v64 != 0 ) || ( xZ.sig.v0 != 0 );
            xZ.sig.v64 = 0;
        } else {
            while ( exp <= 0 ) {
                ++exp;
                xZ.sig = shortShift128RightJam( xZ.sig, 1 );
            }
        }
        xZ = roundFloatXTo53( isTiny, xZ, slowfloat_roundingMode, true );
        exp = ( UINT64_C( 0x0080000000000000 ) <= xZ.sig.v64 ) ? 1 : 0;
    }
    uiZ = (uint_fast64_t) exp<<52;
    if ( xZ.sign ) uiZ |= UINT64_C( 0x8000000000000000 );
    uiZ |= xZ.sig.v64>>3 & UINT64_C( 0x000FFFFFFFFFFFFF );
 uiZ:
    uZ.ui = uiZ;
    return uZ.f;

}

#ifdef FLOATX80

static struct floatX fx80ToFloatX( floatx80_t a )
{
    int_fast32_t exp;
    struct floatX xA;

    xA.isNaN = false;
    xA.isInf = false;
    xA.isZero = false;
    xA.sign = ( ( a.high & 0x8000 ) != 0 );
    exp = a.high & 0x7FFF;
    xA.sig.v64 = 0;
    xA.sig.v0 = a.low;
    if ( exp == 0x7FFF ) {
        if ( ( xA.sig.v0 & UINT64_C( 0x7FFFFFFFFFFFFFFF ) ) ) {
            xA.isNaN = true;
        } else {
            xA.isInf = true;
        }
    } else if ( ! exp ) {
        if ( ! xA.sig.v0 ) {
            xA.isZero = true;
        } else {
            exp = 1 - 0x3FFF;
            while ( xA.sig.v0 < UINT64_C( 0x8000000000000000 ) ) {
                xA.sig.v0 <<= 1;
                --exp;
            }
            xA.exp = exp;
        }
    } else {
        xA.exp = exp - 0x3FFF;
    }
    xA.sig = shortShift128Left( xA.sig, 56 );
    return xA;

}

static floatx80_t floatXToFX80( struct floatX xZ )
{
    struct floatX savedZ;
    bool isTiny;
    int_fast32_t exp;
    floatx80_t z;

    if ( xZ.isNaN ) {
        z.high = 0xFFFF;
        z.low = UINT64_C( 0xFFFFFFFFFFFFFFFF );
        return z;
    }
    if ( xZ.isInf ) {
        z.high = xZ.sign ? 0xFFFF : 0x7FFF;
        z.low = UINT64_C( 0x8000000000000000 );
        return z;
    }
    if ( xZ.isZero ) {
        z.high = xZ.sign ? 0x8000 : 0;
        z.low = 0;
        return z;
    }
    while ( UINT64_C( 0x0100000000000000 ) <= xZ.sig.v64 ) {
        ++xZ.exp;
        xZ.sig = shortShift128RightJam( xZ.sig, 1 );
    }
    while ( xZ.sig.v64 < UINT64_C( 0x0080000000000000 ) ) {
        --xZ.exp;
        xZ.sig = shortShift128Left( xZ.sig, 1 );
    }
    savedZ = xZ;
    isTiny =
        ( slowfloat_detectTininess == softfloat_tininess_beforeRounding )
            && ( xZ.exp + 0x3FFF <= 0 );
    switch ( slow_fx80_rounding_precision ) {
/*** POINTER TO FUNCTION. ***/
     case 32:
        xZ = roundFloatXTo24( isTiny, xZ, slowfloat_roundingMode, true );
        break;
     case 64:
        xZ = roundFloatXTo53( isTiny, xZ, slowfloat_roundingMode, true );
        break;
     default:
        xZ = roundFloatXTo64( isTiny, xZ, slowfloat_roundingMode, true );
        break;
    }
    exp = xZ.exp + 0x3FFF;
    if ( 0x7FFF <= exp ) {
        slowfloat_exceptionFlags |=
            softfloat_flag_overflow | softfloat_flag_inexact;
        if ( xZ.sign ) {
            switch ( slowfloat_roundingMode ) {
             case softfloat_round_nearest_even:
             case softfloat_round_min:
             case softfloat_round_nearest_maxMag:
                z.high = 0xFFFF;
                z.low = UINT64_C( 0x8000000000000000 );
                break;
             case softfloat_round_minMag:
             case softfloat_round_max:
                z.high = 0xFFFE;
                switch ( slow_fx80_rounding_precision ) {
                 case 32:
                    z.low = UINT64_C( 0xFFFFFF0000000000 );
                    break;
                 case 64:
                    z.low = UINT64_C( 0xFFFFFFFFFFFFF800 );
                    break;
                 default:
                    z.low = UINT64_C( 0xFFFFFFFFFFFFFFFF );
                    break;
                }
                break;
            }
        } else {
            switch ( slowfloat_roundingMode ) {
             case softfloat_round_nearest_even:
             case softfloat_round_max:
             case softfloat_round_nearest_maxMag:
                z.high = 0x7FFF;
                z.low = UINT64_C( 0x8000000000000000 );
                break;
             case softfloat_round_minMag:
             case softfloat_round_min:
                z.high = 0x7FFE;
                switch ( slow_fx80_rounding_precision ) {
                 case 32:
                    z.low = UINT64_C( 0xFFFFFF0000000000 );
                    break;
                 case 64:
                    z.low = UINT64_C( 0xFFFFFFFFFFFFF800 );
                    break;
                 default:
                    z.low = UINT64_C( 0xFFFFFFFFFFFFFFFF );
                    break;
                }
                break;
            }
        }
        return z;
    }
    if ( exp <= 0 ) {
        isTiny = true;
        xZ = savedZ;
        exp = xZ.exp + 0x3FFF;
        if ( exp < -70 ) {
            xZ.sig.v0 = ( xZ.sig.v64 != 0 ) || ( xZ.sig.v0 != 0 );
            xZ.sig.v64 = 0;
        } else {
            while ( exp <= 0 ) {
                xZ.sig = shortShift128RightJam( xZ.sig, 1 );
                ++exp;
            }
        }
        switch ( slow_fx80_rounding_precision ) {
/*** POINTER TO FUNCTION. ***/
         case 32:
            xZ = roundFloatXTo24( isTiny, xZ, slowfloat_roundingMode, true );
            break;
         case 64:
            xZ = roundFloatXTo53( isTiny, xZ, slowfloat_roundingMode, true );
            break;
         default:
            xZ = roundFloatXTo64( isTiny, xZ, slowfloat_roundingMode, true );
            break;
        }
        exp = ( UINT64_C( 0x0080000000000000 ) <= xZ.sig.v64 ) ? 1 : 0;
    }
    xZ.sig = shortShift128RightJam( xZ.sig, 56 );
    z.low = xZ.sig.v0;
    z.high = exp;
    if ( xZ.sign ) z.high |= 0x8000;
    return z;

}

#endif

#ifdef FLOAT128

static struct floatX f128ToFloatX( float128_t a )
{
    int_fast32_t exp;
    struct floatX xA;

    xA.isNaN = false;
    xA.isInf = false;
    xA.isZero = false;
    xA.sign = ( ( a.high & UINT64_C( 0x8000000000000000 ) ) != 0 );
    exp = a.high>>48 & 0x7FFF;
    xA.sig.v64 = a.high & UINT64_C( 0x0000FFFFFFFFFFFF );
    xA.sig.v0 = a.low;
    if ( exp == 0x7FFF ) {
        if ( xA.sig.v64 || xA.sig.v0 ) {
            xA.isNaN = true;
        } else {
            xA.isInf = true;
        }
    } else if ( ! exp ) {
        if ( ! xA.sig.v64 && ! xA.sig.v0 ) {
            xA.isZero = true;
        } else {
            exp = 1 - 0x3FFF;
            do {
                --exp;
                xA.sig = shortShift128Left( xA.sig, 1 );
            } while ( xA.sig.v64 < UINT64_C( 0x0001000000000000 ) );
            xA.exp = exp;
        }
    } else {
        xA.exp = exp - 0x3FFF;
        xA.sig.v64 |= UINT64_C( 0x0001000000000000 );
    }
    xA.sig = shortShift128Left( xA.sig, 7 );
    return xA;

}

static float128_t floatXToF128( struct floatX xZ )
{
    struct floatX savedZ;
    bool isTiny;
    int_fast32_t exp;
    float128_t z;

    if ( xZ.isNaN ) {
        z.high = z.low = UINT64_C( 0xFFFFFFFFFFFFFFFF );
        return z;
    }
    if ( xZ.isInf ) {
        z.high =
            xZ.sign ? UINT64_C( 0xFFFF000000000000 )
                : UINT64_C( 0x7FFF000000000000 );
        z.low = 0;
        return z;
    }
    if ( xZ.isZero ) {
        z.high = xZ.sign ? UINT64_C( 0x8000000000000000 ) : 0;
        z.low = 0;
        return z;
    }
    while ( UINT64_C( 0x0100000000000000 ) <= xZ.sig.v64 ) {
        ++xZ.exp;
        xZ.sig = shortShift128RightJam( xZ.sig, 1 );
    }
    while ( xZ.sig.v64 < UINT64_C( 0x0080000000000000 ) ) {
        --xZ.exp;
        xZ.sig = shortShift128Left( xZ.sig, 1 );
    }
    savedZ = xZ;
    isTiny =
        ( slowfloat_detectTininess == softfloat_tininess_beforeRounding )
            && ( xZ.exp + 0x3FFF <= 0 );
    xZ = roundFloatXTo113( isTiny, xZ, slowfloat_roundingMode, true );
    exp = xZ.exp + 0x3FFF;
    if ( 0x7FFF <= exp ) {
        slowfloat_exceptionFlags |=
            softfloat_flag_overflow | softfloat_flag_inexact;
        if ( xZ.sign ) {
            switch ( slowfloat_roundingMode ) {
             case softfloat_round_nearest_even:
             case softfloat_round_min:
             case softfloat_round_nearest_maxMag:
                z.high = UINT64_C( 0xFFFF000000000000 );
                z.low = 0;
                break;
             case softfloat_round_minMag:
             case softfloat_round_max:
                z.high = UINT64_C( 0xFFFEFFFFFFFFFFFF );
                z.low = UINT64_C( 0xFFFFFFFFFFFFFFFF );
                break;
            }
        } else {
            switch ( slowfloat_roundingMode ) {
             case softfloat_round_nearest_even:
             case softfloat_round_max:
             case softfloat_round_nearest_maxMag:
                z.high = UINT64_C( 0x7FFF000000000000 );
                z.low = 0;
                break;
             case softfloat_round_minMag:
             case softfloat_round_min:
                z.high = UINT64_C( 0x7FFEFFFFFFFFFFFF );
                z.low = UINT64_C( 0xFFFFFFFFFFFFFFFF );
                break;
            }
        }
        return z;
    }
    if ( exp <= 0 ) {
        isTiny = true;
        xZ = savedZ;
        exp = xZ.exp + 0x3FFF;
        if ( exp < -120 ) {
            xZ.sig.v0 = ( xZ.sig.v64 != 0 ) || ( xZ.sig.v0 != 0 );
            xZ.sig.v64 = 0;
        } else {
            while ( exp <= 0 ) {
                ++exp;
                xZ.sig = shortShift128RightJam( xZ.sig, 1 );
            }
        }
        xZ = roundFloatXTo113( isTiny, xZ, slowfloat_roundingMode, true );
        exp = ( UINT64_C( 0x0080000000000000 ) <= xZ.sig.v64 ) ? 1 : 0;
    }
    z.high = exp;
    z.high <<= 48;
    if ( xZ.sign ) z.high |= UINT64_C( 0x8000000000000000 );
    xZ.sig = shortShift128RightJam( xZ.sig, 7 );
    z.high |= xZ.sig.v64 & UINT64_C( 0x0000FFFFFFFFFFFF );
    z.low = xZ.sig.v0;
    return z;

}

#endif

static struct floatX floatXInvalid( void )
{

    slowfloat_exceptionFlags |= softfloat_flag_invalid;
    return floatXNaN;

}

static struct floatX
 floatXRoundToInt( struct floatX xA, int_fast8_t roundingMode, bool exact )
{
    int_fast32_t shiftCount, i;

    if ( xA.isNaN || xA.isInf ) return xA;
    shiftCount = 112 - xA.exp;
    if ( shiftCount <= 0 ) return xA;
    if ( 119 < shiftCount ) {
        xA.exp = 112;
        xA.sig.v64 = 0;
        xA.sig.v0 = ! xA.isZero;
    } else {
        while ( 0 < shiftCount ) {
            ++xA.exp;
            xA.sig = shortShift128RightJam( xA.sig, 1 );
            --shiftCount;
        }
    }
    xA = roundFloatXTo113( false, xA, roundingMode, exact );
    if ( ! xA.sig.v64 && ! xA.sig.v0 ) xA.isZero = true;
    return xA;

}

static struct floatX floatXAdd( struct floatX xA, struct floatX xB )
{
    int_fast32_t expDiff;
    struct floatX xZ;

    if ( xA.isNaN ) return xA;
    if ( xB.isNaN ) return xB;
    if ( xA.isInf && xB.isInf ) {
        if ( xA.sign == xB.sign ) return xA;
        return floatXInvalid();
    }
    if ( xA.isInf ) return xA;
    if ( xB.isInf ) return xB;
    if ( xA.isZero && xB.isZero ) {
        if ( xA.sign == xB.sign ) return xA;
        goto completeCancellation;
    }
    if (
           ( xA.sign != xB.sign )
        && ( xA.exp == xB.exp )
        && eq128( xA.sig, xB.sig )
    ) {
 completeCancellation:
        return
            ( slowfloat_roundingMode == softfloat_round_min )
                ? floatXNegativeZero
                : floatXPositiveZero;
    }
    if ( xA.isZero ) return xB;
    if ( xB.isZero ) return xA;
    expDiff = xA.exp - xB.exp;
    if ( expDiff < 0 ) {
        xZ = xA;
        xZ.exp = xB.exp;
        if ( expDiff < -120 ) {
            xZ.sig.v64 = 0;
            xZ.sig.v0 = 1;
        } else {
            while ( expDiff < 0 ) {
                ++expDiff;
                xZ.sig = shortShift128RightJam( xZ.sig, 1 );
            }
        }
        if ( xA.sign != xB.sign ) xZ.sig = neg128( xZ.sig );
        xZ.sign = xB.sign;
        xZ.sig = add128( xZ.sig, xB.sig );
    } else {
        xZ = xB;
        xZ.exp = xA.exp;
        if ( 120 < expDiff ) {
            xZ.sig.v64 = 0;
            xZ.sig.v0 = 1;
        } else {
            while ( 0 < expDiff ) {
                --expDiff;
                xZ.sig = shortShift128RightJam( xZ.sig, 1 );
            }
        }
        if ( xA.sign != xB.sign ) xZ.sig = neg128( xZ.sig );
        xZ.sign = xA.sign;
        xZ.sig = add128( xZ.sig, xA.sig );
    }
    if ( xZ.sig.v64 & UINT64_C( 0x8000000000000000 ) ) {
        xZ.sign = ! xZ.sign;
        xZ.sig = neg128( xZ.sig );
    }
    return xZ;

}

static struct floatX floatXMul( struct floatX xA, struct floatX xB )
{
    int bitNum;
    struct floatX xZ;

    if ( xA.isNaN ) return xA;
    if ( xB.isNaN ) return xB;
    if ( xA.isInf ) {
        if ( xB.isZero ) return floatXInvalid();
        if ( xB.sign ) xA.sign = ! xA.sign;
        return xA;
    }
    if ( xB.isInf ) {
        if ( xA.isZero ) return floatXInvalid();
        if ( xA.sign ) xB.sign = ! xB.sign;
        return xB;
    }
    xZ = xA;
    xZ.sign ^= xB.sign;
    if ( xA.isZero || xB.isZero ) {
        return xZ.sign ? floatXNegativeZero : floatXPositiveZero;
    }
    xZ.exp += xB.exp;
    xZ.sig.v64 = 0;
    xZ.sig.v0 = 0;
    for ( bitNum = 0; bitNum < 120; ++bitNum ) {
        xZ.sig = shortShift128RightJam( xZ.sig, 1 );
        if ( xB.sig.v0 & 1 ) xZ.sig = add128( xZ.sig, xA.sig );
        xB.sig = shortShift128Right( xB.sig, 1 );
    }
    if ( UINT64_C( 0x0100000000000000 ) <= xZ.sig.v64 ) {
        ++xZ.exp;
        xZ.sig = shortShift128RightJam( xZ.sig, 1 );
    }
    return xZ;

}

static struct floatX floatXDiv( struct floatX xA, struct floatX xB )
{
    struct bits128X negBSig;
    int bitNum;
    struct floatX xZ;

    if ( xA.isNaN ) return xA;
    if ( xB.isNaN ) return xB;
    if ( xA.isInf ) {
        if ( xB.isInf ) return floatXInvalid();
        if ( xB.sign ) xA.sign = ! xA.sign;
        return xA;
    }
    if ( xB.isZero ) {
        if ( xA.isZero ) return floatXInvalid();
        slowfloat_exceptionFlags |= softfloat_flag_infinity;
        if ( xA.sign ) xB.sign = ! xB.sign;
        xB.isInf = true;
        xB.isZero = false;
        return xB;
    }
    xZ = xA;
    xZ.sign ^= xB.sign;
    if ( xA.isZero || xB.isInf ) {
        return xZ.sign ? floatXNegativeZero : floatXPositiveZero;
    }
    xZ.exp -= xB.exp + 1;
    xZ.sig.v64 = 0;
    xZ.sig.v0 = 0;
    negBSig = neg128( xB.sig );
    for ( bitNum = 0; bitNum < 120; ++bitNum ) {
        if ( le128( xB.sig, xA.sig ) ) {
            xZ.sig.v0 |= 1;
            xA.sig = add128( xA.sig, negBSig );
        }
        xA.sig = shortShift128Left( xA.sig, 1 );
        xZ.sig = shortShift128Left( xZ.sig, 1 );
    }
    if ( xA.sig.v64 || xA.sig.v0 ) xZ.sig.v0 |= 1;
    return xZ;

}

static struct floatX floatXRem( struct floatX xA, struct floatX xB )
{
    struct bits128X negBSig;
    bool lastQuotientBit;
    struct bits128X savedASig;

    if ( xA.isNaN ) return xA;
    if ( xB.isNaN ) return xB;
    if ( xA.isInf || xB.isZero ) return floatXInvalid();
    if ( xA.isZero || xB.isInf ) return xA;
    --xB.exp;
    if ( xA.exp < xB.exp ) return xA;
    xB.sig = shortShift128Left( xB.sig, 1 );
    negBSig = neg128( xB.sig );
    while ( xB.exp < xA.exp ) {
        --xA.exp;
        if ( le128( xB.sig, xA.sig ) ) xA.sig = add128( xA.sig, negBSig );
        xA.sig = shortShift128Left( xA.sig, 1 );
    }
    lastQuotientBit = le128( xB.sig, xA.sig );
    if ( lastQuotientBit ) xA.sig = add128( xA.sig, negBSig );
    savedASig = xA.sig;
    xA.sig = neg128( add128( xA.sig, negBSig ) );
    if ( lt128( xA.sig, savedASig ) ) {
        xA.sign = ! xA.sign;
    } else if ( lt128( savedASig, xA.sig ) ) {
        xA.sig = savedASig;
    } else {
        if ( lastQuotientBit ) {
            xA.sign = ! xA.sign;
        } else {
            xA.sig = savedASig;
        }
    }
    if ( ! xA.sig.v64 && ! xA.sig.v0 ) xA.isZero = true;
    return xA;

}

static struct floatX floatXSqrt( struct floatX xA )
{
    int bitNum;
    struct bits128X bitSig, savedASig;
    struct floatX xZ;

    if ( xA.isNaN || xA.isZero ) return xA;
    if ( xA.sign ) return floatXInvalid();
    if ( xA.isInf ) return xA;
    xZ = xA;
    xZ.exp >>= 1;
    if ( ! ( xA.exp & 1 ) ) xA.sig = shortShift128RightJam( xA.sig, 1 );
    xZ.sig.v64 = 0;
    xZ.sig.v0 = 0;
    bitSig.v64 = UINT64_C( 0x0080000000000000 );
    bitSig.v0 = 0;
    for ( bitNum = 0; bitNum < 120; ++bitNum ) {
        savedASig = xA.sig;
        xA.sig = add128( xA.sig, neg128( xZ.sig ) );
        xA.sig = shortShift128Left( xA.sig, 1 );
        xA.sig = add128( xA.sig, neg128( bitSig ) );
        if ( xA.sig.v64 & UINT64_C( 0x8000000000000000 ) ) {
            xA.sig = shortShift128Left( savedASig, 1 );
        } else {
            xZ.sig.v64 |= bitSig.v64;
            xZ.sig.v0 |= bitSig.v0;
        }
        bitSig = shortShift128RightJam( bitSig, 1 );
    }
    if ( xA.sig.v64 || xA.sig.v0 ) xZ.sig.v0 |= 1;
    return xZ;

}

static bool floatXEq( struct floatX xA, struct floatX xB )
{

    if ( xA.isNaN || xB.isNaN ) return false;
    if ( xA.isZero && xB.isZero ) return true;
    if ( xA.sign != xB.sign ) return false;
    if ( xA.isInf || xB.isInf ) return xA.isInf && xB.isInf;
    return ( xA.exp == xB.exp ) && eq128( xA.sig, xB.sig );

}

static bool floatXLE( struct floatX xA, struct floatX xB )
{

    if ( xA.isNaN || xB.isNaN ) return false;
    if ( xA.isZero && xB.isZero ) return true;
    if ( xA.sign != xB.sign ) return xA.sign;
    if ( xA.sign ) {
        if ( xA.isInf || xB.isZero ) return true;
        if ( xB.isInf || xA.isZero ) return false;
        if ( xB.exp < xA.exp ) return true;
        if ( xA.exp < xB.exp ) return false;
        return le128( xB.sig, xA.sig );
    } else {
        if ( xB.isInf || xA.isZero ) return true;
        if ( xA.isInf || xB.isZero ) return false;
        if ( xA.exp < xB.exp ) return true;
        if ( xB.exp < xA.exp ) return false;
        return le128( xA.sig, xB.sig );
    }

}

static bool floatXLT( struct floatX xA, struct floatX xB )
{

    if ( xA.isNaN || xB.isNaN ) return false;
    if ( xA.isZero && xB.isZero ) return false;
    if ( xA.sign != xB.sign ) return xA.sign;
    if ( xA.isInf && xB.isInf ) return false;
    if ( xA.sign ) {
        if ( xA.isInf || xB.isZero ) return true;
        if ( xB.isInf || xA.isZero ) return false;
        if ( xB.exp < xA.exp ) return true;
        if ( xA.exp < xB.exp ) return false;
        return lt128( xB.sig, xA.sig );
    } else {
        if ( xB.isInf || xA.isZero ) return true;
        if ( xA.isInf || xB.isZero ) return false;
        if ( xA.exp < xB.exp ) return true;
        if ( xB.exp < xA.exp ) return false;
        return lt128( xA.sig, xB.sig );
    }

}

float32_t slow_ui32_to_f32( uint_fast32_t a )
{

    return floatXToF32( ui32ToFloatX( a ) );

}

float64_t slow_ui32_to_f64( uint_fast32_t a )
{

    return floatXToF64( ui32ToFloatX( a ) );

}

#ifdef FLOATX80

floatx80_t slow_ui32_to_fx80( uint_fast32_t a )
{

    return floatXToFX80( ui32ToFloatX( a ) );

}

#endif

#ifdef FLOAT128

float128_t slow_ui32_to_f128( uint_fast32_t a )
{

    return floatXToF128( ui32ToFloatX( a ) );

}

#endif

float32_t slow_ui64_to_f32( uint_fast64_t a )
{

    return floatXToF32( ui64ToFloatX( a ) );

}

float64_t slow_ui64_to_f64( uint_fast64_t a )
{

    return floatXToF64( ui64ToFloatX( a ) );

}

#ifdef FLOATX80

floatx80_t slow_ui64_to_fx80( uint_fast64_t a )
{

    return floatXToFX80( ui64ToFloatX( a ) );

}

#endif

#ifdef FLOAT128

float128_t slow_ui64_to_f128( uint_fast64_t a )
{

    return floatXToF128( ui64ToFloatX( a ) );

}

#endif

float32_t slow_i32_to_f32( int_fast32_t a )
{

    return floatXToF32( i32ToFloatX( a ) );

}

float64_t slow_i32_to_f64( int_fast32_t a )
{

    return floatXToF64( i32ToFloatX( a ) );

}

#ifdef FLOATX80

floatx80_t slow_i32_to_fx80( int_fast32_t a )
{

    return floatXToFX80( i32ToFloatX( a ) );

}

#endif

#ifdef FLOAT128

float128_t slow_i32_to_f128( int_fast32_t a )
{

    return floatXToF128( i32ToFloatX( a ) );

}

#endif

float32_t slow_i64_to_f32( int_fast64_t a )
{

    return floatXToF32( i64ToFloatX( a ) );

}

float64_t slow_i64_to_f64( int_fast64_t a )
{

    return floatXToF64( i64ToFloatX( a ) );

}

#ifdef FLOATX80

floatx80_t slow_i64_to_fx80( int_fast64_t a )
{

    return floatXToFX80( i64ToFloatX( a ) );

}

#endif

#ifdef FLOAT128

float128_t slow_i64_to_f128( int_fast64_t a )
{

    return floatXToF128( i64ToFloatX( a ) );

}

#endif

uint_fast32_t
 slow_f32_to_ui32( float32_t a, int_fast8_t roundingMode, bool exact )
{

    return floatXToUI32( f32ToFloatX( a ), roundingMode, exact );

}

uint_fast64_t
 slow_f32_to_ui64( float32_t a, int_fast8_t roundingMode, bool exact )
{

    return floatXToUI64( f32ToFloatX( a ), roundingMode, exact );

}

int_fast32_t
 slow_f32_to_i32( float32_t a, int_fast8_t roundingMode, bool exact )
{

    return floatXToI32( f32ToFloatX( a ), roundingMode, exact );

}

int_fast64_t
 slow_f32_to_i64( float32_t a, int_fast8_t roundingMode, bool exact )
{

    return floatXToI64( f32ToFloatX( a ), roundingMode, exact );

}

uint_fast32_t slow_f32_to_ui32_r_minMag( float32_t a, bool exact )
{

    return floatXToUI32( f32ToFloatX( a ), softfloat_round_minMag, exact );

}

uint_fast64_t slow_f32_to_ui64_r_minMag( float32_t a, bool exact )
{

    return floatXToUI64( f32ToFloatX( a ), softfloat_round_minMag, exact );

}

int_fast32_t slow_f32_to_i32_r_minMag( float32_t a, bool exact )
{

    return floatXToI32( f32ToFloatX( a ), softfloat_round_minMag, exact );

}

int_fast64_t slow_f32_to_i64_r_minMag( float32_t a, bool exact )
{

    return floatXToI64( f32ToFloatX( a ), softfloat_round_minMag, exact );

}

float64_t slow_f32_to_f64( float32_t a )
{

    return floatXToF64( f32ToFloatX( a ) );

}

#ifdef FLOATX80

floatx80_t slow_f32_to_fx80( float32_t a )
{

    return floatXToFX80( f32ToFloatX( a ) );

}

#endif

#ifdef FLOAT128

float128_t slow_f32_to_f128( float32_t a )
{

    return floatXToF128( f32ToFloatX( a ) );

}

#endif

float32_t
 slow_f32_roundToInt( float32_t a, int_fast8_t roundingMode, bool exact )
{

    return
        floatXToF32(
            floatXRoundToInt( f32ToFloatX( a ), roundingMode, exact ) );

}

float32_t slow_f32_add( float32_t a, float32_t b )
{

    return floatXToF32( floatXAdd( f32ToFloatX( a ), f32ToFloatX( b ) ) );

}

float32_t slow_f32_sub( float32_t a, float32_t b )
{
    union ui32_f32 uB;

    uB.f = b;
    uB.ui ^= 0x80000000;
    return floatXToF32( floatXAdd( f32ToFloatX( a ), f32ToFloatX( uB.f ) ) );

}

float32_t slow_f32_mul( float32_t a, float32_t b )
{

    return floatXToF32( floatXMul( f32ToFloatX( a ), f32ToFloatX( b ) ) );

}

float32_t slow_f32_mulAdd( float32_t a, float32_t b, float32_t c )
{

    return
        floatXToF32(
            floatXAdd(
                floatXMul( f32ToFloatX( a ), f32ToFloatX( b ) ),
                f32ToFloatX( c )
            )
        );

}

float32_t slow_f32_div( float32_t a, float32_t b )
{

    return floatXToF32( floatXDiv( f32ToFloatX( a ), f32ToFloatX( b ) ) );

}

float32_t slow_f32_rem( float32_t a, float32_t b )
{

    return floatXToF32( floatXRem( f32ToFloatX( a ), f32ToFloatX( b ) ) );

}

float32_t slow_f32_sqrt( float32_t a )
{

    return floatXToF32( floatXSqrt( f32ToFloatX( a ) ) );

}

bool slow_f32_eq( float32_t a, float32_t b )
{

    return floatXEq( f32ToFloatX( a ), f32ToFloatX( b ) );

}

bool slow_f32_le( float32_t a, float32_t b )
{
    struct floatX xA, xB;

    xA = f32ToFloatX( a );
    xB = f32ToFloatX( b );
    if ( xA.isNaN || xB.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
    }
    return floatXLE( xA, xB );

}

bool slow_f32_lt( float32_t a, float32_t b )
{
    struct floatX xA, xB;

    xA = f32ToFloatX( a );
    xB = f32ToFloatX( b );
    if ( xA.isNaN || xB.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
    }
    return floatXLT( xA, xB );

}

bool slow_f32_eq_signaling( float32_t a, float32_t b )
{
    struct floatX xA, xB;

    xA = f32ToFloatX( a );
    xB = f32ToFloatX( b );
    if ( xA.isNaN || xB.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
    }
    return floatXEq( xA, xB );

}

bool slow_f32_le_quiet( float32_t a, float32_t b )
{

    return floatXLE( f32ToFloatX( a ), f32ToFloatX( b ) );

}

bool slow_f32_lt_quiet( float32_t a, float32_t b )
{

    return floatXLT( f32ToFloatX( a ), f32ToFloatX( b ) );

}

uint_fast32_t
 slow_f64_to_ui32( float64_t a, int_fast8_t roundingMode, bool exact )
{

    return floatXToUI32( f64ToFloatX( a ), roundingMode, exact );

}

uint_fast64_t
 slow_f64_to_ui64( float64_t a, int_fast8_t roundingMode, bool exact )
{

    return floatXToUI64( f64ToFloatX( a ), roundingMode, exact );

}

int_fast32_t
 slow_f64_to_i32( float64_t a, int_fast8_t roundingMode, bool exact )
{

    return floatXToI32( f64ToFloatX( a ), roundingMode, exact );

}

int_fast64_t
 slow_f64_to_i64( float64_t a, int_fast8_t roundingMode, bool exact )
{

    return floatXToI64( f64ToFloatX( a ), roundingMode, exact );

}

uint_fast32_t slow_f64_to_ui32_r_minMag( float64_t a, bool exact )
{

    return floatXToUI32( f64ToFloatX( a ), softfloat_round_minMag, exact );

}

uint_fast64_t slow_f64_to_ui64_r_minMag( float64_t a, bool exact )
{

    return floatXToUI64( f64ToFloatX( a ), softfloat_round_minMag, exact );

}

int_fast32_t slow_f64_to_i32_r_minMag( float64_t a, bool exact )
{

    return floatXToI32( f64ToFloatX( a ), softfloat_round_minMag, exact );

}

int_fast64_t slow_f64_to_i64_r_minMag( float64_t a, bool exact )
{

    return floatXToI64( f64ToFloatX( a ), softfloat_round_minMag, exact );

}

float32_t slow_f64_to_f32( float64_t a )
{

    return floatXToF32( f64ToFloatX( a ) );

}

#ifdef FLOATX80

floatx80_t slow_f64_to_fx80( float64_t a )
{

    return floatXToFX80( f64ToFloatX( a ) );

}

#endif

#ifdef FLOAT128

float128_t slow_f64_to_f128( float64_t a )
{

    return floatXToF128( f64ToFloatX( a ) );

}

#endif

float64_t
 slow_f64_roundToInt( float64_t a, int_fast8_t roundingMode, bool exact )
{

    return
        floatXToF64(
            floatXRoundToInt( f64ToFloatX( a ), roundingMode, exact ) );

}

float64_t slow_f64_add( float64_t a, float64_t b )
{

    return floatXToF64( floatXAdd( f64ToFloatX( a ), f64ToFloatX( b ) ) );

}

float64_t slow_f64_sub( float64_t a, float64_t b )
{
    union ui64_f64 uB;

    uB.f = b;
    uB.ui ^= UINT64_C( 0x8000000000000000 );
    return floatXToF64( floatXAdd( f64ToFloatX( a ), f64ToFloatX( uB.f ) ) );

}

float64_t slow_f64_mul( float64_t a, float64_t b )
{

    return floatXToF64( floatXMul( f64ToFloatX( a ), f64ToFloatX( b ) ) );

}

float64_t slow_f64_mulAdd( float64_t a, float64_t b, float64_t c )
{

    return
        floatXToF64(
            floatXAdd(
                floatXMul( f64ToFloatX( a ), f64ToFloatX( b ) ),
                f64ToFloatX( c )
            )
        );

}

float64_t slow_f64_div( float64_t a, float64_t b )
{

    return floatXToF64( floatXDiv( f64ToFloatX( a ), f64ToFloatX( b ) ) );

}

float64_t slow_f64_rem( float64_t a, float64_t b )
{

    return floatXToF64( floatXRem( f64ToFloatX( a ), f64ToFloatX( b ) ) );

}

float64_t slow_f64_sqrt( float64_t a )
{

    return floatXToF64( floatXSqrt( f64ToFloatX( a ) ) );

}

bool slow_f64_eq( float64_t a, float64_t b )
{

    return floatXEq( f64ToFloatX( a ), f64ToFloatX( b ) );

}

bool slow_f64_le( float64_t a, float64_t b )
{
    struct floatX xA, xB;

    xA = f64ToFloatX( a );
    xB = f64ToFloatX( b );
    if ( xA.isNaN || xB.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
    }
    return floatXLE( xA, xB );

}

bool slow_f64_lt( float64_t a, float64_t b )
{
    struct floatX xA, xB;

    xA = f64ToFloatX( a );
    xB = f64ToFloatX( b );
    if ( xA.isNaN || xB.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
    }
    return floatXLT( xA, xB );

}

bool slow_f64_eq_signaling( float64_t a, float64_t b )
{
    struct floatX xA, xB;

    xA = f64ToFloatX( a );
    xB = f64ToFloatX( b );
    if ( xA.isNaN || xB.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
    }
    return floatXEq( xA, xB );

}

bool slow_f64_le_quiet( float64_t a, float64_t b )
{

    return floatXLE( f64ToFloatX( a ), f64ToFloatX( b ) );

}

bool slow_f64_lt_quiet( float64_t a, float64_t b )
{

    return floatXLT( f64ToFloatX( a ), f64ToFloatX( b ) );

}

#ifdef FLOATX80

float32_t slow_fx80_to_f32( floatx80_t a )
{

    return floatXToF32( fx80ToFloatX( a ) );

}

float64_t slow_fx80_to_f64( floatx80_t a )
{

    return floatXToF64( fx80ToFloatX( a ) );

}

#ifdef FLOAT128

float128_t slow_fx80_to_f128( floatx80_t a )
{

    return floatXToF128( fx80ToFloatX( a ) );

}

#endif

fx80
 slow_fx80_roundToInt( floatx80_t a, int_fast8_t roundingMode, bool exact )
{

    return
        floatXToFX80(
            floatXRoundToInt( fx80ToFloatX( a ), roundingMode, exact ) );

}

floatx80_t slow_fx80_add( floatx80_t a, floatx80_t b )
{

    return floatXToFX80( floatXAdd( fx80ToFloatX( a ), fx80ToFloatX( b ) ) );

}

floatx80_t slow_fx80_sub( floatx80_t a, floatx80_t b )
{

    b.high ^= 0x8000;
    return floatXToFX80( floatXAdd( fx80ToFloatX( a ), fx80ToFloatX( b ) ) );

}

floatx80_t slow_fx80_mul( floatx80_t a, floatx80_t b )
{

    return floatXToFX80( floatXMul( fx80ToFloatX( a ), fx80ToFloatX( b ) ) );

}

floatx80_t slow_fx80_div( floatx80_t a, floatx80_t b )
{

    return floatXToFX80( floatXDiv( fx80ToFloatX( a ), fx80ToFloatX( b ) ) );

}

floatx80_t slow_fx80_rem( floatx80_t a, floatx80_t b )
{

    return floatXToFX80( floatXRem( fx80ToFloatX( a ), fx80ToFloatX( b ) ) );

}

floatx80_t slow_fx80_sqrt( floatx80_t a )
{

    return floatXToFX80( floatXSqrt( fx80ToFloatX( a ) ) );

}

bool slow_fx80_eq( floatx80_t a, floatx80_t b )
{

    return floatXEq( fx80ToFloatX( a ), fx80ToFloatX( b ) );

}

bool slow_fx80_le( floatx80_t a, floatx80_t b )
{
    struct floatX xA, xB;

    xA = fx80ToFloatX( a );
    xB = fx80ToFloatX( b );
    if ( xA.isNaN || xB.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
    }
    return floatXLE( xA, xB );

}

bool slow_fx80_lt( floatx80_t a, floatx80_t b )
{
    struct floatX xA, xB;

    xA = fx80ToFloatX( a );
    xB = fx80ToFloatX( b );
    if ( xA.isNaN || xB.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
    }
    return floatXLT( xA, xB );

}

bool slow_fx80_eq_signaling( floatx80_t a, floatx80_t b )
{
    struct floatX xA, xB;

    xA = fx80ToFloatX( a );
    xB = fx80ToFloatX( b );
    if ( xA.isNaN || xB.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
    }
    return floatXEq( xA, xB );

}

bool slow_fx80_le_quiet( floatx80_t a, floatx80_t b )
{

    return floatXLE( fx80ToFloatX( a ), fx80ToFloatX( b ) );

}

bool slow_fx80_lt_quiet( floatx80_t a, floatx80_t b )
{

    return floatXLT( fx80ToFloatX( a ), fx80ToFloatX( b ) );

}

#endif

#ifdef FLOAT128

float32_t slow_f128_to_f32( float128_t a )
{

    return floatXToF32( f128ToFloatX( a ) );

}

float64_t slow_f128_to_f64( float128_t a )
{

    return floatXToF64( f128ToFloatX( a ) );

}

#ifdef FLOATX80

floatx80_t slow_f128_to_fx80( float128_t a )
{

    return floatXToFX80( f128ToFloatX( a ) );

}

#endif

f128
 slow_f128_roundToInt( float128_t a, int_fast8_t roundingMode, bool exact )
{

    return
        floatXToF128(
            floatXRoundToInt( f128ToFloatX( a ), roundingMode, exact ) );

}

float128_t slow_f128_add( float128_t a, float128_t b )
{

    return floatXToF128( floatXAdd( f128ToFloatX( a ), f128ToFloatX( b ) ) );

}

float128_t slow_f128_sub( float128_t a, float128_t b )
{

    b.high ^= UINT64_C( 0x8000000000000000 );
    return floatXToF128( floatXAdd( f128ToFloatX( a ), f128ToFloatX( b ) ) );

}

float128_t slow_f128_mul( float128_t a, float128_t b )
{

    return floatXToF128( floatXMul( f128ToFloatX( a ), f128ToFloatX( b ) ) );

}

float128_t slow_f128_div( float128_t a, float128_t b )
{

    return floatXToF128( floatXDiv( f128ToFloatX( a ), f128ToFloatX( b ) ) );

}

float128_t slow_f128_rem( float128_t a, float128_t b )
{

    return floatXToF128( floatXRem( f128ToFloatX( a ), f128ToFloatX( b ) ) );

}

float128_t slow_f128_sqrt( float128_t a )
{

    return floatXToF128( floatXSqrt( f128ToFloatX( a ) ) );

}

bool slow_f128_eq( float128_t a, float128_t b )
{

    return floatXEq( f128ToFloatX( a ), f128ToFloatX( b ) );

}

bool slow_f128_le( float128_t a, float128_t b )
{
    struct floatX xA, xB;

    xA = f128ToFloatX( a );
    xB = f128ToFloatX( b );
    if ( xA.isNaN || xB.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
    }
    return floatXLE( xA, xB );

}

bool slow_f128_lt( float128_t a, float128_t b )
{
    struct floatX xA, xB;

    xA = f128ToFloatX( a );
    xB = f128ToFloatX( b );
    if ( xA.isNaN || xB.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
    }
    return floatXLT( xA, xB );

}

bool slow_f128_eq_signaling( float128_t a, float128_t b )
{
    struct floatX xA, xB;

    xA = f128ToFloatX( a );
    xB = f128ToFloatX( b );
    if ( xA.isNaN || xB.isNaN ) {
        slowfloat_exceptionFlags |= softfloat_flag_invalid;
    }
    return floatXEq( xA, xB );

}

bool slow_f128_le_quiet( float128_t a, float128_t b )
{

    return floatXLE( f128ToFloatX( a ), f128ToFloatX( b ) );

}

bool slow_f128_lt_quiet( float128_t a, float128_t b )
{

    return floatXLT( f128ToFloatX( a ), f128ToFloatX( b ) );

}

#endif

