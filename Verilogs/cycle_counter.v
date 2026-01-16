`timescale 1ns / 1ps

module cycle_counter (
    input wire clk,
    input wire rst,
    input wire cycle_tick,       
    output reg [15:0] count_out  
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count_out <= 16'd0;
        end else begin
            if (cycle_tick) begin
                count_out <= count_out + 1;
            end
        end
    end

endmodule
