`timescale 1ns/1ps

module tb_baud_gen;

    reg clk;
    reg rst;
    wire baud_tick;

    // Instantiate baud generator
    baud_gen #(
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(9600)
    ) dut (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

    // 100 MHz clock → 10 ns period
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #100;
        rst = 0;

        // Run simulation
        #2_000_000;
        $stop;
    end

endmodule
