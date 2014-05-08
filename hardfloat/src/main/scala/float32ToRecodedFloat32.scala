package hardfloat

import Chisel._
import Node._;

class float32ToRecodedFloat32_io extends Bundle() {
  val in  = UInt(INPUT, 32);
  val out = UInt(OUTPUT, 33);
}

class float32ToRecodedFloat32 extends Module {
  override val io = new float32ToRecodedFloat32_io();

  val sign    = io.in(31);
  val expIn   = io.in(30, 23).toUInt;
  val fractIn = io.in(22, 0).toUInt;
  val isZeroExpIn = ( expIn === UInt(0, 9) );
  val isZeroFractIn = ( fractIn === UInt(0, 23) );
  val isZeroOrSubnormal = isZeroExpIn;
  val isZero      = isZeroOrSubnormal &   isZeroFractIn;
  val isSubnormal = isZeroOrSubnormal & ~ isZeroFractIn;
  val isNormalOrSpecial = ~ isZeroExpIn;

  val norm_in = Cat(fractIn, UInt(0,9));

  val normalizeFract = Module(new normalize32)
  normalizeFract.io.in := norm_in;
  val norm_count = normalizeFract.io.distance;
  val norm_out   = normalizeFract.io.out;

  val normalizedFract = norm_out(30,8);
  val commonExp =
    Mux(isSubnormal, Cat(UInt("b1111",4), ~norm_count), UInt(0,9)) |
    Mux(isNormalOrSpecial, expIn, UInt(0,9));
  val expAdjust = Mux(isZero, UInt(0,9), UInt("b010000001", 9));
  val adjustedCommonExp = commonExp.toUInt + expAdjust.toUInt + isSubnormal.toUInt;
  val isNaN = (adjustedCommonExp(8,7) === UInt("b11",2)) & ~ isZeroFractIn;

  //val expOut = adjustedCommonExp | (isNaN(6, 0)<<6);
  val expOut = adjustedCommonExp | (isNaN << UInt(6));
  val fractOut = Mux(isZeroOrSubnormal, normalizedFract, fractIn);

  io.out := Cat(sign, expOut, fractOut);
}
