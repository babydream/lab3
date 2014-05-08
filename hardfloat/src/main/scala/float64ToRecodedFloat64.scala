package hardfloat

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.Queue
import scala.collection.mutable.HashSet

import Chisel._;
import Node._;
  
class float64ToRecodedFloat64_io extends Bundle() {
  val in = UInt(INPUT, 64);
  val out = UInt(OUTPUT, 65);
}

class float64ToRecodedFloat64 extends Module {
      override val io = new float64ToRecodedFloat64_io();

    val sign    = io.in(63);
    val expIn   = io.in(62,52);
    val fractIn = io.in(51,0);
    val isZeroExpIn = ( expIn === UInt(0) );
    val isZeroFractIn = ( fractIn === UInt(0) );
    val isZeroOrSubnormal = isZeroExpIn;
    val isZero      = isZeroOrSubnormal &   isZeroFractIn;
    val isSubnormal = isZeroOrSubnormal & ~ isZeroFractIn;
    val isNormalOrSpecial = ~ isZeroExpIn;

    val norm_in = Cat(fractIn, UInt(0, 12) );
    
        val normalizeFract = Module(new normalize64)
        normalizeFract.io.in := norm_in;
        val norm_count = normalizeFract.io.distance;
        val norm_out   = normalizeFract.io.out;

    val normalizedFract = norm_out(62,11);
    val commonExp =
                Mux(isSubnormal, Cat( UInt("b111111", 6), ~ norm_count) , UInt(0, 12) ) | 
                Mux( isNormalOrSpecial, expIn, UInt(0, 12) );
    val expAdjust = Mux(isZero, UInt(0, 12), UInt("b010000000001", 12));
    val adjustedCommonExp = commonExp.toUInt + expAdjust.toUInt + isSubnormal.toUInt;
    val isNaN = (adjustedCommonExp(11,10) === UInt("b11",2)) & ~ isZeroFractIn;

    val expOut = adjustedCommonExp | Cat(isNaN, UInt(0,9)); // isNaN << 9;
    val fractOut = Mux(isZeroOrSubnormal, normalizedFract, fractIn);
    io.out := Cat(sign, expOut, fractOut);

}
