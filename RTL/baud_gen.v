module baud_gen #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 9600
)(
    input  wire clk,
    input  wire rst,
    output reg  baud_tick
);

    localparam integer CLK_PER_BIT = CLK_FREQ / BAUD_RATE;
    reg [15:0] count;   
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count     <= 0;
            baud_tick <= 0;
        end else begin
            if (count == CLK_PER_BIT - 1) begin
                count     <= 0;
                baud_tick <= 1;
            end else begin
                count     <= count + 1;
                baud_tick <= 0;
            end
        end
    end

endmodule
