
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

#include <stdbool.h>
#include <stdint.h>
#include "softfloat.h"

extern int_fast8_t slowfloat_roundingMode;
extern int_fast8_t slowfloat_detectTininess;
extern int_fast8_t slowfloat_exceptionFlags;
#ifdef FLOATX80
extern int8 slow_floatx80_roundingPrecision;
#endif

float32_t slow_ui32_to_f32( uint_fast32_t );
float64_t slow_ui32_to_f64( uint_fast32_t );
#ifdef FLOATX80
floatx80_t slow_ui32_to_fx80( uint_fast32_t );
#endif
#ifdef FLOAT128
float128_t slow_ui32_to_f128( uint_fast32_t );
#endif
float32_t slow_ui64_to_f32( uint_fast64_t );
float64_t slow_ui64_to_f64( uint_fast64_t );
#ifdef FLOATX80
floatx80_t slow_ui64_to_fx80( uint_fast64_t );
#endif
#ifdef FLOAT128
float128_t slow_ui64_to_f128( uint_fast64_t );
#endif
float32_t slow_i32_to_f32( int_fast32_t );
float64_t slow_i32_to_f64( int_fast32_t );
#ifdef FLOATX80
floatx80_t slow_i32_to_fx80( int_fast32_t );
#endif
#ifdef FLOAT128
float128_t slow_i32_to_f128( int_fast32_t );
#endif
float32_t slow_i64_to_f32( int_fast64_t );
float64_t slow_i64_to_f64( int_fast64_t );
#ifdef FLOATX80
floatx80_t slow_i64_to_fx80( int_fast64_t );
#endif
#ifdef FLOAT128
float128_t slow_i64_to_f128( int_fast64_t );
#endif

uint_fast32_t slow_f32_to_ui32( float32_t, int_fast8_t, bool );
uint_fast64_t slow_f32_to_ui64( float32_t, int_fast8_t, bool );
int_fast32_t slow_f32_to_i32( float32_t, int_fast8_t, bool );
int_fast64_t slow_f32_to_i64( float32_t, int_fast8_t, bool );
uint_fast32_t slow_f32_to_ui32_r_minMag( float32_t, bool );
uint_fast64_t slow_f32_to_ui64_r_minMag( float32_t, bool );
int_fast32_t slow_f32_to_i32_r_minMag( float32_t, bool );
int_fast64_t slow_f32_to_i64_r_minMag( float32_t, bool );
float64_t slow_f32_to_f64( float32_t );
#ifdef FLOATX80
floatx80_t slow_f32_to_fx80( float32_t );
#endif
#ifdef FLOAT128
float128_t slow_f32_to_f128( float32_t );
#endif
float32_t slow_f32_roundToInt( float32_t, int_fast8_t, bool );
float32_t slow_f32_add( float32_t, float32_t );
float32_t slow_f32_sub( float32_t, float32_t );
float32_t slow_f32_mul( float32_t, float32_t );
float32_t slow_f32_mulAdd( float32_t, float32_t, float32_t );
float32_t slow_f32_div( float32_t, float32_t );
float32_t slow_f32_rem( float32_t, float32_t );
float32_t slow_f32_sqrt( float32_t );
bool slow_f32_eq( float32_t, float32_t );
bool slow_f32_le( float32_t, float32_t );
bool slow_f32_lt( float32_t, float32_t );
bool slow_f32_eq_signaling( float32_t, float32_t );
bool slow_f32_le_quiet( float32_t, float32_t );
bool slow_f32_lt_quiet( float32_t, float32_t );

uint_fast32_t slow_f64_to_ui32( float64_t, int_fast8_t, bool );
uint_fast64_t slow_f64_to_ui64( float64_t, int_fast8_t, bool );
int_fast32_t slow_f64_to_i32( float64_t, int_fast8_t, bool );
int_fast64_t slow_f64_to_i64( float64_t, int_fast8_t, bool );
uint_fast32_t slow_f64_to_ui32_r_minMag( float64_t, bool );
uint_fast64_t slow_f64_to_ui64_r_minMag( float64_t, bool );
int_fast32_t slow_f64_to_i32_r_minMag( float64_t, bool );
int_fast64_t slow_f64_to_i64_r_minMag( float64_t, bool );
float32_t slow_f64_to_f32( float64_t );
#ifdef FLOATX80
floatx80_t slow_f64_to_fx80( float64_t );
#endif
#ifdef FLOAT128
float128_t slow_f64_to_f128( float64_t );
#endif
float64_t slow_f64_roundToInt( float64_t, int_fast8_t, bool );
float64_t slow_f64_add( float64_t, float64_t );
float64_t slow_f64_sub( float64_t, float64_t );
float64_t slow_f64_mul( float64_t, float64_t );
float64_t slow_f64_mulAdd( float64_t, float64_t, float64_t );
float64_t slow_f64_div( float64_t, float64_t );
float64_t slow_f64_rem( float64_t, float64_t );
float64_t slow_f64_sqrt( float64_t );
bool slow_f64_eq( float64_t, float64_t );
bool slow_f64_le( float64_t, float64_t );
bool slow_f64_lt( float64_t, float64_t );
bool slow_f64_eq_signaling( float64_t, float64_t );
bool slow_f64_le_quiet( float64_t, float64_t );
bool slow_f64_lt_quiet( float64_t, float64_t );

