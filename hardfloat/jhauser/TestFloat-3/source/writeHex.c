
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
#include "softfloat.h"
#include "writeHex.h"

void writeHex_bool( bool a, char sepChar )
{

    fputc( a ? '1' : '0', stdout );
    if ( sepChar ) fputc( sepChar, stdout );

}

void writeHex_ui8( uint_fast8_t a, char sepChar )
{
    int digit;

    digit = a>>4 & 0xF;
    if ( 9 < digit ) digit += 'A' - ( '0' + 10 );
    fputc( '0' + digit, stdout );
    digit = a & 0xF;
    if ( 9 < digit ) digit += 'A' - ( '0' + 10 );
    fputc( '0' + digit, stdout );
    if ( sepChar ) fputc( sepChar, stdout );

}

static void writeHex_ui12( uint_fast16_t a, char sepChar )
{
    int digit;

    digit = a>>8 & 0xF;
    if ( 9 < digit ) digit += 'A' - ( '0' + 10 );
    fputc( '0' + digit, stdout );
    digit = a>>4 & 0xF;
    if ( 9 < digit ) digit += 'A' - ( '0' + 10 );
    fputc( '0' + digit, stdout );
    digit = a & 0xF;
    if ( 9 < digit ) digit += 'A' - ( '0' + 10 );
    fputc( '0' + digit, stdout );
    if ( sepChar ) fputc( sepChar, stdout );

}

static void writeHex_ui16( uint_fast16_t a, char sepChar )
{
    int digit;

    digit = a>>12 & 0xF;
    if ( 9 < digit ) digit += 'A' - ( '0' + 10 );
    fputc( '0' + digit, stdout );
    digit = a>>8 & 0xF;
    if ( 9 < digit ) digit += 'A' - ( '0' + 10 );
    fputc( '0' + digit, stdout );
    digit = a>>4 & 0xF;
    if ( 9 < digit ) digit += 'A' - ( '0' + 10 );
    fputc( '0' + digit, stdout );
    digit = a & 0xF;
    if ( 9 < digit ) digit += 'A' - ( '0' + 10 );
    fputc( '0' + digit, stdout );
    if ( sepChar ) fputc( sepChar, stdout );

}

void writeHex_ui32( uint_fast32_t a, char sepChar )
{

    writeHex_ui16( a>>16, 0 );
    writeHex_ui16( a, sepChar );

}

void writeHex_ui64( uint_fast64_t a, char sepChar )
{

    writeHex_ui32( a>>32, 0 );
    writeHex_ui32( a, sepChar );

}

void writeHex_f32( float32_t a, char sepChar )
{
    union { uint32_t ui; float32_t f; } uA;
    uint_fast32_t uiA;

    uA.f = a;
    uiA = uA.ui;
    fputc( ( 0x80000000 <= uiA ) ? '8' : '0', stdout );
    writeHex_ui8( uiA>>23, 0 );
    fputc( '.', stdout );
    writeHex_ui8( uiA>>16 & 0x7F, 0 );
    writeHex_ui16( uiA, sepChar );

}

void writeHex_f64( float64_t a, char sepChar )
{
    union { uint64_t ui; float64_t f; } uA;
    uint_fast64_t uiA;

    uA.f = a;
    uiA = uA.ui;
    writeHex_ui12( uiA>>52, 0 );
    fputc( '.', stdout );
    writeHex_ui12( uiA>>40, 0 );
    writeHex_ui8( uiA>>32, 0 );
    writeHex_ui32( uiA, sepChar );

}

#ifdef FLOATX80

void writeHex_fx80( floatx80 a, char sepChar )
{

    writeHex_ui16( a.high, 0 );
    fputc( '.', stdout );
    writeHex_ui64( a.low, sepChar );

}

#endif

#ifdef FLOAT128

void writeHex_f128( float128 a, char sepChar )
{

    writeHex_ui16( a.high>>48, 0 );
    fputc( '.', stdout );
    writeHex_ui16( a.high>>32, 0 );
    writeHex_ui32( a.high, 0 );
    writeHex_ui64( a.low, sepChar );

}

#endif

void writeHex_softfloat_flags( int_fast8_t flags, char sepChar )
{

    fputc( flags & softfloat_flag_invalid   ? 'v' : '.', stdout );
    fputc( flags & softfloat_flag_infinity  ? 'z' : '.', stdout );
    fputc( flags & softfloat_flag_overflow  ? 'o' : '.', stdout );
    fputc( flags & softfloat_flag_underflow ? 'u' : '.', stdout );
    fputc( flags & softfloat_flag_inexact   ? 'x' : '.', stdout );
    if ( sepChar ) fputc( sepChar, stdout );

}

