
#include <stdio.h>
#include "genCases.h"

void genCases_writeTestsTotal( bool forever )
{

    if ( forever ) {
        fputs( "Unbounded tests.\n", stderr );
    } else {
        if ( 2000000000 <= genCases_total ) {
            fprintf(
                stderr,
                "\r%lu%09lu tests total.\n",
                (long unsigned) ( genCases_total / 1000000000 ),
                (long unsigned) ( genCases_total % 1000000000 )
            );
        } else {
            fprintf(
                stderr, "\r%lu tests total.\n", (long unsigned) genCases_total
            );
        }
    }

}

