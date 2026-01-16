`timescale 1ns / 1ps

module light_driver (
    input wire clk,
    input wire rst,
    input wire [2:0] current_state, 
    input wire emerg_active,         I
    output reg [5:0] led_output      
);

    parameter ACTIVE_LOW = 0; 

    localparam S_ALL_RED    = 3'd0;
    localparam S_MAIN_GREEN = 3'd1;
    localparam S_MAIN_YEL   = 3'd2;
    localparam S_SIDE_GREEN = 3'd3;
    localparam S_SIDE_YEL   = 3'd4;
    localparam S_EMERGENCY  = 3'd5;

    reg [5:0] led_logic;

     
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            led_logic <= 6'b100100; 
        end else begin
            case (current_state)
                S_ALL_RED:    led_logic <= 6'b100100; 
                S_MAIN_GREEN: led_logic <= 6'b001100; 
                S_MAIN_YEL:   led_logic <= 6'b010100; 
                S_SIDE_GREEN: led_logic <= 6'b100001; 
                S_SIDE_YEL:   led_logic <= 6'b100010; 
                S_EMERGENCY:  led_logic <= 6'b100100; 
                default:      led_logic <= 6'b100100; 
            endcase
        end
    end

   
    always @(*) begin
        if (emerg_active) begin
            
            led_output = (ACTIVE_LOW) ? ~6'b100100 : 6'b100100;
        end else begin
            
            if (ACTIVE_LOW) 
                led_output = ~led_logic;
            else 
                led_output = led_logic; 
        end
    end

endmodule
