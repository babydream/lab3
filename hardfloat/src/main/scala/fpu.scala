package hardfloat

import Chisel._
import Node._;

class fpu_tst_f32_to_f64_io extends Bundle() {
  val in              = UInt(INPUT, 32);
  val exception_flags = UInt(OUTPUT, 5);
  val out             = UInt(OUTPUT, 64);
}

class fpu_tst_f64_to_f32_io extends Bundle() {
  val in              = UInt(INPUT, 64);
  val rounding_mode   = UInt(INPUT, 2);
  val exception_flags = UInt(OUTPUT, 5);
  val out             = UInt(OUTPUT, 32);
}

class fpu_tst_muladd64_io extends Bundle() {
  val a               = UInt(INPUT, 64);
  val b               = UInt(INPUT, 64);
  val c               = UInt(INPUT, 64);
  val op              = UInt(INPUT, 1);
  val rounding_mode   = UInt(INPUT, 2);
  val exception_flags = UInt(OUTPUT, 5);
  val out             = UInt(OUTPUT, 64);
}

class fpu_tst_muladd32_io extends Bundle() {
  val a               = UInt(INPUT, 32);
  val b               = UInt(INPUT, 32);
  val c               = UInt(INPUT, 32);
  val op              = UInt(INPUT, 1);
  val rounding_mode   = UInt(INPUT, 2);
  val exception_flags = UInt(OUTPUT, 5);
  val out             = UInt(OUTPUT, 32);
}

class fpu_tst_addsub32_io extends Bundle() {
  val a               = UInt(INPUT, 32);
  val b               = UInt(INPUT, 32);
  val op              = UInt(INPUT, 1);
  val rounding_mode   = UInt(INPUT, 2);
  val exception_flags = UInt(OUTPUT, 5);
  val out             = UInt(OUTPUT, 32);
}


class fpu_tst_mul32_io extends Bundle() {
  val a               = UInt(INPUT, 32);
  val b               = UInt(INPUT, 32);
  val rounding_mode   = UInt(INPUT, 2);
  val exception_flags = UInt(OUTPUT, 5);
  val out             = UInt(OUTPUT, 32);
}

class fpu_tst_mul64_io extends Bundle() {
  val a               = UInt(INPUT, 64);
  val b               = UInt(INPUT, 64);
  val rounding_mode   = UInt(INPUT, 2);
  val exception_flags = UInt(OUTPUT, 5);
  val out             = UInt(OUTPUT, 64);
}
class fpu_tst_addsub64_io extends Bundle() {
  val a               = UInt(INPUT, 64);
  val b               = UInt(INPUT, 64);
  val op              = UInt(INPUT, 1);
  val rounding_mode   = UInt(INPUT, 2);
  val exception_flags = UInt(OUTPUT, 5);
  val out             = UInt(OUTPUT, 64);
}

class fpu_tst_compareFloat32_io extends Bundle() {
  val a              = UInt(INPUT, 32);
  val b              = UInt(INPUT, 32);
  val less           = Bool(OUTPUT);
  val equal          = Bool(OUTPUT);
  val unordered      = Bool(OUTPUT);
  val exceptionFlags = UInt(OUTPUT, 5);
}

class fpu_tst_compareFloat64_io extends Bundle() {
  val a              = UInt(INPUT, 64);
  val b              = UInt(INPUT, 64);
  val less           = Bool(OUTPUT);
  val equal          = Bool(OUTPUT);
  val unordered      = Bool(OUTPUT);
  val exceptionFlags = UInt(OUTPUT, 5);
}

class fpu_tst_f32_to_f64 extends Module {
  override val io = new fpu_tst_f32_to_f64_io();
  val f32rf32  = new float32ToRecodedFloat32();
  val rf32rf64 = new rF32_rF64();
  val rf64f64  = new recodedFloat64ToFloat64();
  f32rf32.io.in <> io.in;
  f32rf32.io.out <> rf32rf64.io.in;
  rf32rf64.io.exception_flags <> io.exception_flags;
  rf32rf64.io.out <> rf64f64.io.in;
  rf64f64.io.out <> io.out;
}

