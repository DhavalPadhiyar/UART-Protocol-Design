module uart_top (
    input  wire clk,        // FPGA clock (e.g. 100 MHz)
    input  wire rst,        // Active-high reset

    // Transmitter interface
    input  wire start,      // Start transmission
    input  wire [7:0] data_in,
    output wire tx,         // UART TX pin
    output wire tx_busy,

    // Receiver interface
    input  wire rx,         // UART RX pin
    output wire [7:0] rx_data,
    output wire rx_done
);

    wire baud_tick;

    
    baud_gen #(
        .CLK_FREQ(100_000_000), // change if needed
        .BAUD_RATE(9600)
    ) baud_inst (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

   
    uart_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .start(start),
        .data_in(data_in),
        .tx(tx),
        .busy(tx_busy)
    );

  
    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

endmodule
