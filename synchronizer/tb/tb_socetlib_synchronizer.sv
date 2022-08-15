
`ifndef TB_STAGES
    `define TB_STAGES 2
`endif

`ifdef TB_SENSE_HIGH
    `define TB_SENSE "HIGH"
`else
    `define TB_SENSE "LOW"
`endif

module tb_socetlib_synchronizer();

    logic CLK = 0, nRST, async_in, sync_out;

    always #(10) CLK++;

    logic window [$];
    logic expected;
    logic v;

    socetlib_synchronizer #(
        .STAGES(`TB_STAGES),
        .RESET_STATE(`TB_SENSE)
    ) DUT0 (
        .*
    );



    initial begin

        $display("Running synchronizer with %d stages and %s reset value", `TB_STAGES, `TB_SENSE);
        async_in = (`TB_SENSE == "LOW") ? 1'b0 : 1'b1;
        nRST = 1'b1;
        @(negedge CLK);
        nRST = 1'b0;
        repeat(2) @(posedge CLK);
        @(negedge CLK);
        nRST = 1'b1;

        // Check reset value
        if(`TB_SENSE == "LOW") begin
            assert(sync_out == 1'b0)
            else $display("Incorrect reset value for SYNC_%s synchronizer", `TB_SENSE);
        end else begin
            assert(sync_out == 1'b1)
            else $display("Incorrect reset value for SYNC_%s synchronizer", `TB_SENSE);
        end

        for(int i = 0; i < 1000; i++) begin
            if(window.size >= `TB_STAGES) begin
                expected = window.pop_back();
                assert(expected == sync_out)
                else begin
                    $display("At time %t, got %b, expected %b", $time, sync_out, expected);
                    $display("Window is: %p", window);
                end
            end

            v = $random;
            window.push_front(v);
            async_in = v;
            @(negedge CLK);
        end


        $finish();
    end

endmodule
