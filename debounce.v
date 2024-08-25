module debounce #(
  parameter DELAY_COUNTS = 2500 // 50us with clk period 20ns is 2500 counts
) (
    input clk, button,
    output reg button_pressed = 0
);

// Use a synchronizer to synchronize `button`.
wire button_sync; // Output of the synchronizer. Input to debounce logic.
synchroniser button_synchroniser (.clk(clk), .x(button), .y(button_sync));

// Declare registers
reg prev_button = 0;
reg [31:0] count = 0;

// Set the count flip-flop:
always @(posedge clk) begin
    if (button_sync != prev_button) begin
        count <= 0;
    end
    else if (count < DELAY_COUNTS) begin
        count <= count + 1;
    end
end

// Set the prev_button flip-flop:
always @(posedge clk) begin
    prev_button <= button_sync; // Always update prev_button with button_sync
end

// Set the button_pressed flip-flop:
always @(posedge clk) begin
    if (count == DELAY_COUNTS) begin
        button_pressed <= prev_button; // Set button_pressed after debounce delay
    end
end

endmodule
