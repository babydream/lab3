
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

#include <stdint.h>
#include <stdio.h>
#include "softfloat.h"
#include "writeHex.h"
#include "writeCase.h"

void
 writeCase_z_f64(
     float64_t trueZ,
     int_fast8_t trueFlags,
     float64_t testZ,
     int_fast8_t testFlags
 )
{

    fputs( writeCase_trueNamePtr, stdout );
    fputs( ": ", stdout );
    writeHex_f64( trueZ, ' ' );
    writeHex_softfloat_flags( trueFlags, 0 );
    fputs( "  ", stdout );
    fputs( writeCase_testNamePtr, stdout );
    fputs( ": ", stdout );
    writeHex_f64( testZ, ' ' );
    writeHex_softfloat_flags( testFlags, '\n' );
    fflush( stdout );

}

