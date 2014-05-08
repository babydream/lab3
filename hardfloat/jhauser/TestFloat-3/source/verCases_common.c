
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
#include <stdlib.h>
#include <stdio.h>
#include "verCases.h"

const char *verCases_functionNamePtr;
int_fast8_t verCases_roundingPrecision = 0;
int_fast8_t verCases_roundingCode = 0;
int_fast8_t verCases_tininessCode = 0;
bool verCases_usesExact = false;
bool verCases_exact;
bool verCases_checkNaNs = false;
uint_fast32_t verCases_maxErrorCount = 0;
bool verCases_errorStop = false;

volatile bool verCases_stop = false;

bool verCases_anyErrors = false;

void verCases_exitWithStatus( void )
{

    exit( verCases_anyErrors ? EXIT_FAILURE : EXIT_SUCCESS );

}

uint_fast32_t verCases_tenThousandsCount, verCases_errorCount;

void verCases_writeTestsPerformed( int count )
{

    if ( verCases_tenThousandsCount ) {
        fprintf(
            stderr,
            "\r%lu%04d tests performed",
            (unsigned long) verCases_tenThousandsCount,
            count
        );
    } else {
        fprintf( stderr, "\r%d tests performed", count );
    }
    if ( verCases_errorCount ) {
        fprintf(
            stderr,
            "; %lu error%s found.\n",
            (unsigned long) verCases_errorCount,
            ( verCases_errorCount == 1 ) ? "" : "s"
        );
    } else {
        fputs( ".\n", stderr );
        fputs( "No errors found in ", stdout );
        verCases_writeFunctionName( stdout );
        fputs( ".\n", stdout );
        fflush( stdout );
    }

}

void verCases_perTenThousand( void )
{

    ++verCases_tenThousandsCount;
    if ( verCases_stop ) {
        verCases_writeTestsPerformed( 0 );
        verCases_exitWithStatus();
    }
    fprintf(
        stderr, "\r%3lu0000", (unsigned long) verCases_tenThousandsCount );

}

void verCases_writeErrorFound( int count )
{

    fputc( '\r', stderr );
    if ( verCases_errorCount == 1 ) {
        fputs( "Errors found in ", stdout );
        verCases_writeFunctionName( stdout );
        fputs( ":\n", stdout );
    }
    if ( verCases_stop ) {
        verCases_writeTestsPerformed( count );
        verCases_exitWithStatus();
    }
    verCases_anyErrors = true;

}

