//*** THIS MODULE HAS NOT BEEN FULLY OPTIMIZED.

package hardfloat

import Chisel._;
import Node._;
import mulRecodedFloat32_1._;

object mulRecodedFloat32_1 {
  val round_nearest_even = UInt("b00",2);
  val round_minMag       = UInt("b01",2);
  val round_min          = UInt("b10",2);
  val round_max          = UInt("b11",2);
}

class mulRecodedFloat32_1_io() extends Bundle{
  val a = UInt(INPUT, 33);
  val b = UInt(INPUT, 33);
  val roundingMode = UInt(INPUT, 2);
  val out = UInt(OUTPUT, 33);
  val exceptionFlags = UInt(OUTPUT, 5);
}

class mulRecodedFloat32_1 extends Module{
    override val io = new mulRecodedFloat32_1_io();
    val signA  = io.a(32);
    val expA   = io.a(31,23).toUInt;
    val fractA = io.a(22,0).toUInt;
    val isZeroA = ( expA(8,6) === UInt("b000",3) );
    val isSpecialA = ( expA(8,7) === UInt("b11",2) );
    val isInfA = isSpecialA & ~ expA(6).toBool;
    val isNaNA = isSpecialA &   expA(6).toBool;
    val isSigNaNA = isNaNA & ~ fractA(22).toBool;
    val sigA = Cat(~ isZeroA, fractA).toUInt;

    val signB  = io.b(32);
    val expB   = io.b(31,23).toUInt;
    val fractB = io.b(22,0).toUInt;
    val isZeroB = ( expB(8,6) === UInt("b000",3) );
    val isSpecialB = ( expB(8,7) === UInt("b11",2) );
    val isInfB = isSpecialB & ~ expB(6).toBool;
    val isNaNB = isSpecialB &   expB(6).toBool;
    val isSigNaNB = isNaNB & ~ fractB(22).toBool;
    val sigB = Cat(~ isZeroB, fractB).toUInt;

    val roundingMode_nearest_even = ( io.roundingMode === round_nearest_even );
    val roundingMode_minMag       = ( io.roundingMode === round_minMag       );
    val roundingMode_min          = ( io.roundingMode === round_min          );
    val roundingMode_max          = ( io.roundingMode === round_max          );

    val signOut = signA ^ signB;

    val sSumExps = expA + Cat(Fill(2, ~ expB(8)), expB(7,0)).toUInt;
    val notNeg_sumExps = sSumExps(8,0);
    val sigProd = sigA * sigB;
    val prodShift1 = sigProd(47).toBool;
    val sigProdX = Cat(sigProd(47,22), ( sigProd(21,0) != UInt(0) )).toUInt;

//*** FIRST TWO BITS NEEDED?
    val roundMask =
//*** OPTIMIZE.
        Cat(( notNeg_sumExps <= UInt("b001101001",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001101010",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001101011",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001101100",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001101101",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001101110",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001101111",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001110000",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001110001",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001110010",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001110011",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001110100",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001110101",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001110110",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001110111",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001111000",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001111001",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001111010",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001111011",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001111100",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001111101",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001111110",9).toUInt ),
         ( notNeg_sumExps <= UInt("b001111111",9).toUInt ),
         ( notNeg_sumExps <= UInt("b010000000",9).toUInt ),
         ( notNeg_sumExps <= UInt("b010000001",9).toUInt ) | prodShift1,
         UInt("b11",2));
    val roundPosMask = ~ Cat(UInt("b0",1), roundMask>>UInt(1)) & roundMask;
    val roundIncr =
          ( Mux(roundingMode_nearest_even, roundPosMask , UInt(0) )) |
          ( Mux( Mux(signOut, roundingMode_min , roundingMode_max ) , roundMask
                , UInt(0) ));
    val roundSigProdX = sigProdX + Cat(UInt("b0",1), roundIncr).toUInt;
    val roundPosBit = ( ( sigProdX & roundPosMask ) != UInt(0) );
    val anyRoundExtra = ( ( sigProdX & roundMask>>UInt(1) ) != UInt(0) );
    val roundInexact = roundPosBit | anyRoundExtra;
    val roundEven =
        roundingMode_nearest_even & roundPosBit & ! anyRoundExtra;
    val sigProdY =
        roundSigProdX>>UInt(2) & ~ ( Mux(roundEven, roundMask>>UInt(1) , roundMask>>UInt(2) ));
//*** COMPOUND ADD FOR `sSumExps'?
    val sExpY = sSumExps + sigProdY(25,24).toUInt;
    val expY = sExpY(8,0);
    val fractY = Mux(prodShift1, sigProdY(23,1) , sigProdY(22,0));

    val overflowY = ( sExpY(9,7) === UInt("b011",3) );
//*** CHANGE TO USE `sSumExps'/`notNeg_sumExps'?
    val totalUnderflowY = sExpY(9) | ( sExpY(8,0) < UInt("b001101011",9).toUInt );
    val underflowY =
//*** REPLACE?:
        totalUnderflowY |
//*** USE EARLIER BITS FROM `roundMask'?
              ( ( notNeg_sumExps <=
                         ( Mux(prodShift1, UInt("b010000000",9) , UInt("b010000001",9) ) ).toUInt) &
                      roundInexact );
    val inexactY = roundInexact;

    val overflowY_roundMagUp =
        roundingMode_nearest_even | ( roundingMode_min & signOut ) |
              ( roundingMode_max & ~ signOut );


    val mulSpecial = isSpecialA | isSpecialB;
    val commonCase = ~ mulSpecial & ~ isZeroA & ~ isZeroB;

    val common_invalid = ( isInfA & isZeroB ) | ( isZeroA & isInfB );
    val invalid = isSigNaNA | isSigNaNB | common_invalid;
    val overflow = commonCase & overflowY;
    val underflow = commonCase & underflowY;
//*** SPEED BY USING `commonCase & totalUnderflowY' INSTEAD OF `underflow'?
    val inexact = overflow | underflow | ( commonCase & inexactY );

    val notSpecial_isZeroOut = isZeroA | isZeroB | totalUnderflowY;
    val isSatOut = overflow & ~ overflowY_roundMagUp;
    val notNaN_isInfOut =
        isInfA | isInfB | ( overflow & overflowY_roundMagUp );
    val isNaNOut = isNaNA | isNaNB | common_invalid;

    val expOut =
        (   expY &
            ~ ( Mux(notSpecial_isZeroOut, UInt("b111000000",9) , UInt(0) )) &
            ~ ( Mux(isSatOut, UInt("b010000000",9) , UInt(0) )) &
            ~ ( Mux(notNaN_isInfOut, UInt("b001000000",9) , UInt(0) )) ) |
            ( Mux(isSatOut, UInt("b101111111",9) , UInt(0) )) |
            ( Mux(notNaN_isInfOut, UInt("b110000000",9) , UInt(0) )) |
            ( Mux(isNaNOut, UInt("b111000000",9) , UInt(0) ));
    val fractOut = fractY | ( Mux(isNaNOut | isSatOut, UInt("h7FFFFF",23) , UInt(0) ));
    io.out := Cat(signOut, expOut, fractOut);

    io.exceptionFlags := Cat(invalid, UInt("b0",1), overflow, underflow, inexact);

}
