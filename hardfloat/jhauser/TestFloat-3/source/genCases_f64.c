
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
#include "random.h"
#include "softfloat.h"
#include "genCases.h"

struct sequence {
    int expNum, term1Num, term2Num;
    bool done;
};

union ui64_f64 { uint64_t ui; float64_t f; };

/*** TO REPLACE. ***/
#define SETFLOAT64( z, zHigh, zLow ) z = ( (uint_fast64_t) (zHigh)<<32 | (zLow) )

enum {
    f64NumQIn  =  22,
    f64NumQOut =  64,
    f64NumP1   =   4,
    f64NumP2   = 204
};
static const uint32_t f64QIn[ f64NumQIn ] = {
    0x00000000,    /* positive, subnormal       */
    0x00100000,    /* positive, -1022           */
    0x3CA00000,    /* positive,   -53           */
    0x3FD00000,    /* positive,    -2           */
    0x3FE00000,    /* positive,    -1           */
    0x3FF00000,    /* positive,     0           */
    0x40000000,    /* positive,     1           */
    0x40100000,    /* positive,     2           */
    0x43400000,    /* positive,    53           */
    0x7FE00000,    /* positive,  1023           */
    0x7FF00000,    /* positive, infinity or NaN */
    0x80000000,    /* negative, subnormal       */
    0x80100000,    /* negative, -1022           */
    0xBCA00000,    /* negative,   -53           */
    0xBFD00000,    /* negative,    -2           */
    0xBFE00000,    /* negative,    -1           */
    0xBFF00000,    /* negative,     0           */
    0xC0000000,    /* negative,     1           */
    0xC0100000,    /* negative,     2           */
    0xC3400000,    /* negative,    53           */
    0xFFE00000,    /* negative,  1023           */
    0xFFF00000     /* negative, infinity or NaN */
};
static const uint32_t f64QOut[ f64NumQOut ] = {
    0x00000000,    /* positive, subnormal       */
    0x00100000,    /* positive, -1022           */
    0x00200000,    /* positive, -1021           */
    0x37E00000,    /* positive,  -129           */
    0x37F00000,    /* positive,  -128           */
    0x38000000,    /* positive,  -127           */
    0x38100000,    /* positive,  -126           */
    0x3CA00000,    /* positive,   -53           */
    0x3FB00000,    /* positive,    -4           */
    0x3FC00000,    /* positive,    -3           */
    0x3FD00000,    /* positive,    -2           */
    0x3FE00000,    /* positive,    -1           */
    0x3FF00000,    /* positive,     0           */
    0x40000000,    /* positive,     1           */
    0x40100000,    /* positive,     2           */
    0x40200000,    /* positive,     3           */
    0x40300000,    /* positive,     4           */
    0x41C00000,    /* positive,    29           */
    0x41D00000,    /* positive,    30           */
    0x41E00000,    /* positive,    31           */
    0x41F00000,    /* positive,    32           */
    0x43400000,    /* positive,    53           */
    0x43C00000,    /* positive,    61           */
    0x43D00000,    /* positive,    62           */
    0x43E00000,    /* positive,    63           */
    0x43F00000,    /* positive,    64           */
    0x47E00000,    /* positive,   127           */
    0x47F00000,    /* positive,   128           */
    0x48000000,    /* positive,   129           */
    0x7FD00000,    /* positive,  1022           */
    0x7FE00000,    /* positive,  1023           */
    0x7FF00000,    /* positive, infinity or NaN */
    0x80000000,    /* negative, subnormal       */
    0x80100000,    /* negative, -1022           */
    0x80200000,    /* negative, -1021           */
    0xB7E00000,    /* negative,  -129           */
    0xB7F00000,    /* negative,  -128           */
    0xB8000000,    /* negative,  -127           */
    0xB8100000,    /* negative,  -126           */
    0xBCA00000,    /* negative,   -53           */
    0xBFB00000,    /* negative,    -4           */
    0xBFC00000,    /* negative,    -3           */
    0xBFD00000,    /* negative,    -2           */
    0xBFE00000,    /* negative,    -1           */
    0xBFF00000,    /* negative,     0           */
    0xC0000000,    /* negative,     1           */
    0xC0100000,    /* negative,     2           */
    0xC0200000,    /* negative,     3           */
    0xC0300000,    /* negative,     4           */
    0xC1C00000,    /* negative,    29           */
    0xC1D00000,    /* negative,    30           */
    0xC1E00000,    /* negative,    31           */
    0xC1F00000,    /* negative,    32           */
    0xC3400000,    /* negative,    53           */
    0xC3C00000,    /* negative,    61           */
    0xC3D00000,    /* negative,    62           */
    0xC3E00000,    /* negative,    63           */
    0xC3F00000,    /* negative,    64           */
    0xC7E00000,    /* negative,   127           */
    0xC7F00000,    /* negative,   128           */
    0xC8000000,    /* negative,   129           */
    0xFFD00000,    /* negative,  1022           */
    0xFFE00000,    /* negative,  1023           */
    0xFFF00000     /* negative, infinity or NaN */
};
static const struct { uint32_t high, low; } f64P1[ f64NumP1 ] = {
    { 0x00000000, 0x00000000 },
    { 0x00000000, 0x00000001 },
    { 0x000FFFFF, 0xFFFFFFFF },
    { 0x000FFFFF, 0xFFFFFFFE }
};
static const struct { uint32_t high, low; } f64P2[ f64NumP2 ] = {
    { 0x00000000, 0x00000000 },
    { 0x00000000, 0x00000001 },
    { 0x00000000, 0x00000002 },
    { 0x00000000, 0x00000004 },
    { 0x00000000, 0x00000008 },
    { 0x00000000, 0x00000010 },
    { 0x00000000, 0x00000020 },
    { 0x00000000, 0x00000040 },
    { 0x00000000, 0x00000080 },
    { 0x00000000, 0x00000100 },
    { 0x00000000, 0x00000200 },
    { 0x00000000, 0x00000400 },
    { 0x00000000, 0x00000800 },
    { 0x00000000, 0x00001000 },
    { 0x00000000, 0x00002000 },
    { 0x00000000, 0x00004000 },
    { 0x00000000, 0x00008000 },
    { 0x00000000, 0x00010000 },
    { 0x00000000, 0x00020000 },
    { 0x00000000, 0x00040000 },
    { 0x00000000, 0x00080000 },
    { 0x00000000, 0x00100000 },
    { 0x00000000, 0x00200000 },
    { 0x00000000, 0x00400000 },
    { 0x00000000, 0x00800000 },
    { 0x00000000, 0x01000000 },
    { 0x00000000, 0x02000000 },
    { 0x00000000, 0x04000000 },
    { 0x00000000, 0x08000000 },
    { 0x00000000, 0x10000000 },
    { 0x00000000, 0x20000000 },
    { 0x00000000, 0x40000000 },
    { 0x00000000, 0x80000000 },
    { 0x00000001, 0x00000000 },
    { 0x00000002, 0x00000000 },
    { 0x00000004, 0x00000000 },
    { 0x00000008, 0x00000000 },
    { 0x00000010, 0x00000000 },
    { 0x00000020, 0x00000000 },
    { 0x00000040, 0x00000000 },
    { 0x00000080, 0x00000000 },
    { 0x00000100, 0x00000000 },
    { 0x00000200, 0x00000000 },
    { 0x00000400, 0x00000000 },
    { 0x00000800, 0x00000000 },
    { 0x00001000, 0x00000000 },
    { 0x00002000, 0x00000000 },
    { 0x00004000, 0x00000000 },
    { 0x00008000, 0x00000000 },
    { 0x00010000, 0x00000000 },
    { 0x00020000, 0x00000000 },
    { 0x00040000, 0x00000000 },
    { 0x00080000, 0x00000000 },
    { 0x000C0000, 0x00000000 },
    { 0x000E0000, 0x00000000 },
    { 0x000F0000, 0x00000000 },
    { 0x000F8000, 0x00000000 },
    { 0x000FC000, 0x00000000 },
    { 0x000FE000, 0x00000000 },
    { 0x000FF000, 0x00000000 },
    { 0x000FF800, 0x00000000 },
    { 0x000FFC00, 0x00000000 },
    { 0x000FFE00, 0x00000000 },
    { 0x000FFF00, 0x00000000 },
    { 0x000FFF80, 0x00000000 },
    { 0x000FFFC0, 0x00000000 },
    { 0x000FFFE0, 0x00000000 },
    { 0x000FFFF0, 0x00000000 },
    { 0x000FFFF8, 0x00000000 },
    { 0x000FFFFC, 0x00000000 },
    { 0x000FFFFE, 0x00000000 },
    { 0x000FFFFF, 0x00000000 },
    { 0x000FFFFF, 0x80000000 },
    { 0x000FFFFF, 0xC0000000 },
    { 0x000FFFFF, 0xE0000000 },
    { 0x000FFFFF, 0xF0000000 },
    { 0x000FFFFF, 0xF8000000 },
    { 0x000FFFFF, 0xFC000000 },
    { 0x000FFFFF, 0xFE000000 },
    { 0x000FFFFF, 0xFF000000 },
    { 0x000FFFFF, 0xFF800000 },
    { 0x000FFFFF, 0xFFC00000 },
    { 0x000FFFFF, 0xFFE00000 },
    { 0x000FFFFF, 0xFFF00000 },
    { 0x000FFFFF, 0xFFF80000 },
    { 0x000FFFFF, 0xFFFC0000 },
    { 0x000FFFFF, 0xFFFE0000 },
    { 0x000FFFFF, 0xFFFF0000 },
    { 0x000FFFFF, 0xFFFF8000 },
    { 0x000FFFFF, 0xFFFFC000 },
    { 0x000FFFFF, 0xFFFFE000 },
    { 0x000FFFFF, 0xFFFFF000 },
    { 0x000FFFFF, 0xFFFFF800 },
    { 0x000FFFFF, 0xFFFFFC00 },
    { 0x000FFFFF, 0xFFFFFE00 },
    { 0x000FFFFF, 0xFFFFFF00 },
    { 0x000FFFFF, 0xFFFFFF80 },
    { 0x000FFFFF, 0xFFFFFFC0 },
    { 0x000FFFFF, 0xFFFFFFE0 },
    { 0x000FFFFF, 0xFFFFFFF0 },
    { 0x000FFFFF, 0xFFFFFFF8 },
    { 0x000FFFFF, 0xFFFFFFFC },
    { 0x000FFFFF, 0xFFFFFFFE },
    { 0x000FFFFF, 0xFFFFFFFF },
    { 0x000FFFFF, 0xFFFFFFFD },
    { 0x000FFFFF, 0xFFFFFFFB },
    { 0x000FFFFF, 0xFFFFFFF7 },
    { 0x000FFFFF, 0xFFFFFFEF },
    { 0x000FFFFF, 0xFFFFFFDF },
    { 0x000FFFFF, 0xFFFFFFBF },
    { 0x000FFFFF, 0xFFFFFF7F },
    { 0x000FFFFF, 0xFFFFFEFF },
    { 0x000FFFFF, 0xFFFFFDFF },
    { 0x000FFFFF, 0xFFFFFBFF },
    { 0x000FFFFF, 0xFFFFF7FF },
    { 0x000FFFFF, 0xFFFFEFFF },
    { 0x000FFFFF, 0xFFFFDFFF },
    { 0x000FFFFF, 0xFFFFBFFF },
    { 0x000FFFFF, 0xFFFF7FFF },
    { 0x000FFFFF, 0xFFFEFFFF },
    { 0x000FFFFF, 0xFFFDFFFF },
    { 0x000FFFFF, 0xFFFBFFFF },
    { 0x000FFFFF, 0xFFF7FFFF },
    { 0x000FFFFF, 0xFFEFFFFF },
    { 0x000FFFFF, 0xFFDFFFFF },
    { 0x000FFFFF, 0xFFBFFFFF },
    { 0x000FFFFF, 0xFF7FFFFF },
    { 0x000FFFFF, 0xFEFFFFFF },
    { 0x000FFFFF, 0xFDFFFFFF },
    { 0x000FFFFF, 0xFBFFFFFF },
    { 0x000FFFFF, 0xF7FFFFFF },
    { 0x000FFFFF, 0xEFFFFFFF },
    { 0x000FFFFF, 0xDFFFFFFF },
    { 0x000FFFFF, 0xBFFFFFFF },
    { 0x000FFFFF, 0x7FFFFFFF },
    { 0x000FFFFE, 0xFFFFFFFF },
    { 0x000FFFFD, 0xFFFFFFFF },
    { 0x000FFFFB, 0xFFFFFFFF },
    { 0x000FFFF7, 0xFFFFFFFF },
    { 0x000FFFEF, 0xFFFFFFFF },
    { 0x000FFFDF, 0xFFFFFFFF },
    { 0x000FFFBF, 0xFFFFFFFF },
    { 0x000FFF7F, 0xFFFFFFFF },
    { 0x000FFEFF, 0xFFFFFFFF },
    { 0x000FFDFF, 0xFFFFFFFF },
    { 0x000FFBFF, 0xFFFFFFFF },
    { 0x000FF7FF, 0xFFFFFFFF },
    { 0x000FEFFF, 0xFFFFFFFF },
    { 0x000FDFFF, 0xFFFFFFFF },
    { 0x000FBFFF, 0xFFFFFFFF },
    { 0x000F7FFF, 0xFFFFFFFF },
    { 0x000EFFFF, 0xFFFFFFFF },
    { 0x000DFFFF, 0xFFFFFFFF },
    { 0x000BFFFF, 0xFFFFFFFF },
    { 0x0007FFFF, 0xFFFFFFFF },
    { 0x0003FFFF, 0xFFFFFFFF },
    { 0x0001FFFF, 0xFFFFFFFF },
    { 0x0000FFFF, 0xFFFFFFFF },
    { 0x00007FFF, 0xFFFFFFFF },
    { 0x00003FFF, 0xFFFFFFFF },
    { 0x00001FFF, 0xFFFFFFFF },
    { 0x00000FFF, 0xFFFFFFFF },
    { 0x000007FF, 0xFFFFFFFF },
    { 0x000003FF, 0xFFFFFFFF },
    { 0x000001FF, 0xFFFFFFFF },
    { 0x000000FF, 0xFFFFFFFF },
    { 0x0000007F, 0xFFFFFFFF },
    { 0x0000003F, 0xFFFFFFFF },
    { 0x0000001F, 0xFFFFFFFF },
    { 0x0000000F, 0xFFFFFFFF },
    { 0x00000007, 0xFFFFFFFF },
    { 0x00000003, 0xFFFFFFFF },
    { 0x00000001, 0xFFFFFFFF },
    { 0x00000000, 0xFFFFFFFF },
    { 0x00000000, 0x7FFFFFFF },
    { 0x00000000, 0x3FFFFFFF },
    { 0x00000000, 0x1FFFFFFF },
    { 0x00000000, 0x0FFFFFFF },
    { 0x00000000, 0x07FFFFFF },
    { 0x00000000, 0x03FFFFFF },
    { 0x00000000, 0x01FFFFFF },
    { 0x00000000, 0x00FFFFFF },
    { 0x00000000, 0x007FFFFF },
    { 0x00000000, 0x003FFFFF },
    { 0x00000000, 0x001FFFFF },
    { 0x00000000, 0x000FFFFF },
    { 0x00000000, 0x0007FFFF },
    { 0x00000000, 0x0003FFFF },
    { 0x00000000, 0x0001FFFF },
    { 0x00000000, 0x0000FFFF },
    { 0x00000000, 0x00007FFF },
    { 0x00000000, 0x00003FFF },
    { 0x00000000, 0x00001FFF },
    { 0x00000000, 0x00000FFF },
    { 0x00000000, 0x000007FF },
    { 0x00000000, 0x000003FF },
    { 0x00000000, 0x000001FF },
    { 0x00000000, 0x000000FF },
    { 0x00000000, 0x0000007F },
    { 0x00000000, 0x0000003F },
    { 0x00000000, 0x0000001F },
    { 0x00000000, 0x0000000F },
    { 0x00000000, 0x00000007 },
    { 0x00000000, 0x00000003 }
};