#ifdef FLOATX80
uint_fast32_t slow_fx80_to_ui32( floatx80_t, int_fast8_t, bool );
uint_fast64_t slow_fx80_to_ui64( floatx80_t, int_fast8_t, bool );
int_fast32_t slow_fx80_to_i32( floatx80_t, int_fast8_t, bool );
int_fast64_t slow_fx80_to_i64( floatx80_t, int_fast8_t, bool );
uint_fast32_t slow_fx80_to_ui32_r_minMag( floatx80_t, bool );
uint_fast64_t slow_fx80_to_ui64_r_minMag( floatx80_t, bool );
int_fast32_t slow_fx80_to_i32_r_minMag( floatx80_t, bool );
int_fast64_t slow_fx80_to_i64_r_minMag( floatx80_t, bool );
float32_t slow_fx80_to_f32( floatx80_t );
float64_t slow_fx80_to_f64( floatx80_t );
#ifdef FLOAT128
float128_t slow_fx80_to_f128( floatx80_t );
#endif
floatx80_t slow_fx80_roundToInt( floatx80_t, int_fast8_t, bool );
floatx80_t slow_fx80_add( floatx80_t, floatx80_t );
floatx80_t slow_fx80_sub( floatx80_t, floatx80_t );
floatx80_t slow_fx80_mul( floatx80_t, floatx80_t );
floatx80_t slow_fx80_mulAdd( floatx80_t, floatx80_t, floatx80_t );
floatx80_t slow_fx80_div( floatx80_t, floatx80_t );
floatx80_t slow_fx80_rem( floatx80_t, floatx80_t );
floatx80_t slow_fx80_sqrt( floatx80_t );
bool slow_fx80_eq( floatx80_t, floatx80_t );
bool slow_fx80_le( floatx80_t, floatx80_t );
bool slow_fx80_lt( floatx80_t, floatx80_t );
bool slow_fx80_eq_signaling( floatx80_t, floatx80_t );
bool slow_fx80_le_quiet( floatx80_t, floatx80_t );
bool slow_fx80_lt_quiet( floatx80_t, floatx80_t );
#endif

#ifdef FLOAT128
uint_fast32_t slow_f128_to_ui32( float128_t, int_fast8_t, bool );
uint_fast64_t slow_f128_to_ui64( float128_t, int_fast8_t, bool );
int_fast32_t slow_f128_to_i32( float128_t, int_fast8_t, bool );
int_fast64_t slow_f128_to_i64( float128_t, int_fast8_t, bool );
uint_fast32_t slow_f128_to_ui32_r_minMag( float128_t, bool );
uint_fast64_t slow_f128_to_ui64_r_minMag( float128_t, bool );
int_fast32_t slow_f128_to_i32_r_minMag( float128_t, bool );
int_fast64_t slow_f128_to_i64_r_minMag( float128_t, bool );
float32_t slow_f128_to_f32( float128_t );
float64_t slow_f128_to_f64( float128_t );
#ifdef FLOATX80
floatx80_t slow_f128_to_fx80( float128_t );
#endif
float128_t slow_f128_roundToInt( float128_t, int_fast8_t, bool );
float128_t slow_f128_add( float128_t, float128_t );
float128_t slow_f128_sub( float128_t, float128_t );
float128_t slow_f128_mul( float128_t, float128_t );
float128_t slow_f128_mulAdd( float128_t, float128_t, float128_t );
float128_t slow_f128_div( float128_t, float128_t );
float128_t slow_f128_rem( float128_t, float128_t );
float128_t slow_f128_sqrt( float128_t );
bool slow_f128_eq( float128_t, float128_t );
bool slow_f128_le( float128_t, float128_t );
bool slow_f128_lt( float128_t, float128_t );
bool slow_f128_eq_signaling( float128_t, float128_t );
bool slow_f128_le_quiet( float128_t, float128_t );
bool slow_f128_lt_quiet( float128_t, float128_t );
#endif

