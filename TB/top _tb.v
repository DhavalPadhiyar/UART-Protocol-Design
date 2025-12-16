`timescale 1ns/1ps

module tb_uart_top;

    reg clk;
    reg rst;
    reg start;
    reg [7:0] data_in;
    wire tx;
    wire rx;
    wire [7:0] rx_data;
    wire rx_done;
    wire tx_busy;

    assign rx = tx; // LOOPBACK

    uart_top dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .tx(tx),
        .tx_busy(tx_busy),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        data_in = 8'h00;

        #100;
        rst = 0;

        #200;
        data_in = 8'h55;
        start = 1;
        #10 start = 0;

        wait(rx_done);
        #100;

        data_in = 8'hAA;
        start = 1;
        #10 start = 0;

        #1_000_000;
        $stop;
    end

endmodule

