module reaction_time_fsm #(
    parameter MAX_MS=2047    
)(
    input                             clk,
    input                             button_pressed,
    input        [$clog2(MAX_MS)-1:0] timer_value,
    output logic                      reset,
    output logic                      up,
    output logic                      enable,
    output logic                      led_on
);  


    // Edge detection block here!
    logic button_q0, button_edge;
    always_ff @(posedge clk) begin : edge_detect
        button_q0 <= button_pressed;
    end : edge_detect
    assign button_edge = (button_pressed > button_q0);

    // State typedef enum here! (See 3.1 code snippets)
    typedef enum {S0, S1, S2, S3} state_type;
    state_type current_state, next_state;
    
    // always_comb for next_state_logic here! (See 3.1 code snippets)
    always_comb begin : next_state_logic
        case (current_state)
            S0: next_state = (button_edge) ? S1 : S0;
            S1: next_state = (timer_value == 0)? S2 : S1;
            S2: next_state = (button_edge) ? S3 : S2;
            S3: next_state = (button_edge) ? S0 : S3;
        endcase
    end


    
    // always_ff for FSM state variable flip-flops here! (See 3.1 code snippets)
    always_ff @(posedge clk) begin : double_dabble_fsm_ff
        current_state <= next_state;
    end

    // Continuously assign outputs here! (See 3.1 code snippets)
    always_comb begin
        case (current_state)
            S0: begin
                reset = 1; 
                enable = 0;
                up = 0;
                led_on = 0;
            end

            S1: begin
                reset = (timer_value == 0); 
                up = 1; 
                enable = 1; 
                led_on = 0;
            end

            S2: begin
                reset = 0;
                up = 0; 
                enable = 1; 
                led_on = 1;
            end 

            S3: begin 
                reset = 0;
                up = 0;
                enable = 0;
                led_on = 0;
            end 
        endcase
    end
endmodule
