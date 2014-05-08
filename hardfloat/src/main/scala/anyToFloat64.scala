//
// anyToFloat64
// Author: Brian Richards, 4/10/21/2011
//

package hardfloat

import Chisel._
import Node._;

class anyToFloat64_io extends Bundle() {
  val in =             UInt(INPUT, 64);
  val roundingMode =   UInt(INPUT, 2);
  val typeOp =         UInt(INPUT, 2);
  val out =            UInt(OUTPUT, 64);
  val exceptionFlags = UInt(OUTPUT, 5);
}

class anyToFloat64 extends Module {
  override val io = new anyToFloat64_io();

  val any_to_rf64  = new anyToRecodedFloat64();
  val rf64_to_f64 = new recodedFloat64ToFloat64();

  any_to_rf64.io.in             <> io.in;
  any_to_rf64.io.roundingMode   <> io.roundingMode;
  any_to_rf64.io.typeOp         <> io.typeOp;
  any_to_rf64.io.exceptionFlags <> io.exceptionFlags;
  any_to_rf64.io.out            <> rf64_to_f64.io.in;

  rf64_to_f64.io.out            <> io.out;
}
