
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

extern void ( *const systfloat_functions[] )();

void systfloat_setRoundingMode( int_fast8_t );
void syst_fx80_setRoundingPrecision( int_fast8_t );
int_fast8_t systfloat_clearExceptionFlags( void );

/*----------------------------------------------------------------------------
| System function declarations.  (Many of these functions may not exist.)
*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
float32_t syst_ui32_to_f32( uint_fast32_t );
float64_t syst_ui32_to_f64( uint_fast32_t );
#ifdef FLOATX80
floatx80_t syst_ui32_to_fx80( uint_fast32_t );
#endif
#ifdef FLOAT128
float128_t syst_ui32_to_f128( uint_fast32_t );
#endif
float32_t syst_ui64_to_f32( uint_fast64_t );
float64_t syst_ui64_to_f64( uint_fast64_t );
#ifdef FLOATX80
floatx80_t syst_ui64_to_fx80( uint_fast64_t );
#endif
#ifdef FLOAT128
float128_t syst_ui64_to_f128( uint_fast64_t );
#endif
float32_t syst_i32_to_f32( int_fast32_t );
float64_t syst_i32_to_f64( int_fast32_t );
#ifdef FLOATX80
floatx80_t syst_i32_to_fx80( int_fast32_t );
#endif
#ifdef FLOAT128
float128_t syst_i32_to_f128( int_fast32_t );
#endif
float32_t syst_i64_to_f32( int_fast64_t );
float64_t syst_i64_to_f64( int_fast64_t );
#ifdef FLOATX80
floatx80_t syst_i64_to_fx80( int_fast64_t );
#endif
#ifdef FLOAT128
float128_t syst_i64_to_f128( int_fast64_t );
#endif

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
uint_fast32_t syst_f32_to_ui32_r_near_even( float32_t );
uint_fast32_t syst_f32_to_ui32_r_minMag( float32_t );
uint_fast32_t syst_f32_to_ui32_r_min( float32_t );
uint_fast32_t syst_f32_to_ui32_r_max( float32_t );
uint_fast32_t syst_f32_to_ui32_r_near_maxMag( float32_t );
uint_fast64_t syst_f32_to_ui64_r_near_even( float32_t );
uint_fast64_t syst_f32_to_ui64_r_minMag( float32_t );
uint_fast64_t syst_f32_to_ui64_r_min( float32_t );
uint_fast64_t syst_f32_to_ui64_r_max( float32_t );
uint_fast64_t syst_f32_to_ui64_r_near_maxMag( float32_t );
int_fast32_t syst_f32_to_i32_r_near_even( float32_t );
int_fast32_t syst_f32_to_i32_r_minMag( float32_t );
int_fast32_t syst_f32_to_i32_r_min( float32_t );
int_fast32_t syst_f32_to_i32_r_max( float32_t );
int_fast32_t syst_f32_to_i32_r_near_maxMag( float32_t );
int_fast64_t syst_f32_to_i64_r_near_even( float32_t );
int_fast64_t syst_f32_to_i64_r_minMag( float32_t );
int_fast64_t syst_f32_to_i64_r_min( float32_t );
int_fast64_t syst_f32_to_i64_r_max( float32_t );
int_fast64_t syst_f32_to_i64_r_near_maxMag( float32_t );

uint_fast32_t syst_f32_to_ui32_rx_near_even( float32_t );
uint_fast32_t syst_f32_to_ui32_rx_minMag( float32_t );
uint_fast32_t syst_f32_to_ui32_rx_min( float32_t );
uint_fast32_t syst_f32_to_ui32_rx_max( float32_t );
uint_fast32_t syst_f32_to_ui32_rx_near_maxMag( float32_t );
uint_fast64_t syst_f32_to_ui64_rx_near_even( float32_t );
uint_fast64_t syst_f32_to_ui64_rx_minMag( float32_t );
uint_fast64_t syst_f32_to_ui64_rx_min( float32_t );
uint_fast64_t syst_f32_to_ui64_rx_max( float32_t );
uint_fast64_t syst_f32_to_ui64_rx_near_maxMag( float32_t );
int_fast32_t syst_f32_to_i32_rx_near_even( float32_t );
int_fast32_t syst_f32_to_i32_rx_minMag( float32_t );
int_fast32_t syst_f32_to_i32_rx_min( float32_t );
int_fast32_t syst_f32_to_i32_rx_max( float32_t );
int_fast32_t syst_f32_to_i32_rx_near_maxMag( float32_t );
int_fast64_t syst_f32_to_i64_rx_near_even( float32_t );
int_fast64_t syst_f32_to_i64_rx_minMag( float32_t );
int_fast64_t syst_f32_to_i64_rx_min( float32_t );
int_fast64_t syst_f32_to_i64_rx_max( float32_t );
int_fast64_t syst_f32_to_i64_rx_near_maxMag( float32_t );

float64_t syst_f32_to_f64( float32_t );
#ifdef FLOATX80
floatx80_t syst_f32_to_fx80( float32_t );
#endif
#ifdef FLOAT128
float128_t syst_f32_to_f128( float32_t );
#endif

float32_t syst_f32_roundToInt_r_near_even( float32_t );
float32_t syst_f32_roundToInt_r_minMag( float32_t );
float32_t syst_f32_roundToInt_r_min( float32_t );
float32_t syst_f32_roundToInt_r_max( float32_t );
float32_t syst_f32_roundToInt_r_near_maxMag( float32_t );
float32_t syst_f32_roundToInt_x( float32_t );
float32_t syst_f32_add( float32_t, float32_t );
float32_t syst_f32_sub( float32_t, float32_t );
float32_t syst_f32_mul( float32_t, float32_t );
float32_t syst_f32_div( float32_t, float32_t );
float32_t syst_f32_rem( float32_t, float32_t );
float32_t syst_f32_sqrt( float32_t );
bool syst_f32_eq( float32_t, float32_t );
bool syst_f32_le( float32_t, float32_t );
bool syst_f32_lt( float32_t, float32_t );
bool syst_f32_eq_signaling( float32_t, float32_t );
bool syst_f32_le_quiet( float32_t, float32_t );
bool syst_f32_lt_quiet( float32_t, float32_t );

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
uint_fast32_t syst_f64_to_ui32_r_near_even( float64_t );
uint_fast32_t syst_f64_to_ui32_r_minMag( float64_t );
uint_fast32_t syst_f64_to_ui32_r_min( float64_t );
uint_fast32_t syst_f64_to_ui32_r_max( float64_t );
uint_fast32_t syst_f64_to_ui32_r_near_maxMag( float64_t );
uint_fast64_t syst_f64_to_ui64_r_near_even( float64_t );
uint_fast64_t syst_f64_to_ui64_r_minMag( float64_t );
uint_fast64_t syst_f64_to_ui64_r_min( float64_t );
uint_fast64_t syst_f64_to_ui64_r_max( float64_t );
uint_fast64_t syst_f64_to_ui64_r_near_maxMag( float64_t );
int_fast32_t syst_f64_to_i32_r_near_even( float64_t );
int_fast32_t syst_f64_to_i32_r_minMag( float64_t );
int_fast32_t syst_f64_to_i32_r_min( float64_t );
int_fast32_t syst_f64_to_i32_r_max( float64_t );
int_fast32_t syst_f64_to_i32_r_near_maxMag( float64_t );
int_fast64_t syst_f64_to_i64_r_near_even( float64_t );
int_fast64_t syst_f64_to_i64_r_minMag( float64_t );
int_fast64_t syst_f64_to_i64_r_min( float64_t );
int_fast64_t syst_f64_to_i64_r_max( float64_t );
int_fast64_t syst_f64_to_i64_r_near_maxMag( float64_t );

uint_fast32_t syst_f64_to_ui32_rx_near_even( float64_t );
uint_fast32_t syst_f64_to_ui32_rx_minMag( float64_t );
uint_fast32_t syst_f64_to_ui32_rx_min( float64_t );
uint_fast32_t syst_f64_to_ui32_rx_max( float64_t );
uint_fast32_t syst_f64_to_ui32_rx_near_maxMag( float64_t );
uint_fast64_t syst_f64_to_ui64_rx_near_even( float64_t );
uint_fast64_t syst_f64_to_ui64_rx_minMag( float64_t );
uint_fast64_t syst_f64_to_ui64_rx_min( float64_t );
uint_fast64_t syst_f64_to_ui64_rx_max( float64_t );
uint_fast64_t syst_f64_to_ui64_rx_near_maxMag( float64_t );
int_fast32_t syst_f64_to_i32_rx_near_even( float64_t );
int_fast32_t syst_f64_to_i32_rx_minMag( float64_t );
int_fast32_t syst_f64_to_i32_rx_min( float64_t );
int_fast32_t syst_f64_to_i32_rx_max( float64_t );
int_fast32_t syst_f64_to_i32_rx_near_maxMag( float64_t );
int_fast64_t syst_f64_to_i64_rx_near_even( float64_t );
int_fast64_t syst_f64_to_i64_rx_minMag( float64_t );
int_fast64_t syst_f64_to_i64_rx_min( float64_t );
int_fast64_t syst_f64_to_i64_rx_max( float64_t );
int_fast64_t syst_f64_to_i64_rx_near_maxMag( float64_t );

float32_t syst_f64_to_f32( float64_t );
#ifdef FLOATX80
floatx80_t syst_f64_to_fx80( float64_t );
#endif
#ifdef FLOAT128
float128_t syst_f64_to_f128( float64_t );
#endif

float64_t syst_f64_roundToInt_r_near_even( float64_t );
float64_t syst_f64_roundToInt_r_minMag( float64_t );
float64_t syst_f64_roundToInt_r_min( float64_t );
float64_t syst_f64_roundToInt_r_max( float64_t );
float64_t syst_f64_roundToInt_r_near_maxMag( float64_t );
float64_t syst_f64_roundToInt_x( float64_t );
float64_t syst_f64_add( float64_t, float64_t );
float64_t syst_f64_sub( float64_t, float64_t );
float64_t syst_f64_mul( float64_t, float64_t );
float64_t syst_f64_div( float64_t, float64_t );
float64_t syst_f64_rem( float64_t, float64_t );
float64_t syst_f64_sqrt( float64_t );
bool syst_f64_eq( float64_t, float64_t );
bool syst_f64_le( float64_t, float64_t );
bool syst_f64_lt( float64_t, float64_t );
bool syst_f64_eq_signaling( float64_t, float64_t );
bool syst_f64_le_quiet( float64_t, float64_t );
bool syst_f64_lt_quiet( float64_t, float64_t );

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
#ifdef FLOATX80

uint_fast32_t syst_fx80_to_ui32_r_near_even( floatx80_t );
uint_fast32_t syst_fx80_to_ui32_r_minMag( floatx80_t );
uint_fast32_t syst_fx80_to_ui32_r_min( floatx80_t );
uint_fast32_t syst_fx80_to_ui32_r_max( floatx80_t );
uint_fast32_t syst_fx80_to_ui32_r_near_maxMag( floatx80_t );
uint_fast64_t syst_fx80_to_ui64_r_near_even( floatx80_t );
uint_fast64_t syst_fx80_to_ui64_r_minMag( floatx80_t );
uint_fast64_t syst_fx80_to_ui64_r_min( floatx80_t );
uint_fast64_t syst_fx80_to_ui64_r_max( floatx80_t );
uint_fast64_t syst_fx80_to_ui64_r_near_maxMag( floatx80_t );
int_fast32_t syst_fx80_to_i32_r_near_even( floatx80_t );
int_fast32_t syst_fx80_to_i32_r_minMag( floatx80_t );
int_fast32_t syst_fx80_to_i32_r_min( floatx80_t );
int_fast32_t syst_fx80_to_i32_r_max( floatx80_t );
int_fast32_t syst_fx80_to_i32_r_near_maxMag( floatx80_t );
int_fast64_t syst_fx80_to_i64_r_near_even( floatx80_t );
int_fast64_t syst_fx80_to_i64_r_minMag( floatx80_t );
int_fast64_t syst_fx80_to_i64_r_min( floatx80_t );
int_fast64_t syst_fx80_to_i64_r_max( floatx80_t );
int_fast64_t syst_fx80_to_i64_r_near_maxMag( floatx80_t );

uint_fast32_t syst_fx80_to_ui32_rx_near_even( floatx80_t );
uint_fast32_t syst_fx80_to_ui32_rx_minMag( floatx80_t );
uint_fast32_t syst_fx80_to_ui32_rx_min( floatx80_t );
uint_fast32_t syst_fx80_to_ui32_rx_max( floatx80_t );
uint_fast32_t syst_fx80_to_ui32_rx_near_maxMag( floatx80_t );
uint_fast64_t syst_fx80_to_ui64_rx_near_even( floatx80_t );
uint_fast64_t syst_fx80_to_ui64_rx_minMag( floatx80_t );
uint_fast64_t syst_fx80_to_ui64_rx_min( floatx80_t );
uint_fast64_t syst_fx80_to_ui64_rx_max( floatx80_t );
uint_fast64_t syst_fx80_to_ui64_rx_near_maxMag( floatx80_t );
int_fast32_t syst_fx80_to_i32_rx_near_even( floatx80_t );
int_fast32_t syst_fx80_to_i32_rx_minMag( floatx80_t );
int_fast32_t syst_fx80_to_i32_rx_min( floatx80_t );
int_fast32_t syst_fx80_to_i32_rx_max( floatx80_t );
int_fast32_t syst_fx80_to_i32_rx_near_maxMag( floatx80_t );
int_fast64_t syst_fx80_to_i64_rx_near_even( floatx80_t );
int_fast64_t syst_fx80_to_i64_rx_minMag( floatx80_t );
int_fast64_t syst_fx80_to_i64_rx_min( floatx80_t );
int_fast64_t syst_fx80_to_i64_rx_max( floatx80_t );
int_fast64_t syst_fx80_to_i64_rx_near_maxMag( floatx80_t );

float32_t syst_fx80_to_f32( floatx80_t );
float64_t syst_fx80_to_f64( floatx80_t );
#ifdef FLOATX80
float128_t syst_fx80_to_f128( floatx80_t );
#endif

floatx80_t syst_fx80_roundToInt_r_near_even( floatx80_t );
floatx80_t syst_fx80_roundToInt_r_minMag( floatx80_t );
floatx80_t syst_fx80_roundToInt_r_min( floatx80_t );
floatx80_t syst_fx80_roundToInt_r_max( floatx80_t );
floatx80_t syst_fx80_roundToInt_r_near_maxMag( floatx80_t );
floatx80_t syst_fx80_roundToInt_x( floatx80_t );
floatx80_t syst_fx80_add( floatx80_t, floatx80_t );
floatx80_t syst_fx80_sub( floatx80_t, floatx80_t );
floatx80_t syst_fx80_mul( floatx80_t, floatx80_t );
floatx80_t syst_fx80_div( floatx80_t, floatx80_t );
floatx80_t syst_fx80_rem( floatx80_t, floatx80_t );
floatx80_t syst_fx80_sqrt( floatx80_t );
bool syst_fx80_eq( floatx80_t, floatx80_t );
bool syst_fx80_le( floatx80_t, floatx80_t );
bool syst_fx80_lt( floatx80_t, floatx80_t );
bool syst_fx80_eq_signaling( floatx80_t, floatx80_t );
bool syst_fx80_le_quiet( floatx80_t, floatx80_t );
bool syst_fx80_lt_quiet( floatx80_t, floatx80_t );

#endif

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
#ifdef FLOAT128

uint_fast32_t syst_f128_to_ui32_r_near_even( float128_t );
uint_fast32_t syst_f128_to_ui32_r_minMag( float128_t );
uint_fast32_t syst_f128_to_ui32_r_min( float128_t );
uint_fast32_t syst_f128_to_ui32_r_max( float128_t );
uint_fast32_t syst_f128_to_ui32_r_near_maxMag( floatx80_t );
uint_fast64_t syst_f128_to_ui64_r_near_even( float128_t );
uint_fast64_t syst_f128_to_ui64_r_minMag( float128_t );
uint_fast64_t syst_f128_to_ui64_r_min( float128_t );
uint_fast64_t syst_f128_to_ui64_r_max( float128_t );
uint_fast64_t syst_f128_to_ui64_r_near_maxMag( floatx80_t );
int_fast32_t syst_f128_to_i32_r_near_even( float128_t );
int_fast32_t syst_f128_to_i32_r_minMag( float128_t );
int_fast32_t syst_f128_to_i32_r_min( float128_t );
int_fast32_t syst_f128_to_i32_r_max( float128_t );
int_fast32_t syst_f128_to_i32_r_near_maxMag( floatx80_t );
int_fast64_t syst_f128_to_i64_r_near_even( float128_t );
int_fast64_t syst_f128_to_i64_r_minMag( float128_t );
int_fast64_t syst_f128_to_i64_r_min( float128_t );
int_fast64_t syst_f128_to_i64_r_max( float128_t );
int_fast64_t syst_f128_to_i64_r_near_maxMag( floatx80_t );

uint_fast32_t syst_f128_to_ui32_rx_near_even( float128_t );
uint_fast32_t syst_f128_to_ui32_rx_minMag( float128_t );
uint_fast32_t syst_f128_to_ui32_rx_min( float128_t );
uint_fast32_t syst_f128_to_ui32_rx_max( float128_t );
uint_fast32_t syst_f128_to_ui32_rx_near_maxMag( floatx80_t );
uint_fast64_t syst_f128_to_ui64_rx_near_even( float128_t );
uint_fast64_t syst_f128_to_ui64_rx_minMag( float128_t );
uint_fast64_t syst_f128_to_ui64_rx_min( float128_t );
uint_fast64_t syst_f128_to_ui64_rx_max( float128_t );
uint_fast64_t syst_f128_to_ui64_rx_near_maxMag( floatx80_t );
int_fast32_t syst_f128_to_i32_rx_near_even( float128_t );
int_fast32_t syst_f128_to_i32_rx_minMag( float128_t );
int_fast32_t syst_f128_to_i32_rx_min( float128_t );
int_fast32_t syst_f128_to_i32_rx_max( float128_t );
int_fast32_t syst_f128_to_i32_rx_near_maxMag( floatx80_t );
int_fast64_t syst_f128_to_i64_rx_near_even( float128_t );
int_fast64_t syst_f128_to_i64_rx_minMag( float128_t );
int_fast64_t syst_f128_to_i64_rx_min( float128_t );
int_fast64_t syst_f128_to_i64_rx_max( float128_t );
int_fast64_t syst_fx80_to_i64_rx_near_maxMag( floatx80_t );

float32_t syst_f128_to_f32( float128_t );
float64_t syst_f128_to_f64( float128_t );
#ifdef FLOAT128
floatx80_t syst_f128_to_fx80( float128_t );
#endif

float128_t syst_f128_roundToInt_r_near_even( float128_t );
float128_t syst_f128_roundToInt_r_minMag( float128_t );
float128_t syst_f128_roundToInt_r_min( float128_t );
float128_t syst_f128_roundToInt_r_max( float128_t );
float128_t syst_f128_roundToInt_r_near_maxMag( float128_t );
float128_t syst_f128_roundToInt_x( float128_t );
float128_t syst_f128_add( float128_t, float128_t );
float128_t syst_f128_sub( float128_t, float128_t );
float128_t syst_f128_mul( float128_t, float128_t );
float128_t syst_f128_div( float128_t, float128_t );
float128_t syst_f128_rem( float128_t, float128_t );
float128_t syst_f128_sqrt( float128_t );
bool syst_f128_eq( float128_t, float128_t );
bool syst_f128_le( float128_t, float128_t );
bool syst_f128_lt( float128_t, float128_t );
bool syst_f128_eq_signaling( float128_t, float128_t );
bool syst_f128_le_quiet( float128_t, float128_t );
bool syst_f128_lt_quiet( float128_t, float128_t );

#endif