static const uint_fast64_t f64NumQInP1 = f64NumQIn * f64NumP1;
static const uint_fast64_t f64NumQOutP1 = f64NumQOut * f64NumP1;

static float64_t f64NextQInP1( struct sequence *sequencePtr )
{
    int expNum, sigNum;
    union ui64_f64 uZ;

    sigNum = sequencePtr->term1Num;
    expNum = sequencePtr->expNum;
    SETFLOAT64(
        uZ.ui,
        f64QIn[ expNum ] | f64P1[ sigNum ].high,
        f64P1[ sigNum ].low
    );
    ++sigNum;
    if ( f64NumP1 <= sigNum ) {
        sigNum = 0;
        ++expNum;
        if ( f64NumQIn <= expNum ) {
            expNum = 0;
            sequencePtr->done = true;
        }
        sequencePtr->expNum = expNum;
    }
    sequencePtr->term1Num = sigNum;
    return uZ.f;

}

static float64_t f64NextQOutP1( struct sequence *sequencePtr )
{
    int expNum, sigNum;
    union ui64_f64 uZ;

    sigNum = sequencePtr->term1Num;
    expNum = sequencePtr->expNum;
    SETFLOAT64(
        uZ.ui,
        f64QOut[ expNum ] | f64P1[ sigNum ].high,
        f64P1[ sigNum ].low
    );
    ++sigNum;
    if ( f64NumP1 <= sigNum ) {
        sigNum = 0;
        ++expNum;
        if ( f64NumQOut <= expNum ) {
            expNum = 0;
            sequencePtr->done = true;
        }
        sequencePtr->expNum = expNum;
    }
    sequencePtr->term1Num = sigNum;
    return uZ.f;

}

