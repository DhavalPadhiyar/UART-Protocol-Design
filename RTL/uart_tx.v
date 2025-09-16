module uart_tx( clk,rst,data_in,start,tx,busy);

    input clk,start,rst;
    input [7:0] data_in;
    output reg tx;
    output reg busy;

parameter CLK_PER_BIT = 5208;

reg [12:0] clk_count = 0;
reg [3:0] bit_index = 0;
reg [9:0] tx_shift = 10'b1111111111; // stop, data, start bits


always @(posedge clk or posedge rst) begin
    if (rst) begin
        clk_count <= 0;
        bit_index <= 0;
        tx <= 1; // idle
        busy <= 0;
        tx_shift <= 10'b1111111111;
    end else begin
        

        if (!busy && start ) begin
            // Load frame: start(0), data_in, stop(1)
            tx_shift <= {1'b1, data_in, 1'b0};
            busy <= 1;
            clk_count <= 0;
            bit_index <= 0;
            
        end else if (busy) begin
            clk_count <= clk_count + 1;
            
            if (clk_count == CLK_PER_BIT - 1) begin
                clk_count <= 0;
                tx <= tx_shift[bit_index];
                
           if (bit_index == 9) begin
            busy <= 0;
            tx <= 1;
          end else begin
             bit_index <= bit_index + 1;
                  
                  end

                end
            end
        end
    end

endmodule