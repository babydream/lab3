
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
#include "functions.h"

#define RNEVEN ROUND_NEAREST_EVEN
#define RMINM  ROUND_MINMAG
#define RMIN   ROUND_MIN
#define RMAX   ROUND_MAX
#define RNMAXM ROUND_NEAREST_MAXMAG

const struct standardFunctionInfo standardFunctionInfos[] = {
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    { "ui32_to_f32", UI32_TO_F32, 0, 0 },
    { "ui32_to_f64", UI32_TO_F64, 0, 0 },
    { "ui64_to_f32", UI64_TO_F32, 0, 0 },
    { "ui64_to_f64", UI64_TO_F64, 0, 0 },
    { "i32_to_f32",  I32_TO_F32,  0, 0 },
    { "i32_to_f64",  I32_TO_F64,  0, 0 },
    { "i64_to_f32",  I64_TO_F32,  0, 0 },
    { "i64_to_f64",  I64_TO_F64,  0, 0 },
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    { "f32_to_ui32_r_near_even",      F32_TO_UI32,      RNEVEN, false },
    { "f32_to_ui32_r_minMag",         F32_TO_UI32,      RMINM,  false },
    { "f32_to_ui32_r_min",            F32_TO_UI32,      RMIN,   false },
    { "f32_to_ui32_r_max",            F32_TO_UI32,      RMAX,   false },
    { "f32_to_ui32_r_near_maxMag",    F32_TO_UI32,      RNMAXM, false },
    { "f32_to_ui64_r_near_even",      F32_TO_UI64,      RNEVEN, false },
    { "f32_to_ui64_r_minMag",         F32_TO_UI64,      RMINM,  false },
    { "f32_to_ui64_r_min",            F32_TO_UI64,      RMIN,   false },
    { "f32_to_ui64_r_max",            F32_TO_UI64,      RMAX,   false },
    { "f32_to_ui64_r_near_maxMag",    F32_TO_UI64,      RNMAXM, false },
    { "f32_to_i32_r_near_even",       F32_TO_I32,       RNEVEN, false },
    { "f32_to_i32_r_minMag",          F32_TO_I32,       RMINM,  false },
    { "f32_to_i32_r_min",             F32_TO_I32,       RMIN,   false },
    { "f32_to_i32_r_max",             F32_TO_I32,       RMAX,   false },
    { "f32_to_i32_r_near_maxMag",     F32_TO_I32,       RNMAXM, false },
    { "f32_to_i64_r_near_even",       F32_TO_I64,       RNEVEN, false },
    { "f32_to_i64_r_minMag",          F32_TO_I64,       RMINM,  false },
    { "f32_to_i64_r_min",             F32_TO_I64,       RMIN,   false },
    { "f32_to_i64_r_max",             F32_TO_I64,       RMAX,   false },
    { "f32_to_i64_r_near_maxMag",     F32_TO_I64,       RNMAXM, false },
    { "f32_to_ui32_rx_near_even",     F32_TO_UI32,      RNEVEN, true  },
    { "f32_to_ui32_rx_minMag",        F32_TO_UI32,      RMINM,  true  },
    { "f32_to_ui32_rx_min",           F32_TO_UI32,      RMIN,   true  },
    { "f32_to_ui32_rx_max",           F32_TO_UI32,      RMAX,   true  },
    { "f32_to_ui32_rx_near_maxMag",   F32_TO_UI32,      RNMAXM, true  },
    { "f32_to_ui64_rx_near_even",     F32_TO_UI64,      RNEVEN, true  },
    { "f32_to_ui64_rx_minMag",        F32_TO_UI64,      RMINM,  true  },
    { "f32_to_ui64_rx_min",           F32_TO_UI64,      RMIN,   true  },
    { "f32_to_ui64_rx_max",           F32_TO_UI64,      RMAX,   true  },
    { "f32_to_ui64_rx_near_maxMag",   F32_TO_UI64,      RNMAXM, true  },
    { "f32_to_i32_rx_near_even",      F32_TO_I32,       RNEVEN, true  },
    { "f32_to_i32_rx_minMag",         F32_TO_I32,       RMINM,  true  },
    { "f32_to_i32_rx_min",            F32_TO_I32,       RMIN,   true  },
    { "f32_to_i32_rx_max",            F32_TO_I32,       RMAX,   true  },
    { "f32_to_i32_rx_near_maxMag",    F32_TO_I32,       RNMAXM, true  },
    { "f32_to_i64_rx_near_even",      F32_TO_I64,       RNEVEN, true  },
    { "f32_to_i64_rx_minMag",         F32_TO_I64,       RMINM,  true  },
    { "f32_to_i64_rx_min",            F32_TO_I64,       RMIN,   true  },
    { "f32_to_i64_rx_max",            F32_TO_I64,       RMAX,   true  },
    { "f32_to_i64_rx_near_maxMag",    F32_TO_I64,       RNMAXM, true  },
    { "f32_to_f64",                   F32_TO_F64,       0,      0     },
    { "f32_roundToInt_r_near_even",   F32_ROUNDTOINT,   RNEVEN, false },
    { "f32_roundToInt_r_minMag",      F32_ROUNDTOINT,   RMINM,  false },
    { "f32_roundToInt_r_min",         F32_ROUNDTOINT,   RMIN,   false },
    { "f32_roundToInt_r_max",         F32_ROUNDTOINT,   RMAX,   false },
    { "f32_roundToInt_r_near_maxMag", F32_ROUNDTOINT,   RNMAXM, false },
    { "f32_roundToInt_x",             F32_ROUNDTOINT,   0,      true  },
    { "f32_add",                      F32_ADD,          0,      0     },
    { "f32_sub",                      F32_SUB,          0,      0     },
    { "f32_mul",                      F32_MUL,          0,      0     },
    { "f32_mulAdd",                   F32_MULADD,       0,      0     },
    { "f32_div",                      F32_DIV,          0,      0     },
    { "f32_rem",                      F32_REM,          0,      0     },
    { "f32_sqrt",                     F32_SQRT,         0,      0     },
    { "f32_eq",                       F32_EQ,           0,      0     },
    { "f32_le",                       F32_LE,           0,      0     },
    { "f32_lt",                       F32_LT,           0,      0     },
    { "f32_eq_signaling",             F32_EQ_SIGNALING, 0,      0     },
    { "f32_le_quiet",                 F32_LE_QUIET,     0,      0     },
    { "f32_lt_quiet",                 F32_LT_QUIET,     0,      0     },
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    { "f64_to_ui32_r_near_even",      F64_TO_UI32,      RNEVEN, false },
    { "f64_to_ui32_r_minMag",         F64_TO_UI32,      RMINM,  false },
    { "f64_to_ui32_r_min",            F64_TO_UI32,      RMIN,   false },
    { "f64_to_ui32_r_max",            F64_TO_UI32,      RMAX,   false },
    { "f64_to_ui32_r_near_maxMag",    F64_TO_UI32,      RNMAXM, false },
    { "f64_to_ui64_r_near_even",      F64_TO_UI64,      RNEVEN, false },
    { "f64_to_ui64_r_minMag",         F64_TO_UI64,      RMINM,  false },
    { "f64_to_ui64_r_min",            F64_TO_UI64,      RMIN,   false },
    { "f64_to_ui64_r_max",            F64_TO_UI64,      RMAX,   false },
    { "f64_to_ui64_r_near_maxMag",    F64_TO_UI64,      RNMAXM, false },
    { "f64_to_i32_r_near_even",       F64_TO_I32,       RNEVEN, false },
    { "f64_to_i32_r_minMag",          F64_TO_I32,       RMINM,  false },
    { "f64_to_i32_r_min",             F64_TO_I32,       RMIN,   false },
    { "f64_to_i32_r_max",             F64_TO_I32,       RMAX,   false },
    { "f64_to_i32_r_near_maxMag",     F64_TO_I32,       RNMAXM, false },
    { "f64_to_i64_r_near_even",       F64_TO_I64,       RNEVEN, false },
    { "f64_to_i64_r_minMag",          F64_TO_I64,       RMINM,  false },
    { "f64_to_i64_r_min",             F64_TO_I64,       RMIN,   false },
    { "f64_to_i64_r_max",             F64_TO_I64,       RMAX,   false },
    { "f64_to_i64_r_near_maxMag",     F64_TO_I64,       RNMAXM, false },
    { "f64_to_ui32_rx_near_even",     F64_TO_UI32,      RNEVEN, true  },
    { "f64_to_ui32_rx_minMag",        F64_TO_UI32,      RMINM,  true  },
    { "f64_to_ui32_rx_min",           F64_TO_UI32,      RMIN,   true  },
    { "f64_to_ui32_rx_max",           F64_TO_UI32,      RMAX,   true  },
    { "f64_to_ui32_rx_near_maxMag",   F64_TO_UI32,      RNMAXM, true  },
    { "f64_to_ui64_rx_near_even",     F64_TO_UI64,      RNEVEN, true  },
    { "f64_to_ui64_rx_minMag",        F64_TO_UI64,      RMINM,  true  },
    { "f64_to_ui64_rx_min",           F64_TO_UI64,      RMIN,   true  },
    { "f64_to_ui64_rx_max",           F64_TO_UI64,      RMAX,   true  },
    { "f64_to_ui64_rx_near_maxMag",   F64_TO_UI64,      RNMAXM, true  },
    { "f64_to_i32_rx_near_even",      F64_TO_I32,       RNEVEN, true  },
    { "f64_to_i32_rx_minMag",         F64_TO_I32,       RMINM,  true  },
    { "f64_to_i32_rx_min",            F64_TO_I32,       RMIN,   true  },
    { "f64_to_i32_rx_max",            F64_TO_I32,       RMAX,   true  },
    { "f64_to_i32_rx_near_maxMag",    F64_TO_I32,       RNMAXM, true  },
    { "f64_to_i64_rx_near_even",      F64_TO_I64,       RNEVEN, true  },
    { "f64_to_i64_rx_minMag",         F64_TO_I64,       RMINM,  true  },
    { "f64_to_i64_rx_min",            F64_TO_I64,       RMIN,   true  },
    { "f64_to_i64_rx_max",            F64_TO_I64,       RMAX,   true  },
    { "f64_to_i64_rx_near_maxMag",    F64_TO_I64,       RNMAXM, true  },
    { "f64_to_f32",                   F64_TO_F32,       0,      0     },
    { "f64_roundToInt_r_near_even",   F64_ROUNDTOINT,   RNEVEN, false },
    { "f64_roundToInt_r_minMag",      F64_ROUNDTOINT,   RMINM,  false },
    { "f64_roundToInt_r_min",         F64_ROUNDTOINT,   RMIN,   false },
    { "f64_roundToInt_r_max",         F64_ROUNDTOINT,   RMAX,   false },
    { "f64_roundToInt_r_near_maxMag", F64_ROUNDTOINT,   RNMAXM, false },
    { "f64_roundToInt_x",             F64_ROUNDTOINT,   0,      true  },
    { "f64_add",                      F64_ADD,          0,      0     },
    { "f64_sub",                      F64_SUB,          0,      0     },
    { "f64_mul",                      F64_MUL,          0,      0     },
    { "f64_mulAdd",                   F64_MULADD,       0,      0     },
    { "f64_div",                      F64_DIV,          0,      0     },
    { "f64_rem",                      F64_REM,          0,      0     },
    { "f64_sqrt",                     F64_SQRT,         0,      0     },
    { "f64_eq",                       F64_EQ,           0,      0     },
    { "f64_le",                       F64_LE,           0,      0     },
    { "f64_lt",                       F64_LT,           0,      0     },
    { "f64_eq_signaling",             F64_EQ_SIGNALING, 0,      0     },
    { "f64_le_quiet",                 F64_LE_QUIET,     0,      0     },
    { "f64_lt_quiet",                 F64_LT_QUIET,     0,      0     },
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    { 0, 0, 0, 0 }
};