static const uint_fast64_t f64NumQInP2 = f64NumQIn * f64NumP2;
static const uint_fast64_t f64NumQOutP2 = f64NumQOut * f64NumP2;

static float64_t f64NextQInP2( struct sequence *sequencePtr )
{
    int expNum, sigNum;
    union ui64_f64 uZ;

    sigNum = sequencePtr->term1Num;
    expNum = sequencePtr->expNum;
    SETFLOAT64(
        uZ.ui,
        f64QIn[ expNum ] | f64P2[ sigNum ].high,
        f64P2[ sigNum ].low
    );
    ++sigNum;
    if ( f64NumP2 <= sigNum ) {
        sigNum = 0;
        ++expNum;
        if ( f64NumQIn <= expNum ) {
            expNum = 0;
            sequencePtr->done = true;
        }
        sequencePtr->expNum = expNum;
    }
    sequencePtr->term1Num = sigNum;
    return uZ.f;

}

static float64_t f64NextQOutP2( struct sequence *sequencePtr )
{
    int expNum, sigNum;
    union ui64_f64 uZ;

    sigNum = sequencePtr->term1Num;
    expNum = sequencePtr->expNum;
    SETFLOAT64(
        uZ.ui,
        f64QOut[ expNum ] | f64P2[ sigNum ].high,
        f64P2[ sigNum ].low
    );
    ++sigNum;
    if ( f64NumP2 <= sigNum ) {
        sigNum = 0;
        ++expNum;
        if ( f64NumQOut <= expNum ) {
            expNum = 0;
            sequencePtr->done = true;
        }
        sequencePtr->expNum = expNum;
    }
    sequencePtr->term1Num = sigNum;
    return uZ.f;

}

