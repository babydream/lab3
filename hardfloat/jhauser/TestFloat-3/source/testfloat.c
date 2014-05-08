
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
#include "systfloat_config.h"
#include "systfloat.h"
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

static void ( *systFunctionPtr )();

typedef float32_t funcType_a_ui32_z_f32( uint_fast32_t );
typedef float64_t funcType_a_ui32_z_f64( uint_fast32_t );
typedef float32_t funcType_a_ui64_z_f32( uint_fast64_t );
typedef float64_t funcType_a_ui64_z_f64( uint_fast64_t );
typedef float32_t funcType_a_i32_z_f32( int_fast32_t );
typedef float64_t funcType_a_i32_z_f64( int_fast32_t );
typedef float32_t funcType_a_i64_z_f32( int_fast64_t );
typedef float64_t funcType_a_i64_z_f64( int_fast64_t );

typedef uint_fast32_t funcType_a_f32_z_ui32( float32_t );
typedef uint_fast64_t funcType_a_f32_z_ui64( float32_t );
typedef int_fast32_t funcType_a_f32_z_i32( float32_t );
typedef int_fast64_t funcType_a_f32_z_i64( float32_t );
typedef float64_t funcType_a_f32_z_f64( float32_t );
typedef float32_t funcType_az_f32( float32_t );
typedef float32_t funcType_abz_f32( float32_t, float32_t );
typedef bool funcType_ab_f32_z_bool( float32_t, float32_t );

typedef uint_fast32_t funcType_a_f64_z_ui32( float64_t );
typedef uint_fast64_t funcType_a_f64_z_ui64( float64_t );
typedef int_fast32_t funcType_a_f64_z_i32( float64_t );
typedef int_fast64_t funcType_a_f64_z_i64( float64_t );
typedef float32_t funcType_a_f64_z_f32( float64_t );
typedef float64_t funcType_az_f64( float64_t );
typedef float64_t funcType_abz_f64( float64_t, float64_t );
typedef bool funcType_ab_f64_z_bool( float64_t, float64_t );

static uint_fast32_t
 systFunction_a_f32_z_ui32_rx(
     float32_t a, int_fast8_t roundingMode, bool exact )
{

    return ( (funcType_a_f32_z_ui32 *) systFunctionPtr )( a );

}

static uint_fast64_t
 systFunction_a_f32_z_ui64_rx(
     float32_t a, int_fast8_t roundingMode, bool exact )
{

    return ( (funcType_a_f32_z_ui64 *) systFunctionPtr )( a );

}

static int_fast32_t
 systFunction_a_f32_z_i32_rx(
     float32_t a, int_fast8_t roundingMode, bool exact )
{

    return ( (funcType_a_f32_z_i32 *) systFunctionPtr )( a );

}

static int_fast64_t
 systFunction_a_f32_z_i64_rx(
     float32_t a, int_fast8_t roundingMode, bool exact )
{

    return ( (funcType_a_f32_z_i64 *) systFunctionPtr )( a );

}

static uint_fast32_t
 systFunction_a_f64_z_ui32_rx(
     float64_t a, int_fast8_t roundingMode, bool exact )
{

    return ( (funcType_a_f64_z_ui32 *) systFunctionPtr )( a );

}

static uint_fast64_t
 systFunction_a_f64_z_ui64_rx(
     float64_t a, int_fast8_t roundingMode, bool exact )
{

    return ( (funcType_a_f64_z_ui64 *) systFunctionPtr )( a );

}

static int_fast32_t
 systFunction_a_f64_z_i32_rx(
     float64_t a, int_fast8_t roundingMode, bool exact )
{

    return ( (funcType_a_f64_z_i32 *) systFunctionPtr )( a );

}

static int_fast64_t
 systFunction_a_f64_z_i64_rx(
     float64_t a, int_fast8_t roundingMode, bool exact )
{

    return ( (funcType_a_f64_z_i64 *) systFunctionPtr )( a );

}

static float32_t
 systFunction_az_f32_rx( float32_t a, int_fast8_t roundingMode, bool exact )
{

    return ( (funcType_az_f32 *) systFunctionPtr )( a );

}

static float64_t
 systFunction_az_f64_rx( float64_t a, int_fast8_t roundingMode, bool exact )
{

    return ( (funcType_az_f64 *) systFunctionPtr )( a );

}

