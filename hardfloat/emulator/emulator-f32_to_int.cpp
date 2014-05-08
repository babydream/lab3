#include <unistd.h>
#include <fcntl.h>
#include "common.h"
#include "emulator.h"
#include "float32ToAny.h"

#define DISPLAY(var) \
	  printf("DBG %s: %16llx\n", \
		 #var, c->var.values[0])
#define DISPLAY2(var) \
	  printf("DBG %s: %llx%016llx\n", \
		 #var, c->var.values[1], c->var.values[0])

static void test_f32_to_int(int typeOp, int roundingMode) {
      float32ToAny_t *c = new float32ToAny_t();
      c->init();
      int successes = 0;
      int t;

      for (t = 0; ; t++) {
	  int reset = (t == 0);
	  uint64_t in, out, flags;
	  int res = scanf("%llx %llx %llx", &in, &out, &flags);
	  if (res != 3) break;

	  c->float32ToAny_in = LIT<32>(in);
	  c->float32ToAny_roundingMode = LIT<2>(roundingMode);
	  c->float32ToAny_typeOp = LIT<2>(typeOp);

	  c->clock_lo(LIT<1>(reset));
	  c->clock_hi(LIT<1>(reset));

	  uint64_t sim_out = c->float32ToAny_out.lo_word();
	  if (typeOp == 1 || typeOp == 0) {
	      // Clip a signed int32 for printing purposes.
	      sim_out &= 0xffffffff;
	  }
	  uint64_t sim_flags = c->float32ToAny_exceptionFlags.lo_word();

	  // Do not print results if the computation is correct.
	  if (sim_out == out && (sim_flags & 0x1f) == flags) {
	      successes++;
	      //continue;
	  }

	  if (typeOp == 1 || typeOp == 0) {
	    printf("%08llx %08llx %02llx\n", in, sim_out, 0x1f & sim_flags);
	  } else {
	    printf("%08llx %016llx %02llx\n", in, sim_out, 0x1f & sim_flags);
	  }
	  //printf("RES %08llx %016llx %02llx\n", in, sim_out, 0x1f & sim_flags);
	  //printf("EXP %08llx %016llx %02llx\n", in, out, flags);
      }

      // printf("Passed %d of %d tests\n", successes, t);
      exit(0);
}

int main (int argc, char* argv[]) {
  char* arg = argv[1];
  if (argc != 2) {
    fprintf(stderr, "MISSING TEST NAME: f32_to_ui32_r_near_even f32_to_i32_r_near_even f32_to_ui64_r_near_even f32_to_i64_r_near_even\n");
    exit(-1);
  }

  if (strcasecmp(arg, "f32_to_ui32_r_near_even") == 0) {
      test_f32_to_int(0, 0); /* int typeOp, int roundingMode */
  } else if (strcasecmp(arg, "f32_to_i32_r_near_even") == 0) {
      test_f32_to_int(1, 0); /* int typeOp, int roundingMode */
  } else if (strcasecmp(arg, "f32_to_ui64_r_near_even") == 0) {
      test_f32_to_int(2, 0); /* int typeOp, int roundingMode */
  } else if (strcasecmp(arg, "f32_to_i64_r_near_even") == 0) {
      test_f32_to_int(3, 0); /* int typeOp, int roundingMode */
  } else {
      printf("Unrecognized option: %s\n", arg);
      exit (-1);
  }
}
