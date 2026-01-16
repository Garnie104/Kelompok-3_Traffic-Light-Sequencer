`timescale 1ns / 1ps

module traffic_top (
    input wire clk,
    input wire rst,
    
    
    input wire btn_emerg_raw,  
    input wire sensor_raw,     
    
    
    output wire [5:0] led_output, 
    output wire [15:0] cycle_count 
);

    
    wire w_emerg_active;
    wire w_vehicle_detected;
    wire w_timer_start;
    wire w_timer_done;
    wire [1:0] w_duration_sel;
    wire [2:0] w_current_state;

    
    reg [2:0] prev_state;
    wire w_cycle_tick_pulse;

    emergency_override u_emerg (
        .clk(clk),
        .rst(rst),
        .btn_emerg_raw(btn_emerg_raw),
        .emerg_active(w_emerg_active)
    );

    sensor_input u_sensor (
        .clk(clk),
        .rst(rst),
        .sensor_raw(sensor_raw),
        .vehicle_detected(w_vehicle_detected)
    );

    timer_module u_timer (
        .clk(clk),
        .rst(rst),
        .timer_start(w_timer_start),
        .duration_sel(w_duration_sel),
        .timer_done(w_timer_done)
    );

    traffic_light_fsm u_fsm (
        .clk(clk),
        .rst(rst),
        .timer_done(w_timer_done),
        .sensor_detected(w_vehicle_detected),
        .emerg_active(w_emerg_active),
        .timer_start(w_timer_start),
        .duration_sel(w_duration_sel),
        .current_state(w_current_state)
    );

    light_driver u_driver (
        .clk(clk),
        .rst(rst),
        .current_state(w_current_state),
	.emerg_active(w_emerg_active),
        .led_output(led_output)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) prev_state <= 3'd0;
        else     prev_state <= w_current_state;
    end
    
    assign w_cycle_tick_pulse = (prev_state == 3'd4 && w_current_state == 3'd1);

    cycle_counter u_counter (
        .clk(clk),
        .rst(rst),
        .cycle_tick(w_cycle_tick_pulse), 
        .count_out(cycle_count)          
    );

endmodule
