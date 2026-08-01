`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2026 11:06:51
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(

    input  wire clk,
    input  wire rst,
    input  wire baud_tick,

    input  wire rx,

    output reg [7:0] rx_data,
    output reg rx_done

);

localparam IDLE  = 2'd0;
localparam START = 2'd1;
localparam DATA  = 2'd2;
localparam STOP  = 2'd3;

reg [1:0] state;
reg [7:0] shift_reg;
reg [2:0] bit_count;

always @(posedge clk)
begin

    if(rst)
    begin
        state     <= IDLE;
        bit_count <= 3'd0;
        shift_reg <= 8'd0;
        rx_data   <= 8'd0;
        rx_done   <= 1'b0;
    end

    else
    begin

        rx_done <= 1'b0;

        //--------------------------------------------------
        // Continuously watch for start bit
        //--------------------------------------------------
        if(state == IDLE)
        begin
            if(rx == 1'b0)
                state <= START;
        end

        //--------------------------------------------------
        // Remaining states move only on baud_tick
        //--------------------------------------------------
        else if(baud_tick)
        begin

            case(state)

            START:
            begin

                if(rx == 1'b0)
                begin
                    bit_count <= 3'd0;
                    state <= DATA;
                end
                else
                    state <= IDLE;

            end

            DATA:
            begin

                shift_reg[bit_count] <= rx;

                if(bit_count == 3'd7)
                    state <= STOP;
                else
                    bit_count <= bit_count + 1;

            end

            STOP:
            begin

                if(rx == 1'b1)
                begin
                    rx_data <= shift_reg;
                    rx_done <= 1'b1;
                end

                state <= IDLE;

            end

            endcase

        end

    end

end

endmodule
