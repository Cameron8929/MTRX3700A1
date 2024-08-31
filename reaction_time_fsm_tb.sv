module reaction_time_fsm_tb;

    // Parameters
    parameter MAX_MS = 2047;
    parameter LED_NUM = 18;

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
        .timer_value(timer_value),
        .game_timer_value(game_timer_value),
        .random_value(random_value),
        .switches(switches),
        .reset(reset),
        .up(up),
        .enable(enable),
        .led_on(led_on),
        .game_reset(game_reset),
        .game_timer_enable(game_timer_enable),
        .user_score(user_score),
        .level(level)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

	     initial begin 
        button_edge = 0;
        timer_value = 10;
        game_timer_value = 0;
        random_value = 5;
        switches = 18'b000000000000000000;
        user_score_local = 0;
		  leds = 0;
		  previous_switch_value = 0;
		  user_increment = 0;
    end
	 
    // Testbench stimulus
    initial begin
        $dumpfile("waveform.vcd");  // VCD dump file
        $dumpvars(0, reaction_time_fsm_tb); // Dump all variables

        // Initial values
        button_edge = 0;
        timer_value = 10; // Random starting value
        game_timer_value = 0;
        random_value = 5; // Random LED index
        switches = 18'b000000000000000000;
        user_score_local = 0;

        // Test case 1: Initial state, no button press
        #(CLK_PERIOD*10);
        button_edge = 1;  // Simulate button press
        #(CLK_PERIOD*5);
        button_edge = 0;

        // Test case 2: Timer reaching zero
        #(CLK_PERIOD*30);
        timer_value = 0;

        // Test case 3: Random state transitions
        #(CLK_PERIOD*10);
        game_timer_value = 60; // Game timer hits max
        #(CLK_PERIOD*10);
        button_edge = 1; // Button press to reset

        // Observe final state and outputs
        #(CLK_PERIOD*10);
        $display("Final state: reset = %b, up = %b, enable = %b, led_on = %b, user_score = %d, level = %d", reset, up, enable, led_on, user_score, level);

        $finish();
    end

endmodule
