module reaction_time_fsm #(
    parameter MAX_MS=2047,
    parameter LED_NUM = 18,
	 parameter MAX_TIME_LED_ON = 1000 // Ms
)(
    input                             clk,
    input                             button_pressed,
    input        [$clog2(MAX_MS)-1:0] timer_value,
	 input 		  [$clog2(10)-1:0]     game_timer_value,
	 input 									  [$clog2(LED_NUM)-1:0]random_value,
	 input  									  [17:0] switches, 
    output logic                      reset,
    output logic                      up,
    output logic                      enable,
	 output logic 							  game_reset, 
	 output logic 							  game_timer_enable,
    output logic                      [LED_NUM:0] led_on,
	 output logic 							  [3:0] user_score
);  
		
    // Edge detection block here!
    logic button_q0, button_edge;
    always_ff @(posedge clk) begin : edge_detect
        button_q0 <= button_pressed;
    end : edge_detect
    assign button_edge = (button_pressed > button_q0);

    // State typedef enum here! (See 3.1 code snippets)
	 
//    typedef enum {S0, S1, S2, S3} state_type;
//	 typedef enum {S0, S1, S2, S3} state_type = S0;

//    state_type state, next_state;

	 enum {S0, S1, S2, S3, S4} next_state, state = S0;
    
    // always_comb for next_state_logic here! (See 3.1 code snippets)
	 // state <= S0;
    always_comb 
    begin
        case (state)
		  
            S0: 
            begin
                next_state = (button_edge) ? S1 : S0;  
            end
				
            S1: 
            begin
					 if (timer_value == 0) begin
							next_state = S2;
					 end 
					 
					 else if (button_edge) begin
							next_state = S0;
					 end 
					 
					 else if (game_timer_value == 0) begin
							next_state = S4;
					 end
					 
					 else begin
							next_state = S1;
					 end 

            end

            S2: 
            begin
                if (timer_value == MAX_TIME_LED_ON) begin
						next_state = S1;
					 end 
					 
					 else if (leds == (previous_switch_value ^ switches)) begin
						next_state = S3;
					 end 
					 
					 else if (game_timer_value == 0) begin
							next_state = S4;
					 end
					 
					 else if (button_edge) begin
						next_state = S0;
					 end 
					 
					 else begin
						next_state = S2;
					 end
				end
				
            S3: 
            begin
					 if (game_timer_value == 0) begin
							next_state = S4;
					 end
                else begin
						    next_state = S1;
					 end
					 
            end
				
				S4: begin
					next_state = (button_edge) ? S0 : S4;
				end 
				
				default: begin
					next_state = S0;
				end
        endcase
    end
	 
	 logic [LED_NUM:0] leds;
	 
	 logic [LED_NUM:0] previous_switch_value;
	 
	 logic user_increment;
	 
	 logic [3:0] user_score_local;
    
    always_ff @(posedge clk) begin
		  state <= S0;
        state <= next_state;
		 
		  
		  if (state == S1) begin
				leds <= 1 << random_value;
				
				previous_switch_value <= switches;
		  end
		  
//		  else if (state == S0) begin
//				user_score_local <= 0;
//		  end
		  
		  else if (state == S3) begin
				user_score_local <= user_score_local + user_increment;
		  end
		  
    end
	 
	
    // Continuously assign outputs here! (See 3.1 code snippets)
    always_comb 
    begin
				game_reset = 1;
				game_timer_enable = 1;
				
	         reset = 1;
            up = 0;
            enable = 0;
            led_on = 0;  
				user_increment = 0;
        case (state)
            S0: 
            begin
					 game_reset = 1;
					 game_timer_enable = 0;
					 
                reset = 1;
                up = 0;
                enable = 0;
                led_on = 0;  
					 user_increment = 0;
            end
				
            S1: 
            begin
					 game_reset = 0;
					 game_timer_enable = 1;
					 
                reset = (timer_value == 0);
                up = 1;
                enable = 1;
                led_on = 0; 
					 user_increment = 0;
            end
				
            S2: 
            begin
					 game_reset = 0;
					 game_timer_enable = 1;
					 
                reset = 0;
                up = 0;
                enable = 1;
                led_on = leds;
					 user_increment = 0;
            end
            S3: 
            begin
					 game_reset = 0;
					 game_timer_enable = 1;
					 
                reset = 0;
                up = 0;
                enable = 0;
                led_on = 0; 
					 user_increment = 1;
            end
				
				S4:
				begin
					 game_reset = 1;
					 game_timer_enable = 0;
					 
					 led_on = leds;
					 reset = 1;
                up = 0;
                enable = 0;
					 user_increment = 0;
				end
				
				default:
				begin
				   game_reset = 1;
					game_timer_enable = 0;
					
					reset = 1;
					up = 0;
					enable = 0;
					led_on = 0;
					user_increment = 0;
				end
        endcase
    end
	 
	 assign user_score = user_score_local;
    
endmodule