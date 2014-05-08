
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
#include <fenv.h>
#include <stdio.h>
#include "softfloat.h"
#include "genCases.h"
#include "verCases.h"
#include "writeCase.h"
#include "testLoops.h"

#pragma STDC FENV_ACCESS ON

void
 test_a_f32_z_ui32_x(
     uint_fast32_t trueFunction( float32_t, bool ),
     uint_fast32_t testFunction( float32_t, bool ),
     bool exact
 )
{
    int count;
    uint_fast32_t trueZ;
    int_fast8_t trueFlags;
    uint_fast32_t testZ;
    int_fast8_t testFlags;

    genCases_f32_a_init();
    genCases_writeTestsTotal( testLoops_forever );
    verCases_errorCount = 0;
    verCases_tenThousandsCount = 0;
    count = 10000;
    while ( ! genCases_done || testLoops_forever ) {
        genCases_f32_a_next();
        *testLoops_trueFlagsPtr = 0;
        trueZ = trueFunction( genCases_f32_a, exact );
        trueFlags = *testLoops_trueFlagsPtr;
        testLoops_testFlagsFunction();
        testZ = testFunction( genCases_f32_a, exact );
        testFlags = testLoops_testFlagsFunction();
        --count;
        if ( ! count ) {
            verCases_perTenThousand();
            count = 10000;
        }
        if ( ( trueZ != testZ ) || ( trueFlags != testFlags ) ) {
            if (
                ! verCases_checkNaNs && f32_isSignalingNaN( genCases_f32_a )
            ) {
                trueFlags |= softfloat_flag_invalid;
            }
            if (
                   ( trueZ != 0xFFFFFFFF )
                || ( testZ != 0xFFFFFFFF )
                || ( trueFlags != softfloat_flag_invalid )
                || ( testFlags != softfloat_flag_invalid )
            ) {
                ++verCases_errorCount;
                verCases_writeErrorFound( 10000 - count );
                writeCase_a_f32( genCases_f32_a, "  " );
                writeCase_z_ui32( trueZ, trueFlags, testZ, testFlags );
                if ( verCases_errorCount == verCases_maxErrorCount ) break;
            }
        }
    }
    verCases_writeTestsPerformed( 10000 - count );

}

