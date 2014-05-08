/****************************************************************************************
*
*    File Name:  tb.v
*
* Dependencies:  mobile_ddr2.v, mobile_ddr_parameters2.vh, subtest.vh
*
*  Description:  Micron MOBILE SDRAM DDR2 (Double Data Rate 2) test bench
*
*         Note: -Set simulator resolution to "ps" accuracy
*               -Set mcd_info = 0 to disable $display messages
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

`timescale 1ps / 1ps

module tb;

`include "mobile_ddr2_parameters.vh"

    // ports
    reg                         ck;
    wire                        ck_n = ~ck;
    reg                         cke;
    reg                         cs_n;
    reg           [CA_BITS-1:0] ca;
    reg           [DM_BITS-1:0] dm;
    wire          [DQ_BITS-1:0] dq;
    wire         [DQS_BITS-1:0] dqs;
    wire         [DQS_BITS-1:0] dqs_n;

    // mode registers
    reg                   [7:0] mr1;
    reg                   [7:0] mr2;
    wire                  [4:0] bl  = 1<<(mr1 & 7);
    wire                  [3:0] rl = (mr2 & 7) + 2;
    wire                  [2:0] wl = (rl>>1) + (&rl[2:0]);

    // dq transmit
    reg                         dq_en;
    reg           [DQ_BITS-1:0] dq_out;
    reg                         dqs_en;
    reg          [DQS_BITS-1:0] dqs_out;
    assign                      dq       = dq_en ? dq_out : {DQ_BITS{1'bz}};
    assign                      dqs      = dqs_en ? dqs_out : {DQS_BITS{1'bz}};
    assign                      dqs_n    = dqs_en ? ~dqs_out : {DQS_BITS{1'bz}};

    // dq receive
    reg           [DM_BITS-1:0] dm_fifo [2*CL_MAX+24:0];
    reg           [DQ_BITS-1:0] dq_fifo [2*CL_MAX+24:0];
    wire          [DQ_BITS-1:0] q0, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15;
    reg                         ptr_rst_n;
    reg                   [3:0] burst_cntr;

    // timing definition in tCK units
    real                        tck;
    wire                 [11:0] tdqsck   = ceil(TDQSCK_MAX/tck);
    wire                 [11:0] tcke     = CKE;
    wire                 [11:0] tckesr   = ceil(TCKESR/tck);
    wire                 [11:0] tmrr     = MRR;
    wire                 [11:0] tmrw     = MRW;
    wire                 [11:0] tccd     = CCD;
    wire                 [11:0] tfaw     = max(ceil(TFAW/tck), FAW);
    wire                 [11:0] tras     = max(ceil(TRAS/tck), RAS);
    wire                 [11:0] trcd     = max(ceil(TRCD/tck), RCD);
    wire                 [11:0] trpab    = max(ceil(TRPAB/tck), RPAB);
    wire                 [11:0] trppb    = max(ceil(TRPPB/tck), RPPB);
    wire                 [11:0] trrd     = max(ceil(TRRD/tck), RRD);
    wire                 [11:0] trtp     = max(ceil(TRTP/tck), RTP);
    wire                 [11:0] twr      = max(ceil(TWR/tck), WR);
    wire                 [11:0] twtr     = max(ceil(TWTR/tck), WTR);
    wire                 [11:0] txp      = max(ceil(TXP/tck), XP);
    wire                 [11:0] txsr     = ceil(TXSR/tck);
    wire                 [11:0] trfcpb   = ceil(TRFCPB/tck);
    wire                 [11:0] trfcab   = ceil(TRFCAB/tck);

    real                        init_speed;


    initial begin
        $timeformat (-9, 1, " ns", 1);
`ifdef period
        tck <= `period; 
`else
        tck <= TCK_MIN;
`endif
        ck <= 1'b1;
        dm <= {DM_BITS{1'b0}};
        dqs_en <= 1'b0;
        dq_en <= 1'b0;
        init_speed = 1.0;
    end

    // component instantiation
    mobile_ddr2 sdrammobile_ddr2 (
        ck,
        ck_n,
        cke,
        cs_n,
        ca,
        dm,
        dq,
        dqs,
        dqs_n
    );

    // clock generator
    always @(posedge ck) begin
      ck <= #(tck/2) 1'b0;
      ck <= #(tck) 1'b1;
    end

    function integer ceil;
        input number;
        real number;
        if (number > $rtoi(number))
            ceil = $rtoi(number) + 1;
        else
            ceil = number;
    endfunction

    function integer max;
        input arg1;
        input arg2;
        integer arg1;
        integer arg2;
        if (arg1 > arg2)
            max = arg1;
        else
            max = arg2;
    endfunction

    task power_up;
        real previous_tck;
        begin
            if (init_speed > 1.0) begin
                $display ("%m at time %t: INFO: The initialization sequence will run at %0.2fx.  tINIT errors are expected.", $time, init_speed);
            end
            power_down (2);                                                             // provide 2 clocks with CKE low
            previous_tck <= tck;
            tck = 100000;                                                               // change clock period to 100 ns
            @(posedge ck);
            @(negedge ck);
            power_down (max(ceil(TINIT1/init_speed/tck), ceil(INIT2/init_speed)));      // satisfy tINIT1 and INIT2
            deselect (ceil(TINIT3/init_speed/tck));                                     // satisfy tINIT3
            precharge (0,1); // PREab allowed 
            deselect (10);
            mode_reg_write(8'h3F, 8'h0);                                                // issue reset command
            deselect (max(ceil(TINIT4/init_speed/tck), ceil(TINIT5/init_speed/tck)));   // satisfy tINIT4 and tINIT5
            mode_reg_write(8'h0a, 8'hFF);                                               // issue ZQ Calibration command
            deselect (ceil(TZQINIT/init_speed/tck));                                    // satisfy tZQINIT
            power_down (2);                                                             // provide 2 clocks with CKE low
            tck = previous_tck;                                                         // restore original clock period;
            @(posedge ck);
            @(negedge ck);
            power_down (ceil(INIT2/init_speed));
            deselect (txp);

        end
    endtask

    task mode_reg_write;
        input                 [7:0] ma;
        input                 [7:0] op;
        begin
            cke   <= 1'b1;
            cs_n  <= 1'b0;
            ca    <= #(tck/4) {ma[5:0], 4'h0};
            ca    <= #(3*tck/4) {op, ma[7:6]};
            case (ma)
                1: mr1 <= op;
                2: mr2 <= op;
            endcase
            @(negedge ck);
        end
    endtask

    task mode_reg_read;
        input                 [7:0] ma;
        input                 [7:0] op;
        integer i;
        begin
            cke   <= 1'b1;
            cs_n  <= 1'b0;
            ca    <= #(tck/4) {ma[5:0], 4'h8};
            ca    <= #(3*tck/4) ma[7:6];
            @(negedge ck);
            dm_fifo[2*(rl + 3)] <= -2;
            dq_fifo[2*(rl + 3)] <= op;
            for (i=1; i<4; i=i+1) begin
                dm_fifo[2*(rl + 3) + i] <= {DM_BITS{1'b1}};
            end
        end
    endtask

    task refresh;
        input                       ab;
        begin
            cke   <= 1'b1;
            cs_n  <= 1'b0;
            ca    <= #(tck/4) {ab, 3'h4};
            @(negedge ck);
        end
    endtask
     
    task precharge;
        input         [BA_BITS-1:0] ba;
        input                       ab;
        begin
            cke   <= 1'b1;
            cs_n  <= 1'b0;
            ca    <= #(tck/4) {ba, 2'h0, ab, 4'hB};
            @(negedge ck);
        end
    endtask
     
    task activate;
        input         [BA_BITS-1:0] ba;
        input                [14:0] r;
        begin
            cke   <= 1'b1;
            cs_n  <= 1'b0;
            ca    <= #(tck/4) {ba, r[12:8], 2'h2};
            ca    <= #(3*tck/4) {r[14:13], r[7:0]};
            @(negedge ck);
        end
    endtask

    //write task supports burst lengths <= 16
    task write;
        input         [BA_BITS-1:0] ba;
        input                [11:0] c;
        input                       ap;
        input      [16*DM_BITS-1:0] wdm;
        input      [16*DQ_BITS-1:0] wdq;
        integer i;
        integer dly;
        begin
            cke   <= 1'b1;
            cs_n  <= 1'b0;
            ca    <= #(tck/4) {ba, c[2:1], 2'h0, 3'h1};
            ca    <= #(3*tck/4) {c[11:3], ap};

            for (i=0; i<=bl; i=i+1) begin
                dly = (wl + 1)*tck + i*tck/2;
                dqs_en <= #(dly) 1'b1;
                if (i%2 == 0) begin
                    dqs_out <= #(dly) {DQS_BITS{1'b0}};
                end else begin
                    dqs_out <= #(dly) {DQS_BITS{1'b1}};
                end

                dq_en  <= #(dly + tck/4) 1'b1;
                dm     <= #(dly + tck/4) wdm>>i*DM_BITS;
                dq_out <= #(dly + tck/4) wdq>>i*DQ_BITS;
            end
            dly = (wl + 1)*tck + bl*tck/2;
            dqs_en <= #(dly + tck/2) 1'b0;
            dq_en  <= #(dly + tck/4) 1'b0;
            @(negedge ck);  
        end
    endtask

    // read without data verification
    task read;
        input         [BA_BITS-1:0] ba;
        input                [11:0] c;
        input                       ap;
        begin
            cke   <= 1'b1;
            cs_n  <= 1'b0;
            ca    <= #(tck/4) {ba, c[2:1], 2'h0, 3'h5};
            ca    <= #(3*tck/4) {c[11:3], ap};
            @(negedge ck);
        end
    endtask

    task burst_term;
        integer i;
        begin
            cke   <= 1'b1;
            ca    <= #(tck/4) 4'h3;
            @(negedge ck);
            for (i=0; i<bl; i=i+1) begin
                dm_fifo[2*(rl + 3) + i] <= {DM_BITS{1'bx}};
                dq_fifo[2*(rl + 3) + i] <= {DQ_BITS{1'bx}};
            end
        end
    endtask

    task nop;
        input [31:0] count;
        begin
            cke   <= 1'b1;
            cs_n  <= 1'b0;
            ca    <= #(tck/4) 3'h7;
            repeat(count) @(negedge ck);
        end
    endtask

    task deselect;
        input [31:0] count;
        begin
            cke   <= 1'b1;
            cs_n  <= 1'b1;
            ca    <= #(tck/4) 3'h7;
            repeat(count) @(negedge ck);
        end
    endtask

    task power_down;
        input [31:0] count;
        begin
            cke   <= 1'b0;
            cs_n  <= 1'b1;
            repeat(count) @(negedge ck);
        end
    endtask

    task self_refresh;
        input [31:0] count;
        begin
            cke   <= 1'b0;
            cs_n  <= 1'b0;
            ca    <= #(tck/4) 3'h4;
            cs_n  <= #(tck) 1'b1;
            repeat(count) @(negedge ck);
        end
    endtask

    task deep_power_down;
        input [31:0] count;
        begin
            cke   <= 1'b0;
            cs_n  <= 1'b0;
            ca    <= #(tck/4) 3'h3;
            cs_n  <= #(tck) 1'b1;
            repeat(count) @(negedge ck);
        end
    endtask

    // read with data verification
    task read_verify;
        input         [BA_BITS-1:0] ba;
        input                [11:0] c;
        input                       ap;
        input      [16*DM_BITS-1:0] rdm;
        input      [16*DQ_BITS-1:0] rdq;
        integer i;
        begin
            read (ba, c, ap);
            for (i=0; i<bl; i=i+1) begin
                dm_fifo[2*(rl + 3) + i] <= rdm >> (i*DM_BITS);
                dq_fifo[2*(rl + 3) + i] <= rdq >> (i*DQ_BITS);
            end
        end
    endtask

    // receiver(s) for data_verify process
    dqrx dqrx[DQS_BITS-1:0] (ptr_rst_n, dqs, dq, q0, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15);

    // perform data verification as a result of read_verify task call
    always @(ck) begin:data_verify
        integer i;
        integer j;
        reg [DQ_BITS-1:0] bit_mask;
        reg [DM_BITS-1:0] dm_temp;
        reg [DQ_BITS-1:0] dq_temp;
        
        for (i = !ck; (i < 2/(2.0 - !ck)); i=i+1) begin
            if ((dm_fifo[i] === {DM_BITS{1'bx}}) && (dm_fifo[i+2] === {DM_BITS{1'bx}})) begin
                burst_cntr = 0;
            end else if (dm_fifo[i] === {DM_BITS{1'bx}}) begin
                // do nothing
            end else begin

                dm_temp = dm_fifo[i];
                for (j=0; j<DQ_BITS; j=j+1) begin
                    bit_mask[j] = !dm_temp[j/(DQ_BITS/DM_BITS)];
                end

                case (burst_cntr)
                    0: dq_temp =  q0;
                    1: dq_temp =  q1;
                    2: dq_temp =  q2;
                    3: dq_temp =  q3;
                    4: dq_temp =  q4;
                    5: dq_temp =  q5;
                    6: dq_temp =  q6;
                    7: dq_temp =  q7;
                    8: dq_temp =  q8;
                    9: dq_temp =  q9;
                   10: dq_temp =  q10;
                   11: dq_temp =  q11;
                   12: dq_temp =  q12;
                   13: dq_temp =  q13;
                   14: dq_temp =  q14;
                   15: dq_temp =  q15;
                endcase
                //if ( ((dq_temp & bit_mask) === (dq_fifo[i] & bit_mask)))
                //    $display ("%m at time %t: INFO: Successful read data compare.  Expected = %h, Actual = %h, Mask = %h, i = %d", $time, dq_fifo[i], dq_temp, bit_mask, burst_cntr);
                if ((dq_temp & bit_mask) !== (dq_fifo[i] & bit_mask)) begin
                    $display ("%m at time %t: ERROR: Read data miscompare.  Expected = %h, Actual = %h, Mask = %h, i = %d", $time, dq_fifo[i], dq_temp, bit_mask, burst_cntr);
                    if (STOP_ON_ERROR) begin
                        $stop;
                    end
                end

                burst_cntr = burst_cntr + 1;
            end
        end

        if (ck) begin
            ptr_rst_n <= (dm_fifo[8] !== {DM_BITS{1'bx}}) || ((dm_fifo[6] !== {DM_BITS{1'bx}}) && (dm_fifo[10] !== {DM_BITS{1'bx}}));
        end else begin
            for (i=0; i<=2*CL_MAX+22; i=i+1) begin
                dm_fifo[i] = dm_fifo[i+2];
                dq_fifo[i] = dq_fifo[i+2];
            end
            dm_fifo[2*CL_MAX+24] = {DM_BITS{1'bx}};
            dq_fifo[2*CL_MAX+24] = {DQ_BITS{1'bx}};
        end
    end

    // End-of-test triggered in 'subtest.vh'
    task test_done;
        begin
            $display ("%m at time %t: INFO: Simulation is Complete", $time);
            $stop(0);
        end
    endtask

    // Test included from external file
    `include "subtest.vh"

endmodule

module dqrx (
    ptr_rst_n, dqs, dq, q0, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15
);

    `include "mobile_ddr2_parameters.vh"

    input  ptr_rst_n;
    input  dqs;
    input  [DQ_BITS/DQS_BITS-1:0] dq;
    output [DQ_BITS/DQS_BITS-1:0] q0;
    output [DQ_BITS/DQS_BITS-1:0] q1;
    output [DQ_BITS/DQS_BITS-1:0] q2;
    output [DQ_BITS/DQS_BITS-1:0] q3;
    output [DQ_BITS/DQS_BITS-1:0] q4;
    output [DQ_BITS/DQS_BITS-1:0] q5;
    output [DQ_BITS/DQS_BITS-1:0] q6;
    output [DQ_BITS/DQS_BITS-1:0] q7;
    output [DQ_BITS/DQS_BITS-1:0] q8;
    output [DQ_BITS/DQS_BITS-1:0] q9;
    output [DQ_BITS/DQS_BITS-1:0] q10;
    output [DQ_BITS/DQS_BITS-1:0] q11;
    output [DQ_BITS/DQS_BITS-1:0] q12;
    output [DQ_BITS/DQS_BITS-1:0] q13;
    output [DQ_BITS/DQS_BITS-1:0] q14;
    output [DQ_BITS/DQS_BITS-1:0] q15;

    reg ptr_rst_dly_n;
    always @(posedge ptr_rst_n) ptr_rst_dly_n <= #(TDQSCK + TDQSQ) ptr_rst_n;
    always @(negedge ptr_rst_n) ptr_rst_dly_n <= #(TDQSCK_MAX + TDQSQ + 2) ptr_rst_n;

    reg dqs_dly;
    always @(dqs) dqs_dly <= #(TDQSQ + 1) dqs;

    reg [3:0] ptr;
    reg [DQ_BITS/DQS_BITS-1:0] q [15:0];

    always @(negedge ptr_rst_dly_n or posedge dqs_dly or negedge dqs_dly) begin
        if (!ptr_rst_dly_n) begin
            ptr <= 0;
        end else if (dqs_dly || ptr) begin
            q[ptr] <= dq;
            ptr <= ptr + 1;
        end
    end

    assign q0  = q[0];
    assign q1  = q[1];
    assign q2  = q[2];
    assign q3  = q[3];
    assign q4  = q[4];
    assign q5  = q[5];
    assign q6  = q[6];
    assign q7  = q[7];
    assign q8  = q[8];
    assign q9  = q[9];
    assign q10 = q[10];
    assign q11 = q[11];
    assign q12 = q[12];
    assign q13 = q[13];
    assign q14 = q[14];
    assign q15 = q[15];

    //assign ptr_rst_dly_n = ptr_rst_n;
    //specify
    //    specparam PATHPULSE$ = 0; // pulse reject and error limit
    //    (ptr_rst_n => ptr_rst_dly_n) = (TDQSCK + TDQSQ, TDQSCK_MAX + TDQSQ + 2);
    //endspecify
endmodule
