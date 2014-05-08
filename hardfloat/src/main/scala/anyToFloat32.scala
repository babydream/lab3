//
// anyToFloat32
// Author: Brian Richards, 5/17/2011, U. C. Berkeley
//

package hardfloat

import Chisel._
import Node._;

class anyToFloat32_io extends Bundle() {
  val in =             UInt(INPUT, 64);
  val roundingMode =   UInt(INPUT, 2);
  val typeOp =         UInt(INPUT, 2);
  val out =            UInt(OUTPUT, 32);
  val exceptionFlags = UInt(OUTPUT, 5);
}

class anyToFloat32 extends Module {
  override val io = new anyToFloat32_io();

  val any_to_rf32  = new anyToRecodedFloat32();
  val rf32_to_f32 = new recodedFloat32ToFloat32();

  any_to_rf32.io.in             <> io.in;
  any_to_rf32.io.roundingMode   <> io.roundingMode;
  any_to_rf32.io.typeOp         <> io.typeOp;
  any_to_rf32.io.exceptionFlags <> io.exceptionFlags;
  any_to_rf32.io.out            <> rf32_to_f32.io.in;

  rf32_to_f32.io.out            <> io.out;
}
