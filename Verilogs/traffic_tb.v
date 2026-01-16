`timescale 1ns / 1ps

module traffic_tb;

    
    reg clk;
    reg rst;
    reg btn_emerg_raw;
    reg sensor_raw;

    
    wire [5:0] led_output;
    wire [15:0] cycle_count;

    
    traffic_top uut (
        .clk(clk), 
        .rst(rst), 
        .btn_emerg_raw(btn_emerg_raw), 
        .sensor_raw(sensor_raw), 
        .led_output(led_output), 
        .cycle_count(cycle_count)
    );

    
    always #10 clk = ~clk;

    initial begin
      
        clk = 0;
        rst = 1;
        btn_emerg_raw = 0;
        sensor_raw = 0;

        
        $dumpfile("traffic_waveform.vcd");
        $dumpvars(0, traffic_tb);

        
        #100;
        rst = 0;
        $display("System Start...");

        
        #2000; 

        
        $display("Car detected on side road!");
        sensor_raw = 1; 
        #500;
        sensor_raw = 0;
        #5000;

        $display("EMERGENCY PRESSED!");
        btn_emerg_raw = 1;
        #1000;
        btn_emerg_raw = 0; 
        
        #10000;

        $display("Simulation Finished");
        $finish;
    end
      
endmodule
