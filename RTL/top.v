 module uart_top (
   input clk,           
   input rst,          
   input start,          
   input [7:0] data_in,  
   input rx_in,          
   output [7:0] data_out, 
   output done,         
   output tx_out,        
   output busy         
);

   // UART Transmitter instance
   uart_tx #(.CLK_PER_BIT(5208)) u_tx (
       .clk(clk),
       .rst(rst),
       .data_in(data_in),
       .start(start),
       .tx(tx_out),    // output goes to top module's tx_out pin
       .busy(busy)
   );

   // UART Receiver instance
   uart_rx #(.CLK_PER_BIT(5208)) u_rx (
       .clk(clk),
       .rst(rst),
       .rx(rx_in),     // input comes from top module's rx_in pin (external source)
       .data(data_out),
       .done(done)
   );

endmodule
