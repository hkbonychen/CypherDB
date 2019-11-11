//------------------------------
// Module name: perf_ex_insn_count.v
// Function: This is the top module of the performance counter
// It instantiates the all related performance counter
// Creator:  Bony Chen
// Version:  1.0
// Date:     26 Nov 2015
//------------------------------

`include "or1200_defines.v"

module perf_ex_insn_count (			 
						 clk, rst, en,
						 perf_start, perf_end,
						 id_freeze, total_count
						 );

   input 			clk;		// clock signal
   input 			rst;
   input 			en;

   input 			perf_start;
   input 			perf_end;
   input 			id_freeze;   
   output reg [63:0] 		total_count;

   reg [63:0] 			counter;   

   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	total_count <= 64'b0;	
	counter <= 64'b0;
     end
     else begin
	if (en & !id_freeze) begin
	   counter <= counter + 1;		   
	end
	
	if (perf_start) begin
	   counter <= 64'b0;
	   total_count <= 64'b0;
	end
	
	if (perf_end) begin
	   total_count <= counter;
	end
     end	       
endmodule

