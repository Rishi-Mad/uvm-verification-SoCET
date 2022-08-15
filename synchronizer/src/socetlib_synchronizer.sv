
module socetlib_synchronizer#(
    parameter RESET_STATE = "HIGH",
    parameter STAGES = 2
)(
    input CLK,
    input nRST,
    input async_in,
    output logic sync_out
);

    /*
    generate
        if(STAGES < 2) begin
            $fatal("socetlib_synchronizer: STAGES must be at least 2!");
        end else if(STAGES > 3) begin
            $fatal("socetlib_synchronizer: Are you SURE you wanted more than 3 stages of synchronizer??? (If so, come edit this module to confirm)");
        end

        if(RESET_STATE != "HIGH" && RESET_STATE != "LOW") begin
            $fatal("socetlib_synchronizer: RESET_STATE must be either 'HIGH' or 'LOW'");
        end
    endgenerate
    */

    logic [STAGES-1:0] stages;
    logic [STAGES-1:0] reset_val;


    generate 
        if(RESET_STATE == "HIGH") begin
            assign reset_val = '1;
        end else if(RESET_STATE == "LOW") begin
            assign reset_val = '0;
        end
    endgenerate 

    always_ff @(posedge CLK, negedge nRST) begin
        if(!nRST) begin
            stages <= reset_val;
        end else begin
            stages <= {async_in, stages[STAGES-1:1]};
        end
    end

    assign sync_out = stages[0];

endmodule
