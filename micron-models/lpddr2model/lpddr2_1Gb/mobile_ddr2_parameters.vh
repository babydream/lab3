/****************************************************************************************
*
*   Disclaimer   This software code and all associated documentation, comments or other 
*  of Warranty:  information (collectively "Software") is provided "AS IS" without 
*                warranty of any kind. MICRON TECHNOLOGY, INC. ("MTI") EXPRESSLY 
*                DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
*                TO, NONINFRINGEMENT OF THIRD PARTY RIGHTS, AND ANY IMPLIED WARRANTIES 
*                OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. MTI DOES NOT 
*                WARRANT THAT THE SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE 
*                OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. 
*                FURTHERMORE, MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR 
*                THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS, 
*                ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT OF USE 
*                OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO EVENT SHALL MTI, 
*                ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE LIABLE FOR ANY DIRECT, 
*                INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR SPECIAL DAMAGES (INCLUDING, 
*                WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, 
*                OR LOSS OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE 
*                THE SOFTWARE, EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
*                DAMAGES. Because some jurisdictions prohibit the exclusion or 
*                limitation of liability for consequential or incidental damages, the 
*                above limitation may not apply to you.
*
*                Copyright 2003 Micron Technology, Inc. All rights reserved.
*
****************************************************************************************/

    // Parameters current with G58A datasheet rev 1.7
`define lpddr2_1Gb

    // Timing parameters based on Speed Grade

                                              // SYMBOL UNITS DESCRIPTION
                                              // ------ ----- -----------
`ifdef sg25
    parameter TCK_MIN           =       2500; // tCK      ps  Minimum Clock Cycle Time
    parameter TDQSQ             =        240; // tDQSQ    ps  DQS-DQ skew, DQS to last DQ valid, per group, per access
    parameter TDS               =        270; // tDS      ps  DQ and DM input setup time relative to DQS
    parameter TDH               =        270; // tDH      ps  DQ and DM input hold time relative to DQS
    parameter TIS               =        290; // tIS      ps  Input Setup Time
    parameter TIH               =        290; // tIH      ps  Input Hold Time
    parameter TWTR              =       7500; // tWTR     ps  Write to Read command delay
`else `ifdef sg3
    parameter TCK_MIN           =       3000; // tCK      ps  Minimum Clock Cycle Time
    parameter TDQSQ             =        280; // tDQSQ    ps  DQS-DQ skew, DQS to last DQ valid, per group, per access
    parameter TDS               =        350; // tDS      ps  DQ and DM input setup time relative to DQS
    parameter TDH               =        350; // tDH      ps  DQ and DM input hold time relative to DQS
    parameter TIS               =        370; // tIS      ps  Input Setup Time
    parameter TIH               =        370; // tIH      ps  Input Hold Time
    parameter TWTR              =       7500; // tWTR     ps  Write to Read command delay
`else `ifdef sg37
    parameter TCK_MIN           =       3750; // tCK      ps  Minimum Clock Cycle Time
    parameter TDQSQ             =        340; // tDQSQ    ps  DQS-DQ skew, DQS to last DQ valid, per group, per access
    parameter TDS               =        430; // tDS      ps  DQ and DM input setup time relative to DQS
    parameter TDH               =        430; // tDH      ps  DQ and DM input hold time relative to DQS
    parameter TIS               =        460; // tIS      ps  Input Setup Time
    parameter TIH               =        460; // tIH      ps  Input Hold Time
    parameter TWTR              =       7500; // tWTR     ps  Write to Read command delay
`else `define sg5
    parameter TCK_MIN           =       5000; // tCK      ps  Minimum Clock Cycle Time
    parameter TDQSQ             =        400; // tDQSQ    ps  DQS-DQ skew, DQS to last DQ valid, per group, per access
    parameter TDS               =        480; // tDS      ps  DQ and DM input setup time relative to DQS
    parameter TDH               =        480; // tDH      ps  DQ and DM input hold time relative to DQS
    parameter TIS               =        600; // tIS      ps  Input Setup Time
    parameter TIH               =        600; // tIH      ps  Input Hold Time
    parameter TWTR              =      10000; // tWTR     ps  Write to Read command delay
