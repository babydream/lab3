
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
#include "genCases.h"
#include "genLoops.h"

enum {
    TYPE_UI32 = NUM_FUNCTIONS,
    TYPE_UI64,
    TYPE_I32,
    TYPE_I64,
    TYPE_F32,
    TYPE_F32_2,
    TYPE_F32_3,
    TYPE_F64,
    TYPE_F64_2,
    TYPE_F64_3,
    TYPE_FX80,
    TYPE_FX80_2,
    TYPE_FX80_3,
    TYPE_F128,
    TYPE_F128_2,
    TYPE_F128_3
};

static void catchSIGINT( int signalCode )
{

    if ( genLoops_stop ) exit( EXIT_FAILURE );
    genLoops_stop = true;

}

int main( int argc, char *argv[] )
{
    int_fast8_t roundingMode, functionCode;
    const char *argPtr;
    const struct standardFunctionInfo *standardFunctionInfoPtr;
    const char *functionNamePtr;
    uint_fast8_t functionAttribs;
    int_fast8_t functionRoundingCode;
    bool exact;
    float32_t ( *trueFunction_abz_f32 )( float32_t, float32_t );
    bool ( *trueFunction_ab_f32_z_bool )( float32_t, float32_t );
    float64_t ( *trueFunction_abz_f64 )( float64_t, float64_t );
    bool ( *trueFunction_ab_f64_z_bool )( float64_t, float64_t );

    fail_programName = "testfloat_gen";
    if ( argc <= 1 ) goto writeHelpMessage;
    softfloat_detectTininess = softfloat_tininess_beforeRounding;
#ifdef FLOATX80
    floatx80_roundingPrecision = 80;
#endif
    roundingMode = softfloat_round_nearest_even;
    genCases_setLevel( 1 );
    genLoops_trueFlagsPtr = &softfloat_exceptionFlags;
    genLoops_forever = false;
    genLoops_givenCount = false;
    functionCode = 0;
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
"testfloat_gen [<option>...] <type>|<function>\n"
"  <option>:  (* is default)\n"
"    -help            --Write this message and exit.\n"
"    -level <num>     --Testing level <num> (1 or 2).\n"
" *  -level 1\n"
"    -n <num>         --Generate <num> test cases.\n"
"    -forever         --Generate test cases indefinitely (implies `-level 2').\n"
#ifdef FLOATX80
"    -precision32     --Set floatx80 rounding precision equivalent to float32_t.\n"
"    -precision64     --Set floatx80 rounding precision equivalent to float64_t.\n"
" *  -precision80     --Set floatx80 maximum rounding precision.\n"
#endif
"    -r<round>        --Round as specified (if not inherent to function).\n"
" *  -rnear_even\n"
" *  -tininessbefore  --Detect underflow tininess before rounding.\n"
"    -tininessafter   --Detect underflow tininess after rounding.\n"
"  <type>:\n"
"    <int>            --Generate test cases with one integer operand.\n"
"    <float>          --Generate test cases with one floating-point operand.\n"
"    <float> <num>    --Generate test cases with <num> (1, 2, or 3)\n"
"                         floating-point operands.\n"
"  <function>:\n"
"    <int>_to_<float>               <float>_add         <float>_eq\n"
"    <float>_to_<int>_r_<round>     <float>_sub         <float>_le\n"
"    <float>_to_<int>_rx_<round>    <float>_mul         <float>_lt\n"
"    <float>_to_<float>             <float>_mulAdd      <float>_eq_signaling\n"
"    <float>_roundToInt_r_<round>   <float>_mulSub      <float>_le_quiet\n"
"    <float>_roundToInt_x           <float>_mulRevSub   <float>_lt_quiet\n"
"                                   <float>_div\n"
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
        } else if ( ! strcmp( argPtr, "n" ) ) {
            if ( argc < 2 ) goto optionError;
            genLoops_forever = true;
            genLoops_givenCount = true;
/*** REPLACE WITH `strtol' FUNCTION. ***/
            genLoops_count = atoi( argv[ 1 ] );
            --argc;
            ++argv;
        } else if ( ! strcmp( argPtr, "forever" ) ) {
            genCases_setLevel( 2 );
            genLoops_forever = true;
            genLoops_givenCount = false;
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
            roundingMode = softfloat_round_nearest_even;
        } else if (
            ! strcmp( argPtr, "rminmag" ) || ! strcmp( argPtr, "rminMag" )
        ) {
            roundingMode = softfloat_round_minMag;
        } else if ( ! strcmp( argPtr, "rmin" ) ) {
            roundingMode = softfloat_round_min;
        } else if ( ! strcmp( argPtr, "rmax" ) ) {
            roundingMode = softfloat_round_max;
        } else if (
               ! strcmp( argPtr, "rnear_maxmag" )
            || ! strcmp( argPtr, "rnear_maxMag" )
            || ! strcmp( argPtr, "rnearmaxmag" )
            || ! strcmp( argPtr, "rnearest_maxmag" )
            || ! strcmp( argPtr, "rnearest_maxMag" )
        ) {
            roundingMode = softfloat_round_nearest_maxMag;
        } else if ( ! strcmp( argPtr, "tininessbefore" ) ) {
            softfloat_detectTininess = softfloat_tininess_beforeRounding;
        } else if ( ! strcmp( argPtr, "tininessafter" ) ) {
            softfloat_detectTininess = softfloat_tininess_afterRounding;
        } else if (
            ! strcmp( argPtr, "ui32" ) || ! strcmp( argPtr, "uint32" )
        ) {
            functionCode = TYPE_UI32;
            if ( 2 <= argc ) goto absorbArg1;
        } else if (
            ! strcmp( argPtr, "ui64" ) || ! strcmp( argPtr, "uint64" )
        ) {
            functionCode = TYPE_UI64;
            if ( 2 <= argc ) goto absorbArg1;
        } else if (
            ! strcmp( argPtr, "i32" ) || ! strcmp( argPtr, "int32" )
        ) {
            functionCode = TYPE_I32;
            if ( 2 <= argc ) goto absorbArg1;
        } else if (
            ! strcmp( argPtr, "i64" ) || ! strcmp( argPtr, "int64" )
        ) {
            functionCode = TYPE_I64;
            if ( 2 <= argc ) goto absorbArg1;
        } else if (
            ! strcmp( argPtr, "f32" ) || ! strcmp( argPtr, "float32" )
        ) {
            functionCode = TYPE_F32;
            goto absorbArg;
        } else if (
            ! strcmp( argPtr, "f64" ) || ! strcmp( argPtr, "float64" )
        ) {
            functionCode = TYPE_F64;
     absorbArg:
            if ( 2 <= argc ) {
                if ( ! strcmp( argv[ 1 ], "2" ) ) {
                    --argc;
                    ++argv;
                    ++functionCode;
                } else if ( ! strcmp( argv[ 1 ], "3" ) ) {
                    --argc;
                    ++argv;
                    functionCode += 2;
                } else {
     absorbArg1:
                    if ( ! strcmp( argv[ 1 ], "1" ) ) {
                        --argc;
                        ++argv;
                    }
                }
            }
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
            functionAttribs = functionInfos[ functionCode ].attribs;
            if ( functionAttribs & FUNC_ARG_ROUNDINGMODE ) {
                functionRoundingCode = standardFunctionInfoPtr->roundingCode;
                if ( functionRoundingCode ) {
                    roundingMode = roundingModes[ functionRoundingCode ];
                }
            }
            exact = standardFunctionInfoPtr->exact;
        }
    }
    if ( ! functionCode ) fail( "Type or function argument required" );
    softfloat_roundingMode = roundingMode;
    signal( SIGINT, catchSIGINT );
    signal( SIGTERM, catchSIGINT );
    switch ( functionCode ) {
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case TYPE_UI32:
        gen_a_ui32();
        break;
     case TYPE_UI64:
        gen_a_ui64();
        break;
     case TYPE_I32:
        gen_a_i32();
        break;
     case TYPE_I64:
        gen_a_i64();
        break;
     case TYPE_F32:
        gen_a_f32();
        break;
     case TYPE_F32_2:
        gen_ab_f32();
        break;
     case TYPE_F32_3:
        gen_abc_f32();
        break;
     case TYPE_F64:
        gen_a_f64();
        break;
     case TYPE_F64_2:
        gen_ab_f64();
        break;
     case TYPE_F64_3:
        gen_abc_f64();
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case UI32_TO_F32:
        gen_a_ui32_z_f32( ui32_to_f32 );
        break;
     case UI32_TO_F64:
        gen_a_ui32_z_f64( ui32_to_f64 );
        break;
     case UI64_TO_F32:
        gen_a_ui64_z_f32( ui64_to_f32 );
        break;
     case UI64_TO_F64:
        gen_a_ui64_z_f64( ui64_to_f64 );
        break;
     case I32_TO_F32:
        gen_a_i32_z_f32( i32_to_f32 );
        break;
     case I32_TO_F64:
        gen_a_i32_z_f64( i32_to_f64 );
        break;
     case I64_TO_F32:
        gen_a_i64_z_f32( i64_to_f32 );
        break;
     case I64_TO_F64:
        gen_a_i64_z_f64( i64_to_f64 );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case F32_TO_UI32:
        gen_a_f32_z_ui32_rx( f32_to_ui32, roundingMode, exact );
        break;
     case F32_TO_UI64:
        gen_a_f32_z_ui64_rx( f32_to_ui64, roundingMode, exact );
        break;
     case F32_TO_I32:
        gen_a_f32_z_i32_rx( f32_to_i32, roundingMode, exact );
        break;
     case F32_TO_I64:
        gen_a_f32_z_i64_rx( f32_to_i64, roundingMode, exact );
        break;
     case F32_TO_F64:
        gen_a_f32_z_f64( f32_to_f64 );
        break;
     case F32_ROUNDTOINT:
        gen_az_f32_rx( f32_roundToInt, roundingMode, exact );
        break;
     case F32_ADD:
        trueFunction_abz_f32 = f32_add;
        goto gen_abz_f32;
     case F32_SUB:
        trueFunction_abz_f32 = f32_sub;
        goto gen_abz_f32;
     case F32_MUL:
        trueFunction_abz_f32 = f32_mul;
        goto gen_abz_f32;
     case F32_DIV:
        trueFunction_abz_f32 = f32_div;
        goto gen_abz_f32;
     case F32_REM:
        trueFunction_abz_f32 = f32_rem;
     gen_abz_f32:
        gen_abz_f32( trueFunction_abz_f32 );
        break;
     case F32_MULADD:
        gen_abcz_f32( f32_mulAdd );
        break;
     case F32_SQRT:
        gen_az_f32( f32_sqrt );
        break;
     case F32_EQ:
        trueFunction_ab_f32_z_bool = f32_eq;
        goto gen_ab_f32_z_bool;
     case F32_LE:
        trueFunction_ab_f32_z_bool = f32_le;
        goto gen_ab_f32_z_bool;
     case F32_LT:
        trueFunction_ab_f32_z_bool = f32_lt;
        goto gen_ab_f32_z_bool;
     case F32_EQ_SIGNALING:
        trueFunction_ab_f32_z_bool = f32_eq_signaling;
        goto gen_ab_f32_z_bool;
     case F32_LE_QUIET:
        trueFunction_ab_f32_z_bool = f32_le_quiet;
        goto gen_ab_f32_z_bool;
     case F32_LT_QUIET:
        trueFunction_ab_f32_z_bool = f32_lt_quiet;
     gen_ab_f32_z_bool:
        gen_ab_f32_z_bool( trueFunction_ab_f32_z_bool );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
     case F64_TO_UI32:
        gen_a_f64_z_ui32_rx( f64_to_ui32, roundingMode, exact );
        break;
     case F64_TO_UI64:
        gen_a_f64_z_ui64_rx( f64_to_ui64, roundingMode, exact );
        break;
     case F64_TO_I32:
        gen_a_f64_z_i32_rx( f64_to_i32, roundingMode, exact );
        break;
     case F64_TO_I64:
        gen_a_f64_z_i64_rx( f64_to_i64, roundingMode, exact );
        break;
     case F64_TO_F32:
        gen_a_f64_z_f32( f64_to_f32 );
        break;
     case F64_ROUNDTOINT:
        gen_az_f64_rx( f64_roundToInt, roundingMode, exact );
        break;
     case F64_ADD:
        trueFunction_abz_f64 = f64_add;
        goto gen_abz_f64;
     case F64_SUB:
        trueFunction_abz_f64 = f64_sub;
        goto gen_abz_f64;
     case F64_MUL:
        trueFunction_abz_f64 = f64_mul;
        goto gen_abz_f64;
     case F64_DIV:
        trueFunction_abz_f64 = f64_div;
        goto gen_abz_f64;
     case F64_REM:
        trueFunction_abz_f64 = f64_rem;
     gen_abz_f64:
        gen_abz_f64( trueFunction_abz_f64 );
        break;
     case F64_MULADD:
        gen_abcz_f64( f64_mulAdd );
        break;
     case F64_SQRT:
        gen_az_f64( f64_sqrt );
        break;
     case F64_EQ:
        trueFunction_ab_f64_z_bool = f64_eq;
        goto gen_ab_f64_z_bool;
     case F64_LE:
        trueFunction_ab_f64_z_bool = f64_le;
        goto gen_ab_f64_z_bool;
     case F64_LT:
        trueFunction_ab_f64_z_bool = f64_lt;
        goto gen_ab_f64_z_bool;
     case F64_EQ_SIGNALING:
        trueFunction_ab_f64_z_bool = f64_eq_signaling;
        goto gen_ab_f64_z_bool;
     case F64_LE_QUIET:
        trueFunction_ab_f64_z_bool = f64_le_quiet;
        goto gen_ab_f64_z_bool;
     case F64_LT_QUIET:
        trueFunction_ab_f64_z_bool = f64_lt_quiet;
     gen_ab_f64_z_bool:
        gen_ab_f64_z_bool( trueFunction_ab_f64_z_bool );
        break;
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
#ifdef FLOATX80
     case FX80_TO_UI32:
        gen_a_fx80_z_ui32_rx( fx80_to_ui32, roundingMode, exact );
        break;
     case FX80_TO_UI64:
        gen_a_fx80_z_ui64_rx( fx80_to_ui64, roundingMode, exact );
        break;
     case FX80_TO_I32:
        gen_a_fx80_z_i32_rx( fx80_to_i32, roundingMode, exact );
        break;
     case FX80_TO_I64:
        gen_a_fx80_z_i64_rx( fx80_to_i64, roundingMode, exact );
        break;
     case FX80_TO_F32:
        gen_a_fx80_z_f32( fx80_to_f32 );
        break;
     case FX80_TO_F64:
        gen_a_fx80_z_f64( fx80_to_f64 );
        break;
#endif
        /*--------------------------------------------------------------------
        *--------------------------------------------------------------------*/
#ifdef FLOAT128
     case F128_TO_UI32:
        gen_a_f128_z_ui32_rx( f128_to_ui32, roundingMode, exact );
        break;
     case F128_TO_UI64:
        gen_a_f128_z_ui64_rx( f128_to_ui64, roundingMode, exact );
        break;
     case F128_TO_I32:
        gen_a_f128_z_i32_rx( f128_to_i32, roundingMode, exact );
        break;
     case F128_TO_I64:
        gen_a_f128_z_i64_rx( f128_to_i64, roundingMode, exact );
        break;
     case F128_TO_F32:
        gen_a_f128_z_f32( f128_to_f32 );
        break;
     case F128_TO_F64:
        gen_a_f128_z_f64( f128_to_f64 );
        break;
#endif
    }
    return EXIT_SUCCESS;
 optionError:
    fail( "`%s' option requires numeric argument", *argv );

}

