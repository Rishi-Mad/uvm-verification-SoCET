
module tb_socetlib_edge_detector;

    logic CLK = 0, nRST;

    localparam NBITS = 4;

    always #(10) CLK++;

    logic [NBITS-1:0] tb_signal;
    logic [NBITS-1:0] mealy_pos, mealy_neg;
    logic [NBITS-1:0] moore_pos, moore_neg;
    logic [NBITS-1:0] prev1, prev2;
    int fails;

    // Mealy (MOORE=0) and Moore (MOORE=1) instances run side-by-side against
    // the same stimulus so both datapaths get coverage on every run, instead
    // of only whichever one MOORE happened to be hardcoded to.
    socetlib_edge_detector #(.WIDTH(NBITS), .MOORE(0)) DUT_MEALY(
        .CLK,
        .nRST,
        .signal(tb_signal),
        .pos_edge(mealy_pos),
        .neg_edge(mealy_neg)
    );

    socetlib_edge_detector #(.WIDTH(NBITS), .MOORE(1)) DUT_MOORE(
        .CLK,
        .nRST,
        .signal(tb_signal),
        .pos_edge(moore_pos),
        .neg_edge(moore_neg)
    );

    // Also checks replication of RESET bit
    logic [NBITS-1:0] r1_pos, r1_neg;
    socetlib_edge_detector #(.WIDTH(NBITS), .MOORE(0), .RESET(1)) DUT_RESET1(
        .CLK,
        .nRST,
        .signal(tb_signal),
        .pos_edge(r1_pos),
        .neg_edge(r1_neg)
    );

    // Resets DUT_MEALY/DUT_MOORE and resyncs prev1/prev2 to what their
    // registers settle to (prev1 = tb_signal held through reset, since it's
    // sampled by signal_r on the first post-reset posedge; prev2 = RESET,
    // which is 0 for these two instances).
    task do_reset();
    begin
        nRST = 1'b0;
        #(1);
        if(r1_neg !== (~tb_signal & {NBITS{1'b1}})) begin
            $display("Time %t [FAILED]: RESET=1 not replicated across WIDTH after reset\n\tExpected neg_edge %b, Actual %b\n", $time, ~tb_signal & {NBITS{1'b1}}, r1_neg);
            fails++;
        end

        repeat(2) @(negedge CLK);
        nRST = 1'b1;
        @(posedge CLK);
        #(1);

        prev1 = tb_signal;
        prev2 = '0;
    end
    endtask

    task automatic check(input [NBITS-1:0] step_signal);
    begin
        tb_signal = step_signal;
        #(1);

        if(mealy_pos !== (tb_signal & ~prev1)) begin
            $display("Time %t [FAILED]: Mealy posedge %b --> %b\n\tExpected %b, Actual %b\n", $time, prev1, tb_signal, tb_signal & ~prev1, mealy_pos);
            fails++;
        end
        if(mealy_neg !== (~tb_signal & prev1)) begin
            $display("Time %t [FAILED]: Mealy negedge %b --> %b\n\tExpected %b, Actual %b\n", $time, prev1, tb_signal, ~tb_signal & prev1, mealy_neg);
            fails++;
        end
        if(moore_pos !== (prev1 & ~prev2)) begin
            $display("Time %t [FAILED]: Moore posedge %b --> %b\n\tExpected %b, Actual %b\n", $time, prev2, prev1, prev1 & ~prev2, moore_pos);
            fails++;
        end
        if(moore_neg !== (~prev1 & prev2)) begin
            $display("Time %t [FAILED]: Moore negedge %b --> %b\n\tExpected %b, Actual %b\n", $time, prev2, prev1, ~prev1 & prev2, moore_neg);
            fails++;
        end

        @(posedge CLK);
        prev2 = prev1;
        prev1 = tb_signal;
        #(1);
    end
    endtask

    initial begin
        $dumpfile("waveform.fst");
        $dumpvars(0, tb_socetlib_edge_detector);
        $timeformat(-9, 2, " ns", 20);

        tb_signal = 0;
        nRST = 1'b1;
        fails = 0;
        #(1); // let nRST's X->1 settle before do_reset() drives its 1->0 edge

        do_reset();
        check(0);

        for(int i = 0; i < 100; i++) begin
            check(i[NBITS-1:0]);
        end

        tb_signal = {NBITS{1'b1}};
        do_reset();
        check({NBITS{1'b1}});

        for(int i = 0; i < 100; i++) begin
            check(i[NBITS-1:0]);
        end

        if(fails == 0) begin
            $display("All tests passed!\n");
        end

        $finish();
    end

endmodule
