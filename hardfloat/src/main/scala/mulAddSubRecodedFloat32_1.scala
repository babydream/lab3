//*** THIS MODULE HAS NOT BEEN FULLY OPTIMIZED.
//*** DO THIS ANOTHER WAY?

package hardfloat

import Chisel._;
import Node._;
import mulAddSubRecodedFloat32_1._;

class mulAddSubRecodedFloat32_1_io() extends Bundle {
  val op = UInt(INPUT, 2);
  val a = UInt(INPUT, 33)
  val b = UInt(INPUT, 33);
  val c = UInt(INPUT, 33);
  val out = UInt(OUTPUT, 33);
  val roundingMode = UInt(INPUT, 2);
  val exceptionFlags = UInt(OUTPUT, 5);
}

object mulAddSubRecodedFloat32_1 {
  val round_nearest_even =  UInt("b00", 2);
  val round_minMag       =  UInt("b01", 2);
  val round_min          =  UInt("b10", 2);
  val round_max          =  UInt("b11", 2);
}

class mulAddSubRecodedFloat32_1 extends Module {
    override val io = new mulAddSubRecodedFloat32_1_io();
    val signA  = io.a(32);
    val expA   = io.a(31, 23).toUInt;
    val fractA = io.a(22, 0).toUInt;
    val isZeroA = ( expA(8,6) === UInt("b000", 3) );
    val isSpecialA = ( expA(8, 7) === UInt("b11", 2) );
    val isInfA = isSpecialA & ~ expA(6);
    val isNaNA = isSpecialA &   expA(6);
    val isSigNaNA = isNaNA & ~ fractA(22);
    val sigA = Cat(~ isZeroA, fractA).toUInt;

    val signB  = io.b(32);
    val expB   = io.b(31, 23).toUInt;
    val fractB = io.b(22, 0).toUInt;
    val isZeroB = ( expB(8, 6) === UInt("b000", 3) );
    val isSpecialB = ( expB(8, 7) === UInt("b11", 2) );
    val isInfB = isSpecialB & ~ expB(6);
    val isNaNB = isSpecialB &   expB(6);
    val isSigNaNB = isNaNB & ~ fractB(22);
    val sigB = Cat(~ isZeroB, fractB).toUInt;

    val opSignC = io.c(32) ^ io.op(0);
    val expC    = io.c(31, 23).toUInt;
    val fractC  = io.c(22, 0).toUInt;
    val isZeroC = ( expC(8, 6) === UInt("b000", 3) );
    val isSpecialC = ( expC(8, 7) === UInt("b11", 2) );
    val isInfC = isSpecialC & ~ expC(6);
    val isNaNC = isSpecialC &   expC(6);
    val isSigNaNC = isNaNC & ~ fractC(22);
    val sigC = Cat(~ isZeroC, fractC).toUInt;

    val roundingMode_nearest_even = ( io.roundingMode === round_nearest_even );
    val roundingMode_minMag       = ( io.roundingMode === round_minMag       );
    val roundingMode_min          = ( io.roundingMode === round_min          );
    val roundingMode_max          = ( io.roundingMode === round_max          );

    //------------------------------------------------------------------------
    //------------------------------------------------------------------------
    val signProd = signA ^ signB ^ io.op(1);
    val isZeroProd = isZeroA | isZeroB;
    //val sExpAlignedProd = expA + Cat(Fill(~ expB(8), 3), expB(7, 0)) + 27;
    val sExpAlignedProd = Cat(Fill(3, ~ expB(8)), expB(7, 0)).toUInt + expA + UInt(27);
    val sigProd = sigA * sigB;

    //------------------------------------------------------------------------
    //------------------------------------------------------------------------
    val doSubMags = signProd ^ opSignC;

