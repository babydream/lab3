
#include <stdint.h>
#include <stdio.h>

static int normDistance( uint16_t x )
{
    int dist;

    if ( ! x ) return 15;
    for ( dist = 0; ! ( x>>15 ); ++dist, x <<= 1 );
    return dist;

}

static int normDistanceAbs( uint16_t x )
{

    return normDistance( x>>15 ? - x : x );

}

static int estNormDistanceNeg( uint16_t a, uint16_t b )
{
    uint16_t ps, gs;

    ps = a ^ b;
    gs = a & b;
    return normDistance( ~ ( ps ^ ( gs<<1 ) ) );

}

static int estNormDistancePos( uint16_t a, uint16_t b )
{
    uint16_t ps, notKs;

    ps = a ^ b;
    notKs = a | b;
    return normDistance( ps ^ ( notKs<<1 ) );

}

static int isNegInvo2( uint16_t x )
{

    if ( ! ( x>>15 ) ) return 0;
    return ( ( - x & x ) == (uint16_t) - x );

}

int main( void )
{
    int_fast16_t a, b;
    union { uint16_t ui; int16_t i; } u16;
    int normDist, estNormDist;

    a = -0x8000;
    for (;;) {
        printf( "%04lX\n", (unsigned int) (uint16_t) a );
        b = -0x8000;
        for (;;) {
            u16.ui = (uint_fast16_t) a + (uint_fast16_t) b;
            if ( u16.ui && ( u16.i == (int_fast32_t) a + b ) ) {
                normDist = normDistanceAbs( u16.ui );
                estNormDist =
                    ( ( u16.i < 0 ) ? estNormDistanceNeg
                          : estNormDistancePos )(
                        a, b );
                if (
                       ( estNormDist < normDist - 1 )
                    || ( normDist < estNormDist )
                ) {
                    if (
                        ! isNegInvo2( u16.ui ) || estNormDist != normDist + 1
                    ) {
                        printf(
  "%04lX  %04lX  %04lX  %2d  %2d\n"
  "  ps = %04lX, gs<<1 = %04lX, ks<<1 = %04lX, neg est = %2d, pos est = %2d\n",
                            (unsigned int) (uint16_t) a,
                            (unsigned int) (uint16_t) b,
                            (unsigned int) u16.ui,
                            normDist,
                            estNormDist,
                            (unsigned int) (uint16_t) ( a ^ b ),
                            (unsigned int) (uint16_t) ( ( a & b )<<1 ),
                            (unsigned int) (uint16_t) ( ( ~ a & ~ b )<<1 | 1 ),
                            estNormDistanceNeg( a, b ),
                            estNormDistancePos( a, b )
                        );
                        return 0;
                    }
                }
            }
            if ( b == 0x7FFF ) break;
            ++b;
        }
        if ( a == 0x7FFF ) break;
        ++a;
    }
    return 0;

}