static float64_t f64RandomQOutP3( void )
{
    int sigNum1, sigNum2;
    uint_fast32_t sig1Low, sig2Low, zLow;
    union ui64_f64 uZ;

    sigNum1 = random_ui8() % f64NumP2;
    sigNum2 = random_ui8() % f64NumP2;
    sig1Low = f64P2[ sigNum1 ].low;
    sig2Low = f64P2[ sigNum2 ].low;
    zLow = sig1Low + sig2Low;
    SETFLOAT64(
        uZ.ui,
          f64QOut[ random_ui8() % f64NumQOut ]
        | (   (   f64P2[ sigNum1 ].high
                + f64P2[ sigNum2 ].high
                + ( zLow < sig1Low )
              )
            & 0x000FFFFF
          ),
        zLow
    );
    return uZ.f;

}

static float64_t f64RandomQOutPInf( void )
{
    union ui64_f64 uZ;

    SETFLOAT64(
        uZ.ui,
        f64QOut[ random_ui8() % f64NumQOut ] | ( random_ui32() & 0x000FFFFF ),
        random_ui32()
    );
    return uZ.f;

}

enum { f64NumQInfWeightMasks = 10 };
static const uint32_t f64QInfWeightMasks[ f64NumQInfWeightMasks ] = {
    0x7FF00000,
    0x7FF00000,
    0x3FF00000,
    0x1FF00000,
    0x0FF00000,
    0x07F00000,
    0x03F00000,
    0x01F00000,
    0x00F00000,
    0x00700000
};
static const uint32_t f64QInfWeightOffsets[ f64NumQInfWeightMasks ] = {
    0x00000000,
    0x00000000,
    0x20000000,
    0x30000000,
    0x38000000,
    0x3C000000,
    0x3E000000,
    0x3F000000,
    0x3F800000,
    0x3FC00000
};

