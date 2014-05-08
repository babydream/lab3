//*** THIS MODULE HAS NOT BEEN FULLY OPTIMIZED.
//*** DO THIS ANOTHER WAY?

package hardfloat

import Chisel._;
import Node._;
import addSubRecodedFloat64_1._;

object addSubRecodedFloat64_1 {
  val round_nearest_even = UInt("b00",2);
  val round_minMag       = UInt("b01",2);
  val round_min          = UInt("b10",2);
  val round_max          = UInt("b11",2);
}

class addSubRecodedFloat64_1_io() extends Bundle{
  val op = UInt(INPUT, 1);
  val a = UInt(INPUT, 65);
  val b = UInt(INPUT, 65);
  val roundingMode = UInt(INPUT, 2);
  val out = UInt(OUTPUT, 65);
  val exceptionFlags = UInt(OUTPUT, 5);
}

class addSubRecodedFloat64_1 extends Module{
    override val io = new addSubRecodedFloat64_1_io();
    val signA  = io.a(64);
    val expA   = io.a(63,52).toUInt;
    val fractA = io.a(51,0).toUInt;
    val isZeroA = ( expA(11,9) === UInt("b000",3) );
    val isSpecialA = ( expA(11,10) === UInt("b11",2) );
    val isInfA = isSpecialA & ~ expA(9).toBool;
    val isNaNA = isSpecialA &   expA(9).toBool;
    val isSigNaNA = isNaNA & ~ fractA(51).toBool;
    val sigA = Cat(~ isZeroA, fractA);

    val opSignB = io.op ^ io.b(64);
    val expB    = io.b(63,52).toUInt;
    val fractB  = io.b(51,0).toUInt;
    val isZeroB = ( expB(11,9) === UInt("b000",3) );
    val isSpecialB = ( expB(11,10) === UInt("b11",2) );
    val isInfB = isSpecialB & ~ expB(9).toBool;
    val isNaNB = isSpecialB &   expB(9).toBool;
    val isSigNaNB = isNaNB & ~ fractB(51).toBool;
    val sigB = Cat(~ isZeroB, fractB);

    val roundingMode_nearest_even = ( io.roundingMode === round_nearest_even );
    val roundingMode_minMag       = ( io.roundingMode === round_minMag       );
    val roundingMode_min          = ( io.roundingMode === round_min          );
    val roundingMode_max          = ( io.roundingMode === round_max          );


    //| `satAbsDiffExps' is the distance to shift the significand of the operand
    //| with the smaller exponent, maximized to 63.

//*** USE SIGN FROM `sSubExps'?
    val hasLargerExpB = ( expA < expB );
    val signLarger = Mux(hasLargerExpB, opSignB , signA).toBool;
    val expLarger  = Mux(hasLargerExpB, expB    , expA);
    val sigLarger  = Mux(hasLargerExpB, sigB    , sigA);
    val sigSmaller = Mux(hasLargerExpB, sigA    , sigB);

    val eqOpSigns = ( signA === opSignB );
    val sSubExps = Cat(UInt("b0",1), expA).toUInt - expB;
//*** IMPROVE?
    val overflowSubExps =
          ( sSubExps(12,6) != UInt(0) ) &
          ( ( sSubExps(12,6) != UInt("b1111111",7) ) | ( sSubExps(5,0) === UInt(0) ) );
    val wrapAbsDiffExps =
        Mux(hasLargerExpB, expB(5,0) - expA(5,0) , sSubExps(5,0));
    val satAbsDiffExps = wrapAbsDiffExps | ( Mux(overflowSubExps, UInt(63) , UInt(0) ));
    val doCloseSubMags =
        ~ eqOpSigns & ~ overflowSubExps & ( wrapAbsDiffExps <= UInt(1) );

