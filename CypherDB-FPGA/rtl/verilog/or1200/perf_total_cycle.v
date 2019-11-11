//------------------------------
// Module name: perf_counter_top.v
// Function: This is the top module of the performance counter
// It instantiates the all related performance counter
// Creator:  Bony Chen
// Version:  1.0
// Date:     26 Nov 2015
//------------------------------

`include "or1200_defines.v"

module perf_total_cycle (			 
						 clk, rst, en,
						 perf_start, perf_end, 
						 total_cycle
						 );

   input 			clk;		// clock signal
   input 			rst;
   input 			en;

   input 			perf_start;
   input 			perf_end;
   output reg [63:0] 		total_cycle;

   reg [63:0] 			counter;   

   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	total_cycle <= 64'b0;	
	counter <= 64'b0;
     end
     else begin
	if (en) begin
	   counter <= counter + 1;		   
	end
	
	if (perf_start) begin
	   counter <= 64'b0;
	   total_cycle <= 64'b0;
	end
	
	if (perf_end) begin
	   total_cycle <= counter;
	end
     end	       
endmodule

