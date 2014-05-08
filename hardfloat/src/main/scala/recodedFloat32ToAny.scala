//
// recodedFloat32ToAny( in, out );
// Author: Brian Richards, 5/17/2011
//

package hardfloat

import Chisel._
import Node._;

class recodedFloat32ToAny_io(SIG_WIDTH: Int, EXP_WIDTH: Int, INT_WIDTH: Int) extends Bundle {
  val in =             UInt(INPUT, SIG_WIDTH + EXP_WIDTH + 1);
  val roundingMode =   UInt(INPUT, 2);
  val typeOp =         UInt(INPUT, 2);
  val out =            UInt(OUTPUT, INT_WIDTH);
  val exceptionFlags = UInt(OUTPUT, 5);
}

class recodedFloat32ToAny(SIG_WIDTH: Int = 23, EXP_WIDTH: Int = 9, INT_WIDTH: Int = 64) extends Module {
  override val io = new recodedFloat32ToAny_io(SIG_WIDTH, EXP_WIDTH, INT_WIDTH);

    val FLOAT_WIDTH = SIG_WIDTH + EXP_WIDTH + 1;
    val SHIFT_WIDTH = INT_WIDTH + 1; // Save one fraction bit.
    val STAGES = 7;                  // $clog2(SHIFT_WIDTH);
    val EXP_OFFSET = UInt("h100", 9).toUInt; //9'h100; // Recoded offset=256 (IEEE offset=127)

    val type_uint32 = UInt(0, 2);
    val type_int32  = UInt(1, 2);
    val type_uint64 = UInt(2, 2);
    val type_int64  = UInt(3, 2);

