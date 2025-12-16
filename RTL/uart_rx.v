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

    reg rx_ff1, rx_ff2;// 
    always @(posedge clk) begin
        rx_ff1 <= rx;
        rx_ff2 <= rx_ff1;
    end
    wire rx_sync = rx_ff2;

    reg half_bit_wait;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_index     <= 0;
            rx_shift      <= 0;
            receiving     <= 0;
            rx_done       <= 0;
            half_bit_wait <= 0;
            rx_data       <= 0;
        end else begin
            rx_done <= 0;

            // Detect start bit
            if (!receiving && rx_sync == 0) begin
                receiving     <= 1;
                bit_index     <= 0;
                half_bit_wait <= 1;  
            end

            else if (receiving && baud_tick) begin

                // Half-bit alignment
                if (half_bit_wait) begin
                    half_bit_wait <= 0;   
                end

                // Sample data bits at center
                else if (bit_index < 8) begin
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
