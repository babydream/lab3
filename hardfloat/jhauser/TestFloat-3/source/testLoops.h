
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
#include <stdio.h>
#include "softfloat.h"

extern bool testLoops_forever;

extern int_fast8_t *testLoops_trueFlagsPtr;
extern int_fast8_t ( *testLoops_testFlagsFunction )( void );

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
void
 test_a_ui32_z_f32( float32_t ( uint_fast32_t ), float32_t ( uint_fast32_t ) );
void
 test_a_ui32_z_f64( float64_t ( uint_fast32_t ), float64_t ( uint_fast32_t ) );
#ifdef FLOATX80
void
 test_a_ui32_z_fx80(
     floatx80_t ( uint_fast32_t ), floatx80_t ( uint_fast32_t ) );
#endif
#ifdef FLOAT128
void
 test_a_ui32_z_f128(
     float128_t ( uint_fast32_t ), float128_t ( uint_fast32_t ) );
#endif
void
 test_a_ui64_z_f32( float32_t ( uint_fast64_t ), float32_t ( uint_fast64_t ) );
void
 test_a_ui64_z_f64( float64_t ( uint_fast64_t ), float64_t ( uint_fast64_t ) );
#ifdef FLOATX80
void
 test_a_ui64_z_fx80(
     floatx80_t ( uint_fast64_t ), floatx80_t ( uint_fast64_t ) );
#endif
#ifdef FLOAT128
void
 test_a_ui64_z_f128(
     float128_t ( uint_fast64_t ), float128_t ( uint_fast64_t ) );
#endif
void
 test_a_i32_z_f32( float32_t ( int_fast32_t ), float32_t ( int_fast32_t ) );
void
 test_a_i32_z_f64( float64_t ( int_fast32_t ), float64_t ( int_fast32_t ) );
#ifdef FLOATX80
void
 test_a_i32_z_fx80( floatx80_t ( int_fast32_t ), floatx80_t ( int_fast32_t ) );
#endif
#ifdef FLOAT128
void
 test_a_i32_z_f128( float128_t ( int_fast32_t ), float128_t ( int_fast32_t ) );
#endif
void
 test_a_i64_z_f32( float32_t ( int_fast64_t ), float32_t ( int_fast64_t ) );
void
 test_a_i64_z_f64( float64_t ( int_fast64_t ), float64_t ( int_fast64_t ) );
#ifdef FLOATX80
void
 test_a_i64_z_fx80( floatx80_t ( int_fast64_t ), floatx80_t ( int_fast64_t ) );
#endif
#ifdef FLOAT128
void
 test_a_i64_z_f128( float128_t ( int_fast64_t ), float128_t ( int_fast64_t ) );
#endif

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
void
 test_a_f32_z_ui32_rx(
     uint_fast32_t ( float32_t, int_fast8_t, bool ),
     uint_fast32_t ( float32_t, int_fast8_t, bool ),
     int_fast8_t,
     bool
 );
void
 test_a_f32_z_ui64_rx(
     uint_fast64_t ( float32_t, int_fast8_t, bool ),
     uint_fast64_t ( float32_t, int_fast8_t, bool ),
     int_fast8_t,
     bool
 );
void
 test_a_f32_z_i32_rx(
     int_fast32_t ( float32_t, int_fast8_t, bool ),
     int_fast32_t ( float32_t, int_fast8_t, bool ),
     int_fast8_t,
     bool
 );
void
 test_a_f32_z_i64_rx(
     int_fast64_t ( float32_t, int_fast8_t, bool ),
     int_fast64_t ( float32_t, int_fast8_t, bool ),
     int_fast8_t,
     bool
 );
void
 test_a_f32_z_ui32_x(
     uint_fast32_t ( float32_t, bool ), uint_fast32_t ( float32_t, bool ), bool
 );
void
 test_a_f32_z_ui64_x(
     uint_fast64_t ( float32_t, bool ), uint_fast64_t ( float32_t, bool ), bool
 );
void
 test_a_f32_z_i32_x(
     int_fast32_t ( float32_t, bool ), int_fast32_t ( float32_t, bool ), bool
 );
void
 test_a_f32_z_i64_x(
     int_fast64_t ( float32_t, bool ), int_fast64_t ( float32_t, bool ), bool
 );
void test_a_f32_z_f64( float64_t ( float32_t ), float64_t ( float32_t ) );
#ifdef FLOATX80
void test_a_f32_z_fx80( floatx80_t ( float32_t ), floatx80_t ( float32_t ) );
#endif
#ifdef FLOAT128
void test_a_f32_z_f128( float128_t ( float32_t ), float128_t ( float32_t ) );
#endif
void test_az_f32( float32_t ( float32_t ), float32_t ( float32_t ) );
void
 test_az_f32_rx(
     float32_t ( float32_t, int_fast8_t, bool ),
     float32_t ( float32_t, int_fast8_t, bool ),
     int_fast8_t,
     bool
 );
void
 test_abz_f32(
     float32_t ( float32_t, float32_t ), float32_t ( float32_t, float32_t ) );
void
 test_abcz_f32(
     float32_t ( float32_t, float32_t, float32_t ),
     float32_t ( float32_t, float32_t, float32_t )
 );
void
 test_ab_f32_z_bool(
     bool ( float32_t, float32_t ), bool ( float32_t, float32_t ) );

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
void
 test_a_f64_z_ui32_rx(
     uint_fast32_t ( float64_t, int_fast8_t, bool ),
     uint_fast32_t ( float64_t, int_fast8_t, bool ),
     int_fast8_t,
     bool
 );
