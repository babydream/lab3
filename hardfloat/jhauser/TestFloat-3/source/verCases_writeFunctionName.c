
#include <stdio.h>
#include "functions.h"
#include "verCases.h"

void verCases_writeFunctionName( FILE *streamPtr )
{
    static const char *roundingModeNames[ NUM_ROUNDINGMODES ] = {
        0,
        ", rounding nearest_even",
        ", rounding minMag (toward zero)",
        ", rounding min (down)",
        ", rounding max (up)",
        ", rounding nearest_maxMag (nearest/away)"
    };

    fputs( verCases_functionNamePtr, streamPtr );
    if ( verCases_roundingCode ) {
        if ( verCases_roundingPrecision ) {
            fprintf(
                streamPtr, ", precision %d", (int) verCases_roundingPrecision
            );
        }
        fputs( roundingModeNames[ verCases_roundingCode ], streamPtr );
        if ( verCases_tininessCode ) {
            fputs(
                ( verCases_tininessCode == TININESS_BEFORE_ROUNDING )
                    ? ", tininess before rounding"
                    : ", tininess after rounding",
                streamPtr
            );
        }
    }
    if ( verCases_usesExact ) {
        fputs( verCases_exact ? ", exact" : ", not exact", streamPtr );
    }

}