class fpu_tst_f64_to_f32 extends Module {
  override val io = new fpu_tst_f64_to_f32_io();
  val f64rf64 = new float64ToRecodedFloat64();
  val rf64rf32 = new recodedFloat64ToRecodedFloat32();
  val rf32f32 = new recodedFloat32ToFloat32();
  f64rf64.io.in <> io.in;
  f64rf64.io.out <> rf64rf32.io.in;
  rf64rf32.io.out <> rf32f32.io.in;
  rf64rf32.io.roundingMode <> io.rounding_mode;
  rf64rf32.io.exceptionFlags <> io.exception_flags;
  rf32f32.io.out <> io.out;
}

class fpu_tst_muladd64 extends Module {
  override val io = new fpu_tst_muladd64_io();
  val mulAf64rf64 = new float64ToRecodedFloat64();
  val mulBf64rf64 = new float64ToRecodedFloat64();
  val mulCf64rf64 = new float64ToRecodedFloat64();
  val mulAddR64   = new mulAddSubRecodedFloat64_1();
  val mulrf64f64  = new recodedFloat64ToFloat64();
  mulAf64rf64.io.in <> io.a;
  mulBf64rf64.io.in <> io.b;
  mulCf64rf64.io.in <> io.c;
  mulAf64rf64.io.out <> mulAddR64.io.a;
  mulBf64rf64.io.out <> mulAddR64.io.b;
  mulCf64rf64.io.out <> mulAddR64.io.c;
  mulAddR64.io.roundingMode <> io.rounding_mode;
  mulAddR64.io.exceptionFlags <> io.exception_flags;
  mulAddR64.io.op <> io.op;
  mulAddR64.io.out <> mulrf64f64.io.in;
  mulrf64f64.io.out <> io.out;  
}


class fpu_tst_muladd32 extends Module {
  override val io = new fpu_tst_muladd32_io();
  val mulA = new float32ToRecodedFloat32();
  val mulB = new float32ToRecodedFloat32();
  val mulC = new float32ToRecodedFloat32();
  val mulAddR32   = new mulAddSubRecodedFloat32_1();
  val mulrf32f32  = new recodedFloat32ToFloat32();
  mulA.io.in <> io.a;
  mulB.io.in <> io.b;
  mulC.io.in <> io.c;
  mulA.io.out <> mulAddR32.io.a;
  mulB.io.out <> mulAddR32.io.b;
  mulC.io.out <> mulAddR32.io.c;
  mulAddR32.io.roundingMode <> io.rounding_mode;
  mulAddR32.io.exceptionFlags <> io.exception_flags;
  mulAddR32.io.op <> io.op;
  mulAddR32.io.out <> mulrf32f32.io.in;
  mulrf32f32.io.out <> io.out;  
}

class fpu_tst_addsub32 extends Module {
  override val io = new fpu_tst_addsub32_io();
  val addSuba = new float32ToRecodedFloat32();
  val addSubb = new float32ToRecodedFloat32();
  val addSubR32   = new addSubRecodedFloat32_1();
  val addsubrf32f32  = new recodedFloat32ToFloat32();
  addSuba.io.in <> io.a;
  addSubb.io.in <> io.b;
  addSuba.io.out <> addSubR32.io.a;
  addSubb.io.out <> addSubR32.io.b;
  addSubR32.io.roundingMode <> io.rounding_mode;
  addSubR32.io.exceptionFlags <> io.exception_flags;
  addSubR32.io.op <> io.op;
  addSubR32.io.out <> addsubrf32f32.io.in;
  addsubrf32f32.io.out <> io.out;  
}

