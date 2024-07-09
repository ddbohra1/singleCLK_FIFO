`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2024 04:54:34 PM
// Design Name: 
// Module Name: fifo_tb
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



module FIFO_tb;

    // Inputs
    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] buf_in;

    // Outputs
    wire [7:0] fifo_cntr;
    wire [7:0] buf_out;
    wire buf_empt;
    wire buf_full;

    // Instantiate the FIFO
    FIFO uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .buf_in(buf_in),
        .fifo_cntr(fifo_cntr),
        .buf_out(buf_out),
        .buf_empt(buf_empt),
        .buf_full(buf_full)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Test procedure
    initial begin
        // Initialize inputs
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        buf_in = 0;

        // Reset the FIFO
        #10;
        rst = 0;
        #10;
        rst = 1;

       // Writing some data into the FIFO
       // Test case 1: Write until full
        //$display("Test case 1: Write until full");
        repeat (65) begin
            @(negedge clk);
            wr_en = 1;
            buf_in = buf_in + 1;
            #10;
            if (buf_full) begin
                wr_en = 0;
                //$display("FIFO is full at count: %d", fifo_cntr);
                //break;
            end
        end
        wr_en = 0;

        // Test case 2: Read until empty
        //$display("Test case 2: Read until empty");
        repeat (65) begin
            @(negedge clk);
            rd_en = 1;
            #10;
            if (buf_empt) begin
                rd_en = 0;
                //$display("FIFO is empty at count: %d", fifo_cntr);
                //break;
            end
        end
        rd_en = 0;

        // Test case 3: Mixed write and read
        //$display("Test case 3: Mixed write and read");
        repeat (32) begin
            @(negedge clk);
            wr_en = 1;
            buf_in = buf_in + 1;
            #10;
        end
        wr_en = 0;

        repeat (16) begin
            @(negedge clk);
            rd_en = 1;
            #10;
        end
        rd_en = 0;

        repeat (16) begin
            @(negedge clk);
            wr_en = 1;
            buf_in = buf_in + 1;
            #10;
        end
        wr_en = 0;

        repeat (32) begin
            @(negedge clk);
            rd_en = 1;
            #10;
        end
        rd_en = 0;
        // Finish simulation
        #50;
        $stop;
    end

endmodule
