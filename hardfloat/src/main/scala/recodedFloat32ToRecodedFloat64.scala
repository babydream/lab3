//
// recodedFloat64ToRecodedFloat32( in, out );
// Author: Andrew Waterman, 2/14/2011
//

package hardfloat

import Chisel._;
import Node._;
import fpu_recoded._;
import scala.math._;
import shift_round_position._;

class recodedFloat32ToRecodedFloat64_io() extends Bundle {
  val in             = UInt(INPUT, 33);
  val out            = UInt(OUTPUT, 65);
  val exceptionFlags = UInt(OUTPUT, 5);
}

class recodedFloat32ToRecodedFloat64 extends Module{

  val io = new recodedFloat32ToRecodedFloat64_io();

  // Break the input f32 into fields:
  val sign           = io.in(32);
  val exponent_in    = io.in(31,23).toUInt;
  val sig_in         = io.in(22,0).toUInt;

  // Determine the type of float from the coded exponent bits:
  val exponentCode = exponent_in(8,6)
  val isSignalingNaN = Cat(exponentCode, sig_in(22)) === UInt("b1110")

  val exponent_extended =
    Mux(exponentCode === UInt("b000"), UInt(0),
    Mux(exponentCode === UInt("b001"), Cat(UInt("b0111"), exponent_in(7,0)),
    Mux(exponentCode === UInt("b010"), Cat(UInt("b0111"), exponent_in(7,0)),
    Mux(exponentCode === UInt("b011"), Cat(UInt("b0111"), exponent_in(7,0)),
    Mux(exponentCode === UInt("b100"), Cat(UInt("b1000"), exponent_in(7,0)),
    Mux(exponentCode === UInt("b101"), Cat(UInt("b1000"), exponent_in(7,0)),
    Mux(exponentCode === UInt("b110"), UInt("b110000000000"),
                                       UInt("b111000000000"))))))))

  io.out := Cat(sign, exponent_extended, isSignalingNaN || sig_in(22), sig_in(21,0), UInt(0,29))
  io.exceptionFlags := Cat(isSignalingNaN, UInt(0,4))
}
