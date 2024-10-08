module top_level #(
    parameter SCALE_FACTOR = 1
)(
    input         CLOCK_50,              // DE2-115's 50MHz clock signal
    input  [3:0]  KEY,                   // The 4 push buttons on the board
	 input  [17:0] SW, 
    output [17:0] LEDR,                  // 18 red LEDs
    output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 // Four 7-segment displays
	 
);

    // Intermediate wires: (DO NOT EDIT WIRE NAMES!)
	 wire [6:0]  user_score;
    wire        timer_reset, timer_up, timer_enable, button_pressed;
	 wire 		 game_reset, game_timer_enable;
    wire [10:0] timer_value, random_value;
	 
	 wire [6:0] HEX_DUMMY0, HEX_DUMMY1;
	 
	 wire [3:0] level;
	 
	 wire [$clog2(60)-1:0] game_timer_value;
	 
	 wire [$clog2(60)-1:0] sus_timer;
	 wire button_edge;
	 assign sus_timer = 6'b111100 - game_timer_value;
	 assign HEX7 = 7'b1000111;
	 
	 wire [17:0] SW_FILT;

    // First module instantiated for you as an example:
    timer     #(.MAX_MS(2047), .CLKS_PER_MS(50000/SCALE_FACTOR))      u_mole_on_timer         (// Inputs:
                                    .clk(CLOCK_50),
                                    .reset(timer_reset),
                                    .up(timer_up),
                                    .enable(timer_enable),
                                    .timer_value(timer_value));
	
	 // Timer for countdown while game is taking place											
    timer   #(.MAX_MS(60), .CLKS_PER_MS(50000000/SCALE_FACTOR))    u_countdown_timer         (// Inputs:
                                    .clk(CLOCK_50),
                                    .reset(game_reset),
                                    .up(1),
                                    .enable(game_timer_enable),
                                    .timer_value(game_timer_value));

    debounce #(.DELAY_COUNTS(2500/SCALE_FACTOR)) u_debounce (
    .clk(CLOCK_50),
    .button(KEY[0]),  // Connect to KEY[0]
    .button_pressed(button_pressed));
	 
	 genvar i;   // Important: use the 'genvar' type for the index of the generate for loop.
	 generate
	   for (i=0; i<17; i=i+1) begin : gen_byte // Important: label the loop (e.g. 'gen_byte').
			 debounce #(.DELAY_COUNTS(2500/SCALE_FACTOR)) u0 (
			 .clk(CLOCK_50),
			 .button(SW[i]),  // Connect to KEY[0]
			 .button_pressed(SW_FILT[i]));
	   end
	 endgenerate

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
    .value(sus_timer+(100*level/SCALE_FACTOR)),
    .display0(HEX4), // Connect to HEX4
    .display1(HEX5), // Connect to HEX5
    .display2(HEX_DUMMY0), 
    .display3(HEX_DUMMY1)
    );
	 
	 seven_seg level_num_display(
	 .bcd(level),
	 .segments(HEX6)
	 );
	 
	 
	 rng u2 (
        .clk(CLOCK_50),
        .random_value(random_value)
		  
    );
	 
	 button_edge_module u_be (
		.clk(CLOCK_50),
		.button_pressed(button_pressed),
		.button_edge(button_edge)
	);
	 

    reaction_time_fsm u1 (
        .clk(CLOCK_50),
        .button_edge(button_edge),
		  .switches(SW_FILT),
		  .game_reset(game_reset),
		  .game_timer_enable(game_timer_enable),
        .timer_value(timer_value),
		  .game_timer_value(game_timer_value),
		  .random_value(random_value),
        .reset(timer_reset),
        .up(timer_up),
        .enable(timer_enable),
        .led_on(LEDR),
		  .user_score(user_score),
		  .level(level)
    );




endmodule
