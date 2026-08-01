`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2026 11:02:59
// Design Name: 
// Module Name: Baud_Rate_Generator
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


module Baud_Rate_Generator #(

    parameter CLOCK_FREQ = 20,
    parameter BAUD_RATE  = 2
)
(
    input  wire clk,
    input  wire rst,

    output reg baud_tick
);

localparam BAUD_COUNT = CLOCK_FREQ / BAUD_RATE;

reg [15:0] counter;

always @(posedge clk)
begin

    if (rst)
    begin
        counter   <= 0;
        baud_tick <= 0;
    end

    else
    begin

        if(counter == BAUD_COUNT-1)
        begin
            counter   <= 0;
            baud_tick <= 1;
        end

        else
        begin
            counter   <= counter + 1;
            baud_tick <= 0;
        end

    end

end

endmodule