`endif `endif `endif

    // Timing Parameters

    // Clock
    parameter CKH_MIN           =       0.45; // tCH      tCK Minimum Clock High-Level Pulse Width
    parameter CKH_MAX           =       0.55; // tCH      tCK Maximum Clock High-Level Pulse Width
    parameter CKL_MIN           =       0.45; // tCL      tCK Minimum Clock Low-Level Pulse Width
    parameter CKL_MAX           =       0.55; // tCL      tCK Maximum Clock Low-Level Pulse Width
    // Read
    parameter TDQSCK            =       2500; // tDQSCK   ps  DQS output access time from CK/CK#
    parameter TDQSCK_MAX        =       5500; // tDQSCK   ps  DQS output access time from CK/CK#
    // Write
    parameter TDIPW             =       0.35; // tDIPW    tCK DQ and DM input Pulse Width
    parameter DQSH              =       0.40; // tDQSH    tCK DQS input High Pulse Width
    parameter DQSL              =       0.40; // tDQSL    tCK DQS input Low Pulse Width
    parameter DQSS              =       0.75; // tDQSS    tCK Rising clock edge to DQS/DQS# latching transition
    parameter DSS               =       0.20; // tDSS     tCK DQS falling edge to CLK rising (setup time)
    parameter DSH               =       0.20; // tDSH     tCK DQS falling edge from CLK rising (hold time)
    parameter WPRE              =       0.35; // tWPRE    tCK DQS Write Preamble
    parameter WPST              =       0.40; // tWPST    tCK DQS Write Postamble
    // CKE
    parameter CKE               =          3; // tCKE     tCK CKE minimum high or low pulse width
    parameter TCKESR            =      15000; // tCKESR   ps  CKE minimum high or low pulse width self refresh
    parameter ISCKE             =       0.25; // tISCKE   tCK CKE Input Setup Time
    parameter IHCKE             =       0.25; // tIHCKE   tCK CKE Input Hold Time
    // Mode Register
    parameter MRR               =          2; // tMRR     tCK Load Mode Register command cycle time
    parameter MRW               =          3; // tMRW     tCK Load Mode Register command cycle time
    parameter CL_MIN            =          3; // CL       tCK Minimum CAS Latency
    parameter CL_MAX            =          8; // CL       tCK Maximum CAS Latency
    parameter TCL               =      15000; // CL       ps  Minimum CAS Latency
    parameter WR_MIN            =          2; // WR       tCK Minimum Write Recovery
    parameter WR_MAX            =          6; // WR       tCK Maximum Write Recovery
    parameter BL_MIN            =          4; // BL       tCK Minimum Burst Length
    parameter BL_MAX            =         16; // BL       tCK Minimum Burst Length
    parameter MR8RESID          =      2'b00;
    parameter DLLK              =        200; // tDLLK    tCK DLL locking time
    // Command and Address
    parameter CCD               =          2; // tCCD     tCK Cas to Cas command delay
    parameter TDPD              =  500000000; // tDPD     ps  Minimum Deep Power-Down time
    parameter TFAW              =      50000; // tFAW     ps  Four-Bank Activate Window
    parameter FAW               =          8; // tFAW     tCK Four-Bank Activate Window
    parameter TIPW              =        0.4; // tIPW     tCK Control and Address input Pulse Width  
    parameter TRAS              =      42000; // tRAS     ps  Minimum Active to Precharge command time
    parameter RAS               =          7; // tRAS     tCK Minimum Active to Precharge command time
    parameter TRCD              =      18000; // tRCD     ps  Active to Read/Write command time
    parameter RCD               =          3; // tRCD     tCK Active to Read/Write command time
    parameter TRPAB             =      21000; // tRPab    ps  Precharge All command period
    parameter RPAB              =          4; // tRPab    tCK Precharge All command period
    parameter TRPPB             =      18000; // tRPpb    ps  Precharge command period
    parameter RPPB              =          3; // tRPpb    tCK Precharge command period
    parameter TRRD              =      10000; // tRRD     ps  Active bank a to Active bank b command time
    parameter RRD               =          2; // tRRD     tCK Active bank a to Active bank b command time
    parameter TRTP              =       7500; // tRTP     ps  Read to Precharge command delay
    parameter RTP               =          2; // tRTP     tCK Read to Precharge command delay
    parameter TWR               =      15000; // tWR      ps  Write recovery time
    parameter WR                =          3; // tWR      tCK Write recovery time
    parameter WTR               =          2; // tWTR     tCK Write to Read command delay
    parameter TXP               =       7500; // tXP      ps  Exit power down to first valid command
    parameter XP                =          2; // tXP      tCK Exit power down to first valid command
    parameter TXSR              =     140000; // tXSR     ps  Exit self refesh to first valid command
    parameter XSR               =          2; // tXSR     tCK Exit self refesh to first valid command
    // Refresh
    parameter TRFCPB            =      60000; // tRFCpb   ps  Refresh to Refresh Command interval minimum value
    parameter TRFCAB            =     130000; // tRFCab   ps  Refresh to Refresh Command interval minimum value
    parameter TREFBW            =    4160000; // tREFBW   ps  Burst Refresh Window
                            
    // Initialization
    parameter TINIT1            =     100000; // tINIT1   ps
    parameter INIT2             =          5; // tINIT2   tCK
    parameter TINIT3            =  200000000; // tINIT3   ps
    parameter TINIT4            =     281000; // tINIT4   ps  2*tRFCab + tRP
    parameter TINIT5            =   10000000; // tINIT5   ps
    parameter TZQINIT           =    1000000; // tZQINIT  ps  Calibration Initialization Time
    parameter TZQCL             =     360000; // tZQCL    ps  Long (Full) Calibration Time
    parameter TZQCS             =      90000; // tZQCS    ps  Short Calibration Time
    parameter TZQRESET          =      50000; // tZQRESET ps  Calibration Reset Time


    // Size Parameters based on Part Width
`ifdef x16
    parameter ROW_BITS          =         13; // Address bits
    parameter COL_BITS          =         10; // Column bits
    parameter DM_BITS           =          2; // Data Mask bits
    parameter DQ_BITS           =         16; // Data bits       **Same as part bit width**
    parameter DQS_BITS          =          2; // Dqs bits
`else `define x32
    parameter ROW_BITS          =         13; // Address bits
    parameter COL_BITS          =          9; // Column bits
    parameter DM_BITS           =          4; // Data Mask bits
    parameter DQ_BITS           =         32; // Data bits       **Same as part bit width**
    parameter DQS_BITS          =          4; // Dqs bits
`endif
    parameter COL_NOWRAPBITS    =          9; // subpage for NOWRAP 
    parameter SUB_PAGE_BITS     =          9; // Sub Page Bits = x32 COL_BITS

    // Size Parameters
    parameter BA_BITS           =          3; // Bank Address bits
    parameter CA_BITS           =         10; // Command Address Bits
    parameter MEM_BITS          =         10; // Set this parameter to control how many write data bursts can be stored in memory.  The default is 2^10=1024.
    parameter SX                =          4; // prefetch architecture.  2 = LPDDR2-S2 device, 4 = LPDDR2-S4 device.

    // Simulation parameters
    parameter STOP_ON_ERROR     =          1; // If set to 1, the model will halt on errors
    parameter MSGLENGTH         =        256; // max length in characters of a debug string
