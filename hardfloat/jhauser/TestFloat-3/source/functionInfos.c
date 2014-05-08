
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

#define ARG_1      FUNC_ARG_UNARY
#define ARG_2      FUNC_ARG_BINARY
#define ARG_R      FUNC_ARG_ROUNDINGMODE
#define ARG_E      FUNC_ARG_EXACT
#define EFF_P      FUNC_EFF_ROUNDINGPRECISION
#define EFF_R      FUNC_EFF_ROUNDINGMODE
#define EFF_T      FUNC_EFF_TININESSMODE
#define EFF_T_REDP FUNC_EFF_TININESSMODE_REDUCEDPREC

const struct functionInfo functionInfos[ NUM_FUNCTIONS ] = {
    { 0, 0 },
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    { "ui32_to_f32",  ARG_1 | EFF_R },
    { "ui32_to_f64",  ARG_1         },
#ifdef FLOATX80
    { "ui32_to_fx80", ARG_1         },
#endif
#ifdef FLOAT128
    { "ui32_to_f128", ARG_1         },
#endif
    { "ui64_to_f32",  ARG_1 | EFF_R },
    { "ui64_to_f64",  ARG_1 | EFF_R },
#ifdef FLOATX80
    { "ui64_to_fx80", ARG_1         },
#endif
#ifdef FLOAT128
    { "ui64_to_f128", ARG_1         },
#endif
    { "i32_to_f32",   ARG_1 | EFF_R },
    { "i32_to_f64",   ARG_1         },
#ifdef FLOATX80
    { "i32_to_fx80",  ARG_1         },
#endif
#ifdef FLOAT128
    { "i32_to_f128",  ARG_1         },
#endif
    { "i64_to_f32",   ARG_1 | EFF_R },
    { "i64_to_f64",   ARG_1 | EFF_R },
#ifdef FLOATX80
    { "i64_to_fx80",  ARG_1         },
#endif
#ifdef FLOAT128
    { "i64_to_f128",  ARG_1         },
#endif
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    { "f32_to_ui32", ARG_1 | ARG_R | ARG_E },
    { "f32_to_ui64", ARG_1 | ARG_R | ARG_E },
    { "f32_to_i32",  ARG_1 | ARG_R | ARG_E },
    { "f32_to_i64",  ARG_1 | ARG_R | ARG_E },
    { "f32_to_ui32_r_minMag", ARG_1 | ARG_E },
    { "f32_to_ui64_r_minMag", ARG_1 | ARG_E },
    { "f32_to_i32_r_minMag",  ARG_1 | ARG_E },
    { "f32_to_i64_r_minMag",  ARG_1 | ARG_E },
    { "f32_to_f64",  ARG_1 },
#ifdef FLOATX80
    { "f32_to_fx80", ARG_1 },
#endif
#ifdef FLOAT128
    { "f32_to_f128", ARG_1 },
#endif
    { "f32_roundToInt", ARG_1 | ARG_R | ARG_E },
    { "f32_add",          ARG_2 | EFF_R         },
    { "f32_sub",          ARG_2 | EFF_R         },
    { "f32_mul",          ARG_2 | EFF_R | EFF_T },
    { "f32_mulAdd",               EFF_R | EFF_T },
    { "f32_div",          ARG_2 | EFF_R         },
    { "f32_rem",          ARG_2                 },
    { "f32_sqrt",         ARG_1 | EFF_R         },
    { "f32_eq",           ARG_2                 },
    { "f32_le",           ARG_2                 },
    { "f32_lt",           ARG_2                 },
    { "f32_eq_signaling", ARG_2                 },
    { "f32_le_quiet",     ARG_2                 },
    { "f32_lt_quiet",     ARG_2                 },
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    { "f64_to_ui32", ARG_1 | ARG_R | ARG_E },
    { "f64_to_ui64", ARG_1 | ARG_R | ARG_E },
    { "f64_to_i32",  ARG_1 | ARG_R | ARG_E },
    { "f64_to_i64",  ARG_1 | ARG_R | ARG_E },
    { "f64_to_ui32_r_minMag", ARG_1 | ARG_E },
    { "f64_to_ui64_r_minMag", ARG_1 | ARG_E },
    { "f64_to_i32_r_minMag",  ARG_1 | ARG_E },
    { "f64_to_i64_r_minMag",  ARG_1 | ARG_E },
    { "f64_to_f32",  ARG_1 | EFF_R | EFF_T },
#ifdef FLOATX80
    { "f64_to_fx80", ARG_1 },
#endif
#ifdef FLOAT128
    { "f64_to_f128", ARG_1 },
#endif
    { "f64_roundToInt", ARG_1 | ARG_R | ARG_E },
    { "f64_add",          ARG_2 | EFF_R         },
    { "f64_sub",          ARG_2 | EFF_R         },
    { "f64_mul",          ARG_2 | EFF_R | EFF_T },
    { "f64_mulAdd",               EFF_R | EFF_T },
    { "f64_div",          ARG_2 | EFF_R         },
    { "f64_rem",          ARG_2                 },
    { "f64_sqrt",         ARG_1 | EFF_R         },
    { "f64_eq",           ARG_2                 },
    { "f64_le",           ARG_2                 },
    { "f64_lt",           ARG_2                 },
    { "f64_eq_signaling", ARG_2                 },
    { "f64_le_quiet",     ARG_2                 },
    { "f64_lt_quiet",     ARG_2                 },
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
#ifdef FLOATX80
    { "fx80_to_ui32", ARG_1 | ARG_R | ARG_E },
    { "fx80_to_ui64", ARG_1 | ARG_R | ARG_E },
    { "fx80_to_i32",  ARG_1 | ARG_R | ARG_E },
    { "fx80_to_i64",  ARG_1 | ARG_R | ARG_E },
    { "fx80_to_ui32_r_minMag", ARG_1 | ARG_E },
    { "fx80_to_ui64_r_minMag", ARG_1 | ARG_E },
    { "fx80_to_i32_r_minMag",  ARG_1 | ARG_E },
    { "fx80_to_i64_r_minMag",  ARG_1 | ARG_E },
    { "fx80_to_f32",  ARG_1 | EFF_R | EFF_T },
    { "fx80_to_f64",  ARG_1 | EFF_R | EFF_T },
#ifdef FLOAT128
    { "fx80_to_f128", ARG_1 },
#endif
    { "fx80_roundToInt", ARG_1 | ARG_R | ARG_E },
    { "fx80_add",          ARG_2 | EFF_P | EFF_R         | EFF_T_REDP },
    { "fx80_sub",          ARG_2 | EFF_P | EFF_R         | EFF_T_REDP },
    { "fx80_mul",          ARG_2 | EFF_P | EFF_R | EFF_T | EFF_T_REDP },
    { "fx80_mulAdd",                       EFF_R | EFF_T              },
    { "fx80_div",          ARG_2 | EFF_P | EFF_R         | EFF_T_REDP },
    { "fx80_rem",          ARG_2                                      },
    { "fx80_sqrt",         ARG_1 | EFF_P | EFF_R                      },
    { "fx80_eq",           ARG_2                                      },
    { "fx80_le",           ARG_2                                      },
    { "fx80_lt",           ARG_2                                      },
    { "fx80_eq_signaling", ARG_2                                      },
    { "fx80_le_quiet",     ARG_2                                      },
    { "fx80_lt_quiet",     ARG_2                                      },
#endif
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
#ifdef FLOAT128
    { "f128_to_ui32", ARG_1 | ARG_R | ARG_E },
    { "f128_to_ui64", ARG_1 | ARG_R | ARG_E },
    { "f128_to_i32",  ARG_1 | ARG_R | ARG_E },
    { "f128_to_i64",  ARG_1 | ARG_R | ARG_E },
    { "f128_to_ui32_r_minMag", ARG_1 | ARG_E },
    { "f128_to_ui64_r_minMag", ARG_1 | ARG_E },
    { "f128_to_i32_r_minMag",  ARG_1 | ARG_E },
    { "f128_to_i64_r_minMag",  ARG_1 | ARG_E },
    { "f128_to_f32",  ARG_1 | EFF_R | EFF_T },
    { "f128_to_f64",  ARG_1 | EFF_R | EFF_T },
#ifdef FLOATX80
    { "f128_to_fx80", ARG_1 | EFF_R | EFF_T },
#endif
    { "f128_roundToInt", ARG_1 | ARG_R | ARG_E },
    { "f128_add",          ARG_2 | EFF_R         },
    { "f128_sub",          ARG_2 | EFF_R         },
    { "f128_mul",          ARG_2 | EFF_R | EFF_T },
    { "f128_mulAdd",               EFF_R | EFF_T },
    { "f128_div",          ARG_2 | EFF_R         },
    { "f128_rem",          ARG_2                 },
    { "f128_sqrt",         ARG_1 | EFF_R         },
    { "f128_eq",           ARG_2                 },
    { "f128_le",           ARG_2                 },
    { "f128_lt",           ARG_2                 },
    { "f128_eq_signaling", ARG_2                 },
    { "f128_le_quiet",     ARG_2                 },
    { "f128_lt_quiet",     ARG_2                 },
#endif
};

