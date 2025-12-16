module uart_rx (
    input  wire clk,
    input  wire rst,
    input  wire baud_tick,
    input  wire rx,
    output reg  [7:0] rx_data,
    output reg  rx_done // this flag tells the tx that the data transmission is done or not.
);

    reg [3:0] bit_index;// it will keep track of data 
    reg [7:0] rx_shift; // buffer shift register to recreate the frame recived 
    reg       receiving; // this flag is for indiacating that data is being recived 
    reg       rx_sync; // for synchronised rx data reception

    // Synchronize RX to clk to insure reliability 
    always @(posedge clk) begin
        rx_sync <= rx;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin // when trigger  reset then it will make the reciver to its initial condition it will make bit index , rx_shift register , receving flag , rx_done acknowledegement flag and data line to 0.
            bit_index <= 0;
            rx_shift  <= 0;
            receiving <= 0;
            rx_done   <= 0;
            rx_data   <= 0;
        end else begin // by default rx done will be zero 
            rx_done <= 0;

            //when reciving flag is not set and and checking the start bit with synchronous rx line then it will start the reciving data by setting reciving flag  and keep track of the bit using bit index register
            if (!receiving && rx_sync == 0) begin
                receiving <= 1;
                bit_index <= 0;
            end

            // while reciving flag is set and baud tick occure recive data one by one bit and shift it to the buffer rx register and will increment the bit index
            else if (receiving && baud_tick) begin
                if (bit_index < 8) begin
                    rx_shift[bit_index] <= rx_sync;
                    bit_index <= bit_index + 1;
                end
                // when all 8 bits are recived it will release the reciving flag and send all the ddata to rx data register and will set the rx done flag 1 that gives acknowledgment to transmitter device that data is transmitted succesfully 
                else begin
                    receiving <= 0;
                    rx_data   <= rx_shift;
                    rx_done   <= 1;
                end
            end
        end
    end

endmodule



