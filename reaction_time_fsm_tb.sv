//`timescale 1 ns / 1 ps
//
//module reaction_time_fsm_tb;
//
//    // Parameters
//    parameter MAX_MS = 2047;
//    parameter LED_NUM = 18;
//
//    // Testbench Variables
//    logic        clk;
//    logic        button_edge;
//    logic [10:0] timer_value;
//    logic        reset;
//    logic        up;
//    logic        enable;
//    logic [LED_NUM:0] led_on;
//    logic        game_timer_enable;
//    logic        game_reset;
//    logic [6:0]  user_score;
//    logic [3:0]  level;
//    logic [17:0] switches;
//    logic        [LED_NUM:0] leds;
//    logic        [LED_NUM:0] previous_switch_value;
//    logic        user_increment;
//    logic [6:0]  user_score_local;
//    logic [5:0]  game_timer_value;
//    logic [$clog2(LED_NUM)-1:0] random_value;
//	 
//
//    // Clock Period
//    localparam CLK_PERIOD = 20;
//
//    // Instantiate DUT (Device Under Test)
//    reaction_time_fsm #(
//        .MAX_MS(MAX_MS),
//        .LED_NUM(LED_NUM)
//    ) DUT (
//        .clk(clk),
//        .button_edge(button_edge),
//        .switches(switches),
//        .game_reset(game_reset),
//        .game_timer_enable(game_timer_enable),
//        .timer_value(timer_value),
//        .game_timer_value(game_timer_value),
//        .random_value(random_value),
//        .reset(reset),
//        .up(up),
//        .enable(enable),
//        .led_on(led_on),
//        .user_score(user_score),
//        .level(level)
//    );
//
//    // Clock generation
//    initial begin
//        clk = 0;
//        forever #(CLK_PERIOD) clk = ~clk;
//    end
//
//    // Initialize signals
//    initial begin
//        button_edge = 0;
//        timer_value = 0;
//        game_timer_value = 0;
//		  game_timer_enable = 1;
//        random_value = 0;               // Set an initial random_value
//        switches = 0;                    // Initial switch value
//        leds = 0;
//        previous_switch_value = 0;
//        user_score_local = 0;
//        user_increment = 0;
//		  reset = 0;
//		  user_score = 0;
//		  level = 0;
//		  game_reset = 0;
//		  up = 1;
//		  enable = 1;
//		  led_on = 0;
//		  
//    end
//
//    // Testbench stimulus
//    initial begin
//        $dumpfile("waveform.vcd");  // VCD dump file
//        $dumpvars(0, reaction_time_fsm_tb); // Dump all variables
//
//        // Initial button press to transition to S1
////        #(CLK_PERIOD*10);
////        button_edge = 1;
////        #(CLK_PERIOD*5);
////        button_edge = 0;
//
//        // Set switches to match random_value directly
//        #(CLK_PERIOD*25);
//        switches = random_value;  // Directly match switches to random_value
//
//        // Trigger transitions and increment the user_score
////        repeat (5) begin
////            #(CLK_PERIOD*10);
////            button_edge = 1;
////            #(CLK_PERIOD*5);
////            button_edge = 0;
////				
////				#(CLK_PERIOD*10);
////            button_edge = 1;
////            #(CLK_PERIOD*5);
////            button_edge = 0;
////            switches = random_value;   // Align switches to random_value (4 in this case)
////            
////				#(CLK_PERIOD*20);          // Wait for FSM to update score
////        end
//
//        // Observe if user_score increments to 5
////      // #(CLK_PERIOD*10);
//        $display("Final state:  = %b, up = %b, enable = %b, led_on = %b, user_score = %d, level = %d, switches = %d, random_value = %d", 
//                  reset, up, enable, led_on, user_score, level, switches, random_value);
//
//        $finish();
//    end
//
//endmodule






`timescale 1 ns / 1 ps
module reaction_time_fsm_tb;

    // Parameters
    parameter MAX_MS = 2047;
    parameter LED_NUM = 18;
	 parameter MAX_TIME_LED_ON = 1000;

    // Testbench Variables
    logic        clk;
    logic        button_edge;
    logic [10:0] timer_value;
    logic        reset;
    logic        up;
    logic        enable;
    logic [LED_NUM:0] led_on;
    logic        game_timer_enable;
    logic        game_reset;
    logic [6:0]  user_score;
    logic [3:0]  level;
    logic [17:0] switches;
    logic        [LED_NUM:0] leds;
    logic        [LED_NUM:0] previous_switch_value;
    logic        user_increment;
    logic [6:0]  user_score_local;
    logic [5:0]  game_timer_value;
    logic [$clog2(LED_NUM)-1:0] random_value;

    // Clock Period
    localparam CLK_PERIOD = 20;

    // Instantiate DUT (Device Under Test)
    reaction_time_fsm #(
        .MAX_MS(MAX_MS),
        .LED_NUM(LED_NUM)
    ) DUT (
        .clk(clk),
        .button_edge(button_edge),
        .switches(switches),
        .game_reset(game_reset),
        .game_timer_enable(game_timer_enable),
        .timer_value(timer_value),
        .game_timer_value(game_timer_value),
        .random_value(random_value),
        .reset(reset),
        .up(up),
        .enable(enable),
        .led_on(led_on),
        .user_score(user_score),
        .level(level)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD) clk = ~clk;
    end

    // Initialize signals
    initial begin
        game_reset = 1;
		  game_timer_enable = 0;
		  reset = 1;
		  up = 0;
		  enable = 0;
		  led_on = 0;
		  user_increment = 0;
		  button_edge = 0;
		  timer_value = 0;
		  switches = 0;
		  leds = 0;
		  previous_switch_value = 0;
		  user_score_local = 0;
		  game_timer_value = 0;
		  random_value = 0;
    end

    // Testbench stimulus
    initial begin
        $dumpfile("waveform.vcd");  // VCD dump file
        $dumpvars(0, reaction_time_fsm_tb); // Dump all variables
		  
		  #(CLK_PERIOD * 20);
		  button_edge = 1;
		  #(CLK_PERIOD);
		  button_edge = 0;
		  
		  #(CLK_PERIOD * 20);
		  timer_value = 0;
		 
		  #(CLK_PERIOD * 20);
		  timer_value = MAX_TIME_LED_ON;
		  
		  #(CLK_PERIOD * 20);
		  timer_value = 0;
		  
		  #(CLK_PERIOD * 20);
		  leds = 1;
		  
		  #(CLK_PERIOD * 20);
		  game_timer_value = 60;
		  
		  #(CLK_PERIOD * 20);
		  button_edge = 1;
		  #(CLK_PERIOD);
		  button_edge = 0;
		  
		  
		 
		  
	
        $display("Final state: reset = %b, up = %b, enable = %b, led_on = %b, user_score = %d, level = %d, switches = %d, random_value = %d", 
                  reset, up, enable, led_on, user_score, level, switches, random_value);

        $finish();
    end

endmodule
