#include <unistd.h>
#include <fcntl.h>
#include "common.h"
#include "emulator.h"
#include "float64ToAny.h"

#define DISPLAY(var) \
	  printf("DBG %s: %16llx\n", \
		 #var, c->var.values[0])
#define DISPLAY2(var) \
	  printf("DBG %s: %llx%016llx\n", \
		 #var, c->var.values[1], c->var.values[0])

static void test_f64_to_int(int typeOp, int roundingMode) {
      float64ToAny_t *c = new float64ToAny_t();
      c->init();
      int successes = 0;
      int t;

      for (t = 0; ; t++) {
	  int reset = (t == 0);
	  uint64_t in, out, flags;
	  int res = scanf("%llx %llx %llx", &in, &out, &flags);
	  if (res != 3) break;

	  c->float64ToAny_in = LIT<64>(in);
	  c->float64ToAny_roundingMode = LIT<2>(roundingMode);
	  c->float64ToAny_typeOp = LIT<2>(typeOp);

	  c->clock_lo(LIT<1>(reset));
	  c->clock_hi(LIT<1>(reset));

	  uint64_t sim_out = c->float64ToAny_out.lo_word();
	  if (typeOp == 1) {
	      // Clip a signed int32 for printing purposes.
	      sim_out &= 0xffffffff;
	  }
	  uint64_t sim_flags = c->float64ToAny_exceptionFlags.lo_word();

	  // Do not print results if the computation is correct.
	  if (sim_out == out && (sim_flags & 0x1f) == flags) {
	      successes++;
	      continue;
	  }

	  printf("RES %016llx %08llx %02llx\n", in, sim_out, 0x1f & sim_flags);
	  printf("EXP %016llx %08llx %02llx\n", in, out, flags);

	  uint64_t rec_in = c->recodedFloat64ToAny_in.lo_word();

	  DISPLAY(recodedFloat64ToAny_isValidShift);
	  DISPLAY(recodedFloat64ToAny_shift_count);
	  DISPLAY2(recodedFloat64ToAny_in);
	  DISPLAY2(recodedFloat64ToAny_absolute_int);
	  DISPLAY(recodedFloat64ToAny_lsbs);
      }
      printf("Passed %d of %d tests\n", successes, t);
      exit(0);
}

int main (int argc, char* argv[]) {
  char* arg = argv[1];
  if (argc != 2) {
    fprintf(stderr, "MISSING TEST NAME: f64_to_ui32_r_near_even f64_to_i32_r_near_even f64_to_ui64_r_near_even f64_to_i64_r_near_even\n");
    exit(-1);
  }

  if (strcasecmp(arg, "f64_to_ui32_r_near_even") == 0) {
      test_f64_to_int(0, 0); /* int typeOp, int roundingMode */
  } else if (strcasecmp(arg, "f64_to_i32_r_near_even") == 0) {
      test_f64_to_int(1, 0); /* int typeOp, int roundingMode */
  } else if (strcasecmp(arg, "f64_to_ui64_r_near_even") == 0) {
      test_f64_to_int(2, 0); /* int typeOp, int roundingMode */
  } else if (strcasecmp(arg, "f64_to_i64_near_even") == 0) {
      test_f64_to_int(3, 0); /* int typeOp, int roundingMode */
  } else {
      printf("Unrecognized option: %s\n", arg);
      exit (-1);
  }
}

