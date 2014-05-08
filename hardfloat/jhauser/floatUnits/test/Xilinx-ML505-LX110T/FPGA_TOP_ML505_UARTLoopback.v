//==============================================================================
//	File:		$URL: svn+ssh://svn_gateforge@gateforge.org:26/Projects/GateLib/branches/dev/Firmware/UART/Hardware/Test/FPGA_TOP_ML505_UARTLoopback.v $
//	Version:	$Revision: 11840 $
//	Author:		Greg Gibeling (http://www.eecs.berkeley.edu/~gdgib/)
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
`include "Const.v"
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//	Module:		FPGA_TOP_ML505_UARTLoopback
//	Desc:		UART Loopback Test for the ML505
//------------------------------------------------------------------------------
module FPGA_TOP_ML505_UARTLoopback(
			//------------------------------------------------------------------
			//	Clocks
			//------------------------------------------------------------------
			CLK_33MHZ_FPGA,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Serial Ports
			//------------------------------------------------------------------
			FPGA_SERIAL_RX,
			FPGA_SERIAL_TX,
			//------------------------------------------------------------------
		); /* synthesis syn_noprune=1 */
	//--------------------------------------------------------------------------
	//	Clocks
	//--------------------------------------------------------------------------
	input					CLK_33MHZ_FPGA			/* synthesis xc_loc = "AH17" syn_pad_type = "LVCMOS_33" chip_pin = "AH17" altera_attribute="-name IO_STANDARD LVCMOS33" */;
	// synthesis attribute LOC of					CLK_33MHZ_FPGA is		"AH17"
	// synthesis attribute IOSTANDARD of			CLK_33MHZ_FPGA is		"LVCMOS33"
	// synthesis attribute PERIOD of 				CLK_33MHZ_FPGA is		"33 MHz"
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Serial Ports
	//--------------------------------------------------------------------------
	input	[2:1]			FPGA_SERIAL_RX			/* synthesis xc_loc = "G10,AG15" syn_pad_type = "LVCMOS_33" chip_pin = "G10,AG15" altera_attribute="-name IO_STANDARD LVCMOS33" */;
	// synthesis attribute LOC of					FPGA_SERIAL_RX is		"G10,AG15"
	// synthesis attribute IOSTANDARD of			FPGA_SERIAL_RX is		"LVCMOS33"
	output	[2:1]			FPGA_SERIAL_TX			/* synthesis xc_loc = "F10,AG20" syn_pad_type = "LVCMOS_33" chip_pin = "F10,AG20" altera_attribute="-name IO_STANDARD LVCMOS33" */;
	// synthesis attribute LOC of					FPGA_SERIAL_TX is		"F10,AG20"
	// synthesis attribute IOSTANDARD of			FPGA_SERIAL_TX is		"LVCMOS33"
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	parameter	ClockFreq =							33000000;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Wires
	//--------------------------------------------------------------------------
	wire					Clock, Reset;
	
	wire	[7:0]			Data[2:1];
	wire					DataValid[2:1], DataReady[2:1];
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Clock Buffers
	//--------------------------------------------------------------------------
	BUFG			ClockBuf(	.I(					CLK_33MHZ_FPGA),
								.O(					Clock));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Reset
	//--------------------------------------------------------------------------
	ResetGenerator	#(			.ClockFreq(			ClockFreq),
								.UseIn(				0),
								.InWidth(			4),
								.UsePowerOn(		1),
								.POWidth(			8),
								.PODelay(			8))
					RstGen(		.Clock(				Clock),
								.Reset(				1'b0),
								.In(				1'bx),
								.Out(				Reset));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	UARTs
	//--------------------------------------------------------------------------
	genvar					i;
	generate for (i = 1; i < 3; i = i + 1) begin:UARTS
		UART		#(			.ClockFreq(			33000000),
								.Baud(				115200),
								.Width(				8),
								.Parity(			0),
								.StopBits(			1))
					UART(		.Clock(				Clock),
								.Reset(				Reset),
								.DataIn(			Data[i]),
								.DataInValid(		DataValid[i]),
								.DataInReady(		DataReady[i]),
								.DataOut(			Data[i]),
								.DataOutValid(		DataValid[i]),
								.DataOutReady(		DataReady[i]),
								.SIn(				FPGA_SERIAL_RX[i]),
								.SOut(				FPGA_SERIAL_TX[i]));
	end endgenerate
	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