static void
 testFunctionInstance(
     int_fast8_t functionCode, int_fast8_t roundingMode, bool exact )
{
    funcType_abz_f32 *trueFunction_abz_f32;
    funcType_ab_f32_z_bool *trueFunction_ab_f32_z_bool;
    funcType_abz_f64 *trueFunction_abz_f64;
    funcType_ab_f64_z_bool *trueFunction_ab_f64_z_bool;

    fputs( "Testing ", stderr );
    verCases_writeFunctionName( stderr );
    fputs( ".\n", stderr );
    switch ( functionCode ) {
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case UI32_TO_F32:
        test_a_ui32_z_f32(
            ui32_to_f32, (funcType_a_ui32_z_f32 *) systFunctionPtr );
        break;
     case UI32_TO_F64:
        test_a_ui32_z_f64(
            ui32_to_f64, (funcType_a_ui32_z_f64 *) systFunctionPtr );
        break;
     case UI64_TO_F32:
        test_a_ui64_z_f32(
            ui64_to_f32, (funcType_a_ui64_z_f32 *) systFunctionPtr );
        break;
     case UI64_TO_F64:
        test_a_ui64_z_f64(
            ui64_to_f64, (funcType_a_ui64_z_f64 *) systFunctionPtr );
        break;
     case I32_TO_F32:
        test_a_i32_z_f32(
            i32_to_f32, (funcType_a_i32_z_f32 *) systFunctionPtr );
        break;
     case I32_TO_F64:
        test_a_i32_z_f64(
            i32_to_f64, (funcType_a_i32_z_f64 *) systFunctionPtr );
        break;
     case I64_TO_F32:
        test_a_i64_z_f32(
            i64_to_f32, (funcType_a_i64_z_f32 *) systFunctionPtr );
        break;
     case I64_TO_F64:
        test_a_i64_z_f64(
            i64_to_f64, (funcType_a_i64_z_f64 *) systFunctionPtr );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case F32_TO_UI32:
        test_a_f32_z_ui32_rx(
            f32_to_ui32, systFunction_a_f32_z_ui32_rx, roundingMode, exact );
        break;
     case F32_TO_UI64:
        test_a_f32_z_ui64_rx(
            f32_to_ui64, systFunction_a_f32_z_ui64_rx, roundingMode, exact );
        break;
     case F32_TO_I32:
        test_a_f32_z_i32_rx(
            f32_to_i32, systFunction_a_f32_z_i32_rx, roundingMode, exact );
        break;
     case F32_TO_I64:
        test_a_f32_z_i64_rx(
            f32_to_i64, systFunction_a_f32_z_i64_rx, roundingMode, exact );
        break;
     case F32_TO_F64:
        test_a_f32_z_f64(
            f32_to_f64, (funcType_a_f32_z_f64 *) systFunctionPtr );
        break;
     case F32_ROUNDTOINT:
        test_az_f32_rx(
            f32_roundToInt, systFunction_az_f32_rx, roundingMode, exact );
        break;
     case F32_ADD:
        trueFunction_abz_f32 = f32_add;
        goto test_abz_f32;
     case F32_SUB:
        trueFunction_abz_f32 = f32_sub;
        goto test_abz_f32;
     case F32_MUL:
        trueFunction_abz_f32 = f32_mul;
        goto test_abz_f32;
     case F32_DIV:
        trueFunction_abz_f32 = f32_div;
        goto test_abz_f32;
     case F32_REM:
        trueFunction_abz_f32 = f32_rem;
     test_abz_f32:
        test_abz_f32(
            trueFunction_abz_f32, (funcType_abz_f32 *) systFunctionPtr );
        break;
     case F32_SQRT:
        test_az_f32( f32_sqrt, (funcType_az_f32 *) systFunctionPtr );
        break;
     case F32_EQ:
        trueFunction_ab_f32_z_bool = f32_eq;
        goto test_ab_f32_z_bool;
     case F32_LE:
        trueFunction_ab_f32_z_bool = f32_le;
        goto test_ab_f32_z_bool;
     case F32_LT:
        trueFunction_ab_f32_z_bool = f32_lt;
        goto test_ab_f32_z_bool;
     case F32_EQ_SIGNALING:
        trueFunction_ab_f32_z_bool = f32_eq_signaling;
        goto test_ab_f32_z_bool;
     case F32_LE_QUIET:
        trueFunction_ab_f32_z_bool = f32_le_quiet;
        goto test_ab_f32_z_bool;
     case F32_LT_QUIET:
        trueFunction_ab_f32_z_bool = f32_lt_quiet;
     test_ab_f32_z_bool:
        test_ab_f32_z_bool(
            trueFunction_ab_f32_z_bool,
            (funcType_ab_f32_z_bool *) systFunctionPtr
        );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case F64_TO_UI32:
        test_a_f64_z_ui32_rx(
            f64_to_ui32, systFunction_a_f64_z_ui32_rx, roundingMode, exact );
        break;
     case F64_TO_UI64:
        test_a_f64_z_ui64_rx(
            f64_to_ui64, systFunction_a_f64_z_ui64_rx, roundingMode, exact );
        break;
     case F64_TO_I32:
        test_a_f64_z_i32_rx(
            f64_to_i32, systFunction_a_f64_z_i32_rx, roundingMode, exact );
        break;
     case F64_TO_I64:
        test_a_f64_z_i64_rx(
            f64_to_i64, systFunction_a_f64_z_i64_rx, roundingMode, exact );
        break;
     case F64_TO_F32:
        test_a_f64_z_f32(
            f64_to_f32, (funcType_a_f64_z_f32 *) systFunctionPtr );
        break;
     case F64_ROUNDTOINT:
        test_az_f64_rx(
            f64_roundToInt, systFunction_az_f64_rx, roundingMode, exact );
        break;
     case F64_ADD:
        trueFunction_abz_f64 = f64_add;
        goto test_abz_f64;
     case F64_SUB:
        trueFunction_abz_f64 = f64_sub;
        goto test_abz_f64;
     case F64_MUL:
        trueFunction_abz_f64 = f64_mul;
        goto test_abz_f64;
     case F64_DIV:
        trueFunction_abz_f64 = f64_div;
        goto test_abz_f64;
     case F64_REM:
        trueFunction_abz_f64 = f64_rem;
     test_abz_f64:
        test_abz_f64(
            trueFunction_abz_f64, (funcType_abz_f64 *) systFunctionPtr );
        break;
     case F64_SQRT:
        test_az_f64( f64_sqrt, (funcType_az_f64 *) systFunctionPtr );
        break;
     case F64_EQ:
        trueFunction_ab_f64_z_bool = f64_eq;
        goto test_ab_f64_z_bool;
     case F64_LE:
        trueFunction_ab_f64_z_bool = f64_le;
        goto test_ab_f64_z_bool;
     case F64_LT:
        trueFunction_ab_f64_z_bool = f64_lt;
        goto test_ab_f64_z_bool;
     case F64_EQ_SIGNALING:
        trueFunction_ab_f64_z_bool = f64_eq_signaling;
        goto test_ab_f64_z_bool;
     case F64_LE_QUIET:
        trueFunction_ab_f64_z_bool = f64_le_quiet;
        goto test_ab_f64_z_bool;
     case F64_LT_QUIET:
        trueFunction_ab_f64_z_bool = f64_lt_quiet;
     test_ab_f64_z_bool:
        test_ab_f64_z_bool(
            trueFunction_ab_f64_z_bool,
            (funcType_ab_f64_z_bool *) systFunctionPtr
        );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
#ifdef FLOATX80
     case FX80_TO_F32:
        test_a_fx80_z_f32(
            fx80_to_f32, (funcType_a_fx80_z_f32 *) systFunctionPtr );
        break;
     case FX80_TO_F64:
        test_a_fx80_z_f64(
            fx80_to_f64, (funcType_a_fx80_z_f64 *) systFunctionPtr );
        break;
#endif
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
#ifdef FLOAT128
     case F128_TO_F32:
        test_a_f128_z_f32(
            f128_to_f32, (funcType_a_f128_z_f32 *) systFunctionPtr );
        break;
     case F128_TO_F64:
        test_a_f128_z_f64(
            f128_to_f64, (funcType_a_f128_z_f64 *) systFunctionPtr );
        break;
#endif
    }
    if ( ( verCases_errorStop && verCases_anyErrors ) || verCases_stop ) {
        verCases_exitWithStatus();
    }

}

