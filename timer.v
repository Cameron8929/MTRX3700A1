// James test
//Darcy test

`timescale 1ns/1ns /* This directive (`) specifies simulation <time unit>/<time precision>. */

module timer #(
    parameter MAX_MS = 2047,            // Maximum millisecond value
    parameter CLKS_PER_MS = 50000 // What is the number of clock cycles in a millisecond?
) (
    input                       clk,
    input                       reset,
    input                       up,
    //input  [$clog2(MAX_)-1:0] start_value, // What does the $clog2() function do here?
    
	 input                       enable,
    output [$clog2(MAX_MS)-1:0] timer_value
);
	 wire [$clog2(MAX_MS)-1:0]start_value;
	 assign start_value = 50000;
	 
    // Your code here!
	 // Test Delete and Reopen
    reg [$clog2(CLKS_PER_MS)-1:0] clock_ticks;
    reg [$clog2(MAX_MS)-1:0] ms;

    reg count_up;
    assign timer_value = ms;

    always @(posedge clk)
    begin
        if (reset)
        begin
            clock_ticks <= 0;
            if (up)
            begin
                ms <= 0;
                count_up <= 1;
            end
            else
            begin
                ms <= start_value;
                count_up <= 0;
            end
        end
        else if (enable) 
        begin  
            if (clock_ticks >= (CLKS_PER_MS - 1))
            begin
                clock_ticks <= 0;
                if (count_up)
                begin
                    ms <= ms + 1;
                end
                else
                begin
                    ms <= ms - 1;
                end
            end
            else
            begin
                clock_ticks <= clock_ticks + 1;
            end

        end
        
    end
    

endmodule