
all: \
 test-f32_add_r_near_even \
 test-f32_mul_r_near_even \
 test-f32_mulAdd_r_near_even \
 test-f64_add_r_near_even \

test-f32_add_r_near_even: test-f32_add_r_near_even.v ../../float32ToRecodedFloat32.v ../../addSubRecodedFloat32_1.v ../../recodedFloat32ToFloat32.v ../../normalize32.v readWriteHex.c
	vcs +vc -timescale=10ns/10ps test-f32_add_r_near_even.v ../../float32ToRecodedFloat32.v ../../addSubRecodedFloat32_1.v ../../recodedFloat32ToFloat32.v ../../normalize32.v readWriteHex.c -o test-f32_add_r_near_even
	rm -f -r vc_hdrs.h csrc

test-f32_mul_r_near_even: test-f32_mul_r_near_even.v ../../float32ToRecodedFloat32.v ../../mulRecodedFloat32_1.v ../../recodedFloat32ToFloat32.v ../../normalize32.v readWriteHex.c
	vcs +vc -timescale=10ns/10ps test-f32_mul_r_near_even.v ../../float32ToRecodedFloat32.v ../../mulRecodedFloat32_1.v ../../recodedFloat32ToFloat32.v ../../normalize32.v readWriteHex.c -o test-f32_mul_r_near_even
	rm -f -r vc_hdrs.h csrc

test-f32_mulAdd_r_near_even: test-f32_mulAdd_r_near_even.v ../../float32ToRecodedFloat32.v ../../mulAddSubRecodedFloat32_1.v ../../recodedFloat32ToFloat32.v ../../normalize32.v ../../estNormDistP24PosSum50.v ../../estNormDistP24NegSum50.v readWriteHex.c
	vcs +vc -timescale=10ns/10ps test-f32_mulAdd_r_near_even.v ../../float32ToRecodedFloat32.v ../../mulAddSubRecodedFloat32_1.v ../../recodedFloat32ToFloat32.v ../../normalize32.v ../../estNormDistP24PosSum50.v ../../estNormDistP24NegSum50.v readWriteHex.c -o test-f32_mulAdd_r_near_even
	rm -f -r vc_hdrs.h csrc

test-f64_add_r_near_even: test-f64_add_r_near_even.v ../../float64ToRecodedFloat64.v ../../addSubRecodedFloat64_1.v ../../recodedFloat64ToFloat64.v ../../normalize64.v readWriteHex.c
	vcs +vc -timescale=10ns/10ps test-f64_add_r_near_even.v ../../float64ToRecodedFloat64.v ../../addSubRecodedFloat64_1.v ../../recodedFloat64ToFloat64.v ../../normalize64.v readWriteHex.c -o test-f64_add_r_near_even
	rm -f -r vc_hdrs.h csrc

test-f64_mul_r_near_even: test-f64_mul_r_near_even.v ../../float64ToRecodedFloat64.v ../../mulRecodedFloat64_1.v ../../recodedFloat64ToFloat64.v ../../normalize64.v readWriteHex.c
	vcs +vc -timescale=10ns/10ps test-f64_mul_r_near_even.v ../../float64ToRecodedFloat64.v ../../mulRecodedFloat64_1.v ../../recodedFloat64ToFloat64.v ../../normalize64.v readWriteHex.c -o test-f64_mul_r_near_even
	rm -f -r vc_hdrs.h csrc

test-f64_mulAdd_r_near_even: test-f64_mulAdd_r_near_even.v ../../float64ToRecodedFloat64.v ../../mulAddSubRecodedFloat64_1.v ../../recodedFloat64ToFloat64.v ../../normalize64.v ../../estNormDistP53PosSum108.v ../../estNormDistP53NegSum108.v readWriteHex.c
	vcs +vc -timescale=10ns/10ps test-f64_mulAdd_r_near_even.v ../../float64ToRecodedFloat64.v ../../mulAddSubRecodedFloat64_1.v ../../recodedFloat64ToFloat64.v ../../normalize64.v ../../estNormDistP53PosSum108.v ../../estNormDistP53NegSum108.v readWriteHex.c -o test-f64_mulAdd_r_near_even
	rm -f -r vc_hdrs.h csrc

test-fma64: test-fma64.v ../../float64ToRecodedFloat64.v ../../mulAddSubRecodedFloat64_1.v ../../recodedFloat64ToFloat64.v ../../normalize64.v ../../estNormDistP53PosSum108.v ../../estNormDistP53NegSum108.v
	vcs +vc -timescale=10ns/10ps test-fma64.v -PP ../../float64ToRecodedFloat64.v ../../mulAddSubRecodedFloat64_1.v ../../recodedFloat64ToFloat64.v ../../normalize64.v ../../estNormDistP53PosSum108.v ../../estNormDistP53NegSum108.v -o test-fma64
	rm -f -r vc_hdrs.h csrc

clean:
	rm -f -r test-f32_add_r_near_even test-f32_add_r_near_even.daidir
	rm -f -r test-f32_mul_r_near_even test-f32_mul_r_near_even.daidir
	rm -f -r test-f32_mulAdd_r_near_even test-f32_mulAdd_r_near_even.daidir
	rm -f -r test-f64_add_r_near_even test-f64_add_r_near_even.daidir
	rm -f -r test-f64_mul_r_near_even test-f64_mul_r_near_even.daidir
	rm -f -r test-f64_mulAdd_r_near_even test-f64_mulAdd_r_near_even.daidir


#*** EXTRA.

test-normalize32: test-normalize32.v ../../normalize32.v readWriteHex.c
	vcs +vc -timescale=10ns/10ps test-normalize32.v ../../normalize32.v readWriteHex.c -o test-normalize32
	rm -f -r vc_hdrs.h csrc

test-recodeFloat32: test-recodeFloat32.v ../../float32ToRecodedFloat32.v ../../recodedFloat32ToFloat32.v ../../normalize32.v readWriteHex.c
	vcs +vc -timescale=10ns/10ps test-recodeFloat32.v ../../float32ToRecodedFloat32.v ../../recodedFloat32ToFloat32.v ../../normalize32.v readWriteHex.c -o test-recodeFloat32
	rm -f -r vc_hdrs.h csrc

