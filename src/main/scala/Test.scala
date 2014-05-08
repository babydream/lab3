package referencechip

import Chisel._
import Node._

class Test1 extends Module {
  val io = new Bundle {
    val en = Bool(INPUT)
    val in = Vec.fill(3){UInt(INPUT, 65)}
    val out = UInt(OUTPUT, 65)
  }

  //val a = io.in(0)(53,0)
  //val b = io.in(1)(53,0)
  //val c = io.in(2)(161,0)
  //val out = a*b
  //val out = (hardfloat.RedundantUInt.fromProduct(a, b) + c).toUInt
  //val out = hardfloat.RedundantUInt.fromProduct(a, b).toUInt

  val fma = Module(new hardfloat.mulAddSubRecodedFloatN(52, 12))
  fma.io.op := UInt(0)
  fma.io.a := io.in(0)
  fma.io.b := io.in(1)
  fma.io.c := io.in(2)
  fma.io.roundingMode := io.in(0)
  val out = fma.io.out

  val r = Reg(UInt())
  val r2 = Reg(UInt())
  when (io.en) { r := out }
  when (Reg(next = io.en)) { r2 := r }
  io.out := r2
  //io.out := r
  //io.out := out
}

class CAMTest extends Module {
  val io = new Bundle {
    val en = Bool(INPUT)
    val in = Vec.fill(3){UInt(INPUT, 65)}
    val out = UInt(OUTPUT, 65)
  }

  val ram = Vec.fill(128)(Reg(UInt(width = 13)))
  val table = Mem(UInt(width = 7), 64)
  val r = Reg(UInt())

  when (io.en) {
    ram(io.in(0)) := io.in(1)
    table(io.in(2)) := io.in(1)
    r := io.in(2)
  }

  val mask = ram.toBits()(ram.size-1,0)
  val out = Vec.tabulate(6) { i =>
    val areg = r(5+6*i,6*i)
    val z = areg === UInt(0)
    val hit = Vec(ram.map(e => e(5,0) === areg)).toBits
    val masked = hit & mask
    val masked_onehot = PriorityEncoderOH(Cat(Bool(false), masked, z))
    val unmasked_onehot = PriorityEncoderOH(Cat(Bool(true), hit, Bool(false)))
    val onehot = Mux(masked.orR, masked_onehot, unmasked_onehot)

    val pregs = UInt(0) +: ram.map(e => e(12,6)) :+ table(areg)
    //val rob = PriorityMux(masked, pregs ++ pregs)
    Mux1H(onehot, pregs)
  } toBits

  io.out := Reg(next = out)
}

class Test extends Module {
  val n = 80
  val io = new Bundle {
    val in = UInt(INPUT, 6)
    val wa = UInt(INPUT, log2Up(n))
    val wd0 = UInt(INPUT, 6)
    val wd1 = UInt(INPUT, log2Up(n))
    val out = UInt(OUTPUT, n)
  }

  val ar = Vec.fill(n)(Reg(io.wd0.clone))
  val pr = Vec.fill(n)(Reg(io.wd1.clone))
  val head = Reg(next=io.wa)
  ar(io.wa) := io.wd0
  pr(io.wa) := io.wd1

  //val in = Reg(next=io.in)
  //val hit0 = ar.map(_ === in)
  //val hit = (0 until n).map(i => hit0(i) && UInt(i) >= head)
  //val out = PriorityMux(hit ++ hit0, pr ++ pr)

  io.out := Reg(next=pr.map(UIntToOH(_)).reduce(_|_))
}