static void
 testFunction(
     const struct standardFunctionInfo *standardFunctionInfoPtr,
     int_fast8_t roundingPrecisionIn,
     int_fast8_t roundingCodeIn
 )
{
    int_fast8_t functionCode;
    uint_fast8_t functionAttribs;
    bool standardFunctionHasFixedRounding;
    int_fast8_t roundingCode;
    bool exact;
    int_fast8_t roundingPrecision, roundingMode;

    functionCode = standardFunctionInfoPtr->functionCode;
    functionAttribs = functionInfos[ functionCode ].attribs;
    standardFunctionHasFixedRounding = false;
    if ( functionAttribs & FUNC_ARG_ROUNDINGMODE ) {
        roundingCode = standardFunctionInfoPtr->roundingCode;
        if ( roundingCode ) {
            standardFunctionHasFixedRounding = true;
            roundingCodeIn = roundingCode;
        }
    }
    exact = standardFunctionInfoPtr->exact;
    verCases_functionNamePtr = standardFunctionInfoPtr->namePtr;
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
            floatx80_roundingPrecision = roundingPrecision;
            syst_floatx80_setRoundingPrecision( roundingPrecision );
        }
#endif
        for (
            roundingCode = 1; roundingCode < NUM_ROUNDINGMODES; ++roundingCode
        ) {
#ifndef SYST_ROUND_NEAREST_MAXMAG
            if ( roundingCode != ROUND_NEAREST_MAXMAG ) {
#endif
                if (
                    ! (   functionAttribs
                        & ( FUNC_ARG_ROUNDINGMODE | FUNC_EFF_ROUNDINGMODE ) )
                ) {
                    roundingCode = 0;
                } else if ( roundingCodeIn ) {
                    roundingCode = roundingCodeIn;
                }
                verCases_roundingCode =
                    standardFunctionHasFixedRounding ? 0 : roundingCode;
                if ( roundingCode ) {
                    roundingMode = roundingModes[ roundingCode ];
                    softfloat_roundingMode = roundingMode;
                    if ( ! standardFunctionHasFixedRounding ) {
                        systfloat_setRoundingMode( roundingMode );
                    }
                }
                testFunctionInstance( functionCode, roundingMode, exact );
                if ( roundingCodeIn || ! roundingCode ) break;
#ifndef SYST_ROUND_NEAREST_MAXMAG
            }
#endif
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
    const struct standardFunctionInfo *standardFunctionInfoPtr;
    int_fast8_t numOperands, roundingPrecision, roundingCode;
    const char *argPtr;
    void ( *const *systFunctionPtrPtr )();
    const char *functionNamePtr;

    fail_programName = "testfloat";
    if ( argc <= 1 ) goto writeHelpMessage;
    genCases_setLevel( 1 );
    verCases_maxErrorCount = 20;
    writeCase_trueNamePtr = "soft";
    writeCase_testNamePtr = "test";
    testLoops_trueFlagsPtr = &softfloat_exceptionFlags;
    testLoops_testFlagsFunction = systfloat_clearExceptionFlags;
    haveFunctionArg = false;
    standardFunctionInfoPtr = 0;
    numOperands = 0;
    roundingPrecision = 0;
    roundingCode = 0;
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
"testfloat [<option>...] <function>\n"
"  <option>:  (* is default)\n"
"    -help            --Write this message and exit.\n"
"    -list            --List all testable functions and exit.\n"
"    -level <num>     --Testing level <num> (1 or 2).\n"
" *  -level 1\n"
"    -errors <num>    --Stop each function test after <num> errors.\n"
" *  -errors 20\n"
"    -errorstop       --Exit after first function with any error.\n"
"    -forever         --Test one function repeatedly (implies `-level 2').\n"
"    -checkNaNs       --Check for bitwise correctness of NaN results.\n"
#ifdef FLOATX80
"    -precision32     --Only test rounding precision equivalent to float32_t.\n"
"    -precision64     --Only test rounding precision equivalent to float64_t.\n"
"    -precision80     --Only test maximum rounding precision.\n"
#endif
"    -r<round>        --Only test specified rounding (if not inherent to\n"
"                         function).\n"
"    -tininessbefore  --Underflow tininess is detected before rounding.\n"
"    -tininessafter   --Underflow tininess is detected after rounding.\n"
"  <function>:\n"
"    <int>_to_<float>               <float>_add   <float>_eq\n"
"    <float>_to_<int>_r_<round>     <float>_sub   <float>_le\n"
"    <float>_to_<int>_rx_<round>    <float>_mul   <float>_lt\n"
"    <float>_to_<float>             <float>_div   <float>_eq_signaling\n"
"    <float>_roundToInt_r_<round>   <float>_rem   <float>_le_quiet\n"
"    <float>_roundToInt_x                         <float>_lt_quiet\n"
"    <float>_sqrt\n"
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
        } else if ( ! strcmp( argPtr, "list" ) ) {
            standardFunctionInfoPtr = standardFunctionInfos;
            systFunctionPtrPtr = systfloat_functions;
            for (;;) {
                functionNamePtr = standardFunctionInfoPtr->namePtr;
                if ( ! functionNamePtr ) break;
                if ( *systFunctionPtrPtr ) puts( functionNamePtr );
                ++standardFunctionInfoPtr;
                ++systFunctionPtrPtr;
            }
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
        } else if (
            ! strcmp( argPtr, "checkNaNs" ) || ! strcmp( argPtr, "checknans" )
        ) {
            verCases_checkNaNs = true;
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
#ifdef SYST_ROUND_NEAREST_MAXMAG
            roundingCode = ROUND_NEAREST_MAXMAG;
#else
            fail(
 "Rounding mode nearest/maximum magnitude is not supported or cannot be tested"
            );
#endif
        } else if ( ! strcmp( argPtr, "tininessbefore" ) ) {
            softfloat_detectTininess = softfloat_tininess_beforeRounding;
        } else if ( ! strcmp( argPtr, "tininessafter" ) ) {
            softfloat_detectTininess = softfloat_tininess_afterRounding;
        } else if ( ! strcmp( argPtr, "all1" ) ) {
            haveFunctionArg = true;
            standardFunctionInfoPtr = 0;
            numOperands = 1;
        } else if ( ! strcmp( argPtr, "all2" ) ) {
            haveFunctionArg = true;
            standardFunctionInfoPtr = 0;
            numOperands = 2;
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
            systFunctionPtr =
                systfloat_functions[
                    standardFunctionInfoPtr - standardFunctionInfos ];
            if ( ! systFunctionPtr ) {
                fail(
                    "Function `%s' is not supported or cannot be tested",
                    argPtr
                );
            }
            haveFunctionArg = true;
        }
    }
    if ( ! haveFunctionArg ) fail( "Function argument required" );
    signal( SIGINT, catchSIGINT );
    signal( SIGTERM, catchSIGINT );
    if ( standardFunctionInfoPtr ) {
        if ( testLoops_forever ) {
            if ( ! roundingPrecision ) roundingPrecision = 80;
            if ( ! roundingCode ) roundingCode = ROUND_NEAREST_EVEN;
        }
        testFunction(
            standardFunctionInfoPtr, roundingPrecision, roundingCode );
    } else {
        if ( testLoops_forever ) {
            fail( "Can only test one function with `-forever' option" );
        }
        if ( numOperands == 1 ) {
            standardFunctionInfoPtr = standardFunctionInfos;
            systFunctionPtrPtr = systfloat_functions;
            while ( standardFunctionInfoPtr->namePtr ) {
                systFunctionPtr = *systFunctionPtrPtr;
                if (
                       systFunctionPtr
                    && ! ( functionInfos[
                               standardFunctionInfoPtr->functionCode ]
                               .attribs
                               & FUNC_ARG_BINARY )
                ) {
                    testFunction(
                        standardFunctionInfoPtr,
                        roundingPrecision,
                        roundingCode
                    );
                }
                ++standardFunctionInfoPtr;
                ++systFunctionPtrPtr;
            }
        } else {
            standardFunctionInfoPtr = standardFunctionInfos;
            systFunctionPtrPtr = systfloat_functions;
            while ( standardFunctionInfoPtr->namePtr ) {
                systFunctionPtr = *systFunctionPtrPtr;
                if (
                       systFunctionPtr
                    && ( functionInfos[ standardFunctionInfoPtr->functionCode ]
                             .attribs
                             & FUNC_ARG_BINARY )
                ) {
                    testFunction(
                        standardFunctionInfoPtr,
                        roundingPrecision,
                        roundingCode
                    );
                }
                ++standardFunctionInfoPtr;
                ++systFunctionPtrPtr;
            }
        }
    }
    verCases_exitWithStatus();
 optionError:
    fail( "`%s' option requires numeric argument", *argv );

}

