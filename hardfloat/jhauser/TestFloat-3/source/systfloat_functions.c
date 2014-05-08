
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
#include "systfloat_config.h"
#include "systfloat.h"
#include "functions.h"

typedef void genFuncType();

/*----------------------------------------------------------------------------
| WARNING:
|   The order of these array entries must match the order in the array
| `standardFunctionInfos'.  Be careful about making changes.
*----------------------------------------------------------------------------*/

genFuncType *const systfloat_functions[] = {
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
#ifdef SYST_UI32_TO_F32
    (genFuncType *) syst_ui32_to_f32,
#else
    0,
#endif
#ifdef SYST_UI32_TO_F64
    (genFuncType *) syst_ui32_to_f64,
#else
    0,
#endif
#ifdef SYST_UI64_TO_F32
    (genFuncType *) syst_ui64_to_f32,
#else
    0,
#endif
#ifdef SYST_UI64_TO_F64
    (genFuncType *) syst_ui64_to_f64,
#else
    0,
#endif
#ifdef SYST_I32_TO_F32
    (genFuncType *) syst_i32_to_f32,
#else
    0,
#endif
#ifdef SYST_I32_TO_F64
    (genFuncType *) syst_i32_to_f64,
#else
    0,
#endif
#ifdef SYST_I64_TO_F32
    (genFuncType *) syst_i64_to_f32,
#else
    0,
#endif
#ifdef SYST_I64_TO_F64
    (genFuncType *) syst_i64_to_f64,
#else
    0,
#endif
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
#ifdef SYST_F32_TO_UI32_R_NEAR_EVEN
    (genFuncType *) syst_f32_to_ui32_r_near_even,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI32_R_MINMAG
    (genFuncType *) syst_f32_to_ui32_r_minMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI32_R_MIN
    (genFuncType *) syst_f32_to_ui32_r_min,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI32_R_MAX
    (genFuncType *) syst_f32_to_ui32_r_max,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI32_R_NEAR_MAXMAG
    (genFuncType *) syst_f32_to_ui32_r_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI64_R_NEAR_EVEN
    (genFuncType *) syst_f32_to_ui64_r_near_even,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI64_R_MINMAG
    (genFuncType *) syst_f32_to_ui64_r_minMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI64_R_MIN
    (genFuncType *) syst_f32_to_ui64_r_min,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI64_R_MAX
    (genFuncType *) syst_f32_to_ui64_r_max,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI64_R_NEAR_MAXMAG
    (genFuncType *) syst_f32_to_ui64_r_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_I32_R_NEAR_EVEN
    (genFuncType *) syst_f32_to_i32_r_near_even,
#else
    0,
#endif
#ifdef SYST_F32_TO_I32_R_MINMAG
    (genFuncType *) syst_f32_to_i32_r_minMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_I32_R_MIN
    (genFuncType *) syst_f32_to_i32_r_min,
#else
    0,
#endif
#ifdef SYST_F32_TO_I32_R_MAX
    (genFuncType *) syst_f32_to_i32_r_max,
#else
    0,
#endif
#ifdef SYST_F32_TO_I32_R_NEAR_MAXMAG
    (genFuncType *) syst_f32_to_i32_r_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_I64_R_NEAR_EVEN
    (genFuncType *) syst_f32_to_i64_r_near_even,
#else
    0,
#endif
#ifdef SYST_F32_TO_I64_R_MINMAG
    (genFuncType *) syst_f32_to_i64_r_minMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_I64_R_MIN
    (genFuncType *) syst_f32_to_i64_r_min,
#else
    0,
#endif
#ifdef SYST_F32_TO_I64_R_MAX
    (genFuncType *) syst_f32_to_i64_r_max,
#else
    0,
#endif
#ifdef SYST_F32_TO_I64_R_NEAR_MAXMAG
    (genFuncType *) syst_f32_to_i64_r_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI32_RX_NEAR_EVEN
    (genFuncType *) syst_f32_to_ui32_rx_near_even,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI32_RX_MINMAG
    (genFuncType *) syst_f32_to_ui32_rx_minMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI32_RX_MIN
    (genFuncType *) syst_f32_to_ui32_rx_min,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI32_RX_MAX
    (genFuncType *) syst_f32_to_ui32_rx_max,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI32_RX_NEAR_MAXMAG
    (genFuncType *) syst_f32_to_ui32_rx_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI64_RX_NEAR_EVEN
    (genFuncType *) syst_f32_to_ui64_rx_near_even,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI64_RX_MINMAG
    (genFuncType *) syst_f32_to_ui64_rx_minMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI64_RX_MIN
    (genFuncType *) syst_f32_to_ui64_rx_min,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI64_RX_MAX
    (genFuncType *) syst_f32_to_ui64_rx_max,
#else
    0,
#endif
#ifdef SYST_F32_TO_UI64_RX_NEAR_MAXMAG
    (genFuncType *) syst_f32_to_ui64_rx_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_I32_RX_NEAR_EVEN
    (genFuncType *) syst_f32_to_i32_rx_near_even,
#else
    0,
#endif
#ifdef SYST_F32_TO_I32_RX_MINMAG
    (genFuncType *) syst_f32_to_i32_rx_minMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_I32_RX_MIN
    (genFuncType *) syst_f32_to_i32_rx_min,
#else
    0,
#endif
#ifdef SYST_F32_TO_I32_RX_MAX
    (genFuncType *) syst_f32_to_i32_rx_max,
#else
    0,
#endif
#ifdef SYST_F32_TO_I32_RX_NEAR_MAXMAG
    (genFuncType *) syst_f32_to_i32_rx_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_I64_RX_NEAR_EVEN
    (genFuncType *) syst_f32_to_i64_rx_near_even,
#else
    0,
#endif
#ifdef SYST_F32_TO_I64_RX_MINMAG
    (genFuncType *) syst_f32_to_i64_rx_minMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_I64_RX_MIN
    (genFuncType *) syst_f32_to_i64_rx_min,
#else
    0,
#endif
#ifdef SYST_F32_TO_I64_RX_MAX
    (genFuncType *) syst_f32_to_i64_rx_max,
#else
    0,
#endif
#ifdef SYST_F32_TO_I64_RX_NEAR_MAXMAG
    (genFuncType *) syst_f32_to_i64_rx_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F32_TO_F64
    (genFuncType *) syst_f32_to_f64,
#else
    0,
#endif
#ifdef SYST_F32_ROUNDTOINT_R_NEAR_EVEN
    (genFuncType *) syst_f32_roundToInt_r_near_even,
#else
    0,
#endif
#ifdef SYST_F32_ROUNDTOINT_R_MINMAG
    (genFuncType *) syst_f32_roundToInt_r_minMag,
#else
    0,
#endif
#ifdef SYST_F32_ROUNDTOINT_R_MIN
    (genFuncType *) syst_f32_roundToInt_r_min,
#else
    0,
#endif
#ifdef SYST_F32_ROUNDTOINT_R_MAX
    (genFuncType *) syst_f32_roundToInt_r_max,
#else
    0,
#endif
#ifdef SYST_F32_ROUNDTOINT_R_NEAR_MAXMAG
    (genFuncType *) syst_f32_roundToInt_r_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F32_ROUNDTOINT_X
    (genFuncType *) syst_f32_roundToInt_x,
#else
    0,
#endif
#ifdef SYST_F32_ADD
    (genFuncType *) syst_f32_add,
#else
    0,
#endif
#ifdef SYST_F32_SUB
    (genFuncType *) syst_f32_sub,
#else
    0,
#endif
#ifdef SYST_F32_MUL
    (genFuncType *) syst_f32_mul,
#else
    0,
#endif
#ifdef SYST_F32_DIV
    (genFuncType *) syst_f32_div,
#else
    0,
#endif
#ifdef SYST_F32_REM
    (genFuncType *) syst_f32_rem,
#else
    0,
#endif
#ifdef SYST_F32_SQRT
    (genFuncType *) syst_f32_sqrt,
#else
    0,
#endif
#ifdef SYST_F32_EQ
    (genFuncType *) syst_f32_eq,
#else
    0,
#endif
#ifdef SYST_F32_LE
    (genFuncType *) syst_f32_le,
#else
    0,
#endif
#ifdef SYST_F32_LT
    (genFuncType *) syst_f32_lt,
#else
    0,
#endif
#ifdef SYST_F32_EQ_SIGNALING
    (genFuncType *) syst_f32_eq_signaling,
#else
    0,
#endif
#ifdef SYST_F32_LE_QUIET
    (genFuncType *) syst_f32_le_quiet,
#else
    0,
#endif
#ifdef SYST_F32_LT_QUIET
    (genFuncType *) syst_f32_lt_quiet,
#else
    0,
#endif
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
#ifdef SYST_F64_TO_UI32_R_NEAR_EVEN
    (genFuncType *) syst_f64_to_ui32_r_near_even,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI32_R_MINMAG
    (genFuncType *) syst_f64_to_ui32_r_minMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI32_R_MIN
    (genFuncType *) syst_f64_to_ui32_r_min,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI32_R_MAX
    (genFuncType *) syst_f64_to_ui32_r_max,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI32_R_NEAR_MAXMAG
    (genFuncType *) syst_f64_to_ui32_r_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI64_R_NEAR_EVEN
    (genFuncType *) syst_f64_to_ui64_r_near_even,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI64_R_MINMAG
    (genFuncType *) syst_f64_to_ui64_r_minMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI64_R_MIN
    (genFuncType *) syst_f64_to_ui64_r_min,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI64_R_MAX
    (genFuncType *) syst_f64_to_ui64_r_max,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI64_R_NEAR_MAXMAG
    (genFuncType *) syst_f64_to_ui64_r_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_I32_R_NEAR_EVEN
    (genFuncType *) syst_f64_to_i32_r_near_even,
#else
    0,
#endif
#ifdef SYST_F64_TO_I32_R_MINMAG
    (genFuncType *) syst_f64_to_i32_r_minMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_I32_R_MIN
    (genFuncType *) syst_f64_to_i32_r_min,
#else
    0,
#endif
#ifdef SYST_F64_TO_I32_R_MAX
    (genFuncType *) syst_f64_to_i32_r_max,
#else
    0,
#endif
#ifdef SYST_F64_TO_I32_R_NEAR_MAXMAG
    (genFuncType *) syst_f64_to_i32_r_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_I64_R_NEAR_EVEN
    (genFuncType *) syst_f64_to_i64_r_near_even,
#else
    0,
#endif
#ifdef SYST_F64_TO_I64_R_MINMAG
    (genFuncType *) syst_f64_to_i64_r_minMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_I64_R_MIN
    (genFuncType *) syst_f64_to_i64_r_min,
#else
    0,
#endif
#ifdef SYST_F64_TO_I64_R_MAX
    (genFuncType *) syst_f64_to_i64_r_max,
#else
    0,
#endif
#ifdef SYST_F64_TO_I64_R_NEAR_MAXMAG
    (genFuncType *) syst_f64_to_i64_r_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI32_RX_NEAR_EVEN
    (genFuncType *) syst_f64_to_ui32_rx_near_even,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI32_RX_MINMAG
    (genFuncType *) syst_f64_to_ui32_rx_minMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI32_RX_MIN
    (genFuncType *) syst_f64_to_ui32_rx_min,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI32_RX_MAX
    (genFuncType *) syst_f64_to_ui32_rx_max,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI32_RX_NEAR_MAXMAG
    (genFuncType *) syst_f64_to_ui32_rx_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI64_RX_NEAR_EVEN
    (genFuncType *) syst_f64_to_ui64_rx_near_even,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI64_RX_MINMAG
    (genFuncType *) syst_f64_to_ui64_rx_minMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI64_RX_MIN
    (genFuncType *) syst_f64_to_ui64_rx_min,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI64_RX_MAX
    (genFuncType *) syst_f64_to_ui64_rx_max,
#else
    0,
#endif
#ifdef SYST_F64_TO_UI64_RX_NEAR_MAXMAG
    (genFuncType *) syst_f64_to_ui64_rx_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_I32_RX_NEAR_EVEN
    (genFuncType *) syst_f64_to_i32_rx_near_even,
#else
    0,
#endif
#ifdef SYST_F64_TO_I32_RX_MINMAG
    (genFuncType *) syst_f64_to_i32_rx_minMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_I32_RX_MIN
    (genFuncType *) syst_f64_to_i32_rx_min,
#else
    0,
#endif
#ifdef SYST_F64_TO_I32_RX_MAX
    (genFuncType *) syst_f64_to_i32_rx_max,
#else
    0,
#endif
#ifdef SYST_F64_TO_I32_RX_NEAR_MAXMAG
    (genFuncType *) syst_f64_to_i32_rx_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_I64_RX_NEAR_EVEN
    (genFuncType *) syst_f64_to_i64_rx_near_even,
#else
    0,
#endif
#ifdef SYST_F64_TO_I64_RX_MINMAG
    (genFuncType *) syst_f64_to_i64_rx_minMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_I64_RX_MIN
    (genFuncType *) syst_f64_to_i64_rx_min,
#else
    0,
#endif
#ifdef SYST_F64_TO_I64_RX_MAX
    (genFuncType *) syst_f64_to_i64_rx_max,
#else
    0,
#endif
#ifdef SYST_F64_TO_I64_RX_NEAR_MAXMAG
    (genFuncType *) syst_f64_to_i64_rx_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F64_TO_F32
    (genFuncType *) syst_f64_to_f32,
#else
    0,
#endif
#ifdef SYST_F64_ROUNDTOINT_R_NEAR_EVEN
    (genFuncType *) syst_f64_roundToInt_r_near_even,
#else
    0,
#endif
#ifdef SYST_F64_ROUNDTOINT_R_MINMAG
    (genFuncType *) syst_f64_roundToInt_r_minMag,
#else
    0,
#endif
#ifdef SYST_F64_ROUNDTOINT_R_MIN
    (genFuncType *) syst_f64_roundToInt_r_min,
#else
    0,
#endif
#ifdef SYST_F64_ROUNDTOINT_R_MAX
    (genFuncType *) syst_f64_roundToInt_r_max,
#else
    0,
#endif
#ifdef SYST_F64_ROUNDTOINT_R_NEAR_MAXMAG
    (genFuncType *) syst_f64_roundToInt_r_near_maxMag,
#else
    0,
#endif
#ifdef SYST_F64_ROUNDTOINT_X
    (genFuncType *) syst_f64_roundToInt_x,
#else
    0,
#endif
#ifdef SYST_F64_ADD
    (genFuncType *) syst_f64_add,
#else
    0,
#endif
#ifdef SYST_F64_SUB
    (genFuncType *) syst_f64_sub,
#else
    0,
#endif
#ifdef SYST_F64_MUL
    (genFuncType *) syst_f64_mul,
#else
    0,
#endif
#ifdef SYST_F64_DIV
    (genFuncType *) syst_f64_div,
#else
    0,
#endif
#ifdef SYST_F64_REM
    (genFuncType *) syst_f64_rem,
#else
    0,
#endif
#ifdef SYST_F64_SQRT
    (genFuncType *) syst_f64_sqrt,
#else
    0,
#endif
#ifdef SYST_F64_EQ
    (genFuncType *) syst_f64_eq,
#else
    0,
#endif
#ifdef SYST_F64_LE
    (genFuncType *) syst_f64_le,
#else
    0,
#endif
#ifdef SYST_F64_LT
    (genFuncType *) syst_f64_lt,
#else
    0,
#endif
#ifdef SYST_F64_EQ_SIGNALING
    (genFuncType *) syst_f64_eq_signaling,
#else
    0,
#endif
#ifdef SYST_F64_LE_QUIET
    (genFuncType *) syst_f64_le_quiet,
#else
    0,
#endif
#ifdef SYST_F64_LT_QUIET
    (genFuncType *) syst_f64_lt_quiet,
#else
    0,
#endif
};

