`timescale 1ns/1ns /* This directive (`) specifies simulation <time unit>/<time precision>. */

module timer_tb;

    reg         clk, reset, up, enable;   // Need to use `reg` here (set in always block).
    reg  [10:0] start_value;
    wire [10:0] timer_value;

    timer DUT (
        .clk(clk), .reset(reset), .up(up), .start_value(start_value), .enable(enable),
        .timer_value(timer_value)
    );

    initial begin : clock_block
        clk = 1'b0;
        forever begin
            #10;
            clk = ~clk; // Clock period = 20 ns (half-period is 10 ns)
        end
    end

    initial begin  // Run the following code starting from the beginning of the simulation.
        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation.
        $dumpvars();
        /* NOTE: that since we have large delays in this simulation, it is possible for the waveform.vcd file
         *       to get too large for this workspace. If you get file space errors, minimise the delays in this
         *       testbench and delete the waveform file each time before running.
         *       Note to fix this, the .fst file format could be used. This is an alternate waveform format that includes compression. */

        #(500000);         // Wait 500 us (500000 ns) before enabling the timer.

        enable = 1'b1;     // Enable the timer module.

        /** Test counting up to 3 ms **/
        up     = 1'b1;
        reset  = 1'b1;     // Reset counter to count upwards (as up = 1'b1).

        #20;               // Wait 1 clock period to *clock* new values before deasserting `reset` (i.e. a reset pulse).
        reset  = 1'b0;     // Disable reset to start counting:

        #20;               // Wait a clock period to get the new timer_value value after deasserting `reset`.
        
        // Print out the timer value over the next 3 milliseconds:
        repeat(3) begin
            $display("t=%0d ns: timer_value=%0d", $time, timer_value);  // $time gets current simulation time.
            #1000000; // Wait 1 millisecond (1000000 ns)
        end
        if (timer_value != 3) $warning("t=%0d ns: timer_value=%0d, but expected 3!",$time, timer_value);

        #500000; // Wait 0.5 milliseconds (500000 ns)

        /** Test counting down from 7 ms to 5 ms **/
        start_value = 7;
        up          = 1'b0;
        reset       = 1'b1; // Reset counter to count down from starting value 7.

        #20;                // Wait 1 clock period to *clock* new values before deasserting `reset` (i.e. a reset pulse).
        reset       = 1'b0; // Disable reset to start counting down from 7:
        if (timer_value != 7) $warning("t=%0d ns: timer_value=%0d, but expected 7!",$time, timer_value);

        #20;                // Wait a clock period to get the new timer_value value after deasserting `reset`.
        
        // Print out the timer value over the next 2 milliseconds:
        $display("t=%0d ns: timer_value=%0d",$time, timer_value);  // $time gets current simulation time.
        repeat(2) begin
            #1000000; // Wait 1 millisecond
            $display("t=%0d ns: timer_value=%0d",$time, timer_value); // Timer should count down from 7 ms to 5 ms.
        end
        if (timer_value != 5) $warning("t=%0d ns: timer_value=%0d, but expected 5!",$time, timer_value);

        /** Test pausing the timer for 2 ms **/
        enable = 1'b0;      // Disable the timer module, i.e. pause the timer.

        #2000000;  // Wait 2 milliseconds (2000000 ns)

        $display("t=%0d ns: timer_value=%0d", $time, timer_value); // Timer should have remained on previous value = 5 ms
        if (timer_value != 5) $warning("t=%0d ns: timer_value=%0d, but expected 5!",$time, timer_value);
        
        enable = 1'b1;      // Enable the timer module, i.e. resume the timer.

        #1500000;  // Wait 1.5 milliseconds (1500000 ns).

        $display("t=%0d ns: timer_value=%0d", $time, timer_value); // Timer should resume counting down from 5 ms to 4 ms
        if (timer_value != 4) $warning("t=%0d ns: timer_value=%0d, but expected 4!",$time, timer_value);

        $finish();  // Finish the simulation.
    end
    
endmodule
