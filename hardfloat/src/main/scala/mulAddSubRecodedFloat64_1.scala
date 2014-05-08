//*** THIS MODULE HAS NOT BEEN FULLY OPTIMIZED.
//*** DO THIS ANOTHER WAY?

package hardfloat

import Chisel._;
import Node._;
import mulAddSubRecodedFloat64_1._;

class mulAddSubRecodedFloat64_1_io() extends Bundle {
  val op = UInt(INPUT, 2);
  val a = UInt(INPUT, 65)
  val b = UInt(INPUT, 65);
  val c = UInt(INPUT, 65);
  val roundingMode = UInt(INPUT, 2);
  val out = UInt(OUTPUT, 65);
  val exceptionFlags = UInt(OUTPUT, 5);
}

object mulAddSubRecodedFloat64_1 {
  val round_nearest_even =  UInt("b00", 2);
  val round_minMag       =  UInt("b01", 2);
  val round_min          =  UInt("b10", 2);
  val round_max          =  UInt("b11", 2);
}

class mulAddSubRecodedFloat64_1 extends Module{
  override val io = new mulAddSubRecodedFloat64_1_io();
    val signA  = io.a(64);
    val expA   = io.a(63, 52).toUInt;
    val fractA = io.a(51, 0).toUInt;
    val isZeroA = ( expA(11, 9) === UInt("b000", 3) );
    val isSpecialA = ( expA(11, 10) === UInt("b11", 2) );
    val isInfA = isSpecialA & ~ expA(9);
    val isNaNA = isSpecialA &   expA(9);
    val isSigNaNA = isNaNA & ~ fractA(51);
    val sigA = Cat(~ isZeroA, fractA).toUInt;

    val signB  = io.b(64);
    val expB   = io.b(63, 52).toUInt;
    val fractB = io.b(51, 0).toUInt;
    val isZeroB = ( expB(11, 9) === UInt("b000", 3) );
    val isSpecialB = ( expB(11, 10) === UInt("b11", 2) );
    val isInfB = isSpecialB & ~ expB(9);
    val isNaNB = isSpecialB &   expB(9);
    val isSigNaNB = isNaNB & ~ fractB(51);
    val sigB = Cat(~ isZeroB, fractB).toUInt;

    val opSignC  = io.c(64) ^ io.op(0);
    val expC   = io.c(63, 52).toUInt;
    val fractC = io.c(51, 0).toUInt;
    val isZeroC = ( expC(11, 9) === UInt("b000", 3) );
    val isSpecialC = ( expC(11, 10) === UInt("b11", 2) );
    val isInfC = isSpecialC & ~ expC(9);
    val isNaNC = isSpecialC &   expC(9);
    val isSigNaNC = isNaNC & ~ fractC(51);
    val sigC = Cat(~ isZeroC, fractC).toUInt;

    val roundingMode_nearest_even = ( io.roundingMode === round_nearest_even );
    val roundingMode_minMag       = ( io.roundingMode === round_minMag       );
    val roundingMode_min          = ( io.roundingMode === round_min          );
    val roundingMode_max          = ( io.roundingMode === round_max          );

    //------------------------------------------------------------------------
    //------------------------------------------------------------------------
    val signProd = signA ^ signB ^ io.op(1);
    val isZeroProd = isZeroA | isZeroB;
    // val sExpAlignedProd = expA + Cat(Fill(~ expB(11), 3), expB(10, 0)) + 56;
    val sExpAlignedProd = Cat(Fill(3, ~ expB(11)), expB(10, 0)).toUInt + expA + UInt(56);

    val sigProd = sigA * sigB;

    //------------------------------------------------------------------------
    //------------------------------------------------------------------------
    val doSubMags = signProd ^ opSignC;

    val sNatCAlignDist = sExpAlignedProd - expC;
    val CAlignDist_floor = isZeroProd | sNatCAlignDist(13);
    val CAlignDist_0 = CAlignDist_floor | ( sNatCAlignDist(12, 0) === UInt(0) );
    val isCDominant =
        ~ isZeroC & ( CAlignDist_floor | ( sNatCAlignDist(12, 0) < UInt(54) ) );
    val CAlignDist =
          Mux(CAlignDist_floor, UInt(0),
          Mux(( sNatCAlignDist(12, 0) < UInt(161, 13) ), sNatCAlignDist,
          UInt(161)))(7, 0);
    val sExpSum = Mux(CAlignDist_floor, expC, sExpAlignedProd);

