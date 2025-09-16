`timescale 1ns/1ps

module tb_uart_tx;

    reg clk;
    reg rst ;
    reg start;
    reg [7:0] data_in =  8'hA5; 
    wire tx;
    wire busy;

    // Instantiate your uart_tx module
    uart_tx DUT (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .start(start),
        .tx(tx),
        .busy(busy)
    );

    
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  
    end

   initial begin
    // Initial state
    rst = 1;
    start = 0;
    #100;
   
   
    rst = 0;

    
    #50;

    // Trigger transmission
    start = 1;
    #20;           
    start = 0;     

    // Wait till ytransmission finish
    wait (busy == 0);

    #1000;         // idle state
    $display("Simulation finished at time %0t", $time);
    $finish;
end
endmodule
