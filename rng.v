module rng #(
    parameter MAX_VALUE = 17,
    parameter SEED= 1 // Choose a random number seed here!
) (
    input clk,
    output [$clog2(MAX_VALUE)-1:0] random_value // 5-bits for values 0 to 32.
);
    reg [10:1] lfsr; // The 10-bit Linear Feedback Shift Register. Note the 10 down-to 1. (No bit-0, we count from 1 in this case!)

    // Initialise the shift reg to SEED, which should be a non-zero value:
    initial lfsr = SEED;

    // Set the feedback:
    wire feedback;
    assign feedback = lfsr[10] ^ lfsr[7];

    //    Make sure to shift left from bit 1 (LSB) towards bit 10 (MSB).
    always @(posedge clk)
    begin
        lfsr <= lfsr << 1;
        lfsr[1] <= feedback;
    end

    // Ensure that the random value is not outside of the LED range.
    assign random_value = (lfsr[5:1]>MAX_VALUE) ? (lfsr[5:1] - MAX_VALUE) : lfsr[5:1];
endmodule