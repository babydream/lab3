#include <unistd.h>
#include <fcntl.h>
#include "common.h"
#include "emulator.h"
#include "float64Compare.h"

#define DISPLAY(var) \
	  printf("DBG %s: %16llx\n", \
		 #var, c->var.values[0])
#define DISPLAY2(var) \
	  printf("DBG %s: %llx%016llx\n", \
		 #var, c->var.values[1], c->var.values[0])

#define OP_EQ 0
#define OP_LT 1
#define OP_LE 2

static void test_f64_compare(int compareOp) {
      float64Compare_t *c = new float64Compare_t();
      c->init();
      int successes = 0;
      int t;

      for (t = 0; ; t++) {
	  int reset = (t == 0);
	  uint64_t a_in, b_in;
	  uint64_t cmp_result, flags;
	  uint64_t sim_cmp_result, sim_flags;

	  // Read stimulus and expected results:
	  int res = scanf("%llx %llx %llx %llx", &a_in, &b_in, &cmp_result, &flags);
	  if (res != 4) break;

	  c->float64Compare_a_in = LIT<64>(a_in);
	  c->float64Compare_b_in = LIT<64>(b_in);

	  c->clock_lo(LIT<1>(reset));
	  c->clock_hi(LIT<1>(reset));

	  switch (compareOp) {
	  case OP_EQ:
	      sim_cmp_result = c->float64Compare_a_eq_b.lo_word();
	      sim_flags =      c->float64Compare_a_eq_b_invalid.lo_word() << 4;
	      break;
	  case OP_LT:
	      sim_cmp_result = c->float64Compare_a_lt_b.lo_word();
	      sim_flags =      c->float64Compare_a_lt_b_invalid.lo_word() << 4;
	      break;
	  case OP_LE:
	      sim_cmp_result = c->float64Compare_a_lt_b.lo_word() ||
		               c->float64Compare_a_eq_b.lo_word();
	      sim_flags =      c->float64Compare_a_lt_b_invalid.lo_word() << 4;
	      break;
	  default:
	      sim_cmp_result = 0;
	      sim_flags =      0;
	  }

	  // Do not print results if the computation is correct.
	  if (sim_cmp_result == cmp_result && sim_flags == flags) {
	      successes++;
	      continue;
	  }

	  printf("RES %016llx %016llx %02llx %01llx\n", a_in, b_in,
		 sim_cmp_result, sim_flags);
	  printf("EXP %016llx %016llx %02llx %01llx\n", a_in, b_in,
		 cmp_result, flags);
      }

      printf("Passed %d of %d tests\n", successes, t);
      exit(0);
}

int main (int argc, char* argv[]) {
  char* arg = argv[1];
  if (argc != 2) {
    fprintf(stderr, "MISSING TEST NAME: f64_eq f64_lt f64_le\n");
    exit(-1);
  }

  if (strcasecmp(arg, "f64_eq") == 0) {
      test_f64_compare(OP_EQ);
  } else if (strcasecmp(arg, "f64_lt") == 0) {
      test_f64_compare(OP_LT);
  } else if (strcasecmp(arg, "f64_le") == 0) {
      test_f64_compare(OP_LE);
  } else {
      printf("Unrecognized option: %s\n", arg);
      exit (-1);
  }
}
