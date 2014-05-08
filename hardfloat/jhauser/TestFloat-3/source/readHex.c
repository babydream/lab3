
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
#include <stdio.h>
#include "readHex.h"

bool readHex_bool( bool *aPtr, char sepChar )
{
    int i;
    bool a;

    i = fgetc( stdin );
    if ( ( i == EOF ) || ( i < '0' ) || ( '1' < i ) ) return false;
    a = i - '0';
    if ( sepChar ) {
        i = fgetc( stdin );
        if ( ( sepChar != '\n' ) || ( i != '\r' ) ) {
            if ( i != sepChar ) return false;
        }
    }
    *aPtr = a;
    return true;

}

bool readHex_ui8( uint8_t *aPtr, char sepChar )
{
    int i;
    uint_fast8_t a;

    i = fgetc( stdin );
    if ( i == EOF ) return false;
    if ( ( '0' <= i ) && ( i <= '9' ) ) {
        i -= '0';
    } else if ( ( 'A' <= i ) && ( i <= 'F' ) ) {
        i -= 'A' - 10;
    } else if ( ( 'a' <= i ) && ( i <= 'f' ) ) {
        i -= 'a' - 10;
    } else {
        return false;
    }
    a = i<<4;
    i = fgetc( stdin );
    if ( i == EOF ) return false;
    if ( ( '0' <= i ) && ( i <= '9' ) ) {
        i -= '0';
    } else if ( ( 'A' <= i ) && ( i <= 'F' ) ) {
        i -= 'A' - 10;
    } else if ( ( 'a' <= i ) && ( i <= 'f' ) ) {
        i -= 'a' - 10;
    } else {
        return false;
    }
    a |= i;
    if ( sepChar ) {
        i = fgetc( stdin );
        if ( ( sepChar != '\n' ) || ( i != '\r' ) ) {
            if ( i != sepChar ) return false;
        }
    }
    *aPtr = a;
    return true;

}

static bool readHex_ui16( uint16_t *aPtr, char sepChar )
{
    int i;
    uint_fast16_t a;

    i = fgetc( stdin );
    if ( i == EOF ) return false;
    if ( ( '0' <= i ) && ( i <= '9' ) ) {
        i -= '0';
    } else if ( ( 'A' <= i ) && ( i <= 'F' ) ) {
        i -= 'A' - 10;
    } else if ( ( 'a' <= i ) && ( i <= 'f' ) ) {
        i -= 'a' - 10;
    } else {
        return false;
    }
    a = (uint_fast16_t) i<<12;
    i = fgetc( stdin );
    if ( i == EOF ) return false;
    if ( ( '0' <= i ) && ( i <= '9' ) ) {
        i -= '0';
    } else if ( ( 'A' <= i ) && ( i <= 'F' ) ) {
        i -= 'A' - 10;
    } else if ( ( 'a' <= i ) && ( i <= 'f' ) ) {
        i -= 'a' - 10;
    } else {
        return false;
    }
    a |= (uint_fast16_t) i<<8;
    i = fgetc( stdin );
    if ( i == EOF ) return false;
    if ( ( '0' <= i ) && ( i <= '9' ) ) {
        i -= '0';
    } else if ( ( 'A' <= i ) && ( i <= 'F' ) ) {
        i -= 'A' - 10;
    } else if ( ( 'a' <= i ) && ( i <= 'f' ) ) {
        i -= 'a' - 10;
    } else {
        return false;
    }
    a |= (uint_fast16_t) i<<4;
    i = fgetc( stdin );
    if ( i == EOF ) return false;
    if ( ( '0' <= i ) && ( i <= '9' ) ) {
        i -= '0';
    } else if ( ( 'A' <= i ) && ( i <= 'F' ) ) {
        i -= 'A' - 10;
    } else if ( ( 'a' <= i ) && ( i <= 'f' ) ) {
        i -= 'a' - 10;
    } else {
        return false;
    }
    a |= i;
    if ( sepChar ) {
        i = fgetc( stdin );
        if ( ( sepChar != '\n' ) || ( i != '\r' ) ) {
            if ( i != sepChar ) return false;
        }
    }
    *aPtr = a;
    return true;

}

bool readHex_ui32( uint32_t *aPtr, char sepChar )
{
    uint16_t v16, v0;

    if ( ! readHex_ui16( &v16, 0 ) || ! readHex_ui16( &v0, sepChar ) ) {
        return false;
    }
    *aPtr = (uint_fast32_t) v16<<16 | v0;
    return true;

}

bool readHex_ui64( uint64_t *aPtr, char sepChar )
{
    uint32_t v32, v0;

    if ( ! readHex_ui32( &v32, 0 ) || ! readHex_ui32( &v0, sepChar ) ) {
        return false;
    }
    *aPtr = (uint_fast64_t) v32<<32 | v0;
    return true;

}

