`timescale 1ns/1ps

module collision_risk_core (
    input  wire [15:0] distance,
    input  wire [15:0] rel_velocity,

    output reg         safe_condition,
    output reg         warning_condition,
    output reg         critical_condition
);

    reg [31:0] critical_limit;
    reg [31:0] warning_limit;

    always @(*) begin

        safe_condition     = 1'b0;
        warning_condition  = 1'b0;
        critical_condition = 1'b0;

        // Approximate TTC thresholds:
        //
        // Critical: TTC <= 2 time units
        // Warning : TTC <= 5 time units
        //
        // Instead of division:
        //
        // distance / velocity <= 2
        // distance / velocity <= 5
        //
        // becomes:
        //
        // distance <= velocity * 2
        // distance <= velocity * 5

        critical_limit = {16'd0, rel_velocity} * 32'd2;
        warning_limit  = {16'd0, rel_velocity} * 32'd5;

        // No relative velocity means no closing motion.
        if (rel_velocity == 16'd0) begin

            safe_condition     = 1'b1;
            warning_condition  = 1'b0;
            critical_condition = 1'b0;

        end

        // Very small approximate TTC
        else if ({16'd0, distance} <= critical_limit) begin

            safe_condition     = 1'b0;
            warning_condition  = 1'b0;
            critical_condition = 1'b1;

        end

        // Small approximate TTC
        else if ({16'd0, distance} <= warning_limit) begin

            safe_condition     = 1'b0;
            warning_condition  = 1'b1;
            critical_condition = 1'b0;

        end

        // Large TTC
        else begin

            safe_condition     = 1'b1;
            warning_condition  = 1'b0;
            critical_condition = 1'b0;

        end

    end

endmodule