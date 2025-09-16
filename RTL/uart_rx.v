module uart_rx (clk,rst, rx,data,done);
  
   input clk,rst,rx;                             
   output reg [7:0] data;
   output reg done ;   
   
parameter CLK_PER_BIT = 5208; // Same as in uart_tx to match baud rate

reg [12:0] clk_count = 0;    
reg [3:0] bit_index = 0;     
reg [7:0] rx_shift = 0;      
reg busy = 0;               

always @(posedge clk or posedge rst) begin
    if (rst) begin
        clk_count <= 0;
        bit_index <= 0;
        busy <= 0;
        data <= 0;
        done <= 0;
    end 
    
    else begin
        done <= 0; // Clear done by default

        if (!busy) begin
            // Wait for start bit
            if (rx == 0) begin
                busy <= 1;
                clk_count <= CLK_PER_BIT >> 1; // Center sample of start bit
                bit_index <= 0;
            end
        end
        
         else begin
            clk_count <= clk_count + 1;
            if (clk_count == CLK_PER_BIT - 1) begin
                clk_count <= 0;
                bit_index <= bit_index + 1;

                if (bit_index == 0) begin
                    // Start bit sampled, do nothing, move to first data bit
                end
               
                else if (bit_index >= 1 && bit_index <= 8) begin
                    // Receiving data bits 1 to 8 
                    rx_shift <= {rx, rx_shift[7:1]}; // LSB first
                end 
                
                else if (bit_index == 9) begin
                    // Stop bit: finish reception
                    busy <= 0;
                    data <= rx_shift;
                    done <= 1; // Data is ready
                end
            end
        end
    end
end
endmodule