    val CExtraMaskGen = Fill(53, UInt(1)) >> (UInt(161) - CAlignDist);

// *** USE `sNatCAlignDist'?
    val CExtraMask = 
        Cat(( UInt(161) === CAlignDist ), ( UInt(160) <= CAlignDist ),
         ( UInt(159) <= CAlignDist ), ( UInt(158) <= CAlignDist ),
         ( UInt(157) <= CAlignDist ), ( UInt(156) <= CAlignDist ),
         ( UInt(155) <= CAlignDist ), ( UInt(154) <= CAlignDist ),
         ( UInt(153) <= CAlignDist ), ( UInt(152) <= CAlignDist ),
         ( UInt(151) <= CAlignDist ), ( UInt(150) <= CAlignDist ),
         ( UInt(149) <= CAlignDist ), ( UInt(148) <= CAlignDist ),
         ( UInt(147) <= CAlignDist ), ( UInt(146) <= CAlignDist ),
         ( UInt(145) <= CAlignDist ), ( UInt(144) <= CAlignDist ),
         ( UInt(143) <= CAlignDist ), ( UInt(142) <= CAlignDist ),
         ( UInt(141) <= CAlignDist ), ( UInt(140) <= CAlignDist ),
         ( UInt(139) <= CAlignDist ), ( UInt(138) <= CAlignDist ),
         ( UInt(137) <= CAlignDist ), ( UInt(136) <= CAlignDist ),
         ( UInt(135) <= CAlignDist ), ( UInt(134) <= CAlignDist ),
         ( UInt(133) <= CAlignDist ), ( UInt(132) <= CAlignDist ),
         ( UInt(131) <= CAlignDist ), ( UInt(130) <= CAlignDist ),
         ( UInt(129) <= CAlignDist ), ( UInt(128) <= CAlignDist ),
         ( UInt(127) <= CAlignDist ), ( UInt(126) <= CAlignDist ),
         ( UInt(125) <= CAlignDist ), ( UInt(124) <= CAlignDist ),
         ( UInt(123) <= CAlignDist ), ( UInt(122) <= CAlignDist ),
         ( UInt(121) <= CAlignDist ), ( UInt(120) <= CAlignDist ),
         ( UInt(119) <= CAlignDist ), ( UInt(118) <= CAlignDist ),
         ( UInt(117) <= CAlignDist ), ( UInt(116) <= CAlignDist ),
         ( UInt(115) <= CAlignDist ), ( UInt(114) <= CAlignDist ),
         ( UInt(113) <= CAlignDist ), ( UInt(112) <= CAlignDist ),
         ( UInt(111) <= CAlignDist ), ( UInt(110) <= CAlignDist ),
         ( UInt(109) <= CAlignDist ));
    val negSigC = Mux(doSubMags, ~ sigC, sigC);
    val alignedNegSigC =
        Cat(Cat(Fill(161, doSubMags), negSigC, Fill(108, doSubMags))>>CAlignDist,
         ( ( sigC & CExtraMask ) != UInt(0) ) ^ doSubMags)(161, 0);

    // val sigSum = (alignedNegSigC + ( sigProd << 1 ))(161,0); // BCR Tmp SInt?

    val sigSum = (alignedNegSigC.toUInt + Cat(sigProd, UInt(0,1)).toUInt)(161,0); // BCR Tmp SInt?

    val estNormPos_a = Cat(doSubMags, alignedNegSigC(107, 1));
    val estNormPos_b = sigProd;
    val estNormPosSigSum = new estNormDistP53PosSum108();
    estNormPosSigSum.io.a := estNormPos_a;
    estNormPosSigSum.io.b := estNormPos_b;
    val estNormPos_dist = estNormPosSigSum.io.out.toUInt;

    val estNormNeg_a = Cat(UInt("b1", 1), alignedNegSigC(107, 1));
    val estNormNeg_b = sigProd;
    val estNormNegSigSum = new estNormDistP53NegSum108();
    estNormNegSigSum.io.a := estNormNeg_a;
    estNormNegSigSum.io.b := estNormNeg_b;
    val estNormNeg_dist = estNormNegSigSum.io.out.toUInt;

