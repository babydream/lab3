initial begin : test
    integer i, j;
    reg [16*DQ_BITS-1:0] d0, d1;
    d0 = {
       {DQ_BITS/8{8'h0F}}, {DQ_BITS/8{8'h0E}}, {DQ_BITS/8{8'h0D}}, {DQ_BITS/8{8'h0C}},
       {DQ_BITS/8{8'h0B}}, {DQ_BITS/8{8'h0A}}, {DQ_BITS/8{8'h09}}, {DQ_BITS/8{8'h08}},
       {DQ_BITS/8{8'h07}}, {DQ_BITS/8{8'h06}}, {DQ_BITS/8{8'h05}}, {DQ_BITS/8{8'h04}},
       {DQ_BITS/8{8'h03}}, {DQ_BITS/8{8'h02}}, {DQ_BITS/8{8'h01}}, {DQ_BITS/8{8'h00}}
    };
    d1 = {
       {DQ_BITS/8{8'h1F}}, {DQ_BITS/8{8'h1E}}, {DQ_BITS/8{8'h1D}}, {DQ_BITS/8{8'h1C}},
       {DQ_BITS/8{8'h1B}}, {DQ_BITS/8{8'h1A}}, {DQ_BITS/8{8'h19}}, {DQ_BITS/8{8'h18}},
       {DQ_BITS/8{8'h17}}, {DQ_BITS/8{8'h16}}, {DQ_BITS/8{8'h15}}, {DQ_BITS/8{8'h14}},
       {DQ_BITS/8{8'h13}}, {DQ_BITS/8{8'h12}}, {DQ_BITS/8{8'h11}}, {DQ_BITS/8{8'h10}}
    };

    //init_speed = 100.0; // run initialization at 100x normal speed

    for (i=1; i<7; i=i+1) begin // RL and WL loop to 6
        for (j=2; j<5; j=j+1) begin // BL loop to 4

            $display ("%m at time %t: Power Ramp and Initialization Sequence", $time);
            power_up;

            /*
            $display ("%m at time %t: Clock Stop Entry and Exit", $time);
            force ck = 0;
            #(100000);
            release ck;
            ck <= 1'b1;
            nop             (1);
            */

            $display ("%m at time %t: Mode Register Write timing example", $time);
            mode_reg_write  (1, (twr - 2)<<5 | j); // wrap
            nop             (tmrw - 1);
            mode_reg_write  (2, i);
            nop             (tmrw - 1);

            $display ("%m at time %t: Mode Register Read timing example", $time);
            mode_reg_read   (0, (init_speed > 1.0));
            nop             (tmrr - 1);
            mode_reg_read   (5, 'hFF);
            nop             (tmrr - 1);

            $display ("%m at time %t: Partial Masked Burst write followed by precharge", $time);
            activate        (0, 0);
            nop             (trcd - 1);
            write           (0, 'h1FC, 0, {2*DM_BITS{1'b1}}<<((bl-2)*DM_BITS), d0);
            nop             (wl + 1 + bl/2 + twr - 1);
            precharge       (0, 0);
            nop             (trppb - 1);

            $display ("%m at time %t: All Masked Burst write followed by precharge", $time);
            activate        (0, 0);
            nop             (trcd - 1);
            write           (0, 0, 0, (1<<(bl*DM_BITS))-1, d1);
            nop             (wl + 1 + bl/2 + twr - 1);
            precharge       (0, 0);
            nop             (trppb - 1);

            $display ("%m at time %t: Partial Masked Burst write w/Auto Precharge", $time);
            activate        (0, 0);
            nop             (trcd - 1);
            write           (0, 0, 1, {2*DM_BITS{1'b1}}, d0);
            nop             (wl + 1 + bl/2 + twr + trppb - 1);

            $display ("%m at time %t: Burst write followed by burst read", $time);
            activate        (0, 0);
            nop             (trcd - 1);
            write           (0, 0, 0, 0, d0);
            nop             (wl + 1 + bl/2 + twtr - 1);
            read_verify     (0, 0, 0, 0, d0);
            nop             ((bl-SX)/2 + trtp - 1);
            precharge       (0, 0);
            nop             (trppb - 1);

            $display ("%m at time %t: Seamless burst write", $time);
            activate        (0, 0);
            nop             (trrd - 1);
            activate        (1, 0);
            nop             (trcd - 1);
            write           (0, 0, 0, 0, d0);
            nop             (bl/2 - 1);
            write           (1, 0, 0, 0, d1);
            nop             (wl + 1 + bl/2 + twr - 1);
            precharge       (0, 1);
            nop             (trpab - 1);

            $display ("%m at time %t: Burst writes", $time);
            activate        (0, 0);
            nop             (trrd - 1);
            activate        (1, 0);
            nop             (trcd - 1);
            write           (0, 0, 0, 0, d0);
            nop             (bl/2);
            write           (1, 0, 0, 0, d1);
            nop             (bl/2 + 1);
            write           (0, 0, 0, 0, d0);
            nop             (wl + 1 + bl/2 + twr - 1);
            precharge       (0, 1);
            nop             (trpab - 1);

            $display ("%m at time %t: Write burst interrupt timing", $time);
            activate        (0, 0);
            nop             (trrd - 1);
            activate        (1, 0);
            nop             (trcd - 1);
            write           (0, 0, 0, 0, d0);
            nop             (tccd - 1);
            write           (1, 0, 0, 0, d1);
            nop             (wl + 1 + twr - 1);
            precharge       (0, 0);
            nop             (max(0, bl/2 - tccd + twr - 2));
            precharge       (1, 0);
            nop             (trppb - 1);

            $display ("%m at time %t: Write burst truncated by BST", $time);
            activate        (0, 0);
            nop             (trrd - 1);
            activate        (1, 0);
            nop             (trcd - 1);
            write           (0, 0, 0, 0, d0);
            nop             (tccd - 1);
            if (tccd < bl/2) begin
                burst_term;
            end
            write           (1, 0, 0, 0, d1);
            nop             (wl + 1 + bl/2 + twr - 1);
            precharge       (0, 1);
            nop             (trpab - 1);

            $display ("%m at time %t: Burst read followed by Precharge", $time);
            activate        (0, 0);
            nop             (max(trcd, tras - ((bl-SX)/2 + trtp)) - 1);
            read_verify     (0, 0, 0, 0, d0);
            nop             ((bl-SX)/2 + trtp - 1);
            precharge       (0, 0);
            nop             (trppb - 1);

            $display ("%m at time %t: Burst read with Auto-Precharge", $time);
            activate        (0, 0);
            nop             (trcd - 1);
            read_verify     (0, 0, 1, 0, d0);
            nop             (max(tras, trcd + (bl-SX)/2 + trtp) + trppb - 1);

            $display ("%m at time %t: Burst read followed by burst write", $time);
            activate        (0, 0);
            nop             (trcd - 1);
            read_verify     (0, 0, 0, 0, d0);
            nop             (rl + tdqsck + bl/2 + 1 - wl - 1);
            write           (0, 0, 0, 0, d0);
            nop             (wl + 1 + bl/2 + twr - 1);
            precharge       (0, 0);
            nop             (trppb - 1);

            $display ("%m at time %t: Seamless burst read", $time);
            activate        (0, 0);
            nop             (trrd - 1);
            activate        (1, 0);
            nop             (max(trcd, tras - ((bl-SX)/2 + trtp)) - 1);
            read_verify     (0, 0, 0, 0, d0);
            nop             (bl/2 - 1);
            read_verify     (1, 0, 0, 0, d1);
            nop             ((bl-SX)/2 + trtp - 1);
            precharge       (0, 1);
            nop             (trpab - 1);


            $display ("%m at time %t: Burst reads", $time);
            activate        (0, 0);
            nop             (trrd - 1);
            activate        (1, 0);
            nop             (trcd - 1);
            read_verify     (0, 0, 0, 0, d0);
            nop             (bl/2);
            read_verify     (1, 0, 0, 0, d1);
            nop             (bl/2 + 1);
            read_verify     (0, 0, 0, 0, d0);
            nop             ((bl-SX)/2 + trtp - 1);
            precharge       (0, 1);
            nop             (trpab - 1);

            $display ("%m at time %t: Read burst interrupt example", $time);
            activate        (0, 0);
            nop             (trrd - 1);
            activate        (1, 0);
            nop             (max(trcd, tras - (tccd - 2 + trtp)) - 1);
            read_verify     (0, 0, 0, 0, d0);
            nop             (tccd - 1);
            read_verify     (1, 0, 0, 0, d1);
            nop             (max(0, (bl-SX)/2 + trtp - tccd - 1));
            precharge       (0, 0);
            nop             (max(0, (bl-SX)/2 + trtp - 2));
            precharge       (1, 0);
            nop             (trppb - 1);

            $display ("%m at time %t: Read burst truncated by BST", $time);
            activate        (0, 0);
            nop             (trrd - 1);
            activate        (1, 0);
            nop             (max(trcd, tras - ((bl-SX)/2 + trtp)) - 1);
            read_verify     (0, 0, 0, 0, d0);
            nop             (tccd - 1);
            if (tccd < bl/2) begin
                burst_term;
            end
            read_verify     (1, 0, 0, 0, d1);
            nop             ((bl-SX)/2 + trtp - 1);
            precharge       (0, 1);
            nop             (trpab - 1);

            $display ("%m at time %t: All Bank Refresh Operation", $time);
            refresh         (1);
            nop             (trfcab - 1);

            // Per Bank Refresh is only allowed in devices with 8 banks
            if (BA_BITS > 2) begin
                $display ("%m at time %t: Per Bank Refresh Operation", $time);
                refresh     (0);
                nop         (trfcpb - 1);
                refresh     (0);
                nop         (trfcpb - 1);
            end

            $display ("%m at time %t: Self-Refresh Operation", $time);
            self_refresh    (tckesr);
            nop             (txsr);

            $display ("%m at time %t: Read to MRR timing example", $time);
            activate        (0, 0);
            nop             (max(trcd, tras - ((bl-SX)/2 + trtp)) - 1);
            read_verify     (0, 0, 0, 0, d0);
            nop             (bl/2 - 1);
            mode_reg_read   (0, 0);
            nop             (max(tmrr, trtp - 2) - 1);
            precharge       (0, 0);
            nop             (trppb - 1);

            $display ("%m at time %t: Burst Write Followed by MRR", $time);
            activate        (0, 0);
            nop             (trcd - 1);
            write           (0, 0, 0, 0, d0);
            nop             (wl + 1 + bl/2 + twtr - 1);
            mode_reg_read   (0, 0);
            nop             (max(tmrr, twr - twtr) - 1);
            precharge       (0, 0);
            //nop             (trppb - 1);
            nop             (rl + tdqsck + 2);

            $display ("%m at time %t: Basic power down entry and exit timing diagram", $time);
            power_down      (tcke);
            nop             (txp);

            $display ("%m at time %t: Read to power-down entry", $time);
            activate        (0, 0);
            nop             (trcd - 1);
            read_verify     (0, 0, 0, 0, d0);
            nop             (rl + tdqsck + bl/2);
            power_down      (tcke);
            nop             (txp);
            precharge       (0, 0);
            nop             (trppb - 1);

            $display ("%m at time %t: Read with autoprecharge to power-down entry", $time);
            activate        (0, 0);
            nop             (trcd - 1);
            read_verify     (0, 0, 1, 0, d0);
            nop             (rl + tdqsck + bl/2);
            power_down      (max(tcke, trppb));
            nop             (txp);

            $display ("%m at time %t: Write to power-down entry", $time);
            activate        (0, 0);
            nop             (trcd - 1);
            write           (0, 0, 0, 0, d0);
            nop             (wl + 1 + bl/2 + twr - 1);
            power_down      (tcke);
            nop             (txp);
            precharge       (0, 0);
            nop             (trppb - 1);

            $display ("%m at time %t: Write with autoprecharge to power-down entry", $time);
            activate        (0, 0);
            nop             (trcd - 1);
            write           (0, 0, 1, 0, d0);
            nop             (wl + 1 + bl/2 + twr - 1);
            power_down      (max(tcke, trppb));
            nop             (txp);

            $display ("%m at time %t: Refresh command to power-down entry", $time);
            refresh         (1);
            power_down      (max(tcke, trfcab));
            nop             (txp);

            $display ("%m at time %t: Activate command to power-down entry", $time);
            activate        (0, 0);
            power_down      (max(tcke, tras));
            nop             (txp);

            $display ("%m at time %t: Precharge/Precharge-all command to power-down entry", $time);
            precharge       (0, 0);
            power_down      (max(tcke, trppb));
            nop             (txp);

            $display ("%m at time %t: Mode Register Read to power-down entry", $time);
            mode_reg_read   (0, 0);
            nop             (rl + tdqsck + 2);
            power_down      (tcke);
            nop             (txp);

            $display ("%m at time %t: MRW command to power-down entry", $time);
            mode_reg_write  (2, i);
            nop             (tmrw - 1);
            power_down      (tcke);
            nop             (max(tcke, txp));

            $display ("%m at time %t: Deep power down entry and exit timing diagram", $time);
            deep_power_down (tcke);
        end
    end

    test_done;
end
