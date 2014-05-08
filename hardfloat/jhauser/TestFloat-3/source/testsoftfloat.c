
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
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include "fail.h"
#include "softfloat.h"
#include "slowfloat.h"
#include "functions.h"
#include "genCases.h"
#include "verCases.h"
#include "writeCase.h"
#include "testLoops.h"

static void catchSIGINT( int signalCode )
{

    if ( verCases_stop ) exit( EXIT_FAILURE );
    verCases_stop = true;

}

static int_fast8_t softfloat_clearExceptionFlags( void )
{
    int_fast8_t prevFlags;

    prevFlags = softfloat_exceptionFlags;
    softfloat_exceptionFlags = 0;
    return prevFlags;

}

static void
 testFunctionInstance(
     int_fast8_t functionCode, int_fast8_t roundingMode, bool exact )
{
    float32_t ( *trueFunction_abz_f32 )( float32_t, float32_t );
    float32_t ( *testFunction_abz_f32 )( float32_t, float32_t );
    bool ( *trueFunction_ab_f32_z_bool )( float32_t, float32_t );
    bool ( *testFunction_ab_f32_z_bool )( float32_t, float32_t );
    float64_t ( *trueFunction_abz_f64 )( float64_t, float64_t );
    float64_t ( *testFunction_abz_f64 )( float64_t, float64_t );
    bool ( *trueFunction_ab_f64_z_bool )( float64_t, float64_t );
    bool ( *testFunction_ab_f64_z_bool )( float64_t, float64_t );

    fputs( "Testing ", stderr );
    verCases_writeFunctionName( stderr );
    fputs( ".\n", stderr );
    switch ( functionCode ) {
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case UI32_TO_F32:
        test_a_ui32_z_f32( slow_ui32_to_f32, ui32_to_f32 );
        break;
     case UI32_TO_F64:
        test_a_ui32_z_f64( slow_ui32_to_f64, ui32_to_f64 );
        break;
#ifdef FLOATX80
     case UI32_TO_FX80:
        test_a_ui32_z_fx80( slow_ui32_to_fx80, ui32_to_fx80 );
        break;
#endif
#ifdef FLOAT128
     case UI32_TO_F128:
        test_a_ui32_z_f128( slow_ui32_to_f128, ui32_to_f128 );
        break;
#endif
     case UI64_TO_F32:
        test_a_ui64_z_f32( slow_ui64_to_f32, ui64_to_f32 );
        break;
     case UI64_TO_F64:
        test_a_ui64_z_f64( slow_ui64_to_f64, ui64_to_f64 );
        break;
#ifdef FLOATX80
     case UI64_TO_FX80:
        test_a_ui64_z_fx80( slow_ui64_to_fx80, ui64_to_fx80 );
        break;
#endif
#ifdef FLOAT128
     case UI64_TO_F128:
        test_a_ui64_z_f128( slow_ui64_to_f128, ui64_to_f128 );
        break;
#endif
     case I32_TO_F32:
        test_a_i32_z_f32( slow_i32_to_f32, i32_to_f32 );
        break;
     case I32_TO_F64:
        test_a_i32_z_f64( slow_i32_to_f64, i32_to_f64 );
        break;
#ifdef FLOATX80
     case I32_TO_FX80:
        test_a_i32_z_fx80( slow_i32_to_fx80, i32_to_fx80 );
        break;
#endif
#ifdef FLOAT128
     case I32_TO_F128:
        test_a_i32_z_f128( slow_i32_to_f128, i32_to_f128 );
        break;
#endif
     case I64_TO_F32:
        test_a_i64_z_f32( slow_i64_to_f32, i64_to_f32 );
        break;
     case I64_TO_F64:
        test_a_i64_z_f64( slow_i64_to_f64, i64_to_f64 );
        break;
#ifdef FLOATX80
     case I64_TO_FX80:
        test_a_i64_z_fx80( slow_i64_to_fx80, i64_to_fx80 );
        break;
#endif
#ifdef FLOAT128
     case I64_TO_F128:
        test_a_i64_z_f128( slow_i64_to_f128, i64_to_f128 );
        break;
#endif
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case F32_TO_UI32:
        test_a_f32_z_ui32_rx(
            slow_f32_to_ui32, f32_to_ui32, roundingMode, exact );
        break;
     case F32_TO_UI64:
        test_a_f32_z_ui64_rx(
            slow_f32_to_ui64, f32_to_ui64, roundingMode, exact );
        break;
     case F32_TO_I32:
        test_a_f32_z_i32_rx(
            slow_f32_to_i32, f32_to_i32, roundingMode, exact );
        break;
     case F32_TO_I64:
        test_a_f32_z_i64_rx(
            slow_f32_to_i64, f32_to_i64, roundingMode, exact );
        break;
     case F32_TO_UI32_R_MINMAG:
        test_a_f32_z_ui32_x(
            slow_f32_to_ui32_r_minMag, f32_to_ui32_r_minMag, exact );
        break;
     case F32_TO_UI64_R_MINMAG:
        test_a_f32_z_ui64_x(
            slow_f32_to_ui64_r_minMag, f32_to_ui64_r_minMag, exact );
        break;
     case F32_TO_I32_R_MINMAG:
        test_a_f32_z_i32_x(
            slow_f32_to_i32_r_minMag, f32_to_i32_r_minMag, exact );
        break;
     case F32_TO_I64_R_MINMAG:
        test_a_f32_z_i64_x(
            slow_f32_to_i64_r_minMag, f32_to_i64_r_minMag, exact );
        break;
     case F32_TO_F64:
        test_a_f32_z_f64( slow_f32_to_f64, f32_to_f64 );
        break;
#ifdef FLOATX80
     case F32_TO_FX80:
        test_a_f32_z_fx80( slow_f32_to_fx80, f32_to_fx80 );
        break;
#endif
#ifdef FLOAT128
     case F32_TO_F128:
        test_a_f32_z_f128( slow_f32_to_f128, f32_to_f128 );
        break;
#endif
     case F32_ROUNDTOINT:
        test_az_f32_rx(
            slow_f32_roundToInt, f32_roundToInt, roundingMode, exact );
        break;
     case F32_ADD:
        trueFunction_abz_f32 = slow_f32_add;
        testFunction_abz_f32 = f32_add;
        goto test_abz_f32;
     case F32_SUB:
        trueFunction_abz_f32 = slow_f32_sub;
        testFunction_abz_f32 = f32_sub;
        goto test_abz_f32;
     case F32_MUL:
        trueFunction_abz_f32 = slow_f32_mul;
        testFunction_abz_f32 = f32_mul;
        goto test_abz_f32;
     case F32_DIV:
        trueFunction_abz_f32 = slow_f32_div;
        testFunction_abz_f32 = f32_div;
        goto test_abz_f32;
     case F32_REM:
        trueFunction_abz_f32 = slow_f32_rem;
        testFunction_abz_f32 = f32_rem;
     test_abz_f32:
        test_abz_f32( trueFunction_abz_f32, testFunction_abz_f32 );
        break;
     case F32_MULADD:
        test_abcz_f32( slow_f32_mulAdd, f32_mulAdd );
        break;
     case F32_SQRT:
        test_az_f32( slow_f32_sqrt, f32_sqrt );
        break;
     case F32_EQ:
        trueFunction_ab_f32_z_bool = slow_f32_eq;
        testFunction_ab_f32_z_bool = f32_eq;
        goto test_ab_f32_z_bool;
     case F32_LE:
        trueFunction_ab_f32_z_bool = slow_f32_le;
        testFunction_ab_f32_z_bool = f32_le;
        goto test_ab_f32_z_bool;
     case F32_LT:
        trueFunction_ab_f32_z_bool = slow_f32_lt;
        testFunction_ab_f32_z_bool = f32_lt;
        goto test_ab_f32_z_bool;
     case F32_EQ_SIGNALING:
        trueFunction_ab_f32_z_bool = slow_f32_eq_signaling;
        testFunction_ab_f32_z_bool = f32_eq_signaling;
        goto test_ab_f32_z_bool;
     case F32_LE_QUIET:
        trueFunction_ab_f32_z_bool = slow_f32_le_quiet;
        testFunction_ab_f32_z_bool = f32_le_quiet;
        goto test_ab_f32_z_bool;
     case F32_LT_QUIET:
        trueFunction_ab_f32_z_bool = slow_f32_lt_quiet;
        testFunction_ab_f32_z_bool = f32_lt_quiet;
     test_ab_f32_z_bool:
        test_ab_f32_z_bool(
            trueFunction_ab_f32_z_bool, testFunction_ab_f32_z_bool );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case F64_TO_UI32:
        test_a_f64_z_ui32_rx(
            slow_f64_to_ui32, f64_to_ui32, roundingMode, exact );
        break;
     case F64_TO_UI64:
        test_a_f64_z_ui64_rx(
            slow_f64_to_ui64, f64_to_ui64, roundingMode, exact );
        break;
     case F64_TO_I32:
        test_a_f64_z_i32_rx(
            slow_f64_to_i32, f64_to_i32, roundingMode, exact );
        break;
     case F64_TO_I64:
        test_a_f64_z_i64_rx(
            slow_f64_to_i64, f64_to_i64, roundingMode, exact );
        break;
     case F64_TO_UI32_R_MINMAG:
        test_a_f64_z_ui32_x(
            slow_f64_to_ui32_r_minMag, f64_to_ui32_r_minMag, exact );
        break;
     case F64_TO_UI64_R_MINMAG:
        test_a_f64_z_ui64_x(
            slow_f64_to_ui64_r_minMag, f64_to_ui64_r_minMag, exact );
        break;
     case F64_TO_I32_R_MINMAG:
        test_a_f64_z_i32_x(
            slow_f64_to_i32_r_minMag, f64_to_i32_r_minMag, exact );
        break;
     case F64_TO_I64_R_MINMAG:
        test_a_f64_z_i64_x(
            slow_f64_to_i64_r_minMag, f64_to_i64_r_minMag, exact );
        break;
     case F64_TO_F32:
        test_a_f64_z_f32( slow_f64_to_f32, f64_to_f32 );
        break;
#ifdef FLOATX80
     case F64_TO_FX80:
        test_a_f64_z_fx80( slow_f64_to_fx80, f64_to_fx80 );
        break;
#endif
#ifdef FLOAT128
     case F64_TO_F128:
        test_a_f64_z_f128( slow_f64_to_f128, f64_to_f128 );
        break;
#endif
     case F64_ROUNDTOINT:
        test_az_f64_rx(
            slow_f64_roundToInt, f64_roundToInt, roundingMode, exact );
        break;
     case F64_ADD:
        trueFunction_abz_f64 = slow_f64_add;
        testFunction_abz_f64 = f64_add;
        goto test_abz_f64;
     case F64_SUB:
        trueFunction_abz_f64 = slow_f64_sub;
        testFunction_abz_f64 = f64_sub;
        goto test_abz_f64;
     case F64_MUL:
        trueFunction_abz_f64 = slow_f64_mul;
        testFunction_abz_f64 = f64_mul;
        goto test_abz_f64;
     case F64_DIV:
        trueFunction_abz_f64 = slow_f64_div;
        testFunction_abz_f64 = f64_div;
        goto test_abz_f64;
     case F64_REM:
        trueFunction_abz_f64 = slow_f64_rem;
        testFunction_abz_f64 = f64_rem;
     test_abz_f64:
        test_abz_f64( trueFunction_abz_f64, testFunction_abz_f64 );
        break;
     case F64_MULADD:
        test_abcz_f64( slow_f64_mulAdd, f64_mulAdd );
        break;
     case F64_SQRT:
        test_az_f64( slow_f64_sqrt, f64_sqrt );
        break;
     case F64_EQ:
        trueFunction_ab_f64_z_bool = slow_f64_eq;
        testFunction_ab_f64_z_bool = f64_eq;
        goto test_ab_f64_z_bool;
     case F64_LE:
        trueFunction_ab_f64_z_bool = slow_f64_le;
        testFunction_ab_f64_z_bool = f64_le;
        goto test_ab_f64_z_bool;
     case F64_LT:
        trueFunction_ab_f64_z_bool = slow_f64_lt;
        testFunction_ab_f64_z_bool = f64_lt;
        goto test_ab_f64_z_bool;
     case F64_EQ_SIGNALING:
        trueFunction_ab_f64_z_bool = slow_f64_eq_signaling;
        testFunction_ab_f64_z_bool = f64_eq_signaling;
        goto test_ab_f64_z_bool;
     case F64_LE_QUIET:
        trueFunction_ab_f64_z_bool = slow_f64_le_quiet;
        testFunction_ab_f64_z_bool = f64_le_quiet;
        goto test_ab_f64_z_bool;
     case F64_LT_QUIET:
        trueFunction_ab_f64_z_bool = slow_f64_lt_quiet;
        testFunction_ab_f64_z_bool = f64_lt_quiet;
     test_ab_f64_z_bool:
        test_ab_f64_z_bool(
            trueFunction_ab_f64_z_bool, testFunction_ab_f64_z_bool );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
#ifdef FLOATX80
     case FX80_TO_F32:
        test_a_fx80_z_f32( slow_fx80_to_f32, fx80_to_f32 );
        break;
     case FX80_TO_F64:
        test_a_fx80_z_f64( slow_fx80_to_f64, fx80_to_f64 );
        break;
#ifdef FLOAT128
     case FX80_TO_F128:
        test_a_fx80_z_f128( slow_fx80_to_f128, fx80_to_f128 );
        break;
#endif
     case FX80_ROUNDTOINT:
        test_az_fx80_rx(
            slow_fx80_roundToInt, fx80_roundToInt, roundingMode, exact );
        break;
     case FX80_ADD:
        trueFunction_abz_fx80 = slow_fx80_add;
        testFunction_abz_fx80 = fx80_add;
        goto test_abz_fx80;
     case FX80_SUB:
        trueFunction_abz_fx80 = slow_fx80_sub;
        testFunction_abz_fx80 = fx80_sub;
        goto test_abz_fx80;
     case FX80_MUL:
        trueFunction_abz_fx80 = slow_fx80_mul;
        testFunction_abz_fx80 = fx80_mul;
        goto test_abz_fx80;
     case FX80_DIV:
        trueFunction_abz_fx80 = slow_fx80_div;
        testFunction_abz_fx80 = fx80_div;
        goto test_abz_fx80;
     case FX80_REM:
        trueFunction_abz_fx80 = slow_fx80_rem;
        testFunction_abz_fx80 = fx80_rem;
     test_abz_fx80:
        test_abz_fx80( trueFunction_abz_fx80, testFunction_abz_fx80 );
        break;
     case FX80_MULADD:
        test_abcz_fx80( slow_fx80_mulAdd, fx80_mulAdd );
        break;
     case FX80_SQRT:
        test_az_fx80( slow_fx80_sqrt, fx80_sqrt );
        break;
     case FX80_EQ:
        trueFunction_ab_fx80_z_bool = slow_fx80_eq;
        testFunction_ab_fx80_z_bool = fx80_eq;
        goto test_ab_fx80_z_bool;
     case FX80_LE:
        trueFunction_ab_fx80_z_bool = slow_fx80_le;
        testFunction_ab_fx80_z_bool = fx80_le;
        goto test_ab_fx80_z_bool;
     case FX80_LT:
        trueFunction_ab_fx80_z_bool = slow_fx80_lt;
        testFunction_ab_fx80_z_bool = fx80_lt;
        goto test_ab_fx80_z_bool;
     case FX80_EQ_SIGNALING:
        trueFunction_ab_fx80_z_bool = slow_fx80_eq_signaling;
        testFunction_ab_fx80_z_bool = fx80_eq_signaling;
        goto test_ab_fx80_z_bool;
     case FX80_LE_QUIET:
        trueFunction_ab_fx80_z_bool = slow_fx80_le_quiet;
        testFunction_ab_fx80_z_bool = fx80_le_quiet;
        goto test_ab_fx80_z_bool;
     case FX80_LT_QUIET:
        trueFunction_ab_fx80_z_bool = slow_fx80_lt_quiet;
        testFunction_ab_fx80_z_bool = fx80_lt_quiet;
     test_ab_fx80_z_bool:
        test_ab_fx80_z_bool(
            trueFunction_ab_fx80_z_bool, testFunction_ab_fx80_z_bool );
        break;
#endif
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
#ifdef FLOAT128
     case F128_TO_F32:
        test_a_f128_z_f32( slow_f128_to_f32, f128_to_f32 );
        break;
     case F128_TO_F64:
        test_a_f128_z_f64( slow_f128_to_f64, f128_to_f64 );
        break;
#ifdef FLOATX80
     case F128_TO_FX80:
        test_a_f128_z_fx80( slow_f128_to_fx80, f128_to_fx80 );
        break;
#endif
     case F128_ROUNDTOINT:
        test_az_f128_rx(
            slow_f128_roundToInt, f128_roundToInt, roundingMode, exact );
        break;
     case F128_ADD:
        trueFunction_abz_f128 = slow_f128_add;
        testFunction_abz_f128 = f128_add;
        goto test_abz_f128;
     case F128_SUB:
        trueFunction_abz_f128 = slow_f128_sub;
        testFunction_abz_f128 = f128_sub;
        goto test_abz_f128;
     case F128_MUL:
        trueFunction_abz_f128 = slow_f128_mul;
        testFunction_abz_f128 = f128_mul;
        goto test_abz_f128;
     case F128_DIV:
        trueFunction_abz_f128 = slow_f128_div;
        testFunction_abz_f128 = f128_div;
        goto test_abz_f128;
     case F128_REM:
        trueFunction_abz_f128 = slow_f128_rem;
        testFunction_abz_f128 = f128_rem;
     test_abz_f128:
        test_abz_f128( trueFunction_abz_f128, testFunction_abz_f128 );
        break;
     case F128_MULADD:
        test_abcz_f128( slow_f128_mulAdd, f128_mulAdd );
        break;
     case F128_SQRT:
        test_az_f128( slow_f128_sqrt, f128_sqrt );
        break;
     case F128_EQ:
        trueFunction_ab_f128_z_bool = slow_f128_eq;
        testFunction_ab_f128_z_bool = f128_eq;
        goto test_ab_f128_z_bool;
     case F128_LE:
        trueFunction_ab_f128_z_bool = slow_f128_le;
        testFunction_ab_f128_z_bool = f128_le;
        goto test_ab_f128_z_bool;
     case F128_LT:
        trueFunction_ab_f128_z_bool = slow_f128_lt;
        testFunction_ab_f128_z_bool = f128_lt;
        goto test_ab_f128_z_bool;
     case F128_EQ_SIGNALING:
        trueFunction_ab_f128_z_bool = slow_f128_eq_signaling;
        testFunction_ab_f128_z_bool = f128_eq_signaling;
        goto test_ab_f128_z_bool;
     case F128_LE_QUIET:
        trueFunction_ab_f128_z_bool = slow_f128_le_quiet;
        testFunction_ab_f128_z_bool = f128_le_quiet;
        goto test_ab_f128_z_bool;
     case F128_LT_QUIET:
        trueFunction_ab_f128_z_bool = slow_f128_lt_quiet;
        testFunction_ab_f128_z_bool = f128_lt_quiet;
     test_ab_f128_z_bool:
        test_ab_f128_z_bool(
            trueFunction_ab_f128_z_bool, testFunction_ab_f128_z_bool );
        break;
#endif
    }
    if ( ( verCases_errorStop && verCases_anyErrors ) || verCases_stop ) {
        verCases_exitWithStatus();
    }

}

