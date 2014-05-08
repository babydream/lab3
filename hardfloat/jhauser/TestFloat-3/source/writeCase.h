
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
#include "softfloat.h"

extern const char *writeCase_trueNamePtr, *writeCase_testNamePtr;

void writeCase_a_ui32( uint_fast32_t, const char * );
void writeCase_a_ui64( uint_fast64_t, const char * );
#define writeCase_a_i32 writeCase_a_ui32
#define writeCase_a_i64 writeCase_a_ui64
void writeCase_a_f32( float32_t, const char * );
void writeCase_ab_f32( float32_t, float32_t, const char * );
void writeCase_abc_f32( float32_t, float32_t, float32_t, const char * );
void writeCase_a_f64( float64_t, const char * );
void writeCase_ab_f64( float64_t, float64_t, const char * );
void writeCase_abc_f64( float64_t, float64_t, float64_t, const char * );
#ifdef FLOATX80
void writeCase_a_fx80( floatx80_t, const char * );
void writeCase_ab_fx80( floatx80_t, floatx80_t, const char * );
void writeCase_abc_fx80( floatx80_t, floatx80_t, floatx80_t, const char * );
#endif
#ifdef FLOAT128
void writeCase_a_f128( float128_t, const char * );
void writeCase_ab_f128( float128_t, float128_t, const char * );
void writeCase_abc_f128( float128_t, float128_t, float128_t, const char * );
#endif

void writeCase_z_bool( bool, int_fast8_t, bool, int_fast8_t );
void
 writeCase_z_ui32( uint_fast32_t, int_fast8_t, uint_fast32_t, int_fast8_t );
void
 writeCase_z_ui64( uint_fast64_t, int_fast8_t, uint_fast64_t, int_fast8_t );
#define writeCase_z_i32 writeCase_z_ui32
#define writeCase_z_i64 writeCase_z_ui64
void writeCase_z_f32( float32_t, int_fast8_t, float32_t, int_fast8_t );
void writeCase_z_f64( float64_t, int_fast8_t, float64_t, int_fast8_t );
#ifdef FLOATX80
void writeCase_z_fx80( floatx80_t, int_fast8_t, floatx80_t, int_fast8_t );
#endif
#ifdef FLOAT128
void writeCase_z_f128( float128_t, int_fast8_t, float128_t, int_fast8_t );
#endif

