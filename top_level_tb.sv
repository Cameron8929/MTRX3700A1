module top_level_tb;
    // Step 1: Define test bench variables:
    logic        CLOCK_50;
	 logic [3:0] KEY;
	 logic [17:0] SW;
	 logic [17:0] LEDR;
	 logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;


    logic [10:0] start_value = 10; // Initialise to 10.

    // Step 2: Instantiate Device Under Test:
    top_level DUT (.*);             // SystemVerilog feature: `.*` automatically connects ports of the instantiated module to variables in this module with the same port/variable name!! So useful :D.
	 
    // Step 3: Toggle the clock variable every 10 time units to create a clock signal **with period = 20 time units**:
    localparam CLK_PERIOD = 20;
    initial forever #(CLK_PERIOD/2) CLOCK_50 = ~CLOCK_50; // forever is an infinite loop!

    // Step 4: Initial block with initial inputs. To specify later inputs, use the delay operator `#`.
    initial begin
        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation. Required to produce a waveform .vcd file.
        $dumpvars();
		  
        
        start_value = 10;
        KEY[0] = 1;
        #(CLK_PERIOD*30);   // 10 Clock cycle delay.
        KEY[0] = 0; // Start count down
//        #(CLK_PERIOD*10);   // Timer counts 5 times from 10 to 5 (1 count every 2 clock cycles).
//        button_pressed = 0;
//        #(CLK_PERIOD*40);   // Timer counts 19 times (not 20, as it takes a clock cycle to reset the timer!)
//                            // So, the timer should have counted from 5 to 0, then up to 14.
//        button_pressed = 1; // React!
//        #(CLK_PERIOD*10);   // Timer should have paused (enable=0).
//        button_pressed = 0;
//        #(CLK_PERIOD*100);  // Pause for a further 100 cycles.
//        button_pressed = 1; // Go back to initial state.
//        #(CLK_PERIOD*10);
        $display(" reset: %b, up: %b, enable: %b, led_on: %b", reset, up, enable, led_on);

        $finish(); // Important: must end simulation (or it will go on forever!)
    end
endmodule