class fpu_tst_addsub64 extends Module {
  override val io = new fpu_tst_addsub64_io();
  val addSuba = new float64ToRecodedFloat64();
  val addSubb = new float64ToRecodedFloat64();
  val addSubR64   = new addSubRecodedFloat64_1();
  val addsubrf64f64  = new recodedFloat64ToFloat64();
  addSuba.io.in <> io.a;
  addSubb.io.in <> io.b;
  addSuba.io.out <> addSubR64.io.a;
  addSubb.io.out <> addSubR64.io.b;
  addSubR64.io.roundingMode <> io.rounding_mode;
  addSubR64.io.exceptionFlags <> io.exception_flags;
  addSubR64.io.op <> io.op;
  addSubR64.io.out <> addsubrf64f64.io.in;
  addsubrf64f64.io.out <> io.out;  
}

// class fpu_tst_compareFloat32 extends Module {
//   override val io = new fpu_tst_compareFloat32_io();
//   val f32_rf32a = new float32ToRecodedFloat32();
//   val f32_rf32b = new float32ToRecodedFloat32();
//   val compareFloat32 = new compareRecodedFloatN(8,24);

//   f32_rf32a.io.in := io.a;
//   f32_rf32b.io.in := io.b;

//   compareFloat32.io.a := f32_rf32a.io.out;
//   compareFloat32.io.b := f32_rf32b.io.out;

//   io.less           := compareFloat32.io.less;
//   io.equal          := compareFloat32.io.equal;
//   io.unordered      := compareFloat32.io.unordered;
//   io.exceptionFlags := compareFloat32.io.exceptionFlags;
// }

// class fpu_tst_compareFloat64 extends Module {
//   override val io = new fpu_tst_compareFloat64_io();
//   val f64_rf64a = new float64ToRecodedFloat64();
//   val f64_rf64b = new float64ToRecodedFloat64();
//   val compareFloat64 = new compareRecodedFloatN(11,53);

//   f64_rf64a.io.in := io.a;
//   f64_rf64b.io.in := io.b;

//   compareFloat64.io.a := f64_rf64a.io.out;
//   compareFloat64.io.b := f64_rf64b.io.out;

//   io.less           := compareFloat64.io.less;
//   io.equal          := compareFloat64.io.equal;
//   io.unordered      := compareFloat64.io.unordered;
//   io.exceptionFlags := compareFloat64.io.exceptionFlags;
// }

class fpu_tst_mul32 extends Module {
  override val io = new fpu_tst_mul32_io();
  val mula = new float32ToRecodedFloat32();
  val mulb = new float32ToRecodedFloat32();
  val mulR32   = new mulRecodedFloat32_1();
  val mulrf32f32  = new recodedFloat32ToFloat32();
  mula.io.in <> io.a;
  mulb.io.in <> io.b;
  mula.io.out <> mulR32.io.a;
  mulb.io.out <> mulR32.io.b;
  mulR32.io.roundingMode <> io.rounding_mode;
  mulR32.io.exceptionFlags <> io.exception_flags;
  mulR32.io.out <> mulrf32f32.io.in;
  mulrf32f32.io.out <> io.out;  
}

class fpu_tst_mul64 extends Module {
  override val io = new fpu_tst_mul64_io();
  val mula = new float64ToRecodedFloat64();
  val mulb = new float64ToRecodedFloat64();
  val mulR64   = new mulRecodedFloat64_1();
  val mulrf64f64  = new recodedFloat64ToFloat64();
  mula.io.in <> io.a;
  mulb.io.in <> io.b;
  mula.io.out <> mulR64.io.a;
  mulb.io.out <> mulR64.io.b;
  mulR64.io.roundingMode <> io.rounding_mode;
  mulR64.io.exceptionFlags <> io.exception_flags;
  mulR64.io.out <> mulrf64f64.io.in;
  mulrf64f64.io.out <> io.out;  
}
class fpu_tst_3264_io extends Bundle() {
  val sign    = UInt(INPUT, 1);
  val exp     = UInt(INPUT, 11);
  val fract   = UInt(INPUT, 53);
  val out     = UInt(OUTPUT, 65);
}

class fpu_bb_io extends Bundle() {
  val in  = UInt(INPUT, 64);
  val out = UInt(OUTPUT, 64);
}

