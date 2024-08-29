module button_edge_module (
    input                             clk,
	 input 									button_pressed,
	 output logic 							button_edge
);  
		
    // Edge detection block here!
    logic button_q0;
    always_ff @(posedge clk) begin : edge_detect
        button_q0 <= button_pressed;
    end : edge_detect
    assign button_edge = (button_pressed > button_q0);
    
endmodule