static float64_t f64RandomQInfP3( void )
{
    int sigNum1, sigNum2;
    uint_fast32_t sig1Low, sig2Low, zLow;
    int weightMaskNum;
    union ui64_f64 uZ;

    sigNum1 = random_ui8() % f64NumP2;
    sigNum2 = random_ui8() % f64NumP2;
    sig1Low = f64P2[ sigNum1 ].low;
    sig2Low = f64P2[ sigNum2 ].low;
    zLow = sig1Low + sig2Low;
    weightMaskNum = random_ui8() % f64NumQInfWeightMasks;
    SETFLOAT64(
        uZ.ui,
          (uint_fast32_t) ( random_ui8() & 1 )<<31
        | (   ( (uint_fast32_t) ( random_ui16() & 0xFFF )<<20
                    & f64QInfWeightMasks[ weightMaskNum ] )
            + f64QInfWeightOffsets[ weightMaskNum ]
          )
        | (   ( f64P2[ sigNum1 ].high + f64P2[ sigNum2 ].high
                    + ( zLow < sig1Low ) )
            & 0x000FFFFF
          ),
        zLow
    );
    return uZ.f;

}

static float64_t f64RandomQInfPInf( void )
{
    int weightMaskNum;
    union ui64_f64 uZ;

    weightMaskNum = random_ui8() % f64NumQInfWeightMasks;
    SETFLOAT64(
        uZ.ui,
          (uint_fast32_t) ( random_ui8() & 1 )<<31
        | (   ( (uint_fast32_t) ( random_ui16() & 0xFFF )<<20
                    & f64QInfWeightMasks[ weightMaskNum ] )
            + f64QInfWeightOffsets[ weightMaskNum ]
          )
        | ( random_ui32() & 0x000FFFFF ),
        random_ui32()
    );
    return uZ.f;

}

