module rng #(
    parameter MAX_VALUE = 18, //Number of LED's
    parameter SEED= 1 // Choose a random number seed here!
) (
    input clk,
    output [$clog2(MAX_VALUE)-1:0] random_value // 5-bits for values 0-17.
);
    reg [5:1] lfsr; // The 5-bit Linear Feedback Shift Register

    // Initialise the shift reg to SEED, which should be a non-zero value:
    initial lfsr = SEED;

    // Set the feedback:
    wire feedback;
    assign feedback = lfsr[2] ^ lfsr[3];

    //    Make sure to shift left from bit 1 (LSB) towards bit 10 (MSB).
    always @(posedge clk)
    begin
        lfsr <= lfsr << 1;
        lfsr[1] <= feedback;
    end

    // Ensure the final value is between 0-17 since 5-bits can produce a number up to 32.
    assign random_value = (lfsr > MAX_VALUE) ? (lfsr - MAX_VALUE)-1 : lfsr-1;
endmodule