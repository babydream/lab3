
#include <stdint.h>
#include "softfloat.h"
#include "functions.h"

const int_fast8_t roundingModes[ NUM_ROUNDINGMODES ] = {
    0,
    softfloat_round_nearest_even,
    softfloat_round_minMag,
    softfloat_round_min,
    softfloat_round_max,
    softfloat_round_nearest_maxMag
};

const int_fast8_t tininessModes[ NUM_TININESSMODES ] = {
    0,
    softfloat_tininess_beforeRounding,
    softfloat_tininess_afterRounding
};

