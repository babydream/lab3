# CPPFLAGS = -O2  #  -S -g
CPPFLAGS = -g -I..
OPTFLAGS = -O2

fpusrcdir = fpu
fpusrcs = \
	fpu_tst_f64_to_f32 \
	fpu_tst_f32_to_f64 \
	fpu_tst_muladd64 \
	fpu_tst_muladd32 \
	fpu_tst_addsub32 \
	fpu_tst_addsub64 \
	fpu_tst_mul32 \
	fpu_tst_mul64 \
	fpu_tst_compareFloat32 \
	fpu_tst_compareFloat64 

fputsts = \
	f32_to_f64 \
	f64_to_f32 \
	f32_mul \
	f64_mul \
	f32_sub \
	f64_add \
	f32_eq_signaling \
	f32_lt \
	f32_le \
	f64_eq_signaling \
	f64_lt \
	f64_le \
	f32_mulAdd \
	f64_mulAdd

fpu_tst_o = $(addsuffix .o, $(fpusrcs))
fpu_tst_cpp = $(addprefix fpu/, $(addsuffix .cpp, $(fpusrcs)))
fpu_tst_h = $(addprefix fpu/, $(addsuffix .h, $(fpusrcs)))

$(fpu_tst_o): $(fpu_tst_cpp) $(fpu_tst_h)
	g++ -c -g $(OPTFLAGS) $(fpu_tst_cpp)

emulator-fpu.o: fpu/emulator.h fpu/emulator-fpu.cpp $(fpu_tst_h) 
	g++ -c -g $(OPTFLAGS) fpu/emulator-fpu.cpp 

emulator-fpu: emulator-fpu.o $(fpu_tst_o)
	g++ -o emulator-fpu -g $(OPTFLAGS) emulator-fpu.o $(fpu_tst_o)

$(fputsts): emulator-fpu
	./gen $@ | ./emulator-fpu $@ | ./ver $@

run: $(fputsts)


emulator-fma64.o: emulator-fma64.cpp ../emulator.h
	g++ -c ${CPPFLAGS} emulator-fma64.cpp

mulAddSubFloat64.o: mulAddSubFloat64.cpp mulAddSubFloat64.h ../emulator.h
	g++ -c ${CPPFLAGS} mulAddSubFloat64.cpp

emulator-fma64: emulator-fma64.o mulAddSubFloat64.o 
	g++ -o $@ ${CPPFLAGS} emulator-fma64.o mulAddSubFloat64.o

float32ToAny.o: float32ToAny.cpp float32ToAny.h
	g++ -c ${CPPFLAGS} float32ToAny.cpp

emulator-f32_to_int: emulator-f32_to_int.cpp float32ToAny.o
	g++ -o $@ ${CPPFLAGS} $^

emu_f32_to_int:
	./testfloat_gen f32_to_i64_r_near_even | ./emulator-f32_to_int f32_to_i64_r_near_even | \
		./testfloat_ver f32_to_i64_r_near_even
	./testfloat_gen f32_to_ui64_r_near_even | ./emulator-f32_to_int f32_to_ui64_r_near_even | \
		./testfloat_ver f32_to_ui64_r_near_even
	./testfloat_gen f32_to_i32_r_near_even | ./emulator-f32_to_int f32_to_i32_r_near_even | \
		./testfloat_ver f32_to_i32_r_near_even
	./testfloat_gen f32_to_ui32_r_near_even | ./emulator-f32_to_int f32_to_ui32_r_near_even | \
		./testfloat_ver f32_to_ui32_r_near_even

sim_float32ToAny:
	(echo 0 0; testfloat_gen f32_to_ui32_r_near_even) | \
		../../verilog/fpu/test_float32ToAny -q | \
		sed -e '/^[$$V]/d' | \
		testfloat_ver f32_to_ui32_r_near_even 
	(echo 1 0; testfloat_gen f32_to_i32_r_near_even) | \
		../../verilog/fpu/test_float32ToAny -q | \
		sed -e '/^[$$V]/d' | \
		testfloat_ver f32_to_i32_r_near_even 
	(echo 2 0; testfloat_gen f32_to_ui64_r_near_even) | \
		../../verilog/fpu/test_float32ToAny -q | \
		sed -e '/^[$$V]/d' | \
		testfloat_ver f32_to_ui64_r_near_even 
	(echo 3 0; testfloat_gen f32_to_i64_r_near_even) | \
		../../verilog/fpu/test_float32ToAny -q | \
		sed -e '/^[$$V]/d' | \
		testfloat_ver f32_to_i64_r_near_even 

anyToFloat32.o: anyToFloat32.cpp anyToFloat32.h
	g++ -c ${CPPFLAGS} anyToFloat32.cpp

emulator-int_to_f32: emulator-int_to_f32.cpp anyToFloat32.o
	g++ -o $@ ${CPPFLAGS} $^

emu_int_to_f32:
	./testfloat_gen i64_to_f32  | ./emulator-int_to_f32 i64_to_f32  | ./testfloat_ver i64_to_f32
	./testfloat_gen ui64_to_f32 | ./emulator-int_to_f32 ui64_to_f32 | ./testfloat_ver ui64_to_f32
	./testfloat_gen i32_to_f32  | ./emulator-int_to_f32 i32_to_f32  | ./testfloat_ver i32_to_f32
	./testfloat_gen ui32_to_f32 | ./emulator-int_to_f32 ui32_to_f32 | ./testfloat_ver ui32_to_f32

sim_anyToFloat32:
	(echo 0 0; testfloat_gen ui32_to_f32) | ../../verilog/fpu/test_anyToFloat32 -q | sed -e '/^[$$V]/d' | testfloat_ver ui32_to_f32 
	(echo 1 0; testfloat_gen i32_to_f32) | ../../verilog/fpu/test_anyToFloat32 -q | sed -e '/^[$$V]/d' | testfloat_ver i32_to_f32 
	(echo 2 0; testfloat_gen ui64_to_f32) | ../../verilog/fpu/test_anyToFloat32 -q | sed -e '/^[$$V]/d' | testfloat_ver ui64_to_f32 
	(echo 3 0; testfloat_gen i64_to_f32) | ../../verilog/fpu/test_anyToFloat32 -q | sed -e '/^[$$V]/d' | testfloat_ver i64_to_f32 

install:
	cd ../sbt; sbt "project hardfloat" "run-main hardfloat.hardfloat"; cp -f *.cpp *.h ../emulator/fpu; sbt "project hardfloat" "run-main hardfloat.hardfloat --v"; cp -f *.v ../verilog/fpu;
#run_fpu:
	#cd ../../sbt; sbt "project fpu" run "run --v"

run_fma64_v:
	../../fpu_jhauser/floatUnits/test/Synopsys-vcs/test-fma64 -q < fma64.vec
	dve -vpd vcdplus.vpd

emu_fma64:
	testfloat_gen f64_mulAdd | ./emulator-fma64 f64_mulAdd | testfloat_ver f64_mulAdd

sim_fma64:
	testfloat_gen f64_mulAdd | ../../verilog/fpu/test-fma64 -q | sed -e '/^[$$V]/d' | testfloat_ver f64_mulAdd 

clean:
	rm -f *.o *~