static float64_t f64Random( void )
{

    switch ( random_ui8() & 7 ) {
     case 0:
     case 1:
     case 2:
        return f64RandomQOutP3();
     case 3:
        return f64RandomQOutPInf();
     case 4:
     case 5:
     case 6:
        return f64RandomQInfP3();
     case 7:
        return f64RandomQInfPInf();
    }

}

static struct sequence sequenceA, sequenceB, sequenceC;
static float64_t currentA, currentB, currentC;
static int subcase;

float64_t genCases_f64_a, genCases_f64_b, genCases_f64_c;

void genCases_f64_a_init( void )
{

    sequenceA.expNum = 0;
    sequenceA.term1Num = 0;
    sequenceA.term2Num = 0;
    sequenceA.done = false;
    subcase = 0;
    genCases_total =
        ( genCases_level == 1 ) ? 3 * f64NumQOutP1 : 2 * f64NumQOutP2;
    genCases_done = false;

}

void genCases_f64_a_next( void )
{

    if ( genCases_level == 1 ) {
        switch ( subcase ) {
         case 0:
         case 1:
            genCases_f64_a = f64Random();
            break;
         case 2:
            genCases_f64_a = f64NextQOutP1( &sequenceA );
            genCases_done = sequenceA.done;
            subcase = -1;
            break;
        }
     } else {
        switch ( subcase ) {
         case 0:
            genCases_f64_a = f64Random();
            break;
         case 1:
            genCases_f64_a = f64NextQOutP2( &sequenceA );
            genCases_done = sequenceA.done;
            subcase = -1;
            break;
        }
    }
    ++subcase;

}

