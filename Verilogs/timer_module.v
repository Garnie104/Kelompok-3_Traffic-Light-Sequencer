`timescale 1ns / 1ps

module timer_module (
    input wire clk,
    input wire rst,
    input wire timer_start,        
    input wire [1:0] duration_sel, 
    output reg timer_done          
);

  
    
    parameter CYCLES_SHORT  = 32'd50;   
    parameter CYCLES_MEDIUM = 32'd150;  
    parameter CYCLES_LONG   = 32'd300;  

    reg [31:0] counter;
    reg [31:0] target_cycles;

    
    always @(*) begin
        case (duration_sel)
            2'b00: target_cycles = CYCLES_SHORT;
            2'b01: target_cycles = CYCLES_MEDIUM;
            2'b10: target_cycles = CYCLES_LONG;
            default: target_cycles = CYCLES_SHORT;
        endcase
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 32'd0;
            timer_done <= 1'b0;
        end 
        else if (timer_start) begin
            
            counter <= 32'd0;
            timer_done <= 1'b0;
        end 
        else begin
            if (counter < target_cycles) begin
                counter <= counter + 1;
                timer_done <= 1'b0;
            end else begin
                
                timer_done <= 1'b1;
            end
        end
    end

endmodule
