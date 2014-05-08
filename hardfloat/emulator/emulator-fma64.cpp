#include <unistd.h>
#include <fcntl.h>
#include "common.h"
#include "emulator.h"
#include "mulAddSubFloat64.h"

#define DISPLAY(var) \
	  printf("DBG %s: %16llx\n", \
		 #var, c->var.values[0])
#define DISPLAY2(var) \
	  printf("DBG %s: %llx%016llx\n", \
		 #var, c->var.values[1], c->var.values[0])
#define DISPLAY3(var) \
	  printf("DBG %s: %llx%016llx%016llx\n", \
		 #var, c->var.values[2], c->var.values[1], c->var.values[0])

#define OP_ADD 0
#define OP_SUB 1

#define ROUND_NEAREST_EVEN 0
#define ROUND_MINMAG       1
#define ROUND_MIN          2
#define ROUND_MAX          3

static void test_fma64(int compare_op, int rounding_mode) {
      mulAddSubFloat64_t *c = new mulAddSubFloat64_t();
      c->init();
      int successes = 0;
      int t;

      for (t = 0; ; t++) {
	  int reset = (t == 0);
	  uint64_t a_in, b_in, c_in;
	  uint64_t exception_flags, out;
	  uint64_t sim_flags, sim_out;

	  // Read stimulus and expected results:
	  int res = scanf("%llx %llx %llx %llx %llx", &a_in, &b_in, &c_in, &out, &exception_flags);
	  if (res != 5) break;

	  c->mulAddSubFloat64_op = LIT<1>(compare_op);
	  c->mulAddSubFloat64_a  = LIT<64>(a_in);
	  c->mulAddSubFloat64_b  = LIT<64>(b_in);
	  c->mulAddSubFloat64_c  = LIT<64>(c_in);
	  c->mulAddSubFloat64_rounding_mode = LIT<2>(rounding_mode);

	  c->clock_lo(LIT<1>(reset));
	  c->clock_hi(LIT<1>(reset));

	  sim_out   = c->mulAddSubFloat64_out.lo_word();
	  sim_flags = c->mulAddSubFloat64_exception_flags.lo_word();

	  
	  printf("%016llx %016llx %016llx %016llx %02llx\n",
		 a_in, b_in, c_in, sim_out, sim_flags & 0x1f);

	  continue;

	  // Do not print results if the computation is correct.
	  if (sim_out == out && sim_flags == exception_flags) {
	      successes++;
	      continue;
	  }

	  printf("RES %016llx %016llx %016llx %016llx %02llx\n",
		 a_in, b_in, c_in, sim_out, sim_flags);
	  printf("EXP %016llx %016llx %016llx %016llx %02llx\n",
		 a_in, b_in, c_in, out, exception_flags);
      }

      // printf("Passed %d of %d tests\n", successes, t);
      exit(0);
}

int main (int argc, char* argv[]) {
  char* arg = argv[1];
  if (argc != 2) {
    fprintf(stderr, "MISSING TEST NAME: f64_mulAdd f64_mulSub\n");
    exit(-1);
  }

  if (strcasecmp(arg, "f64_mulAdd") == 0) {
      test_fma64(OP_ADD, ROUND_NEAREST_EVEN);
  } else if (strcasecmp(arg, "f64_mulSub") == 0) {
      test_fma64(OP_SUB, ROUND_NEAREST_EVEN);
  } else {
      printf("Unrecognized option: %s\n", arg);
      exit (-1);
  }
}