void genCases_f64_ab_init( void )
{

    sequenceA.expNum = 0;
    sequenceA.term1Num = 0;
    sequenceA.term2Num = 0;
    sequenceA.done = false;
    sequenceB.expNum = 0;
    sequenceB.term1Num = 0;
    sequenceB.term2Num = 0;
    sequenceB.done = false;
    subcase = 0;
    if ( genCases_level == 1 ) {
        genCases_total = 6 * f64NumQInP1 * f64NumQInP1;
        currentA = f64NextQInP1( &sequenceA );
    } else {
        genCases_total = 2 * f64NumQInP2 * f64NumQInP2;
        currentA = f64NextQInP2( &sequenceA );
    }
    genCases_done = false;

}

void genCases_f64_ab_next( void )
{

    if ( genCases_level == 1 ) {
        switch ( subcase ) {
         case 0:
            if ( sequenceB.done ) {
                sequenceB.done = false;
                currentA = f64NextQInP1( &sequenceA );
            }
            currentB = f64NextQInP1( &sequenceB );
         case 2:
         case 4:
            genCases_f64_a = f64Random();
            genCases_f64_b = f64Random();
            break;
         case 1:
            genCases_f64_a = currentA;
            genCases_f64_b = f64Random();
            break;
         case 3:
            genCases_f64_a = f64Random();
            genCases_f64_b = currentB;
            break;
         case 5:
            genCases_f64_a = currentA;
            genCases_f64_b = currentB;
            genCases_done = sequenceA.done & sequenceB.done;
            subcase = -1;
            break;
        }
    } else {
        switch ( subcase ) {
         case 0:
            genCases_f64_a = f64Random();
            genCases_f64_b = f64Random();
            break;
         case 1:
            if ( sequenceB.done ) {
                sequenceB.done = false;
                currentA = f64NextQInP2( &sequenceA );
            }
            genCases_f64_a = currentA;
            genCases_f64_b = f64NextQInP2( &sequenceB );
            genCases_done = sequenceA.done & sequenceB.done;
            subcase = -1;
            break;
        }
    }
    ++subcase;

}

