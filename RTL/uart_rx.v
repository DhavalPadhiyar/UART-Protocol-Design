module uart_rx (
    input  wire clk,
    input  wire rst,
    input  wire baud_tick,
    input  wire rx,
    output reg  [7:0] rx_data,
    output reg  rx_done
);

    reg [3:0] bit_index;
    reg [7:0] rx_shift;
    reg       receiving;
    reg       rx_sync;

    // Synchronize RX to clk (important for FPGA)
    always @(posedge clk) begin
        rx_sync <= rx;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_index <= 0;
            rx_shift  <= 0;
            receiving <= 0;
            rx_done   <= 0;
            rx_data   <= 0;
        end else begin
            rx_done <= 0; // default

            // Detect start bit (falling edge)
            if (!receiving && rx_sync == 0) begin
                receiving <= 1;
                bit_index <= 0;
            end

            // Receive data bits
            else if (receiving && baud_tick) begin
                if (bit_index < 8) begin
                    rx_shift[bit_index] <= rx_sync;
                    bit_index <= bit_index + 1;
                end
                // Stop bit
                else begin
                    receiving <= 0;
                    rx_data   <= rx_shift;
                    rx_done   <= 1;
                end
            end
        end
    end

endmodule
