`timescale 1ns / 1ps

module uart_rx_tb;

    // Testbench signals
    reg clk;
    reg rst;
    reg baud_tick;
    reg rx;
    wire [7:0] rx_data;
    wire rx_done;

    // Instantiate DUT
    uart_rx uut (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // Clock generation: 100 MHz
    always #5 clk = ~clk;

    // Task to send one UART byte
    task send_uart_byte;
        input [7:0] data;
        integer i;
        begin
            // Start bit
            rx = 0;
            #100;
            baud_tick = 1; #10; baud_tick = 0;

            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #100;
                baud_tick = 1; #10; baud_tick = 0;
            end

            // Stop bit
            rx = 1;
            #100;
            baud_tick = 1; #10; baud_tick = 0;
        end
    endtask

    // Test sequence
    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        baud_tick = 0;
        rx = 1; // idle state

        // Reset pulse
        #50;
        rst = 0;

        // Send byte 0x55
        #100;
        send_uart_byte(8'h55);

        // Wait for reception
        #500;

       
        $finish;
    end

endmodule

