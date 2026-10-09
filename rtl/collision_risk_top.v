`timescale 1ns/1ps

module collision_risk_top (

    input wire clk,
    input wire reset,

    input wire [15:0] distance,
    input wire [15:0] rel_velocity,

    output wire safe,
    output wire warning,
    output wire critical,
    output wire brake_alert

);

    wire safe_condition;
    wire warning_condition;
    wire critical_condition;


    //====================================================
    // COLLISION RISK CALCULATOR
    //====================================================

    collision_risk_core u_collision_risk_core (

        .distance(distance),
        .rel_velocity(rel_velocity),

        .safe_condition(safe_condition),
        .warning_condition(warning_condition),
        .critical_condition(critical_condition)

    );


    //====================================================
    // SEQUENTIAL RISK FSM
    //====================================================

    risk_fsm u_risk_fsm (

        .clk(clk),
        .reset(reset),

        .safe_condition(safe_condition),
        .warning_condition(warning_condition),
        .critical_condition(critical_condition),

        .safe(safe),
        .warning(warning),
        .critical(critical),
        .brake_alert(brake_alert)

    );

endmodule