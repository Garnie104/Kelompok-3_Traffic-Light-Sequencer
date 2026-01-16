`timescale 1ns / 1ps

module emergency_override (
    input wire clk,
    input wire rst,
    input wire btn_emerg_raw,
    output reg emerg_active  
);

    parameter DEBOUNCE_LIMIT = 32'd5; 

    reg btn_sync_0;
    reg btn_sync_1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_sync_0 <= 1'b0;
            btn_sync_1 <= 1'b0;
        end else begin
            btn_sync_0 <= btn_emerg_raw;
            btn_sync_1 <= btn_sync_0;
        end
    end

    reg [31:0] count;
    

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 32'd0;
            emerg_active <= 1'b0;
        end else begin

            if (btn_sync_1 != emerg_active) begin
                if (count < DEBOUNCE_LIMIT) begin
                    count <= count + 1;
                end else begin
                    
                    emerg_active <= btn_sync_1; 
                    count <= 32'd0;
                end
            end else begin
                
                count <= 32'd0;
            end
        end
    end

endmodule