`timescale 1ns/1ps

module risk_fsm (

    input wire clk,
    input wire reset,

    input wire safe_condition,
    input wire warning_condition,
    input wire critical_condition,

    output reg safe,
    output reg warning,
    output reg critical,
    output reg brake_alert

);

    // FSM states
    localparam STATE_SAFE     = 2'b00;
    localparam STATE_WARNING  = 2'b01;
    localparam STATE_CRITICAL = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;


    //====================================================
    // STATE REGISTER
    //====================================================

    always @(posedge clk or posedge reset) begin

        if (reset)
            state <= STATE_SAFE;

        else
            state <= next_state;

    end


    //====================================================
    // NEXT STATE LOGIC
    //====================================================

    always @(*) begin

        next_state = state;

        case (state)

            //............................................
            // SAFE
            //............................................

            STATE_SAFE: begin

                if (critical_condition)
                    next_state = STATE_CRITICAL;

                else if (warning_condition)
                    next_state = STATE_WARNING;

                else
                    next_state = STATE_SAFE;

            end


            //............................................
            // WARNING
            //............................................

            STATE_WARNING: begin

                if (critical_condition)
                    next_state = STATE_CRITICAL;

                else if (safe_condition)
                    next_state = STATE_SAFE;

                else
                    next_state = STATE_WARNING;

            end


            //............................................
            // CRITICAL
            //............................................

            STATE_CRITICAL: begin

                if (safe_condition)
                    next_state = STATE_SAFE;

                else if (warning_condition)
                    next_state = STATE_WARNING;

                else
                    next_state = STATE_CRITICAL;

            end


            //............................................
            // DEFAULT
            //............................................

            default: begin

                next_state = STATE_SAFE;

            end

        endcase

    end


    //====================================================
    // REGISTERED OUTPUTS
    //====================================================

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            safe        <= 1'b1;
            warning     <= 1'b0;
            critical    <= 1'b0;
            brake_alert <= 1'b0;

        end

        else begin

            case (next_state)

                STATE_SAFE: begin

                    safe        <= 1'b1;
                    warning     <= 1'b0;
                    critical    <= 1'b0;
                    brake_alert <= 1'b0;

                end


                STATE_WARNING: begin

                    safe        <= 1'b0;
                    warning     <= 1'b1;
                    critical    <= 1'b0;
                    brake_alert <= 1'b0;

                end


                STATE_CRITICAL: begin

                    safe        <= 1'b0;
                    warning     <= 1'b0;
                    critical    <= 1'b1;
                    brake_alert <= 1'b1;

                end


                default: begin

                    safe        <= 1'b1;
                    warning     <= 1'b0;
                    critical    <= 1'b0;
                    brake_alert <= 1'b0;

                end

            endcase

        end

    end

endmodule