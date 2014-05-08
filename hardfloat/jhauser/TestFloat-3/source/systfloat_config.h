
/*
===============================================================================

This C header file is part of TestFloat, Release 2a, a package of programs
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

/*
-------------------------------------------------------------------------------
The following macros are defined to indicate that the corresponding
functions exist.
-------------------------------------------------------------------------------
*/

#define SYST_UI32_TO_F32
#define SYST_UI32_TO_F64
#define SYST_UI64_TO_F32
#define SYST_UI64_TO_F64
#define SYST_I32_TO_F32
#define SYST_I32_TO_F64
#define SYST_I64_TO_F32
#define SYST_I64_TO_F64

#define SYST_F32_TO_UI32_RX_MINMAG
#define SYST_F32_TO_UI64_RX_MINMAG
#define SYST_F32_TO_I32_RX_MINMAG
#define SYST_F32_TO_I64_RX_MINMAG
#define SYST_F32_TO_F64
#define SYST_F32_ADD
#define SYST_F32_SUB
#define SYST_F32_MUL
#define SYST_F32_DIV
#define SYST_F32_EQ
#define SYST_F32_LE
#define SYST_F32_LT

#define SYST_F64_TO_UI32_RX_MINMAG
#define SYST_F64_TO_UI64_RX_MINMAG
#define SYST_F64_TO_I32_RX_MINMAG
#define SYST_F64_TO_I64_RX_MINMAG
#define SYST_F64_TO_F32
#define SYST_F64_ADD
#define SYST_F64_SUB
#define SYST_F64_MUL
#define SYST_F64_DIV
#define SYST_F64_SQRT
#define SYST_F64_EQ
#define SYST_F64_LE
#define SYST_F64_LT

#if defined FLOATX80 && defined LONG_DOUBLE_IS_FLOATX80

#define SYST_UI32_TO_FX80
#define SYST_UI64_TO_FX80
#define SYST_I32_TO_FX80
#define SYST_I64_TO_FX80

#define SYST_F32_TO_FX80
#define SYST_F64_TO_FX80

#define SYST_FX80_TO_UI32_ROUND_MINMAG
#define SYST_FX80_TO_UI64_ROUND_MINMAG
#define SYST_FX80_TO_I32_ROUND_MINMAG
#define SYST_FX80_TO_I64_ROUND_MINMAG
#define SYST_FX80_TO_F32
#define SYST_FX80_TO_F64
#define SYST_FX80_EQ
#define SYST_FX80_LE
#define SYST_FX80_LT
#define SYST_FX80_ADD
#define SYST_FX80_SUB
#define SYST_FX80_MUL
#define SYST_FX80_DIV

#endif

#if defined FLOAT128 && defined LONG_DOUBLE_IS_FLOAT128

#define SYST_UI32_TO_F128
#define SYST_UI64_TO_F128
#define SYST_I32_TO_F128
#define SYST_I64_TO_F128

#define SYST_F32_TO_F128
#define SYST_F64_TO_F128

#define SYST_F128_TO_UI32_ROUND_MINMAG
#define SYST_F128_TO_UI64_ROUND_MINMAG
#define SYST_F128_TO_I32_ROUND_MINMAG
#define SYST_F128_TO_I64_ROUND_MINMAG
#define SYST_F128_TO_F32
#define SYST_F128_TO_F64
#define SYST_F128_EQ
#define SYST_F128_LE
#define SYST_F128_LT
#define SYST_F128_ADD
#define SYST_F128_SUB
#define SYST_F128_MUL
#define SYST_F128_DIV

#endif

