`timescale 1ns / 1ps

module traffic_light_fsm (
    input wire clk,
    input wire rst,
    
    input wire timer_done,     
    input wire sensor_detected, 
    input wire emerg_active,    
    
    output reg timer_start,     
    output reg [1:0] duration_sel, 
    output reg [2:0] current_state 
);

    
    localparam S_ALL_RED    = 3'd0; 
    localparam S_MAIN_GREEN = 3'd1; 
    localparam S_MAIN_YEL   = 3'd2; 
    localparam S_SIDE_GREEN = 3'd3; 
    localparam S_SIDE_YEL   = 3'd4; 
    localparam S_EMERGENCY  = 3'd5; 

   
    localparam DUR_SHORT  = 2'b00; 
    localparam DUR_MED    = 2'b01; 
    localparam DUR_LONG   = 2'b10; 

    
    reg [2:0] state_reg, state_next;

    
    always @(posedge clk or posedge rst) begin
        if (rst) 
            state_reg <= S_ALL_RED;
        else 
            state_reg <= state_next;
    end

    
    always @(*) begin
        
        state_next = state_reg;
        timer_start = 1'b0;
        duration_sel = DUR_SHORT;
        current_state = state_reg;

        
        if (emerg_active) begin
            state_next = S_EMERGENCY;
	    timer_start = 1'b0;
        end 
        else begin
            case (state_reg)
                
                S_ALL_RED: begin
                    duration_sel = DUR_SHORT; 
                    if (timer_done) begin
                        state_next = S_MAIN_GREEN;
                        timer_start = 1'b1;
                    end
                end

                
                S_MAIN_GREEN: begin
                    duration_sel = DUR_LONG;
                    
                    if (timer_done && sensor_detected) begin
                        state_next = S_MAIN_YEL;
                        timer_start = 1'b1;
                    end
                    
                end

                
                S_MAIN_YEL: begin
                    duration_sel = DUR_SHORT;
                    if (timer_done) begin
                        state_next = S_SIDE_GREEN;
                        timer_start = 1'b1;
                    end
                end

                
                S_SIDE_GREEN: begin
                    duration_sel = DUR_MED; 
                    if (timer_done) begin
                        state_next = S_SIDE_YEL;
                        timer_start = 1'b1;
                    end
                end

                
                S_SIDE_YEL: begin
                    duration_sel = DUR_SHORT;
                    if (timer_done) begin
                        state_next = S_MAIN_GREEN; 
                        timer_start = 1'b1;
                    end
                end

                
                S_EMERGENCY: begin
                    
                    if (!emerg_active) begin
                        state_next = S_ALL_RED;
                        timer_start = 1'b1;
                    end
                end

                default: state_next = S_ALL_RED;
            endcase
        end
    end

endmodule
