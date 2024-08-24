module rng #(
    parameter OFFSET=200,
//    parameter MAX_VALUE=17,
    parameter MAX_VALUE = 16,
    parameter SEED= 340 // Choose a random number seed here!
) (
    input clk,
    output [$clog2(MAX_VALUE)-1:0] random_value // 11-bits for values 200 to 1223.
);
    reg [10:1] lfsr; // The 10-bit Linear Feedback Shift Register. Note the 10 down-to 1. (No bit-0, we count from 1 in this case!)

    // Initialise the shift reg to SEED, which should be a non-zero value:
    initial lfsr = SEED;

    // Set the feedback:
    wire feedback;
    assign feedback = lfsr[10] ^ lfsr[7];

    // Put shift register logic here (use an always @(posedge clk) block):
    //    Make sure to shift left from bit 1 (LSB) towards bit 10 (MSB).
    always @(posedge clk)
    begin
        lfsr <= lfsr << 1;
        lfsr[1] <= feedback;
    end

    assign random_value = lfsr + OFFSET;


    // Assign random_value to your LSFR output + OFFSET to acheive the range 200 to 1223. Use continuous assign!

endmodule