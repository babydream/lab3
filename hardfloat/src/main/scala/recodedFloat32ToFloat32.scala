package hardfloat

import Chisel._
import Node._;

class recodedFloat32ToFloat32_io extends Bundle() {
  val in  = UInt(INPUT, 33);
  val out = UInt(OUTPUT, 32);
}

class recodedFloat32ToFloat32 extends Module {
    override val io = new recodedFloat32ToFloat32_io();

    val sign    = io.in(32);
    val expIn   = io.in(31, 23).toUInt;
    val fractIn = io.in(22, 0).toUInt;
    val exp01_isHighSubnormalIn = ( expIn(6, 0).toUInt < UInt(2, 7) );
    val isSubnormal =
        ( expIn(8, 6) === UInt("b001", 3) ) | 
        ( ( expIn(8, 7) === UInt("b01", 2) ) & exp01_isHighSubnormalIn );
    val isNormal =
        ( ( expIn(8, 7) === UInt("b01", 2) ) & ~ exp01_isHighSubnormalIn ) | 
        ( expIn(8, 7) === UInt("b10", 2) );
    val isSpecial = ( expIn(8, 7) === UInt("b11", 2) );
    val isNaN = isSpecial & expIn(6);

    val denormShiftDist = UInt(2, 5) - expIn(4, 0).toUInt;
    val subnormal_fractOut = Cat(UInt(1, 1), fractIn) >> denormShiftDist(4,0).toUInt;
    val normal_expOut = expIn - UInt("b010000001", 9).toUInt;

    val expOut =
        Mux( isNormal, normal_expOut ,  UInt(0, 8) ) | 
        Mux( isSpecial, UInt("b11111111", 8) ,  UInt(0, 8) );
    val fractOut =
          Mux(isSubnormal,       subnormal_fractOut,  UInt(0, 23) ) | 
          Mux(isNormal | isNaN , fractIn,             UInt(0, 23) );
    io.out := Cat(sign, expOut(7, 0), fractOut(22, 0));
}
