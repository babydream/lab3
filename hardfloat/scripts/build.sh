#! bin/bash
#
# script to build testfloat_gen and testfloat_ver
base_dir=$PWD"/.."

softfloat_dir=${base_dir}"/jhauser/SoftFloat-3/build/Linux-386-Ubuntu-GCC"
testfloat_dir=${base_dir}"/jhauser/TestFloat-3/build/Linux-386-Ubuntu-GCC"
emulator_dir=${base_dir}"/emulator"
verilog_dir=${base_dir}"/verilog"

#echo "BASE DIR => "  ${base_dir}
#echo "================="
#echo "SOFT DIR => " ${softfloat_dir}
#echo "================="
#echo "TEST DIR => " ${testfloat_dir}
#echo "================="
#echo "VERLOG DIR => " ${verilog_dir}

cd ${softfloat_dir}; make clean; make;
cd ${testfloat_dir}; make clean; make;

rm -f ${emulator_dir}/gen;
rm -f ${emulator_dir}/ver;
ln ${testfloat_dir}/testfloat_gen ${emulator_dir}/gen
ln ${testfloat_dir}/testfloat_ver ${emulator_dir}/ver

rm -f ${verilog_dir}/fpu/gen;
rm -f ${verilog_dir}/fpu/ver;
ln ${testfloat_dir}/testfloat_gen ${verilog_dir}/fpu/gen
ln ${testfloat_dir}/testfloat_ver ${verilog_dir}/fpu/ver

cd ${emulator_dir}; make clean; make install;
cd ${base_dir}