    //-----------------------------------------------------------------
    //| The close-subtract case.
    //|   If the difference significand < 1, it must be exact (when normalized).
    //| If it is < 0 (negative), the round bit will in fact be 0.  If the
    //| difference significand is > 1, it may be inexact, but the rounding
    //| increment cannot carry out (because that would give a rounded difference
    //| >= 2, which is impossibly large).  Hence, the rounding increment can
    //| be done before normalization.  (A significand >= 1 is unaffected by
    //| normalization, whether done before or after rounding.)  The increment
    //| for negation and for rounding are combined before normalization.
    //------------------------------------------------------------------
//*** MASK SIGS TO SAVE ENERGY?  (ALSO EMPLOY LATER WHEN MERGING TWO PATHS.)
    val close_alignedSigSmaller =
        Mux( ( expA(0) === expB(0) ) , Cat(sigSmaller, UInt("b0",1)) , Cat(UInt("b0",1), sigSmaller)).toUInt;
    val close_sSigSum = Cat(UInt("b0",1), sigLarger, UInt("b0",1)).toUInt - close_alignedSigSmaller;
    val close_signSigSum = close_sSigSum(54).toBool;
    val close_pos_isNormalizedSigSum = close_sSigSum(53);
    val close_roundInexact =
        close_sSigSum(0) & close_pos_isNormalizedSigSum;
    val close_roundIncr =
        close_roundInexact &
              (   ( roundingMode_nearest_even & UInt(1)            ) |
                  ( roundingMode_minMag       & UInt(0)            ) |
                  ( roundingMode_min          &   signLarger ) |
                  ( roundingMode_max          & ~ signLarger )
              );
    val close_roundEven = roundingMode_nearest_even & close_roundInexact;
    val close_negSigSumA =
        Mux(close_signSigSum, ~ close_sSigSum(53,1) , close_sSigSum(53,1));
    val close_sigSumAIncr = close_signSigSum | close_roundIncr;
    val close_roundedAbsSigSumAN = close_negSigSumA + close_sigSumAIncr.toUInt;
    val close_roundedAbsSigSum =
        Cat(close_roundedAbsSigSumAN(52,1),
         close_roundedAbsSigSumAN(0) & ~ close_roundEven,
         close_sSigSum(0) & ~ close_pos_isNormalizedSigSum);
    val close_norm_in = Cat(close_roundedAbsSigSum, UInt("b0",10));
    val close_normalizeSigSum = Module(new normalize64)
    close_normalizeSigSum.io.in := close_norm_in;
    val close_norm_count = close_normalizeSigSum.io.distance.toUInt;
    val close_norm_out = close_normalizeSigSum.io.out;

    val close_isZeroY = ~ close_norm_out(63).toBool;
    val close_signY = ~ close_isZeroY & ( signLarger ^ close_signSigSum );
//*** COMBINE EXP ADJUST ADDERS FOR CLOSE AND FAR PATHS?
    val close_expY = expLarger - close_norm_count;
    val close_fractY = close_norm_out(62,11);

