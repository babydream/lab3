#include <unistd.h>
#include <fcntl.h>
#include "common.h"
#include "emulator.h"
#include "anyToFloat32.h"

#define DISPLAY(var) \
	  printf("DBG %s: %16llx\n", \
		 #var, c->var.values[0])
#define DISPLAY2(var) \
	  printf("DBG %s: %llx%016llx\n", \
		 #var, c->var.values[1], c->var.values[0])
    
static void test_int_to_f32(int typeOp, int roundingMode) {
      anyToFloat32_t *c = new anyToFloat32_t();
      c->init();
      int successes = 0;
      int t;

      for (t = 0; ; t++) {
	  int reset = (t == 0);
	  uint64_t in, out, flags;
	  int res = scanf("%llx %llx %llx", &in, &out, &flags);
	  if (res != 3) break;

	  c->anyToFloat32_in = LIT<64>(in);
	  c->anyToFloat32_roundingMode = LIT<2>(roundingMode);
	  c->anyToFloat32_typeOp = LIT<2>(typeOp);

	  c->clock_lo(LIT<1>(reset));
	  c->clock_hi(LIT<1>(reset));

	  uint64_t sim_out = c->anyToFloat32_out.lo_word();
	  uint64_t sim_flags = c->anyToFloat32_exceptionFlags.lo_word();

	  // Do not print results if the computation is correct.
	  if (sim_out == out && (sim_flags & 0x1f) == flags) {
	      successes++;
	      // continue;
	  }

	  if (typeOp == 0 || typeOp == 1) {
	    printf("%08llx %08llx %02llx\n", in, sim_out, 0x1f & sim_flags);
	  } else {
	    printf("%016llx %08llx %02llx\n", in, sim_out, 0x1f & sim_flags);
	  }
	  //printf("RES %016llx %016llx %02llx\n", in, sim_out, 0x1f & sim_flags);
	  //printf("EXP %016llx %016llx %02llx\n", in, out, flags);
      }
      //printf("Passed %d of %d tests\n", successes, t);
      exit(0);
}

int main (int argc, char* argv[]) {
  char* arg = argv[1];
  if (argc != 2) {
    fprintf(stderr, "MISSING TEST NAME: ui32_to_f32 i32_to_f32 ui64_to_f32 i64_to_f32\n");
    exit(-1);
  }

  if (strcasecmp(arg, "ui32_to_f32") == 0) {
      test_int_to_f32(0, 0); /* int typeOp, int roundingMode */
  } else if (strcasecmp(arg, "i32_to_f32") == 0) {
      test_int_to_f32(1, 0); /* int typeOp, int roundingMode */
  } else if (strcasecmp(arg, "ui64_to_f32") == 0) {
      test_int_to_f32(2, 0); /* int typeOp, int roundingMode */
  } else if (strcasecmp(arg, "i64_to_f32") == 0) {
      test_int_to_f32(3, 0); /* int typeOp, int roundingMode */
  } else {
      printf("Unrecognized option: %s\n", arg);
      exit (-1);
  }
}
