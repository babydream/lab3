
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "readWriteHex.h"

/*** TEMPORARY. ***/
#define PROGRAM_NAME "TEST"

static bool atEnd = false;

static void checkEndOfInput( void )
{
    int i;

    i = fgetc( stdin );
    if ( i == EOF ) {
        if ( ferror( stdin ) || ! feof( stdin ) ) {
            fputs( PROGRAM_NAME ": Error reading input.\n", stderr );
            exit( EXIT_FAILURE );
        }
        atEnd = true;
    } else {
        ungetc( i, stdin );
    }

}

static void failFromBadInput( void )
{

    fputs( PROGRAM_NAME ": Invalid input format.\n", stderr );
    exit( EXIT_FAILURE );

}

static bool readHex_bool( uint32_t *aPtr, char sepChar )
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

static bool readHex_ui8( uint32_t *aPtr, char sepChar )
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

static bool readHex_ui16( uint32_t *aPtr, char sepChar )
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

static bool readHex_ui32( uint32_t *aPtr, char sepChar )
{
    uint32_t v16, v0;

    if ( ! readHex_ui16( &v16, 0 ) || ! readHex_ui16( &v0, sepChar ) ) {
        return false;
    }
    *aPtr = (uint_fast32_t) v16<<16 | v0;
    return true;

}

void readHex_ui8_sp( uint32_t *aPtr )
{

    if ( ! readHex_ui8( aPtr, ' ' ) ) failFromBadInput();

}

void readHex_ui8_n( uint32_t *aPtr )
{

    if ( ! readHex_ui8( aPtr, '\n' ) ) failFromBadInput();
    checkEndOfInput();

}

void readHex_ui32_sp( uint32_t *aPtr )
{

    if ( ! readHex_ui32( aPtr, ' ' ) ) failFromBadInput();

}

void readHex_ui32_n( uint32_t *aPtr )
{

    if ( ! readHex_ui32( aPtr, '\n' ) ) failFromBadInput();
    checkEndOfInput();

}

void readHex_ui64_sp( uint32_t *aPtr )
{

    if (
        ! readHex_ui32( &aPtr[ 1 ], 0 ) || ! readHex_ui32( &aPtr[ 0 ], ' ' )
    ) {
        failFromBadInput();
    }

}

void readHex_ui64_n( uint32_t *aPtr )
{

    if (
        ! readHex_ui32( &aPtr[ 1 ], 0 ) || ! readHex_ui32( &aPtr[ 0 ], '\n' )
    ) {
        failFromBadInput();
    }
    checkEndOfInput();

}

void writeHex_ui8_sp( uint32_t a )
{

    printf( "%02X ", (unsigned int) a );

}

void writeHex_ui8_n( uint32_t a )
{

    printf( "%02X\n", (unsigned int) a );
    if ( atEnd ) exit( 0 );

}

void writeHex_ui32_sp( uint32_t a )
{

    printf( "%08lX ", (unsigned long) a );

}

void writeHex_ui32_n( uint32_t a )
{

    printf( "%08lX\n", (unsigned long) a );
    if ( atEnd ) exit( 0 );

}

void writeHex_ui64_sp( uint32_t *aPtr )
{

    printf(
        "%08lX%08lX ", (unsigned long) aPtr[ 1 ], (unsigned long) aPtr[ 0 ] );

}

void writeHex_ui64_n( uint32_t *aPtr )
{

    printf(
        "%08lX%08lX\n", (unsigned long) aPtr[ 1 ], (unsigned long) aPtr[ 0 ] );
    if ( atEnd ) exit( 0 );

}

