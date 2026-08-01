`timescale 1ns/1ps

module uart_tb;

//----------------------------------------------------
// Signals
//----------------------------------------------------

reg clk;
reg rst;

reg tx_start;
reg [7:0] tx_data;

wire tx;
wire rx;

wire [7:0] rx_data;

wire tx_busy;
wire tx_done;
wire rx_done;

// Loopback
assign rx = tx;

//----------------------------------------------------
// DUT
//----------------------------------------------------

uart_top #(

    .CLOCK_FREQ(20),
    .BAUD_RATE(2)

)

DUT(

    .clk(clk),
    .rst(rst),

    .tx_start(tx_start),
    .tx_data(tx_data),

    .rx(rx),

    .tx(tx),

    .rx_data(rx_data),

    .tx_busy(tx_busy),
    .tx_done(tx_done),

    .rx_done(rx_done)

);

//----------------------------------------------------
// Clock Generation
//----------------------------------------------------

initial
begin
    clk = 0;
    forever #10 clk = ~clk;
end

//----------------------------------------------------
// Main Test Sequence
//----------------------------------------------------

integer i;

initial
begin

    rst = 1;
    tx_start = 0;
    tx_data = 8'h00;

    #100;
    rst = 0;

    //------------------------------------------------
    // TEST 1
    //------------------------------------------------

    $display("\n========== TEST 1 : RESET ==========");

    if(tx == 1'b1)
        $display("PASS : TX Idle after Reset");
    else
        $display("FAIL : TX not Idle");

    //------------------------------------------------
    // TEST 2
    //------------------------------------------------

    $display("\n========== TEST 2 : SINGLE BYTE ==========");

    send_byte(8'h55);
    //------------------------------------------------
    // TEST 3
    //------------------------------------------------

    $display("\n========== TEST 3 : MULTIPLE BYTES ==========");

    send_byte(8'h11);
    send_byte(8'h22);
    send_byte(8'h33);
    send_byte(8'h44);
    send_byte(8'h55);

    //------------------------------------------------
    // TEST 4
    //------------------------------------------------

    $display("\n========== TEST 4 : ALL ZEROS ==========");

    send_byte(8'h00);

    //------------------------------------------------
    // TEST 5
    //------------------------------------------------

    $display("\n========== TEST 5 : ALL ONES ==========");

    send_byte(8'hFF);

    //------------------------------------------------
    // TEST 6
    //------------------------------------------------

    $display("\n========== TEST 6 : ALTERNATING ==========");

    send_byte(8'hAA);
    send_byte(8'h55);

    //------------------------------------------------
    // TEST 7
    //------------------------------------------------



    //------------------------------------------------
    // TEST 9
    //------------------------------------------------

    $display("\n========== TEST 9 : BACK TO BACK ==========");

    send_byte(8'h10);
    send_byte(8'h20);
    send_byte(8'h30);
    send_byte(8'h40);

    //------------------------------------------------
    // TEST 10
    //------------------------------------------------

    $display("\n========== TEST 10 : MAX VALUE ==========");

    send_byte(8'hFF);

    //------------------------------------------------
    // TEST 11
    //------------------------------------------------

    $display("\n========== TEST 11 : MIN VALUE ==========");

    send_byte(8'h00);

    //------------------------------------------------
    // TEST 12
    //------------------------------------------------

    $display("\n========== TEST 12 : WALKING ONE ==========");

    send_byte(8'b00000001);
    send_byte(8'b00000010);
    send_byte(8'b00000100);
    send_byte(8'b00001000);
    send_byte(8'b00010000);
    send_byte(8'b00100000);
    send_byte(8'b01000000);
    send_byte(8'b10000000);

    //------------------------------------------------
    // TEST 13
    //------------------------------------------------

    $display("\n========== TEST 13 : WALKING ZERO ==========");

    send_byte(8'b11111110);
    send_byte(8'b11111101);
    send_byte(8'b11111011);
    send_byte(8'b11110111);
    send_byte(8'b11101111);
    send_byte(8'b11011111);
    send_byte(8'b10111111);
    send_byte(8'b01111111);

    //------------------------------------------------
    // TEST 14
    //------------------------------------------------

    $display("\n========== TEST 14 : LONG STRESS ==========");

    for(i=0;i<100;i=i+1)
        send_byte($random);

    //------------------------------------------------
    // FINISH
    //------------------------------------------------


    #100000;

    $display("\n=======================================");
    $display("ALL TEST CASES COMPLETED");
    $display("=======================================\n");
    
    $finish;

end

//----------------------------------------------------
// Send Task
//----------------------------------------------------

task send_byte;

input [7:0] data;

begin

    @(posedge clk);

    tx_data  = data;
    tx_start = 1'b1;

    @(posedge clk);

    tx_start = 1'b0;

    wait(tx_done);

    @(posedge clk);

end

endtask

//----------------------------------------------------
// Monitor
//----------------------------------------------------

always @(posedge clk)
begin

    if(rx_done)
    begin

        if(rx_data == tx_data)
            $display("PASS  Time=%0t  Data=%h", $time, rx_data);

        else
            $display("FAIL  Time=%0t  Expected=%h  Received=%h",
                     $time, tx_data, rx_data);

    end

end

//----------------------------------------------------
// Busy Monitor
//----------------------------------------------------

always @(posedge clk)
begin

    if(tx_busy)
        $display("Time=%0t  TX Busy", $time);

end

endmodule