    val sNatCAlignDist = sExpAlignedProd - expC;
    val CAlignDist_floor = isZeroProd | sNatCAlignDist(10);
    val CAlignDist_0 = CAlignDist_floor | ( sNatCAlignDist(9, 0) === UInt(0) );
    val isCDominant =
        ~ isZeroC & ( CAlignDist_floor | ( sNatCAlignDist(9, 0) < UInt(25) ) );
    val CAlignDist =
        Mux(  CAlignDist_floor, UInt(0), 
        Mux(( sNatCAlignDist(9, 0) < UInt(74) ), sNatCAlignDist, 
              UInt(74)))(6,0);
    val sExpSum = Mux(CAlignDist_floor, expC, sExpAlignedProd);
// *** USE `sNatCAlignDist'?
    val CExtraMask =
        Cat(( UInt(74) === CAlignDist ), ( UInt(73) <= CAlignDist ),
         ( UInt(72) <= CAlignDist ), ( UInt(71) <= CAlignDist ),
         ( UInt(70) <= CAlignDist ), ( UInt(69) <= CAlignDist ),
         ( UInt(68) <= CAlignDist ), ( UInt(67) <= CAlignDist ),
         ( UInt(66) <= CAlignDist ), ( UInt(65) <= CAlignDist ),
         ( UInt(64) <= CAlignDist ), ( UInt(63) <= CAlignDist ),
         ( UInt(62) <= CAlignDist ), ( UInt(61) <= CAlignDist ),
         ( UInt(60) <= CAlignDist ), ( UInt(59) <= CAlignDist ),
         ( UInt(58) <= CAlignDist ), ( UInt(57) <= CAlignDist ),
         ( UInt(56) <= CAlignDist ), ( UInt(55) <= CAlignDist ),
         ( UInt(54) <= CAlignDist ), ( UInt(53) <= CAlignDist ),
         ( UInt(52) <= CAlignDist ), ( UInt(51) <= CAlignDist ));
    val negSigC = Mux(doSubMags, ~ sigC, sigC);
    val alignedNegSigC =
        Cat(Cat(Fill(74, doSubMags), negSigC, Fill(50, doSubMags))>>CAlignDist,
            ( ( sigC & CExtraMask ) != UInt(0) ) ^ doSubMags)(74, 0);

    val sigSum = (alignedNegSigC.toUInt + ( sigProd << UInt(1) ))(74,0);

    val estNormPos_a = Cat(doSubMags, alignedNegSigC(49, 1));
    val estNormPos_b = sigProd;
    val estNormPosSigSum = new estNormDistP24PosSum50();
    estNormPosSigSum.io.a := estNormPos_a;
    estNormPosSigSum.io.b := estNormPos_b;
    val estNormPos_dist = estNormPosSigSum.io.out.toUInt;

    val estNormNeg_a = Cat(UInt("b1", 1), alignedNegSigC(49, 1));
    val estNormNeg_b = sigProd;
    val estNormNegSigSum = new estNormDistP24NegSum50();
    estNormNegSigSum.io.a := estNormNeg_a;
    estNormNegSigSum.io.b := estNormNeg_b;
    val estNormNeg_dist = estNormNegSigSum.io.out.toUInt;

    val firstReduceSigSum = Cat(( sigSum(33, 18) != UInt(0) ), ( sigSum(17, 0) != UInt(0) ));
    val notSigSum = ~ sigSum;
    val firstReduceNotSigSum =
        Cat(( notSigSum(33, 18) != UInt(0) ), ( notSigSum(17, 0) != UInt(0) ));
  // *** USE RESULT OF `CAlignDest - 1' TO TEST FOR ZERO?
    val CDom_estNormDist =
        Mux(CAlignDist_0 | doSubMags, CAlignDist, CAlignDist - UInt(1))(4,0);
    val CDom_firstNormAbsSigSum =
          ( Mux(~ doSubMags & ~ CDom_estNormDist(4),
              Cat(sigSum(74, 34), ( firstReduceSigSum != UInt(0) )),
              UInt(0)) 
          ) | 
          ( Mux(~ doSubMags & CDom_estNormDist(4),
              Cat(sigSum(58, 18), firstReduceSigSum(0)),
              UInt(0)) 
          ) | 
          ( Mux(doSubMags & ~ CDom_estNormDist(4),
              Cat(notSigSum(74, 34), ( firstReduceNotSigSum != UInt(0) )),
              UInt(0)) 
          )|
          ( Mux(doSubMags & CDom_estNormDist(4),
               Cat(notSigSum(58, 18), firstReduceNotSigSum(0)),
               UInt(0))
          );
       
