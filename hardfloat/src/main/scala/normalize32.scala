package hardfloat

import Chisel._
import Node._;

class normalize_io extends Bundle() {
  val in       = UInt(INPUT);
  val distance = UInt(OUTPUT);
  val out      = UInt(OUTPUT);
}

class normalize32_io extends normalize_io {
  override val in       = UInt(INPUT, 32);
  override val distance = UInt(OUTPUT, 5);
  override val out      = UInt(OUTPUT, 32);
}

class normalize32 extends Module {
  override val io: normalize32_io = new normalize32_io();
  val dist_4  = io.in(31, 16) === UInt(0, 16);
  val norm_16 = Mux(dist_4, io.in << UInt(16), io.in);
  val dist_3  = norm_16(31, 24) === UInt(0, 8);
  val norm_8  = Mux(dist_3, norm_16 << UInt(8), norm_16);
  val dist_2  = norm_8(31, 28) === UInt(0, 4);
  val norm_4  = Mux(dist_2, norm_8 << UInt(4), norm_8);
  val dist_1  = norm_4(31, 30) === UInt(0, 2);
  val norm_2  = Mux(dist_1, norm_4 << UInt(2), norm_4);
  val dist_0  = norm_2(31) === UInt(0, 1);
  io.out      := Mux(dist_0, norm_2 << UInt(1), norm_2)(31,0);
  io.distance := Cat(dist_4, dist_3, dist_2, dist_1, dist_0);
}
