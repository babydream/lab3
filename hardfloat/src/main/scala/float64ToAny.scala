//
// float64ToAny
// Author: Brian Richards, 4/10/21/2011
//

package hardfloat

import Chisel._
import Node._;

class float64ToAny_io extends Bundle() {
  val in =             UInt(INPUT, 64);
  val roundingMode =   UInt(INPUT, 2);
  val typeOp =         UInt(INPUT, 2);
  val out =            UInt(OUTPUT, 64);
  val exceptionFlags = UInt(OUTPUT, 5);
}

class float64ToAny extends Module {
  override val io = new float64ToAny_io();

  val f64_to_rf64 = new float64ToRecodedFloat64();
  val rf64_to_any  = new recodedFloat64ToAny();

  f64_to_rf64.io.in            <> io.in;
  f64_to_rf64.io.out           <> rf64_to_any.io.in;
  rf64_to_any.io.roundingMode   <> io.roundingMode;
  rf64_to_any.io.typeOp         <> io.typeOp;
  rf64_to_any.io.out            <> io.out;
  rf64_to_any.io.exceptionFlags <> io.exceptionFlags;
}