void
 test_a_f64_z_ui64_rx(
     uint_fast64_t ( float64_t, int_fast8_t, bool ),
     uint_fast64_t ( float64_t, int_fast8_t, bool ),
     int_fast8_t,
     bool
 );
void
 test_a_f64_z_i32_rx(
     int_fast32_t ( float64_t, int_fast8_t, bool ),
     int_fast32_t ( float64_t, int_fast8_t, bool ),
     int_fast8_t,
     bool
 );
void
 test_a_f64_z_i64_rx(
     int_fast64_t ( float64_t, int_fast8_t, bool ),
     int_fast64_t ( float64_t, int_fast8_t, bool ),
     int_fast8_t,
     bool
 );
void
 test_a_f64_z_ui32_x(
     uint_fast32_t ( float64_t, bool ), uint_fast32_t ( float64_t, bool ), bool
 );
void
 test_a_f64_z_ui64_x(
     uint_fast64_t ( float64_t, bool ), uint_fast64_t ( float64_t, bool ), bool
 );
void
 test_a_f64_z_i32_x(
     int_fast32_t ( float64_t, bool ), int_fast32_t ( float64_t, bool ), bool
 );
void
 test_a_f64_z_i64_x(
     int_fast64_t ( float64_t, bool ), int_fast64_t ( float64_t, bool ), bool
 );
void test_a_f64_z_f32( float32_t ( float64_t ), float32_t ( float64_t ) );
#ifdef FLOATX80
void test_a_f64_z_fx80( floatx80_t ( float64_t ), floatx80_t ( float64_t ) );
#endif
#ifdef FLOAT128
void test_a_f64_z_f128( float128_t ( float64_t ), float128_t ( float64_t ) );
#endif
void test_az_f64( float64_t ( float64_t ), float64_t ( float64_t ) );
void
 test_az_f64_rx(
     float64_t ( float64_t, int_fast8_t, bool ),
     float64_t ( float64_t, int_fast8_t, bool ),
     int_fast8_t,
     bool
 );
void
 test_abz_f64(
     float64_t ( float64_t, float64_t ), float64_t ( float64_t, float64_t ) );
void
 test_abcz_f64(
     float64_t ( float64_t, float64_t, float64_t ),
     float64_t ( float64_t, float64_t, float64_t )
 );
void
 test_ab_f64_z_bool(
     bool ( float64_t, float64_t ), bool ( float64_t, float64_t ) );

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
#ifdef FLOATX80
void
 test_a_fx80_z_i32( int_fast32_t ( floatx80_t ), int_fast32_t ( floatx80_t ) );
void
 test_a_fx80_z_i64( int_fast64_t ( floatx80_t ), int_fast64_t ( floatx80_t ) );
void test_a_fx80_z_f32( float32_t ( floatx80_t ), float32_t ( floatx80_t ) );
void test_a_fx80_z_f64( float64_t ( floatx80_t ), float64_t ( floatx80_t ) );
#ifdef FLOAT128
void
 test_a_fx80_z_f128( float128_t ( floatx80_t ), float128_t ( floatx80_t ) );
#endif
void test_az_fx80( floatx80_t ( floatx80_t ), floatx80_t ( floatx80_t ) );
void
 test_az_fx80_rx(
     floatx80_t ( floatx80_t, int_fast8_t, bool ),
     floatx80_t ( floatx80_t, int_fast8_t, bool ),
     int_fast8_t,
     bool
 );
void
 test_abz_fx80(
     floatx80_t ( floatx80_t, floatx80_t ),
     floatx80_t ( floatx80_t, floatx80_t )
 );
void
 test_abcz_fx80(
     floatx80_t ( floatx80_t, floatx80_t, floatx80_t ),
     floatx80_t ( floatx80_t, floatx80_t, floatx80_t )
 );
void
 test_ab_fx80_z_bool(
     bool ( floatx80_t, floatx80_t ), bool ( floatx80_t, floatx80_t ) );
#endif

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
#ifdef FLOAT128
void
 test_a_f128_z_i32( int_fast32_t ( float128_t ), int_fast32_t ( float128_t ) );
void
 test_a_f128_z_i64( int_fast64_t ( float128_t ), int_fast64_t ( float128_t ) );
void test_a_f128_z_f32( float32_t ( float128_t ), float32_t ( float128_t ) );
void test_a_f128_z_f64( float64_t ( float128_t ), float64_t ( float128_t ) );
#ifdef FLOATX80
void
 test_a_f128_z_fx80( floatx80_t ( float128_t ), floatx80_t ( float128_t ) );
#endif
void test_az_f128( float128_t ( float128_t ), float128_t ( float128_t ) );
void
 test_az_f128_rx(
     float128_t ( float128_t, int_fast8_t, bool ),
     float128_t ( float128_t, int_fast8_t, bool ),
     int_fast8_t,
     bool
 );
void
 test_abz_f128(
     float128_t ( float128_t, float128_t ),
     float128_t ( float128_t, float128_t )
 );
void
 test_abcz_f128(
     float128_t ( float128_t, float128_t, float128_t ),
     float128_t ( float128_t, float128_t, float128_t )
 );
void
 test_ab_f128_z_bool(
     bool ( float128_t, float128_t ), bool ( float128_t, float128_t ) );
#endif

