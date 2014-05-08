
#include <stdint.h>

enum {
    UI32_TO_F32 = 1,
    UI32_TO_F64,
#ifdef FLOATX80
    UI32_TO_FX80,
#endif
#ifdef FLOAT128
    UI32_TO_F128,
#endif
    UI64_TO_F32,
    UI64_TO_F64,
#ifdef FLOATX80
    UI64_TO_FX80,
#endif
#ifdef FLOAT128
    UI64_TO_F128,
#endif
    I32_TO_F32,
    I32_TO_F64,
#ifdef FLOATX80
    I32_TO_FX80,
#endif
#ifdef FLOAT128
    I32_TO_F128,
#endif
    I64_TO_F32,
    I64_TO_F64,
#ifdef FLOATX80
    I64_TO_FX80,
#endif
#ifdef FLOAT128
    I64_TO_F128,
#endif
    F32_TO_UI32,
    F32_TO_UI64,
    F32_TO_I32,
    F32_TO_I64,
    F32_TO_UI32_R_MINMAG,
    F32_TO_UI64_R_MINMAG,
    F32_TO_I32_R_MINMAG,
    F32_TO_I64_R_MINMAG,
    F32_TO_F64,
#ifdef FLOATX80
    F32_TO_FX80,
#endif
#ifdef FLOAT128
    F32_TO_F128,
#endif
    F32_ROUNDTOINT,
    F32_ADD,
    F32_SUB,
    F32_MUL,
    F32_MULADD,
    F32_DIV,
    F32_REM,
    F32_SQRT,
    F32_EQ,
    F32_LE,
    F32_LT,
    F32_EQ_SIGNALING,
    F32_LE_QUIET,
    F32_LT_QUIET,
    F64_TO_UI32,
    F64_TO_UI64,
    F64_TO_I32,
    F64_TO_I64,
    F64_TO_UI32_R_MINMAG,
    F64_TO_UI64_R_MINMAG,
    F64_TO_I32_R_MINMAG,
    F64_TO_I64_R_MINMAG,
    F64_TO_F32,
#ifdef FLOATX80
    F64_TO_FX80,
#endif
#ifdef FLOAT128
    F64_TO_F128,
#endif
    F64_ROUNDTOINT,
    F64_ADD,
    F64_SUB,
    F64_MUL,
    F64_MULADD,
    F64_DIV,
    F64_REM,
    F64_SQRT,
    F64_EQ,
    F64_LE,
    F64_LT,
    F64_EQ_SIGNALING,
    F64_LE_QUIET,
    F64_LT_QUIET,
#ifdef FLOATX80
    FX80_TO_UI32,
    FX80_TO_UI64,
    FX80_TO_I32,
    FX80_TO_I64,
    FX80_TO_UI32_R_MINMAG,
    FX80_TO_UI64_R_MINMAG,
    FX80_TO_I32_R_MINMAG,
    FX80_TO_I64_R_MINMAG,
    FX80_TO_F32,
    FX80_TO_F64,
#ifdef FLOAT128
    FX80_TO_F128,
#endif
    FX80_ROUNDTOINT,
    FX80_ADD,
    FX80_SUB,
    FX80_MUL,
    FX80_MULADD,
    FX80_DIV,
    FX80_REM,
    FX80_SQRT,
    FX80_EQ,
    FX80_LE,
    FX80_LT,
    FX80_EQ_SIGNALING,
    FX80_LE_QUIET,
    FX80_LT_QUIET,
#endif
#ifdef FLOAT128
    F128_TO_UI32,
    F128_TO_UI64,
    F128_TO_I32,
    F128_TO_I64,
    F128_TO_UI32_R_MINMAG,
    F128_TO_UI64_R_MINMAG,
    F128_TO_I32_R_MINMAG,
    F128_TO_I64_R_MINMAG,
    F128_TO_F32,
    F128_TO_F64,
#ifdef FLOATX80
    F128_TO_FX80,
#endif
    F128_ROUNDTOINT,
    F128_ADD,
    F128_SUB,
    F128_MUL,
    F128_MULADD,
    F128_DIV,
    F128_REM,
    F128_SQRT,
    F128_EQ,
    F128_LE,
    F128_LT,
    F128_EQ_SIGNALING,
    F128_LE_QUIET,
    F128_LT_QUIET,
#endif
    NUM_FUNCTIONS
};

enum {
    ROUND_NEAREST_EVEN = 1,
    ROUND_MINMAG,
    ROUND_MIN,
    ROUND_MAX,
    ROUND_NEAREST_MAXMAG,
    NUM_ROUNDINGMODES
};
enum {
    TININESS_BEFORE_ROUNDING = 1,
    TININESS_AFTER_ROUNDING,
    NUM_TININESSMODES
};

extern const int_fast8_t roundingModes[ NUM_ROUNDINGMODES ];
extern const int_fast8_t tininessModes[ NUM_TININESSMODES ];

enum {
    FUNC_ARG_UNARY                    = 0x01,
    FUNC_ARG_BINARY                   = 0x02,
    FUNC_ARG_ROUNDINGMODE             = 0x04,
    FUNC_ARG_EXACT                    = 0x08,
    FUNC_EFF_ROUNDINGPRECISION        = 0x10,
    FUNC_EFF_ROUNDINGMODE             = 0x20,
    FUNC_EFF_TININESSMODE             = 0x40,
    FUNC_EFF_TININESSMODE_REDUCEDPREC = 0x80
};
struct functionInfo {
    const char *namePtr;
    unsigned char attribs;
};
extern const struct functionInfo functionInfos[ NUM_FUNCTIONS ];

struct standardFunctionInfo {
    const char *namePtr;
    unsigned char functionCode;
    char roundingCode, exact;
};
extern const struct standardFunctionInfo standardFunctionInfos[];

