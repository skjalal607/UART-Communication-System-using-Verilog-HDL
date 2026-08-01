`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2026 11:05:20
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(

    input  wire clk,
    input  wire rst,
    input  wire baud_tick,

    input  wire tx_start,
    input  wire [7:0] tx_data,

    output reg tx,
    output reg tx_busy,
    output reg tx_done

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
        tx        <= 1'b1;
        tx_busy   <= 1'b0;
        tx_done   <= 1'b0;
        shift_reg <= 8'd0;
        bit_count <= 3'd0;
    end

    else
    begin

        tx_done <= 1'b0;

        //--------------------------------------------------
        // Capture tx_start immediately (don't wait for baud)
        //--------------------------------------------------
        if(state == IDLE)
        begin
            tx <= 1'b1;
            tx_busy <= 1'b0;

            if(tx_start)
            begin
                shift_reg <= tx_data;
                bit_count <= 3'd0;
                tx_busy   <= 1'b1;
                state     <= START;
            end
        end

        //--------------------------------------------------
        // Remaining states advance only on baud_tick
        //--------------------------------------------------
        else if(baud_tick)
        begin

            case(state)

            START:
            begin
                tx <= 1'b0;
                state <= DATA;
            end

            DATA:
            begin

                tx <= shift_reg[0];
                shift_reg <= shift_reg >> 1;

                if(bit_count == 3'd7)
                    state <= STOP;
                else
                    bit_count <= bit_count + 1;

            end

            STOP:
            begin

                tx <= 1'b1;
                tx_busy <= 1'b0;
                tx_done <= 1'b1;
                state <= IDLE;

            end

            endcase

        end

    end

end

endmodule