void genCases_f64_abc_init( void )
{

    sequenceA.expNum = 0;
    sequenceA.term1Num = 0;
    sequenceA.term2Num = 0;
    sequenceA.done = false;
    sequenceB.expNum = 0;
    sequenceB.term1Num = 0;
    sequenceB.term2Num = 0;
    sequenceB.done = false;
    sequenceC.expNum = 0;
    sequenceC.term1Num = 0;
    sequenceC.term2Num = 0;
    sequenceC.done = false;
    subcase = 0;
    if ( genCases_level == 1 ) {
        genCases_total = 9 * f64NumQInP1 * f64NumQInP1 * f64NumQInP1;
        currentA = f64NextQInP1( &sequenceA );
        currentB = f64NextQInP1( &sequenceB );
    } else {
        genCases_total = 2 * f64NumQInP2 * f64NumQInP2 * f64NumQInP2;
        currentA = f64NextQInP2( &sequenceA );
        currentB = f64NextQInP2( &sequenceB );
    }
    genCases_done = false;

}

void genCases_f64_abc_next( void )
{

    if ( genCases_level == 1 ) {
        switch ( subcase ) {
         case 0:
            if ( sequenceC.done ) {
                sequenceC.done = false;
                if ( sequenceB.done ) {
                    sequenceB.done = false;
                    currentA = f64NextQInP1( &sequenceA );
                }
                currentB = f64NextQInP1( &sequenceB );
            }
            currentC = f64NextQInP1( &sequenceC );
            genCases_f64_a = f64Random();
            genCases_f64_b = f64Random();
            genCases_f64_c = currentC;
            break;
         case 1:
            genCases_f64_a = currentA;
            genCases_f64_b = currentB;
            genCases_f64_c = f64Random();
            break;
         case 2:
            genCases_f64_a = f64Random();
            genCases_f64_b = f64Random();
            genCases_f64_c = f64Random();
            break;
         case 3:
            genCases_f64_a = f64Random();
            genCases_f64_b = currentB;
            genCases_f64_c = currentC;
            break;
         case 4:
            genCases_f64_a = currentA;
            genCases_f64_b = f64Random();
            genCases_f64_c = f64Random();
            break;
         case 5:
            genCases_f64_a = f64Random();
            genCases_f64_b = currentB;
            genCases_f64_c = f64Random();
            break;
         case 6:
            genCases_f64_a = currentA;
            genCases_f64_b = f64Random();
            genCases_f64_c = currentC;
            break;
         case 7:
            genCases_f64_a = f64Random();
            genCases_f64_b = f64Random();
            genCases_f64_c = f64Random();
            break;
         case 8:
            genCases_f64_a = currentA;
            genCases_f64_b = currentB;
            genCases_f64_c = currentC;
            genCases_done = sequenceA.done & sequenceB.done & sequenceC.done;;
            subcase = -1;
            break;
        }
    } else {
        switch ( subcase ) {
         case 0:
            genCases_f64_a = f64Random();
            genCases_f64_b = f64Random();
            genCases_f64_c = f64Random();
            break;
         case 1:
            if ( sequenceC.done ) {
                sequenceC.done = false;
                if ( sequenceB.done ) {
                    sequenceB.done = false;
                    currentA = f64NextQInP2( &sequenceA );
                }
                currentB = f64NextQInP2( &sequenceB );
            }
            genCases_f64_a = currentA;
            genCases_f64_b = currentB;
            genCases_f64_c = f64NextQInP2( &sequenceC );
            genCases_done = sequenceA.done & sequenceB.done & sequenceC.done;;
            subcase = -1;
            break;
        }
    }
    ++subcase;

}