    //------------------------------------------------------------------------
    // (For this case, bits above `sigSum(50)' are never interesting.  Also,
    // if there is any significant cancellation, then `sigSum(0)' must equal
    // `doSubMags'.)
    //------------------------------------------------------------------------
    val notCDom_pos_firstNormAbsSigSum =
          ( Mux(( estNormPos_dist(5, 4) === UInt("b01", 2) ),
               Cat(sigSum(50, 18),
                   Mux(doSubMags , ~ firstReduceNotSigSum(0) , firstReduceSigSum(0))),
               UInt(0))) |
          ( Mux(( estNormPos_dist(5, 4) === UInt("b10", 2) ) , sigSum(42, 1) , UInt(0) )) |
          ( Mux(( estNormPos_dist(5, 4) === UInt("b11", 2) ) , Cat(sigSum(26, 1), Fill(16, doSubMags)), 
                 UInt(0) )) |
          ( Mux(( estNormPos_dist(5, 4) === UInt("b00", 2) ) , Cat(sigSum(10, 1), Fill(32, doSubMags)),
                   UInt(0) ));
    //------------------------------------------------------------------------
    // (For this case, bits above `notSigSum(49)' are never interesting.  Also,
    // if there is any significant cancellation, then `notSigSum(0)' must be
    // zero.)
    //------------------------------------------------------------------------

    val notCDom_neg_cFirstNormAbsSigSum =
          Mux(( estNormNeg_dist(5, 4) === UInt("b01", 2) ),
                Cat(UInt(0, 10), notSigSum(49, 18), firstReduceNotSigSum(0)),
                 UInt(0)) |
          Mux(( estNormNeg_dist(5, 4) === UInt("b10", 2) ) , notSigSum(43, 1)     , UInt(0) ) |
          Mux(( estNormNeg_dist(5, 4) === UInt("b11", 2) ) , (notSigSum(27, 1)) << UInt(16) , UInt(0) ) |
          Mux(( estNormNeg_dist(5, 4) === UInt("b00", 2) ) , (notSigSum(11, 1)) << UInt(32), UInt(0) );
    val notCDom_signSigSum = sigSum(51);
    val doNegSignSum =
        Mux(isCDominant, doSubMags & ~ isZeroC, notCDom_signSigSum);
    val estNormDist =
          Mux(  isCDominant                       , CDom_estNormDist, UInt(0) ) |
          Mux(~ isCDominant & ~ notCDom_signSigSum, estNormPos_dist , UInt(0) ) |
          Mux(~ isCDominant &   notCDom_signSigSum, estNormNeg_dist , UInt(0) );
    val cFirstNormAbsSigSum =
          Mux(isCDominant , CDom_firstNormAbsSigSum , UInt(0) ) |
          ( Mux(~ isCDominant & ~ notCDom_signSigSum, 
                notCDom_pos_firstNormAbsSigSum,
                UInt(0))
          ) |
          ( Mux(~ isCDominant & notCDom_signSigSum,
                notCDom_neg_cFirstNormAbsSigSum,
                UInt(0))
          );
    val doIncrSig = ~ isCDominant & ~ notCDom_signSigSum & doSubMags;
    val normTo2ShiftDist = ~ estNormDist(3, 0);
    val absSigSumExtraMask =
        Cat(( estNormDist(3, 0) ===  UInt(0) ), ( estNormDist(3, 0) <=  UInt(1) ),
         ( estNormDist(3, 0) <=  UInt(2) ), ( estNormDist(3, 0) <=  UInt(3) ),
         ( estNormDist(3, 0) <=  UInt(4) ), ( estNormDist(3, 0) <=  UInt(5) ),
         ( estNormDist(3, 0) <=  UInt(6) ), ( estNormDist(3, 0) <=  UInt(7) ),
         ( estNormDist(3, 0) <=  UInt(8) ), ( estNormDist(3, 0) <=  UInt(9) ),
         ( estNormDist(3, 0) <= UInt(10) ), ( estNormDist(3, 0) <= UInt(11) ),
         ( estNormDist(3, 0) <= UInt(12) ), ( estNormDist(3, 0) <= UInt(13) ),
         ( estNormDist(3, 0) <= UInt(14) ), UInt("b1", 1));
    val sigX3 =
        Cat(cFirstNormAbsSigSum(42, 1)>>normTo2ShiftDist,
         Mux(doIncrSig,
            ( ( ~ cFirstNormAbsSigSum(15, 0) & absSigSumExtraMask ) === UInt(0) ),
            ( (   cFirstNormAbsSigSum(15, 0) & absSigSumExtraMask ) != UInt(0) )))(27, 0);
    val sigX3Shift1 = ( sigX3(27, 26) === UInt(0) );
    val sExpX3 = sExpSum - estNormDist;