    //--------------------------------------------------------------
    // The far/add case.
    //   `far_sigSum' has two integer bits and a value in the range (1/2, 4).
    //-------------------------------------------------------------
//*** MASK SIGS TO SAVE ENERGY?  (ALSO EMPLOY LATER WHEN MERGING TWO PATHS.)
//*** BREAK UP COMPUTATION OF EXTRA MASK?
    val far_roundExtraMask =
        Cat(( UInt(55) <= satAbsDiffExps ), ( UInt(54) <= satAbsDiffExps ),
         ( UInt(53) <= satAbsDiffExps ), ( UInt(52) <= satAbsDiffExps ),
         ( UInt(51) <= satAbsDiffExps ), ( UInt(50) <= satAbsDiffExps ),
         ( UInt(49) <= satAbsDiffExps ), ( UInt(48) <= satAbsDiffExps ),
         ( UInt(47) <= satAbsDiffExps ), ( UInt(46) <= satAbsDiffExps ),
         ( UInt(45) <= satAbsDiffExps ), ( UInt(44) <= satAbsDiffExps ),
         ( UInt(43) <= satAbsDiffExps ), ( UInt(42) <= satAbsDiffExps ),
         ( UInt(41) <= satAbsDiffExps ), ( UInt(40) <= satAbsDiffExps ),
         ( UInt(39) <= satAbsDiffExps ), ( UInt(38) <= satAbsDiffExps ),
         ( UInt(37) <= satAbsDiffExps ), ( UInt(36) <= satAbsDiffExps ),
         ( UInt(35) <= satAbsDiffExps ), ( UInt(34) <= satAbsDiffExps ),
         ( UInt(33) <= satAbsDiffExps ), ( UInt(32) <= satAbsDiffExps ),
         ( UInt(31) <= satAbsDiffExps ), ( UInt(30) <= satAbsDiffExps ),
         ( UInt(29) <= satAbsDiffExps ), ( UInt(28) <= satAbsDiffExps ),
         ( UInt(27) <= satAbsDiffExps ), ( UInt(26) <= satAbsDiffExps ),
         ( UInt(25) <= satAbsDiffExps ), ( UInt(24) <= satAbsDiffExps ),
         ( UInt(23) <= satAbsDiffExps ), ( UInt(22) <= satAbsDiffExps ),
         ( UInt(21) <= satAbsDiffExps ), ( UInt(20) <= satAbsDiffExps ),
         ( UInt(19) <= satAbsDiffExps ), ( UInt(18) <= satAbsDiffExps ),
         ( UInt(17) <= satAbsDiffExps ), ( UInt(16) <= satAbsDiffExps ),
         ( UInt(15) <= satAbsDiffExps ), ( UInt(14) <= satAbsDiffExps ),
         ( UInt(13) <= satAbsDiffExps ), ( UInt(12) <= satAbsDiffExps ),
         ( UInt(11) <= satAbsDiffExps ), ( UInt(10) <= satAbsDiffExps ),
         (  UInt(9) <= satAbsDiffExps ), (  UInt(8) <= satAbsDiffExps ),
         (  UInt(7) <= satAbsDiffExps ), (  UInt(6) <= satAbsDiffExps ),
         (  UInt(5) <= satAbsDiffExps ), (  UInt(4) <= satAbsDiffExps ),
         (  UInt(3) <= satAbsDiffExps ));
//*** USE `wrapAbsDiffExps' AND MASK RESULT?
    val far_alignedSigSmaller =
        Cat(Cat(sigSmaller, UInt("b0",2))>>satAbsDiffExps,
         ( ( sigSmaller & far_roundExtraMask ) != UInt(0) ));
    val far_negAlignedSigSmaller =
        Mux(eqOpSigns , Cat(UInt("b0",1), far_alignedSigSmaller),
              Cat(UInt("b1",1), ~ far_alignedSigSmaller)).toUInt;
    val far_sigSumIncr = ~ eqOpSigns;
    val far_sigSum =
        Cat(UInt("b0",1), sigLarger, UInt("b0",3)).toUInt + far_negAlignedSigSmaller + far_sigSumIncr.toUInt;
    val far_sumShift1  = far_sigSum(56).toBool;
    val far_sumShift0  = ( far_sigSum(56,55) === UInt("b01",2) );
    val far_sumShiftM1 = ( far_sigSum(56,55) === UInt("b00",2) );
    val far_fractX =
          ( Mux(far_sumShift1, Cat(far_sigSum(55,3), ( far_sigSum(2,0) != UInt(0) )) , UInt(0) )) |
          ( Mux(far_sumShift0, Cat(far_sigSum(54,2), ( far_sigSum(1,0) != UInt(0) )) , UInt(0) )) |
          ( Mux(far_sumShiftM1, far_sigSum(53,0)                            , UInt(0) ));

