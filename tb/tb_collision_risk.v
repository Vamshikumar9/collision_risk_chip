`timescale 1ns/1ps

module tb_collision_risk;

    reg clk;
    reg reset;

    reg [15:0] distance;
    reg [15:0] rel_velocity;

    wire safe;
    wire warning;
    wire critical;
    wire brake_alert;


    //====================================================
    // DUT
    //====================================================

    collision_risk_top dut (

        .clk(clk),
        .reset(reset),

        .distance(distance),
        .rel_velocity(rel_velocity),

        .safe(safe),
        .warning(warning),
        .critical(critical),
        .brake_alert(brake_alert)

    );


    //====================================================
    // CLOCK
    // 10 ns period = 100 MHz
    //====================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    //====================================================
    // VCD WAVEFORM
    //====================================================

    initial begin

        $dumpfile("collision_risk.vcd");
        $dumpvars(0, tb_collision_risk);

    end


    //====================================================
    // TEST SEQUENCE
    //====================================================

    initial begin

        // Initial conditions
        reset        = 1'b1;
        distance     = 16'd500;
        rel_velocity = 16'd0;

        #20;


        //================================================
        // TEST 1
        // SAFE
        //
        // Distance = 500
        // Velocity = 10
        //
        // TTC = 500/10 = 50
        //================================================

        reset        = 1'b0;

        distance     = 16'd500;
        rel_velocity = 16'd10;

        #30;


        //================================================
        // TEST 2
        // WARNING
        //
        // Distance = 40
        // Velocity = 10
        //
        // TTC = 4
        //
        // 2 < TTC <= 5
        //================================================

        distance     = 16'd40;
        rel_velocity = 16'd10;

        #30;


        //================================================
        // TEST 3
        // CRITICAL
        //
        // Distance = 15
        // Velocity = 10
        //
        // TTC = 1.5
        //
        // TTC <= 2
        //================================================

        distance     = 16'd15;
        rel_velocity = 16'd10;

        #30;


        //================================================
        // TEST 4
        // SAFE
        //
        // Object becomes far away
        //================================================

        distance     = 16'd500;
        rel_velocity = 16'd10;

        #30;


        //================================================
        // TEST 5
        // WARNING
        //================================================

        distance     = 16'd100;
        rel_velocity = 16'd20;

        #30;


        //================================================
        // TEST 6
        // CRITICAL
        //================================================

        distance     = 16'd30;
        rel_velocity = 16'd20;

        #30;


        //================================================
        // TEST 7
        // SAFE
        // No closing velocity
        //================================================

        distance     = 16'd30;
        rel_velocity = 16'd0;

        #30;


        $finish;

    end


    //====================================================
    // MONITOR
    //====================================================

    initial begin

        $monitor(
            "TIME=%0t | RESET=%b | DIST=%0d | VELOCITY=%0d | SAFE=%b | WARNING=%b | CRITICAL=%b | BRAKE=%b",
            $time,
            reset,
            distance,
            rel_velocity,
            safe,
            warning,
            critical,
            brake_alert
        );

    end

endmodule