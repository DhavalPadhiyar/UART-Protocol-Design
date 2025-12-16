module uart_tx (
    input  wire clk,
    input  wire rst,
    input  wire baud_tick,
    input  wire start,
    input  wire [7:0] data_in,
    output reg  tx,
    output reg  busy // flag which indicate andd tell the processor that line is busy to avoide new data from being loaded 
);

    reg [3:0] bit_index; // for tracking which bit is being transmitted and also used to keep track of data frame transmission.
    reg [9:0] tx_shift; // buffer shift register for making data frame with start and stop bit 
    
  
    always @(posedge clk or posedge rst) begin
        if (rst) begin      // when we do reset it will configure transmitter to its initial condition like tx line idle , busy flag is released , bit index is at 0 and the register contains initial value we assigned .      
            tx        <= 1'b1;
            busy      <= 1'b0;
            bit_index <= 0;
            tx_shift  <= 10'b1111111111;
        end else begin
            // forming a 8 bit frame with start and stop bit and start tranmission by making busy flag high and making bit index 0.
            if (start && !busy) begin
                tx_shift  <= {1'b1, data_in, 1'b0};
                busy      <= 1'b1;
                bit_index <= 0;
            end
            // while it is busy and baud tick triggers then it will shift next data bit over line it will send bits one by one when the condition become true 
            else if (busy && baud_tick) begin
                tx <= tx_shift[bit_index];
              // when bit index will become 9,which means all the bits of one frame get transmitted over line itwill relese the busy flag and roll off the bit index to 0 and make tx line idle.
                if (bit_index == 9) begin
                    busy      <= 0;
                    bit_index <= 0;
                    tx        <= 1'b1;
                end else begin
                    // if bit index is not 9 yet then it will increment the bit index and and shift the next data out.
                    bit_index <= bit_index + 1;
                end
            end
        end
    end

endmodule