class fpu_bb extends BlackBox {
  override val io = new fpu_bb_io();
}

class fpu_tst_bb extends Module {
  override val io = new fpu_bb_io();
  val bb = new fpu_bb();
  bb.io.in  <> io.in;
  bb.io.out <> io.out;
}

class fpu_tst_3264 extends Module {
  override val io = new fpu_tst_3264_io();
  // io.out := (io.sign(64,0)<<64)|Cat(io.exp, io.fract);
  val x = UInt(1,1) << UInt(64);
  val y = UInt("hFFFF",16) >> UInt(8);
  val z = UInt("hFFFF",16) >> io.exp.toUInt;
  val a = UInt("hFFFF",16) << io.exp(3, 0).toUInt;
  // io.out := (io.sign(64,0)<<64)|Cat(io.exp, io.fract);
  io.out := io.sign | x | y | z | a;
}

class fpu_tst_compareFloat32() extends Module{
  val io = new Bundle {
    val a              = UInt(INPUT, 32);
    val b              = UInt(INPUT, 32);
    val less           = Bool(OUTPUT);
    val equal          = Bool(OUTPUT);
    val lessOrEqual    = Bool(OUTPUT);
    val eq_exception   = UInt(OUTPUT, 5);
    val lt_exception   = UInt(OUTPUT, 5);
    val lte_exception  = UInt(OUTPUT, 5);
  }
  val f32_rf32a = new float32ToRecodedFloat32();
  val f32_rf32b = new float32ToRecodedFloat32();
  val compareFloat32 = new recodedFloat32Compare(24,8);

  f32_rf32a.io.in := io.a;
  f32_rf32b.io.in := io.b;

  compareFloat32.io.a := f32_rf32a.io.out;
  compareFloat32.io.b := f32_rf32b.io.out;

  io.less           := compareFloat32.io.a_lt_b;
  io.equal          := compareFloat32.io.a_eq_b;
  io.lessOrEqual    := compareFloat32.io.a_lt_b || compareFloat32.io.a_eq_b;
  io.eq_exception   := Cat(compareFloat32.io.a_eq_b_invalid, UInt(0,4));
  io.lt_exception   := Cat(compareFloat32.io.a_lt_b_invalid, UInt(0,4));
  io.lte_exception   := Cat(compareFloat32.io.a_eq_b_invalid | compareFloat32.io.a_lt_b_invalid, UInt(0,4));
}

class fpu_tst_compareFloat64() extends Module{
  val io = new Bundle {
    val a              = UInt(INPUT, 64);
    val b              = UInt(INPUT, 64);
    val less           = Bool(OUTPUT);
    val equal          = Bool(OUTPUT);
    val lessOrEqual    = Bool(OUTPUT);
    val eq_exception   = UInt(OUTPUT, 5);
    val lt_exception   = UInt(OUTPUT, 5);
    val lte_exception  = UInt(OUTPUT, 5);
  }
  val f64_rf64a = new float64ToRecodedFloat64();
  val f64_rf64b = new float64ToRecodedFloat64();
  val compareFloat64 = new recodedFloat64Compare(53,11);

  f64_rf64a.io.in := io.a;
  f64_rf64b.io.in := io.b;

  compareFloat64.io.a := f64_rf64a.io.out;
  compareFloat64.io.b := f64_rf64b.io.out;

  io.less           := compareFloat64.io.a_lt_b;
  io.equal          := compareFloat64.io.a_eq_b;
  io.lessOrEqual    := compareFloat64.io.a_lt_b || compareFloat64.io.a_eq_b;
  io.eq_exception   := Cat(compareFloat64.io.a_eq_b_invalid, UInt(0,4));
  io.lt_exception   := Cat(compareFloat64.io.a_lt_b_invalid, UInt(0,4));
  io.lte_exception   := Cat(compareFloat64.io.a_eq_b_invalid | compareFloat64.io.a_lt_b_invalid, UInt(0,4));
}
