//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Const.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Section:	Simulation Flag
//	Desc:		This little nebulous block will define the flags:
//				-SIMULATION	Simulating
//				-MODELSIM	Simulating using ModelSim
//				-XST		Synthesizing with XST
//				-SYNPLIFY	Synthesizing with Synplify
//				-SYNTHESIS	Synthesizing
//				-MACROSAFE	Safe to use macros (Synplify or ModelSim)
//
//	YOU SHOULD DEFINE THE "MODELSIM" FLAG FOR SIMULATION!!!!
//------------------------------------------------------------------------------
`ifdef synthesis                // if Synplify
	`define SYNPLIFY
	`define SYNTHESIS
	`define MACROSAFE
`else                           // if not Synplify
	`ifdef MODELSIM
		`define SIMULATION
		`define MACROSAFE
	`else
		`define XST
		// synthesis translate_off    // if XST then stop compiling
			`undef XST
			`define SIMULATION
			`define MODELSIM
		// synthesis translate_on     // if XST then resume compiling
		`ifdef XST
			`define SYNTHESIS
			`define MACROSAFE
		`endif
	`endif
`endif
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//	Section:	Log2 Macro
//	Desc:		A macro to take the log base 2 of any number.  Useful for
//				calculating bitwidths.  Warning, this actually calculates
//				log2Ceiling(x).
//------------------------------------------------------------------------------
`ifdef MACROSAFE
`define log2(x)			((((x) > 1) ? 1 : 0) + \
						(((x) > 2) ? 1 : 0) + \
						(((x) > 4) ? 1 : 0) + \
						(((x) > 8) ? 1 : 0) + \
						(((x) > 16) ? 1 : 0) + \
						(((x) > 32) ? 1 : 0) + \
						(((x) > 64) ? 1 : 0) + \
						(((x) > 128) ? 1 : 0) + \
						(((x) > 256) ? 1 : 0) + \
						(((x) > 512) ? 1 : 0) + \
						(((x) > 1024) ? 1 : 0) + \
						(((x) > 2048) ? 1 : 0) + \
						(((x) > 4096) ? 1 : 0) + \
						(((x) > 8192) ? 1 : 0) + \
						(((x) > 16384) ? 1 : 0) + \
						(((x) > 32768) ? 1 : 0) + \
						(((x) > 65536) ? 1 : 0) + \
						(((x) > 131072) ? 1 : 0) + \
						(((x) > 262144) ? 1 : 0) + \
						(((x) > 524288) ? 1 : 0) + \
						(((x) > 1048576) ? 1 : 0) + \
						(((x) > 2097152) ? 1 : 0) + \
						(((x) > 4194304) ? 1 : 0) + \
						(((x) > 8388608) ? 1 : 0) + \
						(((x) > 16777216) ? 1 : 0) + \
						(((x) > 33554432) ? 1 : 0) + \
						(((x) > 67108864) ? 1 : 0) + \
						(((x) > 134217728) ? 1 : 0) + \
						(((x) > 268435456) ? 1 : 0) + \
						(((x) > 536870912) ? 1 : 0) + \
						(((x) > 1073741824) ? 1 : 0))
`endif
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//	Section:	Log2 Floor Macro
//	Desc:		A macro to take the floor of the log base 2 of any number.
//------------------------------------------------------------------------------
`ifdef MACROSAFE
`define log2f(x)		((((x) >= 2) ? 1 : 0) + \
						(((x) >= 4) ? 1 : 0) + \
						(((x) >= 8) ? 1 : 0) + \
						(((x) >= 16) ? 1 : 0) + \
						(((x) >= 32) ? 1 : 0) + \
						(((x) >= 64) ? 1 : 0) + \
						(((x) >= 128) ? 1 : 0) + \
						(((x) >= 256) ? 1 : 0) + \
						(((x) >= 512) ? 1 : 0) + \
						(((x) >= 1024) ? 1 : 0) + \
						(((x) >= 2048) ? 1 : 0) + \
						(((x) >= 4096) ? 1 : 0) + \
						(((x) >= 8192) ? 1 : 0) + \
						(((x) >= 16384) ? 1 : 0) + \
						(((x) >= 32768) ? 1 : 0) + \
						(((x) >= 65536) ? 1 : 0) + \
						(((x) >= 131072) ? 1 : 0) + \
						(((x) >= 262144) ? 1 : 0) + \
						(((x) >= 524288) ? 1 : 0) + \
						(((x) >= 1048576) ? 1 : 0) + \
						(((x) >= 2097152) ? 1 : 0) + \
						(((x) >= 4194304) ? 1 : 0) + \
						(((x) >= 8388608) ? 1 : 0) + \
						(((x) >= 16777216) ? 1 : 0) + \
						(((x) >= 33554432) ? 1 : 0) + \
						(((x) >= 67108864) ? 1 : 0) + \
						(((x) >= 134217728) ? 1 : 0) + \
						(((x) >= 268435456) ? 1 : 0) + \
						(((x) >= 536870912) ? 1 : 0) + \
						(((x) >= 1073741824) ? 1 : 0))
`endif
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//	Section:	Pow2 Macro
//	Desc:		A macro to take the 2 to the power of any number.  Useful for
//				calculating bitwidths.
//------------------------------------------------------------------------------
`ifdef MACROSAFE
`define pow2(x)			((((x) >= 1) ? 2 : 1) * \
						(((x) >= 2) ? 2 : 1) * \
						(((x) >= 3) ? 2 : 1) * \
						(((x) >= 4) ? 2 : 1) * \
						(((x) >= 5) ? 2 : 1) * \
						(((x) >= 6) ? 2 : 1) * \
						(((x) >= 7) ? 2 : 1) * \
						(((x) >= 8) ? 2 : 1) * \
						(((x) >= 9) ? 2 : 1) * \
						(((x) >= 10) ? 2 : 1) * \
						(((x) >= 11) ? 2 : 1) * \
						(((x) >= 12) ? 2 : 1) * \
						(((x) >= 13) ? 2 : 1) * \
						(((x) >= 14) ? 2 : 1) * \
						(((x) >= 15) ? 2 : 1) * \
						(((x) >= 16) ? 2 : 1) * \
						(((x) >= 17) ? 2 : 1) * \
						(((x) >= 18) ? 2 : 1) * \
						(((x) >= 19) ? 2 : 1) * \
						(((x) >= 20) ? 2 : 1) * \
						(((x) >= 21) ? 2 : 1) * \
						(((x) >= 22) ? 2 : 1) * \
						(((x) >= 23) ? 2 : 1) * \
						(((x) >= 24) ? 2 : 1) * \
						(((x) >= 25) ? 2 : 1) * \
						(((x) >= 26) ? 2 : 1) * \
						(((x) >= 27) ? 2 : 1) * \
						(((x) >= 28) ? 2 : 1) * \
						(((x) >= 29) ? 2 : 1) * \
						(((x) >= 30) ? 2 : 1) * \
						(((x) >= 31) ? 2 : 1))
`endif
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//	Section:	Max/Min Macros
//	Desc:		Standard binary max/min macros
//------------------------------------------------------------------------------
`ifdef MACROSAFE
`define max(x,y)		((x) > (y) ? (x) : (y))
`define min(x,y)		((x) < (y) ? (x) : (y))
`endif
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//	Section:	Integer Division Macros
//	Desc:		Rounding and ceiling for integer division
//------------------------------------------------------------------------------
`ifdef MACROSAFE
`define	divceil(x,y)	(((x) + ((y) - 1)) / (y))
`define	divrnd(x,y)		(((x) + ((y) >> 1)) / (y))
`endif
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//	Section:	Population Count
//	Desc:		A population counter macro for 32bit values
//------------------------------------------------------------------------------
`ifdef MACROSAFE
`define popcount(x)		((((x) & 1) ? 1 : 0) + \
						(((x) & 2) ? 1 : 0) + \
						(((x) & 4) ? 1 : 0) + \
						(((x) & 8) ? 1 : 0) + \
						(((x) & 16) ? 1 : 0) + \
						(((x) & 32) ? 1 : 0) + \
						(((x) & 64) ? 1 : 0) + \
						(((x) & 128) ? 1 : 0) + \
						(((x) & 256) ? 1 : 0) + \
						(((x) & 512) ? 1 : 0) + \
						(((x) & 1024) ? 1 : 0) + \
						(((x) & 2048) ? 1 : 0) + \
						(((x) & 4096) ? 1 : 0) + \
						(((x) & 8192) ? 1 : 0) + \
						(((x) & 16384) ? 1 : 0) + \
						(((x) & 32768) ? 1 : 0) + \
						(((x) & 65536) ? 1 : 0) + \
						(((x) & 131072) ? 1 : 0) + \
						(((x) & 262144) ? 1 : 0) + \
						(((x) & 524288) ? 1 : 0) + \
						(((x) & 1048576) ? 1 : 0) + \
						(((x) & 2097152) ? 1 : 0) + \
						(((x) & 4194304) ? 1 : 0) + \
						(((x) & 8388608) ? 1 : 0) + \
						(((x) & 16777216) ? 1 : 0) + \
						(((x) & 33554432) ? 1 : 0) + \
						(((x) & 67108864) ? 1 : 0) + \
						(((x) & 134217728) ? 1 : 0) + \
						(((x) & 268435456) ? 1 : 0) + \
						(((x) & 536870912) ? 1 : 0) + \
						(((x) & 1073741824) ? 1 : 0) + \
						(((x) & 2147483648) ? 1 : 0))
`endif
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gateforge.org:26/Projects/GateLib/branches/dev/Firmware/UART/Hardware/UART.v $
//	Version:	$Revision: 12399 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		UART
//	Desc:		Standard Universal Asynchronous RS232/16550 type transceiver.
//				
//				Note that the DataOut FIFO connection is not stable.  Output
//				data will be lost if the application does not accept it quickly
//				enough as per the FIFO interface specification.
//				
//	Params:		ClockFreq: Frequency (in Hz) of the "Clock" being fed to this
//						module.
//				Baud:	Desired Baud rate.  This is the rate at which this
//						module will send bits, and should be at most 1/4th
//						of the clock rate (or so).
//				Width:	Word width (in bits) of the words (bytes) send over
//						the serial line.
//				Parity:	The type of parity bit to be appended to each word of
//						data.
//						0:	None
//						1:	Odd
//						2:	Even
//						3:	Mark
//						4:	Space
//				StopBits:The number of bit-periods to send the stop condition.
//						Generally 1 or 2, though larger numbers are possible.
//				HoldReceived:Should the output byte be held until read or until
//						a new one is actually received?  This costs one
//						register, but normally the output byte is held until a
//						new byte COULD arrive.
//	Ex:			(27000000, 9600, 8, 0, 1) Standard 9600baud 8-N-1 serial port
//						settings used as the default by many devices, based
//						on a 27MHz clock.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12399 $
//------------------------------------------------------------------------------
module	UART(Clock, Reset, DataIn, DataInValid, DataInReady, DataOut, DataOutValid, DataOutReady, SIn, SOut);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				ClockFreq =				27000000,
							Baud =					115200,
							Width =					8,
							Parity =				0,
							StopBits =				1,
							HoldReceived =			0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;	
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Parallel Data Input
	//--------------------------------------------------------------------------
	input	[Width-1:0]		DataIn;
	input					DataInValid;
	output					DataInReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Parallel Data Output
	//--------------------------------------------------------------------------
	output	[Width-1:0]		DataOut;
	output					DataOutValid;
	input					DataOutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Serial Interface
	//--------------------------------------------------------------------------
	input					SIn;
	output					SOut;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Transmitter
	//--------------------------------------------------------------------------
	UATransmitter	#(			.ClockFreq(			ClockFreq),
								.Baud(				Baud),
								.Width(				Width),
								.Parity(			Parity),
								.StopBits(			StopBits))
					TX(			.Clock(				Clock),
								.Reset(				Reset),
								.DataIn(			DataIn),
								.DataInValid(		DataInValid),
								.DataInReady(		DataInReady),
								.SOut(				SOut));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Receiver
	//--------------------------------------------------------------------------
	UAReceiver		#(			.ClockFreq(			ClockFreq),
								.Baud(				Baud),
								.Width(				Width),
								.Parity(			Parity),
								.StopBits(			StopBits),
								.HoldReceived(		HoldReceived))
					RX(			.Clock(				Clock),
								.Reset(				Reset),
								.DataOut(			DataOut),
								.DataOutValid(		DataOutValid),
								.DataOutReady(		DataOutReady),
								.SIn(				SIn));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gateforge.org:26/Projects/GateLib/branches/dev/Firmware/UART/Hardware/UAReceiver.v $
//	Version:	$Revision: 12399 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		UAReceiver
//	Desc:		Standard Universal Asynchronous RS232/16550 type receiver.
//				
//				Note that the DataOut FIFO connection is not stable.  Output
//				data will be lost if the application does not accept it quickly
//				enough as per the FIFO interface specification.
//				
//	Params:		ClockFreq: Frequency (in Hz) of the "Clock" being fed to this
//						module.
//				Baud:	Desired Baud rate.  This is the rate at which this
//						module will send bits, and should be at most 1/4th
//						of the clock rate (or so).
//				Width:	Word width (in bits) of the words (bytes) send over
//						the serial line.
//				Parity:	The type of parity bit to be appended to each word of
//						data.
//						0:	None
//						1:	Even
//						2:	Odd
//						3:	Mark
//						4:	Space
//				StopBits:The number of bit-periods to send the stop condition.
//						Generally 1 or 2, though larger numbers are possible.
//				HoldReceived:Should the output byte be held until read or until
//						a new one is actually received?  This costs one
//						register, but normally the output byte is held until a
//						new byte COULD arrive.
//	Ex:			(27000000, 9600, 8, 0, 1) Standard 9600baud 8-N-1 serial port
//						settings used as the default by many devices, based
//						on a 27MHz clock.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12399 $
//------------------------------------------------------------------------------
module	UAReceiver(Clock, Reset, DataOut, DataOutValid, DataOutReady, SIn);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				ClockFreq =				27000000,
							Baud =					115200,
							Width =					8,
							Parity =				0,
							StopBits =				1,
							HoldReceived =			0;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Local Parameters
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				Divisor =				ClockFreq / Baud,
							DivWidth =				`log2(Divisor),
							Capture =				(Divisor / 2),
							BitCount =				Width + StopBits + (Parity ? 1 : 0) + 1,
							BCWidth =				`log2(BitCount + 1),
							ActualBaud =			ClockFreq / Divisor;
	`endif

	`ifdef SIMULATION
	localparam real			MaxBaud =				ClockFreq / ((Divisor * (BitCount - 0.5)) / BitCount),
							MinBaud =				ClockFreq / ((Divisor * (BitCount + 0.5)) / BitCount);
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constant Debugging Statements
	//--------------------------------------------------------------------------
	`ifdef SIMULATION
		initial begin
			$display("DEBUG[%m @ %t]: UART Parameters", $time);
			$display("    ClockFreq =  %d", ClockFreq);
			$display("    Baud =       %d", Baud);
			$display("    Width =      %d", Width);
			$display("    Parity =     %d", Parity);
			$display("    StopBits =   %d", StopBits);

			/*$display("    Divisor =    %d", Divisor);
			$display("    DivWidth =   %d", DivWidth);
			$display("    Capture =    %d", Capture);
			$display("    BitCount =   %d", BitCount);
			$display("    BCWidth =    %d", BCWidth);*/

			$display("    ActualBaud = %d", ActualBaud);
			$display("    MaxBaud =    %f", MaxBaud);
			$display("    MinBaud =    %f", MinBaud);
		end
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;	
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Parallel Data Output
	//--------------------------------------------------------------------------
	output	[Width-1:0]		DataOut;
	output					DataOutValid;
	input					DataOutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Serial Interface
	//--------------------------------------------------------------------------
	input					SIn;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	 Wires & Regs
	//--------------------------------------------------------------------------
	wire					IntSIn;

	wire	[DivWidth-1:0]	RxDivCount;
	wire	[BCWidth-1:0]	RxBitCount;
	wire	[BitCount-1:0]	RxData;
	wire					RxShiftEnable, RxRunning, RxBit, RxStart, RxTransfered;
	wire					RxEnable;

	wire					RxStartBit, RxActualParity;
	wire	[StopBits-1:0]	RxStopBits;

	wire					RxParity;
	wire	[Width-1:0]		RxDataStripped;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Assigns and Decodes
	//--------------------------------------------------------------------------
	assign	RxShiftEnable =							(RxDivCount == Capture) & RxEnable;
	assign	RxRunning =								(RxBitCount < BitCount) & RxEnable;
	assign	RxBit =									RxRunning & RxShiftEnable;
	assign	RxStart =								~IntSIn & ~RxRunning;
	
	assign	RxStartBit =							RxData[BitCount-1];
	assign	RxActualParity =						RxData[StopBits];
	assign	RxStopBits =							RxData[StopBits-1:0];
	
	assign	DataOutValid =							(~RxStartBit) & (&RxStopBits) & ~RxTransfered & (Parity ? ~(RxParity ^ RxActualParity) : 1'b1);
	assign	RxDataStripped =						Parity ? RxData[BitCount-2:StopBits+1] : RxData[BitCount-2:StopBits];
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	IO Register
	//--------------------------------------------------------------------------
	IORegister		#(			.Width(				1))
					IOR(		.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				1'b0),
								.Enable(			1'b1),
								.In(				SIn),
								.Out(				IntSIn));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Clock Divider Counter
	//--------------------------------------------------------------------------
	Counter			#(			.Width(				DivWidth))
					RxDivCnt(	.Clock(				Clock),
								.Reset(				Reset | (RxDivCount == (Divisor-1)) | RxStart),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			1'b1),
								.In(				{DivWidth{1'bx}}),
								.Count(				RxDivCount));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Hold Control Register
	//--------------------------------------------------------------------------
	generate if (HoldReceived) begin:HOLD
		wire			RxEnableState;
		
		Register	#(			.Width(				1))
					HRReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				RxStart),
								.Enable(			DataOutValid),
								.In(				1'b0),
								.Out(				RxEnableState));
		
		assign	RxEnable =							RxEnableState | RxStart;
	end else begin:NOHOLD
		assign	RxEnable =							1'b1;
	end endgenerate
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Bit Counter
	//--------------------------------------------------------------------------
	Counter			#(			.Width(				BCWidth))
					RxBitCnt(	.Clock(				Clock),
								.Reset(				RxStart),
								.Set(				Reset),
								.Load(				1'b0),
								.Enable(			RxBit),
								.In(				{BCWidth{1'bx}}),
								.Count(				RxBitCount));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Shift Register and Bit Reversal
	//--------------------------------------------------------------------------
	ShiftRegister	#(			.PWidth(			BitCount),
								.SWidth(			1))
					RxShift(	.Clock(				Clock),
								.Reset(				1'b0),
								.Load(				Reset),
								.Enable(			RxShiftEnable),
								.PIn(				{BitCount{1'b1}}),
								.SIn(				IntSIn),
								.POut(				RxData),
								.SOut(				/* Unconnected */));
	Reverse			#(			.Width(				Width))
					RxReverse(	.In(				RxDataStripped),
								.Out(				DataOut));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Received Transfered Register
	//--------------------------------------------------------------------------
	Register		#(			.Width(				1))
					RXTR(		.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				Reset | (DataOutReady & DataOutValid)),
								.Enable(			RxShiftEnable),
								.In(				(RxBitCount != (BitCount - 1))),
								.Out(				RxTransfered));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Parity Generator
	//--------------------------------------------------------------------------
	ParityGen		#(			.Width(				Width),
								.Parity(			Parity))
					RxParityGen(.In(				DataOut),
								.Out(				RxParity));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gateforge.org:26/Projects/GateLib/branches/dev/Firmware/UART/Hardware/UATransmitter.v $
//	Version:	$Revision: 12399 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		UATransmitter
//	Desc:		Standard Universal Asynchronous RS232/16550 type transmitter.
//	Params:		ClockFreq: Frequency (in Hz) of the "Clock" being fed to this
//						module.
//				Baud:	Desired Baud rate.  This is the rate at which this
//						module will send bits, and should be at most 1/4th
//						of the clock rate (or so).
//				Width:	Word width (in bits) of the words (bytes) send over
//						the serial line.
//				Parity:	The type of parity bit to be appended to each word of
//						data.
//						0:	None
//						1:	Even
//						2:	Odd
//						3:	Mark
//						4:	Space
//				StopBits:The number of bit-periods to send the stop condition.
//						Generally 1 or 2, though larger numbers are possible.
//	Ex:			(27000000, 9600, 8, 0, 1) Standard 9600baud 8-N-1 serial port
//						settings used as the default by many devices, based
//						on a 27MHz clock.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12399 $
//------------------------------------------------------------------------------
module	UATransmitter(Clock, Reset, DataIn, DataInValid, DataInReady, SOut);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				ClockFreq =				27000000,
							Baud =					115200,
							Width =					8,
							Parity =				0,
							StopBits =				1;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Local Parameters
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				Divisor =				ClockFreq / Baud,
							DivWidth =				`log2(Divisor),
							Capture =				(Divisor / 2),
							BitCount =				Width + StopBits + (Parity ? 1 : 0) + 1,
							BCWidth =				`log2(BitCount + 1),
							ActualBaud =			ClockFreq / Divisor;
	`endif

	`ifdef SIMULATION
	localparam real			MaxBaud =				ClockFreq / ((Divisor * (BitCount - 0.5)) / BitCount),
							MinBaud =				ClockFreq / ((Divisor * (BitCount + 0.5)) / BitCount);
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constant Debugging Statements
	//--------------------------------------------------------------------------
	`ifdef SIMULATION
		initial begin
			$display("DEBUG[%m @ %t]: UART Parameters", $time);
			$display("    ClockFreq =  %d", ClockFreq);
			$display("    Baud =       %d", Baud);
			$display("    Width =      %d", Width);
			$display("    Parity =     %d", Parity);
			$display("    StopBits =   %d", StopBits);

			/*$display("    Divisor =    %d", Divisor);
			$display("    DivWidth =   %d", DivWidth);
			$display("    Capture =    %d", Capture);
			$display("    BitCount =   %d", BitCount);
			$display("    BCWidth =    %d", BCWidth);*/

			$display("    ActualBaud = %d", ActualBaud);
			$display("    MaxBaud =    %f", MaxBaud);
			$display("    MinBaud =    %f", MinBaud);
		end
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;	
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Parallel Data Input
	//--------------------------------------------------------------------------
	input	[Width-1:0]		DataIn;
	input					DataInValid;
	output					DataInReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Serial Interface
	//--------------------------------------------------------------------------
	output					SOut;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	 Wires & Regs
	//--------------------------------------------------------------------------
	wire					IntSOut;

	wire	[DivWidth-1:0]	TxDivCount;
	wire	[BCWidth-1:0]	TxBitCount;
	wire	[BitCount-1:0]	TxData;
	wire					TxShiftEnable, TxRunning, TxBit, TxStart, TxParity;
	wire	[BitCount-1:0]	DataInAugmented;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Assigns and Decodes
	//--------------------------------------------------------------------------
	assign	TxShiftEnable =							(TxDivCount == (Divisor - 1));
	assign	TxRunning =								(TxBitCount < BitCount);
	assign	TxBit =									TxRunning & TxShiftEnable;
	assign	TxStart =								DataInValid & DataInReady;

	assign	DataInReady =							~TxRunning & ~Reset;
	assign	DataInAugmented =						Parity ? {{StopBits{1'b1}}, TxParity, DataIn, 1'b0} : {{StopBits{1'b1}}, DataIn, 1'b0};
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	IO Register
	//--------------------------------------------------------------------------
	IORegister		#(			.Width(				1))
					IOR(		.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				1'b0),
								.Enable(			1'b1),
								.In(				IntSOut),
								.Out(				SOut));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Clock Divider Counter
	//--------------------------------------------------------------------------
	Counter			#(			.Width(			DivWidth))
					TxDivCnt(	.Clock(				Clock),
								.Reset(				Reset | (TxDivCount == (Divisor-1)) | TxStart),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			1'b1),
								.In(				{DivWidth{1'bx}}),
								.Count(				TxDivCount));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Bit Counter
	//--------------------------------------------------------------------------
	Counter			#(			.Width(				BCWidth))			
					TxBitCounter(.Clock(			Clock),
								.Reset(				TxStart),
								.Set(				Reset),
								.Load(				1'b0),
								.Enable(			TxBit),
								.In(				{BCWidth{1'bx}}),
								.Count(				TxBitCount));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Shift Register and Bit Reversal
	//--------------------------------------------------------------------------
	ShiftRegister	#(			.PWidth(			BitCount),
								.SWidth(			1))
					TxShift(	.Clock(				Clock),
								.Reset(				1'b0),
								.Load(				TxStart | Reset),
								.Enable(			TxShiftEnable),
								.PIn(				Reset ? {BitCount{1'b1}} : TxData),
								.SIn(				1'b1),
								.POut(				/* Unconnected */),
								.SOut(				IntSOut));
	Reverse			#(			.Width(				BitCount))
					TxReverse(	.In(				DataInAugmented),
								.Out(				TxData));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Parity Generator
	//--------------------------------------------------------------------------
	ParityGen		#(			.Width(				Width),
								.Parity(			Parity))
					TxParityGen(.In(				DataIn),
								.Out(				TxParity));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Platforms/Virtex/Hardware/DRP/DRPAdapter.v $
//	Version:	$Revision: 11840 $
//	Author:		Marcelo Velloso
//				Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		DRPAdapter
//	Desc:		...
//	Params:		...
//	Author:		Marcelo Velloso
//				<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	DRPAdapter(
			//------------------------------------------------------------------
			//	System Inputs
			//------------------------------------------------------------------
			Clock, Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	DRP Adpater Ports
			//------------------------------------------------------------------
			Command,
			CommandAddress,
			CommandValid,
			CommandReady,
			
			DataIn,
			DataInValid,
			DataInReady,
			
			DataOut,
			DataOutValid,
			DataOutReady,	// Mostly ignored (one the command starts, this better stay high), since this is a source of data
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	DRP Ports
			//------------------------------------------------------------------
			DADDR,
			DEN, DWE,
			DRDY,
			DI,
			DO
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				DWidth =				16,
							AWidth =				7;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	localparam				COMMAND_Write =			1'b0,
							COMMAND_Read =			1'b1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	DRP Adpater Ports
	//--------------------------------------------------------------------------
	input					Command;
	input	[AWidth-1:0]	CommandAddress;
	input					CommandValid;
	output					CommandReady;
	
	input	[DWidth-1:0]	DataIn;
	input					DataInValid;
	output					DataInReady;
	
	output	[DWidth-1:0]	DataOut;
	output					DataOutValid;
	input					DataOutReady;	// Mostly ignored (one the command starts, this better stay high), since this is a source of data
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	DRP Ports
	//--------------------------------------------------------------------------
	output	[AWidth-1:0]	DADDR;
	output					DEN, DWE;
	input					DRDY;
	output	[DWidth-1:0]	DI;
	input	[DWidth-1:0]	DO;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					Write, Read;
	wire					DataOK, WasRead, DRDYReady, DRDYWait;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	// Handshaking
	assign	Write =									Command === COMMAND_Write;
	assign	Read =									Command === COMMAND_Read;
	
	// Data I/O Logic
	assign DI =										DataIn;
	assign DataOut =								DO;
	
	// Command Interface Logic
	assign DADDR =									CommandAddress;
	assign DWE =									Write;
	
	// Handshaking
	assign DataInReady =							DRDYReady & Write & CommandValid;
	assign CommandReady =							DRDYReady & DataOK;
	assign DataOutValid =							DRDY & WasRead;
	assign DataOK =									Write ? DataInValid : DataOutReady;	
	assign DEN =									(CommandValid & DataOK & DRDYReady);
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	DRDY Wait
	//--------------------------------------------------------------------------
	Register 		#(			.Width(				1)) 
					DRDYWaitReg(.Clock(				Clock), 
								.Reset(				Reset), 
								.Set(				DEN), 
								.Enable(			DRDY),
								.In(				1'b0),
								.Out(				DRDYWait));
	assign DRDYReady =								~DRDYWait | DRDY;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Was Read
	//--------------------------------------------------------------------------
	Register 		#(			.Width(				1)) 
					WRReg(		.Clock(				Clock), 
								.Reset(				Reset), 
								.Set(				1'b0), 
								.Enable(			DEN),
								.In(				Read),
								.Out(				WasRead));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gateforge.org:26/Projects/GateLib/branches/dev/Platforms/Virtex/Hardware/Engine/ResetDCM.v $
//	Version:	$Revision: 12537 $
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		ResetDCM
//	Desc:		Provides reset generation both for a DCM, and per-clock for each
//				set of output logic.  Ensures that there are no combinational
//				paths, that resets are held even after the clock outputs from
//				the DCM lock and optionally resets user logic before resetting
//				the DCM too.
//				
//				Standard usage consists of:
//					Clock should be the same clock that is being passed into the
//					DCM.  Presumably this comes from a pad and passes only
//					through a BUFG before fanning out to this module and the
//					DCM.
//					Reset should come from a some primal source, such as an
//					instanceof ResetGenerator.
//					DerivedClocks will be the bit-wise concatenation of all of
//					the clock outputs from the DCM (after they are run through
//					a BUFG) for which this module should generate a reset.
//					DerivedResets will be a bit-wise concatenation of the
//					resets generated by this module, with one for each derived
//					clock.
//
//	Params:		NDerived:	The number of derived clocks and resets.
//				PreReset:	Flag indication whether derived resets should be
//							asserted before the DCM is reset (they are always
//							kept asserted for a few cycles after DCM lock).
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12537 $
//------------------------------------------------------------------------------
module	ResetDCM(Clock, Reset, DCMReset, DCMLocked, DerivedClocks, DerivedResets);
	//--------------------------------------------------------------------------
	//	Per-Instance Parameters
	//--------------------------------------------------------------------------
	parameter				NDerived =						1,
							PreReset =						0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	output reg				DCMReset;
	input					DCMLocked;
	input	[NDerived-1:0]	DerivedClocks;
	output	[NDerived-1:0]	DerivedResets;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	States
	//--------------------------------------------------------------------------
	localparam				STATE_Width =					2,
							STATE_Initial =					2'b00,
							STATE_Pre =						2'b01,
							STATE_DCM =						2'b11,
							STATE_Post =					2'b10;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	genvar					i;
	wire	[NDerived-1:0]	DerivedTest;
	
	wire	[1:0]			CycleCount;
	
	wire	[STATE_Width-1:0] CurrentState;
	reg		[STATE_Width-1:0] NextState;
	reg						LogicReset, CycleCountReset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Derived Shift Registers
	//--------------------------------------------------------------------------
	generate for (i = 0; i < NDerived; i = i + 1) begin:PERDERIVED
		ShiftRegister #(		.PWidth(			2),
								.SWidth(			1),
								.Reverse(			0),
								.Initial(			2'bxx),
								.AsyncReset(		1),
								.ResetValue(		2'b11))
					Derive(		.Clock(				DerivedClocks[i]),
								.Reset(				~DCMLocked),
								.Load(				1'b0),
								.Enable(			1'b1),
								.PIn(				2'bxx),
								.SIn(				LogicReset),
								.POut(				/* Unconnected */),
								.SOut(				DerivedResets[i]));
		ShiftRegister #(		.PWidth(			2),
								.SWidth(			1),
								.Reverse(			0),
								.Initial(			2'bxx),
								.AsyncReset(		0),
								.ResetValue(		2'b00))
					Test(		.Clock(				Clock),
								.Reset(				Reset),
								.Load(				1'b0),
								.Enable(			1'b1),
								.PIn(				2'bxx),
								.SIn(				DerivedResets[i]),
								.POut(				/* Unconnected */),
								.SOut(				DerivedTest[i]));
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Cycle Counter
	//--------------------------------------------------------------------------
	Counter			#(			.Width(				2))
					CCnt(		.Clock(				Clock),
								.Reset(				CycleCountReset),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			1'b1),
								.In(				2'bxx),
								.Count(				CycleCount));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	State Register
	//--------------------------------------------------------------------------
	Register		#(			.Width( 			STATE_Width),
								.Initial(			STATE_Initial),
								.AsyncReset(		0),
								.AsyncSet(			0),
								.ResetValue(		STATE_Initial),
								.SetValue(			STATE_Initial))
					State(		.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				1'b0),
								.Enable(			1'b1),
								.In(				NextState),
								.Out(				CurrentState));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Next State & Output Logic
	//--------------------------------------------------------------------------
	always @ (*) begin
		DCMReset =									1'b0;
		LogicReset =								1'b0;
		CycleCountReset =							1'b1;
		NextState =									CurrentState;
		
		case (CurrentState)
			STATE_Initial: begin
				if (Reset) NextState =				PreReset ? STATE_Pre : STATE_DCM;
			end
			STATE_Pre: begin
				LogicReset =						1'b1;
				if (Reset) NextState =				PreReset ? STATE_Pre : STATE_DCM;
				else if (&DerivedTest) NextState =	STATE_DCM;
			end
			STATE_DCM: begin
				LogicReset =						1'b1;
				CycleCountReset =					1'b0;
				DCMReset =							1'b1;
				if (&CycleCount) begin
					if (Reset) NextState =			PreReset ? STATE_Pre : STATE_DCM;
					else NextState =				STATE_Post;
				end
			end
			STATE_Post: begin
				if (Reset) NextState =				PreReset ? STATE_Pre : STATE_DCM;
				else if (~|DerivedTest) NextState =	STATE_Initial;
			end
			default: begin
				DCMReset =							1'bx;
				LogicReset =						1'bx;
				NextState =							{STATE_Width{1'bx}};
			end
		endcase
	end
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gateforge.org:26/Projects/GateLib/branches/dev/Platforms/Virtex/Hardware/Engine/ResetGenerator.v $
//	Version:	$Revision: 12532 $
//	Author:		Ilia Lebedev
//				Greg Gibeling
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		ResetGenerator
//	Desc:		Provides a system Reset signal from one or more of the following sources:
//				- An input (eg. from a button).
//				- A power-on Reset pulse of configurable width and delay.
//	Params:		...
//	Author:		Ilia Lebedev
//				<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12532 $
//------------------------------------------------------------------------------
module	ResetGenerator(Clock, Reset, In, Out);
	//--------------------------------------------------------------------------
	//	Per-Instance Parameters
	//--------------------------------------------------------------------------
	parameter				ClockFreq =						200000000,
							UseIn =							1,
							UsePowerOn =					1,
							InWidth =						1,
							POWidth =						1,
							PODelay =						0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset, In;
	output					Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					InPulse, POPulse;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Button-Parsed Pulse
	//--------------------------------------------------------------------------
	generate if (UseIn) begin:INRESET
		ButtonParse	#(			.Width(				1),
								.DebWidth(			`log2(ClockFreq / 100)), // Use a 10ms button parser (roughly)
								.EdgeOutWidth(		InWidth))
					InBP(		.Clock(				Clock),
								.Reset(				Reset),
								.Enable(			1'b1),
								.In(				In),
								.Out(				InPulse));
	end else begin:INNORESET
		// If a button-parsed reset signal is not needed, the circuitry to generate it is ommitted.
		assign	InPulse =							1'b0;
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Power-On Pulse
	//--------------------------------------------------------------------------
	generate if (UsePowerOn) begin:PORESET
		ShiftRegister #(		.PWidth(			POWidth+PODelay),
								.SWidth(			1),
								.Reverse(			0),
								.Initial(			{{PODelay{1'b0}}, {POWidth{1'b1}}}))
					POShft(		.Clock(				Clock),
								.Reset(				Reset),
								.Load(				1'b0),
								.Enable(			1'b1),
								.PIn(				{POWidth+PODelay{1'bx}}),
								.SIn(				1'b0),
								.POut(				/* Unconnected */),
								.SOut(				POPulse));
	end else begin:PONORESET
		// If a power-on reset signal is not needed, the circuitry to generate it is ommitted.
		assign	POPulse =							1'b0;
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Logic
	//--------------------------------------------------------------------------
	assign Out =									InPulse | POPulse;
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Platforms/Virtex/Hardware/IO/DDR2SDR.v $
//	Version:	$Revision: 11840 $
//	Author:		Ilia Lebedev
//				Greg Gibeling
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		DDR2SDR Demux
//	Desc:		...
//	Params:		...
//	Author:		Ilia Lebedev
//				<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	DDR2SDR(Clock, Reset, Set, In, Out);
	//--------------------------------------------------------------------------
	//	Per-Instance Constants
	//--------------------------------------------------------------------------
	parameter				DDRWidth =				1,
							Interleave =			1,	// If 1, posedge bits are taken from odd-numbered bits of In. If 0, posedge bits are taken from In[DDRWidth-1:0]
							Pipeline =				1;	// Select between SAME_EDGE_PIPELINED and SAME_EDGE
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				SDRWidth =				2*DDRWidth;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset, Set;
	input	[DDRWidth-1:0]	In;
	output	[SDRWidth-1:0]	Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	genvar					i;
	wire	[SDRWidth-1:0]	InterleavedOut, NonInterleavedOut;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assignments
	//--------------------------------------------------------------------------
	assign	Out =									Interleave ? InterleavedOut : NonInterleavedOut;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	DDR Demux
	//--------------------------------------------------------------------------
	generate for (i = 0; i < DDRWidth; i = i + 1) begin:BIT
			IDDR	#(		.DDR_CLK_EDGE(			Pipeline ? "SAME_EDGE_PIPELINED" : "SAME_EDGE")) // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED" are the options
					IDDR(		.Q1(				InterleavedOut[(2*i)+(Pipeline?0:1)]),	// 1-bit output for positive edge of clock
								.Q2(				InterleavedOut[(2*i)+(Pipeline?1:0)]),	// 1-bit output for negative edge of clock
								.C(					Clock),						// 1-bit clock input
								.CE(				1'b1),						// 1-bit clock enable input
								.D(					In[i]),						// 1-bit DDR data input
								.R(					Reset),						// 1-bit reset
								.S(					Set));						// 1-bit set
			
			assign	NonInterleavedOut[i] =			InterleavedOut[2*i];
			assign	NonInterleavedOut[DDRWidth+i] =	InterleavedOut[(2*i)+1];
		end
	endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Platforms/Virtex/Hardware/IO/IODelayControl.v $
//	Version:	$Revision: 11840 $
//	Author:		Ilia Lebedev
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		IODelayControl
//	Desc:		A necessary primitive used to calibrate IODELAY primitives in a bank.
//	Params:		...
//	Author:		Ilia Lebedev
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	IODelayControl(Clock, Reset, Ready);
	//--------------------------------------------------------------------------
	//	Per-Instance Constants
	//--------------------------------------------------------------------------
	parameter				NumInstances =			2,
							LocConstraints =		"IDELAYCTRL_X0Y0,IDELAYCTRL_X2Y1";
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	output	[NumInstances-1:0] Ready;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	genvar					i;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Delay Control Primitive
	//--------------------------------------------------------------------------
	generate for (i = 0; i < NumInstances; i = i + 1) begin : bit
		(* xc_loc=LocConstraints, chip_pin=LocConstraints, LOC=LocConstraints *)
		IDELAYCTRL	Control(	.REFCLK(			Clock),
								.RST(				Reset),
								.RDY(				Ready[i]))	/* synthesis syn_noprune=1 */;
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Platforms/Virtex/Hardware/IO/IODelayMultiple.v $
//	Version:	$Revision: 11840 $
//	Author:		Ilia Lebedev
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		IODelayMultiple
//	Desc:		A set of tapped delay lines that allow N channels of M bits
//				each to be delayed independently.
//	Params:		LaneWidth:	M, The width of a single channel. All bits
//								within a channel share a tap delay value.
//				NLanes:		N, The number of M-bit channels.
//	Author:		Ilia Lebedev
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	IODelayMultiple(Clock, Reset, In, Out, Increment, Enable);
	//--------------------------------------------------------------------------
	//	Per-Instance Parameters
	//--------------------------------------------------------------------------
	parameter				ReferenceClockFreq =	200_000_000,
							LaneWidth =				2,
							NLanes =				3;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Per-Instance Constants
	//--------------------------------------------------------------------------
	localparam				Width =					(LaneWidth * NLanes),
							IODelayFrequency =		(ReferenceClockFreq / 1_000_000);
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Data I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		In;
	output	[Width-1:0]		Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	 Delay Control
	//--------------------------------------------------------------------------
	input	[NLanes-1:0]	Increment;
	input	[NLanes-1:0]	Enable;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	genvar					i, j;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Delay Primitive
	//--------------------------------------------------------------------------
	generate for (i = 0; i < NLanes; i = i + 1) begin:CHANNEL
		for (j = 0; j < LaneWidth; j = j + 1) begin:BIT
			IODELAY #(		.IDELAY_TYPE(				"VARIABLE"),
							.IDELAY_VALUE(				0),
							.ODELAY_VALUE(				0),
							.REFCLK_FREQUENCY(			IODelayFrequency),
							.HIGH_PERFORMANCE_MODE(		"TRUE"))
					IODELAY(.C(							Clock),
							.RST(						Reset),
							.DATAOUT(					Out[(i*LaneWidth) + j]),
							.IDATAIN(					In[(i*LaneWidth) + j]),
							.ODATAIN(					1'b0),
							.DATAIN(					1'b0),
							.T(							/* Unconnected */),
							.CE(						Enable[i]),
							.INC(						Increment[i]));
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Platforms/Virtex/Hardware/IO/SDR2DDR.v $
//	Version:	$Revision: 11840 $
//	Author:		Ilia Lebedev
//				Greg Gibeling
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		SDR2DDR Mux
//	Desc:		...
//	Params:		...
//	Author:		Ilia Lebedev
//				<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	SDR2DDR(Clock, Reset, Set, In, Out);
	//--------------------------------------------------------------------------
	//	Per-Instance Constants
	//--------------------------------------------------------------------------
	parameter				DDRWidth =				1,
							Interleave =			1;	// If 1, posedge bits are taken from odd-numbered bits of In. If 0, posedge bits are taken from In[DDRWidth-1:0]
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				SDRWidth =				2*DDRWidth;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset, Set;
	input	[SDRWidth-1:0]	In;
	output	[DDRWidth-1:0]	Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	genvar					i;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	DDR Mux
	//--------------------------------------------------------------------------
	generate for (i = 0; i < DDRWidth; i = i+1) begin : bit
			// NOTE:	Data is transmitted with a 180-degree phase shift! DDR Data *must* be deskewed before use, or the receiver must listen on negative edges.
			ODDR	#(			.DDR_CLK_EDGE(		"SAME_EDGE"))	// "OPPOSITE_EDGE" or "SAME_EDGE" are the options, but we use "SAME_EDGE"
					ODDR(		.Q(					Out[i]),		// 1-bit DDR output
								.C(					Clock),			// 1-bit clock input
								.CE(				1'b1),			// 1-bit clock enable input
								.D1(				(Interleave ? In[2*i] : In[i])),				// 1-bit data input (1st edge - negative)
								.D2(				(Interleave ? In[(2*i)+1] : In[DDRWidth+i])),	// 1-bit data input (2nd edge - positive)
								.R(					Reset),			// 1-bit reset
								.S(					Set));			// 1-bit set
		end
	endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/PatternGen/Hardware/FIFO/FIFOPatternCheck.v $
//	Version:	$Revision: 11840 $
//	Author:		Ilia Lebedev
//				Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOPatternCheck
//	Desc:		...
//	Params:		...
//	Author:		Ilia Lebedev
//				<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOPatternCheck(Clock, Reset, InData, InValid, InReady, WordCount, ErrorCount);
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				DWidth =				32,			// Width of the data
							RWidth =				32,			// Width of the report counters
							PatternControl =		SPGCTL_LFSR,
							PatternInitial =		{1'b1, {DWidth-1{1'b0}}},
							PatternResetValue =		{1'b1, {DWidth-1{1'b0}}},
							PatternLFSRPoly =		32'h04C11DB7,
							EnableControl =			SEGCTL_Random,
							EnableInitial =			1'b0,
							EnableResetValue =		1'b0,
							EnableCountFixed =		2,
							EnableRandomWidth = 	32,
							EnableRandomDividend =	32'h243b807f,
							EnableRandomDivisor =	32'h35a414bb,
							EnableRandomPoly = 		32'h243b807f;
	//--------------------------------------------------------------------------
							
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Data Input
	//--------------------------------------------------------------------------
	input	[DWidth-1:0]	InData;
	input					InValid;
	output					InReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Report Output
	//--------------------------------------------------------------------------
	output	[RWidth-1:0]	WordCount;
	output	[RWidth-1:0]	ErrorCount;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	wire	[DWidth-1:0]	CheckData;
	wire					CheckValid, CheckReady;
	
	wire					Enable;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Check Generator
	//--------------------------------------------------------------------------
	FIFOPatternGen	#(			.DWidth(			DWidth),
								.PatternControl(	PatternControl),
								.PatternInitial(	PatternInitial),
								.PatternResetValue(	PatternResetValue),
								.PatternLFSRPoly(	PatternLFSRPoly),
								.EnableControl(		EnableControl),
								.EnableInitial(		EnableInitial),
								.EnableResetValue(	EnableResetValue),
								.EnableCountFixed(	EnableCountFixed),
								.EnableRandomWidth(	EnableRandomWidth),
								.EnableRandomDividend(EnableRandomDividend),
								.EnableRandomDivisor(EnableRandomDivisor),
								.EnableRandomPoly(	EnableRandomPoly))
					CheckGen(	.Clock(				Clock),
								.Reset(				Reset),
								.OutData(			CheckData),
								.OutValid(			CheckValid),
								.OutReady(			CheckReady));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Rendezvous
	//--------------------------------------------------------------------------
	FIFORendezvous	#(			.NInputs(			2),
								.NOutputs(			1))
					Rendezvous(	.Clock(				Clock),
								.Reset(				Reset),
								.InValid(			{InValid, CheckValid}),
								.InAccept(			{InReady, CheckReady}),
								.OutSend(			Enable),
								.OutReady(			1'b1));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Reporting Logic
	//--------------------------------------------------------------------------
	Counter			#(			.Width(				RWidth),
								.Initial(			{RWidth{1'b0}}))
					WrdCnt(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			Enable),
								.In(				{RWidth{1'bx}}),
								.Count(				WordCount));
	
	Counter			#(			.Width(				RWidth),
								.Initial(			{RWidth{1'b0}}))
					ErrCnt(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			Enable & (InData != CheckData)),
								.In(				{RWidth{1'bx}}),
								.Count(				ErrorCount));
	//--------------------------------------------------------------------------	
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/PatternGen/Hardware/FIFO/FIFOPatternGen.v $
//	Version:	$Revision: 11840 $
//	Author:		Ilia Lebedev
//				Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOPatternGen
//	Desc:		...
//	Params:		...
//	Author:		Ilia Lebedev
//				<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOPatternGen(Clock, Reset, OutData, OutValid, OutReady);
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				DWidth =				32,			// Width of the data
							PatternControl =		SPGCTL_LFSR,
							PatternInitial =		{1'b1, {DWidth-1{1'b0}}},
							PatternResetValue =		{1'b1, {DWidth-1{1'b0}}},
							PatternLFSRPoly =		32'h04C11DB7,
							EnableControl =			SEGCTL_Random,
							EnableInitial =			1'b0,
							EnableResetValue =		1'b0,
							EnableCountFixed =		2,
							EnableRandomWidth = 	32,
							EnableRandomDividend =	32'h243b807f,
							EnableRandomDivisor =	32'h35a414bb,
							EnableRandomPoly = 		32'h243b807f;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				CountWidth =			`log2(EnableCountFixed+1);
	`else
	localparam				CountWidth =			EnableCountFixed;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Data Output
	//--------------------------------------------------------------------------
	output	[DWidth-1:0]	OutData;
	output					OutValid;
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	wire	[CountWidth-1:0] EnableCountVariable;
	wire					Fire;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	EnableCountVariable =					EnableCountFixed;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Out Pattern Gen
	//--------------------------------------------------------------------------
	SimplePatternGen #(			.PWidth(			DWidth),
								.SWidth(			1),
								.Initial(			PatternInitial),
								.ResetValue(		PatternResetValue),
								.LFSRPoly(			PatternLFSRPoly),
								.PGControlMask(		1 << PatternControl))
					OGen(		.Clock(				Clock),
								.Reset(				Reset),
								.Load(				1'b0),
								.Enable(			OutValid & OutReady),
								.Control(			PatternControl),
								.In(				{DWidth{1'b0}}),
								.Out(				OutData));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Valid Enable Gen
	//--------------------------------------------------------------------------
	SimpleEnableGen	#(			.Initial(			EnableInitial),
								.ResetValue(		EnableResetValue),
								.CountWidth(		CountWidth),
								.RandomWidth( 		EnableRandomWidth),
								.RandomPoly( 		EnableRandomPoly),
								.EGControlMask(		1 << EnableControl))
					OVGen(		.Clock(				Clock),
								.Reset(				Reset),
								.Enable(			1'b1),
								.Control(			EnableControl),
								.RandomDividend(	EnableRandomDividend),
								.RandomDivisor(		EnableRandomDivisor),
								.RandomLoad(		1'b0),
								.CountVariable(		EnableCountVariable),
								.CountMax(			/* Unconnected */),
								.Out(				Fire));
	
	FIFORegControl	#(			.FWLatency(			0),
								.BWLatency(			0))
					FRC(		.Clock(				Clock),
								.Reset(				Reset),
								.InValid(			Fire),
								.InAccept(			),
								.OutSend(			OutValid),
								.OutReady(			OutReady),
								.Full(				/* Unconnected */));
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/PatternGen/Hardware/PatternGen.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//				James Martin
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		PatternGen
//	Desc:		A programmable pattern generator.  This module includes two
//				simple pattern generators and two enable generators the four
//				of which can be combined in interesting ways to produce a
//				wide range of test patterns.
//				
//				This module is designed to be used in link, memory and other
//				test stimulus generation.  The enable patterns have been
//				included to allow testing at different temporal data patterns
//				which can catch a wide variety of seqeuential faults.
//				
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//				James Martin
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	PatternGen(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Control
			//------------------------------------------------------------------
			// Each signal is annotated with a value you can use if you know nothing better
			Enable,					// Default: 1'b1
			
			SEG0_Control,			// Default: SEGCTL_Nth
			SEG0_EnableSelect,		// Default: SEGES_One
			SEG0_RandomDividend,	// Default: Unconnected
			SEG0_RandomDivisor,		// Default: Unconnected
			SEG0_RandomLoad,		// Default: 1'b0
			SEG0_CountVariable,		// Default: 0
			
			SEG1_Control,			// Default: SEGCTL_Nth
			SEG1_EnableSelect,		// Default: SEGES_One
			SEG1_RandomDividend,	// Default: Unconnected
			SEG1_RandomDivisor,		// Default: Unconnected
			SEG1_RandomLoad,		// Default: 1;b0
			SEG1_CountVariable,		// Default: 0
			
			SPG0_Load,				// Default: 1'b0
			SPG0_Control,			// Default: SPGCTL_LFSR
			SPG0_EnableSelect,		// Default: SPGES_Enable
			SPG0_In,				// Default: 0
			
			SPG1_Load,				// Default: 1'b0
			SPG1_Control,			// Default: SPGCTL_LFSR
			SPG1_EnableSelect,		// Default: SPGES_Enable
			SPG1_In,				// Default: 0
			
			SPO_Control,			// Default: SPOCTL_In0
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output
			//------------------------------------------------------------------
			Out
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							SEG0_Initial =			1'b0,
							SEG0_ResetValue =		1'b0,
							SEG0_CountWidth =		4,
							SEG0_RandomWidth = 		32,
							SEG0_RandomPoly = 		32'h243b807f,
							SEG1_Initial =			1'b0,
							SEG1_ResetValue =		1'b0,
							SEG1_CountWidth =		4,
							SEG1_RandomWidth = 		32,
							SEG1_RandomPoly = 		32'h243b807f,
	`ifdef MACROSAFE
							SEG0_EGControlMask =	{`pow2(SEGCTL_CWidth){1'b1}},
							SEG1_EGControlMask =	{`pow2(SEGCTL_CWidth){1'b1}},
	`else
							SEG0_EGControlMask =	2'h3,
							SEG1_EGControlMask =	2'h3,
	`endif
							SPG0_SWidth =			1,					// Shift (for shift, rotate and LFSR) width
							SPG0_Initial =			{1'b1, {(Width-1){1'b0}}},
							SPG0_ResetValue =		{1'b1, {(Width-1){1'b0}}},
							SPG0_LFSRPoly =			32'h04C11DB7,		// Standard 802.3 CRC32 polynomial
							SPG1_SWidth =			1,
							SPG1_Initial =			{1'b1, {(Width-1){1'b0}}},
							SPG1_ResetValue =		{1'b1, {(Width-1){1'b0}}},
							SPG1_LFSRPoly =			32'h04C11DB7,
	`ifdef MACROSAFE
							SPG0_PGControlMask =	{`pow2(SPGCTL_CWidth){1'b1}},
							SPG1_PGControlMask =	{`pow2(SPGCTL_CWidth){1'b1}};
	`else
							SPG0_PGControlMask =		16'hFFFF,
							SPG1_PGControlMask =		16'hFFFF;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Control
	//--------------------------------------------------------------------------
	input					Enable;
	
	input	[SEGCTL_CWidth-1:0] SEG0_Control;
	input	[SEGES_Width-1:0] SEG0_EnableSelect;
	input	[SEG0_RandomWidth-1:0] SEG0_RandomDividend, SEG0_RandomDivisor;
	input					SEG0_RandomLoad;
	input	[SEG0_CountWidth-1:0] SEG0_CountVariable;
	
	input	[SEGCTL_CWidth-1:0] SEG1_Control;
	input	[SEGES_Width-1:0] SEG1_EnableSelect;
	input	[SEG1_RandomWidth-1:0] SEG1_RandomDividend, SEG1_RandomDivisor;
	input					SEG1_RandomLoad;
	input	[SEG1_CountWidth-1:0] SEG1_CountVariable;
	
	input					SPG0_Load;
	input	[SPGCTL_CWidth-1:0] SPG0_Control;
	input	[SPGES_Width-1:0] SPG0_EnableSelect;
	input	[Width-1:0]		SPG0_In;
	
	input					SPG1_Load;
	input	[SPGCTL_CWidth-1:0] SPG1_Control;
	input	[SPGES_Width-1:0] SPG1_EnableSelect;
	input	[Width-1:0]		SPG1_In;
	
	input	[SPOCTL_CWidth-1:0] SPO_Control;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output
	//--------------------------------------------------------------------------
	output	[Width-1:0]		Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	reg						SEG0_Enable, SEG1_Enable, SPG0_Enable, SPG1_Enable;
	
	wire					Enable0, Enable1;
	wire	[Width-1:0]		Pattern0, Pattern1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Enable Muxes
	//--------------------------------------------------------------------------
	always @ (*) begin
		case (SEG0_EnableSelect)
			SEGES_One: SEG0_Enable =				1'b1;
			SEGES_Other: SEG0_Enable =				Enable1;
			default: SEG0_Enable =					1'bx;
		endcase
	end
	always @ (*) begin
		case (SEG1_EnableSelect)
			SEGES_One: SEG1_Enable =				1'b1;
			SEGES_Other: SEG1_Enable =				Enable0;
			default: SEG1_Enable =					1'bx;
		endcase
	end
	
	always @ (*) begin
		case (SPG0_EnableSelect)
			SPGES_Zero: SPG0_Enable =				1'b0;
			SPGES_One: SPG0_Enable =				1'b1;
			SPGES_Enable: SPG0_Enable =				Enable0;
			SPGES_And: SPG0_Enable =				Enable0 & Enable1;
			default: SPG0_Enable =					1'bx;
		endcase
	end
	always @ (*) begin
		case (SPG1_EnableSelect)
			SPGES_Zero: SPG1_Enable =				1'b0;
			SPGES_One: SPG1_Enable =				1'b1;
			SPGES_Enable: SPG1_Enable =				Enable1;
			SPGES_And: SPG1_Enable =				Enable0 & Enable1;
			default: SPG1_Enable =					1'bx;
		endcase
	end
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Simple Enable Generators
	//--------------------------------------------------------------------------
	SimpleEnableGen #(			.Initial(			SEG0_Initial),
								.ResetValue(		SEG0_ResetValue),
								.CountWidth(		SEG0_CountWidth),
								.RandomWidth( 		SEG0_RandomWidth),
								.RandomPoly( 		SEG0_RandomPoly),
								.EGControlMask(		SEG0_EGControlMask))
					SEG0(		.Clock(				Clock),
								.Reset(				Reset),
								.Enable(			SEG0_Enable),
								.Control(			SEG0_Control),
								.RandomDividend(	SEG0_RandomDividend),
								.RandomDivisor(		SEG0_RandomDivisor),
								.RandomLoad(		SEG0_RandomLoad),
								.CountVariable(		SEG0_CountVariable),
								.CountMax(			/* Unconnected */),
								.Out(				Enable0));
	
	SimpleEnableGen #(			.Initial(			SEG1_Initial),
								.ResetValue(		SEG1_ResetValue),
								.CountWidth(		SEG1_CountWidth),
								.RandomWidth( 		SEG1_RandomWidth),
								.RandomPoly( 		SEG1_RandomPoly),
								.EGControlMask(		SEG1_EGControlMask))
					SEG1(		.Clock(				Clock),
								.Reset(				Reset),
								.Enable(			SEG1_Enable),
								.Control(			SEG1_Control),
								.RandomDividend(	SEG1_RandomDividend),
								.RandomDivisor(		SEG1_RandomDivisor),
								.RandomLoad(		SEG1_RandomLoad),
								.CountVariable(		SEG1_CountVariable),
								.CountMax(			/* Unconnected */),
								.Out(				Enable1));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Simple Pattern Generators
	//--------------------------------------------------------------------------
	SimplePatternGen #(			.PWidth(			Width),
								.SWidth(			SPG0_SWidth),
								.Initial(			SPG0_Initial),
								.ResetValue(		SPG0_ResetValue),
								.LFSRPoly(			SPG0_LFSRPoly),
								.PGControlMask(		SPG0_PGControlMask))
					SPG0(		.Clock(				Clock),
								.Reset(				Reset),
								.Load(				SPG0_Load),
								.Enable(			SPG0_Enable),
								.Control(			SPG0_Control),
								.In(				SPG0_In),
								.Out(				Pattern0));
	
	SimplePatternGen #(			.PWidth(			Width),
								.SWidth(			SPG1_SWidth),
								.Initial(			SPG1_Initial),
								.ResetValue(		SPG1_ResetValue),
								.LFSRPoly(			SPG1_LFSRPoly),
								.PGControlMask(		SPG1_PGControlMask))
					SPG1(		.Clock(				Clock),
								.Reset(				Reset),
								.Load(				SPG1_Load),
								.Enable(			SPG1_Enable),
								.Control(			SPG1_Control),
								.In(				SPG1_In),
								.Out(				Pattern1));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Pattern Operation
	//--------------------------------------------------------------------------
	SimplePatternOp	#(			.Width(				Width))
					POp(		.Control(			SPO_Control),
								.In0(				Pattern0),
								.In1(				Pattern1),
								.Out(				Out));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/PatternGen/Hardware/Simple/SimpleEnableGen.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//				James Martin
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		SimpleEnableGen
//	Desc:		Generates a sequence of bits, one per cycle, meant to provide
//				a programmable source of Enable signals.  Has an enable input to
//				move to the next bit and a Control input to determine the
//				pattern to the output
//				 
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//				James Martin
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	SimpleEnableGen(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Control
			//------------------------------------------------------------------
			Enable,
			Control,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Pattern Control
			//------------------------------------------------------------------
			RandomDividend,	// Default: 32'h243b807f
			RandomDivisor,	// Default: 32'h35a414bb
			RandomLoad,
			
			CountVariable,
			CountMax,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output
			//------------------------------------------------------------------
			Out
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Initial =				1'b0,
							ResetValue =			1'b0,
							CountWidth =			4,
							RandomWidth = 			32,
							RandomPoly = 			32'h243b807f,
	`ifdef MACROSAFE
							EGControlMask =			{`pow2(SEGCTL_CWidth){1'b1}};
	`else
							EGControlMask =			2'h3;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input 					Clock, Reset;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Control
	//--------------------------------------------------------------------------
	input					Enable;
	input	[SEGCTL_CWidth-1:0] Control;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Pattern Control
	//--------------------------------------------------------------------------
	input	[RandomWidth-1:0] RandomDividend, RandomDivisor;
	input					RandomLoad;
	
	input	[CountWidth-1:0] CountVariable;
	output					CountMax;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Output
	//--------------------------------------------------------------------------
	output reg				Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	wire	[CountWidth-1:0] Count;
	wire					RandomInValid, RandomInReady;
	wire					RandomOut;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Random Bit Source
	//--------------------------------------------------------------------------
	generate if (EGControlMask[SEGCTL_Random]) begin:RANDOM
		Register	#(			.Width(				1),
								.ResetValue(		1'b1),
								.SetValue(			1'b0))
					RInVReg(	.Clock(				Clock),
								.Reset(				Reset),
								.Set(				RandomInReady),
								.Enable(			RandomLoad),
								.In(				1'b1),
								.Out(				RandomInValid));
	
		RandomBits 	#(			.Width(				RandomWidth),
								.Poly(				RandomPoly))
					Random(		.Clock(				Clock),
								.Reset(				Reset),
								.Dividend(			RandomDividend),
								.Divisor(			RandomDivisor),
								.InValid(			RandomInValid | RandomLoad),
								.InReady(			RandomInReady),
								.OutBits(			RandomOut),
								.OutValid(			/* Unconnected */),
								.OutReady(			Enable));
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Every Nth
	//--------------------------------------------------------------------------
	generate if (EGControlMask[SEGCTL_Nth]) begin:NTH
		Counter		#(			.Width(				CountWidth))
					NthCnt(		.Clock(				Clock),
								.Reset(				Reset | (CountMax & Enable)),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			Enable),
								.In(				{CountWidth{1'bx}}),
								.Count(				Count));
		assign	CountMax =							Count >= CountVariable;
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Control
	//--------------------------------------------------------------------------
	always @ (*) begin
		if (EGControlMask[Control]) case (Control)
			SEGCTL_Zero: Out =						1'b0;
			SEGCTL_Nth: Out =						CountMax;
			SEGCTL_Random: Out =					RandomOut;
			default: Out =							1'bx;
		endcase
		else Out =									1'bx;
	end
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/PatternGen/Hardware/Simple/SimplePatternGen.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//				James Martin
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		SimplePatternGen
//	Desc:		A simple, runtime programmable, multi-bit pattern generator.
//				This module is incredibly useful for generating test patterns
//				of all kinds.
//
//	Params:		PWidth:	The width of the generated pattern output.
//				SWidth:	The shift width for the LFSR, shift and rotate patterns
//				LFSRPoly:An LFSR polynomial used to control the generation of
//						LFSR output patterns.
//	Inputs:		Enable:	Moves to the next pattern.
//				Load:	Load the specified input value.
//				Control:Select a certain pattern
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//				James Martin				
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	SimplePatternGen(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Control
			//------------------------------------------------------------------
			Load,
			Enable,
			Control,
			//------------------------------------------------------------------
            
			//------------------------------------------------------------------
			//	Data
			//------------------------------------------------------------------
			In,
			Out
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				PWidth =				32,					// Parallel output width
							SWidth =				1,					// Shift (for shift, rotate and LFSR) width
							Initial =				{1'b1, {(PWidth-1){1'b0}}},
							ResetValue =			{1'b1, {(PWidth-1){1'b0}}},
							LFSRPoly =				32'h04C11DB7,		// Standard 802.3 CRC32 polynomial
	`ifdef MACROSAFE
							PGControlMask =			{`pow2(SPGCTL_CWidth){1'b1}}; // Select which control values are allowed
	`else
							PGControlMask =			16'hFFFF;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Control
	//--------------------------------------------------------------------------	
	input					Load, Enable;
	input	[SPGCTL_CWidth-1:0] Control;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Data
	//--------------------------------------------------------------------------
	input	[PWidth-1:0]	In;
	output	[PWidth-1:0]	Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[PWidth-1:0]	LFSRNext;
	reg		[PWidth-1:0]	Next;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Core Register
	//--------------------------------------------------------------------------
	Register 		#(			.Width(		 		PWidth),
								.Initial( 			Initial),
								.ResetValue(		ResetValue))
					Core(		.Clock(				Clock), 
								.Reset(				Reset), 
								.Set(				1'b0), 
								.Enable(			Load | Enable), 
								.In(				Next), 
								.Out(				Out));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	LFSR Polynomial
	//--------------------------------------------------------------------------
	LFSRPoly		#(			.PWidth( 			PWidth),
								.SWidth( 			SWidth),
								.Poly(				LFSRPoly))
					LFSRGen(	.PIn(				Out),
								.SIn(				In[SWidth-1:0]), 
								.POut(				LFSRNext));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Mux
	//--------------------------------------------------------------------------
	always @ (*) begin
		if (Load) Next = 							In;
		else if (PGControlMask[Control]) case (Control)
			SPGCTL_Constant: Next =					Out;
			SPGCTL_LFSR: Next =						LFSRNext;
			SPGCTL_Toggle: Next =					~Out;
			SPGCTL_ShiftLeft: Next =				{Out[PWidth-SWidth-1:0], In[SWidth-1:0]};
			SPGCTL_ShiftRight: Next =				{In[SWidth-1:0], Out[PWidth-1:SWidth]};
			SPGCTL_RotateLeft: Next =				{Out[PWidth-SWidth-1:0], Out[PWidth-1:PWidth-SWidth]};
			SPGCTL_RotateRight: Next =				{Out[SWidth-1:0], Out[PWidth-1:SWidth]};
			SPGCTL_CountUp: Next =					Out + 1;
			SPGCTL_CountDown: Next =				Out - 1;
			default: Next =							{PWidth{1'bx}};
		endcase
		else Next =									{PWidth{1'bx}};
	end
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/PatternGen/Hardware/Simple/SimplePatternOp.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//				James Martin
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		SimplePatternOp
//	Desc:		A simple pattern operation module, basically an ALU, which
//				combines two patterns according to a control value.		
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//				James Martin
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	SimplePatternOp(Control, In0, In1, Out);
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[SPOCTL_CWidth-1:0] Control;
	input	[Width-1:0]		In0, In1;
	output reg [Width-1:0]	Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires and Regs
	//--------------------------------------------------------------------------
	wire	[Width-1:0]		AddOut, SubOut, XOrOut, AndOut, OrOut;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	AddOut =								In0 + In1;
	assign	SubOut = 								In0 - In1;
	assign	XOrOut =								In0 ^ In1;
	assign 	AndOut =								In0 & In1;
	assign	OrOut =									In0 | In1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Mux/ALU
	//--------------------------------------------------------------------------
	always @ (*) begin
		case (Control)
			SPOCTL_Add: Out = 						AddOut;
			SPOCTL_Subtract: Out = 					SubOut;
			SPOCTL_XOr: Out = 						XOrOut;
			SPOCTL_In0: Out = 						In0;
			SPOCTL_In1: Out =						In1;
			SPOCTL_And: Out = 						AndOut;
			SPOCTL_Or: Out = 						OrOut;
			default: Out = 							32'bx;
		endcase
	end
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------	

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Adapter/FIFOXilinxReadAdapter.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOXilinxReadAdapter
//	Desc:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOXilinxReadAdapter(Clock, Reset, XilinxDOut, XilinxEmpty, XilinxRead, OutData, OutValid, OutReady);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							DO_REG =				0,
							EN_SYN =				"FALSE",
							FIRST_WORD_FALL_THROUGH = "FALSE";
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	
	input	[Width-1:0]		XilinxDOut;
	input					XilinxEmpty;
	output					XilinxRead;
	
	output	[Width-1:0]		OutData;
	output					OutValid;
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Implementation
	//--------------------------------------------------------------------------
	generate if (FIRST_WORD_FALL_THROUGH == "TRUE") begin:FWFT
		//----------------------------------------------------------------------
		//	FWFT Conversion -> GateLib
		//----------------------------------------------------------------------
		if (EN_SYN != "FALSE") begin:FWFT_NONSYN
			initial $display("ERROR[%m @ %t]: The Xilinx FIFOs don't allow EN_SYN and FIRST_WORD_FALL_THROUGH!", $time);
		end else begin:FWFT_SYN
			assign	OutData =							XilinxDOut;
			assign	XilinxRead =						OutReady & ~XilinxEmpty & ~Reset;
			
			if (DO_REG) begin:VREG
				Register #(			.Width(				1))
						VReg(		.Clock(				Clock),
									.Reset(				Reset),
									.Set(				1'b0),
									.Enable(			1'b1),
									.In(				~XilinxEmpty),
									.Out(				OutValid));
			end else begin:VWIRE
				assign	Valid =							~XilinxEmpty & ~Reset;
			end
		end
		//----------------------------------------------------------------------
	end else begin:STANDARD
		if (((DO_REG == 0) && (EN_SYN == "TRUE")) | ((DO_REG == 1) & (EN_SYN == "FALSE"))) begin:STANDARDONE
			//------------------------------------------------------------------
			//	1 Cycle Standard -> GateLib
			//		Read -> (Data|Empty|Error) is 1 cycle
			//------------------------------------------------------------------
			assign	OutData =						XilinxDOut;
			assign	XilinxRead =					(~OutValid | OutReady) & ~XilinxEmpty & ~Reset;
			
			Register #(			.Width(				1))
					VReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			1'b1),
								.In(				~XilinxEmpty | (OutReady ? 1'b0 : OutValid)),
								.Out(				OutValid));
			//------------------------------------------------------------------
		end else if ((DO_REG == 1) && (EN_SYN == "TRUE")) begin:STANDARDTWO
			//------------------------------------------------------------------
			//	2 Cycle Standard -> GateLib
			//		Read -> (Data) is 2 cycles
			//		Read -> (Empty|Error) is 1 cycles
			//------------------------------------------------------------------
			wire	[Width-1:0]		RegisterData;
			wire					RegisterValid, RegisterLoad;
			wire	[1:0]			FIFOValid;
			
			assign	XilinxRead =					(~OutValid | OutReady) & ~XilinxEmpty & ~Reset;
			assign	OutValid =						(RegisterValid | FIFOValid[1]) & ~Reset;
			assign	RegisterLoad =					(&FIFOValid) & ~OutReady;
			assign	OutData =						RegisterValid ? RegisterData : XilinxDOut;
			
			Register #(			.Width(				1))
					F0Reg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			1'b1),
								.In(				XilinxRead),
								.Out(				FIFOValid[0]));
			Register #(			.Width(				1))
					F1Reg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				FIFOValid[0]),
								.Enable(			OutReady & ~RegisterValid),
								.In(				1'b0),
								.Out(				FIFOValid[1]));
								
			Register #(			.Width(				1))
					RVReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				RegisterLoad),
								.Enable(			OutReady),
								.In(				1'b0),
								.Out(				RegisterValid));
			Register #(			.Width(				Width))
					RDReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			RegisterLoad),
								.In(				XilinxDOut),
								.Out(				RegisterData));
			//------------------------------------------------------------------
		end else begin:INVALID
			//------------------------------------------------------------------
			//	 Invalid Config
			//------------------------------------------------------------------
			initial $display("ERROR[%m @ %t]: The Xilinx FIFOs must have either EN_SYN or DO_REG enabled!", $time);
			//------------------------------------------------------------------
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Buffer/FIFOLinear.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOLinear
//	Desc:		A class1 or class2 FIFO implementation which is Depth deep,
//				built out of individual registers.  Has Depth cycle forward
//				latency, Depth fragments of buffering, and zero
//				(class2) or Depth/Divisor (class1) cycle backwards latency
//				(RDL channel CBFC<Width, Depth, Depth, Depth/Divisor>)
//	Params:		Width:	The width of the data through this FIFO.
//				Depth:	The number of elements to build this FIFO from.
//				Divisor:The number of stages between class1 FIFO register
//						elements.  1 to make all elements class1, and Depth+1
//						to make them all class2.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOLinear(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,								// May actually be InReady, depending on the Divisor parameter
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutValid,
			OutReady
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							Depth =					1,
							Divisor =				1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clock & Reset Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;					// Transfered when Valid & Ready are both asserted
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the Class1 parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;				// Transfered when Valid & Ready are both asserted
	output 					OutValid;				// Must not be a function of OutReady
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	genvar					i;
	wire	[Width-1:0]		Data[Depth:0];
	wire					Valid[Depth:0];
	wire					Accept[Depth:0];
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	Data[0] =								InData;
	assign	Valid[0] =								InValid;
	assign	InAccept =								Accept[0];
	
	assign	OutData =								Data[Depth];
	assign	OutValid =								Valid[Depth];
	assign	Accept[Depth] =							OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	FIFO Stages
	//--------------------------------------------------------------------------
	generate for (i = 0; i < Depth; i = i + 1) begin:STAGE
		FIFORegister #(			.Width(				Width),
								.FWLatency(			1),
								.BWLatency(			((i + 1) % Divisor) == 0))	// Use i+1 to ensure that Divisor = Depth+1 means all elements are class2.
					Element(	.Clock(				Clock),
								.Reset(				Reset),
								.InData(			Data[i]),
								.InValid(			Valid[i]),
								.InAccept(			Accept[i]),
								.OutData(			Data[i+1]),
								.OutSend(			Valid[i+1]),
								.OutReady(			Accept[i+1]));
	end endgenerate
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Buffer/FIFOOptimized.v $
//	Version:	$Revision: 12025 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//==============================================================================
//	Section:	Defines and Constants
//==============================================================================
`timescale 1 ns/1 ps
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOOptimized
//	Desc:		A class1 or class2 FIFO using whatever implementation is most
//				efficient for the given parameters.
//	Params:		Width:	The width of the data through this FIFO.
//				FWLatency: Forward latency of data.
//				Buffering: The number of data items which can be buffered.
//				BWLatency: Backward latency of empties.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12025 $
//------------------------------------------------------------------------------
module	FIFOOptimized(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,								// May actually be InReady, depending on the BWLatency parameter
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutSend,								// May actually be OutValid, depending on the FWLatency parameter
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							FWLatency =				1,
							Buffering =				16,
							BWLatency =				1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;					// Transfered when Valid & Ready are both asserted
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the BWLatency parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;				// Transfered when Valid & Ready are both asserted
	output					OutSend;				// Must not be a function of OutReady, may actually be OutValid, depending on the FWLatency parameter
	input					OutReady;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	FIFO
	//--------------------------------------------------------------------------
	generate if ((Buffering == 0) && (FWLatency == 0) && (BWLatency == 0)) begin:IMPL_PASSTHROUGH
		FIFOPassthrough #(		.Width(				Width))
					FIFO(		.Clock(				Clock),
								.Reset(				Reset),
								.InData(			InData),
								.InValid(			InValid),
								.InAccept(			InAccept),
								.OutData(			OutData),
								.OutSend(			OutSend),
								.OutReady(			OutReady));
		initial begin
			if (FWLatency != 0) $display("ERROR[%m @ %t]: FIFOPassthrough has a fixed FWLatency of 0", $time);
			if (Buffering != 0) $display("ERROR[%m @ %t]: FIFOPassthrough has a fixed Buffering of 0", $time);
			if (BWLatency != 0) $display("ERROR[%m @ %t]: FIFOPassthrough has a fixed BWLatency of 0", $time);
		end
	end else if ((Buffering == 1) && ((FWLatency == 0) || (FWLatency == 1)) && ((BWLatency == 0) || (BWLatency == 1))) begin:IMPL_REGISTER
		FIFORegister #(			.Width(				Width),
								.FWLatency(			FWLatency),
								.BWLatency(			BWLatency))
					FIFO(		.Clock(				Clock),
								.Reset(				Reset),
								.InData(			InData),
								.InValid(			InValid),
								.InAccept(			InAccept),
								.OutData(			OutData),
								.OutSend(			OutSend),
								.OutReady(			OutReady));
		initial begin
			if (FWLatency > 1) $display("ERROR[%m @ %t]: FIFORegister has a fixed FWLatency of 1", $time);
			if (Buffering != 1) $display("ERROR[%m @ %t]: FIFORegister has a fixed Buffering of 1", $time);
			if (BWLatency > 1) $display("ERROR[%m @ %t]: FIFORegister has a maximum BWLatency of 1", $time);
		end
	end else if ((Buffering != 0) && (BWLatency != 0) && (Buffering == FWLatency) && ((Buffering / (`max(1, Buffering) / `max(1, BWLatency))) == BWLatency) && ((Buffering * (Width + 1)) <= ((2 * `log2(Buffering)) + ((Buffering * Width) / 32)))) begin:IMPL_LINEAR
		FIFOLinear	#(			.Width(				Width),
								.Depth(				Buffering),
								.Divisor(			Buffering / BWLatency))
					FIFO(		.Clock(				Clock),
								.Reset(				Reset),
								.InData(			InData),
								.InValid(			InValid),
								.InAccept(			InAccept),
								.OutData(			OutData),
								.OutValid(			OutSend),
								.OutReady(			OutReady));
		initial begin
			if (Buffering != FWLatency) $display("ERROR[%m @ %t]: FIFOLinear must have FWLatency == Buffering", $time);
			if ((Buffering / (Buffering / BWLatency)) != BWLatency) $display("ERROR[%m @ %t]: FIFOLinear must have a backwards latency which is an integer divisor of it's buffering", $time);
		end
	end else begin:IMPL_RAM
		FIFORAM		#(			.Width(				Width),
								.FWLatency(			FWLatency),
								.Buffering(			Buffering),
								.BWLatency(			BWLatency),
								.Asynchronous(		0))
					FIFO(		.Clock(				Clock),
								.Reset(				Reset),
								.InClock(			/* Unconnected */),
								.InReset(			/* Unconnected */),
								.InData(			InData),
								.InValid(			InValid),
								.InAccept(			InAccept),
								.InEmptyCount(		/* Unconnected */),
								.OutClock(			/* Unconnected */),
								.OutReset(			/* Unconnected */),
								.OutData(			OutData),
								.OutSend(			OutSend),
								.OutReady(			OutReady),
								.OutFullCount(		/* Unconnected */));
	end endgenerate
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Buffer/FIFOPassthrough.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOPassthrough
//	Desc:		A class2 module with FIFO interfaces, but no storage space.
//				Note that the interfaces are completely symmetrical, which is
//				why this module will work correctly.
//				Transfers occur on an interface when both the Accept & Send
//				signals are asserted on the same clock cycle, and neither signal
//				should affect the other through a non-registered path to avoid
//				combinational loops when modules are composed.  Of course the
//				composition of these interfaces may be limited by delays along
//				the control path.
//	Params:		Width:	The width of the data through this "FIFO".
//	Inputs:		InData:	The data input, data is transfered when InValid &
//						InReady are both asserted on the same clock cycle.
//				InValid:Indicates that InData contains valid data.  Neither the
//						data nor this signal may change after this signal is
//						asserted until InReady has been asserted.
//				OutReady:Indicates that the module connected to the output is
//						ready to accept more data.
//	Outputs:	InAccept:Indicates that this module is ready to accept new
//						input data.  Must not be a combinational function of
//						InValid to avoid combinational loops when modules using
//						this interface are composed.
//				OutData:Transfered when OutValid & OutReady are both asserted
//						on the same clock cycle.
//				OutSend:Indicates that the output of this module is valid.
//						Must not be a function of OutReady to avoid
//						combinational loops when modules using this interface
//						are composed.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOPassthrough(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutSend,
			OutReady
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clock & Reset Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;					// Transfered when Valid & Ready are both asserted
	input					InValid;
	output					InAccept;				// Must not be a function of InValid
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;				// Transfered when Valid & Ready are both asserted
	output					OutSend;				// Must not be a function of OutReady
	input					OutReady;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	InAccept =								OutReady;
	
	assign	OutData =								InData;
	assign	OutSend =								InValid;
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Buffer/FIFORAM.v $
//	Version:	$Revision: 12025 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFORAM
//	Desc:		A class1 or class2 FIFO implementation based on a circular
//				buffer stored in dual port RAM.  This module provides full
//				timing parameters (RDL channel CBFC<Width, FWLatency, Buffering,
//				BWLatency>).  It will be class1 iff FWLatency > 0 and
//				BWLatency > 0.
//	Params:		Width:	The width of the data through this FIFO.
//				FWLatency: Forward latency of data.
//				Buffering: The number of data items which can be buffered.
//				BWLatency: Backward latency of empties.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12025 $
//------------------------------------------------------------------------------
module	FIFORAM(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InClock,
			InReset,
			
			InData,
			InValid,
			InAccept,								// May actually be InReady, depending on the BWLatency parameter
			InEmptyCount,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutClock,
			OutReset,
			
			OutData,
			OutSend,								// May actually be OutValid, depending on the FWLatency parameter
			OutReady,
			OutFullCount
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							FWLatency =				1,
							Buffering =				16,
							BWLatency =				1,
							Asynchronous =			0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				AWidth =				`max(`log2(Buffering), 1),
							CWidth =				`log2(Buffering + 1);
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input					InClock, InReset;
	input	[Width-1:0]		InData;					// Transfered when Valid & Ready are both asserted
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the BWLatency parameter
	output	[CWidth-1:0]	InEmptyCount;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	input					OutClock, OutReset;
	output	[Width-1:0]		OutData;				// Transfered when Valid & Ready are both asserted
	output					OutSend;				// Must not be a function of OutReady, may actually be OutValid, depending on the FWLatency parameter
	input					OutReady;
	output	[CWidth-1:0]	OutFullCount;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					InWrite, OutRead, OutGate;
	wire	[AWidth-1:0]	InWriteAddress, OutReadAddress;
	
	wire	[Width-1:0]		WrittenData, ReadData;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	FIFO Controller
	//--------------------------------------------------------------------------
	FIFOControl		#(			.Asynchronous(		Asynchronous),
								.FWLatency(			FWLatency),
								.Buffering(			Buffering),
								.BWLatency(			BWLatency))
					Control(	.Clock(				Clock),
								.Reset(				Reset),
								
								.InClock(			InClock),
								.InReset(			InReset),
								.InValid(			InValid),
								.InAccept(			InAccept),
								.InWrite(			InWrite),
								.InGate(			/* Unconnected */),
								.InWriteAddress(	InWriteAddress),
								.InReadAddress(		/* Unconnected */),
								.InEmptyCount(		InEmptyCount),
								
								.OutClock(			OutClock),
								.OutReset(			OutReset),
								.OutSend(			OutSend),
								.OutReady(			OutReady),
								.OutRead(			OutRead),
								.OutGate(			OutGate),
								.OutReadAddress(	OutReadAddress),
								.OutWriteAddress(	/* Unconnected */),
								.OutFullCount(		OutFullCount));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Transparent Memory Mux
	//--------------------------------------------------------------------------
	generate if (FWLatency > 0) begin:FW_LARGE
		assign	OutData =							ReadData;
	end else begin:FW_ZERO
		assign	OutData =							OutGate ? ReadData : InData;
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	RAM
	//--------------------------------------------------------------------------
	RAM			 	#(			.DWidth(			Width),
								.AWidth(			AWidth),
								.RLatency(			0),
								.WLatency(			1),
								.NPorts(			2),
								.WriteMask(			2'b01))
					RAM(		.Clock(				Asynchronous ? {OutClock, InClock} : {2{Clock}}),
								.Reset(				Asynchronous ? {OutReset, InReset} : {2{Reset}}),
								.Enable(			{OutRead, InWrite}),
								.Write(				{1'b0, InWrite}),
								.Address(			{OutReadAddress, InWriteAddress}),
								.DIn(				{{Width{1'bx}}, InData}),
								.DOut(				{ReadData, WrittenData}));
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Buffer/FIFORectangle.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFORectangle
//	Desc:		A class 1 or 2 FIFO implementation which is HDepth*WDepth deep,
//				built out of individual registers arranged in a rectangle.  Has
//				HDepth+WDepth-1 cycle forward latency, HDepth*WDepth words
//				of buffering, and zero (class2) or HDepth+WDepth-1 (class1)
//				cycle backwards latency
//				(RDL channel CBFC<Width, HDepth+WDepth, HDepth*WDepth,
//				HDepth+WDepth>)
//	Params:		Width:	The width of the data through this FIFO.
//				HDepth:	The height/depth of this FIFO rectangle.  If
//						HDepth != WDepth, then HDepth should be smaller.
//				WDepth:	The width/depth of this FIFO rectangle.
//				Class1:	Should this implementation be class1?
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFORectangle(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,								// May actually be InReady, depending on the Divisor parameter
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutValid,
			OutReady
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							HDepth =				1,
							WDepth =				1,
							Class1 =				0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clock & Reset Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;					// Transfered when Valid & Ready are both asserted
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the Class1 parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;				// Transfered when Valid & Ready are both asserted
	output 					OutValid;				// Must not be a function of OutReady
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	genvar					i;
	wire	[WDepth-1:0]	TopSelect, TopNext;
	wire	[WDepth:0]		BotSelect, BotNext;
	
	wire	[Width-1:0]		TopData[WDepth-1:0];
	wire	[WDepth-1:0]	TopValid, TopAccept;
	wire	[Width-1:0]		ColData[WDepth-1:0];
	wire	[WDepth-1:0]	ColValid, ColAccept;
	wire	[Width-1:0]		BotData[WDepth-1:0];
	wire	[WDepth-1:0]	BotValid;
	wire	[WDepth:0]		BotAccept;
	
	wire	[WDepth-1:0]	TopTransfer, BotTransfer;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	TopAccept[WDepth-1] =					1'b0;
	assign	TopSelect[WDepth-1] =					1'b1;
	assign	TopNext[WDepth-1] =						1'b1;
	
	assign	BotSelect[0] =							1'b1;
	assign	BotSelect[WDepth] =						1'b0;
	assign	BotAccept[WDepth] =						OutReady;
	
	assign	OutData =								BotData[WDepth-1];
	assign	OutValid =								BotValid[WDepth-1];
	
	assign	TopTransfer[WDepth-1] =					TopValid[WDepth-1] & (TopSelect[WDepth-1] ? ColAccept[WDepth-1] : TopAccept[WDepth-1]);
	assign	BotTransfer[0] =						BotAccept[0] & (BotSelect[0] ? ColValid[0] : 1'b0);
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Select Shifters
	//--------------------------------------------------------------------------
	generate for (i = 0; i < WDepth-1; i = i + 1) begin:TOPSEL
		assign	TopTransfer[i] =					TopValid[i] & (TopSelect[i] ? ColAccept[i] : TopAccept[i]);
		assign	TopNext[i] =						~TopSelect[i] & (TopTransfer[i+1] ? TopNext[i+1] : TopSelect[i+1]);
		Register #(1) TopSel(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(TopTransfer[i]), .In(TopNext[i]), .Out(TopSelect[i]));
	end endgenerate
	generate for (i = 1; i < WDepth; i = i + 1) begin:BOTSEL
		assign	BotTransfer[i] =					BotAccept[i] & (BotSelect[i] ? ColValid[i] : BotValid[i-1]);
		assign	BotNext[i] =						BotSelect[i] ? 1'b0 : BotSelect[i-1];
		Register #(1) BotSel(.Clock(Clock), .Reset(1'b0), .Set(Reset), .Enable(BotTransfer[i]), .In(BotNext[i]), .Out(BotSelect[i]));
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Top Row
	//--------------------------------------------------------------------------
	FIFORegister 	#(			.Width(				Width),
								.FWLatency(			1),
								.BWLatency(			Class1))
					TopLeft(	.Clock(				Clock),
								.Reset(				Reset),
								.InData(			InData),
								.InValid(			InValid),
								.InAccept(			InAccept),
								.OutData(			TopData[0]),
								.OutSend(			TopValid[0]),
								.OutReady(			TopSelect[0] ? ColAccept[0] : TopAccept[0]));
								
	generate for (i = 1; i < WDepth; i = i + 1) begin:TOP
		FIFORegister #(			.Width(				Width),
								.FWLatency(			1),
								.BWLatency(			Class1))
					Top(		.Clock(				Clock),
								.Reset(				Reset),
								.InData(			TopData[i-1]),
								.InValid(			~TopSelect[i-1] & TopValid[i-1]),
								.InAccept(			TopAccept[i-1]),
								.OutData(			TopData[i]),
								.OutSend(			TopValid[i]),
								.OutReady(			TopSelect[i] ? ColAccept[i] : TopAccept[i]));
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	FIFO Columns
	//--------------------------------------------------------------------------
	generate for (i = 0; i < WDepth; i = i + 1) begin:COL
		FIFOLinear #(			.Width(				Width),
								.Depth(				HDepth-2),
								.Divisor(			Class1 ? 1 : (HDepth - 1)))
					Element(	.Clock(				Clock),
								.Reset(				Reset),
								.InData(			TopData[i]),
								.InValid(			TopSelect[i] & TopValid[i]),
								.InAccept(			ColAccept[i]),
								.OutData(			ColData[i]),
								.OutValid(			ColValid[i]),
								.OutReady(			BotSelect[i] & BotAccept[i]));
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Bottom Row
	//--------------------------------------------------------------------------
	FIFORegister 	#(			.Width(				Width),
								.FWLatency(			1),
								.BWLatency(			Class1))
					BotLeft(	.Clock(				Clock),
								.Reset(				Reset),
								.InData(			ColData[0]),
								.InValid(			ColValid[0]),
								.InAccept(			BotAccept[0]),
								.OutData(			BotData[0]),
								.OutSend(			BotValid[0]),
								.OutReady(			~BotSelect[1] & BotAccept[1]));
																
	generate for (i = 1; i < WDepth; i = i + 1) begin:BOT
		FIFORegister #(			.Width(				Width),
								.FWLatency(			1),
								.BWLatency(			Class1))
					Bot(		.Clock(				Clock),
								.Reset(				Reset),
								.InData(			BotSelect[i] ? ColData[i] : BotData[i-1]),
								.InValid(			BotSelect[i] ? ColValid[i] : BotValid[i-1]),
								.InAccept(			BotAccept[i]),
								.OutData(			BotData[i]),
								.OutSend(			BotValid[i]),
								.OutReady(			~BotSelect[i+1] & BotAccept[i+1]));
	end endgenerate
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Buffer/FIFORegister.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFORegister
//	Desc:		A class1 or class2 FIFO implementation which is one deep.  Has
//				zero/one cycle forward latency, one fragment of buffering, and
//				zero/one cycle backwards latency (RDL channel
//				CBFC<Width, FWLatency, 1, BWLatency>). This module will be
//				class1 only if FWLantency = BWLatency = 1.
//	Params:		Width:	The width of the data through this FIFO.
//				FWLatency: The forward latency through this FIFO.
//				BWLatency: The backwards latency through this FIFO.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFORegister(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,								// May actually be InReady, depending on the BWLatency parameter
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutSend,								// May actually be OutValid, depending on the FWLatency parameter
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							FWLatency =				1,
							BWLatency =				0,
							Initial =				{Width{1'bx}},
							InitialValid =			1'b0,
							ResetValue =			{Width{1'b0}},
							ResetValid =			1'b0,
							Conservative =			0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;					// Transfered when Valid & Ready are both asserted
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the BWLatency parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;				// Transfered when Valid & Ready are both asserted
	output					OutSend;				// Must not be a function of OutReady, may actually be OutValid, depending on the FWLatency parameter
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	wire	[Width-1:0]		Data;
	wire					Full;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	OutData =								(FWLatency || Full) ? Data : InData;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Value Register
	//--------------------------------------------------------------------------
	Register		#(			.Width(				Width),
								.Initial(			Initial),
								.ResetValue(		ResetValue))
					Value(		.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				1'b0),
								.Enable(			(Conservative ? InValid : 1'b1) & InAccept),
								.In(				InData),
								.Out(				Data));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Controller
	//--------------------------------------------------------------------------
	FIFORegControl	#(			.FWLatency(			FWLatency),
								.BWLatency(			BWLatency),
								.InitialValid(		InitialValid),
								.ResetValid(		ResetValid))
					Cntrl( 		.Clock(				Clock),
								.Reset(				Reset),
								.InValid(			InValid),
								.InAccept(			InAccept),
								.OutSend(			OutSend),
								.OutReady(			OutReady),
								.Full(				Full));
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	MODIFY THIS FILE AT YOUR OWN RISK!  IT HAS BEEN AUTOMATICALLY GENERATED!
//	File:		$URL$
//	Version:	$Revision$
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//	
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer. 
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOAsyncCoregen
//	Desc:		This module wraps a coregen async FIFO up and provides the
//				standard FIFO interface.  Obviously it is currently a very
//				simple wrapper, but this may not always be the case as the
//				abilities and options on coregen FIFOs change from time to time.
//				In general it should be expected that this is a class1 FIFO,
//				though that depends on the implementation from coregen.
//
//				To reuse this wrapper with a new FIFO, you will need to either
//				use the GateTools ANT tasks to automatically generate the new
//				wrapped FIFO or do the following:
//				1) Generate a FIFO using Xilinx Coregen.  Make sure you enable
//					"First Word Fall Through" (FWFT).  The FIFO interface can
//					vary from implementation to implementation, and these
//					options are necessary to avoid incompatabilities.
//				2) Change the module name to match the name of your new
//					FIFO.  Coregen doesn't believe in parameters.  Sorry.
//				3) You will also need to change the name of this module if you
//					use it multiple times in your project.
//				4) Put the coregen output files (xxx.v and either xxx.ngc or
//					xxx.edf) in the appropriate version control system
//					location.  You may wish to save other files, but these
//					two are the minimum.
//				5) Tell Xilinx ISE where to find the coregen output (set the
//					macro search path).
//
//	Params:		Width:	The width of the data through this "FIFO".
//	Inputs:		InData:	The data input, data is transfered when InValid &
//						InReady are both asserted on the same clock cycle.
//						Synchronous to InClock.
//				InValid:Indicates that InData contains valid data.  Neither the
//						data nor this signal may change after this signal is
//						asserted until InReady has been asserted.  Synchronous
//						to InClock.
//				OutReady:Indicates that the module connected to the output is
//						ready to accept more data.  Synchronous to OutClock.
//	Outputs:	InReady:Indicates that this module is ready to accept new
//						input data.  Must not be a combinational function of
//						InValid to avoid combinational loops when modules using
//						this interface are composed.  Synchronous to InClock.
//				OutData:Transfered when OutValid & OutReady are both asserted
//						on the same clock cycle.  Synchronous to OutClock.
//				OutValid:Indicates that the output of this module is valid.
//						Must not be a function of OutReady to avoid
//						combinational loops when modules using this interface
//						are composed.  Synchronous to OutClock.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOAsyncCoregen(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			InClock,
			OutClock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InValid,
			InReady,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutValid,
			OutReady
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clock & Reset Inputs
	//--------------------------------------------------------------------------
	input					InClock, OutClock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;					// Transfered when Valid & Ready are both asserted
	input					InValid;
	output					InReady;				// Should not be a function of InValid
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;				// Transfered when Valid & Ready are both asserted
	output					OutValid;
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					Full;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assign Statements
	//--------------------------------------------------------------------------
	assign	InReady =								~Full;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Coregen FIFO Instantiation
	//--------------------------------------------------------------------------
	MODULENAME		Core(		.din(				InData), 
								.rd_clk(			OutClock),
								.rd_en(				OutReady),
								.rst(				Reset),
								.wr_clk(			InClock),
								.wr_en(				InValid),
								.dout(				OutData), 
								.empty(				),
								.full(				Full),
								.valid(				OutValid));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	MODIFY THIS FILE AT YOUR OWN RISK!  IT HAS BEEN AUTOMATICALLY GENERATED!
//	File:		$URL$
//	Version:	$Revision$
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//	
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer. 
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOSyncCoregen
//	Desc:		This module wraps a coregen synchronous FIFO up and provides the
//				standard FIFO interface.  Obviously it is currently a very
//				simple wrapper, but this may not always be the case as the
//				abilities and options on coregen FIFOs change from time to time.
//				In general it should be expected that this is a class1 FIFO,
//				though that depends on the implementation from coregen.
//
//				To reuse this wrapper with a new FIFO, you will need to either
//				use the GateTools ANT tasks to automatically generate the new
//				wrapped FIFO or do the following:
//				1) Generate a FIFO using Xilinx Coregen.  Make sure you enable
//					"First Word Fall Through" (FWFT).  The FIFO interface can
//					vary from implementation to implementation, and these
//					options are necessary to avoid incompatabilities.
//				2) Change the module name to match the name of your new
//					FIFO.  Coregen doesn't believe in parameters.  Sorry.
//				3) You will also need to change the name of this module if you
//					use it multiple times in your project.
//				4) Put the coregen output files (xxx.v and either xxx.ngc or
//					xxx.edf) in the appropriate version control system
//					location.  You may wish to save other files, but these
//					two are the minimum.
//				5) Tell Xilinx ISE where to find the coregen output (set the
//					macro search path).
//
//	Params:		Width:	The width of the data through this "FIFO".
//	Inputs:		InData:	The data input, data is transfered when InValid &
//						InReady are both asserted on the same clock cycle.
//				InValid:Indicates that InData contains valid data.  Neither the
//						data nor this signal may change after this signal is
//						asserted until InReady has been asserted.
//				OutReady:Indicates that the module connected to the output is
//						ready to accept more data.
//	Outputs:	InReady:Indicates that this module is ready to accept new
//						input data.  Must not be a combinational function of
//						InValid to avoid combinational loops when modules using
//						this interface are composed.
//				OutData:Transfered when OutValid & OutReady are both asserted
//						on the same clock cycle.
//				OutValid:Indicates that the output of this module is valid.
//						Must not be a function of OutReady to avoid
//						combinational loops when modules using this interface
//						are composed.
//	Author:		<a href="http://www.gdgib.com//">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOSyncCoregen(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InValid,
			InReady,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutValid,
			OutReady
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clock & Reset Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;					// Transfered when Valid & Ready are both asserted
	input					InValid;
	output					InReady;				// Should not be a function of InValid
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;				// Transfered when Valid & Ready are both asserted
	output					OutValid;
	input					OutReady;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					Full;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assign Statements
	//--------------------------------------------------------------------------
	assign	InReady =								~Full;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Coregen FIFO Instantiation
	//--------------------------------------------------------------------------
	MODULENAME		Core(		.clk(				Clock),
								.din(				InData), 
								.rd_en(				OutReady),
								.rst(				Reset),
								.wr_en(				InValid),
								.dout(				OutData), 
								.empty(				),
								.full(				Full),
								.valid(				OutValid));
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gateforge.org:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Control/FIFOControl.v $
//	Version:	$Revision: 12534 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOControl
//	Desc:		A class1 or class2 FIFO controller implementation suitable for
//				use as either a pure semaphore or a FIFO controller.  This
//				module provides full timing parameters (RDL channel CBFC<Width,
//				FWLatency, Buffering, BWLatency>).  It will be class1 iff
//				FWLatency > 0 and BWLatency > 0.
//	Params:		Asynchronous: Use a completely asynchronous design
//				FWLatency: Forward latency of count values.
//				Buffering: The maximum value of the semaphore counter.
//				BWLatency: Backward latency of count values.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12534 $
//------------------------------------------------------------------------------
module	FIFOControl(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InClock,
			InReset,
			
			InValid,
			InAccept,								// May actually be InReady, depending on the BWLatency parameter
			
			InWrite,
			InGate,
			InWriteAddress,
			InReadAddress,
			InEmptyCount,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutClock,
			OutReset,
			
			OutSend,								// May actually be OutValid, depending on the FWLatency parameter
			OutReady,
			
			OutRead,
			OutGate,
			OutReadAddress,
			OutWriteAddress,
			OutFullCount
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Asynchronous =			0,
							FWLatency =				1,
							Buffering =				16,
							BWLatency =				1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				RawAWidth =				`log2(Buffering),
							AWidth =				`max(RawAWidth, 1),
							IOCWidth =				`log2(Buffering + 1),
							IOCDWidth =				RawAWidth + 1,
							Simple =				`popcount(Buffering) == 1,
							CWidth =				Simple ? IOCDWidth : IOCWidth,
							CTerminal =				(Simple ? (Buffering*2) : Buffering)-1;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input					InClock, InReset;
	
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the BWLatency parameter
	
	output					InWrite, InGate;
	output	[AWidth-1:0]	InWriteAddress, InReadAddress;
	output	[IOCWidth-1:0]	InEmptyCount;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	input					OutClock, OutReset;
	
	output					OutSend;				// Must not be a function of OutReady, may actually be OutValid, depending on the FWLatency parameter
	input					OutReady;
	
	output					OutRead, OutGate;
	output	[AWidth-1:0]	OutReadAddress, OutWriteAddress;
	output	[IOCWidth-1:0]	OutFullCount;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Checks
	//--------------------------------------------------------------------------
	`ifdef MODELSIM
		initial if (Asynchronous && (FWLatency < 2)) $display("ERROR[%m @ %t]: Forwards latency must be at least 2 for an asynchronous FIFO control!", $time);
		initial if (Asynchronous && (BWLatency < 2)) $display("ERROR[%m @ %t]: Backwards latency must be at least 2 for an asynchronous FIFO control!", $time);
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					IntIClock, IntOClock;
	wire					IntReset;
	
	wire					InRead, OutWrite;
	wire	[CWidth-1:0]	InReadCount, OutReadCount, InWriteCount, OutWriteCount;
	wire					InReadTerminal, OutReadTerminal, InWriteTerminal, OutWriteTerminal;
	
	wire	[CWidth-1:0]	InWriteGray, InReadGray, OutReadGray, OutWriteGray;
	wire	[IOCDWidth-1:0]	InCountDiff, OutCountDiff, CDBuffering;
	wire	[IOCDWidth-1:0]	CDInEmptyCount, CDOutFullCount;
	
	wire					InPrevWrite, OutPrevWrite;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assign Statements
	//--------------------------------------------------------------------------
	generate if (Asynchronous) begin:ASYNCSYS
		assign	IntIClock =							InClock;
		assign	IntOClock =							OutClock;
		assign	IntReset =							InReset | OutReset;
	end else begin:SYNCSYS
		assign	IntIClock =							Clock;
		assign	IntOClock =							Clock;
		assign	IntReset =							Reset;
	end endgenerate
	
	generate if (RawAWidth < 1) begin:ADDRESSONE
		assign	InWriteAddress =					1'b0;
		assign	InReadAddress =						1'b0;
		assign	OutReadAddress =					1'b0;
		assign	OutWriteAddress =					1'b0;
	end else begin:ADDRESSMANY
		assign	InWriteAddress =					InWriteCount[AWidth-1:0];
		assign	InReadAddress =						InReadCount[AWidth-1:0];
		assign	OutReadAddress =					OutReadCount[AWidth-1:0];
		assign	OutWriteAddress =					OutWriteCount[AWidth-1:0];
	end endgenerate
	
	assign	InWrite =								InValid & InAccept;
	assign	OutRead =								OutSend & OutReady;
	assign	InAccept =								~IntReset & (InGate | ((BWLatency == 0) & (OutReady & OutGate)));
	assign	OutSend =								~IntReset & (OutGate | ((FWLatency == 0) & (InValid & InGate)));
	
	generate if (Simple) begin:SIMPLEGATE
		if (Asynchronous) begin:ASYNCGATE
			if (RawAWidth < 1) begin:GRAYONE
				assign	InGate =					~InPrevWrite;
				assign	OutGate =					OutPrevWrite;
			end else begin:GRAYMANY
				assign	InGate =					({^InReadGray[AWidth:AWidth-1], InReadGray[AWidth-2:0]} != {^InWriteGray[AWidth:AWidth-1], InWriteGray[AWidth-2:0]}) | ~InPrevWrite;
				assign	OutGate =					({^OutReadGray[AWidth:AWidth-1], OutReadGray[AWidth-2:0]} != {^OutWriteGray[AWidth:AWidth-1], OutWriteGray[AWidth-2:0]}) | OutPrevWrite;
			end
			assign	InPrevWrite =					(InReadGray[RawAWidth] != InWriteGray[RawAWidth]);
			assign	OutPrevWrite =					(OutReadGray[RawAWidth] != OutWriteGray[RawAWidth]);
		end else begin:SYNCGATE
			assign	InGate =						(InReadAddress != InWriteAddress) | ~InPrevWrite;
			assign	OutGate =						(OutReadAddress != OutWriteAddress) | OutPrevWrite;
			assign	InPrevWrite =					(InReadCount[RawAWidth] != InWriteCount[RawAWidth]);
			assign	OutPrevWrite =					(OutReadCount[RawAWidth] != OutWriteCount[RawAWidth]);
		end
	end else begin:COMPLEXGATE
		assign	InGate =							(InReadCount != InWriteCount) | ~InPrevWrite;
		assign	OutGate =							(OutReadCount != OutWriteCount) | OutPrevWrite;
	end endgenerate
	
	assign	InCountDiff =							InReadAddress - InWriteAddress;
	assign	OutCountDiff =							OutWriteAddress - OutReadAddress;
	assign	CDBuffering =							Buffering;
	assign	CDInEmptyCount =						((InCountDiff[IOCDWidth-1] | ((~|InCountDiff[AWidth-1:0]) & ~InPrevWrite)) ? CDBuffering : {IOCDWidth{1'b0}}) + InCountDiff;
	assign	CDOutFullCount =						((OutCountDiff[IOCDWidth-1] | ((~|OutCountDiff[AWidth-1:0]) & OutPrevWrite)) ? CDBuffering : {IOCDWidth{1'b0}}) + OutCountDiff;
	assign	InEmptyCount =							CDInEmptyCount[IOCWidth-1:0];
	assign	OutFullCount =							CDOutFullCount[IOCWidth-1:0];
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Primary Counters
	//--------------------------------------------------------------------------
	Counter #(.Width(CWidth), .AsyncReset(Asynchronous)) PrimReadCnt(.Clock(IntOClock), .Reset(IntReset), .Set(1'b0), .Load(OutRead & OutReadTerminal), .Enable(OutRead), .In({CWidth{1'b0}}), .Count(OutReadCount));
	Counter #(.Width(CWidth), .AsyncReset(Asynchronous)) PrimWritCnt(.Clock(IntIClock), .Reset(IntReset), .Set(1'b0), .Load(InWrite & InWriteTerminal), .Enable(InWrite), .In({CWidth{1'b0}}), .Count(InWriteCount));
	CountCompare #(CWidth, CTerminal) PrimReadCmp(.Count(OutReadCount), .TerminalCount(OutReadTerminal));
	CountCompare #(CWidth, CTerminal) PrimWriteCmp(.Count(InWriteCount), .TerminalCount(InWriteTerminal));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	PrevWrite Registers
	//--------------------------------------------------------------------------
	generate if (!Simple) begin:PREVOPS
		Register #(.Width(1), .AsyncReset(Asynchronous)) InPWR (.Clock(IntIClock), .Reset(IntReset), .Set(1'b0), .Enable(InRead ^ InWrite), .In(InWrite), .Out(InPrevWrite));
		Register #(.Width(1), .AsyncReset(Asynchronous)) OutPWR(.Clock(IntOClock), .Reset(IntReset), .Set(1'b0), .Enable(OutRead ^ OutWrite), .In(OutWrite), .Out(OutPrevWrite));
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Backward Latency (Secondary Counter)
	//--------------------------------------------------------------------------
	generate if (Asynchronous) begin:BW_ASYNC
		wire	[CWidth-1:0] AsyncReadGray;
		Bin2Gray #(CWidth) BWB2G(.Bin(OutReadCount), .Gray(OutReadGray));
		ShiftRegister #(.PWidth(CWidth), .SWidth(CWidth), .AsyncReset(1)) ReadDelayO(.Clock(IntOClock), .Reset(IntReset), .Load(1'b0), .Enable(1'b1), .PIn({CWidth{1'bx}}), .SIn(OutReadGray), .POut(), .SOut(AsyncReadGray));
		ShiftRegister #(.PWidth(CWidth*(BWLatency-1)), .SWidth(CWidth), .AsyncReset(1)) ReadDelayI(.Clock(IntIClock), .Reset(IntReset), .Load(1'b0), .Enable(1'b1), .PIn({(CWidth*(BWLatency-1)){1'bx}}), .SIn(AsyncReadGray), .POut(), .SOut(InReadGray));
		Gray2Bin #(CWidth) BWG2B(.Gray(InReadGray), .Bin(InReadCount));
	end else begin:BW_SYNC
		if (BWLatency > 1) begin:BW_LARGE
			Counter #(CWidth) SecReadCnt(.Clock(Clock), .Reset(Reset | (InRead & InReadTerminal)), .Set(1'b0), .Load(1'b0), .Enable(InRead), .In({CWidth{1'bx}}), .Count(InReadCount));
			CountCompare #(CWidth, CTerminal) SecReadCmp(.Count(InReadCount), .TerminalCount(InReadTerminal));
			ShiftRegister #((BWLatency-1), 1) ReadDelay(.Clock(Clock), .Reset(Reset), .Load(1'b0), .Enable(1'b1), .PIn({(BWLatency-1){1'bx}}), .SIn(OutRead), .POut(), .SOut(InRead));
		end else begin:BW_ZERO
			assign	InReadCount =					OutReadCount;
			assign	InRead =						OutRead;
		end
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Forward Latency (Secondary Counter)
	//--------------------------------------------------------------------------
	generate if (Asynchronous) begin:FW_ASYNC
		wire	[CWidth-1:0] AsyncWriteGray;
		Bin2Gray #(CWidth) FWB2G(.Bin(InWriteCount), .Gray(InWriteGray));
		ShiftRegister #(.PWidth(CWidth), .SWidth(CWidth), .AsyncReset(1)) WriteDelayI(.Clock(IntIClock), .Reset(IntReset), .Load(1'b0), .Enable(1'b1), .PIn({CWidth{1'bx}}), .SIn(InWriteGray), .POut(), .SOut(AsyncWriteGray));
		ShiftRegister #(.PWidth(CWidth*(FWLatency-1)), .SWidth(CWidth), .AsyncReset(1)) WriteDelayO(.Clock(IntOClock), .Reset(IntReset), .Load(1'b0), .Enable(1'b1), .PIn({(CWidth*(FWLatency-1)){1'bx}}), .SIn(AsyncWriteGray), .POut(), .SOut(OutWriteGray));
		Gray2Bin #(CWidth) FWG2B(.Gray(OutWriteGray), .Bin(OutWriteCount));
	end else begin:FW_SYNC
		if (FWLatency > 1) begin:FW_LARGE
			Counter #(CWidth) SecWriteCnt(.Clock(Clock), .Reset(Reset | (OutWrite & OutWriteTerminal)), .Set(1'b0), .Load(1'b0), .Enable(OutWrite), .In({CWidth{1'bx}}), .Count(OutWriteCount));
			CountCompare #(CWidth, CTerminal) SecWriteCmp(.Count(OutWriteCount), .TerminalCount(OutWriteTerminal));
			ShiftRegister #((FWLatency-1), 1) WriteDelay(.Clock(Clock), .Reset(Reset), .Load(1'b0), .Enable(1'b1), .PIn({(FWLatency-1){1'bx}}), .SIn(InWrite), .POut(), .SOut(OutWrite));
		end else begin:FW_ZERO
			assign	OutWriteCount =					InWriteCount;
			assign	OutWrite =						InWrite;
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Control/FIFORegControl.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFORegControl
//	Desc:		The controller for a class1 or class2 FIFO implementation which
//				is one deep.  Has zero/one cycle forward latency, one fragment
//				of buffering, and zero/one cycle backwards latency (RDL channel
//				CBFC<Width, FWLatency, 1, BWLatency>). This module will be
//				class1 only if FWLantency = BWLatency = 1.
//	Params:		FWLatency: The forward latency through this FIFO.
//				BWLatency: The backwards latency through this FIFO.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFORegControl(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InValid,
			InAccept,								// May actually be InReady, depending on the BWLatency parameter
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutSend,								// May actually be OutValid, depending on the FWLatency parameter
			OutReady,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	State Output
			//------------------------------------------------------------------
			Full
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				FWLatency =				1,
							BWLatency =				0,
							InitialValid =			0,
							ResetValid =			0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the BWLatency parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output					OutSend;				// Must not be a function of OutReady, may actually be OutValid, depending on the FWLatency parameter
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	State Outputs
	//--------------------------------------------------------------------------
	output					Full;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	InAccept =								~Full | (BWLatency ? 1'b0 : OutReady);
	assign	OutSend =								Full | (FWLatency ? 1'b0 : InValid);
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Full Register
	//--------------------------------------------------------------------------
	Register		#(			.Width(				1),
								.Initial(			InitialValid),
								.ResetValue(		ResetValid))
					FullReg(	.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			1'b1),
								.In(				Full ? (~OutReady | (BWLatency ? 1'b0 : InValid)) : (InValid & (FWLatency ? 1'b1 : ~OutReady))),
								.Out(				Full));
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Debug/FIFOUserDisplay.v $
//	Version:	$Revision: 12031 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Section:	Includes
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//	Module:		FIFOUserDisplay
//	Desc:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12031 $
//------------------------------------------------------------------------------
module	FIFOUserDisplay(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Passthrough
			//------------------------------------------------------------------
			InData,
			InValid,
			InReady,
			
			OutData,
			OutValid,
			OutReady,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	User Display
			//------------------------------------------------------------------
			Button,
			Display,
			Valid
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				ClockFreq = 			100000000,
							DataWidth =				8,
							DisplayWidth =			8,
							Parse =					1,
							Buffering =				64;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input 					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Passthrough
	//--------------------------------------------------------------------------
	input	[DataWidth-1:0]	InData;
	input					InValid;
	output					InReady;
	
	output	[DataWidth-1:0]	OutData;
	output 					OutValid;
	input 					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	User Display
	//--------------------------------------------------------------------------
	input					Button;
	output	[DisplayWidth-1:0] Display;
	output					Valid;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	wire					Next;
	
	wire	[DataWidth-1:0]	BufInData;
	wire					BufInValid;
	wire					BufInReady;
	
	wire	[DataWidth-1:0]	BufOutData;
	wire 					BufOutValid;
	wire 					BufOutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Button Parsing
	//--------------------------------------------------------------------------
	generate if (Parse) begin:PARSE
		ButtonParse	#(			.Width(				1),
								.DebWidth(			`log2(ClockFreq / 100)), // Use a 10ms button parser (roughly)
								.EdgeOutWidth(		1))
					InBP(		.Clock(				Clock),
								.Reset(				Reset),
								.Enable(			1'b1),
								.In(				Button),
								.Out(				Next));
	end else begin:NOPARSE
		assign Next =								Button;
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Buffer
	//--------------------------------------------------------------------------
	FIFORAM			#(			.Buffering(			Buffering),
								.Width(				DataWidth),
								.Asynchronous(		0))
					FIFO(		.Clock(				Clock),
								.Reset(				Reset),
								.InClock(			/* Unconnected */),
								.InReset(			/* Unconnected */),
								.InData(			BufInData),
								.InValid(			BufInValid),
								.InAccept(			BufInReady),
								.InEmptyCount(		/* Unconnected */),
								.OutClock(			/* Unconnected */),
								.OutReset(			/* Unconnected */),
								.OutData(			BufOutData),
								.OutSend(			BufOutValid),
								.OutReady(			BufOutReady),
								.OutFullCount(		/* Unconnected */));
	
	FIFORendezvous	#(			.NInputs(			1),
								.NOutputs(			2))
					Rendezvous(	.Clock(				Clock),
								.Reset(				Reset),
								.InValid(			InValid),
								.InAccept(			InReady),
								.OutSend(			{OutValid, BufInValid}),
								.OutReady(			{OutReady, BufInReady}));
	
	assign	BufInData =								InData;
	assign	OutData =								InData;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Shifter
	//--------------------------------------------------------------------------
	FIFOShiftRound	#(			.IWidth(			DataWidth),
								.OWidth(			DisplayWidth),
								.Reverse(			0),
								.Bottom(			0),
								.Class1(			0),
								.Variable(			0),
								.Register(			1))
					OutShft(	.Clock(				Clock),
								.Reset(				Reset),
								.RepeatLimit(		/* Unconnected */),
								.RepeatCount(		/* Unconnected */),
								.RepeatMin(			/* Unconnected */),
								.RepeatPreMax(		/* Unconnected */),
								.RepeatMax(			/* Unconnected */),
								.InData(			BufOutData),
								.InValid(			BufOutValid),
								.InAccept(			BufOutReady),
								.OutData(			Display),
								.OutValid(			Valid),
								.OutReady(			Next));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Library/FIFOArbiter.v $
//	Version:	$Revision: 11965 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOArbiter
//	Desc:		This module provides arbitration with a flexible arbitration
//				policy and Valid/Ready control signals.  The ports are named as
//				if this module exists at the input to some single ported
//				structure to which access is being multiplexed.  However, by
//				reversing the connections of Valid and Ready, this module
//				can be used to select which of multiple outputs from a single
//				structure should be used, because Valid/Ready is a symmetric
//				interface.
//
//				This module implements a Class2 FIFO interface.  Please note
//				that the Arbiter module in GateCore provides a more standard
//				request/grant arbiter interface.
//				
//	Params:		NPorts:	The number of ports on this arbiter.
//				Policy:	0 - Round Robin
//						1 - Priority Logic
//						2 - Select Any (Don't Care, fast implementation)
//						3 - Cyclic (wait for the next port, no actual arbitration)
//	Inputs:		ManyValid:Indicates the validity of the many ports.  Lower bit
//						indices take priority over higher ones for priority
//						arbitration policy.
//				OneReady:Indicates that the shared port has accepted data.
//	Outputs:	ManyReady:Indicates the ready status for the many ports.  A
//						simple combination of ManySelect and OneReady.
//				ManySelect:A one-hot indication of the port which won the
//						arbitration on this cycle.
//				Locked:	Indicates that the arbiter is locked waiting for
//						a OneReady pulse
//				OneValid:Indicates that the arbitration has been decided and
//						the winner has valid data.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11965 $
//------------------------------------------------------------------------------
module	FIFOArbiter(Clock, Reset, ManyValid, ManyReady, ManySelect, Locked, OneValid, OneReady);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				NPorts =		 		2,
							Policy =				0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[NPorts-1:0]	ManyValid;
	output	[NPorts-1:0]	ManyReady, ManySelect;
	output					Locked;
	output					OneValid;
	input					OneReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[NPorts-1:0]	NextSelect, PrevSelect;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	OneValid =								~Locked ? (|ManyValid) : (|(ManyValid & PrevSelect));
	assign	ManySelect =							~Locked ? NextSelect : PrevSelect;
	assign	ManyReady =								{NPorts{OneReady}} & ManySelect;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Variable Policy Priority Selector
	//--------------------------------------------------------------------------
	generate if (Policy == 0) begin:RR
		RoundRobinSelect #(		.Width(				NPorts))
					Select(		.Valid(				ManyValid),
								.PrevSelect(		PrevSelect),
								.Select(			NextSelect));
	end else if ((Policy == 1) || (Policy == 2)) begin:PRI
		PrioritySelect #(		.Width(				NPorts))
					Select(		.Valid(				ManyValid),
								.Select(			NextSelect));
	end else if (Policy == 3) begin:CYC
		CyclicSelect #(			.Width(				NPorts))
					Select(		.PrevSelect(		PrevSelect),
								.Select(			NextSelect));
	end else begin
		initial begin
			$display("ERROR[%m @ %t]: Unknown arbitration policy!", $time);
			$stop;
		end
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Lock State Register 
	//--------------------------------------------------------------------------
	Register		#(			.Width(				1),
								.Initial(			1'bx),
								.AsyncReset(		0),
								.AsyncSet(			0),
								.ResetValue(		1'b0),
								.SetValue(			1'b1))
					LSR(		.Clock(				Clock),
								.Reset(				Reset | (OneReady & OneValid)),
								.Set(				OneValid),
								.Enable(			1'b0),
								.In(				1'bx),
								.Out(				Locked));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Previous Select Logic
	//--------------------------------------------------------------------------
	generate if (NPorts > 1) begin:PREVREG
		Register	#(			.Width(				NPorts),
								.Initial(			{NPorts{1'bx}}),
								.AsyncReset(		0),
								.AsyncSet(			0),
								.ResetValue(		{NPorts{1'b0}}),
								.SetValue(			{NPorts{1'b1}}))
					PrevReg(	.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				1'b0),
								.Enable(			Reset | ((OneReady | ~Locked) & OneValid)),
								.In(				Reset ? {1'b1, {NPorts-1{1'b0}}} : ManySelect),
								.Out(				PrevSelect));
	end else begin:PREVWIRE
		assign	PrevSelect =						1'b1;
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Library/FIFODownsample.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2007-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Copyright (c) 2007-2010, Regents of the University of California
//	All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//	
//		 - Redistributions of source code must retain the above copyright notice,
//			 this list of conditions and the following disclaimer. 
//		 - Redistributions in binary form must reproduce the above copyright
//			 notice, this list of conditions and the following disclaimer
//			 in the documentation and/or other materials provided with the
//			 distribution. 
//		 - Neither the name of the University of California, Berkeley nor the
//			 names of its contributors may be used to endorse or promote
//			 products derived from this software without specific prior
//			 written permission. 
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRA	NTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFODownsample
//	Desc:		A simple module designed to throw out some fraction of the input
//				stream with either a fixed or variable number of input words per
//				output word.
//	Params:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFODownsample(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Downsampling Control
			//------------------------------------------------------------------
			DepthVariable,
			DepthMax,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutSend,
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Per-Instance Constants
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							DepthFixed =			4,				// The downsampling rate minux one, so 0 means output is the same as output
							Variable =				0,				// Enable support for variable rate downsampling using DepthVariable instead of DepthFixed
							First =					1;				// Take the first word on input from a depth (1) versus the last (0)
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Fixed Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				DCXWidth =				`max(`log2(DepthFixed + 1), 1);
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Downsampling Control
	//--------------------------------------------------------------------------
	input	[DCXWidth-1:0]	DepthVariable;
	output					DepthMax;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;					// Transfered when Valid & Ready are both asserted
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the Class1 parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;				// Transfered when Valid & Ready are both asserted
	output					OutSend;				// Must not be a function of OutReady
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[DCXWidth-1:0]	DepthCount;
	wire					DepthTrigger;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	DepthTrigger =							(First ? ~|DepthCount : DepthMax);
	
	assign	OutData =								InData;
	assign	OutSend =								InValid & DepthTrigger;
	assign	InAccept =								OutReady | ~DepthTrigger;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Depth Counter
	//--------------------------------------------------------------------------
	generate if (DepthFixed > 0) begin:DPCNT
		Counter		#(			.Width(				DCXWidth))			
					DpCnt(		.Clock(				Clock),
								.Reset(				Reset | (InValid & InAccept & DepthMax)),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			InValid & InAccept),
								.In(				{DCXWidth{1'bx}}),
								.Count(				DepthCount));
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Depth Comparator
	//--------------------------------------------------------------------------
	generate if (Variable) begin:VARIABLE
		assign	DepthMax =							DepthCount == DepthVariable;
	end else begin:FIXED
		CountCompare #(			.Width(				DCXWidth),
								.Compare(			DepthFixed))
					DpCmp(		.Count(				DepthCount),
								.TerminalCount(		DepthMax));
	end endgenerate
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Library/FIFOFillCounter.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOFillCounter
//	Desc:		This module has both an input and an output side FIFO interface,
//				and can be used to count the amount of data which has entered
//				but not left.  In addition to being useful in testing new
//				buffering FIFOs, this module can be used to build credit based
//				flow control schemes of all kinds.  It could also be used for
//				performance measurement.
//				
//	Params:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOFillCounter(Clock, Reset, Read, Write, Count, Max, Zero);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				FWLatency =				1,
							Buffering =				16,
							BWLatency =				1,
							Space =					0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				CWidth =				`log2(Buffering + 1);
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	input					Read, Write;
	output	[CWidth-1:0]	Count;
	output					Max, Zero;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[CWidth-1:0]	CBuffering;
	
	wire					ReadDelayed, WriteDelayed;
	
	wire					Up, Down;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	Zero =									~|Count;
	
	assign	CBuffering =							Buffering;
	
	assign	Up =									(Space ? ReadDelayed : WriteDelayed);
	assign	Down =									(Space ? WriteDelayed : ReadDelayed);
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	FW Latency Shifter
	//--------------------------------------------------------------------------
	generate if (FWLatency > 1) begin:FW_POS
		ShiftRegister #((FWLatency-1), 1) WriteDelay(.Clock(Clock), .Reset(Reset), .Load(1'b0), .Enable(1'b1), .PIn({(FWLatency-1){1'bx}}), .SIn(Write), .POut(), .SOut(WriteDelayed));
	end else if ((FWLatency == 1) || (FWLatency == 0)) begin:FW_ZERO
		assign	WriteDelayed =						Write;
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	BW Latency Shifter
	//--------------------------------------------------------------------------
	generate if (BWLatency > 1) begin:BW_POS
		ShiftRegister #((BWLatency-1), 1) ReadDelay(.Clock(Clock), .Reset(Reset), .Load(1'b0), .Enable(1'b1), .PIn({(BWLatency-1){1'bx}}), .SIn(Read), .POut(), .SOut(ReadDelayed));
	end else if ((BWLatency == 1) || (BWLatency == 0)) begin:BW_ZERO
		assign	ReadDelayed =						Read;
	end endgenerate
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Counter
	//--------------------------------------------------------------------------
	UDCounter		#(			.Width(				CWidth),
								.Limited(			1'b0))
					Cnt(		.Clock(				Clock),
								.Reset(				Reset & (Space ? 1'b0 : 1'b1)),
								.Set(				1'b0),
								.Load(				Reset & (Space ? 1'b1 : 1'b0)),
								.Up(				Up & (Down | ~Max)),
								.Down(				Down & (Up | ~Zero)),
								.In(				CBuffering),
								.Count(				Count));
	CountCompare	#(			.Width( 			CWidth),
								.Compare(			Buffering))
					Cmp(		.Count(				Count),
								.TerminalCount(		Max));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Library/FIFOInitial.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOInitial
//	Desc:		Many pieces of hardware require complex, but fixed,
//				initialization sequences and this module exists to fill that
//				need.  On both configuration and reset this module will present
//				at it's FIFO output a stream of values determined by the
//				instantiation parameters.  This output stream will be generated
//				exactly once per reset.
//				
//	Params:		Width:	The width of the data output.
//				Depth:	The number of words in the output sequence.
//				Value:	A concatenation of the words in the output sequence.
//						The most significant word will appear first.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOInitial(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			Done,
			OutData,
			OutValid,
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					8,
							Depth =					2,
							Value =					{Width*Depth{1'b0}};
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				ShiftBased =			1;	// Other styles do not work in most synthesis tools yet
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output					Done;
	output	[Width-1:0]		OutData;
	output					OutValid;
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Multiple Implementations
	//--------------------------------------------------------------------------
	generate if (Depth < 2) begin:SIMPLE
		//----------------------------------------------------------------------
		//	Assigns
		//----------------------------------------------------------------------
		assign	OutData =							Value;
		assign	OutValid =							~Done;
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	State Register
		//----------------------------------------------------------------------
		Register	#(			.Width(				1),
								.Initial(			1'b0))
					SprReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				OutValid & OutReady),
								.Enable(			1'b0),
								.In(				1'bx),
								.Out(				Done));
		//----------------------------------------------------------------------
	end else if (ShiftBased) begin:SHIFT
		//----------------------------------------------------------------------
		//	Wires
		//----------------------------------------------------------------------
		wire				InternalValid, LastValid, SuppressValid;
		wire				Skip;
		wire				OutTransfer;
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Assigns
		//----------------------------------------------------------------------
		assign	Done =								~(InternalValid | SuppressValid);
		assign	OutValid =							InternalValid & ~SuppressValid;
		assign	OutTransfer =						OutReady & OutValid;
		assign	Skip =								Reset ? ~InternalValid : SuppressValid;
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	State Register
		//----------------------------------------------------------------------
		Register	#(			.Width(				1),
								.Initial(			1'b0))
					SprReg(		.Clock(				Clock),
								.Reset(				~Reset & ~InternalValid),
								.Set(				Reset & InternalValid & LastValid),
								.Enable(			1'b0),
								.In(				1'bx),
								.Out(				SuppressValid));
		Register	#(			.Width(				1),
								.Initial(			1'b0))
					LstValReg(	.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				1'b0),
								.Enable(			1'b1),
								.In(				InternalValid),
								.Out(				LastValid));
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Core Shift Registers
		//----------------------------------------------------------------------
		ShiftRegister #(		.PWidth(			Width*Depth),
								.SWidth(			Width),
								.Reverse(			0),
								.Initial(			Value),
								.AsyncReset(		0),
								.ResetValue(		{Width*Depth{1'bx}}))
					DataShft(	.Clock(				Clock),
								.Reset(				1'b0),
								.Load(				1'b0),
								.Enable(			(Skip & InternalValid) | OutTransfer),
								.PIn(				{Width*Depth{1'bx}}),
								.SIn(				OutData),
								.POut(				/* Unconnected */),
								.SOut(				OutData));
		ShiftRegister #(		.PWidth(			Depth+1),
								.SWidth(			1),
								.Reverse(			0),
								.Initial(			{{Depth{1'b1}}, 1'b0}),
								.AsyncReset(		0),
								.ResetValue(		{Depth{1'bx}}))
					VldShft(	.Clock(				Clock),
								.Reset(				1'b0),
								.Load(				1'b0),
								.Enable(			Skip | OutTransfer),
								.PIn(				{Depth+1{1'bx}}),
								.SIn(				InternalValid),
								.POut(				/* Unconnected */),
								.SOut(				InternalValid));
		//----------------------------------------------------------------------
	end else begin:RAM
		//----------------------------------------------------------------------
		//	Constants
		//----------------------------------------------------------------------
		localparam			A0Width =				`log2(Depth),
							A1Width =				`log2(Depth+1);
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Wires
		//----------------------------------------------------------------------
		wire	[A1Width-1:0] Address;
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Assigns
		//----------------------------------------------------------------------
		assign	OutValid =							~Done;
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Counter
		//----------------------------------------------------------------------
		Counter		#(			.Width(				A1Width),
								.Initial(			{A1Width{1'b0}}))
					Cnt(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			OutReady & OutValid),
								.In(				{A1Width{1'bx}}),
								.Count(				Address));
		CountCompare #(			.Width(				A1Width),
								.Compare(			Depth))
					Cmp(		.Count(				Address),
								.TerminalCount(		Done));
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Memory
		//----------------------------------------------------------------------
		RAM			#(			.DWidth(			Width),
								.AWidth(			A0Width),
								.RLatency(			0),
								.WLatency(			1),
								.NPorts(			1),
								.WriteMask(			1'b0),
								.EnableInitial(		1),
								.Initial(			Value))
					RAM(		.Clock(				Clock),
								.Reset(				1'b0),
								.Enable(			1'b1),
								.Write(				1'b0),
								.Address(			Address[A0Width-1:0]),
								.DIn(				{Width{1'bx}}),
								.DOut(				OutData));
		//----------------------------------------------------------------------
	end endgenerate
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Library/FIFORendezvous.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2007-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Copyright (c) 2007-2010, Regents of the University of California
//	All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//	
//		 - Redistributions of source code must retain the above copyright notice,
//			 this list of conditions and the following disclaimer. 
//		 - Redistributions in binary form must reproduce the above copyright
//			 notice, this list of conditions and the following disclaimer
//			 in the documentation and/or other materials provided with the
//			 distribution. 
//		 - Neither the name of the University of California, Berkeley nor the
//			 names of its contributors may be used to endorse or promote
//			 products derived from this software without specific prior
//			 written permission. 
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRA	NTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFORendezvous
//	Desc:		A rendezvous or barrier for any number of FIFO interfaces, which
//				are packed onto vector I/O ports.  Note that this module does
//				not touch the data, instead making the assumption that an
//				external datapath will exist, thereby avoiding problems with
//				data mismatches between ports.
//	Params:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFORendezvous(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interfaces
			//------------------------------------------------------------------
			InValid,
			InAccept,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Output Interfaces
			//------------------------------------------------------------------
			OutSend,
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Per-Instance Constants
	//--------------------------------------------------------------------------
	parameter				NInputs =				4,
							NOutputs =				4,
							InStabilize =			{NInputs{1'b0}},	// Optionally stabilize the various FIFOs
							OutStabilize =			{NOutputs{1'b0}};
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				Width =					`max(NInputs, NOutputs);
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interfaces
	//--------------------------------------------------------------------------
	input	[NInputs-1:0]	InValid;
	output	[NInputs-1:0]	InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the Class1 parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interfaces
	//--------------------------------------------------------------------------
	output	[NOutputs-1:0]	OutSend;				// Must not be a function of OutReady
	input	[NOutputs-1:0]	OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	genvar					i, j;
	wire	[NInputs-1:0]	InValidInternal, InFull, InValidMasked[0:NInputs-1];
	wire	[NOutputs-1:0]	OutReadyInternal, OutFull, OutReadyMasked[0:NOutputs-1];
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Side
	//--------------------------------------------------------------------------
	generate for (i = 0; i < NInputs; i = i + 1) begin:INREGCONTROL
		assign	InValidMasked[i] =					InValidInternal | (1 << i);
		assign	InAccept[i] =						&OutReadyInternal & (&InValidMasked[i]);
		
		if (InStabilize[i]) begin:INUNSTABLE
			FIFORegControl #(	.FWLatency(			0),
								.BWLatency(			0))
					IRC(		.Clock(				Clock),
								.Reset(				Reset),
								.InValid(			InValid[i] & ~InFull[i]),
								.InAccept(			),
								.OutSend(			InValidInternal[i]),
								.OutReady(			InAccept[i]),
								.Full(				InFull[i]));
		end else begin:INSTABLE
			assign	InValidInternal[i] =			InValid[i];
		end
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Side
	//--------------------------------------------------------------------------
	generate for (j = 0; j < NOutputs; j = j + 1) begin:OUTREGCONTROL
		assign	OutReadyMasked[j] =					OutReadyInternal | (1 << j);
		assign	OutSend[j] =						&InValidInternal & (&OutReadyMasked[j]);
		
		if (OutStabilize[j]) begin:OUTUNSTABLE
			FIFORegControl #(	.FWLatency(			0),
								.BWLatency(			0))
					ORC(		.Clock(				Clock),
								.Reset(				Reset),
								.InValid(			OutSend[j]),
								.InAccept(			OutReadyInternal[j]),
								.OutSend(			),
								.OutReady(			OutReady[j] & OutFull[j]),
								.Full(				OutFull[j]));
		end else begin:OUTSTABLE
			assign	OutReadyInternal[j] =			OutReady[j];
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Library/FIFOSemaphore.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOSemaphore
//	Desc:		There are many situations where a handshake or credit flow
//				scheme is required, but not the accompanying datapath.  This
//				module provides exactly that, including the ability to be used
//				in a synchronous or asynchronous environment.
//				
//	Params:		Asynchronous: Use a completely asynchronous design
//				Buffering: The maximum value of the semaphore counter.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOSemaphore(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InClock,
			InReset,
			InValid,
			InReady,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutClock,
			OutReset,
			OutValid,
			OutReady
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Asynchronous =			0,
							Buffering =				16;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clock & Reset Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input					InClock, InReset;
	input					InValid;
	output					InReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	input					OutClock, OutReset;
	output					OutValid;
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	FIFO Controller
	//--------------------------------------------------------------------------
	FIFOControl		#(			.Asynchronous(		Asynchronous),
								.FWLatency(			Asynchronous ? 2 : 1),
								.Buffering(			Buffering),
								.BWLatency(			Asynchronous ? 2 : 1))
					Control(	.Clock(				Clock),
								.Reset(				Reset),
								
								.InClock(			InClock),
								.InReset(			InReset),
								.InValid(			InValid),
								.InAccept(			InReady),
								.InWrite(			),
								.InGate(			),
								.InWriteAddress(	),
								.InReadAddress(		),
								.InEmptyCount(		),
								
								.OutClock(			OutClock),
								.OutReset(			OutReset),
								.OutSend(			OutValid),
								.OutReady(			OutReady),
								.OutRead(			),
								.OutGate(			),
								.OutReadAddress(	),
								.OutWriteAddress(	),
								.OutFullCount(		));
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Library/FIFOTransferCounter.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOTransferCounter
//	Desc:		A simple module to count FIFO transfers, and produce start and
//				end signals which delimit a packet or burst.  Can handle
//				zero or one based length counts, and fixed or variable length
//				packets/bursts.
//				
//				Note that in variable length mode the Length input is expected
//				to be valid on the first (Start) word, and is ignored on all
//				other words.
//				
//	Params:		NWords:		The (maximum) number of words in a packet/burst.
//				Variable:	If 0, then NWords is the fixed number of words, if
//							1 then the Length input is used.
//				Total:		If 1 then the length/nwords is interpreted as the
//							total length, if 0 length/nwords is the number of
//							words after the first.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOTransferCounter(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input
			//------------------------------------------------------------------
			Length,
			Valid,
			Ready,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output
			//------------------------------------------------------------------
			Start,
			End
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Per-Instance Parameters
	//--------------------------------------------------------------------------
	parameter				NWords =				1,
							Variable =				0,
							Total =					0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Per-Instance Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				Width =					`log2(NWords),
	`else
	localparam				Width =					NWords-1,
	`endif
							Offset =				Total ? 2 : 1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input
	//--------------------------------------------------------------------------
	input	[Width-1:0]		Length;
	input					Valid, Ready;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output
	//--------------------------------------------------------------------------
	output					Start, End;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					Transfer;
	wire	[Width-1:0]		OffsetLength, Count;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	Transfer =								Valid & Ready;
	assign	OffsetLength =							(Variable ? Length : NWords) - Offset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Implementation Selection
	//--------------------------------------------------------------------------
	generate if (NWords < Offset) begin:SMALL
		assign	Start =								1'b1;
		assign	End =								1'b1;
	end else if (Variable) begin:VARIABLE
		//----------------------------------------------------------------------
		//	Wires
		//----------------------------------------------------------------------
		wire				StartEnd;
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Assigns
		//----------------------------------------------------------------------
		assign	StartEnd =							Start & (~|Length[Width-1:(Total ? 1 : 0)]);
		assign	End =								(~|Count) | StartEnd;
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Word Counter
		//----------------------------------------------------------------------
		UDCounter	#(			.Width( 			Width))
					WCnt(		.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				Reset | (Transfer & End)),
								.Load(				Transfer & Start),
								.Up(				1'b0),
								.Down(				Transfer),
								.In(				OffsetLength),
								.Count(				Count));
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Start Register
		//----------------------------------------------------------------------
		Register	#(			.Width(				1))
					StartReg(	.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				Reset),
								.Enable(			Transfer),
								.In(				End),
								.Out(				Start));
		//----------------------------------------------------------------------
	end else begin:FIXED
		//----------------------------------------------------------------------
		//	Word Counter
		//----------------------------------------------------------------------
		Counter		#(			.Width( 			Width))
					WCnt(		.Clock(				Clock),
								.Reset(				Reset | (Transfer & End)),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			Transfer),
								.In(				{Width{1'bx}}),
								.Count(				Count));
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	End Count Compare
		//----------------------------------------------------------------------
		CountCompare #(			.Width(				Width),
								.Compare(			NWords - Offset + 1))
					WCmp(		.Count(				Count),
								.TerminalCount(		End));
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Start Register
		//----------------------------------------------------------------------
		Register	#(			.Width(				1))
					StartReg(	.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				Reset),
								.Enable(			Transfer),
								.In(				End),
								.Out(				Start));
		//----------------------------------------------------------------------
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Library/FIFOUpsample.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2007-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Copyright (c) 2007-2010, Regents of the University of California
//	All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//	
//		 - Redistributions of source code must retain the above copyright notice,
//			 this list of conditions and the following disclaimer. 
//		 - Redistributions in binary form must reproduce the above copyright
//			 notice, this list of conditions and the following disclaimer
//			 in the documentation and/or other materials provided with the
//			 distribution. 
//		 - Neither the name of the University of California, Berkeley nor the
//			 names of its contributors may be used to endorse or promote
//			 products derived from this software without specific prior
//			 written permission. 
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRA	NTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOUpsample
//	Desc:		A simple module designed to repeat or pad each of it's input
//				stream with either a fixed or variable number of output words
//				per input word.  Note that when repeating input data (rather
//				than padding) this module makes the assumption that the input
//				data is stable, which may not be the case with I/O firmware
//				modules.
//				
//	Params:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOUpsample(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Upsampling Control
			//------------------------------------------------------------------
			DepthVariable,
			DepthMax,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutSend,
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Per-Instance Constants
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							DepthFixed =			4,				// The upsampling rate minux one, so 0 means output is the same as output
							Variable =				0,				// Enable support for variable rate upsampling using DepthVariable instead of DepthFixed
							Repeat =				1,				// Repeat the input (1)?  Or pad it with a constant (0)?
							Pad =					{Width{1'bx}};	// The value to pad width
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Fixed Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				DCXWidth =				`max(`log2(DepthFixed + 1), 1);
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Upsampling Control
	//--------------------------------------------------------------------------
	input	[DCXWidth-1:0]	DepthVariable;
	output					DepthMax;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;					// Transfered when Valid & Ready are both asserted
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the Class1 parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;				// Transfered when Valid & Ready are both asserted
	output					OutSend;				// Must not be a function of OutReady
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[DCXWidth-1:0]	DepthCount;
	wire					DepthZero;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	DepthZero =								~|DepthCount;
	
	assign	OutData =								(Repeat || DepthZero) ? InData : Pad;
	assign	OutSend =								(Repeat ? 1'b0 : ~DepthZero) | InValid;
	assign	InAccept =								OutReady & (Repeat ? DepthMax : DepthZero);
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Depth Counter
	//--------------------------------------------------------------------------
	generate if (DepthFixed > 0) begin:DPCNT
		Counter		#(			.Width(				DCXWidth))			
					DpCnt(		.Clock(				Clock),
								.Reset(				Reset | (OutSend & OutReady & DepthMax)),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			OutSend & OutReady),
								.In(				{DCXWidth{1'bx}}),
								.Count(				DepthCount));
	end else begin:DPFIXED
		assign	DepthCount =						0;
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Depth Comparator
	//--------------------------------------------------------------------------
	generate if (Variable) begin:VARIABLE
		assign	DepthMax =							DepthCount == DepthVariable;
	end else begin:FIXED
		CountCompare #(			.Width(				DCXWidth),
								.Compare(			DepthFixed))
					DpCmp(		.Count(				DepthCount),
								.TerminalCount(		DepthMax));
	end endgenerate
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Math/FIFOAccumulator.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOAccumulator
//	Desc:		A class1 or class2 FIFO implementation which accumulates it's
//				input.  Has zero/one cycle forward latency, one fragment of
//				buffering, and zero/one cycle backwards latency (RDL channel
//				CBFC<Width, FWLatency, 1, BWLatency>). This module will be
//				class1 only if FWLantency = BWLatency = 1.
//	Params:		Width:	The width of the data through this FIFO.
//				FWLatency: The forward latency through this FIFO.
//				BWLatency: The backwards latency through this FIFO.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOAccumulator(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InLast,
			InValid,
			InAccept,								// May actually be InReady, depending on the BWLatency parameter
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutSend,								// May actually be OutValid, depending on the FWLatency parameter
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							FWLatency =				1,
							BWLatency =				0,
							Initial =				{Width{1'bx}},
							InitialValid =			1'b0,
							ResetValue =			{Width{1'b0}},
							ResetValid =			1'b0,
							Conservative =			0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;					// Transfered when Valid & Ready are both asserted
	input					InLast;
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the BWLatency parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;				// Transfered when Valid & Ready are both asserted
	output					OutSend;				// Must not be a function of OutReady, may actually be OutValid, depending on the FWLatency parameter
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	wire	[Width-1:0]		Sum, Data;
	wire					Full;
	wire					First;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	Sum =									First ? InData : (InData + Data);
	assign	OutData =								(FWLatency || Full) ? Data : Sum;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	First Register
	//--------------------------------------------------------------------------
	Register		#(			.Width(				1),
								.Initial(			1'b1))
					FirstReg(	.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				Reset),
								.Enable(			(Conservative ? InValid : 1'b1) & InAccept),
								.In(				InLast),
								.Out(				First));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Value Register
	//--------------------------------------------------------------------------
	Register		#(			.Width(				Width),
								.Initial(			Initial),
								.ResetValue(		ResetValue))
					Value(		.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				1'b0),
								.Enable(			(Conservative ? InValid : 1'b1) & InAccept),
								.In(				Sum),
								.Out(				Data));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Controller
	//--------------------------------------------------------------------------
	FIFORegControl	#(			.FWLatency(			FWLatency),
								.BWLatency(			BWLatency),
								.InitialValid(		InitialValid),
								.ResetValid(		ResetValid))
					Cntrl( 		.Clock(				Clock),
								.Reset(				Reset),
								.InValid(			InValid & InLast),
								.InAccept(			InAccept),
								.OutSend(			OutSend),
								.OutReady(			OutReady),
								.Full(				Full));
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Math/FIFOPopCount.v $
//	Version:	$Revision: 12031 $
//	Author:		Brandon Myers
//				Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOPopCount
//	Desc:		Population count; counts the 1's in the input
//	Params:		PWidth: Sets the bitwidth of parallel data into module
//				SWidth: Sets the bitwidth of the internal serial data.  This
//						affects latency and throughput, as this is the
//						width of the internal combinational PopAdd instance
//	Ex:			(32, 32) will give the number of 1'b1 bits in the 32-bit input
//					in 1 cycles.  The throughput and issue rate are 1.
//				(8, 1) will give the number of 1'b1 bits in the 8-bit input in
//					8 clock cycles.  The throughput and issue rate are 1/8.
//	Author:		Brandon Myers
//				<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12031 $
//------------------------------------------------------------------------------
module	FIFOPopCount(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input
			//------------------------------------------------------------------
			InData,
			InValid,
			InReady,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output
			//------------------------------------------------------------------
			OutData,
			OutValid,
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				PWidth =				32,
							SWidth =				8;
	//--------------------------------------------------------------------------
		
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				OWidth =				`log2(PWidth+1),
							XWidth =				`log2(SWidth+1);
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock;
	input					Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input
	//--------------------------------------------------------------------------
	input	[PWidth-1:0]	InData;
	input					InValid;
	output					InReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output
	//--------------------------------------------------------------------------
	output	[OWidth-1:0]	OutData;
	output					OutValid;
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[SWidth-1:0]	IntermediateData;
	wire	[XWidth-1:0]	IntermediateCount;
	wire					IntermediateLast,  IntermediateValid, IntermediateReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Shifter
	//--------------------------------------------------------------------------
	FIFOShiftRound	#(			.IWidth(			PWidth),
								.OWidth(			SWidth),
								.Reverse(			0),
								.Bottom(			0),
								.Class1(			0),
								.Variable(			0),
								.Register(			0))
					Shift(		.Clock(				Clock),
								.Reset(				Reset),
								.RepeatLimit(		/* Unconnected */),
								.RepeatCount(		/* Unconnected */),
								.RepeatMin(			/* Unconnected */),
								.RepeatPreMax(		IntermediateLast),
								.RepeatMax(			/* Unconnected */),
								.InData(			InData),
								.InValid(			InValid),
								.InAccept(			InReady),
								.OutData(			IntermediateData),
								.OutValid(			IntermediateValid),
								.OutReady(			IntermediateReady));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Pop Adder
	//--------------------------------------------------------------------------
	PopAdd			#(			.IWidth(			SWidth))
					PopAdd(		.In(				IntermediateData),
								.Out(				IntermediateCount));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	// Accumulator
	//--------------------------------------------------------------------------
	FIFOAccumulator	#(			.Width(				OWidth))
					Acc(		.Clock(				Clock),
								.Reset(				Reset),
								.InData(			{{OWidth-XWidth{1'b0}}, IntermediateCount}),
								.InLast(			IntermediateLast),
								.InValid(			IntermediateValid),
								.InAccept(			IntermediateReady),
								.OutData(			OutData),
								.OutSend(			OutValid),
								.OutReady(			OutReady));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Mux/FIFODeMux.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2007-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Copyright (c) 2007-2010, Regents of the University of California
//	All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//	
//		 - Redistributions of source code must retain the above copyright notice,
//			 this list of conditions and the following disclaimer. 
//		 - Redistributions in binary form must reproduce the above copyright
//			 notice, this list of conditions and the following disclaimer
//			 in the documentation and/or other materials provided with the
//			 distribution. 
//		 - Neither the name of the University of California, Berkeley nor the
//			 names of its contributors may be used to endorse or promote
//			 products derived from this software without specific prior
//			 written permission. 
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRA	NTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFODeMux
//	Desc:		...
//	Params:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFODeMux(
			//------------------------------------------------------------------
			//	Control
			//------------------------------------------------------------------
			Select,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interfaces
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Output Interfaces
			//------------------------------------------------------------------
			OutData,
			OutSend,
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							NPorts =				4,
							SelectCode =			0; // 0 - Binary, 1 - One-Hot
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam 				SWidth =				SelectCode ? NPorts : `max(1,`log2(NPorts));
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Control
	//--------------------------------------------------------------------------
	input	[SWidth-1:0]	Select;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interfaces
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the Class1 parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interfaces
	//--------------------------------------------------------------------------
	output	[(Width*NPorts)-1:0] OutData;
	output	[NPorts-1:0]	OutSend;				// Must not be a function of OutReady
	input	[NPorts-1:0]	OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Muxes & DeMuxes
	//--------------------------------------------------------------------------
	DeMux			#(			.Width(				Width),
								.NPorts(			NPorts),
								.SelectCode(		SelectCode))
					DDeMux(		.Select(			Select),
								.Input(				InData),
								.Output(			OutData));
	DeMux			#(			.Width(				1),
								.NPorts(			NPorts),
								.SelectCode(		SelectCode),
								.Unselected(		1'b0))
					VDeMux(		.Select(			Select),
								.Input(				InValid),
								.Output(			OutSend));
	Mux				#(			.Width(				1),
								.NPorts(			NPorts),
								.SelectCode(		SelectCode))
					RMux(		.Select(			Select),
								.Input(				OutReady),
								.Output(			InAccept));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Mux/FIFOMux.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2007-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Copyright (c) 2007-2010, Regents of the University of California
//	All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//	
//		 - Redistributions of source code must retain the above copyright notice,
//			 this list of conditions and the following disclaimer. 
//		 - Redistributions in binary form must reproduce the above copyright
//			 notice, this list of conditions and the following disclaimer
//			 in the documentation and/or other materials provided with the
//			 distribution. 
//		 - Neither the name of the University of California, Berkeley nor the
//			 names of its contributors may be used to endorse or promote
//			 products derived from this software without specific prior
//			 written permission. 
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRA	NTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOMux
//	Desc:		...
//	Params:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOMux(
			//------------------------------------------------------------------
			//	Control
			//------------------------------------------------------------------
			Select,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interfaces
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Output Interfaces
			//------------------------------------------------------------------
			OutData,
			OutSend,
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							NPorts =				4,
							SelectCode =			0; // 0 - Binary, 1 - One-Hot
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam 				SWidth =				SelectCode ? NPorts : `max(1,`log2(NPorts));
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Control
	//--------------------------------------------------------------------------
	input	[SWidth-1:0]	Select;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interfaces
	//--------------------------------------------------------------------------
	input	[(Width*NPorts)-1:0] InData;
	input	[NPorts-1:0]	InValid;
	output	[NPorts-1:0]	InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the Class1 parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interfaces
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;
	output					OutSend;				// Must not be a function of OutReady
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Muxes & DeMuxes
	//--------------------------------------------------------------------------
	Mux				#(			.Width(				Width),
								.NPorts(			NPorts),
								.SelectCode(		SelectCode))
					DMux(		.Select(			Select),
								.Input(				InData),
								.Output(			OutData));
	Mux				#(			.Width(				1),
								.NPorts(			NPorts),
								.SelectCode(		SelectCode))
					VMux(		.Select(			Select),
								.Input(				InValid),
								.Output(			OutSend));
	DeMux			#(			.Width(				1),
								.NPorts(			NPorts),
								.SelectCode(		SelectCode),
								.Unselected(		1'b0))
					RDeMux(		.Select(			Select),
								.Input(				OutReady),
								.Output(			InAccept));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Polystream/FIFOCollector.v $
//	Version:	$Revision: 12065 $
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2007-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Copyright (c) 2007-2010, Regents of the University of California
//	All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//	
//		 - Redistributions of source code must retain the above copyright notice,
//			 this list of conditions and the following disclaimer. 
//		 - Redistributions in binary form must reproduce the above copyright
//			 notice, this list of conditions and the following disclaimer
//			 in the documentation and/or other materials provided with the
//			 distribution. 
//		 - Neither the name of the University of California, Berkeley nor the
//			 names of its contributors may be used to endorse or promote
//			 products derived from this software without specific prior
//			 written permission. 
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRA	NTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOCollector
//	Desc:		...
//	Params:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12065 $
//------------------------------------------------------------------------------
module	FIFOCollector(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Mask Interface
			//------------------------------------------------------------------
			Mask,
			MaskValid,
			MaskReady,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interfaces
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Output Interfaces
			//------------------------------------------------------------------
			OutData,
			OutSend,
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							NPorts =				4,
							Register =				{NPorts{1'b0}},	// Per-port: 0 - Combinational logic, 1 - FIFO register all outputs
							Policy =				0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Mask Interface
	//--------------------------------------------------------------------------
	input	[NPorts-1:0]	Mask;
	input					MaskValid;
	output					MaskReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interfaces
	//--------------------------------------------------------------------------
	input	[(Width*NPorts)-1:0] InData;
	input	[NPorts-1:0]	InValid;
	output	[NPorts-1:0]	InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the Register parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interfaces
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;
	output					OutSend;				// Must not be a function of OutReady
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[NPorts:0]		End;
	wire	[NPorts-1:0]	Select;
	wire					MaskIntReady;
	wire					OneValid, OneReady;
	
	wire	[(Width*NPorts)-1:0] IntData;
	wire	[NPorts-1:0]	IntValid;
	wire	[NPorts-1:0]	IntAccept;
	
	genvar					i;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	End =									{1'b0, ~Mask} + {IntValid & IntAccept, 1'b0};
	assign	MaskReady =								MaskIntReady & End[NPorts];
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	FIFO Registers
	//--------------------------------------------------------------------------
	generate for (i = 0; i < NPorts; i = i + 1) begin:REGISTERS
		if (Register[i]) begin:REGISTER
			FIFORegister #(		.Width(				Width)) 
					FIFOReg(	.Clock(				Clock),
								.Reset(				Reset),
								.InData(			InData[(i*Width)+Width-1:(i*Width)]),
								.InValid(			InValid[i]),
								.InAccept(			InAccept[i]),
								.OutData(			IntData[(i*Width)+Width-1:(i*Width)]),
								.OutSend(			IntValid[i]),
								.OutReady(			IntAccept[i] & Mask[i]));
		end else begin:PASSTHROUGH
			assign	IntData[(i*Width)+Width-1:(i*Width)] = InData[(i*Width)+Width-1:(i*Width)];
			assign	IntValid[i] =					InValid[i];
			assign	InAccept[i] =					IntAccept[i] & Mask[i];
		end
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Arbiter
	//--------------------------------------------------------------------------
	generate if (NPorts < 2) begin:S0
		assign	Select =							1'b1;
	end else begin:SCOUNT
		FIFOArbiter	#(			.NPorts(			NPorts),
								.Policy(			Policy))
					Arbiter(	.Clock(				Clock),
								.Reset(				Reset | MaskReady),
								.ManyValid(			IntValid & Mask & {NPorts{MaskValid}}),
								.ManyReady(			IntAccept),
								.ManySelect(		Select),
								.Locked(			/* Unconnected */),
								.OneValid(			OneValid),
								.OneReady(			OneReady));
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Rendezvous
	//--------------------------------------------------------------------------
	FIFORendezvous		#(		.NInputs(			2),
								.NOutputs(			1),
								.InStabilize(		2'b00),
								.OutStabilize(		1'b0))
						Rendezvous(.Clock(			Clock),
								.Reset(				Reset),
								.InValid(			{MaskValid, OneValid}),
								.InAccept(			{MaskIntReady, OneReady}),
								.OutSend(			OutSend),
								.OutReady(			OutReady));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Mux (No need to mux control signals, arbiter takes care of that)
	//--------------------------------------------------------------------------
	Mux				#(			.Width(				Width),
								.NPorts(			NPorts),
								.SelectCode(		1)) // One Hot
					Mux(		.Select(			Select),
								.Input(				IntData),
								.Output(			OutData));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Polystream/FIFODistributor.v $
//	Version:	$Revision: 12065 $
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2007-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Copyright (c) 2007-2010, Regents of the University of California
//	All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//	
//		 - Redistributions of source code must retain the above copyright notice,
//			 this list of conditions and the following disclaimer. 
//		 - Redistributions in binary form must reproduce the above copyright
//			 notice, this list of conditions and the following disclaimer
//			 in the documentation and/or other materials provided with the
//			 distribution. 
//		 - Neither the name of the University of California, Berkeley nor the
//			 names of its contributors may be used to endorse or promote
//			 products derived from this software without specific prior
//			 written permission. 
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRA	NTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFODistributor
//	Desc:		...
//	Params:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12065 $
//------------------------------------------------------------------------------
module	FIFODistributor(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Mask Interface
			//------------------------------------------------------------------
			Mask,
			MaskValid,
			MaskReady,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interfaces
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Output Interfaces
			//------------------------------------------------------------------
			OutData,
			OutSend,
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							NPorts =				4,
							Register =				{NPorts{1'b0}},	// Per-port: 0 - Combinational logic, 1 - FIFO register output
							Policy =				0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Mask Interface
	//--------------------------------------------------------------------------
	input	[NPorts-1:0]	Mask;
	input					MaskValid;
	output					MaskReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interfaces
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the Register parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interfaces
	//--------------------------------------------------------------------------
	output	[(Width*NPorts)-1:0] OutData;
	output	[NPorts-1:0]	OutSend;				// Must not be a function of OutReady
	input	[NPorts-1:0]	OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[NPorts:0]		End;
	wire	[NPorts-1:0]	Select;
	wire					MaskIntReady;
	wire					OneValid, OneReady;
	
	wire	[(Width*NPorts)-1:0] IntData;
	wire	[NPorts-1:0]	IntSend;
	wire	[NPorts-1:0]	IntReady;
	
	genvar					i;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	End =									{1'b0, ~Mask} + {IntReady & IntSend, 1'b0};
	assign	MaskReady =								MaskIntReady & End[NPorts];
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Rendezvous
	//--------------------------------------------------------------------------
	FIFORendezvous		#(		.NInputs(			2),
								.NOutputs(			1),
								.InStabilize(		2'b00),
								.OutStabilize(		1'b0))
						Rendezvous(.Clock(			Clock),
								.Reset(				Reset),
								.InValid(			{MaskValid, InValid}),
								.InAccept(			{MaskIntReady, InAccept}),
								.OutSend(			OneValid),
								.OutReady(			OneReady));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Arbiter
	//--------------------------------------------------------------------------
	generate if (NPorts < 2) begin:S0
		assign	Select =							1'b1;
	end else begin:SCOUNT
		FIFOArbiter	#(			.NPorts(			NPorts),
								.Policy(			Policy))
					Arbiter(	.Clock(				Clock),
								.Reset(				Reset | MaskReady),
								.ManyValid(			IntReady & Mask & {NPorts{MaskValid}}),
								.ManyReady(			IntSend),
								.ManySelect(		Select),
								.Locked(			/* Unconnected */),
								.OneValid(			OneReady),
								.OneReady(			OneValid));
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	DeMux (No need to demux control signals, arbiter takes care of that)
	//--------------------------------------------------------------------------
	DeMux			#(			.Width(				Width),
								.NPorts(			NPorts),
								.SelectCode(		1)) // One Hot
					DeMux(		.Select(			Select),
								.Input(				InData),
								.Output(			IntData));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	FIFO Registers
	//--------------------------------------------------------------------------
	generate for (i = 0; i < NPorts; i = i + 1) begin:REGISTERS
		if (Register[i]) begin:REGISTER
			FIFORegister #(		.Width(				Width)) 
					FIFOReg(	.Clock(				Clock),
								.Reset(				Reset),
								.InData(			IntData[(i*Width)+Width-1:(i*Width)]),
								.InValid(			IntSend[i] & Mask[i]),
								.InAccept(			IntReady[i]),
								.OutData(			OutData[(i*Width)+Width-1:(i*Width)]),
								.OutSend(			OutSend[i]),
								.OutReady(			OutReady[i]));
		end else begin:PASSTHROUGH
			assign	OutData[(i*Width)+Width-1:(i*Width)] = IntData[(i*Width)+Width-1:(i*Width)];
			assign	OutSend[i] =					IntSend[i] & Mask[i];
			assign	IntReady[i] =					OutReady[i];
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Polystream/FIFODuplicator.v $
//	Version:	$Revision: 12062 $
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2007-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Copyright (c) 2007-2010, Regents of the University of California
//	All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//	
//		 - Redistributions of source code must retain the above copyright notice,
//			 this list of conditions and the following disclaimer. 
//		 - Redistributions in binary form must reproduce the above copyright
//			 notice, this list of conditions and the following disclaimer
//			 in the documentation and/or other materials provided with the
//			 distribution. 
//		 - Neither the name of the University of California, Berkeley nor the
//			 names of its contributors may be used to endorse or promote
//			 products derived from this software without specific prior
//			 written permission. 
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRA	NTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFODuplicator
//	Desc:		...
//	Params:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12062 $
//------------------------------------------------------------------------------
module	FIFODuplicator(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Mask Interface
			//------------------------------------------------------------------
			Mask,
			MaskValid,
			MaskReady,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interfaces
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Output Interfaces
			//------------------------------------------------------------------
			OutData,
			OutSend,
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							NPorts =				4,
							Register =				{NPorts{1'b0}},	// Per-port: 0 - Combinational logic, 1 - FIFO register output
							Policy =				0; // 0 - Wait for all outputs, 1 - Duplicate to all currently ready outputs
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Mask Interface
	//--------------------------------------------------------------------------
	input	[NPorts-1:0]	Mask;
	input					MaskValid;
	output					MaskReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interfaces
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the Register parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interfaces
	//--------------------------------------------------------------------------
	output	[(Width*NPorts)-1:0] OutData;
	output	[NPorts-1:0]	OutSend;				// Must not be a function of OutReady
	input	[NPorts-1:0]	OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[(Width*NPorts)-1:0] IntData;
	wire	[NPorts-1:0]	IntSend;
	wire	[NPorts-1:0]	IntReady;
	
	genvar					i;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	IntData =								{NPorts{InData}};
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Control Logic
	//--------------------------------------------------------------------------
	generate if (Policy) begin:NOWAIT
		//----------------------------------------------------------------------
		//	Policy 1: Send to all ready outputs
		//----------------------------------------------------------------------
		wire				SingleSend;
		
		FIFORendezvous	#(		.NInputs(			2),
								.NOutputs(			1),
								.InStabilize(		2'b00),
								.OutStabilize(		1'b0))
						Rendezvous(.Clock(			Clock),
								.Reset(				Reset),
								.InValid(			{MaskValid, InValid}),
								.InAccept(			{MaskReady, InAccept}),
								.OutSend(			SingleSend),
								.OutReady(			|(IntReady & Mask)));
		
		assign	IntSend =							{NPorts{SingleSend}};
		//----------------------------------------------------------------------
	end else begin:WAIT
		//----------------------------------------------------------------------
		//	Policy 0: Wait for all ports
		//----------------------------------------------------------------------
		FIFORendezvous	#(		.NInputs(			2),
								.NOutputs(			NPorts),
								.InStabilize(		2'b00),
								.OutStabilize(		{NPorts{1'b0}}))
						Rendezvous(.Clock(			Clock),
								.Reset(				Reset),
								.InValid(			{MaskValid, InValid}),
								.InAccept(			{MaskReady, InAccept}),
								.OutSend(			IntSend),
								.OutReady(			IntReady | ~Mask));
		//----------------------------------------------------------------------
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	FIFO Registers
	//--------------------------------------------------------------------------
	generate for (i = 0; i < NPorts; i = i + 1) begin:REGISTERS
		if (Register[i]) begin:REGISTER
			FIFORegister #(		.Width(				Width)) 
					FIFOReg(	.Clock(				Clock),
								.Reset(				Reset),
								.InData(			IntData[(i*Width)+Width-1:(i*Width)]),
								.InValid(			IntSend[i] & Mask[i]),
								.InAccept(			IntReady[i]),
								.OutData(			OutData[(i*Width)+Width-1:(i*Width)]),
								.OutSend(			OutSend[i]),
								.OutReady(			OutReady[i]));
		end else begin:PASSTHROUGH
			assign	OutData[(i*Width)+Width-1:(i*Width)] = IntData[(i*Width)+Width-1:(i*Width)];
			assign	OutSend[i] =					IntSend[i] & Mask[i];
			assign	IntReady[i] =					OutReady[i];
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Shift/FIFOShiftFixedExact.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2008-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2008-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOShiftFixedExact
//	Desc:		A shift register with class2 FIFO interfaces for both parallel
//				and serial data.  This module is designed for skew conversion on
//				FIFO connections including complete support for lossless
//				bitwidth conversions of any input and output widths.  Note that
//				this module will neither lose NOR GENERATE additional bits for
//				the conversion, instead treating the input and output as
//				parallel windows onto a serial bitstream.
//				
//				In order to support any bitwidth input and output without any
//				bit-loss, this module includes a complex muxing structure which
//				may be expensive to implement in FPGAs.  In particular the
//				module will include a Xb, Y input register/mux where:
//				X = IWidth + OWidth - GCD(IWidth,OWidth)
//				Y = MAX(IWidth,OWidth) / GCD(IWidth,OWidth)
//				
//	Params:		IWidth:	Sets the bitwidth of the input.
//				OWidth:	Sets the bitwidth of the output.
//				Reverse:Shift MSb to LSb instead of the normal LSb to MSb
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOShiftFixedExact(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,								// May actually be InReady, depending on the Class1 parameter
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutValid,
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				IWidth =				8,	// Input width
							OWidth =				32,	// Output width
							Reverse =				0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	GCD Function
	//--------------------------------------------------------------------------
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				Max =					`max(IWidth, OWidth),
							GCD =					gcd(IWidth, OWidth),
							Order =					Max / GCD,
							Increment =				(IWidth > OWidth) ? (IWidth - OWidth) : IWidth,
							Width =					IWidth + OWidth - GCD,
							CWidth =				`log2(Order);
	`else
	localparam				Max =					IWidth + OWidth,
							GCD =					Max,
							Order =					Max,
							Increment =				1,
							Width =					Max,
							CWidth =				Max;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clock & Reset Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[IWidth-1:0]	InData;					// Transfered when Valid & Ready are both asserted
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the Class1 parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[OWidth-1:0]	OutData;				// Transfered when Valid & Ready are both asserted
	output					OutValid;				// Must not be a function of OutReady
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					InEnable, OutEnable, Enable;
	
	wire	[CWidth-1:0]	RepeatCount;
	wire					RepeatMax;
	
	wire	[Width-1:0]		Next, Current;
	wire					Load, ShiftLoad, Full;
	wire					Maxed, ReadGate;
	
	genvar					i;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Conditional Logic Generation
	//--------------------------------------------------------------------------
	generate if (IWidth == OWidth) begin:SAME
		//----------------------------------------------------------------------
		//	Simple FIFO Register
		//----------------------------------------------------------------------
		FIFORegister #(			.Width(				IWidth),
								.FWLatency(			1),
								.BWLatency(			0))
					Pass(		.Clock(				Clock),
								.Reset(				Reset),
								.InData(			InData),
								.InValid(			InValid),
								.InAccept(			InAccept),
								.OutData(			OutData),
								.OutSend(			OutValid),
								.OutReady(			OutReady));
		//----------------------------------------------------------------------
	end else begin:DIFF
		//----------------------------------------------------------------------
		//	Maxed Register
		//----------------------------------------------------------------------
		Register	#(			.Width(				1))
					MaxedReg(	.Clock(				Clock),
								.Reset(				Reset),
								.Set(				Enable & ~|RepeatCount),
								.Enable(			1'b0),
								.In(				1'bx),
								.Out(				Maxed));
		//----------------------------------------------------------------------
	
		//----------------------------------------------------------------------
		//	Already Read
		//----------------------------------------------------------------------							
		Register	#(			.Width(				1))
					AReadReg(	.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				Reset | Enable),
								.Enable(			OutValid & OutReady),
								.In(				1'b0),
								.Out(				ReadGate));
		//--------------------------------------------------------------------------
	
		//----------------------------------------------------------------------
		//	Variable Shift Assigns
		//----------------------------------------------------------------------
		assign	InAccept =							OutEnable & Load;
		assign	OutData =							Reverse ? Current[OWidth-1:0] : Current[Width-1:Width-OWidth];
		assign	OutValid =							/*InEnable &*/ Full & ReadGate;
		
		assign	InEnable =							(~Load | InValid);
		assign	OutEnable =							(~Full | OutReady);
		assign	Enable =							InEnable & OutEnable;
		
		if (IWidth >= OWidth) begin
			assign	ShiftLoad =						1'b1;
			assign	Full =							Maxed;
		end
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Variable Shift Muxing Logic
		//----------------------------------------------------------------------
		for (i = 0; i < Order; i = i + 1) begin
			localparam	LdPos =						((i*Increment)%Max);
			
			assign	Load =							(i == RepeatCount) ? ((IWidth <= OWidth) || (LdPos < OWidth)) : 1'bz;
		
			if (IWidth < OWidth) begin
				assign	ShiftLoad =					(i == RepeatCount) ? ((((i+Order-1)%Order)*Increment)%Max) >= (OWidth - IWidth) : 1'bz; // ((i*IWidth) >= OWidth)
				assign	Full =						(i == RepeatCount) ? (((i != 0) | Maxed) & ShiftLoad) : 1'bz;
			end
			
			if (Reverse) begin
				if ((LdPos+IWidth) <= Width) assign	Next[LdPos+IWidth-1:LdPos] =				((i == RepeatCount) & Load) ? InData : {IWidth{1'bz}};
				if (LdPos != 0) begin
					assign	Next[LdPos-1:0] =													((i == RepeatCount) & Load & ~ShiftLoad) ? Current[LdPos-1:0] : {LdPos{1'bz}};
					if (Width > OWidth) assign	Next[LdPos-1:0] =								((i == RepeatCount) & (~Load | ShiftLoad)) ? {{((Width > (LdPos+OWidth)) ? (Width-LdPos-OWidth) : 1){1'bx}}, Current[((Width >= (OWidth+LdPos)) ? (LdPos+OWidth-1) : (Width-1)):OWidth]} : {LdPos{1'bz}};
				end
			end else begin
				if (LdPos != 0) begin
					assign	Next[Width-1:Width-LdPos] =											((i == RepeatCount) & Load & ~ShiftLoad) ? Current[Width-1:Width-LdPos] : {LdPos{1'bz}};
					if (Width > OWidth) assign	Next[Width-1:Width-LdPos] =						((i == RepeatCount) & (~Load | ShiftLoad)) ? ({Current[Width-OWidth-1:(Width >= (OWidth+LdPos)) ? (Width-OWidth-LdPos) : 0], {(Width >= (OWidth+LdPos)) ? 1 : (OWidth+LdPos-Width+1){1'bx}}} >> 1) : {LdPos{1'bz}};
				end
				if (Width >= LdPos+IWidth) assign	Next[Width-LdPos-1:Width-LdPos-IWidth] =	((i == RepeatCount) & Load) ? InData : {IWidth{1'bz}};
			end
		end
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Variable Shift Register
		//----------------------------------------------------------------------
		Register	#(			.Width(				Width))
					Reg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			Enable),
								.In(				Next),
								.Out(				Current));
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Variable Shift Counter
		//----------------------------------------------------------------------
		Counter 	#(			.Width(				CWidth))
					Cnt(		.Clock(				Clock),
								.Reset(				Reset | (RepeatMax & Enable)),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			Enable),
								.In(				{CWidth{1'bx}}),
								.Count(				RepeatCount));
		//----------------------------------------------------------------------
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Count Comparison
	//--------------------------------------------------------------------------
	CountCompare 	#(			.Width(				CWidth),
								.Compare(			Order - 1))
					Cmp(		.Count(				RepeatCount),
								.TerminalCount(		RepeatMax));
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Shift/FIFOShiftRound.v $
//	Version:	$Revision: 12031 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOShiftRound
//	Desc:		A shift register with class1 or class2 FIFO interfaces for both
//				parallel and serial data.  This module is designed for skew
//				conversion on FIFO connections.
//				
//				Note that this module does not perform complete realignment.
//				In particular if IWidth%OWidth!=0 and OWidth%IWidth!=0 then the
//				module will drop some of the input bits.  For example it can
//				convert 32b to 8b or 8b to 32b both without loss, but if asked
//				to go from 32b to 9b, it will unpack 3 9b values from the 32b
//				word and throw out the remaining 5b.  See FIFOShiftFixedExact
//				for a module which does lossless conversions. 
//
//				This module is basically a way to convert from a narrow FIFO
//				interface to a wide one and vice versa.  It supports any width
//				of input and output, and has parameters to control its behavior
//				with respect to alignment and excess bits.
//				
//	Params:		IWidth:	Sets the bitwidth of the input.
//				OWidth:	Sets the bitwidth of the output.
//				Reverse:Shift MSb to LSb instead of the normal LSb to MSb
//				Bottom:	If (Max(IWidth,OWidth) % Min(IWidth,OWitdh)) != 0, use
//						the least significant bits of the big bus (whether in
//						or out)
//				Class1:	Should this implementation be class1?
//				Variable: Determine whether the repeat count can be varied
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12031 $
//------------------------------------------------------------------------------
module	FIFOShiftRound(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Control & Status
			//------------------------------------------------------------------
			RepeatLimit,
			RepeatCount,
			RepeatMin,
			RepeatPreMax,
			RepeatMax,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InValid,
			InAccept,								// May actually be InReady, depending on the Class1 parameter
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutValid,
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				IWidth =				8,	// Input width
							OWidth =				32,	// Output width
							Reverse =				0,
							Bottom =				0,
							Class1 =				0,
							Variable =				0,
							Register =				0;	// Put a FIFO register between the input and output when their widths are equal 
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				BWidth =				`max(IWidth, OWidth),	// The big width
							SWidth =				`min(IWidth, OWidth),	// The small width
							Max =					`divceil(BWidth, SWidth),
							PWidth =				Max * SWidth,
							CWidth =				`log2(Max + 1);
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Control & Status
	//--------------------------------------------------------------------------
	input	[CWidth-1:0]	RepeatLimit;
	output	[CWidth-1:0]	RepeatCount;
	output					RepeatMin, RepeatPreMax, RepeatMax;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[IWidth-1:0]	InData;					// Transfered when Valid & Ready are both asserted
	input					InValid;
	output					InAccept;				// Must not be a function of InValid, may actually be InReady, depending on the Class1 parameter
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[OWidth-1:0]	OutData;				// Transfered when Valid & Ready are both asserted
	output					OutValid;				// Must not be a function of OutReady
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					RepeatCountReset, RepeatCountEnable;
	
	wire	[PWidth-1:0]	Parallel;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Conditional Logic Generation
	//--------------------------------------------------------------------------
	generate if (IWidth == OWidth) begin:SAME
		if (Register) begin:REGISTER
			FIFORegister #(		.Width(				IWidth),
								.FWLatency(			1),
								.BWLatency(			Class1))
					Pass(		.Clock(				Clock),
								.Reset(				Reset),
								.InData(			InData),
								.InValid(			InValid),
								.InAccept(			InAccept),
								.OutData(			OutData),
								.OutSend(			OutValid),
								.OutReady(			OutReady));
		end else begin:PASSTHROUGH
			assign	OutData =						InData;
			assign	OutValid =						InValid;
			assign	InAccept =						OutReady;
		end
	end else if (IWidth > OWidth) begin:DOWN
		assign	InAccept =							RepeatMax | ((Class1 ? 1'b0 : 1'b1) & OutReady & RepeatPreMax);
		assign	OutValid =							~RepeatMax;
		assign	RepeatCountReset =					InValid & InAccept;
		assign	RepeatCountEnable =					OutValid & OutReady;
		
		if (IWidth < PWidth) assign	Parallel =		Bottom ? {{(PWidth-IWidth){1'bx}}, InData} : {InData, {(PWidth-IWidth){1'bx}}};
		else assign	Parallel =						InData;
	
		ShiftRegister #(		.PWidth(			PWidth),
								.SWidth(			SWidth),
								.Reverse(			Reverse))
					Shift(		.Clock(				Clock),
								.Reset(				Reset),
								.Load(				InAccept),
								.Enable(			OutReady),
								.PIn(				Parallel),
								.SIn(				{SWidth{1'bx}}),
								.POut(				/* Unconnected */),
								.SOut(				OutData));
								
		Counter 	#(			.Width(				CWidth))
					Cnt(		.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				Reset),
								.Load(				RepeatCountReset),
								.Enable(			RepeatCountEnable),
								.In(				{CWidth{1'b0}}),
								.Count(				RepeatCount));
	end else begin:UP
		assign	InAccept =							~RepeatMax | ((Class1 ? 1'b0 : 1'b1) & OutReady & RepeatMax);
		assign	OutValid =							RepeatMax;
		assign	RepeatCountReset =					OutValid & OutReady;
		assign	RepeatCountEnable =					InValid & InAccept;
		
		if (OWidth < PWidth) assign	OutData =		Bottom ? Parallel[OWidth-1:0] : Parallel[PWidth-1:PWidth-OWidth];
		else assign	OutData =						Parallel;
	
		ShiftRegister #(		.PWidth(			PWidth),
								.SWidth(			SWidth),
								.Reverse(			Reverse))
					Shift(		.Clock(				Clock),
								.Reset(				Reset),
								.Load(				1'b0),
								.Enable(			InValid & InAccept),
								.PIn(				{PWidth{1'bx}}),
								.SIn(				InData),
								.POut(				Parallel),
								.SOut(				/* Unconnected */));
		
		Counter 	#(			.Width(				CWidth))
					Cnt(		.Clock(				Clock),
								.Reset(				(RepeatCountReset & ~RepeatCountEnable) | Reset),
								.Set(				1'b0),
								.Load(				RepeatCountReset & RepeatCountEnable),
								.Enable(			RepeatCountEnable),
								.In(				{{CWidth-1{1'b0}}, 1'b1}),
								.Count(				RepeatCount));
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Count Comparsion
	//--------------------------------------------------------------------------
	generate if (IWidth == OWidth) begin:SAMELIMITS
		assign	RepeatMin =							1'b1;
		assign	RepeatPreMax =						1'b1;
		assign	RepeatMax =							1'b1;
	end else begin:DIFFLIMITS
		if (Variable) begin:VARIABLE
			assign	RepeatMax =						RepeatCount == RepeatLimit;
			assign	RepeatPreMax =					RepeatCount == (RepeatLimit - 1);
		end else begin:FIXED
			CountCompare #(		.Width(				CWidth),
								.Compare(			Max))
					Cmp(		.Count(				RepeatCount),
								.TerminalCount(		RepeatMax));
			assign	RepeatPreMax =					RepeatCount == (Max - 1);
		end
		
		assign	RepeatMin =							~|RepeatCount;
	end endgenerate
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Shift/FIFOShiftVarExact.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2008-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2008-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOShiftVarExact
//	Desc:		A shift register with class1 FIFO interfaces for both parallel
//				and serial data.  This module will allow the data receiver to
//				enable the reception of only those chunks of data which it
//				is prepared to accept on a given cycle.
//
//				In order to accomodate the variable size transfers, the
//				handshake signals on this modules are sizes rather than simple
//				flags as usual.  The data word (Width) is broken into groups
//				(GWidth) and the number of groups of input or output which are
//				being transfered is a specified as part of the handshake of this
//				module.  This allows the user to put in or take out only as much
//				data as they want on each cycle.  There are parameters which
//				control which of the four input and output, ready and valid
//				signals are widths, versus simple flags.
//				
//	Params:		GWidth:	The width of each of the input groups to this module
//				Groups:	The number of input groups
//				Reverse:Shift MSb to LSb instead of the normal LSb to MSb
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOShiftVarExact(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input Interface
			//------------------------------------------------------------------
			InData,
			InValid,
			InReady,
			InTransfer,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutValid,
			OutReady,
			OutTransfer
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				GWidth =				16,	// Group width
							Groups =				2,
							Reverse =				0,
							InMode =				0,	// Transfer Size: 0 - minimum of ready and valid, 1 - ready (valid is 1bit), 2 - valid (ready is 1 bit), 3 - complete word (ready and valid are 1bit)
							OutMode =				0,	// Transfer Size: 0 - minimum of ready and valid, 1 - valid (ready is 1bit), 2 - ready (valid is 1 bit), 3 - complete word (ready and valid are 1bit)
							Class1 =				0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				Width =					GWidth * Groups,
							IVShort =				((InMode == 1) || (InMode == 3)),
							IRShort =				((InMode == 2) || (InMode == 3)),
							ITShort =				(InMode == 3),
							OVShort =				((OutMode == 2) || (OutMode == 3)),
							ORShort =				((OutMode == 1) || (OutMode == 3)),
							OTShort =				(OutMode == 3),
							DoubleWide =			(IRShort | OVShort),
							XGroups =				(DoubleWide ? (2*Groups) : Groups),
	`ifdef MACROSAFE
							CWidth =				`log2(Groups+1),
							CXWidth =				`log2(XGroups+1),
	`else
							CWidth =				Groups,
							CXWidth =				XGroups,
	`endif
							IVCWidth =				IVShort ? 1 : CWidth,
							IRCWidth =				IRShort ? 1 : CWidth,
							ITCWidth =				ITShort ? 1 : CWidth,
							OVCWidth =				OVShort ? 1 : CWidth,
							ORCWidth =				ORShort ? 1 : CWidth,
							OTCWidth =				OTShort ? 1 : CWidth,
							XWidth =				DoubleWide ? (GWidth*XGroups) : Width;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clock & Reset Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Interface
	//--------------------------------------------------------------------------
	input	[Width-1:0]		InData;					// Transfered when Valid & Ready are both asserted
	input	[IVCWidth-1:0]	InValid;
	output	[IRCWidth-1:0]	InReady;				// Must not be a function of InValid
	output	[ITCWidth-1:0]	InTransfer;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		OutData;				// Transfered when Valid & Ready are both asserted
	output	[OVCWidth-1:0]	OutValid;				// Must not be a function of OutReady
	input	[ORCWidth-1:0]	OutReady;
	output	[OTCWidth-1:0]	OutTransfer;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[CWidth-1:0]	LongInValid, LongInReady, LongInTransfer;
	wire	[CWidth-1:0]	LongOutValid, LongOutReady, LongOutTransfer;
	
	wire	[CXWidth-1:0]	CurrCount, NextCount;
	wire	[CXWidth-1:0]	Remaining, VeryLongOutTransfer;
	
	wire	[XWidth-1:0]	OldData, NewData, RawData;
	wire	[XWidth-1:0]	CurrData, NextData;
	
	genvar					i;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input Side Logic
	//--------------------------------------------------------------------------
	assign	LongInValid =							IVShort ? (InValid ? Groups : 0) : InValid;
	assign	InReady =								IRShort ? (LongInReady >= Groups) : LongInReady;
	assign	InTransfer =							ITShort ? (InValid & InReady) : LongInTransfer;
	
	generate if (DoubleWide) begin:DOUBLELIR
		wire	[CXWidth-1:0]XLongInReady;
		assign	XLongInReady =						Class1 ? (XGroups - CurrCount) : (XGroups - Remaining);
		assign	LongInReady =						(XLongInReady > Groups) ? Groups : XLongInReady;
	end else begin:SINGLELIR
		assign	LongInReady =						Class1 ? (XGroups - CurrCount) : (XGroups - Remaining);
	end endgenerate
	
	generate case (InMode)
		0: begin
			assign	LongInTransfer =				`min(LongInValid, LongInReady);
		end
		1: begin
			assign	LongInTransfer =				InValid ? LongInReady : 0;
		end
		2: begin
			assign	LongInTransfer =				InReady ? LongInValid : 0;
		end
		3: begin
			assign	LongInTransfer =				InTransfer ? Groups : 0;
		end
	endcase endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Side Logic
	//--------------------------------------------------------------------------
	assign	OutValid =								OVShort ? (LongOutValid >= Groups) : LongOutValid;
	assign	LongOutReady =							ORShort ? (OutReady ? Groups : 0) : OutReady;
	assign	OutTransfer =							OTShort ? (OutValid & OutReady) : LongOutTransfer;
	
	generate if (DoubleWide) begin:DOUBLELOV
		assign	LongOutValid =						(CurrCount > Groups) ? Groups : CurrCount;
		assign	VeryLongOutTransfer =				{{CXWidth-CWidth{1'b0}}, LongOutTransfer};
	end else begin:SINGLELOV
		assign	LongOutValid =						CurrCount;
		assign	VeryLongOutTransfer =				LongOutTransfer;
	end endgenerate
	
	generate case (OutMode)
		0: begin
			assign	LongOutTransfer =				`min(LongOutValid, LongOutReady);
		end
		1: begin
			assign	LongOutTransfer =				OutReady ? LongOutValid : 0;
		end
		2: begin
			assign	LongOutTransfer =				OutValid ? LongOutReady : 0;
		end
		3: begin
			assign	LongOutTransfer =				OutTransfer ? Groups : 0;
		end
	endcase endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	generate if (DoubleWide) begin:DOUBLELIO
		assign	RawData =							Reverse ? {{Width{1'bx}}, InData} : {InData, {Width{1'bx}}};
		assign	OutData =							Reverse ? CurrData[Width-1:0] : CurrData[XWidth-1:Width];
	end else begin:SINGLEIO
		assign	RawData =							InData;
		assign	OutData =							CurrData;
	end endgenerate
	
	assign	Remaining =								CurrCount - LongOutTransfer;
	assign	NextCount =								Remaining + LongInTransfer;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Barrel Shifters
	//--------------------------------------------------------------------------
	// OldData = (CurrData << LongOutTransfer)
	BarrelShifter	#(			.GWidth(			GWidth),
								.Groups(			XGroups),
								.Direction(			Reverse ? 1 : 0),
								.Type(				0),
								.Output(			Reverse ? 0 : 1))
					OldShift(	.In(				CurrData),
								.Shift(				VeryLongOutTransfer),
								.Out(				OldData));
	
	// NewData = (InData >> Remaining)
	BarrelShifter	#(			.GWidth(			GWidth),
								.Groups(			XGroups),
								.Direction(			Reverse ? 0 : 1),
								.Type(				0),
								.Output(			Reverse ? 1 : 0))
					NewShift(	.In(				RawData),
								.Shift(				Remaining),
								.Out(				NewData));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Data Mux
	//--------------------------------------------------------------------------
	generate for (i = 0; i < XGroups; i = i + 1) begin:DATAMUX
		assign	NextData[(GWidth*i)+GWidth-1:(GWidth*i)] = (Reverse ? (i < Remaining) : ((XGroups - i - 1) < Remaining)) ? OldData[(GWidth*i)+GWidth-1:(GWidth*i)] : NewData[(GWidth*i)+GWidth-1:(GWidth*i)];
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	State Registers
	//--------------------------------------------------------------------------
	Register		#(			.Width(				CXWidth))
					CountReg(	.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			1'b1),
								.In(				NextCount),
								.Out(				CurrCount));
	Register		#(			.Width(				XWidth))
					DataReg(	.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			1'b1),
								.In(				NextData),
								.Out(				CurrData));
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Simulation/FIFORandom.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFORandom
//	Desc:		Generate a stream of random data suitable for simulation testing
//				purposes.
//				
//	Params:		Width:	The width of the data output.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFORandom(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output Interface
			//------------------------------------------------------------------
			OutData,
			OutValid,
			OutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					8;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Interface
	//--------------------------------------------------------------------------
	output reg [Width-1:0]	OutData;
	output					OutValid;
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	OutValid =								1'b1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Random Number Generation
	//--------------------------------------------------------------------------
	always @ (posedge Clock) begin
		if (Reset | (OutValid & OutReady)) OutData = $random;
	end
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Tester/FIFOMeasure.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOMeasure
//	Desc:		A circuit designed to measure the timing characteristics of a
//				FIFO by repeatedly filling and draining it.  This circuit will
//				calculate the forward latency, buffering and backward latency
//				of the FIFO as well as checking for spurious control signal
//				changes (which may or may not indicate a problem), data errors
//				and spurious data changes (which indicate a FIFO interface
//				violation).  This circuit is started with a pulse, and will
//				report done similarly.  Results are reported using a FIFO
//				interface at the end of each test iteration.
//				See FIFOTester and the FIFO documentation for more information.
//	Params:		Width:	The data width of the FIFO.
//				EstMaxLatency: The estimated maximum latency of the FIFO.  An
//						overestimate is preferable to an underestimate, as this
//						is used to size the result counters.
//				EstMaxBuffering The estimated maximum buffering of the FIFO.  An
//						overestimate is preferable to an underestimate, as this
//						is used to size the result counters.
//				RWidth:	The width of the reports, by default this is
//						calculated from the estimated values above.
//				NTests:	Number of times to run the test.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOMeasure(
			//------------------------------------------------------------------
			//	Control Signals
			//------------------------------------------------------------------
			Clock,
			Reset,
			Start,
			Done,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	FIFO (Circuit Under Test) Interface
			//------------------------------------------------------------------
			CUTInData,
			CUTInValid,
			CUTInReady,
			
			CUTOutData,
			CUTOutValid,
			CUTOutReady,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Report Interface
			//------------------------------------------------------------------
			ReportFWLatency,
			ReportBuffering,
			ReportBWLatency,
			ReportErrorCount,
			ReportDataChange,
			ReportSpurious,
			ReportValid,
			ReportReady
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	parameter				Width =					32,
							EstMaxLatency =			32,
							EstMaxBuffering =		1,
							LimitMaxBuffering =		0,
							PadEnable =				0,
							PadValue =				{Width{1'bx}},
							RWidth =				`log2(`max(EstMaxLatency, EstMaxBuffering)) + 4,
							NTests =				16;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				NWidth =				`log2(NTests),
							WCWidth =				`max(RWidth, Width);
	`endif
	localparam				STATE_Done =			2'b00,
							STATE_Fill =			2'b01,
							STATE_Drain =			2'b10,
							STATE_Report =			2'b11;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Control Signals
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	input					Start;
	output					Done;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	FIFO (Circuit Under Test) Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		CUTInData;
	output					CUTInValid;
	input					CUTInReady;

	input	[Width-1:0]		CUTOutData;
	input					CUTOutValid;
	output					CUTOutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Report Interface
	//--------------------------------------------------------------------------
	output	[RWidth-1:0]	ReportFWLatency, ReportBuffering, ReportBWLatency, ReportErrorCount, ReportDataChange;
	output	[1:0]			ReportSpurious;
	output					ReportValid;
	input					ReportReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[NWidth-1:0]	TestCount;
	wire	[RWidth-1:0]	TimeoutCounter;
	wire	[WCWidth-1:0]	WriteCount;
	
	wire	[Width-1:0]		LastCUTOutData, PrevCUTOutData, ExpectedCUTOutData;
	wire					Skip, Match;
	wire					ErrorInc, DataChangeInc;
	
	reg		[1:0]			CurrentState, NextState;
	wire					Running;
	wire					Timeout, TestTerminal;
	wire					ReportTransfer, CUTInTransfer, CUTOutTransfer, LastDCValid;
	wire					FillComplete, DrainComplete;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assign Statements
	//--------------------------------------------------------------------------
	assign	Done =									TestTerminal & ReportTransfer;
	assign	CUTInValid =							(CurrentState == STATE_Fill);
	assign	CUTInData =								WriteCount[Width-1:0];
	assign	CUTOutReady =							(CurrentState == STATE_Drain);
	assign	ReportValid =							(CurrentState == STATE_Report);
	
	assign	ExpectedCUTOutData =					PrevCUTOutData+1;
	assign	Skip =									PadEnable ? (PadValue === CUTOutData) : 1'b0;
	assign	Match =									(ExpectedCUTOutData == CUTOutData);
	assign	ErrorInc =								~Match & ~Skip & CUTOutTransfer;
	assign	DataChangeInc =							(LastCUTOutData != CUTOutData) & CUTOutValid & LastDCValid & Running;
	
	assign	Running =								(CurrentState == STATE_Fill) | (CurrentState == STATE_Drain);
	assign	Timeout =								&TimeoutCounter | ((LimitMaxBuffering != 0) & (CurrentState == STATE_Fill) & (WriteCount >= (LimitMaxBuffering - 1)));
	assign	ReportTransfer =						ReportReady & ReportValid;
	assign	CUTInTransfer =							CUTInValid & CUTInReady;
	assign	CUTOutTransfer =						CUTOutValid & CUTOutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	FSM
	//--------------------------------------------------------------------------
	always @ (posedge Clock) begin
		if (Reset | Done) CurrentState <=			STATE_Done;
		else CurrentState <=						NextState;
	end
	
	always @ (*) begin
		case (CurrentState)
			STATE_Done: NextState =					Start ? STATE_Fill : STATE_Done;
			STATE_Fill: NextState =					Timeout ? STATE_Drain : STATE_Fill;
			STATE_Drain: NextState =				Timeout ? STATE_Report : STATE_Drain;
			STATE_Report: NextState =				ReportReady ? (Done ? STATE_Done : STATE_Fill) : STATE_Report;
		endcase
	end
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Timeout Counter
	//--------------------------------------------------------------------------
	Counter			#(			.Width(				RWidth))
					TimeCnt(	.Clock(				Clock),
								.Reset(				Reset | Done | ((CurrentState == STATE_Fill) & CUTInReady) | ((CurrentState == STATE_Drain) & CUTOutValid)),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			((CurrentState == STATE_Fill) & ~CUTInReady) | ((CurrentState == STATE_Drain) & ~CUTOutValid)),
								.In(				{RWidth{1'bx}}),
								.Count(				TimeoutCounter));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Test Iteration Counter
	//--------------------------------------------------------------------------
	Counter			#(			.Width(				NWidth))
					TestCnt(	.Clock(				Clock),
								.Reset(				Reset | Done),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			ReportTransfer),
								.In(				{NWidth{1'bx}}),
								.Count(				TestCount));
	CountCompare	TCCmp(		.Count(				TestCount),
								.TerminalCount(		TestTerminal));
	defparam		TCCmp.Width = 					NWidth;
	defparam		TCCmp.Compare =					NTests - 1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Test Data Counter & Register
	//--------------------------------------------------------------------------
	Counter #(WCWidth) WriteCnt(.Clock(Clock), .Reset(Reset | Done | ReportTransfer), .Set(1'b0), .Load(1'b0), .Enable(CUTInTransfer), .In({WCWidth{1'bx}}), .Count(WriteCount));
	Register #(Width) PrevReg(.Clock(Clock), .Reset(1'b0), .Set(Reset | Done | ReportTransfer), .Enable((~Skip | Match) & CUTOutTransfer), .In(CUTOutData), .Out(PrevCUTOutData));
	Register #(Width+1) LastReg(.Clock(Clock), .Reset(Reset | Done), .Set(1'b0), .Enable(1'b1), .In({~CUTOutTransfer & Running & CUTOutValid, CUTOutData}), .Out({LastDCValid, LastCUTOutData}));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Report Counters & Registers
	//--------------------------------------------------------------------------
	Register #(RWidth) BufReg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable((CurrentState == STATE_Fill) & Timeout), .In(WriteCount[RWidth-1:0]), .Out(ReportBuffering));
	Counter #(RWidth) FWCnt(.Clock(Clock), .Reset(Reset | ReportTransfer), .Set(1'b0), .Load(1'b0), .Enable((CurrentState == STATE_Fill) & ~CUTOutValid), .In({RWidth{1'bx}}), .Count(ReportFWLatency));
	Counter #(RWidth) BWCnt(.Clock(Clock), .Reset(Reset | ReportTransfer), .Set(1'b0), .Load(1'b0), .Enable((CurrentState == STATE_Drain) & ~CUTInReady), .In({RWidth{1'bx}}), .Count(ReportBWLatency));
	Counter #(RWidth) ErrCnt(.Clock(Clock), .Reset(Reset | ReportTransfer), .Set(1'b0), .Load(1'b0), .Enable(ErrorInc), .In({RWidth{1'bx}}), .Count(ReportErrorCount));
	Counter #(RWidth) DCCnt(.Clock(Clock), .Reset(Reset | ReportTransfer), .Set(1'b0), .Load(1'b0), .Enable(DataChangeInc), .In({RWidth{1'bx}}), .Count(ReportDataChange));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Spurious Status Change Check Registers
	//--------------------------------------------------------------------------
	Register #(1) FWDReg(.Clock(Clock), .Reset(Reset | ReportTransfer), .Set((CurrentState == STATE_Fill) & CUTOutValid), .Enable(1'b0), .In(1'bx), .Out(FillComplete));
	Register #(1) FWSReg(.Clock(Clock), .Reset(Reset | ReportTransfer), .Set((CurrentState == STATE_Fill) & FillComplete & ~CUTOutValid), .Enable(1'b0), .In(1'bx), .Out(ReportSpurious[0]));
	Register #(1) BWDReg(.Clock(Clock), .Reset(Reset | ReportTransfer), .Set((CurrentState == STATE_Drain) & CUTInReady), .Enable(1'b0), .In(1'bx), .Out(DrainComplete));
	Register #(1) BWSReg(.Clock(Clock), .Reset(Reset | ReportTransfer), .Set((CurrentState == STATE_Drain) & DrainComplete & ~CUTInReady), .Enable(1'b0), .In(1'bx), .Out(ReportSpurious[1]));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Tester/FIFOStress.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOStress
//	Desc:		A circuit designed to stress a FIFO at various base occupancy
//				and offered load rates.  This circuit runs a complete battery
//				of stress tests, looking for errors as well as collecting
//				simple performance data to help check for subtle timing bugs.
//				This circuit relies on knowing certain timing characteristics
//				of the FIFO which can be determined by FIFOMeasure.  This
//				circuit is started with a pulse, and will report done similarly.
//				Results are reported using a FIFO interface at the end of each
//				test iteration and consist of performance and error counts.
//				See FIFOTester and the FIFO documentation for more information.
//	Params:		Width:	The data width of the FIFO.
//				NTests:	The number of times to repeat the rate divisor period
//						during each test, larger values should bring the expected
//						data rate and actual data rate closer together.
//				EstMaxLatency: The estimated maximum latency of the FIFO.  An
//						overestimate is preferable to an underestimate, as this
//						is used to size the result counters.
//				RWidth:	The width of the reports, by default this is
//						calculated from the estimated values above.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOStress(
			//------------------------------------------------------------------
			//	Control Signals
			//------------------------------------------------------------------
			Clock,
			Reset,
			Start,
			Done,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	FIFO (Circuit Under Test) Interface
			//------------------------------------------------------------------
			CUTInData,
			CUTInValid,
			CUTInReady,
			
			CUTOutData,
			CUTOutValid,
			CUTOutReady,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Parameter I/O (Must be held constant)
			//------------------------------------------------------------------
			MaxBuffering,
			MinFWLatency,
			MaxFWLatency,
			MinBWLatency,
			MaxBWLatency,
			ReportCycleCount,
			ReportRateDivisor,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Report Interface
			//------------------------------------------------------------------
			ReportOccupancy,
			ReportRateDividend,
			ReportWriteCount,
			ReportReadCount,
			ReportErrorCount,
			ReportDataChange,
			ReportValid,
			ReportReady
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	parameter				Width =					32,
							NTests =				4,
							EstMaxLatency =			32,
							PadEnable =				0,
							PadValue =				{Width{1'bx}},
							TestDivShift =			3,
							RWidth =				`log2(EstMaxLatency * NTests) + 5;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				NWidth =				`log2(NTests),
							WCWidth =				`max(RWidth, Width);
	`endif
	localparam				STATE_Done =			3'b000,
							STATE_DivideStart =		3'b001,
							STATE_Fill =			3'b010,
							STATE_DivideWait =		3'b011,
							STATE_Run =				3'b100,
							STATE_Drain =			3'b101,
							STATE_Report =			3'b110;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Control Signals
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	input					Start;
	output					Done;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	FIFO (Circuit Under Test) Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		CUTInData;
	output					CUTInValid;
	input					CUTInReady;

	input	[Width-1:0]		CUTOutData;
	input					CUTOutValid;
	output					CUTOutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Parameter I/O (Must be held constant)
	//--------------------------------------------------------------------------
	input	[RWidth-1:0]	MaxBuffering;
	input	[RWidth-1:0]	MinFWLatency, MaxFWLatency;
	input	[RWidth-1:0]	MinBWLatency, MaxBWLatency;
	output	[RWidth-1:0]	ReportCycleCount;
	output	[RWidth-1:0]	ReportRateDivisor;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Report Interface
	//--------------------------------------------------------------------------
	output	[RWidth-1:0]	ReportOccupancy, ReportRateDividend, ReportWriteCount, ReportReadCount, ReportErrorCount, ReportDataChange;
	output					ReportValid;
	input					ReportReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[NWidth-1:0]	TestCount;
	wire	[WCWidth-1:0]	WriteCount, WriteModulo;
	wire	[RWidth-1:0]	CycleCount, CycleMax, Occupancy, RateDividend;
	wire	[RWidth-1:0]	OccupancyMax, RateDividendMax, OccupancyInc, RateDividendInc, OccupancyNext, RateDividendNext;
	
	wire					Write, Read;
	wire	[Width-1:0]		LastCUTOutData, PrevCUTOutData, ExpectedCUTOutData;
	wire					Skip, Match;
	wire					ErrorInc, ReadInc, DataChangeInc;
	
	reg		[2:0]			CurrentState, NextState;
	wire					TestTerminal, CycleRunTerminal, CycleDrainTerminal, OccupancyTerminal, RateDividendTerminal;
	wire					Running, Draining, CycleEnable;
	wire					ReportTransfer, CUTInTransfer, CUTOutTransfer, LastDCValid;
	
	wire					WriteDivideValid, ReadDivideValid, WriteDivideReady, ReadDivideReady;
	wire					DivideValid, DivideReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assign Statements
	//--------------------------------------------------------------------------
	assign	Done =									OccupancyTerminal & RateDividendTerminal & ReportTransfer;
	assign	CUTInValid =							(CurrentState == STATE_Fill) | (Running & Write) | (Draining & (|WriteModulo));
	assign	CUTInData =								WriteCount[Width-1:0];
	assign	CUTOutReady =							(Running & Read) | Draining;
	assign	ReportValid =							(CurrentState == STATE_Report);
	
	assign	ExpectedCUTOutData =					PrevCUTOutData+1;
	assign	Skip =									PadEnable ? (PadValue === CUTOutData) : 1'b0;
	assign	Match =									(ExpectedCUTOutData == CUTOutData);
	assign	ErrorInc =								~Match & ~Skip & CUTOutTransfer;
	assign	ReadInc =								Running & (Match | ~Skip) & CUTOutTransfer;
	assign	DataChangeInc =							(LastCUTOutData != CUTOutData) & CUTOutValid & LastDCValid & Running;
	
	assign	CycleMax =								(~|ReportCycleCount) ? 0 : (ReportCycleCount - 1);
	assign	CycleRunTerminal =						(CycleCount == CycleMax) & CycleEnable;
	assign	CycleDrainTerminal =					(CycleCount == {CycleMax[RWidth-2:0], 1'b0}) & CycleEnable;
	assign	OccupancyTerminal =						OccupancyNext > MaxBuffering;
	assign	RateDividendTerminal =					(RateDividendNext > (MaxBuffering - 1)) | (RateDividendNext > (MinFWLatency + MinBWLatency));
	
	assign	Running =								(CurrentState == STATE_Run);
	assign	Draining =								(CurrentState == STATE_Drain);
	assign	CycleEnable =							Running | (Draining & CUTInReady & ~CUTOutValid);
	assign	ReportTransfer =						ReportReady & ReportValid;
	assign	CUTInTransfer =							CUTInValid & CUTInReady;
	assign	CUTOutTransfer =						CUTOutValid & CUTOutReady;
	
	assign	DivideValid =							WriteDivideValid & ReadDivideValid;
	assign	DivideReady =							WriteDivideReady & ReadDivideReady;
	
	assign	ReportCycleCount =						MaxFWLatency + MaxBWLatency + MaxBuffering;
	assign	ReportRateDivisor =						MinFWLatency + MinBWLatency;
	assign	ReportOccupancy =						Occupancy;
	assign	ReportRateDividend =					RateDividend;
	assign	ReportWriteCount =						WriteCount - Occupancy;
	
	assign	OccupancyMax =							MaxBuffering;
	assign	RateDividendMax =						(MaxBuffering - 1) | (MinFWLatency + MinBWLatency);
	generate if (RWidth > TestDivShift) begin:INCDIV
		assign	OccupancyInc =						(~|OccupancyMax[RWidth-1:TestDivShift]) ? 1 : {{TestDivShift{1'b0}}, OccupancyMax[RWidth-1:TestDivShift]};
		assign	RateDividendInc =					(~|RateDividendMax[RWidth-1:TestDivShift]) ? 1 : {{TestDivShift{1'b0}}, RateDividendMax[RWidth-1:TestDivShift]};
	end else begin:INCONE
		assign	OccupancyInc =						1;
		assign	RateDividendInc =					1;
	end endgenerate
	assign	OccupancyNext =							Occupancy + OccupancyInc;
	assign	RateDividendNext =						RateDividend + RateDividendInc;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	FSM
	//--------------------------------------------------------------------------
	always @ (posedge Clock) begin
		if (Reset | Done) CurrentState <=			STATE_Done;
		else CurrentState <=						NextState;
	end
	
	always @ (*) begin
		case (CurrentState)
			STATE_Done: NextState =					Start ? STATE_DivideStart : STATE_Done;
			STATE_DivideStart: NextState =			DivideReady ? ((~|Occupancy) ? STATE_DivideWait : STATE_Fill) : STATE_DivideStart;
			STATE_Fill: NextState =					(WriteCount == (Occupancy - 1)) ? STATE_DivideWait : STATE_Fill;
			STATE_DivideWait: NextState =			(DivideValid & DivideReady) ? STATE_Run : STATE_DivideWait;
			STATE_Run: NextState =					(CycleRunTerminal & TestTerminal) ? STATE_Drain : STATE_Run;
			STATE_Drain: NextState =				CycleDrainTerminal ? STATE_Report : STATE_Drain;
			STATE_Report: NextState =				ReportReady ? (Done ? STATE_Done : STATE_DivideStart) : STATE_Report;
		endcase
	end
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Test Iteration Counter
	//--------------------------------------------------------------------------
	Counter			#(			.Width(				NWidth))
					TestCnt(	.Clock(				Clock),
								.Reset(				Reset | Done | ReportTransfer),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			CycleRunTerminal & Running),
								.In(				{NWidth{1'bx}}),
								.Count(				TestCount));
	CountCompare	#(			.Width( 			NWidth),
								.Compare(			NTests - 1))
					TCCmp(		.Count(				TestCount),
								.TerminalCount(		TestTerminal));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Cycle Counter
	//--------------------------------------------------------------------------
	Counter			#(			.Width(				RWidth))
					CycleCnt(	.Clock(				Clock),
								.Reset(				Reset | Done | ((CycleRunTerminal & Running) | (CycleDrainTerminal & Draining)) | (Draining & (|WriteModulo | CUTOutValid))),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			CycleEnable),
								.In(				{RWidth{1'bx}}),
								.Count(				CycleCount));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Occupancy Counter
	//--------------------------------------------------------------------------
	Register		#(			.Width(				RWidth))
					OccCnt(		.Clock(				Clock),
								.Reset(				Reset | Done),
								.Set(				1'b0),
								.Enable(			RateDividendTerminal & ReportTransfer),
								.In(				OccupancyNext),
								.Out(				Occupancy));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Rate Dividend Counter
	//--------------------------------------------------------------------------
	Register		#(			.Width(				RWidth),
								.ResetValue(		{{RWidth-1{1'b0}}, 1'b1}))
					RDCnt(		.Clock(				Clock),
								.Reset(				Reset | Done | (RateDividendTerminal & ReportTransfer)),
								.Set(				1'b0),
								.Enable(			ReportTransfer),
								.In(				RateDividendNext),
								.Out(				RateDividend));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Random Sequence Generators
	//--------------------------------------------------------------------------
	RandomBits #(RWidth, 32'h243b807f) WriteBits(.Clock(Clock), .Reset(Reset), .Dividend(RateDividend), .Divisor(ReportRateDivisor), .InValid(DivideReady & (CurrentState == STATE_DivideStart)), .InReady(WriteDivideReady), .OutBits(Write), .OutValid(WriteDivideValid), .OutReady(Running | (CurrentState == STATE_DivideWait)));
	RandomBits #(RWidth, 32'h3975d5d5) ReadBits(.Clock(Clock), .Reset(Reset), .Dividend(RateDividend), .Divisor(ReportRateDivisor), .InValid(DivideReady & (CurrentState == STATE_DivideStart)), .InReady(ReadDivideReady), .OutBits(Read), .OutValid(ReadDivideValid), .OutReady((Running & ~(Read & ~Match & Skip)) | (CurrentState == STATE_DivideWait)));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Test Data Counter & Register
	//--------------------------------------------------------------------------
	Counter #(WCWidth) WriteCnt(.Clock(Clock), .Reset(Reset | Done | ReportTransfer), .Set(1'b0), .Load(1'b0), .Enable(CUTInTransfer), .In({WCWidth{1'bx}}), .Count(WriteCount));
	Register #(Width) PrevReg(.Clock(Clock), .Reset(1'b0), .Set(Reset | Done | ReportTransfer), .Enable((~Skip | Match) & CUTOutTransfer), .In(CUTOutData), .Out(PrevCUTOutData));
	Register #(Width+1) LastReg(.Clock(Clock), .Reset(Reset | Done), .Set(1'b0), .Enable(1'b1), .In({~CUTOutTransfer & Running & CUTOutValid, CUTOutData}), .Out({LastDCValid, LastCUTOutData}));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Write Module Counter
	//--------------------------------------------------------------------------
	Counter #(WCWidth) WriteMod(.Clock(Clock), .Reset(Reset | Done | ReportTransfer | ((WriteModulo == (MaxBuffering - 1)) & CUTInTransfer)), .Set(1'b0), .Load(1'b0), .Enable(CUTInTransfer), .In({WCWidth{1'bx}}), .Count(WriteModulo));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Report Counters
	//--------------------------------------------------------------------------
	Counter #(RWidth) ErrCnt(.Clock(Clock), .Reset(Reset | ReportTransfer), .Set(1'b0), .Load(1'b0), .Enable(ErrorInc), .In({RWidth{1'bx}}), .Count(ReportErrorCount));
	Counter #(RWidth) ReadCnt(.Clock(Clock), .Reset(Reset | ReportTransfer), .Set(1'b0), .Load(1'b0), .Enable(ReadInc), .In({RWidth{1'bx}}), .Count(ReportReadCount));
	Counter #(RWidth) DCCnt(.Clock(Clock), .Reset(Reset | ReportTransfer), .Set(1'b0), .Load(1'b0), .Enable(DataChangeInc), .In({RWidth{1'bx}}), .Count(ReportDataChange));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Gateware/FIFOs/Hardware/Tester/FIFOTester.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FIFOTester
//	Desc:		This circuit is designed to completely test a FIFO, first by
//				measuring its timing characteristics and then by stress
//				testing it under a range of base occupancies and offered load
//				rates.  Results are reported on separate FIFO outputs, and
//				test control is done by way the Start and Done pulse signals.
//				See FIFOMeasure, FIFOStress and the complete FIFO documentation
//				for more information.
//	Params:		Width:	The data width of the FIFO.
//				EstMaxLatency: The estimated maximum latency of the FIFO.  An
//						overestimate is preferable to an underestimate, as this
//						is used to size the result counters.
//				EstMaxBuffering The estimated maximum buffering of the FIFO.  An
//						overestimate is preferable to an underestimate, as this
//						is used to size the result counters.
//				RWidth:	The width of the reports, by default this is
//						calculated from the estimated values above.
//				NTests:	Number of times to run the tests (measurement and
//						stress both).
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FIFOTester(
			//------------------------------------------------------------------
			//	Control Signals
			//------------------------------------------------------------------
			Clock,
			Reset,
			Start,
			Done,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	FIFO (Circuit Under Test) Interface
			//------------------------------------------------------------------
			CUTInData,
			CUTInValid,
			CUTInReady,
			
			CUTOutData,
			CUTOutValid,
			CUTOutReady,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Measure Interface
			//------------------------------------------------------------------
			MeasureFWLatency,
			MeasureBuffering,
			MeasureBWLatency,
			MeasureErrorCount,
			MeasureDataChange,
			MeasureSpurious,
			MeasureValid,
			MeasureReady,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Stress Test Constants
			//------------------------------------------------------------------
			StressCycleCount,
			StressRateDivisor,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Stress Interface
			//------------------------------------------------------------------
			StressOccupancy,
			StressRateDividend,
			StressWriteCount,
			StressReadCount,
			StressErrorCount,
			StressDataChange,
			StressValid,
			StressReady
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	parameter				Width =					32,
							EstMaxLatency =			32,
							EstMaxBuffering =		1,
							LimitMaxBuffering =		0,
							NTests =				16,
							PadEnable =				0,
							PadValue =				{Width{1'bx}},
							TestDivShift =			3,
							RWidth =				`max(`log2(`max(EstMaxLatency, EstMaxBuffering)), `log2(EstMaxLatency * NTests) + 1) + 4;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Control Signals
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	input					Start;
	output					Done;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	FIFO (Circuit Under Test) Interface
	//--------------------------------------------------------------------------
	output	[Width-1:0]		CUTInData;
	output					CUTInValid;
	input					CUTInReady;

	input	[Width-1:0]		CUTOutData;
	input					CUTOutValid;
	output					CUTOutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Measure Interface
	//--------------------------------------------------------------------------
	output	[RWidth-1:0]	MeasureFWLatency, MeasureBuffering, MeasureBWLatency, MeasureErrorCount, MeasureDataChange;
	output	[1:0]			MeasureSpurious;
	output					MeasureValid;
	input					MeasureReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Stress Test Constants
	//--------------------------------------------------------------------------
	output	[RWidth-1:0]	StressCycleCount;
	output	[RWidth-1:0]	StressRateDivisor;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Stress Interface
	//--------------------------------------------------------------------------
	output	[RWidth-1:0]	StressOccupancy, StressRateDividend, StressWriteCount, StressReadCount, StressErrorCount, StressDataChange;
	output					StressValid;
	input					StressReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					Select;
	
	wire	[Width-1:0]		MeasureInData;
	wire					MeasureInValid, MeasureOutReady, MeasureDone;
	
	wire	[Width-1:0]		StressInData;
	wire					StressInValid, StressOutReady, StressDone;
	
	wire					MeasureTransfer, MeasureGate;
	wire	[RWidth-1:0]	MaxBuffering;
	wire	[RWidth-1:0]	MinFWLatency;
	wire	[RWidth-1:0]	MaxFWLatency;
	wire	[RWidth-1:0]	MinBWLatency;
	wire	[RWidth-1:0]	MaxBWLatency;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assign Statements
	//--------------------------------------------------------------------------
	assign	CUTInData =								Select ? StressInData : MeasureInData;
	assign	CUTInValid =							Select ? StressInValid : MeasureInValid;
	assign	CUTOutReady =							Select ? StressOutReady : MeasureOutReady;
	
	assign	Done =									StressDone;
	
	assign	MeasureTransfer =						MeasureValid & MeasureReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Mux Select Register
	//--------------------------------------------------------------------------
	Register #(1) SelectReg(.Clock(Clock), .Reset(Reset | StressDone), .Set(MeasureDone), .Enable(1'b0), .In(1'bx), .Out(Select));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Measurement Logic
	//--------------------------------------------------------------------------
	FIFOMeasure		Measure(	.Clock(				Clock),
								.Reset(				Reset),
								.Start(				Start & ~Select),
								.Done(				MeasureDone),
								.CUTInData(			MeasureInData),
								.CUTInValid(		MeasureInValid),
								.CUTInReady(		CUTInReady & ~Select),
								.CUTOutData(		CUTOutData),
								.CUTOutValid(		CUTOutValid & ~Select),
								.CUTOutReady(		MeasureOutReady),
								.ReportFWLatency(	MeasureFWLatency),
								.ReportBuffering(	MeasureBuffering),
								.ReportBWLatency(	MeasureBWLatency),
								.ReportErrorCount(	MeasureErrorCount),
								.ReportDataChange(	MeasureDataChange),
								.ReportSpurious(	MeasureSpurious),
								.ReportValid(		MeasureValid),
								.ReportReady(		MeasureReady));
	defparam		Measure.Width =					Width;
	defparam		Measure.EstMaxLatency =			EstMaxLatency;
	defparam		Measure.EstMaxBuffering =		EstMaxBuffering;
	defparam		Measure.LimitMaxBuffering =		LimitMaxBuffering;
	defparam		Measure.PadEnable =				PadEnable;
	defparam		Measure.PadValue =				PadValue;
	defparam		Measure.RWidth =				RWidth;
	defparam		Measure.NTests =				NTests;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Stress Logic
	//--------------------------------------------------------------------------
	FIFOStress		Stress(		.Clock(				Clock),
								.Reset(				Reset),
								.Start(				MeasureDone),
								.Done(				StressDone),
								.CUTInData(			StressInData),
								.CUTInValid(		StressInValid),
								.CUTInReady(		CUTInReady & Select),
								.CUTOutData(		CUTOutData),
								.CUTOutValid(		CUTOutValid & Select),
								.CUTOutReady(		StressOutReady),
								.MaxBuffering(		MaxBuffering),
								.MinFWLatency(		MinFWLatency),
								.MaxFWLatency(		MaxFWLatency),
								.MinBWLatency(		MinBWLatency),
								.MaxBWLatency(		MaxBWLatency),
								.ReportCycleCount(	StressCycleCount),
								.ReportRateDivisor(	StressRateDivisor),
								.ReportOccupancy(	StressOccupancy),
								.ReportRateDividend(StressRateDividend),
								.ReportWriteCount(	StressWriteCount),
								.ReportReadCount(	StressReadCount),
								.ReportErrorCount(	StressErrorCount),
								.ReportDataChange(	StressDataChange),
								.ReportValid(		StressValid),
								.ReportReady(		StressReady));
	defparam		Stress.Width =					Width;
	defparam		Stress.NTests =					NTests;
	defparam		Stress.EstMaxLatency =			EstMaxLatency;
	defparam		Stress.PadEnable =				PadEnable;
	defparam		Stress.PadValue =				PadValue;
	defparam		Stress.TestDivShift =			TestDivShift;
	defparam		Stress.RWidth =					RWidth;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Bound Registers
	//--------------------------------------------------------------------------
	Register		#(			.Width(				1))
					MGReg(		.Clock(				Clock),
								.Reset(				Reset | Done),
								.Set(				MeasureTransfer),
								.Enable(			1'b0),
								.In(				1'bx),
								.Out(				MeasureGate));
	
	Register #(RWidth) MBReg(.Clock(Clock), .Reset(Reset | Done), .Set(1'b0), .Enable(MeasureGate & MeasureTransfer & (MaxBuffering < MeasureBuffering)), .In(MeasureBuffering), .Out(MaxBuffering));
	Register #(RWidth) LFLReg(.Clock(Clock), .Reset(1'b0), .Set(Reset | Done), .Enable(MeasureGate & MeasureTransfer & (MinFWLatency > MeasureFWLatency)), .In(MeasureFWLatency), .Out(MinFWLatency));
	Register #(RWidth) GFLReg(.Clock(Clock), .Reset(Reset | Done), .Set(1'b0), .Enable(MeasureGate & MeasureTransfer & (MaxFWLatency < MeasureFWLatency)), .In(MeasureFWLatency), .Out(MaxFWLatency));
	Register #(RWidth) LBLReg(.Clock(Clock), .Reset(1'b0), .Set(Reset | Done), .Enable(MeasureGate & MeasureTransfer & (MinBWLatency > MeasureBWLatency)), .In(MeasureBWLatency), .Out(MinBWLatency));
	Register #(RWidth) GBLReg(.Clock(Clock), .Reset(Reset | Done), .Set(1'b0), .Enable(MeasureGate & MeasureTransfer & (MaxBWLatency < MeasureBWLatency)), .In(MeasureBWLatency), .Out(MaxBWLatency));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Arbiter/Arbiter.v $
//	Version:	$Revision: 11963 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Arbiter
//	Desc:		A simple arbiter with a standard request grant interface for a
//				variable number of ports.  Please note that FIFOArbiter,
//				in the FIFOs subproject, provides Valid/Ready interfaces.
//	Params:		NPorts:	The number of ports on this arbiter.
//				Policy:	0 - Round Robin
//						1 - Priority Logic
//						2 - Select Any (Don't Care, fast implementation)
//						3 - Cyclic (wait for the next port, no actual arbitration)
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11963 $
//------------------------------------------------------------------------------
module	Arbiter(Clock, Reset, Request, Grant, Locked);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				NPorts =		 		2,
							Policy =				0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[NPorts-1:0]	Request;
	output	[NPorts-1:0]	Grant;
	output					Locked;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					OneValid, Done;
	wire	[NPorts-1:0]	NextSelect, PrevSelect;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	OneValid =								~Locked ? (|Request) : (|(Request & PrevSelect));
	assign	Done =									~|(Request & Grant);
	assign	Grant =									~Locked ? NextSelect : PrevSelect;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Variable Policy Priority Selector
	//--------------------------------------------------------------------------
	generate if (Policy == 0) begin:RR
		RoundRobinSelect #(		.Width(				NPorts))
					Select(		.Valid(				Request),
								.PrevSelect(		PrevSelect),
								.Select(			NextSelect));
	end else if ((Policy == 1) || (Policy == 2)) begin:PRI
		PrioritySelect #(		.Width(				NPorts))
					Select(		.Valid(				Request),
								.Select(			NextSelect));
	end else if (Policy == 3) begin:CYC
		CyclicSelect #(			.Width(				NPorts))
					Select(		.PrevSelect(		PrevSelect),
								.Select(			NextSelect));
	end else begin
		initial begin
			$display("ERROR[%m @ %t]: Unknown arbitration policy!", $time);
			$stop;
		end
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Lock State Register 
	//--------------------------------------------------------------------------
	Register		#(			.Width(				1),
								.Initial(			1'bx),
								.AsyncReset(		0),
								.AsyncSet(			0),
								.ResetValue(		1'b0),
								.SetValue(			1'b1))
					LSR(		.Clock(				Clock),
								.Reset(				Reset | (Done & OneValid)),
								.Set(				OneValid),
								.Enable(			1'b0),
								.In(				1'bx),
								.Out(				Locked));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Previous Select Logic
	//--------------------------------------------------------------------------
	generate if (NPorts > 1) begin:PREVREG
		Register	#(			.Width(				NPorts),
								.Initial(			{NPorts{1'bx}}),
								.AsyncReset(		0),
								.AsyncSet(			0),
								.ResetValue(		{NPorts{1'b0}}),
								.SetValue(			{NPorts{1'b1}}))
					PrevReg(	.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				1'b0),
								.Enable(			Reset | ((Done | ~Locked) & OneValid)),
								.In(				Reset ? {1'b1, {NPorts-1{1'b0}}} : Grant),
								.Out(				PrevSelect));
	end else begin:PREVWIRE
		assign	PrevSelect =						1'b1;
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Arbiter/CyclicSelect.v $
//	Version:	$Revision: 11964 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		CyclicSelect
//	Desc:		A simple, stupid selector which will always select the port
//				after the previous one, in a cycle, even if it is not valid.
//	Params:		Width:	The number of ports on this selector's input.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11964 $
//------------------------------------------------------------------------------
module CyclicSelect(PrevSelect, Select);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =		 			4;
	//--------------------------------------------------------------------------

	//---------------------------------------------------------------------
	//	I/O
	//---------------------------------------------------------------------
	input	[Width-1:0]		PrevSelect;
	output	[Width-1:0]		Select;
	//---------------------------------------------------------------------
	
	//---------------------------------------------------------------------
	//	Assigns
	//---------------------------------------------------------------------
	generate if (Width > 1) begin:MANY
		assign	Select =							{PrevSelect[Width-2:0], PrevSelect[Width-1]};
	end else begin:ONE
		assign	Select =							1'b1;
	end endgenerate
	//---------------------------------------------------------------------
endmodule
//-------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Arbiter/PrioritySelect.v $
//	Version:	$Revision: 11964 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		PrioritySelect
//	Desc:		This module provides straight priority select implementation.
//				It is encapsulated so that language and synthesis tool changes
//				can be isolated from major designs.  Takes a many-hot input
//				and generates a one-hot (or none-hot) output, where the output
//				which is hot will be the lowest index input which was asserted.
//	Params:		Width:	The number of ports on this selector's input.
//				LUTWidth:The width of the FPGA LUTs for the device to which this
//						instance will be synthesized.  If 0 the synthesis tool
//						is fed a purely behavioral construct, but if non-0, this
//						module will (hopefully) be highly optimized.  Note that
//						the optimal value for an FPGA may be slightly more or
//						less than the LUTWidth on that FPGA thanks to retiming
//						and general synthesis optimizations.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11964 $
//------------------------------------------------------------------------------
module	PrioritySelect(Valid, Select);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =		 			2,
							LUTWidth =				0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				LUTWidth1 =				`max(LUTWidth, 1),	// Avoid div by 0, parameters aren't used with LUTWidth == 0 anyway
							FullGroups =			Width / LUTWidth1,
							LastGroup =				Width % LUTWidth1,
							Groups =				`divceil(Width, LUTWidth1);
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		Valid;
	output	[Width-1:0]		Select;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires and Regs
	//--------------------------------------------------------------------------
	reg						Found;
	reg		[Width-1:0]		SelectReg;
	integer					i;
	genvar					j;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Priority Selection
	//--------------------------------------------------------------------------
	generate if ((LUTWidth == 0) || (LUTWidth >= Width)) begin:BEHAV
		always @ (*) begin
			Found =									0;
			for (i = 0; i < Width; i = i + 1) begin
				if (~Found) begin
					SelectReg[i] =					Valid[i];
					Found =							Valid[i];
				end
				else SelectReg[i] =					1'b0;
			end
		end
		
		assign	Select =							SelectReg;
	end else begin:OPT
		wire	[Width-1:0]	Intermediate;
		wire	[Groups-1:0]GroupHot, GroupSelect;
	
		for (j = 0; j < FullGroups; j = j + 1) begin:FULLGROUP
			PrioritySelect #(LUTWidth, LUTWidth) PS(.Valid(Valid[(j*LUTWidth)+LUTWidth-1:j*LUTWidth]), .Select(Intermediate[(j*LUTWidth)+LUTWidth-1:j*LUTWidth]));
			assign Select[(j*LUTWidth)+LUTWidth-1:j*LUTWidth] = Intermediate[(j*LUTWidth)+LUTWidth-1:j*LUTWidth] & {LUTWidth{GroupSelect[j]}};
			assign GroupHot[j] = |Valid[(j*LUTWidth)+LUTWidth-1:j*LUTWidth];
		end
		
		if (LastGroup > 0) begin:LASTGROUP
			PrioritySelect(.Valid(Valid[(FullGroups*LUTWidth)+LastGroup-1:FullGroups*LUTWidth]), .Select(Intermediate[(FullGroups*LUTWidth)+LastGroup-1:FullGroups*LUTWidth]));
			assign Select[(FullGroups*LUTWidth)+LastGroup-1:FullGroups*LUTWidth] = Intermediate[(FullGroups*LUTWidth)+LastGroup-1:FullGroups*LUTWidth] & {LastGroup{GroupSelect[FullGroups]}};
			assign GroupHot[FullGroups] = |Valid[(FullGroups*LUTWidth)+LastGroup-1:FullGroups*LUTWidth];
		end
		
		PrioritySelect	#(			.Width(				Groups),
									.LUTWidth(			LUTWidth))
						PS(			.Valid(				GroupHot),
									.Select(			GroupSelect));
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Arbiter/RoundRobinSelect.v $
//	Version:	$Revision: 11964 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		RoundRobinSelect
//	Desc:		This is an efficient implementation of round-robin priority
//				selector.  It accepts one-hot inputs one the Valid, along with
//				it's previous selection on the PrevSelect bus and then applies
//				the round robin scheduling algorithm to "Select" one of the
//				Valid inputs.
//	Params:		Width:	The number of ports on this selector's input.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11964 $
//------------------------------------------------------------------------------
module RoundRobinSelect(Valid, PrevSelect, Select);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =		 			4;
	//--------------------------------------------------------------------------

	//---------------------------------------------------------------------
	//	I/O
	//---------------------------------------------------------------------
	input	[Width-1:0]		Valid, PrevSelect;
	output	[Width-1:0]		Select;
	//---------------------------------------------------------------------

	//---------------------------------------------------------------------
	//	Wires
	//---------------------------------------------------------------------
	wire	[Width:0]		PassSelectL0;
	wire	[Width-1:0]		PassSelectL1;
	//---------------------------------------------------------------------

	//---------------------------------------------------------------------
	//	Assigns
	//---------------------------------------------------------------------
	// This module makes use of that fact that for many implementation
	// technologies adders are surprisingly fast (e.g. fast carry chains
	// and such on Xilinx FPGAs).  A carry signal is therefore use to
	// propagate the selection signal.  Two passes across the input
	// bitwidth are needed in order to avoid a combinational loop which
	// many synthesis tools cannot handle.
	generate if (Width > 1) begin:RR
		assign	PassSelectL0 =						{1'b0, ~Valid} + {1'b0, PrevSelect[Width-2:0], PrevSelect[Width-1]};
		assign	PassSelectL1 =						(~Valid) + 1;
		assign	Select =							(PassSelectL0[Width] ? PassSelectL1 : PassSelectL0[Width-1:0]) & Valid;
	end else begin:SIMPLE
		assign	Select =							Valid;
	end endgenerate
	//---------------------------------------------------------------------
endmodule
//-------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Code/Bin2Gray.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Bin2Gray
//	Desc:		This is a simple binary to gray code converter
//	Params:		Width:		The width of the binary/gray code
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	Bin2Gray(Bin, Gray);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					8;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		Bin;
	output	[Width-1:0]		Gray;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	genvar					i;
	//--------------------------------------------------------------------------
  
	//--------------------------------------------------------------------------
	//	Converter
	//--------------------------------------------------------------------------
	generate for(i = 0; i < (Width - 1); i = i + 1) begin:B2G
		assign	Gray[i] =							^Bin[i+1:i];
	end endgenerate
	assign	Gray[Width-1] =							Bin[Width-1];
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Code/Bin2HexASCII.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Bin2HexASCII
//	Desc:		This module is a pretty simple behavioral ROM which can be used
//				to convert 4-bit binary into 8bit ASCII character.
//	Params:		UpperCase:	If 1'b1, use uppercase chars
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	Bin2HexASCII(Bin, ASCII);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				UpperCase =				1;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[3:0]			Bin;
	output	[7:0]			ASCII;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[2:0]			Letter;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	Letter =								Bin[2:0] + 7;
	assign	ASCII =									(Bin[3] & |Bin[2:1]) ? {(UpperCase ? 4'h4 : 4'h6), 1'b0, Letter} : {4'h3, Bin};
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Code/Bin2HexLED.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Bin2HexLED
//	Desc:		This module is a pretty simple behavioral ROM which can be used
//				to convert 4-bit binary into 7segment driver signals.
//	Output:		[6:0] = {gfedcba}
//					   a
//					  ---
//					f|   |b
//					  ---
//					e| g |c
//					  ---
//					   d
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module Bin2HexLED(Bin, SegLED);
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[3:0]			Bin;
	output reg [6:0]		SegLED;
	//--------------------------------------------------------------------------
  
	//--------------------------------------------------------------------------
	//	Converter ROM
	//--------------------------------------------------------------------------
	always @ (Bin) begin
		case (Bin)
			4'h0: SegLED =							7'b0111111;
			4'h1: SegLED =							7'b0000110;
			4'h2: SegLED =							7'b1011011;
			4'h3: SegLED =							7'b1001111;
			4'h4: SegLED =							7'b1100110;
			4'h5: SegLED =							7'b1101101;
			4'h6: SegLED =							7'b1111101;
			4'h7: SegLED =							7'b0000111;
			4'h8: SegLED =							7'b1111111;
			4'h9: SegLED =							7'b1100111;
			4'hA: SegLED =							7'b1110111;
			4'hB: SegLED =							7'b1111100;
			4'hC: SegLED =							7'b1011000;
			4'hD: SegLED =							7'b1011110;
			4'hE: SegLED =							7'b1111001;
			4'hF: SegLED =							7'b1110001;
			default: SegLED =						{7{1'bx}};
		endcase
	end
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Code/Bin2OneHot.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Bin2OneHot
//	Desc:		This is a simple binary to one hot converter.
//	Params:		Width:	The width of the one-hot output.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	Bin2OneHot(Bin, OneHot);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					8;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				BWidth =				`max(`log2(Width), 1);
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[BWidth-1:0]	Bin;
	output reg [Width-1:0]	OneHot;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Regs
	//--------------------------------------------------------------------------
	integer					i;
	//--------------------------------------------------------------------------
  
	//--------------------------------------------------------------------------
	//	Converter
	//--------------------------------------------------------------------------
	always @ (Bin) begin
		for (i = 0; i < Width; i = i + 1) OneHot[i] = (Bin == i);
	end
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Code/Gray2Bin.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Gray2Bin
//	Desc:		This is a simple gray code to binary converter
//	Params:		Width:		The width of the binary/gray code
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	Gray2Bin(Gray, Bin);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					8;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		Gray;
	output	[Width-1:0]		Bin;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Regs
	//--------------------------------------------------------------------------
	genvar					i;
	//--------------------------------------------------------------------------
  
	//--------------------------------------------------------------------------
	//	Converter
	//--------------------------------------------------------------------------
	generate for(i = 0; i < Width; i = i + 1) begin:G2B
		assign	Bin[i] =							^Gray[Width-1:i];
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Code/Hamming/HammingCode.v $
//	Version:	$Revision: 12029 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		HammingCode
//	Desc:		This is a variable width hamming code generator.  It takes in
//				a hamming code word, and calculates the syndrome or parity
//				bits based on the data bits of the incoming code word.  The
//				parity bits of the incoming code word are ignored.
//	Params:		CWidth:		The width of the code input
//				SWidth:		The width of the syndrome output
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12029 $
//------------------------------------------------------------------------------
module	HammingCode(Code, Syndrome);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				CWidth =				8,
							SWidth =				4;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[CWidth-1:0]	Code;
	output	[SWidth-1:0]	Syndrome;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Regs
	//--------------------------------------------------------------------------
	reg		[SWidth-1:0]	Syndrome;
	genvar					i;
	reg		[SWidth:0]		j;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Hamming Code Generator
	//--------------------------------------------------------------------------
	generate for(i = 0; i < SWidth; i = i + 1) begin:HCG
		always @ (Code) begin
			Syndrome[i] =							1'b0;
			for (j = 1; j <= CWidth; j = j + 1) begin
				if (j[i]) Syndrome[i] =				Syndrome[i] ^ Code[j - 1];
			end
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Code/Hamming/HammingDecoder.v $
//	Version:	$Revision: 12029 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		HammingDecoder
//	Desc:		This is a variable width hamming decoder.
//	Params:		Width:		The width of the data output
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12029 $
//------------------------------------------------------------------------------
module	HammingDecoder(Code, Error, Correction, Data);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					8;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				ASWidth =				`log2f(Width) + 1,
							SWidth =				ASWidth + (((`pow2(ASWidth)-ASWidth) < (Width+1)) ? 1 : 0),
							CWidth =				Width + SWidth;
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[CWidth-1:0]	Code;
	output					Error;
	output	[CWidth-1:0]	Correction;
	output	[Width-1:0]		Data;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[SWidth-1:0]	Syndrome;
	wire					NoCorrection;
	wire	[CWidth-1:0]	CorrectedCode;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns and Decodes
	//--------------------------------------------------------------------------
	assign	Error =									~NoCorrection;
	assign	CorrectedCode =							Code ^ Correction;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Syndrome Generator
	//--------------------------------------------------------------------------
	HammingCode		#(			.CWidth(			CWidth),
								.SWidth(			SWidth))
					HSG(		.Code(				Code),
								.Syndrome(			Syndrome));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Correction Generator
	//--------------------------------------------------------------------------
	Bin2OneHot		#(			.Width(				CWidth + 1))
					CG(			.Bin(				Syndrome),
								.OneHot(			{Correction, NoCorrection}));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Hamming Deflation (Remove the parity bits)
	//--------------------------------------------------------------------------
	HammingDeflation #(			.Width(				Width),
								.SWidth(			SWidth),
								.CWidth(			CWidth))
					HD(			.Code(				CorrectedCode),
								.Data(				Data));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Code/Hamming/HammingDeflation.v $
//	Version:	$Revision: 12029 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		HammingDeflation
//	Desc:		This is a variable width hamming deflator
//	Params:		width:		The width of the input
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12029 $
//------------------------------------------------------------------------------
module	HammingDeflation(Code, Data);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					8,
							SWidth =				4,
							CWidth =				12;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[CWidth-1:0]	Code;
	output reg [Width-1:0]	Data;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Regs
	//--------------------------------------------------------------------------
	reg		[SWidth-1:0]	i, j, k;
	//--------------------------------------------------------------------------
  
	//--------------------------------------------------------------------------
	//	Hamming Expander
	//--------------------------------------------------------------------------
	always @ (*) begin
		i =											0;
		j =											1;
		for (k = 0; k < Width; k = k + 1) begin
			while (j == (i + 1)) begin
				j =									{j[SWidth-2:0], 1'b0};
				i =									i + 1;
			end
			Data[k] =								Code[i];
			i =										i + 1;
		end
	end
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Code/Hamming/HammingEncoder.v $
//	Version:	$Revision: 12029 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		HammingEncoder
//	Desc:		This is a variable width hamming encoder
//	Params:		Width:		The width of the input
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12029 $
//------------------------------------------------------------------------------
module	HammingEncoder(Data, Code);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					8;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				ASWidth =				`log2f(Width) + 1,
							SWidth =				ASWidth + (((`pow2(ASWidth)-ASWidth) < (Width+1)) ? 1 : 0),
							CWidth =				Width + SWidth;
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		Data;
	output	[CWidth-1:0]	Code;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[CWidth-1:0]	BlankCode;
	wire	[SWidth-1:0]	Parity;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	First Hamming Expansion (Insert 1'b0s)
	//--------------------------------------------------------------------------
	HammingExpansion #(			.Width(				Width),
								.SWidth(			SWidth),
								.CWidth(			CWidth))
					HEX1(		.Data(				Data),
								.Parity(			{SWidth{1'b0}}),
								.Code(				BlankCode));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Parity Generator
	//--------------------------------------------------------------------------
	HammingCode		#(			.CWidth(			CWidth),
								.SWidth(			SWidth))
					HCG(		.Code(				BlankCode),
								.Syndrome(			Parity));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Second Hamming Expansion (Insert Parity)
	//--------------------------------------------------------------------------
	HammingExpansion #(			.Width(				Width),
								.SWidth(			SWidth),
								.CWidth(			CWidth))
					HEX2(		.Data(				Data),
								.Parity(			Parity),
								.Code(				Code));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Code/Hamming/HammingExpansion.v $
//	Version:	$Revision: 12029 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		HammingExpansion
//	Desc:		This is a variable width hamming expansion
//	Params:		Width:		The width of the data input
//				SWidth:		The width of the parity input
//				CWidth:		The width of the code output
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12029 $
//------------------------------------------------------------------------------
module	HammingExpansion(Data, Parity, Code);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					8,
							SWidth =				4,
							CWidth =				12;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		Data;
	input	[SWidth-1:0]	Parity;
	output reg [CWidth-1:0]	Code;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Regs
	//--------------------------------------------------------------------------
	reg		[SWidth-1:0]	i, j, k, l;
	//--------------------------------------------------------------------------
  
	//--------------------------------------------------------------------------
	//	Hamming Expander
	//--------------------------------------------------------------------------
	always @ (*) begin
		j =											1;
		k =											0;
		l =											0;
		for (i = 0; i < CWidth; i = i + 1) begin
			if (j == (i + 1)) begin
				Code[i] =							Parity[l];
				j =									{j[SWidth-2:0], 1'b0};
				l =									l + 1;
			end
			else begin
				Code[i] =							Data[k];
				k =									k + 1;
			end
		end
	end
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Code/HexASCII2Bin.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		HexASCII2Bin
//	Desc:		This module is a pretty simple behavioral ROM which can be used
//				to convert 8-bit hexadecimal ASCII characters into 4-bit binary
//				numbers.  It will handle both upper and lower case.  The
//				output is undefined for non-hexadecimal inputs.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	HexASCII2Bin(ASCII, Bin);
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[7:0]			ASCII;
	output	[3:0]			Bin;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	Bin =									(ASCII[6] ? 9 : 0) + ASCII[3:0];
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Code/OneHot2Bin.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		OneHot2Bin
//	Desc:		This is a simple one hot to binary converter
//	Params:		width:		The width of the one-hot input
//------------------------------------------------------------------------------
module	OneHot2Bin(OneHot, Bin);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					8;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				BWidth =				`log2(Width);
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		OneHot;
	output	[BWidth-1:0]	Bin;
	//--------------------------------------------------------------------------
  
	//--------------------------------------------------------------------------
	//	Converter
	//--------------------------------------------------------------------------
	genvar					i;
	generate for (i = 0; i < BWidth; i = i + 1) begin:ENC
		assign	Bin[i] =							|({`divceil(Width, (2*`pow2(i))){{`pow2(i){1'b1}},{`pow2(i){1'b0}}}} & OneHot);
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Code/ParityGen.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		ParityGen
//	Desc:		RS232/16550 selectable parity bit generator.
//	Params:		Parity:
//						0:	None
//						1:	Odd
//						2:	Even
//						3:	Mark
//						4:	Space
//				Width:	Input width (in bits)
//------------------------------------------------------------------------------
module	ParityGen(In, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Parity =				0,
							Width =					8;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		In;
	output reg				Out;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Parity Computation
	//--------------------------------------------------------------------------
	always @ (In) begin
		case (Parity)
			1: Out =								~^In;
			2: Out =								^In;
			3: Out =								1;
			4: Out =								0;
			default: Out =							1'b0;
		endcase
	end
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Counting/CircularComparator.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		CircularComparator
//	Desc:		Compare two values, whose LSbs are in the position, which may
//				change over time.  The LSb input should be a one-hot indicator
//				of the location of the least-significant-bit.  The inputs will
//				be rotated (not shifted!) to compensate and then compared.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	CircularComparator(Small, Large, Geq, LSb);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				32;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Inputs & Outputs
	//--------------------------------------------------------------------------
	input	[Width-1:0]		Small, Large, LSb;
	output					Geq;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[Width-1:0]		Mask;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Behavioral Register
	//--------------------------------------------------------------------------
	assign	Mask =									(LSb - 1); 
	assign	Geq =									{{Mask, ~Mask} & {2{Large}}} >= {{Mask, ~Mask} & {2{Small}}};
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Counting/CountCompare.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		CountCompare
//	Desc:		An efficient (=) comparison against a monotonic, binary
//				counter.  This module exploits the fact that we needn't actually
//				check EVERY bit to determine equality.  The output may be true
//				or false for inputs larger than the comparison value.  Here's a
//				truth table:
//				
//				Count input		TerminalCount output
//				< Compare		1'b0
//				== Compare		1'b1
//				> Compare		1'b1 or 1'b0 (can be either for different values)
//
//				This module is designed to be used to reset a counter when that
//				counter hits a certain value.  The output of the counter should
//				be fed to the Count input, and the TerminalCount output can then
//				be used to reset the Counter.
//
//				By using this module the space complexity of the comparator is
//				reduced to the number of 1'b1 bits in Compare
//				(N = PopCount(Compare)), and the time complexity is reduced to
//				O(logD(N)), assuming a d-ary AND reduction tree is synthesized.
//				By comparison a magnitude comparator will generally require
//				a carry propagation operation which takes O(Width) time.  
//	Params:		Width:	Sets the bitwidth of the input
//				Compare:The value to compare against
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	CountCompare(Count, TerminalCount);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				8,
							Compare =				8'hFF;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				CWidth =				`log2(Compare+1),
							CWidthCheck =			`max(CWidth,1);
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		Count;
	output					TerminalCount;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Multiple Implementations
	//--------------------------------------------------------------------------
	generate if (Width > 1) begin:WIDE
		//----------------------------------------------------------------------
		//	Wires and Regs
		//----------------------------------------------------------------------
		wire	[CWidth-1:0]	CompareWire;
		//----------------------------------------------------------------------
	
		//----------------------------------------------------------------------
		//	Assigns
		//----------------------------------------------------------------------
		assign	CompareWire =						Compare;
		assign	TerminalCount =						Compare ? &(Count[CWidthCheck-1:0] | ~CompareWire) : 1'b1;
		//----------------------------------------------------------------------
	end else begin:NARROW
		//----------------------------------------------------------------------
		//	Assigns
		//----------------------------------------------------------------------
		assign	TerminalCount =						Count >= Compare;
		//----------------------------------------------------------------------
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Counting/CountRegion.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		CountRegion
//	Desc:		Uses a highly efficient counter comparison (CountCompare) and
//				a single big register to determine whether the input counter
//				is within a prespecified region.
//	Params:		Width:	Sets the bitwidth of the input
//				Start:	The starting value at which to turn the output on (inclusive)
//				End:	The ending value at which to turn the output off (inclusive)
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	CountRegion(Clock, Reset, Enable, Count, Max, Output);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				8,
							Start =					9'h000,
							End =					9'h100,
							UseMagnitude =			Width < 4;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				EnablePre =				Start > 0,
							EnableActive =			Start != End,
							EnablePost =			End < `pow2(Width);
	`else
	localparam				EnablePre =				1'b1,
							EnableActive =			1'b1,
							EnablePost =			1'b1;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	
	input					Enable;
	input	[Width-1:0]		Count;
	input					Max;
	output					Output;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Comparison Logic
	//--------------------------------------------------------------------------
	generate if (UseMagnitude) begin:MAG
		assign	Output =							(Count >= Start) && (Count < End);
	end else if (EnableActive & (EnablePre | EnablePost)) begin:FSM
		//----------------------------------------------------------------------
		//	Wires
		//----------------------------------------------------------------------
		wire	[2:0]		CurrentState, NextState, DoneState;
		wire				SetOutput, ResetOutput;
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Assigns
		//----------------------------------------------------------------------
		assign	DoneState =							CurrentState & {Max, ResetOutput, SetOutput};
		
		assign	NextState[0] =						EnablePre & (DoneState[2] | (~EnablePost & DoneState[1]));
		assign	NextState[1] =						DoneState[0] | (~EnablePre & (DoneState[2] | (~EnablePost & DoneState[1])));
		assign	NextState[2] =						EnablePost & DoneState[1];
		assign	Output =							CurrentState[1];
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	Start Comparator
		//----------------------------------------------------------------------
		if (EnablePre) begin:STARTCMP
			CountCompare #(		.Width(				Width),
								.Compare(			Start-1))
					StartCmp(	.Count(				Count),
								.TerminalCount(		SetOutput));
		end else begin:STARTFIXED
			assign	SetOutput =						Max;
		end
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	End Comparator
		//----------------------------------------------------------------------
		if (EnablePost) begin:ENDCMP
			CountCompare #(		.Width(				Width),
								.Compare(			End-1))
					EndCmp(		.Count(				Count),
								.TerminalCount(		ResetOutput));
		end else begin:ENDFIXED
			assign	ResetOutput =					Max;
		end
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//	State Register
		//----------------------------------------------------------------------
		Register	#(			.Width(				3),
								.ResetValue(		EnablePre ? 3'b001 : 3'b010))
					State(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			Enable & (|DoneState)),
								.In(				NextState),
								.Out(				CurrentState));
		//----------------------------------------------------------------------
	end else if (EnableActive) begin:SIMPLE
		assign Output =								1'b1;
	end else begin:INACTIVE
		assign Output =								1'b0;
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Counting/Counter.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Counter
//	Desc:		Standard binary counter.
//	Params:		Width:	The bitwidth of the counter.
//				Limited:Should the counter saturate rather than roll over?
//				Down:	Should the counter count down (decrement) rather than
//						up (increment)?  Note that this will, obviously, affect
//						the limit, if used.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	Counter(Clock, Reset, Set, Load, Enable, In, Count);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				32,
							Limited =				0,
							Down =					0,
							Initial =				{Width{1'bx}},
							AsyncReset =			0,
							AsyncSet =				0,
							ResetValue =			{Width{1'b0}},
							SetValue =				{Width{1'b1}};
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset, Set, Load, Enable;
	input	[Width-1:0]		In;
	output	[Width-1:0]		Count;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					NoLimit;
	
	wire					RegEnable;
	wire	[Width-1:0]		RegIn;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	NoLimit =								!Limited;
	
	assign	RegEnable =								Load | (Enable & (NoLimit | (Down ? |Count : ~&Count)));
	assign	RegIn =									Load ? In : (Down ? (Count - 1) : (Count + 1));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Register
	//--------------------------------------------------------------------------
	Register		#(			.Width(				Width),
								.Initial(			Initial),
								.AsyncReset(		AsyncReset),
								.AsyncSet(			AsyncSet),
								.ResetValue(		ResetValue),
								.SetValue(			SetValue))
					Register(	.Clock(				Clock),
								.Reset(				Reset),
								.Set(				Set),
								.Enable(			RegEnable),
								.In(				RegIn),
								.Out(				Count));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Counting/Hysteresis.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Hysteresis
//	Desc:		This is a limited up down counter which will change its
//				output at the top and bottom.
//	Params:		Width:		Sets the bitwidth of the counter
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	Hysteresis(Clock, Reset, Set, Up, Down, Out, Limit);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				32,
							Initial =				{Width{1'bx}},
							AsyncReset =			0,
							AsyncSet =				0;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset, Set;
	input					Up, Down;
	output					Out, Limit;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires and Regs
	//--------------------------------------------------------------------------
	wire					Top, Bottom;
	wire	[Width-1:0]		Count;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	Top =									&Count;
	assign	Bottom =								~|Count;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Up/Down Counter (With Set/Reset and Limiting)
	//--------------------------------------------------------------------------
	Register		#(			.Width(				Width),
								.Initial(			Initial),
								.AsyncReset(		AsyncReset),
								.AsyncSet(			AsyncSet))
					CntReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				Set),
								.Enable(			(Up ^ Down) & (Up ? ~Top : ~Bottom)),
								.In(				Up ? (Count + 1) : (Count - 1)),
								.Out(				Count));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Register for Output
	//--------------------------------------------------------------------------
	Register		#(			.Width(				1),
								.AsyncReset(		AsyncReset),
								.AsyncSet(			AsyncSet))
					OutReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				Set),
								.Enable(			Top | Bottom),
								.In(				Top),
								.Out(				Out));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Register for Limit
	//--------------------------------------------------------------------------
	Register		#(			.Width(				1),
								.AsyncReset(		AsyncReset || AsyncSet))
					LimReg(		.Clock(				Clock),
								.Reset(				Reset | Set),
								.Set(				1'b0),
								.Enable(			1'b1),
								.In(				Top | Bottom),
								.Out(				Limit));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Counting/LFSR.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		LFSRPoly
//	Desc:		This module computes multiple iterations of an LFSR polynomial.
//				It can be used to build an LFSR or simply to calculate a magic
//				number.
//	Params:		PWidth:	Sets the bitwidth of the parallel data (both in and out
//				of the module)
//				SWidth:	Sets the bitwidth of the serial input
//				Poly:	Sets the LFSR polynomial to use.  Defaults to Ethernet
//						CRC32.  This should be the galois field representation
//						of the polynomial.  The highest degree polynomial term
//						(x^PWidth) is always implied, and the second highest
//						(x^(PWidth-1)) is represent by the 0th bit of the poly.
//						The lowest degree term (1) is always implied and the
//						second lowest (x) is represented by the PWidth-1 bit of
//						the poly.
//				GateXnor: Use Xnor gates instead of Xor gates.
//	Ex:			(32,1) will generate a 32bit CRC using the 802.3 CRC32
//				polynomial one bit at a time
//				(16,8,1'6h1021) will generate a 16bit CRC using the CRC-CCIT
//				polynomial, a byte at a time
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	LFSRPoly(PIn, SIn, POut);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				PWidth =				32,				// The parallel width
							SWidth =				1,				// The serial width
							Poly =					32'h04C11DB7,	// Standard 802.3 CRC32 polynomial
							GateXnor =				0;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Parallel and Serial I/O
	//--------------------------------------------------------------------------
	input	[PWidth-1:0]	PIn;
	input	[SWidth-1:0]	SIn;
	output	[PWidth-1:0]	POut;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[PWidth-1:0]	Intermediate[SWidth:0], Polynomial, IPoly[SWidth:1];
	genvar					i;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Generate Loop Setup and Termination
	//--------------------------------------------------------------------------
	assign	Polynomial =							Poly;
	assign	Intermediate[0] =						PIn;
	assign	POut =									Intermediate[SWidth];
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Generate Loop (Each iteration processes one bit of SIn)
	//--------------------------------------------------------------------------
	generate for (i = 1; i < SWidth + 1; i = i + 1) begin:Shift
			assign	IPoly[i] =						Polynomial & {PWidth{Intermediate[i-1][PWidth-1] ^ SIn[i-1]}};
			assign	Intermediate[i] =				GateXnor ? ~({Intermediate[i-1][PWidth-2:0], 1'b0} ^ IPoly[i]) : ({Intermediate[i-1][PWidth-2:0], 1'b0} ^ IPoly[i]);
		end
	endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//	Module:		LFSR
//	Desc:		This module is an actual LFSR with a variable serial input,
//				parallel width and polynomial it uses the LFSRPoly module to do
//				the actual calculations.
//	Params:		pwidth:	Sets the bitwidth of the parallel data (both in and out
//						of the module).
//				swidth:	Sets the bitwidth of the serial input
//				poly:	Sets the LFSR polynomial to use.  Defaults to Ethernet
//						CRC32.  See the LFSRPoly module for more information.
//				GateXnor: Use Xnor gates instead of Xor gates.
//	Ex:			(32,1) will generate a 32bit CRC using the 802.3 CRC32
//				polynomial one bit at a time
//				(16,8,1'6h1021) will generate a 16bit CRC using the CRC-CCIT
//				polynomial, a byte at a time
//------------------------------------------------------------------------------
module	LFSR(Clock, Reset, Load, Enable, PIn, SIn, POut, SOut);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				PWidth =				32,				// The parallel width
							SWidth =				1,				// The serial width
							Poly =					32'h04C11DB7,	// Standard 802.3 CRC32 polynomial
							GateXnor =				0,
							AsyncReset =			0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Control Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	input					Load, Enable;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Parallel and Serial I/O
	//--------------------------------------------------------------------------
	input	[PWidth-1:0]	PIn;
	input	[SWidth-1:0]	SIn;
	output	[PWidth-1:0]	POut;
	output	[SWidth-1:0]	SOut;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[PWidth-1:0]	POutNext;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	SOut =									POut[PWidth-1:PWidth-SWidth];
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	LFSR Polynomial Calculation
	//--------------------------------------------------------------------------
	LFSRPoly		PONGen(		.PIn(				POut),
								.SIn(				SIn),
								.POut(				POutNext));
	defparam		PONGen.PWidth =					PWidth;
	defparam		PONGen.SWidth =					SWidth;
	defparam		PONGen.Poly =					Poly;
	defparam		PONGen.GateXnor =				GateXnor;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Behavioral Register Core
	//--------------------------------------------------------------------------
	Register		#(			.Width(				PWidth),
								.AsyncSet(			AsyncReset))
					Register(	.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				Reset),
								.Enable(			Load | Enable),
								.In(				Load ? PIn : POutNext),
								.Out(				POut));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Counting/Timeout.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Timeout
//	Desc:		A timeout counter
//	Params:		timeout:	The value at which to signal a timeout and stop
//							counting
//------------------------------------------------------------------------------
module	Timeout(Clock, Reset, Set, Enable, Signal);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Timeout = 				7,
							AsyncReset =			0,
							AsyncSet =				0;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				Width =					`log2(Timeout + 1);
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset, Set, Enable;
	output					Signal;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	wire	[Width-1:0]		Count;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Counter (with Set/Reset)
	//--------------------------------------------------------------------------
	Register		#(			.Width(				Width),
								.AsyncReset(		AsyncReset),
								.AsyncSet(			AsyncSet),
								.SetValue(			Timeout - 1))
					CntReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				Set),
								.Enable(			~Signal & Enable),
								.In(				Count + 1),
								.Out(				Count));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Output Generation
	//--------------------------------------------------------------------------
	Register		#(			.Width(				1),
								.AsyncReset(		AsyncReset),
								.AsyncSet(			AsyncSet))
					OutReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				Set),
								.Enable(			(&(Count | ~(Timeout - 1))) & Enable),
								.In(				1'b1),
								.Out(				Signal));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Counting/UDCounter.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		UDCounter
//	Desc:		This is an up/down counter with an option to be hard limited at
//				the max/min values.
//	Params:		Width:		Sets the bitwidth of the counter
//				Limited:	Should the counter saturate?
//	Ex:			(8,1)		creates an 8-bit saturating counter
//				(32,1) creates a 32-bit saturating counter
//				(4,0) creates a 4-bit rollover counter
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	UDCounter(Clock, Reset, Set, Load, Up, Down, In, Count);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				32,
							Limited =				0,
							Initial =				{Width{1'bx}},
							AsyncReset =			0,
							AsyncSet =				0,
							ResetValue =			{Width{1'b0}},
							SetValue =				{Width{1'b1}};
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset, Set, Load;
	input					Up, Down;
	input	[Width-1:0]		In;
	output	[Width-1:0]		Count;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					NoLimit;
	wire	[Width-1:0]		NextCount;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	NoLimit =								!Limited;
	assign	NextCount =								(Up) ? (Count + 1) : (Count - 1);
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Behavioral Up/Down Counter (With Set/Reset and Limiting)
	//--------------------------------------------------------------------------
	Register		#(			.Width(				Width),
								.Initial(			Initial),
								.AsyncReset(		AsyncReset),
								.AsyncSet(			AsyncSet),
								.ResetValue(		ResetValue),
								.SetValue(			SetValue))
					Register(	.Clock(				Clock),
								.Reset(				Reset),
								.Set(				Set),
								.Enable(			Load | ((Up ^ Down) & (Up ? (NoLimit | ~&Count) : (NoLimit | |Count)))),
								.In(				Load ? In : NextCount),
								.Out(				Count));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Datapath/Fixed/CornerTurn.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2008-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2008-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		CornerTurn
//	Desc:		A parameterized module to perform a corner turn on a 2D vector
//				packed into a 1D wire vector.
//	Params:		IWidth:	The width of the inner/minor axis on the input
//				OWidth:	The width of the outter/major axis on the input
//				GWidth: The width of groups within the bus which should be left
//						intact.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	CornerTurn(In, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				IWidth =				4,
							OWidth =				4,
							GWidth =				1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				Width =					IWidth * OWidth * GWidth;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		In;
	output	[Width-1:0]		Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	A Complicated Wire
	//--------------------------------------------------------------------------
	genvar					i, j;
	generate for (i = 0; i < OWidth; i = i + 1) begin:OUTTER
		for (j = 0; j < IWidth; j = j + 1) begin:INNER
			assign Out[(j*OWidth*GWidth)+(i*GWidth)+GWidth-1:(j*OWidth*GWidth)+(i*GWidth)] = In[(i*IWidth*GWidth)+(j*GWidth)+GWidth-1:(i*IWidth*GWidth)+(j*GWidth)];
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Datapath/Fixed/ExtractMask.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		ExtractMask
//	Desc:		Extract some bits from an input, according to a mask parameter.
//	Params:		IWidth:		The width of the input
//				Mask:		The mask, wherein a 1bit will be sent to the output.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	ExtractMask(In, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				IWidth =				32,
							Mask =					32'hF0000000;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				PopCount =				`popcount(Mask),
							OWidth =				`max(1, PopCount),
							CWidth =				`log2(IWidth);
	`else
	localparam				OWidth =				IWidth,
							CWidth =				IWidth;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[IWidth-1:0]	In;
	output	[OWidth-1:0]	Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Regs
	//--------------------------------------------------------------------------
	reg		[CWidth:0]		i, j;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Extraction
	//--------------------------------------------------------------------------
	generate if (Mask != 0) begin:EXTRACT
		reg	[OWidth-1:0]	Temp;
		
		always @ (In) begin
			j =										0;
			for (i = 0; i < OWidth; i = i + 1) begin
				while (!Mask[j]) j =				j + 1;
				Temp[i] =							In[j];
				j =									j + 1;
			end
		end
		
		assign	Out =								Temp;
	end else begin:ZERO
		assign	Out =								0;
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Datapath/Fixed/InsertMask.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		InsertMask
//	Desc:		Insert some bits from an input, according to a mask parameter.
//	Params:		OWidth:		The width of the output
//				Mask:		The mask, wherein a 1bit will be pulled from In
//							and a 0bit will be pulled from Base.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	InsertMask(In, Base, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				OWidth =				32,
							Mask =					32'hF0000000;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				IWidth =				`popcount(Mask),
							CWidth =				`log2(OWidth);
	`else
	localparam				IWidth =				OWidth,
							CWidth =				OWidth;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[IWidth-1:0]	In;
	input	[OWidth-1:0]	Base;
	output reg [OWidth-1:0]	Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Regs
	//--------------------------------------------------------------------------
	reg		[CWidth:0]		i, j;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Insertion
	//--------------------------------------------------------------------------
	always @ (In or Base) begin
		j =											0;
		for (i = 0; i < OWidth; i = i + 1) begin
			Out[i] =								Mask[i] ? In[j] : Base[i];
			if (Mask[i]) j =						j + 1;
		end
	end
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Datapath/Fixed/LevelConverter.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		LevelConverter
//	Desc:		A simple module to convert between signalling levels,
//				particularly during simulation.  For each bit of input, this
//				module will select the appropriate parameter, and extract
//				the corresponding bit position from it to generate the output.
//				For example, if the width is 2, Output0 is 2'b10 and Output1 is
//				2'b01, this module will pass through the LSb, and invert the
//				MSb.  If Output1 were instead 2'b00, then the LSb output would
//				always be 1'b0.  Note that this module can also handle
//				1'bx and 1'bz on the inputs and outputs.
//	Params:		Width:	The width of the input and output.
//				...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	LevelConverter(In, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							Output0 =				{Width{1'b0}},
							Output1 =				{Width{1'b1}},
							OutputX =				{Width{1'bx}},
							OutputZ =				{Width{1'bz}};
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		In;
	output reg [Width-1:0]	Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	A Complicated Wire
	//--------------------------------------------------------------------------
	genvar					i;
	generate for(i = 0; i < Width; i = i + 1) begin:CONVERT
		always @ (In[i]) begin
			case (In[i])
				1'b0: Out[i] =						Output0[i];
				1'b1: Out[i] =						Output1[i];
`ifdef SIMULATION
				1'bx: Out[i] =						OutputX[i];
				1'bz: Out[i] =						OutputZ[i];
`endif
				default: Out[i] =					1'bx;
			endcase
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Datapath/Fixed/Reverse.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Reverse
//	Desc:		Parameterized bit reversal module: a fancy wire.
//				Essentially this module is just a very complex set of wires, all
//				it does it reverse the bits in a bus.  A "group" is a group of
//				"chunks" that should be reversed, "set" is the number of
//				"chunks" per "group".  This module will reverse the order of the
//				"chunks" within each "group".
//	Params:		Width:	This sets the input and output bus width of the module
//				Chunk:	This is the size of a block of wires which should
//						be kept in order.  The default is 1 meaning each wire
//						should be treated separately.
//				Set:	The number of chunks in a set, the default is the
//						bitwidth of the input bus, meaning that the whole input
//						bus is treated as a set.
//	Ex:			(32,1,32) Will reverse the bit order of a 32bit bus.
//				(32,1,8)Will reverse the MSb/LSb order of the bytes in a 32bit
//						bus.
//				(32,4,2)will reverse the MSNibble/LSNibble of each byte in a
//						32bit bus.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	Reverse(In, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							Chunk =					1,
							Set =					Width;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				Group =					Chunk * Set;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		In;
	output	[Width-1:0]		Out;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	A Complicated Wire
	//--------------------------------------------------------------------------
	genvar					i;
	generate for(i = 0; i < Width; i = i + 1) begin:REVERSE
		assign Out[i] =								In[((Set - 1 - ((i % Group) / Chunk)) * Chunk) + ((i % Group) % Chunk) + ((i / Group) * Group)];
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Datapath/Variable/BarrelShifter.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2008-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2008-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		BarrelShifter
//	Desc:		A synthesizable barrel shifter, which can go either way, and
//				incorporates the ability to specify don't care values for
//				filled bit positions.  The output is twice the width of the
//				input, and the width of the shift input allows shifts amounts
//				in the range [0,Groups].  By setting GWidth to 1, this module
//				becomes a complete barrel shifter.  The actual shift amount is
//				Shift*GWidth, just to be perfectly clear.
//	Params:		GWidth:	The width of each of the input groups to this module
//				Groups:	The number of input groups
//				Direction: 0 - Left (input is right aligned),
//						1 - Right (input is left aligned)
//				Type:	0 - Logical, 1 - Arithmetic, 2 - DontCare
//				Output:	0 - Left Half (MSbs), 1 - Right Half (LSbs),
//						2 - 2*Width
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	BarrelShifter(In, Shift, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				GWidth =				1,
							Groups =				4,
							Direction =				0,
							Type =					0,
							Output =				2;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				Width =					GWidth * Groups,
							OWidth =				(Output < 2) ? Width : (2*Width),
	`ifdef MACROSAFE
							ShWidth =				`log2(Groups+1);
	`else
							ShWidth =				Groups;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		In;
	input	[ShWidth-1:0]	Shift;
	output	[OWidth-1:0]	Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[ShWidth-1:0]	Limited;
	wire	[(2*Width)-1:0]	Extended, Shifted, DontCared;
	genvar					i;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	Limited =								(Shift > Groups) ? {ShWidth{1'bx}} : Shift;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Shift Logic Generation
	//--------------------------------------------------------------------------
	generate case(Direction)
		0: begin:LEFTSHIFT
			assign	Extended =						{{Width{1'bx}}, In};
			if (Type == 1) assign	Shifted =		Extended <<< (Limited * GWidth);
			else assign	Shifted =					Extended << (Limited * GWidth);
			
			if (Type == 2) begin
				for (i = 0; i < Width; i = i + 1) begin:DONTCAREMUX
					assign	DontCared[i] =			(i < Shift) ? 1'bx : Shifted[i];
				end
				assign	DontCared[(2*Width)-1:Width] = Shifted[(2*Width)-1:Width];
			end else assign	DontCared =				Shifted;
		end
		1: begin:RIGHTSHIFT
			assign	Extended =						{In, {Width{1'bx}}};
			if (Type == 1) assign	Shifted =		Extended >>> (Limited * GWidth);
			else assign	Shifted =					Extended >> (Limited * GWidth);
			
			if (Type == 2) begin
				assign	DontCared[Width-1:0] =		Shifted[Width-1:0];
				for (i = 0; i < Width; i = i + 1) begin:DONTCAREMUX
					assign	DontCared[i+Width] =	(i >= (Width - Shift)) ? 1'bx : Shifted[i+Width];
				end
			end else assign	DontCared =				Shifted;
		end
	endcase endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Logic
	//--------------------------------------------------------------------------
	generate case(Output)
		0: begin
			assign	Out =							DontCared[(Width*2)-1:Width];
		end
		1: begin
			assign	Out =							DontCared[Width-1:0];
		end
		2: begin
			assign	Out =							DontCared;
		end
	endcase endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Datapath/Variable/DeMux.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		DeMux
//	Desc:		This is a parameterized size demux.  It is primarily meant for
//				use in places where the number of demux outputs is a parameter
//				to the module which instantiates this one, as the way one
//				writes Verilog to describe a demux can affect the whether a
//				functional simulation is accurate as of ModelSim 6.5.
//	Params:		Width:	The width of the demux
//				NPorts:	The number of output ports from the demux
//				Unselected: The value to output on a port which is not selected
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module DeMux(Select, Input, Output);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							NPorts =				2,
							SelectCode =			0, // 0 - Binary, 1 - One-Hot
							Unselected =			{Width{1'bx}};
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam 				SWidth =				SelectCode ? NPorts : `max(1,`log2(NPorts));
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O Ports
	//--------------------------------------------------------------------------
	input	[SWidth-1:0]	Select;
	input	[Width-1:0]		Input;
	output	[(NPorts*Width)-1:0] Output;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	genvar					i;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Behavioral DeMux
	//--------------------------------------------------------------------------
	generate if (SelectCode) begin:ONEHOT
		for (i = 0; i < NPorts; i = i + 1) begin:LOOP
			assign	Output[(Width*i)+Width-1:(Width*i)] = Select[i] ? Input : Unselected;
		end
	end else if (NPorts > 1) begin:MANYOUT
		for (i = 0; i < NPorts; i = i + 1) begin:LOOP
			assign	Output[(Width*i)+Width-1:(Width*i)] = (Select == i) ? Input : Unselected;
		end
	end else begin:ONEOUT
		assign	Output =							Input[Width-1:0];
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Datapath/Variable/LUT.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		LUT
//	Desc:		Standard LUT.
//	Params:		Width:	The bitwidth of the LUT input.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	LUT(Input, Program, Output);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				4;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Local Params
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				PWidth =				`pow2(Width);
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[Width-1:0]		Input;
	input	[PWidth-1:0]	Program;
	output reg				Output;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Behavioral Counter (with Set/Reset)
	//--------------------------------------------------------------------------
	integer					i;
	always @ (*) begin
		Output =									1'bx;
		for (i = 0; i < PWidth; i = i + 1) begin
			if (Input == i) Output =				Program[i];
		end
	end
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Datapath/Variable/Mux.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Mux
//	Desc:		This is a parameterized size mux.  It is primarily meant for use
//				in places where the number of mux inputs is a parameter to
//				the module which instantiates this one, as the way one writes
//				Verilog to describe a mux can affect the whether a functional
//				simulation is accurate as of ModelSim 6.4a.
//	Params:		Width:	The width of the mux
//				NPorts:	The number of input ports to the mux
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module Mux(Select, Input, Output);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							NPorts =				2,
							SelectCode =			0; // 0 - Binary, 1 - One-Hot
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam 				SWidth =				SelectCode ? NPorts : `max(1,`log2(NPorts));
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O Ports
	//--------------------------------------------------------------------------
	input	[SWidth-1:0]	Select;
	input	[(NPorts*Width)-1:0] Input;
	output	[Width-1:0]		Output;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	genvar					i;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Behavioral Mux
	//--------------------------------------------------------------------------
	generate if (NPorts > 1) begin:MANYIN
		if (SelectCode) begin:ONEHOT
			for (i = 0; i < NPorts; i = i + 1) begin:LOOP
				assign	Output =					Select[i] ? Input[(Width*i)+Width-1:(Width*i)] : {Width{1'bz}};
			end
		end else begin:BINARY
			for (i = 0; i < NPorts; i = i + 1) begin:LOOP
				assign	Output =					(Select == i) ? Input[(Width*i)+Width-1:(Width*i)] : {Width{1'bz}};
			end
		end
	end else begin:ONEIN
		assign	Output =							Input[Width-1:0];
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Math/PopAdd.v $
//	Version:	$Revision: 11840 $
//	Author:		Brandon Myers
//				Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		PopAdd
//	Desc:		Counts the number of 1's in the input
//	Params:		Width:	Sets the bitwidth of input
//	Author:		Brandon Myers
//				<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	PopAdd(In, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				IWidth =				16;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				OWidth =				`log2(IWidth+1),
							LIWidth =				`log2(IWidth),
							XIWidth =				`pow2(LIWidth),
							XOWidth =				`log2(XIWidth+1);
	
	function automatic [31:0] upper(input [31:0] i, input [31:0] j); begin
		if (i == 0) upper = j;
		else upper = ((i*2*j)+i);
	end endfunction
	
	function automatic [31:0] lower(input [31:0] i, input [31:0] j); begin
		if (i == 0) lower = j;
		else lower = (i*2*j);
	end endfunction
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Ports
	//--------------------------------------------------------------------------
	input 	[IWidth-1:0]	In;
	output 	[OWidth-1:0]	Out;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[XIWidth-1:0]	Intermediate[XOWidth-1:0];
	genvar					i, j;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	Intermediate[0] =			In;
	assign	Out =						Intermediate[XOWidth-1][OWidth-1:0];
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Generated Adder Tree
	//--------------------------------------------------------------------------
	generate for (i = 1; i < XOWidth; i = i + 1) begin:OUTTER
		for (j = 0; j < (XIWidth >> i); j = j + 1) begin:INNER
			assign	Intermediate[i][upper(i,j):lower(i,j)] = Intermediate[i-1][upper(i-1,j*2):lower(i-1,j*2)] + Intermediate[i-1][upper(i-1,(j*2)+1):lower(i-1,(j*2)+1)];
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Math/ShiftDivide.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		ShiftDivide
//	Desc:		A shift and subtract based divider.  Can use twos-complement or
//				unsigned numbers.  This is a clas1 module.
//	Params:		Width:	The bitwidth of the inputs and outputs
//				SignedArith: Specifies that this module should use sign
//						extension
//------------------------------------------------------------------------------
module	ShiftDivide(Clock, Reset, Divisor, Dividend, InValid, InReady, Quotient, Remainder, OutValid, OutReady);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					18,
							SignedArith =			0;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				CountMax =				Width + 2,
							CWidth =				`log2(CountMax);
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Control I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Inputs
	//--------------------------------------------------------------------------
	input	[Width-1:0]		Divisor, Dividend;
	input					InValid;
	output					InReady;
	
	//	Outputs
	output	[Width-1:0]		Quotient, Remainder;
	output					OutValid;
	input					OutReady;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[Width-1:0]		NegQuotient, NegRemainder;
	wire					InvertQuotient, InvertRemainder;

	wire	[Width:0]		Difference;
	wire	[Width-1:0]		INVDivisor, INVDividend;
	wire	[Width-1:0]		ABSDivisor, ABSDividend;
	wire	[(2*Width)-1:0]	Q;

	wire	[CWidth-1:0]	Count, CountMaxWire;
	wire					Start, Done;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	NegQuotient =							(~Q[Width-1:0]) + 1;
	assign	Quotient =								InvertQuotient ? NegQuotient : Q[Width-1:0];

	assign	NegRemainder =							(~Q[(2*Width)-1:Width]) + 1;
	assign	Remainder =								InvertRemainder ? NegRemainder : Q[(2*Width)-1:Width];

	assign	Difference =							Q[(2*Width)-1:Width-1] - {1'b0, ABSDivisor};
	assign	INVDivisor =							((~Divisor) + 1);
	assign	INVDividend =							((~Dividend) + 1);
	assign	ABSDividend =							(SignedArith && Dividend[Width-1]) ? INVDividend : Dividend;

	assign	CountMaxWire =							CountMax - 1;

	assign	Start =									InValid & InReady;
	assign	OutValid =								Done & ~InReady;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Absolute Value Registers
	//--------------------------------------------------------------------------
	Register		ABSDvs(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			Start),
								.In(				(SignedArith && Divisor[Width-1]) ? INVDivisor : Divisor),
								.Out(				ABSDivisor));
	defparam		ABSDvs.Width =					Width;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Invert Register
	//--------------------------------------------------------------------------
	generate if (SignedArith) begin:IREG
		Register	IReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			Start),
								.In(				{Dividend[Width-1], Divisor[Width-1] ^ Dividend[Width-1]}),
								.Out(				{InvertRemainder, InvertQuotient}));
		defparam	IReg.Width =					2;
	end else begin:ICONST
		assign	InvertRemainder =					1'b0;
		assign	InvertQuotient =					1'b0;
	end endgenerate
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Q Shift Register
	//--------------------------------------------------------------------------
	ShiftRegister	QSR(		.Clock(				Clock),
								.Reset(				Reset),
								.Load(				Start | (~OutValid & ~Difference[Width])),
								.Enable(			~(Done | InReady)),
								.PIn(				Start ? {{Width{1'b0}}, ABSDividend} : {Difference[Width-1:0], Q[Width-2:0], 1'b1}),
								.SIn(				1'b0),
								.POut(				Q),
								.SOut(				));
	defparam		QSR.PWidth =					Width * 2;
	defparam		QSR.SWidth =					1'b1;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Counter
	//--------------------------------------------------------------------------
	Counter			Cnt(		.Clock(				Clock),
								.Reset(				Start & ~Reset),
								.Set(				1'b0),
								.Load(				Reset),
								.Enable(			InReady ? InValid : (~OutValid | OutReady)),
								.In(				CountMaxWire),
								.Count(				Count));
	defparam		Cnt.Width =						CWidth;
	CountCompare	DC(			.Count(				Count),
								.TerminalCount(		Done));
	defparam		DC.Width =						CWidth;
	defparam		DC.Compare =					CountMax - 2;
	CountCompare	IRC(		.Count(				Count),
								.TerminalCount(		InReady));
	defparam		IRC.Width =						CWidth;
	defparam		IRC.Compare =					CountMax - 1;
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://repositorypub@repository.eecs.berkeley.edu/public/Projects/GateLib/branches/dev/Core/GateCore/Hardware/PWM/PWM.v$
//	Version:	$Revision: 18673$
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		PWM
//	Desc:		This module will generate a PWM signal which can be very
//				precisely controlled.
//	Params:		Width:	Sets the bitwidth of the PWM counter. 
//						NOTE: In is one bit wider than this:
//						If the top bit is on, the output will always be on.
//	Inputs:		Reset:	Turns the output all the way off.
//				Set:	Turns the output all the way on.
//				Load:	Loads a new duty cycle.
//				Enable:	Can be used to gate the clock so that the PWM effectively
//						operates at a lower frequency
//				In:		Duty Cycle Input.
//						NOTE: In is one bit wider than this:
//						If the top bit is on, the output will always be on.
//	Outputs:	Out:	PWM Output 
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 18673$
//------------------------------------------------------------------------------
module	PWM(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			Set,
			Load,
			Enable,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Inputs
			//------------------------------------------------------------------
			In,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Outputs
			//------------------------------------------------------------------
			Out
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					8,
							RestartOnLoad =			0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clock & Reset Inputs
	//--------------------------------------------------------------------------
	input					Clock, Enable, Reset, Set, Load;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Inputs
	//--------------------------------------------------------------------------
	input	[Width:0]		In;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Outputs
	//--------------------------------------------------------------------------
	output					Out;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires and Regs
	//--------------------------------------------------------------------------
	wire	[Width-1:0]		Count;
	wire	[Width:0]		Threshold;
	wire					TurnOn, TurnOff;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	TurnOn =								~|Count;
	assign	TurnOff =								~Threshold[Width] & &(Count | ~Threshold[Width-1:0]);
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Threshold Register
	//--------------------------------------------------------------------------
	Register		#(			.Width(				Width + 1))
					TReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				Set),
								.Enable(			Load),
								.In(				In),
								.Out(				Threshold));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Cycle Counter
	//--------------------------------------------------------------------------
	Counter			#(			.Width(				Width))
					CCnt(		.Clock(				Clock),
								.Reset(				Reset | Set | (RestartOnLoad ? Load : 1'b0)),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			Enable),
								.In(				{Width{1'bx}}),
								.Count(				Count));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Output Register
	//--------------------------------------------------------------------------
	Register		#(			.Width(				1))
					OReg(		.Clock(				Clock),
								.Reset(				Reset | TurnOff),
								.Set(				Set | TurnOn),
								.Enable(			1'b0),
								.In(				1'bx),
								.Out(				Out));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://repositorypub@repository.eecs.berkeley.edu/public/Projects/GateLib/branches/dev/Core/GateCore/Hardware/PWM/PWMCounter.v$
//	Version:	$Revision: 18673$
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		PWMCounter
//	Desc:		This module will measure a PWM input.  It accepts parameters
//				to control the number of significant bits and the time
//				resolution.
//				The Clock, Reset and In inputs operate as expected, the Out
//				output is simply the width of the pulse, in time units,
//				delineated by the divided clock pulses.
//	Params:		Width:		Sets the bitwidth of the PWM counter
//				DebWidth:	Width of the input debouncer 0 will remove the
//							debouncer
//	Inputs:		ClockDiv: 	Pulsed to determine the resolution of the output
//							Ex.	If set to 1'b1, same frequency as Clock
//								If set to pulse once every 2 cycles, 50% resolution
//								If set to pulse once every 4 cycles, 25% resolution, etc.
//				In:			PWM Signal
//	Outputs:	Out:		The width of the pulse, in time units
//				Valid:		Pulsed after the end of a PWM signal
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 18673$
//------------------------------------------------------------------------------
module	PWMCounter(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Input
			//------------------------------------------------------------------
			ClockDiv,
			In,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Output
			//------------------------------------------------------------------
			Out,
			OutValid
			//------------------------------------------------------------------
	);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					8,
							DebWidth =				0;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Clock & Reset Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Inputs
	//--------------------------------------------------------------------------
	input					ClockDiv, In;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Outputs
	//--------------------------------------------------------------------------
	output	[Width-1:0]		Out;
	output					OutValid;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					CleanIn, LastCleanIn;
	wire	[Width-1:0]		HighCount;
	wire					High, Falling;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	High =									ClockDiv & CleanIn & ~&HighCount;
	assign	Falling =								ClockDiv & ~CleanIn & LastCleanIn;
	assign	OutValid =								Falling;
	assign	Out =									HighCount;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Optional Debouncer
	//--------------------------------------------------------------------------
	generate if (DebWidth > 0) begin:DEBIF
		Debouncer	#(			.Width(				DebWidth),
								.SimWidth(			DebWidth))
					CIDeb(		.In(				In),
								.Out(				CleanIn),
								.Clock(				Clock),
								.Reset(				Reset),
								.Enable(			1'b1),
								.Half(				));
	end else begin:DEBELSE
		assign	CleanIn =							In;
	end endgenerate
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Input Register (For Edge-Detection)
	//--------------------------------------------------------------------------
	Register		#(			.Width(				1))
					IReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			ClockDiv),
								.In(				CleanIn),
								.Out(				LastCleanIn));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	High Counter
	//--------------------------------------------------------------------------
	Counter			#(			.Width(				Width))
					HCnt(		.Clock(				Clock),
								.Reset(				Reset | Falling),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			High),
								.In(				{Width{1'bx}}),
								.Count(				HighCount));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Random/FixedRandomBits.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		FixedRandomBits
//	Desc:		Generate a string of high quality random bits, with a
//				parameterizable probability of a 1.  Explain...
//	Params:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	FixedRandomBits(Clock, Reset, OutBits, OutValid, OutReady);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				32,				// The width of the internal LFSR polynomials
							Poly =					32'h243b807f,	// A polynomial to use to generate many random bits
							Quotient =				{Width{1'b0}};	// The fraction of the time to generate 1s, {1'b1, {Width-1{1'b0}}} will be 50%, {Width{1'b0}} will be all 0s
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Clock & Reset
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output
	//--------------------------------------------------------------------------
	output					OutBits;
	output					OutValid;
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					LSbSerial, QutSerial;
	wire	[Width-1:0]		LSbSelect;
	
	
	wire	[Width-1:0]		Threshold, Random, Aux;
	wire	[12:0]			Aux13;
	wire	[16:0]			Aux17;
	
	wire	[Width-1:0]		QuotientWire;
	
	wire					NotOutBits;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assign Statements
	//--------------------------------------------------------------------------
	assign	OutValid =								1'b1;
	
	assign	Aux =									{`divceil(Width, 13){Aux13}} ^ {`divceil(Width, 17){Aux17}};
	assign	OutBits =								~NotOutBits;
	
	assign	QuotientWire =							Quotient;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Psuedo-Random Number Generator
	//--------------------------------------------------------------------------
	LFSR			PNGen(		.Clock(				Clock),
								.Reset(				1'b0),
								.Load(				Reset),
								.Enable(			OutValid & OutReady),
								.PIn(				{Width{1'b1}}),
								.SIn(				1'b0),
								.POut(				Random),
								.SOut(				));
	defparam		PNGen.PWidth =					Width;
	defparam		PNGen.SWidth =					1;
	defparam		PNGen.Poly =					Poly;
	defparam		PNGen.GateXnor =				0;
	
	LFSR			PNAux13(	.Clock(				Clock),
								.Reset(				1'b0),
								.Load(				Reset),
								.Enable(			OutValid & OutReady),
								.PIn(				{13{1'b1}}),
								.SIn(				1'b0),
								.POut(				Aux13),
								.SOut(				));
	defparam		PNAux13.PWidth =				13;
	defparam		PNAux13.SWidth =				1;
	defparam		PNAux13.Poly =					13'h0209;
	defparam		PNAux13.GateXnor =				0;
	LFSR			PNAux17(	.Clock(				Clock),
								.Reset(				1'b0),
								.Load(				Reset),
								.Enable(			OutValid & OutReady),
								.PIn(				{17{1'b1}}),
								.SIn(				1'b0),
								.POut(				Aux17),
								.SOut(				));
	defparam		PNAux17.PWidth =				17;
	defparam		PNAux17.SWidth =				1;
	defparam		PNAux17.Poly =					17'h04467;
	defparam		PNAux17.GateXnor =				0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Quotient Shifter
	//--------------------------------------------------------------------------
	ShiftRegister	QutSh(		.Clock(				Clock),
								.Reset(				1'b0),
								.Load(				Reset),
								.Enable(			OutReady & OutValid),
								.PIn(				QuotientWire),
								.SIn(				QutSerial),
								.POut(				Threshold),
								.SOut(				QutSerial));
	defparam		QutSh.PWidth =					Width;
	defparam		QutSh.SWidth =					1;
	defparam		QutSh.Reverse =					1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	LSb Select Shifter
	//--------------------------------------------------------------------------
	ShiftRegister	LSbSh(		.Clock(				Clock),
								.Reset(				1'b0),
								.Load(				Reset),
								.Enable(			OutReady & OutValid),
								.PIn(				{{Width-1{1'b0}}, 1'b1}),
								.SIn(				LSbSerial),
								.POut(				LSbSelect),
								.SOut(				LSbSerial));
	defparam		LSbSh.PWidth =					Width;
	defparam		LSbSh.SWidth =					1;
	defparam		LSbSh.Reverse =					1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Circular Comparator
	//--------------------------------------------------------------------------
	CircularComparator #(Width) Comparator(.Small(Threshold), .Large(Random ^ Aux), .Geq(NotOutBits), .LSb(LSbSelect));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Random/RandomBits.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		RandomBits
//	Desc:		Generate a string of high quality random bits, with a run-time
//				configurable probability of a 1.  Explain...
//	Params:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	RandomBits(Clock, Reset, Dividend, Divisor, InValid, InReady, OutBits, OutValid, OutReady);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				32,
							Poly =					32'h243b807f;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				IWidth =				2*Width;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Clock & Reset
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Input
	//--------------------------------------------------------------------------
	input	[Width-1:0]		Dividend, Divisor;
	input					InValid;
	output					InReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output
	//--------------------------------------------------------------------------
	output					OutBits;
	output					OutValid;
	input					OutReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					DivValid, NextOutValid;
	wire					Load, Enable, LoadGate;
	
	wire					LSbSerial, QutSerial;
	wire	[Width-1:0]		LSbSelect;
	
	wire	[(2*Width)-1:0]	Quotient;
	wire	[Width-1:0]		Threshold, Random, Aux;
	wire	[12:0]			Aux13;
	wire	[16:0]			Aux17;
	
	wire					NotOutBits;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assign Statements
	//--------------------------------------------------------------------------
	assign	LoadGate =								~OutValid | OutReady;
	assign	Load =									DivValid & LoadGate;
	assign	Enable =								OutValid & OutReady;
	
	assign	Aux =									{`divceil(Width, 13){Aux13}} ^ {`divceil(Width, 17){Aux17}};
	assign	OutBits =								~NotOutBits;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	OutValid State Registers
	//--------------------------------------------------------------------------
	Register #(1) NOV(.Clock(Clock), .Reset(Reset | (InValid & InReady)), .Set(DivValid), .Enable(1'b0), .In(1'bx), .Out(NextOutValid));
	Register #(1) OV(.Clock(Clock), .Reset(Reset), .Set(DivValid), .Enable(OutReady), .In(NextOutValid), .Out(OutValid));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Rate Calculator
	//--------------------------------------------------------------------------
	ShiftDivide		Divider(	.Clock(				Clock),
								.Reset(				Reset),
								.Divisor(			{{Width{1'b0}}, Divisor}),
								.Dividend(			{Dividend, {Width{1'b0}}}),
								.InValid(			InValid),
								.InReady(			InReady),
								.Quotient(			Quotient),
								.Remainder(			),
								.OutValid(			DivValid),
								.OutReady(			LoadGate));
	defparam		Divider.Width =					Width*2;
	defparam		Divider.SignedArith =			0;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Psuedo-Random Number Generator
	//--------------------------------------------------------------------------
	LFSR			PNGen(		.Clock(				Clock),
								.Reset(				1'b0),
								.Load(				Reset),
								.Enable(			Enable),
								.PIn(				{Width{1'b1}}),
								.SIn(				1'b0),
								.POut(				Random),
								.SOut(				));
	defparam		PNGen.PWidth =					Width;
	defparam		PNGen.SWidth =					1;
	defparam		PNGen.Poly =					Poly;
	defparam		PNGen.GateXnor =				0;
	
	LFSR			PNAux13(	.Clock(				Clock),
								.Reset(				1'b0),
								.Load(				Reset),
								.Enable(			Enable),
								.PIn(				{13{1'b1}}),
								.SIn(				1'b0),
								.POut(				Aux13),
								.SOut(				));
	defparam		PNAux13.PWidth =				13;
	defparam		PNAux13.SWidth =				1;
	defparam		PNAux13.Poly =					13'h0209;
	defparam		PNAux13.GateXnor =				0;
	LFSR			PNAux17(	.Clock(				Clock),
								.Reset(				1'b0),
								.Load(				Reset),
								.Enable(			Enable),
								.PIn(				{17{1'b1}}),
								.SIn(				1'b0),
								.POut(				Aux17),
								.SOut(				));
	defparam		PNAux17.PWidth =				17;
	defparam		PNAux17.SWidth =				1;
	defparam		PNAux17.Poly =					17'h04467;
	defparam		PNAux17.GateXnor =				0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Quotient Shifter
	//--------------------------------------------------------------------------
	ShiftRegister	QutSh(		.Clock(				Clock),
								.Reset(				Reset),
								.Load(				Load),
								.Enable(			Enable),
								.PIn(				(|Quotient[(2*Width)-1:Width]) ? {Width{1'b1}} : Quotient[Width-1:0]),
								.SIn(				QutSerial),
								.POut(				Threshold),
								.SOut(				QutSerial));
	defparam		QutSh.PWidth =					Width;
	defparam		QutSh.SWidth =					1;
	defparam		QutSh.Reverse =					1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	LSb Select Shifter
	//--------------------------------------------------------------------------
	ShiftRegister	LSbSh(		.Clock(				Clock),
								.Reset(				Reset),
								.Load(				Load),
								.Enable(			Enable),
								.PIn(				{{Width-1{1'b0}}, 1'b1}),
								.SIn(				LSbSerial),
								.POut(				LSbSelect),
								.SOut(				LSbSerial));
	defparam		LSbSh.PWidth =					Width;
	defparam		LSbSh.SWidth =					1;
	defparam		LSbSh.Reverse =					1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Circular Comparator
	//--------------------------------------------------------------------------
	CircularComparator #(Width) Comparator(.Small(Threshold), .Large(Random ^ Aux), .Geq(NotOutBits), .LSb(LSbSelect));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Sequence/ButtonParse.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		ButtonParse
//	Desc:		This is a highly parameterized module which can be used to clean
//				up groups of related buttons used for human input.
//
//				This module essentially connects an edge detector after a
//				debouncer, one per-bit in the input bus.  However, by using a
//				"Half" bus from the debouncers this module can be used to
//				decode presses from combinations of buttons as long as the
//				original buttons and the derived "buttons" are all fed in as
//				separate input bits.  Thus the input might be something like
//				{Button[0] & Button[1], Button[1], Button[0]} in order to cause
//				different outputs when one, the other or both buttons are
//				pressed.
//
//				The output from this module is one-hot when the obvious parameter
//				is 1.
//
//	Params:		Width:		This sets the bitwidth of the input and output
//							busses.  Note that the signals are assumed to be
//							related as described above.
//				EdgeWidth:	The total number of bits the edge detectors should
//							look at to determine if an edge exists.
//				WdgeUpWidth:The number of edge bits which must be high to signal
//							an edge.  Obviously must be less than EdgeWidth.
//				BebWidth:	This is the width of the counter core of the
//							debouncer, which will require 2^width cycles for the
//							output to change, assuming no bounces on the input.
//				DebSimWidth:This is the value used instead of DebWidth for
//							simulation.
//				EdgeType:	number	type
//							0	posedge
//							1	negedge
//							2	both
//							3	neither
//				Related:	Binary flag specifying if the input signals are
//							related buttons (when 1) or if they should be
//							treated completely separately (when 0).
//				EnableEdge:	Forcibly enable the edge detectors at all times.
//							The debouncers will still use the Enable input.
//				Continuous:	
//				OutWidth:	The width of the output pulses to generate
//				AsyncReset: Make the reset input an asynchronous one
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module ButtonParse(Clock, Reset, Enable, In, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					1,
							EdgeWidth =				3,
							EdgeUpWidth =			2,
							DebWidth =				16,
							DebSimWidth =			4,
							EdgeType =				0,
							Related =				1,
							EnableEdge =			0,
							Continuous =			0,
							EdgeOutWidth =			1,
							AsyncReset =			0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset, Enable;
	input	[Width-1:0]		In;
	output	[Width-1:0]		Out;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[Width-1:0]		Debounced;	// The debounced versions of the inputs
	wire	[Width-1:0]		Edges;		// The edge detected versions of the inputs
	wire	[Width-1:0]		Half;		// Used to ensure the output is one-hot, even at human perception times...
	
	genvar					i;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Generated Instantiations
	//		Actually instantiate a debouncer and edge
	//		detector for each bit.  Notice the "Half" signal
	//		and how the constants will be optimized.
	//--------------------------------------------------------------------------
	generate for (i = 0; i < Width; i = i + 1) begin:BP
			Debouncer #(		.Width(				DebWidth),
								.SimWidth(			DebSimWidth),
								.Continuous(		Continuous),
								.AsyncReset(		AsyncReset))
					D(			.Clock(				Clock),
								.Reset(				Reset),
								.Enable(			Enable),
								.In(				In[i] & (Related ? ~|(Half & ~(1 << i)) : 1'b1)), // The complex masking removes the potential loop between half and the input
								.Out(				Debounced[i]),
								.Half(				Half[i]));
			if (EdgeType != 3) begin:ED
				EdgeDetect #(	.Width(				EdgeWidth),
								.UpWidth(			EdgeUpWidth),
								.Type(				EdgeType),
								.AsyncReset(		AsyncReset))
						ED(		.Clock(				Clock),
								.Reset(				Reset),
								.Enable(			EnableEdge ? 1'b1 : Enable),
								.In(				Debounced[i]),
								.Out(				Edges[i]));
			end else begin:NOED
				assign	Edges[i] =					Debounced[i];
			end
			if (EdgeOutWidth > 1) begin:PE
				PulseExpander #(.Width(				EdgeOutWidth),
								.AsyncReset(		AsyncReset))
						PE(		.Clock(				Clock),
								.Reset(				Reset),
								.In(				Edges[i]),
								.Out(				Out[i]));
			end else begin:NOPE
				assign Out[i] =						Edges[i];
			end
		end
	endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Sequence/Debouncer.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Debouncer
//	Desc:		A hysteresis loop based debouncer.  This module will ensure that
//				a noisy signal is at least somewhat clean before passing it back
//				out.  It provides the digital equivalent of inertia...
//
//	Params:		Width:		This is the width of the counter core of the
//							debouncer which will require 2^width cycles for the
//							output to change, assuming no bouncing.
//				SimWidth:	This is the value used instead of Width during
//							simulation.
//				Continuous:	
//				AsyncReset: Make the reset input an asynchronous one
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	Debouncer(Clock, Reset, Enable, In, Out, Half);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					16,
							SimWidth =				4,
							Continuous =			0,
							AsyncReset =			0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef SIMULATION
	localparam				XWidth =				SimWidth;
	`else
	localparam				XWidth =				Width;
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset, Enable;
	input					In;
	output					Out;
	output					Half;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	reg		[XWidth-1:0]	NextCount;
	wire	[XWidth-1:0]	Count;
	
	reg						NextOut;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	Half =									Count[XWidth-1];
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Limited Up/Down Counter
	//--------------------------------------------------------------------------
	always @ (*) begin
		if (Continuous ? Out : 1'b0) NextCount =	0;
		else if (In & (~&Count)) NextCount =		Count + 1;
		else if (~In & (|Count)) NextCount =		Count - 1;
		else NextCount =							Count;
	end
	
	Register		#(			.Width(				XWidth),
								.AsyncReset(		AsyncReset),
								.Initial(			0))
					CntReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			Enable),
								.In(				NextCount),
								.Out(				Count));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Hysteresis/Limit Detector
	//--------------------------------------------------------------------------
	always @ (*) begin
		if (&Count) NextOut =						1;
		else if (~|Count) NextOut =					0;
		else NextOut =								Out;
	end
	
	Register		#(			.Width(				1),
								.AsyncReset(		AsyncReset))
					OutReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			Enable),
								.In(				NextOut),
								.Out(				Out));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Sequence/DelayShift.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		DelayShift
//	Desc:		This is a length length delay line.  Tap will set the length of
//				the delay.  When Tap = 0, the delay will be one clock cycle.
//	Params:		Width:	Sets the bitwidth of the data
//				Length:	Sets the delay length
//------------------------------------------------------------------------------
module	DelayShift(Clock, Reset, Enable, In, Out, Tap);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					32,
							Length =				2,
							Initial =				{Length{1'b0}},
							AsyncReset =			0;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				TWidth =				`log2(Length);
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset, Enable;
	input	[Width-1:0]		In;
	output	[Width-1:0]		Out;
	input	[TWidth-1:0]	Tap;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	reg		[Width-1:0]		ShiftReg[0:Length-1] /* synthesis syn_srlstyle = select_srl */;
	integer					i;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	Out =									ShiftReg[Tap];
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Initialization
	//--------------------------------------------------------------------------
	initial begin
		if (Length > 1) begin
			// synthesis loop_limit 65536
			for (i = 0; i < Length; i = i + 1) begin
				ShiftReg[i][Width-1:0] <=			{Width{1'b0}};
			end
		end
		// synthesis loop_limit 65536
		for (i = 0; i < Length; i = i + 1) begin
			ShiftReg[i][0] <=						Initial[i];
		end
	end
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Behavioral Shift Register Core
	//--------------------------------------------------------------------------
	generate if (AsyncReset) begin:AR
		always @ (posedge Clock or posedge Reset) begin
			if (Reset) begin
				if (Length > 1) begin
					// synthesis loop_limit 65536
					for (i = 0; i < Length; i = i + 1) begin
						ShiftReg[i][Width-1:0] <=	{Width{1'b0}};
					end
				end
				// synthesis loop_limit 65536
				for (i = 0; i < Length; i = i + 1) begin
					ShiftReg[i][0] <=				Initial[i];
				end
			end
			else if (Enable) begin
				ShiftReg[0] <=						In;
				// synthesis loop_limit 65536
				for (i = 1; i < Length; i = i + 1) begin
					ShiftReg[i] <=					ShiftReg[i-1];
				end
			end
		end
	end else begin:SR
		always @ (posedge Clock) begin
			if (Reset) begin
				if (Length > 1) begin
					// synthesis loop_limit 65536
					for (i = 0; i < Length; i = i + 1) begin
						ShiftReg[i][Width-1:0] <=	{Width{1'b0}};
					end
				end
				// synthesis loop_limit 65536
				for (i = 0; i < Length; i = i + 1) begin
					ShiftReg[i][0] <=				Initial[i];
				end
			end
			else if (Enable) begin
				ShiftReg[0] <=						In;
				// synthesis loop_limit 65536
				for (i = 1; i < Length; i = i + 1) begin
					ShiftReg[i] <=					ShiftReg[i-1];
				end
			end
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Sequence/EdgeDetect.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		EdgeDetect
//	Desc:		A simple parameterized, shift-register based edge detector.
//				Note this module is fully moore-tyle, the output is isolated
//				from the input by a single flip-flop.
//	Params:		Width:		The number of previous samples of the input signal
//							to examine.  Also the width of the internal shift
//							register.
//				UpWidth:	The number of consecutive high samples which must
//							appear before the edge is signaled (assuming
//							posedge detection).
//				Type:	number	type
//						0	posedge
//						1	negedge
//						2	both
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module EdgeDetect(Clock, Reset, Enable, In, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				3,
							UpWidth = 				2,
							Type =					0,
							AsyncReset =			0,
							AsyncInput =			0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset, Enable;
	input					In;
	output reg				Out;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	wire	[Width-1:0]		Q;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Decoder
	//--------------------------------------------------------------------------
	always @ (Q) begin
		case (Type)
			0:	Out =								(~|Q[Width-1:UpWidth]) & (&Q[UpWidth-1:0]);
			1:	Out =								(&Q[Width-1:UpWidth]) & (~|Q[UpWidth-1:0]);
			2:	Out =								((~|Q[Width-1:UpWidth]) | (&Q[Width-1:UpWidth])) & ((~|Q[UpWidth-1:0]) | (&Q[UpWidth-1:0])) & (Q[Width-1] ^ Q[UpWidth-1]);
			default: Out =							1'bx;
		endcase
	end
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Shift Register
	//--------------------------------------------------------------------------
	generate if (AsyncInput) begin:ASYNCIN
		ShiftRegister #(		.PWidth(			Width - 1),
								.SWidth(			1),
								.AsyncReset(		AsyncReset))
					ShftReg(	.Clock(				Clock),
								.Reset(				Reset),
								.Load(				1'b0),
								.Enable(			Enable),
								.PIn(				{Width-1{1'bx}}),
								.SIn(				In),
								.POut(				Q[Width-1:1]),
								.SOut(				/* Unconnected */));
		assign	Q[0] =								In;
	end else begin:SYNCIN
		ShiftRegister #(		.PWidth(			Width),
								.SWidth(			1),
								.AsyncReset(		AsyncReset))
					ShftReg(	.Clock(				Clock),
								.Reset(				Reset),
								.Load(				1'b0),
								.Enable(			Enable),
								.PIn(				{Width{1'bx}}),
								.SIn(				In),
								.POut(				Q),
								.SOut(				/* Unconnected */));
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Sequence/LocalResetGen.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		LocalResetGen
//	Desc:		The purpose of this module is to generate two resets in a local
//				clock domain from one in a global clock domain.  The idea is to
//				handle situations where LocalClock is gated by the
//				LocalClockReset.  Thus LocalRegReset can be used to reset all
//				the registers clocked with LocalClock, as it is guarenteed to be
//				active during at least a few local clock cycles.  Note that
//				this module assumes that Clock is free-running.
//
//	Params:		ClockFreq:			Frequency of consistently free running Clock
//				LocalClockFreq:		Frequency of the slowest of all the local clocks
//				LCRTime:			Time to hold LocalClockReset in ns
//				LCTimeout:			Maximum timeout delay in ns, 0 to disable the timeout
//				NLClocks:			Number of local clocks
//				StartupReset:		Should this module reset the local clock at startup?
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module LocalResetGen(Clock, Reset, LocalClockSelect, LocalClocks, LocalClock, LocalClockReset, LocalRegReset, WasResetValid, WasResetReady);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				ClockFreq =				27000000,	//	Free running clock frequency
							LocalClockFreq =		25000000,	//	Should be the slowest of all the local clocks
							LCRTime =				1000,		//	Time to hold LocalClockReset in ns
							LCTimeout =				1000,		//	Minimum timeout delay in ns, 0 to disable the timeout
							NLClocks =				1,			//	Number of local clocks
							StartupReset =			1;			//	Should this module reset the local clock at startup?
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				RRWidth =				2,																								// Number of register stages when resynchronization the reset back to Clock to create TOSet
							RSRegTap =				1,																								// Shift tap to generate LocalRegisterReset on
							RSTOTap =				2,																								// Shift tap to determine timeout is unneeded 
							RSClockTap =			3,																								// Shift tap to start resetting the local clock on
							CF1K =					ClockFreq / 1000,
							LCF1K =					LocalClockFreq / 1000,
							LCRRound =				`max(0, `log2(CF1K) + `log2(LCRTime) - 31),														// Workaround to avoid overflow in multiplication for LCRCycles
							TORound =				`max(0, `log2(CF1K) + `log2(LCTimeout) - 31),													// Workaround to avoid overflow in multiplication for TOCycles
							RSWidthRegTap =			`max(RSRegTap, RSTOTap),																		// Workaround for spurious "recursive macro" problem in synthesis tools
							RSWidth =				`max(RSWidthRegTap, RSClockTap) + 1,															// Total width of the reset synchronization shifter 
							LCSWidth =				`max(1, `log2(NLClocks)),																		// LocalClockSelect width
							LCRCycles =				`divceil((LCRTime >> LCRRound) * CF1K, 1000000 >> LCRRound) + (RRWidth + 1),					// Number of Clock cycles to hold LocalClockReset high for, including the time to select a new clock
							TLCRCycles =			LCRCycles + `divceil(RSWidth * CF1K, LCF1K),													// Number of Clock cycles to hold LocalClockReset high for (includes time for synchronization)
							TLCRWidth =				`log2(TLCRCycles),																				// Total local clock reset count width
							TOCycles =				`divceil((CF1K * 4), LCF1K) + 1 + `divceil((LCTimeout >> TORound) * CF1K, 1000000 >> TORound),	// Timeout cycles (wait for 4 cycles of LocalClock, measured in Clock cycles, before giving up and re-resetting), plus 1 for "invalid", plus the user timeout
							TOWidth =				`log2(TOCycles);																				// Timeout count width
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Checks
	//--------------------------------------------------------------------------	
	`ifdef MODELSIM
		initial if (RSRegTap >= RSClockTap) $display("ERROR[%m @ %t]: Must reset local clock registers before the clock itself (%d >= %d)!", $time, RSRegTap, RSClockTap);
		initial if (RSTOTap <= RSRegTap) $display("ERROR:[%m @ %t] Must reset timeout after register reset is no longer asserted (%d <= %d)!", $time, RSTOTap, RSRegTap);
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System Inputs (@ Clock)
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	input	[LCSWidth-1:0]	LocalClockSelect;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Local Clock Domain
	//--------------------------------------------------------------------------
	input	[NLClocks-1:0]	LocalClocks;
	output					LocalClock;
	output					LocalClockReset, LocalRegReset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Reset Acknowledgement (@ Clock)
	//--------------------------------------------------------------------------
	output					WasResetValid;
	input					WasResetReady;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires and Regs
	//--------------------------------------------------------------------------
	wire	[TLCRWidth-1:0]	TLCRCount;
	wire					TLCRMax, LongReset;
	
	wire	[TOWidth-1:0]	TOCount;
	wire					TOMax, Timeout, StartTimeout, EndTimeout;
	
	reg		[RSWidth-1:0]	ResetSync =			0;
	wire					ResetResync_;
	
	wire					LCSEnable;
	wire	[LCSWidth-1:0]	CurrentClockSelect;
	wire					WasReset, WasResetTransfer;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	LongReset =								~TLCRMax;
	assign	Timeout =								(LCTimeout < 1) ? 1'b0 : TOMax;
	assign	StartTimeout =							~LongReset & Timeout;
	assign	EndTimeout =							LongReset & Timeout;
	
	assign	LocalRegReset =							ResetSync[RSRegTap];
	assign	LocalClockReset =						ResetSync[RSClockTap] & LongReset;
	
	assign	WasResetTransfer =						WasResetValid & WasResetReady;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Cycle Counter
	//--------------------------------------------------------------------------
	Counter			#(			.Width(				TLCRWidth),
								.Initial(			StartupReset ? {TLCRWidth{1'b0}} : {TLCRWidth{1'b1}}))
					TLCRCnt(	.Clock(				Clock),
								.Reset(				Reset | Timeout),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			LongReset & (~TLCRAlmost | ~ResetResync_)),
								.In(				{TLCRWidth{1'bx}}),
								.Count(				TLCRCount));
	CountCompare	#(			.Width(				TLCRWidth),
								.Compare(			TLCRCycles-2))
					TLCRAlmst(	.Count(				TLCRCount),
								.TerminalCount(		TLCRAlmost));
	CountCompare	#(			.Width(				TLCRWidth),
								.Compare(			TLCRCycles-1))
					TLCRCmp(	.Count(				TLCRCount),
								.TerminalCount(		TLCRMax));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Synchronize Reset to LocalClock
	//--------------------------------------------------------------------------
	always @ (posedge LocalClock or posedge Timeout) begin
		if (Timeout) ResetSync <=					{RSWidth{1'b1}};
		else ResetSync <=							{ResetSync[RSWidth-2:0], LongReset};
	end
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Resynchronize Shift Register
	//--------------------------------------------------------------------------
	ShiftRegister	#(			.PWidth(			RRWidth),
								.SWidth(			1))
					RRShift(	.Clock(				Clock),
								.Reset(				Reset | Timeout),
								.Load(				1'b0),
								.Enable(			1'b1),
								.PIn(				{RRWidth{1'bx}}),
								.SIn(				~ResetSync[RSClockTap]),
								.POut(				),
								.SOut(				ResetResync_));
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Timeout Counter
	//--------------------------------------------------------------------------
	Counter			#(			.Width(				TOWidth),
								.Initial(			{TOWidth{1'b0}}))
					TOCnt(		.Clock(				Clock),
								.Reset(				Reset | Timeout),
								.Set(				1'b0),
								.Load(				1'b0),
								.Enable(			~TOMax & ~(LongReset ^ ResetResync_)),
								.In(				{TOWidth{1'b0}}),
								.Count(				TOCount));
	CountCompare	#(			.Width(				TOWidth),
								.Compare(			TOCycles))
					TOCmp(		.Count(				TOCount),
								.TerminalCount(		TOMax));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clock Select State Logic
	//--------------------------------------------------------------------------
	generate if (NLClocks > 1) begin:MANYCLOCKS
		EdgeDetect	#(			.Width(				2),
								.UpWidth(			1),
								.Type(				0))
					LCSED(		.Clock(				Clock),
								.Reset(				Reset | Timeout),
								.Enable(			1'b1),
								.In(				~ResetResync_),
								.Out(				LCSEnable));
		Register	#(			.Width(				LCSWidth),
								.Initial(			1'b0))
					LCSReg(		.Clock(				Clock),
								.Reset(				1'b0),
								.Set(				1'b0),
								.Enable(			LCSEnable),
								.In(				LocalClockSelect),
								.Out(				CurrentClockSelect));
		Mux			#(			.Width(				1),
								.NPorts(			NLClocks))
					ClockMux(	.Select(			CurrentClockSelect),
								.Input(				LocalClocks),
								.Output(			LocalClock));
	end else begin:ONECLOCK
		assign	LocalClock =						LocalClocks;
	end endgenerate
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Was Reset State Logic
	//--------------------------------------------------------------------------
	EdgeDetect		#(			.Width(				2),
								.UpWidth(			1),
								.Type(				0))
					WRED(		.Clock(				Clock),
								.Reset(				Reset | Timeout),
								.Enable(			1'b1),
								.In(				ResetResync_),
								.Out(				WasReset));
	Register		#(			.Width(				1))
					WSReg(		.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			WasReset ^ WasResetTransfer),
								.In(				WasReset),
								.Out(				WasResetValid));
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Sequence/Pulse/PulseExpander.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		PulseExpander
//	Desc:		This module is designed to take a pulse signal in and widen it
//				to the specified number of cycles.  This is very useful in
//				clock crossings and reset generation.
//	Params:		Width:	Sets the width (in cycles) of the output
//				pulse
//------------------------------------------------------------------------------
module	PulseExpander(Clock, Reset, In, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width =					2,
							Async =					0,
							AsyncReset =			0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				IWidth =				Async ? (Width - 1) : Width,
	`ifdef MACROSAFE
							I1Width =				`max(IWidth, 1);
	`else
							I1Width =				IWidth;
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset, In;
	output					Out;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire	[I1Width-1:0]	Next;
	wire	[I1Width-1:0]	Internal;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	generate if (IWidth > 0) begin:IW0PLUS
		assign	Out =								Internal[IWidth-1] | (Async ? In : 1'b0);
	end else begin:IW0
		assign	Out =								(Async ? In : 1'b0);
	end endgenerate
	
	generate if (IWidth > 1) begin:IW1PLUS
		assign	Next =								{Internal[IWidth-2:0], 1'b0};
	end else begin:IW1
		assign	Next =								1'b0;
	end endgenerate
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Behavioral Shift Register Core
	//--------------------------------------------------------------------------
	generate if (IWidth > 0) begin:SHIFT
		Register	#(			.Width(				I1Width),
								.AsyncReset(		AsyncReset))
					Register(	.Clock(				Clock),
								.Reset(				Reset),
								.Set(				In),
								.Enable(			1'b1),
								.In(				Next),
								.Out(				Internal));
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Sequence/Pulse/PulseOffset.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		PulseOffset
//	Desc:		Generate two signals both of which are delayed versions on an
//				input, and whose relative delay is specified by a parameter:
//				Offset.
//	Params:		Offset:	The number of cycles between the first output being
//						pulsed and the second output being pulsed.  May be
//						negative.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	PulseOffset(Clock, Input, FirstOutput, SecondOutput);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Offset =				1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				Delay =					`max(Offset, -Offset),
							Swap =					Offset < 0;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Inputs & Outputs
	//--------------------------------------------------------------------------
	input					Clock, Input;
	output					FirstOutput, SecondOutput;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assign Statements
	//--------------------------------------------------------------------------
	generate if (Swap) begin:SWAPPED
		assign	SecondOutput =						Input;
	end else begin:NOTSWAPPED
		assign	FirstOutput =						Input;
	end endgenerate
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Delay Shifter
	//--------------------------------------------------------------------------
	ShiftRegister	#(			.PWidth(			Delay),
								.SWidth(			1))
					TopSel(		.Clock(				Clock),
								.Reset(				1'b0),
								.Load(				1'b0),
								.Enable(			1'b1),
								.PIn(				{Delay{1'bx}}),
								.SIn(				Input),
								.POut(				),
								.SOut(				Swap ? FirstOutput : SecondOutput));
	//--------------------------------------------------------------------------
endmodule	
//------------------------------------------------------------------------------
//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Sequence/Pulse/PulseRetime.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		PulseRetime
//	Desc:		This module will retime a pulse from one clock domain to another
//	Params:		inclockfreq:	Input clock frequency
//				outclockfreq:	Output clock frequency
//------------------------------------------------------------------------------
module	PulseRetime(InClock, InReset, In, OutClock, OutReset, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				InClockFreq =			25000000,
							OutClockFreq =			12288000,
							AsyncInReset =			0,
							AsyncOutReset =			0;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				ExpWidth =				(InClockFreq < OutClockFreq) ? 2 : ((InClockFreq / OutClockFreq) + 1);
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					InClock, InReset;
	input					In;
	input					OutClock, OutReset;
	output					Out;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					InExtended, OutExtended;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Pulse Expander
	//--------------------------------------------------------------------------
	PulseExpander	Exp(		.Clock(				InClock), 
								.Reset(				InReset),
								.In(				In), 
								.Out(				InExtended));
	defparam 		Exp.Width =						ExpWidth;
	defparam		Exp.AsyncReset =				AsyncInReset;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	ShiftRegister
	//--------------------------------------------------------------------------
	ShiftRegister	SR(			.Clock(				OutClock), 
								.Reset(				OutReset),
								.Load(				1'b0), 
								.Enable(			1'b1),
								.PIn(				2'bxx),
								.SIn(				InExtended), 
								.POut(				), 
								.SOut(				OutExtended));
	defparam 		SR.PWidth =						2;
	defparam 		SR.SWidth =						1;
	defparam		SR.AsyncReset =					AsyncOutReset;
	//--------------------------------------------------------------------------

 	//--------------------------------------------------------------------------
	//	EdgeDetect
	//--------------------------------------------------------------------------
	EdgeDetect		Edge(		.Clock(				OutClock),
								.Reset(				OutReset), 
								.Enable(			1'b1),
								.In(				OutExtended),
								.Out(				Out));
	defparam		Edge.UpWidth =					1;
	defparam		Edge.Width =					2;
	defparam		Edge.AsyncReset =				AsyncOutReset;
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Simulation/BusModel.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Defines and Constants
//==============================================================================
`timescale		1 ps/1 ps		// Display things in ps, compute them in ps
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		BusModel
//	Desc:		Models a bidirectional bus with optionally asymetric delays.
//				Note that this model may misbehave in the even of input
//				transitions on both the A and B ports within a single simulation
//				timestep.  Note that all of the wires in the bus are completely
//				independent from one another.
//	Params:		ABDelay:The delay from an input change on A to the output change
//				on B measured in picoseconds.
//				BADelay:The delay from an input change on B to the output change
//				on B measured in picoseconds.
//				Width:	The width of the bus to model
//				ClockFreq:The rough (maximum) clock frequency of the signals
//						being sent over this bus.  Normally a delay larger than
//						the period of a signal will cause problems, by informing
//						the module of the period (frequency) we can avoid these
//						problems.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	BusModel(A, B);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				ABDelay =				0,
							BADelay =				0,
							Width =					1,
							ClockFreq =				100000000;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Ports
	//--------------------------------------------------------------------------
	inout	[Width-1:0]		A, B;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	genvar					i;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wire Models
	//--------------------------------------------------------------------------
	generate for (i = 0; i < Width; i = i + 1) begin:WIREMODELS
		WireModel	#(			.ABDelay(			ABDelay),
								.BADelay(			BADelay),
								.ClockFreq(			ClockFreq))
					WM(			.A(					A[i]),
								.B(					B[i]));
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Simulation/ClockSource.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Defines and Constants
//==============================================================================
`timescale		1 ps/1 ps		// Display things in ps, compute them in ps
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		ClockSource
//	Desc:		This module will use behavioral verilog to generate a properly
//				gated clock source at any frequency you desire.
//	Params:		ClockFreq:	Desired output clock frequency
//				SyncDisable: Will cause this generator to wait for a low value
//							on the clock before disabling it when Enable
//							transitions to low.
//				Phase:
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module ClockSource(Enable, Clock);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter real			ClockFreq =				100000000,
							SyncDisable =			1,
							Phase =					0;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam real			Delay =					500000000/(ClockFreq/1000),
							PhaseDelay =			Delay * Phase / 180;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input					Enable;
	output					Clock;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires & Reg
	//--------------------------------------------------------------------------
	reg						Clock =					1'b0;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Gated Clock Source
	//--------------------------------------------------------------------------
	always @ (posedge Enable) begin
		#(Delay);
		#(PhaseDelay);
		while (Enable) begin
			Clock =									~Clock;
			#(Delay);
		end
		if (Clock && SyncDisable) Clock =			1'b0;
	end
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/Simulation/WireModel.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Defines and Constants
//==============================================================================
`timescale		1 ps/1 ps		// Display things in ps, compute them in ps
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		WireModel
//	Desc:		Models a bidirectional wire with optionally asymetric delays.
//				Note that this model may misbehave in the even of input
//				transitions on both the A and B ports within a single simulation
//				timestep.
//	Params:		ABDelay:The delay from an input change on A to the output change
//				on B measured in picoseconds.
//				BADelay:The delay from an input change on B to the output change
//				on B measured in picoseconds.
//				ClockFreq:The rough (maximum) clock frequency of the signals
//						being sent over this bus.  Normally a delay larger than
//						the period of a signal will cause problems, by informing
//						the module of the period (frequency) we can avoid these
//						problems.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	WireModel(A, B);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				ABDelay =				0,
							BADelay =				0,
							ClockFreq =				100000000;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				ClockPeriod =			((1000000000 / ClockFreq) * 1000) / 2;
	localparam integer		ABInteger =				ABDelay,
							BAInteger =				BADelay,
							ABShift =				ABInteger / ClockPeriod,
							BAShift =				BAInteger / ClockPeriod,
							ABAlways =				ABInteger - (ABShift * ClockPeriod),
							BAAlways =				BAInteger - (BAShift * ClockPeriod);
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Ports
	//--------------------------------------------------------------------------
	inout					A, B;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	reg						AReg =					1'bz,
							BReg =					1'bz,
							Direction =				1'b0;
	
	wire					AShifted, BShifted;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	A =										AReg;
	assign 	B =										BReg;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wire Delay Modeling
	//--------------------------------------------------------------------------
	always @ (AShifted or BShifted or Direction) begin
		if (Direction) begin
			AReg <= #BAAlways						BShifted;
			BReg <=									1'bz;
		end else begin
			BReg <= #ABAlways						AShifted;
			AReg <=									1'bz;
		end
	end
	
	always @ (A or B) begin
		if (A !== AReg) Direction <=				1'b0;
		else if (BReg !== B) Direction <=			1'b1;
		else Direction <=							Direction;
	end
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Shift Delay Lines
	//--------------------------------------------------------------------------
	generate if (ABShift > 0) begin:ABSHIFT
		genvar				i;
		wire [ABShift-1:0]	AShiftLine;
		
		assign	#ClockPeriod AShiftLine[0] =		A;
		
		for (i = 1; i < ABShift; i = i + 1) begin:DELAY
			assign	#ClockPeriod AShiftLine[i] =	AShiftLine[i-1];
		end
		
		assign	AShifted =							AShiftLine[ABShift-1];
	end else begin:ABNOSHIFT
		assign	AShifted =							A;
	end endgenerate
	
	generate if (BAShift > 0) begin:BASHIFT
		genvar				j;
		wire [BAShift-1:0]	BShiftLine;
		
		assign	#ClockPeriod BShiftLine[0] =		B;
		
		for (j = 1; j < BAShift; j = j + 1) begin:DELAY
			assign	#ClockPeriod BShiftLine[j] =	BShiftLine[j-1];
		end
		
		assign	BShifted =							BShiftLine[BAShift-1];
	end else begin:BANOSHIFT
		assign	BShifted =							B;
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/State/HardRegister.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		HardRegister
//	Desc:		A register which should not be removed by synthesis
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	HardRegister(Clock, Reset, Set, Enable, In, Out) /* synthesis syn_hier = "hard" */;
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				32,
							Initial =				{Width{1'bx}},
							AsyncReset =			0,
							AsyncSet =				0,
							ResetValue =			{Width{1'b0}},
							SetValue =				{Width{1'b1}};
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Inputs & Outputs
	//--------------------------------------------------------------------------
	input					Clock, Enable, Reset, Set;
	input	[Width-1:0]		In;
	output reg [Width-1:0]	Out =					Initial /* synthesis syn_keep = 1 */;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Behavioral Register
	//--------------------------------------------------------------------------
	generate if (AsyncReset) begin:AR
		if (AsyncSet) begin:AS
			always @ (posedge Clock or posedge Reset or posedge Set) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end else begin:SS
			always @ (posedge Clock or posedge Reset) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end
	end else begin:SR
		if (AsyncSet) begin:AS
			always @ (posedge Clock or posedge Set) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end else begin:SS
			always @ (posedge Clock) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/State/HardShiftRegister.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		HardShiftRegister
//	Desc:		This is a general parallel to serial and serial to parallel
//				converter.  Note that it can work with 'serial' data streams
//				that are more than a single bit wide.  This is useful for
//				example when a signal must cross a 32b/8b boundary.
//				This also means it can be used to delay a signal quite easily.
//	Params:		PWidth:	Sets the bitwidth of the parallel data (both in and
//						out of the module)
//				SWidth:	Sets the bitwidth of the serial data (both in and out
//						of the module)
//				Reverse:Shift MSb to LSb?
//	Ex:			(32,1) will convert 32bit wide data into 1bit serial data
//				(32,8) will convert 32bit words into bytes
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	HardShiftRegister(Clock, Reset, Load, Enable, PIn, SIn, POut, SOut);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				PWidth =				32,		// The parallel width
							SWidth =				1,		// The serial width
							Reverse =				0,
							Initial =				{PWidth{1'bx}},
							AsyncReset =			0;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Control Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset, Load, Enable;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Parallel and Serial I/O
	//--------------------------------------------------------------------------
	input	[PWidth-1:0]	PIn;
	input	[SWidth-1:0]	SIn;
	output	[PWidth-1:0]	POut;
	output	[SWidth-1:0]	SOut;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	SOut =									Reverse ? POut[SWidth-1:0] : POut[PWidth-1:PWidth-SWidth];
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Behavioral Shift Register Core
	//--------------------------------------------------------------------------
	generate if (PWidth == SWidth) begin:REG
		HardRegister #(			.Width(				PWidth),
								.Initial(			Initial),
								.AsyncReset(		AsyncReset))
					Register(	.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			Load | Enable),
								.In(				Load ? PIn : SIn),
								.Out(				POut));
	end else begin:SHIFT
		HardRegister #(			.Width(				PWidth),
								.Initial(			Initial),
								.AsyncReset(		AsyncReset))
					Register(	.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			Load | Enable),
								.In(				Load ? PIn : (Reverse ? {SIn, POut[PWidth-1:SWidth]} : {POut[PWidth-SWidth-1:0], SIn})),
								.Out(				POut));
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/State/IORegister.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		IORegister
//	Desc:		A register which should be packed in to IO pads.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	IORegister(Clock, Reset, Set, Enable, In, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				32,
							Initial =				{Width{1'bx}},
							AsyncReset =			0,
							AsyncSet =				0,
							ResetValue =			{Width{1'b0}},
							SetValue =				{Width{1'b1}};
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Inputs & Outputs
	//--------------------------------------------------------------------------
	input					Clock, Enable, Reset, Set;
	input	[Width-1:0]		In;
	output reg [Width-1:0]	Out =					Initial /* synthesis syn_useioff = 1 iob = true useioff = 1 */;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Behavioral Register
	//--------------------------------------------------------------------------
	generate if (AsyncReset) begin:AR
		if (AsyncSet) begin:AS
			always @ (posedge Clock or posedge Reset or posedge Set) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end else begin:SS
			always @ (posedge Clock or posedge Reset) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end
	end else begin:SR
		if (AsyncSet) begin:AS
			always @ (posedge Clock or posedge Set) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end else begin:SS
			always @ (posedge Clock) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gateforge.org:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/State/RAM.v $
//	Version:	$Revision: 12633 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		RAM
//	Desc:		...
//	Params:		DWidth:	Data width
//				AWidth:	Address width
//				RLatency: Number of clock cycles between Address and DOut.
//						Can be 0 for asynchronous read.
//				WLatency: Number of clock cycles between Write and the change.
//						Can be 0 for asynchronous write.
//				NPorts:	Every signal gets its own set of ports.
//				WriteMask: A NPorts-bit wide signal, with a 1'b1 for each port
//						which can write, and a 1'b0 for each port which cannot.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 12633 $
//------------------------------------------------------------------------------
module	RAM(Clock, Reset, Enable, Write, Address, DIn, DOut);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				DWidth = 				32,
							AWidth =				10,
							RLatency =				1,
							WLatency =				1,
							NPorts =				1,
							WriteMask =				{NPorts{1'b1}},
							EnableInitial =			0,
							Initial =				0,	// Must be set to a (MaxAddress * DWidth) width vector
							EnableHexInitFile =		0,
							HexInitFile =			"",
							AsyncReset =			0;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				MaxAddress =			`pow2(AWidth);
	`endif
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	I/O
	//--------------------------------------------------------------------------
	input	[NPorts-1:0]	Clock, Reset, Enable, Write;
	input	[(AWidth*NPorts)-1:0] Address;
	input	[(DWidth*NPorts)-1:0] DIn;
	output	[(DWidth*NPorts)-1:0] DOut;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	reg		[DWidth-1:0]	Mem[0:MaxAddress-1];
	// attribute ram_style of Mem is block
	
	genvar					i, j, k;
	wire					Write_DELAY[NPorts-1:0];
	reg		[AWidth-1:0]	ReadAddress_DELAY[NPorts-1:0];
	wire	[AWidth-1:0]	WriteAddress_DELAY[NPorts-1:0];
	wire	[DWidth-1:0]	DIn_DELAY[NPorts-1:0];
	reg		[DWidth-1:0]	DOut_DELAY[NPorts-1:0];
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Initialization
	//--------------------------------------------------------------------------
	generate if (EnableInitial) begin:ENINITVECTOR
		for (k = 0; k < MaxAddress; k = k + 1) begin:INIT
			initial	Mem[k] =						Initial[(k*DWidth)+DWidth-1:(k*DWidth)];
		end
	end endgenerate
	generate if (EnableHexInitFile) begin:ENINITFILE
		initial $readmemh(HexInitFile, Mem);
	end endgenerate
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Read Logic
	//--------------------------------------------------------------------------
	generate for (i = 0; i < NPorts; i = i + 1) begin:PORTS_READ
		if (RLatency < 1) begin:ASYNC_READ
			//------------------------------------------------------------------
			//	Asynchronous Read Logic
			//------------------------------------------------------------------
			assign	DOut[(DWidth*i)+DWidth-1:(DWidth*i)] = Mem[Address[(AWidth*i)+AWidth-1:(AWidth*i)]];
			//------------------------------------------------------------------
		end else begin:SYNC_READ
			//------------------------------------------------------------------
			//	Read Address Delay
			//------------------------------------------------------------------
			if ((WLatency < 1) || (!WriteMask[i])) begin:NONSYNC_WRITE
				always @ (posedge Clock[i]) begin
					if (Reset[i]) DOut_DELAY[i] <= 0;
					else if (Enable[i]) DOut_DELAY[i] <= Mem[Address[(AWidth*i)+AWidth-1:(AWidth*i)]];
				end
			end
			//------------------------------------------------------------------
			if (RLatency == 1) begin:ONESYNC_READ
				//--------------------------------------------------------------
				//	Memory Read
				//--------------------------------------------------------------
				assign DOut[(DWidth*i)+DWidth-1:(DWidth*i)] = DOut_DELAY[i];
				//--------------------------------------------------------------
			end else begin:MULTISYNC_READ
				//--------------------------------------------------------------
				//	Synchronous Read Logic
				//--------------------------------------------------------------
				ShiftRegister #(.PWidth(			DWidth * (RLatency-1)),
								.SWidth(			DWidth),
								.AsyncReset(		AsyncReset))
							RDDelay(.Clock(			Clock[i]),
								.Reset(				Reset[i]),
								.Load(				1'b0),
								.Enable(			Enable[i]),
								.PIn(				{DWidth * (RLatency-1){1'bx}}),
								.SIn(				DOut_DELAY[i]),
								.POut(				),
								.SOut(				DOut[(DWidth*i)+DWidth-1:(DWidth*i)]));
				//--------------------------------------------------------------
			end
		end
	end endgenerate
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Write Logic
	//--------------------------------------------------------------------------
	generate for (j = 0; j < NPorts; j = j + 1) begin:PORTS_WRITE
		if (WriteMask[j]) begin:WRITABLE
			if (WLatency < 1) begin:ASYNC_WRITE
				//--------------------------------------------------------------
				//	Asynchronous Write Logic
				//--------------------------------------------------------------
				always @ (posedge Write[j] or posedge Enable[j]) if (Write[j] & Enable[j]) Mem[Address[(AWidth*j)+AWidth-1:(AWidth*j)]] <= DIn[(DWidth*j)+DWidth-1:(DWidth*j)];
				//--------------------------------------------------------------
			end else if (WLatency == 1) begin:SYNC_WRITE_1
				//--------------------------------------------------------------
				//	Latency 1 Write Logic
				//--------------------------------------------------------------
				if (RLatency < 1) begin:ONESYNC_READ
					always @ (posedge Clock[j]) begin
						if (Enable[j] & Write[j]) Mem[Address[(AWidth*j)+AWidth-1:(AWidth*j)]] <= DIn[(DWidth*j)+DWidth-1:(DWidth*j)];
					end
				end else begin:MULTISYNC_READ
					always @ (posedge Clock[j]) begin
						if (Enable[j]) begin
							if (Write[j]) Mem[Address[(AWidth*j)+AWidth-1:(AWidth*j)]] <= DIn[(DWidth*j)+DWidth-1:(DWidth*j)];
							DOut_DELAY[j] <= Mem[Address[(AWidth*j)+AWidth-1:(AWidth*j)]];
						end
					end
				end
				//--------------------------------------------------------------
			end else begin:SYNC_WRITE_MORE
				//--------------------------------------------------------------
				//	Synchronous Write Logic
				//--------------------------------------------------------------
				if (RLatency < 1) begin:ONESYNC_READ
					always @ (posedge Clock[j]) begin
						if (Enable[j] & Write_DELAY[j]) Mem[WriteAddress_DELAY[j]] <= DIn_DELAY[j];
					end
				end else begin:MULTISYNC_READ
					always @ (posedge Clock[j]) begin
						if (Enable[j]) begin
							if (Write_DELAY[j]) Mem[WriteAddress_DELAY[j]] <= DIn_DELAY[j];
							DOut_DELAY[j] <= Mem[Address[(AWidth*j)+AWidth-1:(AWidth*j)]];
						end
					end
				end
	
				ShiftRegister #(.PWidth(			(DWidth+AWidth+1) * (WLatency - 1)),
								.SWidth(			DWidth+AWidth+1),
								.AsyncReset(		AsyncReset))
							WDelay(.Clock(			Clock[j]),
								.Reset(				Reset[j]),
								.Load(				1'b0),
								.Enable(			Enable[j]),
								.PIn(				{(DWidth+AWidth+1) * (WLatency - 1){1'bx}}),
								.SIn(				{DIn[(DWidth*j)+DWidth-1:(DWidth*j)], Address[(AWidth*j)+AWidth-1:(AWidth*j)], Write[j] & Enable[j]}),
								.POut(				),
								.SOut(				{DIn_DELAY[j], WriteAddress_DELAY[j], Write_DELAY[j]}));
				//--------------------------------------------------------------
			end
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/State/RAM2RegisterFile.v $
//	Version:	$Revision: 11950 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Section:	Includes
//==============================================================================
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		RAM2RegisterFile
//	Desc:		...
//	Params:		Width:	Width of the register file
//				Depth:	Depth of the register file
//				RLatency: Number of clock cycles between RAMAddress and RAMDOut.
//						Can be 0 for asynchronous read.
//				WLatency: Number of clock cycles between RAMWrite and the
//						change.  Must be 1 or larger as register files are
//						synchronous!
//				WriteMask: A 1bit wide signal indicating whether writes are
//						allowed.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11950 $
//------------------------------------------------------------------------------
module	RAM2RegisterFile(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	RAM Interface
			//------------------------------------------------------------------
			RAMEnable,
			RAMWrite,
			RAMAddress,
			RAMDIn,
			RAMDOut,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Register Interface
			//------------------------------------------------------------------
			RegReset,
			RegSet,
			RegEnable,
			RegIn,
			RegOut
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				32,
							Depth =					4,
							RLatency =				0,
							WLatency =				1,
							WriteMask =				1'b1;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				AWidth =				`log2(Depth),
							RFWidth =				Width * Depth;
	`endif
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	RAM Interface
	//--------------------------------------------------------------------------
	input					RAMEnable, RAMWrite;
	input	[AWidth-1:0]	RAMAddress;
	input	[Width-1:0]		RAMDIn;
	output	[Width-1:0]		RAMDOut;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Register Interface
	//--------------------------------------------------------------------------
	output	[Depth-1:0]		RegReset, RegSet, RegEnable;
	output	[RFWidth-1:0]	RegIn;
	input	[RFWidth-1:0]	RegOut;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	genvar					i, j;
	wire					RAMWrite_DELAY;
	wire	[AWidth-1:0]	RAMAddress_DELAY;
	wire	[Width-1:0]		RAMDIn_DELAY, RAMDOut_DELAY;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	RegReset =								{Depth{1'b0}};
	assign	RegSet =								{Depth{1'b0}};
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Read Logic
	//--------------------------------------------------------------------------
	generate
		for (i = 0; i < Depth; i = i + 1) begin:READMUX
			assign	RAMDOut_DELAY =					(RAMAddress == i) ? RegOut[(Width*i)+Width-1:Width*i] : {Width{1'bz}};
		end
		
		if (RLatency < 1) begin:ASYNC_READ
			//------------------------------------------------------------------
			//	Asynchronous Read Logic
			//------------------------------------------------------------------
			assign	RAMDOut =						RAMDOut_DELAY;
			//------------------------------------------------------------------
		end else begin:SYNC_READ
			//------------------------------------------------------------------
			//	Synchronous Read Logic
			//------------------------------------------------------------------
			ShiftRegister #(	.PWidth(			Width * RLatency),
								.SWidth(			Width))
							RDelay(.Clock(			Clock),
								.Reset(				Reset),
								.Load(				1'b0),
								.Enable(			RAMEnable),
								.PIn(				{Width * RLatency{1'bx}}),
								.SIn(				RAMDOut_DELAY),
								.POut(				),
								.SOut(				RAMDOut));
			//------------------------------------------------------------------
		end
	endgenerate
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Write Logic
	//--------------------------------------------------------------------------
	generate
		for (j = 0; j < Depth; j = j + 1) begin:WRITEMUX
			assign	RegIn[(Width*j)+Width-1:Width*j] = RAMDIn_DELAY;
			assign	RegEnable[j] =					(RAMAddress_DELAY == j) & RAMWrite_DELAY;
		end
		
		if (WriteMask) begin:WRITABLE
			if (WLatency < 1) begin:ASYNC_WRITE
				initial $display("ERROR[%m @ %t]: Cannot write to a register file asynchronously!", $time);
			end else if (WLatency == 1) begin:SYNC_WRITE_1
				//--------------------------------------------------------------
				//	Latency 1 Write Logic
				//--------------------------------------------------------------
				assign	RAMWrite_DELAY =			RAMWrite & RAMEnable;
				assign	RAMAddress_DELAY =			RAMAddress;
				assign	RAMDIn_DELAY =				RAMDIn;
				//--------------------------------------------------------------
			end else begin:SYNC_WRITE_MORE
				//--------------------------------------------------------------
				//	Synchronous Write Logic
				//--------------------------------------------------------------
				ShiftRegister #(.PWidth(			(Width+AWidth+1) * (WLatency - 1)),
								.SWidth(			Width+AWidth+1))
							WDelay(.Clock(			Clock),
								.Reset(				Reset),
								.Load(				1'b0),
								.Enable(			RAMEnable),
								.PIn(				{(Width+AWidth+1) * (WLatency - 1){1'bx}}),
								.SIn(				{RAMDIn, RAMAddress, RAMWrite & RAMEnable}),
								.POut(				),
								.SOut(				{DIn_DELAY, Address_DELAY, Write_DELAY}));
				//--------------------------------------------------------------
			end
		end
	endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/State/Register.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		Register
//	Desc:		If you don't know, I can't help you.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	Register(Clock, Reset, Set, Enable, In, Out);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				32,
							Initial =				{Width{1'bx}},
							AsyncReset =			0,
							AsyncSet =				0,
							ResetValue =			{Width{1'b0}},
							SetValue =				{Width{1'b1}};
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Inputs & Outputs
	//--------------------------------------------------------------------------
	input					Clock, Enable, Reset, Set;
	input	[Width-1:0]		In;
	output reg [Width-1:0]	Out =					Initial;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Behavioral Register
	//--------------------------------------------------------------------------
	generate if (AsyncReset) begin:AR
		if (AsyncSet) begin:AS
			always @ (posedge Clock or posedge Reset or posedge Set) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end else begin:SS
			always @ (posedge Clock or posedge Reset) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end
	end else begin:SR
		if (AsyncSet) begin:AS
			always @ (posedge Clock or posedge Set) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end else begin:SS
			always @ (posedge Clock) begin
				if (Reset) Out <=					ResetValue;
				else if (Set) Out <=				SetValue;
				else if (Enable) Out <=				In;
			end
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/State/RegisterFile.v $
//	Version:	$Revision: 11950 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		RegisterFile
//	Desc:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11950 $
//------------------------------------------------------------------------------
module	RegisterFile(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Register Interface
			//------------------------------------------------------------------
			RegReset,
			RegSet,
			RegEnable,
			RegIn,
			RegOut
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				32,
							Depth =					1,
							Initial =				{Width * Depth{1'bx}},
							ResetValue =			{Width * Depth{1'b0}},
							SetValue =				{Width * Depth{1'b1}};
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				RFWidth =				Width * Depth;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	System Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Register Interface
	//--------------------------------------------------------------------------
	input	[Depth-1:0]		RegReset, RegSet, RegEnable;
	input	[RFWidth-1:0]	RegIn;
	output	[RFWidth-1:0]	RegOut;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	genvar					i;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Registers
	//--------------------------------------------------------------------------
	generate for (i = 0; i < Depth; i = i + 1) begin:REGISTER
		Register	#(			.Width(				Width),
								.Initial(			Initial[(Width*i)+Width-1:Width*i]),
								.ResetValue(		ResetValue[(Width*i)+Width-1:Width*i]),
								.SetValue(			SetValue[(Width*i)+Width-1:Width*i]))
					Reg(		.Clock(				Clock),
								.Reset(				Reset | RegReset[i]),
								.Set(				RegSet[i]),
								.Enable(			RegEnable[i]),
								.In(				RegIn[(Width*i)+Width-1:Width*i]),
								.Out(				RegOut[(Width*i)+Width-1:Width*i]));
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/State/RegisterFileMultiport.v $
//	Version:	$Revision: 11950 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		RegisterFileMultiport
//	Desc:		...
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11950 $
//------------------------------------------------------------------------------
module	RegisterFileMultiport(
			//------------------------------------------------------------------
			//	Clock & Reset Inputs
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
			
			//------------------------------------------------------------------
			//	Register Interface
			//------------------------------------------------------------------
			MultiRegReset,
			MultiRegSet,
			MultiRegEnable,
			MultiRegIn,
			MultiRegOut,

			RegReset,
			RegSet,
			RegEnable,
			RegIn,
			RegOut
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				Width = 				32,
							Depth =					1,
							NPorts =				1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------
	localparam				RFWidth =				Width * Depth,
							MDepth =				Depth * NPorts,
							MRFWidth =				RFWidth * NPorts;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	System Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Register Interface
	//--------------------------------------------------------------------------
	input	[MDepth-1:0]	MultiRegReset, MultiRegSet, MultiRegEnable;
	input	[MRFWidth-1:0]	MultiRegIn;
	output	[MRFWidth-1:0]	MultiRegOut;
	
	output reg [Depth-1:0]	RegReset, RegSet, RegEnable;
	output	[RFWidth-1:0]	RegIn;
	input	[RFWidth-1:0]	RegOut;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------
	reg		[NPorts-1:0]	MultiRegEnable_CORNER[Depth-1:0];
	wire	[NPorts-1:0]	MultiRegEnable_SELECT[Depth-1:0];
	
	genvar					i, k;
	integer					j;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	generate for (i = 0; i < Depth; i = i + 1) begin:REGISTERS
		always @ (*) begin
			RegReset[i] =							1'b0;
			RegSet[i] =								1'b0;
			RegEnable[i] =							1'b0;
			for (j = 0; j < NPorts; j = j + 1) begin
				RegReset[i] =						RegReset[i] | MultiRegReset[(j*Depth)+i];
				RegSet[i] =							RegSet[i] | MultiRegSet[(j*Depth)+i];
				RegEnable[i] =						RegEnable[i] | MultiRegEnable[(j*Depth)+i];
				MultiRegEnable_CORNER[i][j] =		MultiRegEnable[(j*Depth)+i];
			end
		end
		
		PrioritySelect #(.Width(NPorts)) PS(.Valid(MultiRegEnable_CORNER[i]), .Select(MultiRegEnable_SELECT[i]));
		
		for (k = 0; k < NPorts; k = k + 1) begin:NPORTS
			assign	RegIn[(Width*i)+Width-1:Width*i] = MultiRegEnable_SELECT[i][k] ? MultiRegIn[(Width*i)+(Depth*k*Width)+Width-1:(Width*i)+(Depth*k*Width)] : {Width{1'bz}};
		end
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gdgib.com:26/Projects/GateLib/branches/dev/Core/GateCore/Hardware/State/ShiftRegister.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.gdgib.com/)
//	Copyright:	Copyright 2003-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		ShiftRegister
//	Desc:		This is a general parallel to serial and serial to parallel
//				converter.  Note that it can work with 'serial' data streams
//				that are more than a single bit wide.  This is useful for
//				example when a signal must cross a 32b/8b boundary.
//				This also means it can be used to delay a signal quite easily.
//	Params:		PWidth:	Sets the bitwidth of the parallel data (both in and
//						out of the module)
//				SWidth:	Sets the bitwidth of the serial data (both in and out
//						of the module)
//				Reverse:Shift MSb to LSb?
//	Ex:			(32,1) will convert 32bit wide data into 1bit serial data
//				(32,8) will convert 32bit words into bytes
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 11840 $
//------------------------------------------------------------------------------
module	ShiftRegister(Clock, Reset, Load, Enable, PIn, SIn, POut, SOut);
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter				PWidth =				32,		// The parallel width
							SWidth =				1,		// The serial width
							Reverse =				0,
							Initial =				{PWidth{1'bx}},
							AsyncReset =			0,
							AsyncSet =				0,
							ResetValue =			{PWidth{1'b0}},
							SetValue =				{PWidth{1'b1}};
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Control Inputs
	//--------------------------------------------------------------------------
	input					Clock, Reset, Load, Enable;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Parallel and Serial I/O
	//--------------------------------------------------------------------------
	input	[PWidth-1:0]	PIn;
	input	[SWidth-1:0]	SIn;
	output 	[PWidth-1:0]	POut;
	output	[SWidth-1:0]	SOut;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Assigns
	//--------------------------------------------------------------------------
	assign	SOut =									Reverse ? POut[SWidth-1:0] : POut[PWidth-1:PWidth-SWidth];
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Behavioral Shift Register Core
	//--------------------------------------------------------------------------
	generate if (PWidth == SWidth) begin:REG
		Register 	#(			.Width(				PWidth),
								.Initial(			Initial),
								.AsyncReset(		AsyncReset),
								.AsyncSet(			AsyncSet),
								.ResetValue(		ResetValue),
								.SetValue(			SetValue))
					Register(	.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			Load | Enable),
								.In(				Load ? PIn : SIn),
								.Out(				POut));
	end else begin:SHIFT
		Register	 #(			.Width(				PWidth),
								.Initial(			Initial),
								.AsyncReset(		AsyncReset),
								.AsyncSet(			AsyncSet),
								.ResetValue(		ResetValue),
								.SetValue(			SetValue))
					Register(	.Clock(				Clock),
								.Reset(				Reset),
								.Set(				1'b0),
								.Enable(			Load | Enable),
								.In(				Load ? PIn : (Reverse ? {SIn, POut[PWidth-1:SWidth]} : {POut[PWidth-SWidth-1:0], SIn})),
								.Out(				POut));
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------

