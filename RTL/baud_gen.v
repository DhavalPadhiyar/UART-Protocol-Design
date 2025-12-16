module baud_gen #(
    parameter CLK_FREQ  = 100_000_000, // frequency of system clock
    parameter BAUD_RATE = 9600 // this defines baud rate which we scaled 
)(
    input  wire clk,
    input  wire rst,
    output reg  baud_tick // this flag will be triggered afte each time when count becomes equal to clock required to send one bit. 
);

    localparam integer CLK_PER_BIT = CLK_FREQ / BAUD_RATE; // calculating clock cycles which are required to transmitt/recive one bit of data.
    reg [15:0] count; // to count boud ticks   
    always @(posedge clk or posedge rst) begin
        if (rst) begin // in reset state count and baud tick are 0.
            count     <= 0;
            baud_tick <= 0;
        end else begin // whenever the count will become equal to clks required to send one bit which we get from calculation it will trigger the baud_tick flag
            if (count == CLK_PER_BIT - 1) begin
                count     <= 0;
                baud_tick <= 1;
            end else begin // if the count is not equal then it will continu incrementing the count 
                count     <= count + 1;
                baud_tick <= 0;
            end
        end
    end

endmodule

