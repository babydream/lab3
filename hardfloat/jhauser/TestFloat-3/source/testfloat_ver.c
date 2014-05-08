
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
#include "functions.h"
#include "verCases.h"
#include "writeCase.h"
#include "verLoops.h"

static void catchSIGINT( int signalCode )
{

    if ( verCases_stop ) exit( EXIT_FAILURE );
    verCases_stop = true;

}

int main( int argc, char *argv[] )
{
    int_fast8_t functionCode, roundingCode, tininessCode;
    const char *argPtr;
    const struct standardFunctionInfo *standardFunctionInfoPtr;
    const char *functionNamePtr;
    uint_fast8_t functionAttribs;
    bool standardFunctionHasFixedRounding;
    int_fast8_t functionRoundingCode, roundingMode;
    bool exact;
    float32_t ( *trueFunction_abz_f32 )( float32_t, float32_t );
    bool ( *trueFunction_ab_f32_z_bool )( float32_t, float32_t );
    float64_t ( *trueFunction_abz_f64 )( float64_t, float64_t );
    bool ( *trueFunction_ab_f64_z_bool )( float64_t, float64_t );

    fail_programName = "testfloat_ver";
    if ( argc <= 1 ) goto writeHelpMessage;
    softfloat_detectTininess = softfloat_tininess_beforeRounding;
#ifdef FLOATX80
    floatx80_roundingPrecision = 80;
#endif
    verCases_maxErrorCount = 20;
    writeCase_trueNamePtr = "soft";
    writeCase_testNamePtr = "test";
    verLoops_trueFlagsPtr = &softfloat_exceptionFlags;
    functionCode = 0;
    roundingCode = ROUND_NEAREST_EVEN;
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
"testfloat_ver [<option>...] <function>\n"
"  <option>:  (* is default)\n"
"    -help            --Write this message and exit.\n"
"    -errors <num>    --Stop after <num> errors.\n"
" *  -errors 20\n"
#ifdef FLOATX80
"    -precision32     --floatx80 rounding precision is equivalent to float32_t.\n"
"    -precision64     --floatx80 rounding precision is equivalent to float64_t.\n"
" *  -precision80     --floatx80 rounding precision is maximum.\n"
#endif
"    -r<round>        --Rounding is as specified (if not inherent to function).\n"
" *  -rnear_even\n"
" *  -tininessbefore  --Underflow tininess is detected before rounding.\n"
"    -tininessafter   --Underflow tininess is detected after rounding.\n"
"  <function>:\n"
"    <int>_to_<float>               <float>_add         <float>_eq\n"
"    <float>_to_<int>_r_<round>     <float>_sub         <float>_le\n"
"    <float>_to_<int>_rx_<round>    <float>_mul         <float>_lt\n"
"    <float>_to_<float>             <float>_mulAdd      <float>_eq_signaling\n"
"    <float>_roundToInt_r_<round>   <float>_mulSub      <float>_le_quiet\n"
"    <float>_roundToInt_x           <float>_mulRevSub   <float>_lt_quiet\n"
"                                   <float>_rem\n"
"                                   <float>_sqrt\n"
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
"  <round>:\n"
"    near_even        --Round to nearest/even.\n"
"    minMag           --Round to minimum magnitude (toward zero).\n"
"    min              --Round to minimum (down).\n"
"    max              --Round to maximum (up).\n"
"    near_maxMag      --Round to nearest/maximum magnitude (nearest/away).\n"
                ,
                stdout
            );
            return EXIT_SUCCESS;
        } else if ( ! strcmp( argPtr, "errors" ) ) {
            if ( argc < 2 ) goto optionError;
/*** REPLACE WITH `strtol' FUNCTION. ***/
            verCases_maxErrorCount = atoi( argv[ 1 ] );
            --argc;
            ++argv;
#ifdef FLOATX80
        } else if ( ! strcmp( argPtr, "precision32" ) ) {
            floatx80_roundingPrecision = 32;
        } else if ( ! strcmp( argPtr, "precision64" ) ) {
            floatx80_roundingPrecision = 64;
        } else if ( ! strcmp( argPtr, "precision80" ) ) {
            floatx80_roundingPrecision = 80;
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
            softfloat_detectTininess = softfloat_tininess_beforeRounding;
        } else if ( ! strcmp( argPtr, "tininessafter" ) ) {
            softfloat_detectTininess = softfloat_tininess_afterRounding;
        } else {
            standardFunctionInfoPtr = standardFunctionInfos;
            for (;;) {
                functionNamePtr = standardFunctionInfoPtr->namePtr;
                if ( ! functionNamePtr ) {
                    fail( "Invalid argument `%s'", *argv );
                }
                if ( ! strcmp( argPtr, functionNamePtr ) ) break;
                ++standardFunctionInfoPtr;
            }
            functionCode = standardFunctionInfoPtr->functionCode;
        }
    }
    if ( ! functionCode ) fail( "Function argument required" );
    functionAttribs = functionInfos[ functionCode ].attribs;
    standardFunctionHasFixedRounding = false;
    if ( functionAttribs & FUNC_ARG_ROUNDINGMODE ) {
        functionRoundingCode = standardFunctionInfoPtr->roundingCode;
        if ( functionRoundingCode ) {
            standardFunctionHasFixedRounding = true;
            roundingCode = functionRoundingCode;
        }
    }
    roundingMode = roundingModes[ roundingCode ];
    exact = standardFunctionInfoPtr->exact;
    verCases_functionNamePtr = functionNamePtr;
    verCases_roundingPrecision =
        functionAttribs & FUNC_EFF_ROUNDINGPRECISION
            ? floatx80_roundingPrecision
            : 0;
    verCases_roundingCode =
        ! standardFunctionHasFixedRounding
            && ( functionAttribs
                     & ( FUNC_ARG_ROUNDINGMODE | FUNC_EFF_ROUNDINGMODE ) )
            ? roundingCode
            : 0;
    softfloat_roundingMode = roundingMode;
    signal( SIGINT, catchSIGINT );
    signal( SIGTERM, catchSIGINT );
    fputs( "Testing ", stderr );
    verCases_writeFunctionName( stderr );
    fputs( ".\n", stderr );
    switch ( functionCode ) {
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case UI32_TO_F32:
        ver_a_ui32_z_f32( ui32_to_f32 );
        break;
     case UI32_TO_F64:
        ver_a_ui32_z_f64( ui32_to_f64 );
        break;
     case UI64_TO_F32:
        ver_a_ui64_z_f32( ui64_to_f32 );
        break;
     case UI64_TO_F64:
        ver_a_ui64_z_f64( ui64_to_f64 );
        break;
     case I32_TO_F32:
        ver_a_i32_z_f32( i32_to_f32 );
        break;
     case I32_TO_F64:
        ver_a_i32_z_f64( i32_to_f64 );
        break;
     case I64_TO_F32:
        ver_a_i64_z_f32( i64_to_f32 );
        break;
     case I64_TO_F64:
        ver_a_i64_z_f64( i64_to_f64 );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case F32_TO_UI32:
        ver_a_f32_z_ui32_rx( f32_to_ui32, roundingMode, exact );
        break;
     case F32_TO_UI64:
        ver_a_f32_z_ui64_rx( f32_to_ui64, roundingMode, exact );
        break;
     case F32_TO_I32:
        ver_a_f32_z_i32_rx( f32_to_i32, roundingMode, exact );
        break;
     case F32_TO_I64:
        ver_a_f32_z_i64_rx( f32_to_i64, roundingMode, exact );
        break;
     case F32_TO_F64:
        ver_a_f32_z_f64( f32_to_f64 );
        break;
     case F32_ROUNDTOINT:
        ver_az_f32_rx( f32_roundToInt, roundingMode, exact );
        break;
     case F32_ADD:
        trueFunction_abz_f32 = f32_add;
        goto ver_abz_f32;
     case F32_SUB:
        trueFunction_abz_f32 = f32_sub;
        goto ver_abz_f32;
     case F32_MUL:
        trueFunction_abz_f32 = f32_mul;
        goto ver_abz_f32;
     case F32_DIV:
        trueFunction_abz_f32 = f32_div;
        goto ver_abz_f32;
     case F32_REM:
        trueFunction_abz_f32 = f32_rem;
     ver_abz_f32:
        ver_abz_f32( trueFunction_abz_f32 );
        break;
     case F32_MULADD:
        ver_abcz_f32( f32_mulAdd );
        break;
     case F32_SQRT:
        ver_az_f32( f32_sqrt );
        break;
     case F32_EQ:
        trueFunction_ab_f32_z_bool = f32_eq;
        goto ver_ab_f32_z_bool;
     case F32_LE:
        trueFunction_ab_f32_z_bool = f32_le;
        goto ver_ab_f32_z_bool;
     case F32_LT:
        trueFunction_ab_f32_z_bool = f32_lt;
        goto ver_ab_f32_z_bool;
     case F32_EQ_SIGNALING:
        trueFunction_ab_f32_z_bool = f32_eq_signaling;
        goto ver_ab_f32_z_bool;
     case F32_LE_QUIET:
        trueFunction_ab_f32_z_bool = f32_le_quiet;
        goto ver_ab_f32_z_bool;
     case F32_LT_QUIET:
        trueFunction_ab_f32_z_bool = f32_lt_quiet;
     ver_ab_f32_z_bool:
        ver_ab_f32_z_bool( trueFunction_ab_f32_z_bool );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case F64_TO_UI32:
        ver_a_f64_z_ui32_rx( f64_to_ui32, roundingMode, exact );
        break;
     case F64_TO_UI64:
        ver_a_f64_z_ui64_rx( f64_to_ui64, roundingMode, exact );
        break;
     case F64_TO_I32:
        ver_a_f64_z_i32_rx( f64_to_i32, roundingMode, exact );
        break;
     case F64_TO_I64:
        ver_a_f64_z_i64_rx( f64_to_i64, roundingMode, exact );
        break;
     case F64_TO_F32:
        ver_a_f64_z_f32( f64_to_f32 );
        break;
     case F64_ROUNDTOINT:
        ver_az_f64_rx( f64_roundToInt, roundingMode, exact );
        break;
     case F64_ADD:
        trueFunction_abz_f64 = f64_add;
        goto ver_abz_f64;
     case F64_SUB:
        trueFunction_abz_f64 = f64_sub;
        goto ver_abz_f64;
     case F64_MUL:
        trueFunction_abz_f64 = f64_mul;
        goto ver_abz_f64;
     case F64_DIV:
        trueFunction_abz_f64 = f64_div;
        goto ver_abz_f64;
     case F64_REM:
        trueFunction_abz_f64 = f64_rem;
     ver_abz_f64:
        ver_abz_f64( trueFunction_abz_f64 );
        break;
     case F64_MULADD:
        ver_abcz_f64( f64_mulAdd );
        break;
     case F64_SQRT:
        ver_az_f64( f64_sqrt );
        break;
     case F64_EQ:
        trueFunction_ab_f64_z_bool = f64_eq;
        goto ver_ab_f64_z_bool;
     case F64_LE:
        trueFunction_ab_f64_z_bool = f64_le;
        goto ver_ab_f64_z_bool;
     case F64_LT:
        trueFunction_ab_f64_z_bool = f64_lt;
        goto ver_ab_f64_z_bool;
     case F64_EQ_SIGNALING:
        trueFunction_ab_f64_z_bool = f64_eq_signaling;
        goto ver_ab_f64_z_bool;
     case F64_LE_QUIET:
        trueFunction_ab_f64_z_bool = f64_le_quiet;
        goto ver_ab_f64_z_bool;
     case F64_LT_QUIET:
        trueFunction_ab_f64_z_bool = f64_lt_quiet;
     ver_ab_f64_z_bool:
        ver_ab_f64_z_bool( trueFunction_ab_f64_z_bool );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
#ifdef FLOATX80
     case FX80_TO_UI32:
        ver_a_fx80_z_ui32_rx( fx80_to_ui32, roundingMode, exact );
        break;
     case FX80_TO_UI64:
        ver_a_fx80_z_ui64_rx( fx80_to_ui64, roundingMode, exact );
        break;
     case FX80_TO_I32:
        ver_a_fx80_z_i32_rx( fx80_to_i32, roundingMode, exact );
        break;
     case FX80_TO_I64:
        ver_a_fx80_z_i64_rx( fx80_to_i64, roundingMode, exact );
        break;
     case FX80_TO_F32:
        ver_a_fx80_z_f32( fx80_to_f32 );
        break;
     case FX80_TO_F64:
        ver_a_fx80_z_f64( fx80_to_f64 );
        break;
#endif
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
#ifdef FLOAT128
     case F128_TO_UI32:
        ver_a_f128_z_ui32_rx( f128_to_ui32, roundingMode, exact );
        break;
     case F128_TO_UI64:
        ver_a_f128_z_ui64_rx( f128_to_ui64, roundingMode, exact );
        break;
     case F128_TO_I32:
        ver_a_f128_z_i32_rx( f128_to_i32, roundingMode, exact );
        break;
     case F128_TO_I64:
        ver_a_f128_z_i64_rx( f128_to_i64, roundingMode, exact );
        break;
     case F128_TO_F32:
        ver_a_f128_z_f32( f128_to_f32 );
        break;
     case F128_TO_F64:
        ver_a_f128_z_f64( f128_to_f64 );
        break;
#endif
    }
    verCases_exitWithStatus();
 optionError:
    fail( "`%s' option requires numeric argument", *argv );

}

