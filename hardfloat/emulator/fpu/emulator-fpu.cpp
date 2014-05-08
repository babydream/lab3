#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "emulator.h"
#include "fpu_tst_f64_to_f32.h"
#include "fpu_tst_f32_to_f64.h"
#include "fpu_tst_muladd64.h"
#include "fpu_tst_muladd32.h"
#include "fpu_tst_addsub32.h"
#include "fpu_tst_addsub64.h"
#include "fpu_tst_mul32.h"
#include "fpu_tst_mul64.h"
#include "fpu_tst_compareFloat32.h"
#include "fpu_tst_compareFloat64.h"

int main (int argc, char* argv[]) {
  char* arg = argv[1];
  if (argc < 2) {
    fprintf(stderr, "MISSING TEST NAME: MULADD64, F64-TO-I64, CMP64, F64-TO-F64\n");
    exit(-1);
  }
  if (strcasecmp(arg, "f64_mulAdd") == 0) {
    fpu_tst_muladd64_t *c = new fpu_tst_muladd64_t();
    c->init();
    for (int t = 0; ; t++) {
      int reset = (t == 0);
      uint64_t a, b, cin, out, flags;
    
      int res = scanf("%llx %llx %llx %llx %llx", &a, &b, &cin, &out, &flags);
      if (res != 5)
        exit(0);
      c->fpu_tst_muladd64__io_a = LIT<64>(a);
      c->fpu_tst_muladd64__io_b = LIT<64>(b);
      c->fpu_tst_muladd64__io_c = LIT<64>(cin);
      c->fpu_tst_muladd64__io_rounding_mode = LIT<2>(0);
      c->fpu_tst_muladd64__io_op = LIT<1>(0);
      c->clock_lo(LIT<1>(reset));
      c->clock_hi(LIT<1>(reset));
      uint64_t fpu_out   = c->fpu_tst_muladd64__io_out.lo_word();
      uint64_t fpu_flags = c->fpu_tst_muladd64__io_exception_flags.lo_word();
      printf("%016llx %016llx %016llx %016llx %02llx\n", a, b, cin, fpu_out, fpu_flags);
    }

  } else if (strcasecmp(arg, "f32_mulAdd") == 0) {
    fpu_tst_muladd32_t *c = new fpu_tst_muladd32_t();
    c->init();
    for (int t = 0; ; t++) {
      int reset = (t == 0);
      uint64_t a, b, cin, out, flags;
    
      int res = scanf("%llx %llx %llx %llx %llx", &a, &b, &cin, &out, &flags);
      if (res != 5)
        exit(0);
      c->fpu_tst_muladd32__io_a = LIT<32>(a);
      c->fpu_tst_muladd32__io_b = LIT<32>(b);
      c->fpu_tst_muladd32__io_c = LIT<32>(cin);
      c->fpu_tst_muladd32__io_rounding_mode = LIT<2>(0);
      c->fpu_tst_muladd32__io_op = LIT<1>(0);
      c->clock_lo(LIT<1>(reset));
      c->clock_hi(LIT<1>(reset));
      uint64_t fpu_out   = c->fpu_tst_muladd32__io_out.lo_word();
      uint64_t fpu_flags = c->fpu_tst_muladd32__io_exception_flags.lo_word();
      printf("%08llx %08llx %08llx %08llx %02llx\n", a, b, cin, fpu_out, fpu_flags);
    }
  }else if (strcasecmp(arg, "f32_sub") == 0) {
    fpu_tst_addsub32_t *c = new fpu_tst_addsub32_t();
    c->init();
    for (int t = 0; ; t++) {
      int reset = (t == 0);
      uint64_t a, b, out, flags;
    
      int res = scanf("%llx %llx %llx %llx", &a, &b, &out, &flags);
      if (res != 4)
        exit(0);
      c->fpu_tst_addsub32__io_a = LIT<32>(a);
      c->fpu_tst_addsub32__io_b = LIT<32>(b);
      c->fpu_tst_addsub32__io_rounding_mode = LIT<2>(0);
      c->fpu_tst_addsub32__io_op = LIT<1>(1);
      c->clock_lo(LIT<1>(reset));
      c->clock_hi(LIT<1>(reset));
      uint64_t fpu_out   = c->fpu_tst_addsub32__io_out.lo_word();
      uint64_t fpu_flags = c->fpu_tst_addsub32__io_exception_flags.lo_word();
      printf("%08llx %08llx %08llx %02llx\n", a, b, fpu_out, fpu_flags);
    }
  }else if (strcasecmp(arg, "f32_mul") == 0) {
    fpu_tst_mul32_t *c = new fpu_tst_mul32_t();
    c->init();
    for (int t = 0; ; t++) {
      int reset = (t == 0);
      uint64_t a, b, out, flags;
    
      int res = scanf("%llx %llx %llx %llx", &a, &b, &out, &flags);
      if (res != 4)
        exit(0);
      c->fpu_tst_mul32__io_a = LIT<32>(a);
      c->fpu_tst_mul32__io_b = LIT<32>(b);
      c->fpu_tst_mul32__io_rounding_mode = LIT<2>(0);
      c->clock_lo(LIT<1>(reset));
      c->clock_hi(LIT<1>(reset));
      uint64_t fpu_out   = c->fpu_tst_mul32__io_out.lo_word();
      uint64_t fpu_flags = c->fpu_tst_mul32__io_exception_flags.lo_word();
      printf("%08llx %08llx %08llx %02llx\n", a, b, fpu_out, fpu_flags);
    }
  }else if (strcasecmp(arg, "f64_add") == 0) {
    fpu_tst_addsub64_t *c = new fpu_tst_addsub64_t();
    c->init();
    for (int t = 0; ; t++) {
      int reset = (t == 0);
      uint64_t a, b, out, flags;
    
      int res = scanf("%llx %llx %llx %llx", &a, &b, &out, &flags);
      if (res != 4)
        exit(0);
      c->fpu_tst_addsub64__io_a = LIT<64>(a);
      c->fpu_tst_addsub64__io_b = LIT<64>(b);
      c->fpu_tst_addsub64__io_rounding_mode = LIT<2>(0);
      c->fpu_tst_addsub64__io_op = LIT<1>(0);
      c->clock_lo(LIT<1>(reset));
      c->clock_hi(LIT<1>(reset));
      uint64_t fpu_out   = c->fpu_tst_addsub64__io_out.lo_word();
      uint64_t fpu_flags = c->fpu_tst_addsub64__io_exception_flags.lo_word();
      printf("%016llx %016llx %016llx %02llx\n", a, b, fpu_out, fpu_flags);
    }
  }else if (strcasecmp(arg, "f64_mul") == 0) {
    fpu_tst_mul64_t *c = new fpu_tst_mul64_t();
    c->init();
    for (int t = 0; ; t++) {
      int reset = (t == 0);
      uint64_t a, b, out, flags;
    
      int res = scanf("%llx %llx %llx %llx", &a, &b, &out, &flags);
      if (res != 4)
        exit(0);
      c->fpu_tst_mul64__io_a = LIT<64>(a);
      c->fpu_tst_mul64__io_b = LIT<64>(b);
      c->fpu_tst_mul64__io_rounding_mode = LIT<2>(0);
      c->clock_lo(LIT<1>(reset));
      c->clock_hi(LIT<1>(reset));
      uint64_t fpu_out   = c->fpu_tst_mul64__io_out.lo_word();
      uint64_t fpu_flags = c->fpu_tst_mul64__io_exception_flags.lo_word();
      printf("%016llx %016llx %016llx %02llx\n", a, b, fpu_out, fpu_flags);
    }
  } else if (strcasecmp(arg, "f64_to_f32") == 0) {
    fpu_tst_f64_to_f32_t *c = new fpu_tst_f64_to_f32_t();
    c->init();
    for (int t = 0; ; t++) {
      int reset = (t == 0);
      uint64_t in, out, flags;
    
      int res = scanf("%llx %llx %llx", &in, &out, &flags);
      //printf("IN = 0x%llx OUT = 0x%llx FLAGS = 0x%llx\n", in, out, flags);
      if (res != 3)
        exit(0);
      c->fpu_tst_f64_to_f32__io_in = LIT<64>(in);
      c->fpu_tst_f64_to_f32__io_rounding_mode = LIT<2>(0);
      c->clock_lo(LIT<1>(reset));
      c->clock_hi(LIT<1>(reset));
      uint64_t fpu_out   = c->fpu_tst_f64_to_f32__io_out.lo_word();
      uint64_t fpu_flags = c->fpu_tst_f64_to_f32__io_exception_flags.lo_word();
      printf("%016llx %08llx %02llx\n", in, fpu_out, fpu_flags);
    }
  } else if (strcasecmp(arg, "f32_to_f64") == 0){
    fpu_tst_f32_to_f64_t *c = new fpu_tst_f32_to_f64_t();
    c->init();
    for (int t = 0; ; t++) {
      int reset = (t == 0);
      uint64_t in, out, flags;
    
      int res = scanf("%llx %llx %llx", &in, &out, &flags);
      //printf("IN = 0x%llx OUT = 0x%llx FLAGS = 0x%llx\n", in, out, flags);
      if (res != 3)
        exit(0);
      /*
        int res = scanf("%llx", &in);
        out = in; flags = 0;
        // printf("IN = 0x%llx OUT = 0x%llx FLAGS = 0x%llx\n", in, in, flags);
        if (res != 1)
        exit(0);
      */
      c->fpu_tst_f32_to_f64__io_in = LIT<32>(in);
      c->clock_lo(LIT<1>(reset));
      c->clock_hi(LIT<1>(reset));
      uint64_t fpu_out   = c->fpu_tst_f32_to_f64__io_out.lo_word();
      uint64_t fpu_flags = c->fpu_tst_f32_to_f64__io_exception_flags.lo_word();
      printf("%08llx %016llx %02llx\n", in, fpu_out, fpu_flags);
    }
  } else if (strcasecmp(arg, "f32_eq_signaling") == 0 || strcasecmp(arg, "f32_lt") == 0 || strcasecmp(arg, "f32_le") == 0){
    fpu_tst_compareFloat32_t *c = new fpu_tst_compareFloat32_t();
    c->init();
    for (int t = 0; ; t++) {
      int reset = (t == 0);
      uint64_t a, b, less, equal, flags;
    
      int res;
      
      if(strcasecmp(arg, "f32_lt") == 0){
	res = scanf("%llx %llx %llx %llx", &a, &b, &less, &flags);
      } else if (strcasecmp(arg, "f32_eq_signaling") == 0){
	res = scanf("%llx %llx %llx %llx", &a, &b, &equal, &flags);
      } else if (strcasecmp(arg, "f32_le") == 0){
	res = scanf("%llx %llx %llx %llx", &a, &b, &equal, &flags);
      }
      //printf("IN = 0x%llx OUT = 0x%llx FLAGS = 0x%llx\n", in, out, flags);
      if (res != 4)
        exit(0);

      c->fpu_tst_compareFloat32__io_a = LIT<32>(a);
      c->fpu_tst_compareFloat32__io_b = LIT<32>(b);
      c->clock_lo(LIT<1>(reset));
      c->clock_hi(LIT<1>(reset));

      uint64_t fpu_less      = c->fpu_tst_compareFloat32__io_less.lo_word();
      uint64_t fpu_equal     = c->fpu_tst_compareFloat32__io_equal.lo_word();
      uint64_t fpu_lessOrEqual = c->fpu_tst_compareFloat32__io_lessOrEqual.lo_word();
      uint64_t fpu_eq_ex     = c->fpu_tst_compareFloat32__io_eq_exception.lo_word();
      uint64_t fpu_lt_ex     = c->fpu_tst_compareFloat32__io_lt_exception.lo_word();
      uint64_t fpu_lte_ex     = c->fpu_tst_compareFloat32__io_lte_exception.lo_word();
      
      if(strcasecmp(arg, "f32_lt") == 0){
	printf("%08llx %08llx %01llx %02llx\n", a, b, fpu_less, fpu_lt_ex);
      } else if (strcasecmp(arg, "f632_eq_signaling") ==0){
	printf("%08llx %08llx %01llx %02llx\n", a, b, fpu_equal, fpu_eq_ex);
      } else if (strcasecmp(arg, "f32_le") == 0){
	printf("%08llx %08llx %01llx %02llx\n", a, b, fpu_lessOrEqual, fpu_lte_ex);
      }
    }
  } else if (strcasecmp(arg, "f64_eq_signaling") == 0 || strcasecmp(arg, "f64_le") == 0 || strcasecmp(arg, "f64_lt") == 0){
    fpu_tst_compareFloat64_t *c = new fpu_tst_compareFloat64_t();
    c->init();
    for (int t = 0; ; t++) {
      int reset = (t == 0);
      uint64_t a, b, less, equal, flags;
    
      int res;
      
      if(strcasecmp(arg, "f64_lt") == 0){
	res = scanf("%llx %llx %llx %llx", &a, &b, &less, &flags);
      } else if (strcasecmp(arg, "f64_eq_signaling") == 0){
	res = scanf("%llx %llx %llx %llx", &a, &b, &equal, &flags);
      } else if (strcasecmp(arg, "f64_le") == 0){
	res = scanf("%llx %llx %llx %llx", &a, &b, &equal, &flags);
      }
      //printf("IN = 0x%llx OUT = 0x%llx FLAGS = 0x%llx\n", in, out, flags);
      if (res != 4)
        exit(0);

      c->fpu_tst_compareFloat64__io_a = LIT<64>(a);
      c->fpu_tst_compareFloat64__io_b = LIT<64>(b);
      c->clock_lo(LIT<1>(reset));
      c->clock_hi(LIT<1>(reset));

      uint64_t fpu_less      = c->fpu_tst_compareFloat64__io_less.lo_word();
      uint64_t fpu_equal     = c->fpu_tst_compareFloat64__io_equal.lo_word();
      uint64_t fpu_lessOrEqual = c->fpu_tst_compareFloat64__io_lessOrEqual.lo_word();
      uint64_t fpu_eq_ex     = c->fpu_tst_compareFloat64__io_eq_exception.lo_word();
      uint64_t fpu_lt_ex     = c->fpu_tst_compareFloat64__io_lt_exception.lo_word();
      uint64_t fpu_lte_ex     = c->fpu_tst_compareFloat64__io_lte_exception.lo_word();
      
      if(strcasecmp(arg, "f64_lt") == 0){
	printf("%016llx %016llx %01llx %02llx\n", a, b, fpu_less, fpu_lt_ex);
      } else if (strcasecmp(arg, "f64_eq_signaling") ==0){
	printf("%016llx %016llx %01llx %02llx\n", a, b, fpu_equal, fpu_eq_ex);
      } else if (strcasecmp(arg, "f64_le") == 0){
	printf("%016llx %016llx %01llx %02llx\n", a, b, fpu_lessOrEqual, fpu_lte_ex);
      }
    }
  }
}

