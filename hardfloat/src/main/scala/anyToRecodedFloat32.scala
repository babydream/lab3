//
// anyToRecodedFloat32( in, out );
// Author: Brian Richards, 5/17/2011
// Based on float32ToRecodedFloat32 from John Hauser
//

package hardfloat

import Chisel._
import Node._;

class anyToRecodedFloat32_io(SIG_WIDTH: Int, EXP_WIDTH: Int, INT_WIDTH: Int) extends Bundle {
  val in             = UInt(INPUT, INT_WIDTH);
  val roundingMode   = UInt(INPUT, 2);
  val typeOp         = UInt(INPUT, 2);
  val out            = UInt(OUTPUT, SIG_WIDTH + EXP_WIDTH + 1);
  val exceptionFlags = UInt(OUTPUT, 5);
}

class anyToRecodedFloat32(
  SIG_WIDTH: Int = 23,
  EXP_WIDTH: Int = 9,
  INT_WIDTH: Int = 64) extends Module {

  override val io = new anyToRecodedFloat32_io(SIG_WIDTH, EXP_WIDTH, INT_WIDTH);

  val FLOAT_WIDTH = SIG_WIDTH + EXP_WIDTH + 1;
  val SHIFT_WIDTH = INT_WIDTH + 1; // Save one fraction bit.
  val STAGES = 7;                  // $clog2(SHIFT_WIDTH);
  val EXP_OFFSET = UInt("h100", 9); //9'h100; // Recoded offset=256 (IEEE offset=127)

  val type_uint32 = UInt(0, 2);
  val type_int32  = UInt(1, 2);
  val type_uint64 = UInt(2, 2);
  val type_int64  = UInt(3, 2);

  val round_nearest_even = UInt(0, 2);
  val round_minMag       = UInt(1, 2);
  val round_min          = UInt(2, 2);
  val round_max          = UInt(3, 2);

// Generate the absolute value of the input.
val sign =
  Mux(io.typeOp === type_uint32, Bool(false),
  Mux(io.typeOp === type_int32,  io.in(31).toBool,
  Mux(io.typeOp === type_uint64, Bool(false),
  Mux(io.typeOp === type_int64,  io.in(63).toBool,
  Bool(false)))));

val norm_in =
  Mux(io.typeOp === type_uint32, Cat(UInt(0,32), io.in(31,0)),
  Mux(io.typeOp === type_int32,  Cat(UInt(0,32), Mux(sign, -io.in(31,0), io.in(31,0))),
  Mux(io.typeOp === type_uint64, io.in,
  Mux(io.typeOp === type_int64,  Mux(sign, -io.in , io.in),
  UInt(0,64)))));

// Normalize to generate the fractional part.
val normalizeFract = Module(new normalize64)
normalizeFract.io.in := norm_in;
val norm_count = normalizeFract.io.distance;
val norm_out   = normalizeFract.io.out;

// norm_out contains the 52 double significand bits as norm_out(62,11)
// norm_out contains the 23 single significand bits as norm_out(62,40)
// Rounding depends on:
//  norm_out(40):   The LSB of the significand
//  norm_out(39):   The MSB of the fraction bits to be rounded
//  norm_out(38,0): Remaining fraction bits
val roundBits = Cat(norm_out(40,39),(norm_out(38,0) != UInt(0,39)));

// Check if rounding is necessary.
val roundInexact = (roundBits(1,0) != UInt(0,2));

// Determine the rounding increment, based on the rounding mode.
val roundEvenOffset = (roundBits(1,0) === UInt("b11",2) ||
           roundBits(2,1) === UInt("b11",2));
val roundOffset =
  Mux(io.roundingMode === round_nearest_even, roundEvenOffset,
  Mux(io.roundingMode === round_minMag,       UInt(0,1),
  Mux(io.roundingMode === round_min,
      sign & Mux(roundInexact, UInt(1,1), UInt(0,1)),
  Mux(io.roundingMode === round_max,
      ~sign & Mux(roundInexact, UInt(1,1), UInt(0,1)),
  UInt(0,1))))).toUInt;

// The rounded normalized significand includes the carry-out, implicit unit
// digit, and 23-bits of final significand (25 bits total).
val norm_round = (Cat(UInt(0, 1), norm_out(63, 40)).toUInt + roundOffset);

// For the Recoded Float32:
//  norm_count Exponent  Recoded Exponent      IEEE Exponent
//   63, msb=0    2^0      9'b000------      8'b00000000
//   63, msb=1    2^0      9'b100000000      8'b01111111
//   62           2^1      9'b100000001      8'b10000000
//   61           2^2      9'b100000010      8'b10000001
//     ...
//   1            2^62     9'b100111110      8'b10111101
//   0            2^63     9'b100111111      8'b10111110
//

// Construct the exponent from the norm_count, and increment the
// exponent if the rounding overflows (the significand will still
// be all zeros in this case).
val exponent_offset = Cat(UInt("b100",3), ~norm_count).toUInt + norm_round(24);

// The MSB of norm_out is zero only if the input is all zeros.
val exponent =
  Mux(norm_out(63) === UInt(0,1) && norm_count === UInt(63,6),
    UInt(0,9),
    exponent_offset);

io.out := Cat(sign, exponent, norm_round(22,0));
io.exceptionFlags := Cat(UInt(0,4), roundInexact);
}
