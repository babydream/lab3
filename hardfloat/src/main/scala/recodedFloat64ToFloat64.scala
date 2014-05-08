package hardfloat

import Chisel._
import Node._;

class recodedFloat64ToFloat64_io extends Bundle {
  val in  = UInt(INPUT, 65);
  val out = UInt(OUTPUT, 64);
}

class recodedFloat64ToFloat64 extends Module {
  override val io = new recodedFloat64ToFloat64_io();
  val sign    = io.in(64);
  val expIn   = io.in(63,52).toUInt;
  val fractIn = io.in(51,0);

  val exp01_isHighSubnormalIn = ( expIn(9,0).toUInt < UInt(2,10) );
  val isSubnormal =
        ( expIn(11,9) === UInt("b001",3) ) | 
        ( ( expIn(11,10) === UInt("b01",2) ) & exp01_isHighSubnormalIn );
  val isNormal    =
        ( ( expIn(11,10) === UInt("b01",2) ) & ~ exp01_isHighSubnormalIn ) | 
        ( expIn(11,10) === UInt("b10",2) );
  val isSpecial   = ( expIn(11,10) === UInt("b11",2) );
  val isNaN       = isSpecial & expIn(9);

  val denormShiftCount = UInt(2,6) - expIn(5,0).toUInt;
  val subnormal_fractOut = (Cat(UInt(1,1), fractIn) >> denormShiftCount.toUInt)(51,0);
  val normal_expOut = (expIn - UInt("b010000000001",12).toUInt)(10,0);

  val expOut = ( Mux(isNormal,  normal_expOut,         UInt(0,11) ) ) | 
               ( Mux(isSpecial, UInt("b11111111111",11), UInt(0,11) ) );
  val fractOut = ( Mux(isSubnormal,      subnormal_fractOut, UInt(0,52) ) ) |
                 ( Mux(isNormal | isNaN, fractIn,            UInt(0,52) ) );

  io.out := Cat(sign, expOut, fractOut);
}
