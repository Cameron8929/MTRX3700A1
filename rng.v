module rng #(
    parameter MAX_VALUE = 18,
    parameter SEED= 1 // Choose a random number seed here!
) (
    input clk,
    output [$clog2(MAX_VALUE)-1:0] random_value // -bits for values 200 to 1223.
);
    reg [5:1] lfsr; // The 10-bit Linear Feedback Shift Register. Note the 10 down-to 1. (No bit-0, we count from 1 in this case!)

    // Initialise the shift reg to SEED, which should be a non-zero value:
    initial lfsr = SEED;

    // Set the feedback:
    wire feedback;
    assign feedback = lfsr[2] ^ lfsr[3];

    // Put shift register logic here (use an always @(posedge clk) block):
    //    Make sure to shift left from bit 1 (LSB) towards bit 10 (MSB).
    always @(posedge clk)
    begin
        lfsr <= lfsr << 1;
        lfsr[1] <= feedback;
    end

    assign random_value = (lfsr > MAX_VALUE) ? (lfsr - MAX_VALUE)-1 : lfsr-1;
endmodule