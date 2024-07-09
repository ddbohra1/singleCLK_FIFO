`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: dixit_bohra
// 
// Create Date: 07/09/2024 04:16:43 PM
// Design Name: 
// Module Name: FIFO
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

// Single Clock FIFO

module FIFO(
    input clk,rst,wr_en,rd_en,
    input [7:0] buf_in, // input to buffer 8bit
    output reg [7:0] fifo_cntr, // since there are 64 locations but it have to go one higher lcoation so 8bits are taken
    output reg [7:0] buf_out, // output buffer  8bit
    output reg buf_empt, buf_full   // flag signals

    );
    
    //reg [6:0] fifo_cntr;
    reg [3:0] rd_pntr, wr_pntr;
    reg [7:0] buf_mem [63:0];
    
    always@(fifo_cntr)
    begin
        buf_empt = (fifo_cntr == 0); // when fifo_counter is zero means nothing in the fifo so EMPTY (buf_empt) goes high means nobody can read
        buf_full = (fifo_cntr == 64); // when FIFO get full then buf_full flag become HIGH. means no body can write in this condition.
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst) // ASynchronous reset
            fifo_cntr <=0;
        else if ((!buf_full && wr_en) && (!buf_empt && rd_en))
            fifo_cntr <= fifo_cntr;
        else if (!buf_full && wr_en) // writing into buffer so 
            fifo_cntr <= fifo_cntr + 1; // counter goes high
        else if (!buf_empt && rd_en) // reading from FIFO
            fifo_cntr <= fifo_cntr - 1; // so couner goes reduced by one.
        else
            fifo_cntr <= fifo_cntr;     
    end
    
    always@(posedge clk or posedge rst)  
    begin
        if (rst)
            buf_out <=0;
        else begin
            if(rd_en && !buf_empt)
                buf_out <= buf_mem[rd_pntr];
            else
                buf_out <= buf_out;
         end
    end
    
    always@(posedge clk)
    begin
        if(wr_en && !buf_full)
            buf_mem[wr_pntr] <= buf_in;
        else
            buf_mem[wr_pntr] <= buf_mem[wr_pntr];
         
    end
    
    //pointer management 
    always@(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            wr_pntr <= 0;
            rd_pntr <= 0;
        end
        else begin //managing head pointer(i.e. Write pointer)
            if(!buf_full && wr_en)
                wr_pntr <= wr_pntr+1;
            else
                wr_pntr <= wr_pntr;
            
            // Managing the Read Pointer (i.e. Tail Pointer)    
            if( !buf_empt && rd_en)
                rd_pntr <= rd_pntr+1;
            else
                rd_pntr <= rd_pntr;
        end
        
    end
    
    
    
endmodule
