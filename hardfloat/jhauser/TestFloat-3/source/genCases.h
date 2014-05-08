
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

extern int_fast8_t genCases_level;

/*** SET DIRECTLY? ***/
void genCases_setLevel( int_fast8_t );

extern uint_fast64_t genCases_total;
extern bool genCases_done;

void genCases_ui32_a_init( void );
void genCases_ui32_a_next( void );

extern uint_fast32_t genCases_ui32_a;

void genCases_ui64_a_init( void );
void genCases_ui64_a_next( void );

extern uint_fast64_t genCases_ui64_a;

void genCases_i32_a_init( void );
void genCases_i32_a_next( void );

extern int_fast32_t genCases_i32_a;

void genCases_i64_a_init( void );
void genCases_i64_a_next( void );

extern int_fast64_t genCases_i64_a;

void genCases_f32_a_init( void );
void genCases_f32_a_next( void );
void genCases_f32_ab_init( void );
void genCases_f32_ab_next( void );
void genCases_f32_abc_init( void );
void genCases_f32_abc_next( void );

extern float32_t genCases_f32_a, genCases_f32_b, genCases_f32_c;

void genCases_f64_a_init( void );
void genCases_f64_a_next( void );
void genCases_f64_ab_init( void );
void genCases_f64_ab_next( void );
void genCases_f64_abc_init( void );
void genCases_f64_abc_next( void );

extern float64_t genCases_f64_a, genCases_f64_b, genCases_f64_c;


/*** OLD STYLE BELOW. ***/

void genCases_initSequence( int );
enum {
    genCases_sequence_a_floatx80,
    genCases_sequence_ab_floatx80,
    genCases_sequence_a_float128,
    genCases_sequence_ab_float128,
};

void genCases_next( void );

#ifdef FLOATX80
extern floatx80 genCases_a_floatx80;
extern floatx80 genCases_b_floatx80;
#endif
#ifdef FLOAT128
extern float128 genCases_a_float128;
extern float128 genCases_b_float128;
#endif

void genCases_writeTestsTotal( bool );

