module debounce_tb;
    // Testbench Signals
    reg clk;
    reg button;
    wire button_pressed;

    // Instantiate the debounce module
    debounce dut (
        .clk(clk),
        .button(button),
        .button_pressed(button_pressed)
    );

    // Clock generation: 20ns clock period (50 MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Initialize signals
    initial begin
        // Initialize the button to 0
        button = 0;
    end

    // Test procedure
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars();

        // Apply the first button press (bouncing scenario)
        #100 button = 1;
        #50  button = 0;  // Bouncing to 0 quickly
        #50  button = 1;  // Button settles to 1
        #50;

        // Wait enough time for debounce to trigger
        #(2500 * 20);  // Wait for 2500 clock cycles (50 microseconds)

        // Display the value of button_pressed
        $display("Time: %0t | button_pressed: %b", $time, button_pressed);

        // Apply the button release (another bouncing scenario)
        #100 button = 0;
        #50  button = 1;  // Bounces back to 1 quickly
        #50  button = 0;  // Button settles to 0
        #50;

        // Wait enough time for debounce to trigger
        #(2500 * 20);  // Wait for 2500 clock cycles (50 microseconds)

        // Display the value of button_pressed after button release
        $display("Time: %0t | button_pressed: %b", $time, button_pressed);

        $finish(); // End simulation
    end

endmodule
