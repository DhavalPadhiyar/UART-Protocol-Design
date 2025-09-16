`timescale 1ns / 1ps

module tb_uart_top;

    reg clk;
    reg rst;
    reg start;
    reg [7:0] data_in;
    wire [7:0] data_out; 
    wire done;            
    wire tx_out;          
    wire busy;

    // UART RX input is driven by TX output (loopback)
    wire rx_in;
    assign rx_in = tx_out;

    // Parameter for 9600 baud @ 50MHz
    parameter CLK_PER_BIT = 5208;

    // Instantiate uart_top
    uart_top DUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .rx_in(rx_in),
        .data_out(data_out),
        .done(done),
        .tx_out(tx_out),
        .busy(busy)
    );

    // Generate 50 MHz clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 20ns clock period
    end

    // Main stimulus
    initial begin
        // Initialization
        rst = 1;
        start = 0;
        data_in = 8'h00;

        // Reset pulse
        #100;
        rst = 0;

        // Wait before sending
        #100;

        // Send byte 0xA5
        data_in = 8'hA5;
        start = 1;
        #20;
        start = 0;

        // Wait until data is received
        wait(done);
        #(CLK_PER_BIT*20)
        

        // Display result
        $display("Time: %0t ns", $time);
        $display("Received: 0x%02X", data_out);
        if (data_out == 8'hA5)
            $display("UART Loopback Test: PASSED ?");
        else
            $display("UART Loopback Test: FAILED ?");

        #1000;
        $finish;
    end

endmodule
