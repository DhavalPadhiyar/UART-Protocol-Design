`timescale 1ns/1ps

module tb_uart_rx;
  parameter CLK_PER_BIT = 5208;
    reg clk = 0;
    reg rst = 1;
    reg rx = 1;           // idle high
    wire [7:0] data;
    wire done;

    // Instantiate uart_rx
    uart_rx #(.CLK_PER_BIT(5208)) uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data(data),
        .done(done)
    );

      initial begin
          clk = 0;
          forever #10 clk = ~clk;  
      end

    initial begin
        rst = 1;
        #100;              // short reset pulse
        rst = 0;

        #100;           // wait some time before sending

        send_uart_byte(8'hA5); // example byte: 10100101

        #200000;           

        $display("Received data: %02X", data);
        $finish;
    end

    task send_uart_byte(input [7:0] byte);
        integer i;
        begin
            // Start bit
            rx <= 0;
            #(CLK_PER_BIT * 20);

            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx <= byte[i];
                #(CLK_PER_BIT * 20);
            end

            // Stop bit
            rx <= 1;
            #(CLK_PER_BIT * 20);

            // Extra time after frame
            #(CLK_PER_BIT * 40);
        end
    endtask

endmodule

