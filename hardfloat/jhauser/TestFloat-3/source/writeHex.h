
/*
===============================================================================

This C header file is part of TestFloat, Release 2a, a package of programs
for testing the correctness of fing-point arithmetic complying to the
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

void writeHex_bool( bool, char );
void writeHex_ui8( uint_fast8_t, char );
void writeHex_ui32( uint_fast32_t, char );
void writeHex_ui64( uint_fast64_t, char );
void writeHex_f32( float32_t, char );
void writeHex_f64( float64_t, char );
#ifdef FLOATX80
void writeHex_fx80( floatx80_t, char );
#endif
#ifdef FLOAT128
void writeHex_f128( float128_t, char );
#endif
void writeHex_softfloat_flags( int_fast8_t, char );