    val firstReduceSigSum = Cat(( sigSum(75, 44) != UInt(0) ), ( sigSum(43, 0) != UInt(0) ));
    val notSigSum = ~ sigSum;
    val firstReduceNotSigSum =
        Cat(( notSigSum(75, 44) != UInt(0) ), ( notSigSum(43, 0) != UInt(0) ));
//*** USE RESULT OF `CAlignDest - 1' TO TEST FOR ZERO?
    val CDom_estNormDist =
        Mux(CAlignDist_0 | doSubMags, CAlignDist, (CAlignDist - UInt(1))(5, 0));
    val CDom_firstNormAbsSigSum =
          ( Mux(~ doSubMags & ~ CDom_estNormDist(5), 
            Cat(sigSum(161, 76), ( firstReduceSigSum != UInt(0) )),
            UInt(0))
          ) |
          ( Mux(~ doSubMags & CDom_estNormDist(5),
            Cat(sigSum(129, 44), firstReduceSigSum(0)),
            UInt(0))
          ) |
          ( Mux(doSubMags & ~ CDom_estNormDist(5),
            Cat(notSigSum(161, 76), ( firstReduceNotSigSum != UInt(0) )),
            UInt(0))
          ) |
          ( Mux(doSubMags & CDom_estNormDist(5),
            Cat(notSigSum(129, 44), firstReduceNotSigSum(0)),
            UInt(0))
          );
    //------------------------------------------------------------------------
    // (For this case, bits above `sigSum(108)' are never interesting.  Also,
    // if there is any significant cancellation, then `sigSum(0)' must equal
    // `doSubMags'.)
    //------------------------------------------------------------------------
    val notCDom_pos_firstNormAbsSigSum =
          ( Mux(( estNormPos_dist(6, 4) === UInt("b011", 3) ),
                  Cat(sigSum(108, 44),
                      Mux(doSubMags, ~ firstReduceNotSigSum(0), firstReduceSigSum(0))),
                  UInt(0))
          ) |
          ( Mux(( estNormPos_dist(6, 5) === UInt("b10", 2) ),
                  Cat(sigSum(97, 12),
                      Mux(doSubMags , ( notSigSum(11, 1) === UInt(0) ) , ( sigSum(11, 1) != UInt(0) ))),
                  UInt(0))
          ) |
          ( Mux(( estNormPos_dist(6, 5) === UInt("b11", 2) ) , Cat(sigSum(65, 1), Fill(22, doSubMags)),
                  UInt(0) )) |
          ( Mux(( estNormPos_dist(6, 5) === UInt("b00", 2) ) , Cat(sigSum(33, 1), Fill(54, doSubMags)),
                  UInt(0) )) |
          ( Mux(( estNormPos_dist(6, 4) === UInt("b010", 3) ) , Cat(sigSum(1), Fill(86, doSubMags)),
                  UInt(0) ));
    //------------------------------------------------------------------------
    // (For this case, bits above `notSigSum(107)' are never interesting.
    // Also, if there is any significant cancellation, then `notSigSum(0)' must
    // be zero.)
    //------------------------------------------------------------------------
    val notCDom_neg_cFirstNormAbsSigSum =
          Mux(( estNormNeg_dist(6, 4) === UInt("b011", 3) ),
                Cat(notSigSum(107, 44), firstReduceNotSigSum(0)), UInt(0)) |
          Mux(( estNormNeg_dist(6, 5) === UInt("b10", 2) ),
                Cat(notSigSum(98, 12), ( notSigSum(11, 1) != UInt(0) )), UInt(0)) |
          Mux(( estNormNeg_dist(6, 5) === UInt("b11", 2) ),
                Cat(notSigSum(66, 1), Fill(22, UInt(0,1))), UInt(0) ) |
          Mux(( estNormNeg_dist(6, 5) === UInt("b00", 2) ),
                Cat(notSigSum(34, 1), Fill(54,UInt(0,1))), UInt(0) ) |
          Mux(( estNormNeg_dist(6, 4) === UInt("b010", 3) ),
                Cat(notSigSum(2, 1),  Fill(86,UInt(0,1))), UInt(0) );
    val notCDom_signSigSum = sigSum(109);
    val doNegSignSum =
        Mux(isCDominant, doSubMags & ~ isZeroC, notCDom_signSigSum);
    val estNormDist =
          Mux(  isCDominant                       , CDom_estNormDist, UInt(0) ) |
          Mux(~ isCDominant & ~ notCDom_signSigSum, estNormPos_dist , UInt(0) ) |
          Mux(~ isCDominant &   notCDom_signSigSum, estNormNeg_dist , UInt(0) );
    val cFirstNormAbsSigSum =
          Mux(isCDominant, CDom_firstNormAbsSigSum, UInt(0) ) |
          ( Mux(~ isCDominant & ~ notCDom_signSigSum,
                  notCDom_pos_firstNormAbsSigSum,
                  UInt(0))
          ) |
          ( Mux(~ isCDominant & notCDom_signSigSum,
                  notCDom_neg_cFirstNormAbsSigSum,
                  UInt(0))
          );
    val doIncrSig = ~ isCDominant & ~ notCDom_signSigSum & doSubMags;
    val estNormDist_5 = estNormDist(4, 0).toUInt;
    val normTo2ShiftDist = ~ estNormDist_5;
    val absSigSumExtraMask =
        Cat( 
         ( estNormDist_5 === UInt(0) ), ( estNormDist_5 <=  UInt(1) ),
         ( estNormDist_5 <=  UInt(2) ), ( estNormDist_5 <=  UInt(3) ),
         ( estNormDist_5 <=  UInt(4) ), ( estNormDist_5 <=  UInt(5) ),
         ( estNormDist_5 <=  UInt(6) ), ( estNormDist_5 <=  UInt(7) ),
         ( estNormDist_5 <=  UInt(8) ), ( estNormDist_5 <=  UInt(9) ),
         ( estNormDist_5 <= UInt(10) ), ( estNormDist_5 <= UInt(11) ),
         ( estNormDist_5 <= UInt(12) ), ( estNormDist_5 <= UInt(13) ),
         ( estNormDist_5 <= UInt(14) ), ( estNormDist_5 <= UInt(15) ),
         ( estNormDist_5 <= UInt(16) ), ( estNormDist_5 <= UInt(17) ),
         ( estNormDist_5 <= UInt(18) ), ( estNormDist_5 <= UInt(19) ),
         ( estNormDist_5 <= UInt(20) ), ( estNormDist_5 <= UInt(21) ),
         ( estNormDist_5 <= UInt(22) ), ( estNormDist_5 <= UInt(23) ),
         ( estNormDist_5 <= UInt(24) ), ( estNormDist_5 <= UInt(25) ),
         ( estNormDist_5 <= UInt(26) ), ( estNormDist_5 <= UInt(27) ),
         ( estNormDist_5 <= UInt(28) ), ( estNormDist_5 <= UInt(29) ),
         ( estNormDist_5 <= UInt(30) ), UInt("b1", 1));
    //val absSigSumExtraMaskGen = Fill(UInt(1,1), (UInt(32, 6) - estNormDist_5));
    val sigX3 =
        Cat(cFirstNormAbsSigSum(87, 1)>>normTo2ShiftDist,
         Mux(doIncrSig,
         ( ( ~ cFirstNormAbsSigSum(31, 0) & absSigSumExtraMask ) === UInt(0) ),
         ( (   cFirstNormAbsSigSum(31, 0) & absSigSumExtraMask ) != UInt(0) )))(56, 0);
    val sigX3Shift1 = ( sigX3(56, 55) === UInt(0) );
    val sExpX3 = sExpSum - estNormDist;

