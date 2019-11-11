//------------------------------
// Module name: perf_enc_stall.v
// Function: This is the top module of the performance counter
// It instantiates the all related performance counter
// Creator:  Bony Chen
// Version:  1.0
// Date:     26 Nov 2015
//------------------------------

`include "or1200_defines.v"

module perf_enc_stall (			 
						 clk, rst, en,
						 perf_start, perf_end,
						 delayed_ack_load, delayed_ack_store,
						 load_enc_stall_cycle, store_enc_stall_cycle
						 );

   input 			clk;		// clock signal
   input 			rst;
   input 			en;

   input 			perf_start;
   input 			perf_end;
   
   input 			delayed_ack_load;
   input 			delayed_ack_store;   
   output reg [31:0] 		load_enc_stall_cycle;
   output reg [31:0] 		store_enc_stall_cycle;

   reg [31:0] 			load_stall_counter;
   reg [31:0] 			store_stall_counter;   

   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	load_enc_stall_cycle <= 32'b0;
	store_enc_stall_cycle <= 32'b0;	
	load_stall_counter <= 32'b0;
	store_stall_counter <= 32'b0;
     end
     else begin
	if (en) begin
	   if (delayed_ack_load)
	     load_stall_counter <= load_stall_counter + 1;
	   else if (delayed_ack_store)
	     store_stall_counter <= store_stall_counter + 1;	   
	end
	
	if (perf_start) begin
	   load_enc_stall_cycle <= 32'b0;
	   store_enc_stall_cycle <= 32'b0;	
	   load_stall_counter <= 32'b0;
	   store_stall_counter <= 32'b0;
	end
	
	if (perf_end) begin
	   load_enc_stall_cycle <= load_stall_counter;
	   store_enc_stall_cycle <= store_stall_counter;	
	end
     end	       
endmodule