    val isZeroY = ( sigX3(27, 25) === UInt(0) );
    val signY = ~ isZeroY & ( signProd ^ doNegSignSum );
    val roundMask =
          Mux(sExpX3(10) , UInt("h7FFFFFF", 27),
          Cat( (sExpX3(9, 0) <= UInt("b0001101010", 10).toUInt ) ,
           ( sExpX3(9, 0) <= UInt("b0001101011", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001101100", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001101101", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001101110", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001101111", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001110000", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001110001", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001110010", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001110011", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001110100", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001110101", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001110110", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001110111", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001111000", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001111001", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001111010", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001111011", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001111100", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001111101", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001111110", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0001111111", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0010000000", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0010000001", 10).toUInt  ),
           ( sExpX3(9, 0) <= UInt("b0010000010", 10).toUInt  ) | sigX3(26),
           UInt("b11", 2)));
    val roundPosMask = ~ Cat(UInt("b0", 1), roundMask>>UInt(1)) & roundMask;
    val roundPosBit = ( ( sigX3 & roundPosMask ) != UInt(0, 28) );
    val anyRoundExtra = ( (   sigX3 & roundMask>>UInt(1) ) != UInt(0, 28) );
    val allRoundExtra = ( ( ~ sigX3 & roundMask>>UInt(1) ) === UInt(0, 28 ));
    val anyRound = roundPosBit | anyRoundExtra;
    val allRound = roundPosBit & allRoundExtra;
    val roundDirectUp = Mux(signY, roundingMode_min, roundingMode_max)
    val roundUp =
          ( ~ doIncrSig & roundingMode_nearest_even
                                               & roundPosBit & anyRoundExtra ) |
          ( ~ doIncrSig & roundDirectUp             & anyRound    ) |
          (   doIncrSig                             & allRound    ) |
          (   doIncrSig & roundingMode_nearest_even & roundPosBit ) |
          (   doIncrSig & roundDirectUp             & Bool(true)   );
    val roundEven =
        Mux(doIncrSig,
              roundingMode_nearest_even & ~ roundPosBit &   allRoundExtra,
              roundingMode_nearest_even &   roundPosBit & ~ anyRoundExtra);
    val roundInexact = Mux(doIncrSig, ~ allRound, anyRound);
    val roundUp_sigY3 = ( sigX3>>UInt(2) | roundMask>>UInt(2) ).toUInt + UInt(1);
    val sigY3 =
          ( Mux(~ roundUp & ~ roundEven , ( sigX3 & ~ roundMask )>>UInt(2)         , UInt(0) )) |
          ( Mux(roundUp                 , roundUp_sigY3                      , UInt(0) )) |
          ( Mux(roundEven               , roundUp_sigY3 & ~ ( roundMask>>UInt(1) ) , UInt(0) ));
  //  *** HANDLE DIFFERENTLY?  (NEED TO ACCOUNT FOR ROUND-EVEN ZEROING MSB.)
    val sExpY =
           Mux(sigY3(25)              , sExpX3 + UInt(1) , UInt(0) ) |
           Mux(sigY3(24)              , sExpX3           , UInt(0) ) |
           Mux( (sigY3(25, 24) === UInt(0) ) , sExpX3 - UInt(1) , UInt(0) );
    val expY = sExpY(8, 0);
    val fractY = Mux(sigX3Shift1, sigY3(22, 0), sigY3(23, 1))