enum { EXACT_FALSE = 1, EXACT_TRUE };

static void
 testFunction(
     int_fast8_t functionCode,
     int_fast8_t roundingPrecisionIn,
     int_fast8_t roundingCodeIn,
     int_fast8_t tininessCodeIn,
     int_fast8_t exactCodeIn
 )
{
    uint_fast8_t functionAttribs;
    int_fast8_t roundingPrecision, roundingCode, roundingMode, exactCode;
    bool exact;
    int_fast8_t tininessCode, tininessMode;

    functionAttribs = functionInfos[ functionCode ].attribs;
    verCases_functionNamePtr = functionInfos[ functionCode ].namePtr;
    roundingPrecision = 32;
    for (;;) {
        if ( ! ( functionAttribs & FUNC_EFF_ROUNDINGPRECISION ) ) {
            roundingPrecision = 0;
        } else if ( roundingPrecisionIn ) {
            roundingPrecision = roundingPrecisionIn;
        }
#ifdef FLOATX80
        verCases_roundingPrecision = roundingPrecision;
        if ( roundingPrecision ) {
            slow_floatx80_roundingPrecision = roundingPrecision;
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
            verCases_roundingCode = roundingCode;
            if ( roundingCode ) {
                roundingMode = roundingModes[ roundingCode ];
                if ( functionAttribs & FUNC_EFF_ROUNDINGMODE ) {
                    slowfloat_roundingMode = roundingMode;
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
                verCases_usesExact = ( exactCode != 0 );
                verCases_exact = exact;
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
                    verCases_tininessCode = tininessCode;
                    if ( tininessCode ) {
                        tininessMode = tininessModes[ tininessCode ];
                        slowfloat_detectTininess = tininessMode;
                        softfloat_detectTininess = tininessMode;
                    }
                    testFunctionInstance( functionCode, roundingMode, exact );
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

    fail_programName = "testsoftfloat";
    if ( argc <= 1 ) goto writeHelpMessage;
    genCases_setLevel( 1 );
    verCases_maxErrorCount = 20;
    writeCase_trueNamePtr = "true";
    writeCase_testNamePtr = "soft";
    testLoops_trueFlagsPtr = &slowfloat_exceptionFlags;
    testLoops_testFlagsFunction = softfloat_clearExceptionFlags;
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
"testsoftfloat [<option>...] <function>\n"
"  <option>:  (* is default)\n"
"    -help            --Write this message and exit.\n"
"    -level <num>     --Testing level <num> (1 or 2).\n"
" *  -level 1\n"
"    -errors <num>    --Stop each function test after <num> errors.\n"
" *  -errors 20\n"
"    -errorstop       --Exit after first function with any error.\n"
"    -forever         --Test one function repeatedly (implies `-level 2').\n"
#ifdef FLOATX80
"    -precision32     --Only test rounding precision equivalent to float32_t.\n"
"    -precision64     --Only test rounding precision equivalent to float64_t.\n"
"    -precision80     --Only test maximum rounding precision.\n"
#endif
"    -rnear_even      --Only test rounding to nearest/even.\n"
"    -rminmag         --Only test rounding to minimum magnitude (toward zero).\n"
"    -rmin            --Only test rounding to minimum (down).\n"
"    -rmax            --Only test rounding to maximum (up).\n"
"    -rnear_maxmag    --Only test rounding to nearest/maximum magnitude\n"
"                         (nearest/away).\n"
"    -tininessbefore  --Only test underflow tininess detected before rounding.\n"
"    -tininessafter   --Only test underflow tininess detected after rounding.\n"
"    -notexact        --Only test non-exact rounding to integer (no inexact\n"
"                         exception).\n"
"    -exact           --Only test exact rounding to integer (allow inexact\n"
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
        } else if ( ! strcmp( argPtr, "level" ) ) {
            if ( argc < 2 ) goto optionError;
/*** REPLACE WITH `strtol' FUNCTION. ***/
            genCases_setLevel( atoi( argv[ 1 ] ) );
            --argc;
            ++argv;
        } else if ( ! strcmp( argPtr, "level1" ) ) {
            genCases_setLevel( 1 );
        } else if ( ! strcmp( argPtr, "level2" ) ) {
            genCases_setLevel( 2 );
        } else if ( ! strcmp( argPtr, "errors" ) ) {
            if ( argc < 2 ) goto optionError;
/*** REPLACE WITH `strtol' FUNCTION. ***/
            verCases_maxErrorCount = atoi( argv[ 1 ] );
            --argc;
            ++argv;
        } else if ( ! strcmp( argPtr, "errorstop" ) ) {
            verCases_errorStop = true;
        } else if ( ! strcmp( argPtr, "forever" ) ) {
            genCases_setLevel( 2 );
            testLoops_forever = true;
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
    signal( SIGINT, catchSIGINT );
    signal( SIGTERM, catchSIGINT );
    if ( functionCode ) {
        if ( testLoops_forever ) {
            if ( ! roundingPrecision ) roundingPrecision = 80;
            if ( ! roundingCode ) roundingCode = ROUND_NEAREST_EVEN;
        }
        testFunction(
            functionCode,
            roundingPrecision,
            roundingCode,
            tininessCode,
            exactCode
        );
    } else {
        if ( testLoops_forever ) {
             fail( "Can only test one function with `-forever' option" );
        }
        if ( numOperands == 1 ) {
            for (
                functionCode = 1; functionCode < NUM_FUNCTIONS; ++functionCode
            ) {
                if ( functionInfos[ functionCode ].attribs & FUNC_ARG_UNARY ) {
                    testFunction(
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
                    testFunction(
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
    verCases_exitWithStatus();
 optionError:
    fail( "`%s' option requires numeric argument", *argv );

}