    val round_nearest_even = UInt(0, 2);
    val round_minMag       = UInt(1, 2);
    val round_min          = UInt(2, 2);
    val round_max          = UInt(3, 2);

// For the Recoded Float:
//  shift_count Exponent  Recoded Exponent      IEEE Exponent
//                (zero)   9'b000------      8'b00000000
//   32           2^-1     9'b011111111      8'b01111110 (Can round up to 1)
//   31, msb=1    2^0      9'b100000000      8'b01111111
//   30           2^1      9'b100000001      8'b10000000
//   29           2^2      9'b100000010      8'b10000001
//     ...
//   1            2^30     9'b100011110      8'b10011101
//   0        2^31     9'b100011111      8'b10011110
//

val sign =     io.in(FLOAT_WIDTH-1).toBool;
val exponent = io.in(FLOAT_WIDTH-2,SIG_WIDTH).toUInt;

// The signed conversion is valid if:
// Input < 2^63 || Input === -2^63

val isTiny      = (exponent < EXP_OFFSET-UInt(1));
val isZeroOrOne = (exponent === EXP_OFFSET-UInt(1));
val isZero      = (exponent(EXP_WIDTH-1,EXP_WIDTH-3) === UInt(0, 3));
val isNaN       = (exponent(EXP_WIDTH-1,EXP_WIDTH-3) === UInt("b111",3));

val maxExponent = EXP_OFFSET + (
    Mux(io.typeOp === type_uint32, UInt(32, EXP_WIDTH),
    Mux(io.typeOp === type_int32,  UInt(31, EXP_WIDTH),
    Mux(io.typeOp === type_uint64, UInt(64, EXP_WIDTH),
    Mux(io.typeOp === type_int64,  UInt(63, EXP_WIDTH),
    UInt(0,12))))));

val maxNegFloat = Cat(UInt(1,1), maxExponent(EXP_WIDTH-1,0),
    Fill(SIG_WIDTH, UInt(0, 1)));
val isMaxNegFloat =
    Mux(io.typeOp === type_uint32, Bool(false),
    Mux(io.typeOp === type_int32,  (io.in === maxNegFloat),
    Mux(io.typeOp === type_uint64, Bool(false),
    Mux(io.typeOp === type_int64,  (io.in === maxNegFloat),
    Bool(false)))));

val maxInteger =
    Mux(io.typeOp === type_uint32, UInt("h00000000ffffffff", 64),
    Mux(io.typeOp === type_int32,  UInt("h000000007fffffff", 64),
    Mux(io.typeOp === type_uint64, UInt("hffffffffffffffff", 64),
    Mux(io.typeOp === type_int64,  UInt("h7fffffffffffffff", 64),
    UInt(0, 64))))).toUInt;
val minInteger =
    Mux(io.typeOp === type_uint32, UInt("h00000000ffffffff", 64),
    Mux(io.typeOp === type_int32,  UInt("hffffffff80000000", 64),
    Mux(io.typeOp === type_uint64, UInt("hffffffffffffffff", 64),
    Mux(io.typeOp === type_int64,  UInt("h8000000000000000", 64),
    UInt(0, 64))))).toUInt;

// Calculate the shift count:
val isValidShift = (exponent(8,6) === UInt("b100",3) || isZeroOrOne);
val shift_count =
    Mux(exponent(8,6) === UInt("b100",3),  Cat(UInt(0,1),~exponent(5,0)),
    Mux(isZeroOrOne,                     UInt("b1000000",7),
    UInt(0,7)));

// Construct the initial 64- bit unsigned integer with
// leading 1 digit at the MSB.

// Arrays for storing intermediate values between log shifting stages.
val shift_vector = new Array[UInt](STAGES+1);
val lsb_vector   = new Array[UInt](STAGES+1);

shift_vector(0) = Cat(UInt(1,1), io.in(SIG_WIDTH-1,0), Fill(INT_WIDTH - SIG_WIDTH, UInt(0,1)));
lsb_vector(0)   = UInt(0, 1); // Track a sticky LSB.

// Generate a logarithmic array of shifter stages.
for (i <- 0 until STAGES) {
    val shift_stage = Module(new shift_right_track_lsbs(SHIFT_WIDTH, 1 << i))
    //register_child(shift_stage);
    shift_stage.io.do_shift := shift_count(i);
    shift_stage.io.in       := shift_vector(i);
    shift_stage.io.in_lsb   := lsb_vector(i);
    shift_vector(i+1) = shift_stage.io.out;
    lsb_vector(i+1)   = shift_stage.io.out_lsb;
}

// 
val absolute_int = Cat(UInt(0, 1), shift_vector(STAGES));
val lsbs         = Cat(absolute_int(1,0), lsb_vector(STAGES));

// Check if rounding is necessary
val roundExact = ((lsbs(1,0) === UInt("b00",2)) && ~isTiny) || isZero;

// Determine the rounding offsets
val roundOffset =
    Mux(io.roundingMode === round_nearest_even,
             (lsbs(1,0) === UInt("b11",2) || lsbs(2,1) === UInt("b11",2)),
    Mux(io.roundingMode === round_minMag,       UInt(0,1),
    Mux(io.roundingMode === round_min,          (sign & ~roundExact),
    Mux(io.roundingMode === round_max,          (~sign & ~roundExact),
    UInt(0,1))))).toUInt;

// For convenience, extract the last shifted value from the shift vectors.
val absolute_round = absolute_int(SHIFT_WIDTH,1).toUInt + roundOffset; // BCR: Extract needed?
val signed_int = Mux(sign, -absolute_round, absolute_round)(INT_WIDTH-1, 0); // BCR: Extract needed?

// If casting to signed, valid if in range, including max neg int.
// If casting a positive float to unsigned, it is valid if in range.
// If casting a negative float to unsigned, check round to zero.
val isValidExp = (exponent < maxExponent);
val isRoundToZero = (sign && (isZeroOrOne || isTiny) && signed_int(1,0) === UInt(0,2));
val isValidUnsigned =
    Mux(isValidShift && !sign, (absolute_round(INT_WIDTH-1,0).toUInt <= maxInteger), // BCR: LE Op OK?
    Mux(!sign,                 isTiny,
    Bool(false)));

val isValidSigned =
    Mux(isValidShift && !sign, (absolute_round(INT_WIDTH-1,0).toUInt <= maxInteger), // BCR: LE Op OK?
    Mux(isValidShift && sign,  (absolute_round(INT_WIDTH-1,0).toUInt <= maxInteger+UInt(1)), // BCR: LE Op OK?
    isTiny));

val isValid =
    Mux(io.typeOp === type_uint32, ((isValidUnsigned) || isRoundToZero),
    Mux(io.typeOp === type_int32,  (isValidSigned || io.in === maxNegFloat),
    Mux(io.typeOp === type_uint64, ((!sign && isValidExp) || isRoundToZero),
    Mux(io.typeOp === type_int64,  (isValidExp || io.in === maxNegFloat),
    Bool(false)))));

val out_near_zero =
    Mux(io.roundingMode === round_nearest_even, Fill(INT_WIDTH, UInt(0,1)),
    Mux(io.roundingMode === round_minMag,       Fill(INT_WIDTH, UInt(0,1)),
    Mux(io.roundingMode === round_min,          Fill(INT_WIDTH, roundOffset),
        /* roundingMode === round_max */        Cat(Fill(INT_WIDTH -1, UInt(0,1)), roundOffset))));

io.out  :=
    Mux(isTiny,                     out_near_zero,
    Mux(~isValid && ~sign || isNaN, maxInteger,
    Mux(~isValid &&  sign,          minInteger,
                                    signed_int(INT_WIDTH-1,0))));

io.exceptionFlags := Cat(~isValid, UInt(0,4));

}
