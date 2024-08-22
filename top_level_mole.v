module top_level (
    input         CLOCK_50,              // DE2-115's 50MHz clock signal
    input  [3:0]  KEY,                   // The 4 push buttons on the board
    output [17:0] LEDR,                  // 18 red LEDs
    output [6:0]  HEX0, HEX1, HEX2, HEX3 // Four 7-segment displays
);

    // Intermediate wires: (DO NOT EDIT WIRE NAMES!)
    wire        timer_reset, timer_up, timer_enable, button_pressed;
    wire [10:0] timer_value, random_value;

    // First module instantiated for you as an example:
    timer           u_timer         (// Inputs:
                                    .clk(CLOCK_50),
                                    .reset(timer_reset),
                                    .up(timer_up),
                                    .enable(timer_enable),
                                    .start_value(random_value),
                                    // Outputs:
                                    .timer_value(timer_value));

    debounce u_debounce (
    .clk(CLOCK_50),
    .button(KEY[0]),  // Connect to KEY[0]
    .button_pressed(button_pressed));

    display u_display (
    .clk(CLOCK_50),
    .value(timer_value),
    .display0(HEX0), // Connect to HEX0
    .display1(HEX1), // Connect to HEX1
    .display2(HEX2), // etc.
    .display3(HEX3)
    );

    reaction_time_fsm u1 (
        .clk(CLOCK_50),
        .button_pressed(button_pressed),
        .timer_value(timer_value),
        .reset(timer_reset),
        .up(timer_up),
        .enable(timer_enable),
        .led_on(LEDR[0])  // Connect to LEDR[0]
    );

     rng u2 (
        .clk(CLOCK_50),
        .random_value(random_value)
    );


endmodule