    val far_roundInexact = ( far_fractX(1,0) != UInt(0) );
    val far_roundIncr =
          ( roundingMode_nearest_even & far_fractX(1)                   ) |
          ( roundingMode_minMag       & UInt(0)                          ) |
          ( roundingMode_min          &   signLarger & far_roundInexact ) |
          ( roundingMode_max          & ~ signLarger & far_roundInexact );
    val far_roundEven =
        roundingMode_nearest_even & ( far_fractX(1,0) === UInt("b10",2) );
    val far_cFractYN = ( far_fractX.toUInt>>UInt(2) ) + far_roundIncr.toUInt;
    val far_roundCarry = far_cFractYN(52).toBool;
//*** COMBINE EXP ADJUST ADDERS FOR CLOSE AND FAR PATHS?
    val far_expAdjust =
          Mux( far_sumShift1 | ( far_sumShift0 & far_roundCarry ) , UInt(1) , UInt(0) ) |
          ( Mux(far_sumShiftM1 & ~ far_roundCarry, UInt("b111111111111",12) , UInt(0) ));
    val far_expY = expLarger + far_expAdjust.toUInt;
    val far_fractY =
        Cat(far_cFractYN(51,1), far_cFractYN(0) & ~ far_roundEven);


    val isZeroY = doCloseSubMags & close_isZeroY;
    val signY  = Mux(doCloseSubMags, close_signY  , signLarger);
    val expY   = Mux(doCloseSubMags, close_expY   , far_expY);
    val fractY = Mux(doCloseSubMags, close_fractY , far_fractY);
    val overflowY = ~ doCloseSubMags & ( far_expY(11,10) === UInt("b11",2) );
    val inexactY = Mux(doCloseSubMags, close_roundInexact , far_roundInexact);

    val overflowY_roundMagUp =
        roundingMode_nearest_even | ( roundingMode_min & signLarger ) |
              ( roundingMode_max & ~ signLarger );


    val addSpecial = isSpecialA | isSpecialB;
    val addZeros = isZeroA & isZeroB;
    val commonCase = ~ addSpecial & ~ addZeros;

    val common_invalid = isInfA & isInfB & ~ eqOpSigns;
    val invalid = isSigNaNA | isSigNaNB | common_invalid;
    val overflow = commonCase & overflowY;
    val inexact = overflow | ( commonCase & inexactY );

    val notSpecial_isZeroOut = addZeros | isZeroY;
    val isSatOut = overflow & ~ overflowY_roundMagUp;
    val notNaN_isInfOut =
        isInfA | isInfB | ( overflow & overflowY_roundMagUp );
    val isNaNOut = isNaNA | isNaNB | common_invalid;

    val signOut =
          ( eqOpSigns              & signA   ) |
          ( isNaNA                 & signA   ) |
          ( ~ isNaNA & isNaNB      & opSignB ) |
          ( isInfA & ~ isSpecialB  & signA   ) |
          ( ~ isSpecialA & isInfB  & opSignB ) |
          ( invalid                & UInt(0)       ) |
          ( addZeros & ~ eqOpSigns & UInt(0)       ) |
          ( commonCase             & signY   );
    val expOut =
        (   expY &
            ~ ( Mux(notSpecial_isZeroOut, UInt("b111000000000",12) , UInt(0) )) &
            ~ ( Mux(isSatOut, UInt("b010000000000",12) , UInt(0) )) &
            ~ ( Mux(notNaN_isInfOut, UInt("b001000000000",12) , UInt(0) )) ) |
            ( Mux(isSatOut, UInt("b101111111111",12) , UInt(0) )) |
            ( Mux(notNaN_isInfOut, UInt("b110000000000",12) , UInt(0) )) |
            ( Mux(isNaNOut, UInt("b111000000000",12) , UInt(0) ));
    val fractOut = fractY | ( Mux(isNaNOut | isSatOut, UInt("hFFFFFFFFFFFFF",52) , UInt(0) ));
    io.out := Cat(signOut, expOut, fractOut);

    io.exceptionFlags := Cat(invalid, UInt("b0",1), overflow, UInt("b0",1), inexact);

}
