`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2026 11:07:43
// Design Name: 
// Module Name: uart_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_top #

(
    parameter CLOCK_FREQ = 50000000,
    parameter BAUD_RATE  = 9600
)

(

    input wire clk,
    input wire rst,

    input wire tx_start,
    input wire [7:0] tx_data,

    input wire rx,

    output wire tx,
    output wire [7:0] rx_data,

    output wire tx_busy,
    output wire tx_done,

    output wire rx_done

);

wire baud_tick;

/////////////////////////////////////////////////
// Baud Generator
/////////////////////////////////////////////////

Baud_Rate_Generator #

(

    .CLOCK_FREQ(CLOCK_FREQ),
    .BAUD_RATE(BAUD_RATE)

)

baud_gen

(

    .clk(clk),
    .rst(rst),

    .baud_tick(baud_tick)

);

/////////////////////////////////////////////////
// UART Transmitter
/////////////////////////////////////////////////

uart_tx transmitter

(

    .clk(clk),
    .rst(rst),

    .baud_tick(baud_tick),

    .tx_start(tx_start),
    .tx_data(tx_data),

    .tx(tx),

    .tx_busy(tx_busy),
    .tx_done(tx_done)

);

/////////////////////////////////////////////////
// UART Receiver
/////////////////////////////////////////////////

uart_rx receiver

(

    .clk(clk),
    .rst(rst),

    .baud_tick(baud_tick),

    .rx(rx),

    .rx_data(rx_data),

    .rx_done(rx_done)

);

endmodule
