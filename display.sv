module display (
    input         clk,
    input  [10:0] value,
    output [6:0]  display0,
    output [6:0]  display1,
    output [6:0]  display2,
    output [6:0]  display3
);
    /*** FSM Controller Code: ***/
    enum { Initialise, Add3, Shift, Result } next_state, current_state = Initialise; // FSM states.
    
    logic init, add, done; // FSM outputs.

    logic [3:0] count = 0; // Use this to count the 11 loop iterations.

    /*** DO NOT MODIFY THE CODE ABOVE ***/

    //TODO
    always_comb begin : double_dabble_fsm_next_state_logic
        case (current_state)
            Initialise: next_state = Add3;
            Shift:      next_state = count == 10 ? Result : Add3; // After 11 iterations, exit out of the loop
            // Add cases for the other states... (No inputs on those transitions)
            Add3:       next_state = Shift;
            Result:     next_state = Initialise;
            default:    next_state = Result;
        endcase
    end
    //TODO
    always_ff @(posedge clk) begin : double_dabble_fsm_ff
        // Set state to next state.

        // To implement the loop, we use count to count the iterations.
        // Increment count if in the Shift state.
        // Set count to zero if in the Result state.
        current_state <= next_state;
        
        case (current_state)
            Shift: count <= count + 1;
            Result: count <= 0;
        endcase
    end
    //TODO
    always_comb begin : double_dabble_fsm_output
        // Assign init, add and done based on the current state.

        done = 0;

        init = 0;
        add = 0;
        case (current_state)
            Initialise: init = 1;
            Add3:       add = 1;
            Shift:      add = 0;
            Result:    done = 1;
        endcase 
    end
    

    /*** DO NOT MODIFY THE CODE BELOW ***/

    logic [3:0] digit0, digit1, digit2, digit3;

    //// Seven-Segment Displays
    seven_seg u_digit0 (.bcd(digit0), .segments(display0));
    seven_seg u_digit1 (.bcd(digit1), .segments(display1));
    seven_seg u_digit2 (.bcd(digit2), .segments(display2));
    seven_seg u_digit3 (.bcd(digit3), .segments(display3));

    // Algorithm RTL:  (completed no changes required - see dd_rtl.png for a representation of the code below but for 2 BCD digits.)
    // essentially a 27-bit long, 1-bit wide shift-register, starting from the 11 input bits through to the 4 bits of each BCD digit (4*4=16, 16+11=27).
    // We shift in the Shift state, add 3 to BCD digits greater than 4 in the Add3 state, and initialise the shift-register values in the Initialise state.
    logic [3:0]  bcd0, bcd1, bcd2, bcd3; // Do NOT change.
    logic [10:0] temp_value; // Do NOT change.

    always_ff @(posedge clk) begin : double_dabble_shiftreg
        if (init) begin // Initialise: set bcd values to 0 and temp_value to value.
            {bcd3, bcd2, bcd1, bcd0, temp_value} <= {16'b0, value}; // A nice usage of the concat operator on both LHS and RHS!
        end
        else begin
            if (add) begin // Add3: 3 is added to each bcd value greater than 4.
                bcd0 <= bcd0 > 4 ? bcd0 + 3 : bcd0;  // Conditional operator.
                bcd1 <= bcd1 > 4 ? bcd1 + 3 : bcd1;
                bcd2 <= bcd2 > 4 ? bcd2 + 3 : bcd2;
                bcd3 <= bcd3 > 4 ? bcd3 + 3 : bcd3;
            end
            else begin // Shift: essentially everything becomes a shift-register
                {bcd3, bcd2, bcd1, bcd0, temp_value} <= {bcd3, bcd2, bcd1, bcd0, temp_value} << 1; // Concat operator makes this easy!
            end
        end
    end

    always_ff @(posedge clk) begin : double_dabble_ff_output
        // Need to 'flop' bcd values at the output so that intermediate calculations are not seen at the output.
        if (done) begin  // Only take bcd values when the algorithm is done!
            digit0 <= bcd0;
            digit1 <= bcd1;
            digit2 <= bcd2;
            digit3 <= bcd3;
        end
    end

endmodule