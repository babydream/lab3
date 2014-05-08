
SOURCE_DIR = ../../source
PLATFORM_TYPE = 8086

C_INCLUDES = -I. -I$(SOURCE_DIR)/$(PLATFORM_TYPE) -I$(SOURCE_DIR)
COMPILE_C = \
  gcc -c -Werror-implicit-function-declaration \
    -DINLINE_LEVEL=9 "-DINLINE=extern inline" $(C_INCLUDES) -I- -O2 -o $@
MAKELIB = ar crs $@
DELETE = rm -f

OBJ = .o
LIB = .a

.PHONY: all
all: softfloat$(LIB)

OBJS_PRIMITIVES = \
  s_eq128$(OBJ) \
  s_le128$(OBJ) \
  s_lt128$(OBJ) \
  s_shortShift128Left$(OBJ) \
  s_shortShift192Left$(OBJ) \
  s_shift32RightJam$(OBJ) \
  s_shortShift32Right1Jam$(OBJ) \
  s_shift64RightJam$(OBJ) \
  s_shortShift64RightJam$(OBJ) \
  s_shift64ExtraRightJam$(OBJ) \
  s_shortShift64ExtraRightJam$(OBJ) \
  s_shortShift128Right$(OBJ) \
  s_shift128RightJam$(OBJ) \
  s_shift128ExtraRightJam$(OBJ) \
  s_shortShift128ExtraRightJam$(OBJ) \
  s_countLeadingZeros8$(OBJ) \
  s_countLeadingZeros32$(OBJ) \
  s_countLeadingZeros64$(OBJ) \
  s_add128$(OBJ) \
  s_add192$(OBJ) \
  s_sub128$(OBJ) \
  s_sub192$(OBJ) \
  s_mul64To128$(OBJ) \
  s_mul128By64To192$(OBJ) \
  s_mul128To256$(OBJ) \
  s_estimateDiv128To64$(OBJ) \
  s_estimateSqrt32$(OBJ) \

OBJS_SPECIALIZE = \
  softfloat_raiseFlags$(OBJ) \
  s_isSigNaNF32UI$(OBJ) \
  s_f32UIToCommonNaN$(OBJ) \
  s_commonNaNToF32UI$(OBJ) \
  s_propagateNaNF32UI$(OBJ) \
  s_isSigNaNF64UI$(OBJ) \
  s_f64UIToCommonNaN$(OBJ) \
  s_commonNaNToF64UI$(OBJ) \
  s_propagateNaNF64UI$(OBJ) \

OBJS_OTHERS = \
  s_roundPackToUI32$(OBJ) \
  s_roundPackToUI64$(OBJ) \
  s_roundPackToI32$(OBJ) \
  s_roundPackToI64$(OBJ) \
  s_normSubnormalF32Sig$(OBJ) \
  s_roundPackToF32$(OBJ) \
  s_normRoundPackToF32$(OBJ) \
  s_addMagsF32$(OBJ) \
  s_subMagsF32$(OBJ) \
  s_mulAddF32$(OBJ) \
  s_normSubnormalF64Sig$(OBJ) \
  s_roundPackToF64$(OBJ) \
  s_normRoundPackToF64$(OBJ) \
  s_addMagsF64$(OBJ) \
  s_subMagsF64$(OBJ) \
  s_mulAddF64$(OBJ) \
  softfloat_state$(OBJ) \
  ui32_to_f32$(OBJ) \
  ui32_to_f64$(OBJ) \
  ui64_to_f32$(OBJ) \
  ui64_to_f64$(OBJ) \
  i32_to_f32$(OBJ) \
  i32_to_f64$(OBJ) \
  i64_to_f32$(OBJ) \
  i64_to_f64$(OBJ) \
  f32_to_ui32$(OBJ) \
  f32_to_ui64$(OBJ) \
  f32_to_i32$(OBJ) \
  f32_to_i64$(OBJ) \
  f32_to_ui32_r_minMag$(OBJ) \
  f32_to_ui64_r_minMag$(OBJ) \
  f32_to_i32_r_minMag$(OBJ) \
  f32_to_i64_r_minMag$(OBJ) \
  f32_to_f64$(OBJ) \
  f32_roundToInt$(OBJ) \
  f32_add$(OBJ) \
  f32_sub$(OBJ) \
  f32_mul$(OBJ) \
  f32_mulAdd$(OBJ) \
  f32_div$(OBJ) \
  f32_rem$(OBJ) \
  f32_sqrt$(OBJ) \
  f32_eq$(OBJ) \
  f32_le$(OBJ) \
  f32_lt$(OBJ) \
  f32_eq_signaling$(OBJ) \
  f32_le_quiet$(OBJ) \
  f32_lt_quiet$(OBJ) \
  f32_isSignalingNaN$(OBJ) \
  f64_to_ui32$(OBJ) \
  f64_to_ui64$(OBJ) \
  f64_to_i32$(OBJ) \
  f64_to_i64$(OBJ) \
  f64_to_ui32_r_minMag$(OBJ) \
  f64_to_ui64_r_minMag$(OBJ) \
  f64_to_i32_r_minMag$(OBJ) \
  f64_to_i64_r_minMag$(OBJ) \
  f64_to_f32$(OBJ) \
  f64_roundToInt$(OBJ) \
  f64_add$(OBJ) \
  f64_sub$(OBJ) \
  f64_mul$(OBJ) \
  f64_mulAdd$(OBJ) \
  f64_div$(OBJ) \
  f64_rem$(OBJ) \
  f64_sqrt$(OBJ) \
  f64_eq$(OBJ) \
  f64_le$(OBJ) \
  f64_lt$(OBJ) \
  f64_eq_signaling$(OBJ) \
  f64_le_quiet$(OBJ) \
  f64_lt_quiet$(OBJ) \
  f64_isSignalingNaN$(OBJ) \

OBJS_ALL = $(OBJS_PRIMITIVES) $(OBJS_SPECIALIZE) $(OBJS_OTHERS)

$(OBJS_ALL): \
  $(SOURCE_DIR)/$(PLATFORM_TYPE)/platform.h $(SOURCE_DIR)/primitives.h
$(OBJS_SPECIALIZE) $(OBJS_OTHERS): \
  $(SOURCE_DIR)/$(PLATFORM_TYPE)/softfloat_types.h $(SOURCE_DIR)/internals.h \
  $(SOURCE_DIR)/$(PLATFORM_TYPE)/specialize.h $(SOURCE_DIR)/softfloat.h

$(OBJS_PRIMITIVES) $(OBJS_OTHERS): %.o: $(SOURCE_DIR)/%.c
	$(COMPILE_C) $(SOURCE_DIR)/$*.c

$(OBJS_SPECIALIZE): %.o: $(SOURCE_DIR)/$(PLATFORM_TYPE)/%.c
	$(COMPILE_C) $(SOURCE_DIR)/$(PLATFORM_TYPE)/$*.c

softfloat$(LIB): $(OBJS_ALL)
	$(MAKELIB) $^

.PHONY: clean
clean:
	$(DELETE) $(OBJS_ALL) softfloat$(LIB)

