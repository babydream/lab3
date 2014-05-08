
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

/*** REPLACE WITH A BETTER RANDOM NUMBER GENERATOR! ***/

#include <stdint.h>
#include <stdlib.h>
#include "random.h"

uint_fast8_t random_ui8( void )
{

    return rand()>>4 & 0xFF;

}

uint_fast16_t random_ui16( void )
{

    return ( ( rand() & 0x0FF0 )<<4 ) | ( rand()>>4 & 0xFF );

}

uint_fast32_t random_ui32( void )
{

    return
          (uint_fast32_t) ( rand() & 0x0FF0 )<<20
        | (uint_fast32_t) ( rand() & 0x0FF0 )<<12
        | ( rand() & 0x0FF0 )<<4
        | ( rand()>>4 & 0xFF );

}

uint_fast64_t random_ui64( void )
{

    return (uint_fast64_t) random_ui32()<<32 | random_ui32();

}

