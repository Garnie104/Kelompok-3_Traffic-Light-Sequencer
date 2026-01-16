`timescale 1ns / 1ps

module sensor_input (
    input wire clk,
    input wire rst,
    input wire sensor_raw,     
    output reg vehicle_detected 
);

    
    parameter ACTIVE_LOW = 1; 

    
    parameter FILTER_LIMIT = 32'd10;

  
    wire sensor_norm;
    
    assign sensor_norm = (ACTIVE_LOW) ? ~sensor_raw : sensor_raw;

    
    reg sync_0, sync_1;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync_0 <= 1'b0;
            sync_1 <= 1'b0;
        end else begin
            sync_0 <= sensor_norm;
            sync_1 <= sync_0;
        end
    end

    
    reg [31:0] counter;
    reg sensor_stable;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 32'd0;
            sensor_stable <= 1'b0;
            vehicle_detected <= 1'b0;
        end else begin
            if (sync_1 != sensor_stable) begin
                
                if (counter < FILTER_LIMIT) begin
                    counter <= counter + 1;
                end else begin
                    
                    sensor_stable <= sync_1;
                    vehicle_detected <= sync_1;
                    counter <= 32'd0;
                end
            end else begin
                
                counter <= 32'd0;
            end
        end
    end

endmodule