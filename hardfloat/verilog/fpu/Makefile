
all: test-fma64 test-f32f64 test-fma32 test-f64f32 test-mul32 test-mul64 test-addsub32 test-addsub64

test-fma64: test-fma64.v fpu_tst_muladd64.v
	vcs -full64 +vc +v2k -timescale=10ns/10ps test-fma64.v fpu_tst_muladd64.v -o test-fma64
	rm -f -r vc_hdrs.h csrc
test-f32f64: test-f32f64.v fpu_tst_f32_to_f64.v
	vcs -full64 +vc +v2k -timescale=10ns/10ps test-f32f64.v fpu_tst_f32_to_f64.v -o test-f32f64 -q
	rm -f -r vc_hdrs.h csrc
test-fma32: test-fma32.v fpu_tst_muladd32.v
	vcs -full64 +vc +v2k -timescale=10ns/10ps test-fma32.v fpu_tst_muladd32.v -o test-fma32 -q
	rm -f -r vc_hdrs.h csrc
test-f64f32: test-f64f32.v fpu_tst_f64_to_f32.v
	vcs -full64 +vc +v2k -timescale=10ns/10ps test-f64f32.v fpu_tst_f64_to_f32.v -o test-f64f32 -q
	rm -f -r vc_hdrs.h csrc
test-mul32: test-mul32.v fpu_tst_mul32.v
	vcs -full64 +vc +v2k -timescale=10ns/10ps test-mul32.v fpu_tst_mul32.v -o test-mul32
	rm -f -r vc_hdrs.h csrc
test-mul64: test-mul64.v fpu_tst_mul64.v
	vcs -full64 +vc +v2k -timescale=10ns/10ps test-mul64.v fpu_tst_mul64.v -o test-mul64
	rm -f -r vc_hdrs.h csrc
test-addsub32: test-addsub32.v fpu_tst_addsub32.v
	vcs -full64 +vc +v2k -timescale=10ns/10ps test-addsub32.v fpu_tst_addsub32.v -o test-addsub32
	rm -f -r vc_hdrs.h csrc
test-addsub64: test-addsub64.v fpu_tst_addsub64.v
	vcs -full64 +vc +v2k -timescale=10ns/10ps test-addsub64.v fpu_tst_addsub64.v -o test-addsub64
	rm -f -r vc_hdrs.h csrc
run-fma64:
	../../emulator/fpu/gen f64_mulAdd | ./test-fma64 -q | ./ver f64_mulAdd
run-fma32:
	./gen f32_mulAdd | ./test-fma32 -q | ./ver f32_mulAdd
run-f32f64:
	./gen f32_to_f64 | ./test-f32f64 -q | ./ver f32_to_f64
run-f64f32:
	./gen f64_to_f32 | ./test-f64f32 -q | ./ver f64_to_f32
run-mul32:
	./gen f32_mul | ./test-mul32 -q | ./ver f32_mul
run-mul64:
	./gen f64_mul | ./test-mul64 -q | ./ver f64_mul
run-add32:
	./gen f32_add | ./test-addsub32 -q | ./ver f32_add
run-add64:
	./gen f64_add | ./test-addsub64 -q | ./ver f64_add

#run-all: run-f32f64 run-f64f32 run-mul32 run-mul64 run-add32 run-add64

run: run-f32f64 run-f64f32 run-mul32 run-mul64 run-add32 run-add64

#Daniel Nakashima EDIT
clean:
	rm -rf *.o *~ *.daidir; find . -perm +100 -type f | grep '\.\/test*' | xargs rm;

