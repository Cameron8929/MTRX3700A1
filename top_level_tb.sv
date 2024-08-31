`timescale 1us/1us
module top_level_tb;
    // Step 1: Define test bench variables:
    logic        CLOCK_50;
	 logic [3:0] KEY;
	 logic [17:0] SW;
	 logic [17:0] LEDR;
	 logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;


    logic [10:0] start_value = 10; // Initialise to 10.
	 
	 initial begin
		CLOCK_50 = 0;
		KEY = 0;
		SW = 0;
		{HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6} = 0;
	  end

    // Step 2: Instantiate Device Under Test:
	 localparam SIMULATE_SECONDS = 100000;
    top_level #(.SCALE_FACTOR(1000)) DUT (.*);             // SystemVerilog feature: `.*` automatically connects ports of the instantiated module to variables in this module with the same port/variable name!! So useful :D.
	 localparam CLK_PERIOD = 10;
    // Step 3: Toggle the clock variable every 10 time units to create a clock signal **with period = 20 time units**:
    initial begin
		CLOCK_50 = 0;
		forever #(CLK_PERIOD) CLOCK_50 = ~CLOCK_50;
	  end


    // Step 4: Initial block with initial inputs. To specify later inputs, use the delay operator `#`.
    initial begin
        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation. Required to produce a waveform .vcd file.
        $dumpvars();
		  
//		  #(CLK_PERIOD*0);
//		  KEY[0] = 0;
        #(CLK_PERIOD*5*SIMULATE_SECONDS);
        KEY[0] = 1;
        #(CLK_PERIOD*0.5*SIMULATE_SECONDS);
        KEY[0] = 0; // Start count down
		  #(CLK_PERIOD*2*SIMULATE_SECONDS);
		  
		  


        $finish(); // Important: must end simulation (or it will go on forever!)
    end
endmodule
