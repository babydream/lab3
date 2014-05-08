
#include <stdint.h>
#include <stdio.h>

static int normDistance( uint16_t x )
{
    int dist;

    if ( ! x ) return 15;
    for ( dist = 0; ! ( x>>15 ); ++dist, x <<= 1 );
    return dist;

}

static int estNormDistancePos( uint16_t a, uint16_t b )
{
    uint16_t ps, notKs;

    if ( ( a & 0xC000 ) || ( b & 0xC000 ) ) return 0;
    ps = a ^ b;
    notKs = a | b;
    return normDistance( ps ^ ( notKs<<1 ) );

}

int main( void )
{
    uint_fast16_t a, b;
    int_fast32_t sum;
    int normDist, estNormDist;

    a = 0;
    for (;;) {
        printf( "%04lX\n", (unsigned int) a );
        b = 0;
        for (;;) {
            sum = a + b;
            if ( sum <= 0xFFFF ) {
                normDist = normDistance( sum );
                estNormDist = estNormDistancePos( a, b );
                if (
                       ( estNormDist < normDist - 1 )
                    || ( normDist < estNormDist )
                ) {
                    printf(
  "%04lX  %04lX  %04lX  %2d  %2d\n"
  "  ps = %04lX, ks<<1 = %04lX\n",
                        (unsigned int) a,
                        (unsigned int) b,
                        (unsigned int) sum,
                        normDist,
                        estNormDist,
                        (unsigned int) ( a ^ b ),
                        (unsigned int) (uint16_t) ( ( ~ a & ~ b )<<1 | 1 )
                    );
                    return 0;
                }
            }
            if ( b == 0xFFFF ) break;
            ++b;
        }
        if ( a == 0xFFFF ) break;
        ++a;
    }
    return 0;

}