    val isZeroY = ( sigX3(56, 54) === UInt(0) );
    val signY = ~ isZeroY & ( signProd ^ doNegSignSum );
    val sExpX3_13 = sExpX3(12, 0);
    val roundMask =
          Mux(sExpX3(13) , UInt("hFFFFFFFFFFFFFF", 56),
          Cat(
           ( sExpX3_13 <= UInt("b0001111001101", 13).toUInt ), // 973 = 3*256(768) + 12*16(192) + 13
           ( sExpX3_13 <= UInt("b0001111001110", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111001111", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111010000", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111010001", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111010010", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111010011", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111010100", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111010101", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111010110", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111010111", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111011000", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111011001", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111011010", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111011011", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111011100", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111011101", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111011110", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111011111", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111100000", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111100001", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111100010", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111100011", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111100100", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111100101", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111100110", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111100111", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111101000", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111101001", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111101010", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111101011", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111101100", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111101101", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111101110", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111101111", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111110000", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111110001", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111110010", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111110011", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111110100", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111110101", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111110110", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111110111", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111111000", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111111001", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111111010", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111111011", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111111100", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111111101", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111111110", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0001111111111", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0010000000000", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0010000000001", 13).toUInt ),
           ( sExpX3_13 <= UInt("b0010000000010", 13).toUInt ) | sigX3(55), // 256*4 + 2 = 1026
           UInt("b11", 2)));
    // val roundMaskGen = 
    //   Mux(sExpX3(13) , UInt("hFFFFFFFFFFFFFFL", 56),
    //       Fill(Lit(1,1), (Lit(1026+2, 15) - sExpX3_13)(6, 0)) | Cat(sigX3(55), Lit(0, 2)));

    val roundPosMask = ~ Cat(UInt("b0", 1), roundMask>>UInt(1)) & roundMask;
    val roundPosBit = ( ( sigX3 & roundPosMask ) != UInt(0) );
    val anyRoundExtra = ( (   sigX3 & roundMask>>UInt(1) ) != UInt(0) );
    val allRoundExtra = ( ( ~ sigX3 & roundMask>>UInt(1) ) === UInt(0) );
    val anyRound = roundPosBit | anyRoundExtra;
    val allRound = roundPosBit & allRoundExtra;
    val roundDirectUp = Mux(signY, roundingMode_min, roundingMode_max);
    val roundUp =
          ( ~ doIncrSig & roundingMode_nearest_even &
                          roundPosBit & anyRoundExtra ) |
          ( ~ doIncrSig & roundDirectUp             & anyRound    ) |
          (   doIncrSig                             & allRound    ) |
          (   doIncrSig & roundingMode_nearest_even & roundPosBit ) |
          (   doIncrSig & roundDirectUp             & UInt(1)  );
    val roundEven =
        Mux(doIncrSig,
            roundingMode_nearest_even & ~ roundPosBit &   allRoundExtra,
            roundingMode_nearest_even &   roundPosBit & ~ anyRoundExtra);
    val roundInexact = Mux(doIncrSig, ~ allRound, anyRound);
    val roundUp_sigY3 = (( sigX3>>UInt(2) | roundMask>>UInt(2) ).toUInt + UInt(1))(54, 0);
    val sigY3 =
          (Mux(~ roundUp & ~ roundEven, ( sigX3 & ~ roundMask )>>UInt(2)        , UInt(0) ) |
          Mux(roundUp                , roundUp_sigY3                     , UInt(0) ) |
          Mux(roundEven              , roundUp_sigY3 & ~ ( roundMask>>UInt(1) ), UInt(0) ))(54, 0);
//*** HANDLE DIFFERENTLY?  (NEED TO ACCOUNT FOR ROUND-EVEN ZEROING MSB.)
    val sExpY =
          Mux(sigY3(54)                    , sExpX3 + UInt(1), UInt(0) ) |
          Mux(sigY3(53)                    , sExpX3          , UInt(0) ) |
          Mux(( sigY3(54, 53) === UInt(0) ), sExpX3 - UInt(1), UInt(0) );
    val expY = sExpY(11, 0);
    val fractY = Mux(sigX3Shift1, sigY3(51, 0), sigY3(52, 1));

    val overflowY = ( sExpY(12, 10) === UInt("b011", 3) );
//*** HANDLE DIFFERENTLY?  (NEED TO ACCOUNT FOR ROUND-EVEN ZEROING MSB.)
    val totalUnderflowY = sExpY(12) | ( sExpY(11, 0) < UInt("b001111001110", 12).toUInt );
    val underflowY =
        ( sExpX3(13) |
                ( sExpX3_13 <=
                        ( Mux(sigX3Shift1 , UInt("b0010000000010", 13).toUInt,
                               UInt("b0010000000001", 13).toUInt) ) ) ) &
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
            ~ Mux(notSpecial_isZeroOut, UInt("b111000000000", 12), UInt(0) ) &
            ~ Mux(isSatOut            , UInt("b010000000000", 12), UInt(0) ) &
            ~ Mux(notNaN_isInfOut     , UInt("b001000000000", 12), UInt(0) ) ) | 
            Mux(isSatOut       , UInt("b101111111111", 12), UInt(0) ) |
            Mux(notNaN_isInfOut, UInt("b110000000000", 12), UInt(0) ) |
            Mux(isNaNOut       , UInt("b111000000000", 12), UInt(0) );
    val fractOut = fractY | Mux(isNaNOut | isSatOut, UInt("hFFFFFFFFFFFFF", 52), UInt(0) );
    io.out := Cat(signOut, expOut, fractOut);

    io.exceptionFlags := Cat(invalid, UInt("b0", 1), overflow, underflow, inexact);

}