    val overflowY = ( sExpY(9, 7) === UInt("b011", 3) );
  // *** HANDLE DIFFERENTLY?  (NEED TO ACCOUNT FOR ROUND-EVEN ZEROING MSB.)
    val totalUnderflowY = sExpY(9) | ( sExpY(8, 0) < UInt("b001101011", 9).toUInt );
    val underflowY =
        ( sExpX3(10) |
                ( sExpX3(9, 0) <=
                         ( Mux(sigX3Shift1 , UInt("b0010000010", 10) , UInt("b0010000001", 10) ) ).toUInt )) &
              roundInexact;
    val inexactY = roundInexact;

    val overflowY_roundMagUp =
        roundingMode_nearest_even | ( roundingMode_min & signY ) |
              ( roundingMode_max & ~ signY );

    //------------------------------------------------------------------------
    //------------------------------------------------------------------------
    val mulSpecial = isSpecialA | isSpecialB;
    val addSpecial = mulSpecial | isSpecialC;
    val notSpecial_addZeros = isZeroProd & isZeroC;
    val commonCase = ~ addSpecial & ~ notSpecial_addZeros;

    val notSigNaN_invalid =
          ( isInfA & isZeroB ) |
          ( isZeroA & isInfB ) |
          ( ~ isNaNA & ~ isNaNB & ( isInfA | isInfB ) & isInfC & doSubMags );
    val invalid = isSigNaNA | isSigNaNB | isSigNaNC | notSigNaN_invalid;
    val overflow = commonCase & overflowY;
    val underflow = commonCase & underflowY;
    val inexact = overflow | ( commonCase & inexactY );

    val notSpecial_isZeroOut =
        notSpecial_addZeros | isZeroY | totalUnderflowY;
    val isSatOut = overflow & ~ overflowY_roundMagUp;
    val notNaN_isInfOut =
        isInfA | isInfB | isInfC | ( overflow & overflowY_roundMagUp );
    val isNaNOut = isNaNA | isNaNB | isNaNC | notSigNaN_invalid;

    val signOut =
          ( ~ doSubMags                                    & opSignC  ) |
          (   isNaNOut                                     & UInt(1)  ) |
          ( mulSpecial & ~ isSpecialC                      & signProd ) |
          ( ~ mulSpecial & isSpecialC                      & opSignC  ) |
          ( ~ mulSpecial & notSpecial_addZeros & doSubMags & UInt(0)  ) |
          ( commonCase                                     & signY    );
    val expOut =
        (   expY &
            ~  Mux(notSpecial_isZeroOut, UInt("b111000000", 9), UInt(0))  &
            ~  Mux(isSatOut            , UInt("b010000000", 9), UInt(0))  &
            ~  Mux(notNaN_isInfOut     , UInt("b001000000", 9), UInt(0))  ) | 
            Mux(isSatOut       , UInt("b101111111", 9), UInt(0))  |
            Mux(notNaN_isInfOut, UInt("b110000000", 9), UInt(0))  |
            Mux(isNaNOut       , UInt("b111000000", 9), UInt(0));
    val fractOut = fractY | ( Mux(isNaNOut | isSatOut , UInt("h7FFFFF",23) , UInt(0) ));
    io.out := Cat(signOut, expOut, fractOut);

    io.exceptionFlags := Cat(invalid, UInt("b0", 1), overflow, underflow, inexact);

}
