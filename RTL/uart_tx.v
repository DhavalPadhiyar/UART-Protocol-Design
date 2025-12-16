module uart_tx (
    input  wire clk,
    input  wire rst,
    input  wire baud_tick,
    input  wire start,
    input  wire [7:0] data_in,
    output reg  tx,
    output reg  busy
);

    reg [3:0] bit_index;
    reg [9:0] tx_shift;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx        <= 1'b1;
            busy      <= 1'b0;
            bit_index <= 0;
            tx_shift  <= 10'b1111111111;
        end else begin

            if (start && !busy) begin
                tx_shift  <= {1'b1, data_in, 1'b0};
                busy      <= 1'b1;
                bit_index <= 0;
            end

            else if (busy && baud_tick) begin
                tx <= tx_shift[bit_index];

                if (bit_index == 9) begin
                    busy      <= 0;
                    bit_index <= 0;
                    tx        <= 1'b1;
                end else begin
                    bit_index <= bit_index + 1;
                end
            end
        end
    end

endmodule
