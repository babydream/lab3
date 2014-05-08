
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

extern volatile bool genLoops_stop;

extern bool genLoops_forever;
extern bool genLoops_givenCount;
extern uint_fast64_t genLoops_count;
extern int_fast8_t *genLoops_trueFlagsPtr;

void gen_a_ui32( void );
void gen_a_ui64( void );
void gen_a_i32( void );
void gen_a_i64( void );
void gen_a_f32( void );
void gen_ab_f32( void );
void gen_abc_f32( void );
void gen_a_f64( void );
void gen_ab_f64( void );
void gen_abc_f64( void );

void gen_a_ui32_z_f32( float32_t ( uint_fast32_t ) );
void gen_a_ui32_z_f64( float64_t ( uint_fast32_t ) );
void gen_a_ui64_z_f32( float32_t ( uint_fast64_t ) );
void gen_a_ui64_z_f64( float64_t ( uint_fast64_t ) );
void gen_a_i32_z_f32( float32_t ( int_fast32_t ) );
void gen_a_i32_z_f64( float64_t ( int_fast32_t ) );
void gen_a_i64_z_f32( float32_t ( int_fast64_t ) );
void gen_a_i64_z_f64( float64_t ( int_fast64_t ) );

void
 gen_a_f32_z_ui32_rx(
     uint_fast32_t ( float32_t, int_fast8_t, bool ), int_fast8_t, bool );
void
 gen_a_f32_z_ui64_rx(
     uint_fast64_t ( float32_t, int_fast8_t, bool ), int_fast8_t, bool );
void
 gen_a_f32_z_i32_rx(
     int_fast32_t ( float32_t, int_fast8_t, bool ), int_fast8_t, bool );
void
 gen_a_f32_z_i64_rx(
     int_fast64_t ( float32_t, int_fast8_t, bool ), int_fast8_t, bool );
void gen_a_f32_z_ui32_x( uint_fast32_t ( float32_t, bool ), bool );
void gen_a_f32_z_ui64_x( uint_fast64_t ( float32_t, bool ), bool );
void gen_a_f32_z_i32_x( int_fast32_t ( float32_t, bool ), bool );
void gen_a_f32_z_i64_x( int_fast64_t ( float32_t, bool ), bool );
void gen_a_f32_z_f64( float64_t ( float32_t ) );
void gen_az_f32( float32_t ( float32_t ) );
void
 gen_az_f32_rx(
     float32_t ( float32_t, int_fast8_t, bool ), int_fast8_t, bool );
void gen_abz_f32( float32_t ( float32_t, float32_t ) );
void gen_abcz_f32( float32_t ( float32_t, float32_t, float32_t ) );
void gen_ab_f32_z_bool( bool ( float32_t, float32_t ) );

void
 gen_a_f64_z_ui32_rx(
     uint_fast32_t ( float64_t, int_fast8_t, bool ), int_fast8_t, bool );
void
 gen_a_f64_z_ui64_rx(
     uint_fast64_t ( float64_t, int_fast8_t, bool ), int_fast8_t, bool );
void
 gen_a_f64_z_i32_rx(
     int_fast32_t ( float64_t, int_fast8_t, bool ), int_fast8_t, bool );
void
 gen_a_f64_z_i64_rx(
     int_fast64_t ( float64_t, int_fast8_t, bool ), int_fast8_t, bool );
void gen_a_f64_z_ui32_x( uint_fast32_t ( float64_t, bool ), bool );
void gen_a_f64_z_ui64_x( uint_fast64_t ( float64_t, bool ), bool );
void gen_a_f64_z_i32_x( int_fast32_t ( float64_t, bool ), bool );
void gen_a_f64_z_i64_x( int_fast64_t ( float64_t, bool ), bool );
void gen_a_f64_z_f32( float32_t ( float64_t ) );
void gen_az_f64( float64_t ( float64_t ) );
void
 gen_az_f64_rx(
     float64_t ( float64_t, int_fast8_t, bool ), int_fast8_t, bool );
void gen_abz_f64( float64_t ( float64_t, float64_t ) );
void gen_abcz_f64( float64_t ( float64_t, float64_t, float64_t ) );
void gen_ab_f64_z_bool( bool ( float64_t, float64_t ) );

