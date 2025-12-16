`timescale 1ns/1ps

module tb_uart_tx;

    reg clk;
    reg rst;
    reg start;
    reg [7:0] data_in;
    wire tx;
    wire busy;
    wire baud_tick;

    baud_gen #(
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(9600)
    ) bg (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

    uart_tx dut (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .start(start),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
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
        data_in = 8'hA5;
        start = 1;
        #10;
        start = 0;

        wait(!busy);
        #500_000;
        $stop;
    end

endmodule
