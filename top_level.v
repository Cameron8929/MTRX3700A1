module top_level (
    input         CLOCK_50,              // DE2-115's 50MHz clock signal
    input  [3:0]  KEY,                   // The 4 push buttons on the board
	 input  [17:0] SW, 
    output [17:0] LEDR,                  // 18 red LEDs
    output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 // Four 7-segment displays
	 
);

    // Intermediate wires: (DO NOT EDIT WIRE NAMES!)
	 wire [3:0] user_score;
    wire        timer_reset, timer_up, timer_enable, button_pressed;
	 wire 		 game_reset, game_timer_enable;
    wire [10:0] timer_value, random_value, game_timer_value;

    // First module instantiated for you as an example:
    timer           u_mole_on_timer         (// Inputs:
                                    .clk(CLOCK_50),
                                    .reset(timer_reset),
                                    .up(timer_up),
                                    .enable(timer_enable),
                                    .timer_value(timer_value));
	
	 // Timer for countdown while game is taking place											
    timer   #(.MAX_MS(10), .CLKS_PER_MS(50000000))    u_countdown_timer         (// Inputs:
                                    .clk(CLOCK_50),
                                    .reset(game_reset),
                                    .up(0),
                                    .enable(game_timer_enable),
                                    .timer_value(game_timer_value));

    debounce u_debounce (
    .clk(CLOCK_50),
    .button(KEY[0]),  // Connect to KEY[0]
    .button_pressed(button_pressed));

    display u_display (
    .clk(CLOCK_50),
    .value(user_score),
    .display0(HEX0), // Connect to HEX0
    .display1(HEX1), // Connect to HEX1
    .display2(HEX2), // etc.
    .display3(HEX3)
    );
	 
	 display u_display1 (
    .clk(CLOCK_50),
    .value(game_timer_value),
    .display0(HEX4), // Connect to HEX4
    .display1(HEX5), // Connect to HEX5
    .display2(HEX6), 
    .display3(HEX7)
    );
	 
	 
	 rng u2 (
        .clk(CLOCK_50),
        .random_value(random_value)
		  
    );
	 

    reaction_time_fsm u1 (
        .clk(CLOCK_50),
        .button_pressed(button_pressed),
		  .switches(SW),
		  .game_reset(game_reset),
		  .game_timer_enable(game_timer_enable),
        .timer_value(timer_value),
		  .game_timer_value(game_timer_value),
		  .random_value(random_value),
        .reset(timer_reset),
        .up(timer_up),
        .enable(timer_enable),
        .led_on(LEDR),
		  .user_score(user_score)
    );




endmodule
