//------------------------------
// Module name: perf_counter_top.v
// Function: This is the top module of the performance counter
// It instantiates the all related performance counter
// Creator:  Bony Chen
// Version:  1.0
// Date:     26 Nov 2015
//------------------------------

`include "or1200_defines.v"

module perf_counter_top 
(			 
			 clk, rst, 
			 perf_start, perf_end, perf_en,
			 // input selection for performance counter and output
			 operand_in, perf_cntr_out,
			 // input condition for counting insn executed
			 id_freeze,
			 // perf counters inputs from dc_fsm
			 // output the decoded perf counter start and end pulses
			 // to dc_fsm
			 dcfsm_perf_dcache_miss_count, dcache_miss_total_count,
			 dcfsm_perf_dcache_hit_count, dcache_hit_total_count,
			 dcfsm_perf_dcache_wb_count, dcache_wb_total_count,
			 dcfsm_perf_dcache_flush_count, dcache_flush_total_count,
			 dcfsm_perf_seedcache_access_count, seedcache_access_total_count,
			 dcfsm_perf_seedcache_miss_count, seedcache_miss_total_count,
			 dcfsm_perf_seedcache_hit_count, seedcache_hit_total_count,
			 dcfsm_perf_seedcache_wb_count, seedcache_wb_total_count,
			 dcfsm_perf_en, dcfsm_perf_start,
			 // input the signal indicating the delay caused by the
			 // data en-/decryption
			 delayed_ack_load, delayed_ack_store
			 );

   input 			clk;		// clock signal
   input 			rst;

   input 			perf_start;
   input 			perf_end;
   input 			perf_en;   

   // I/O port for all performance counter
   input [15:0] 		operand_in;
   output [31:0] 		perf_cntr_out;

   // input port for insn executed count condition
   input 			id_freeze;

   input [63:0] 		dcfsm_perf_dcache_miss_count;
   input [63:0] 		dcfsm_perf_dcache_hit_count;
   input [63:0] 		dcfsm_perf_dcache_wb_count;
   input [63:0] 		dcfsm_perf_dcache_flush_count;
   input [63:0] 		dcfsm_perf_seedcache_access_count;
   input [63:0] 		dcfsm_perf_seedcache_miss_count;
   input [63:0] 		dcfsm_perf_seedcache_hit_count;
   input [63:0] 		dcfsm_perf_seedcache_wb_count;

   output [63:0] 			dcache_miss_total_count;
   output [63:0] 			dcache_hit_total_count;   
   output [63:0] 			dcache_wb_total_count;   
   output [63:0] 			dcache_flush_total_count;
   output [63:0] 			seedcache_access_total_count;   
   output [63:0] 			seedcache_miss_total_count;   
   output [63:0] 			seedcache_hit_total_count;   
   output [63:0] 			seedcache_wb_total_count;
   
   output 			dcfsm_perf_en;
   output 			dcfsm_perf_start;

   // input the signal indicating the delay caused by the
   // data en-/decryption 
   input 			delayed_ack_load;
   input 			delayed_ack_store;
   
   //---------------------total execution cycles-------------------------
   
   // control signal
   wire 			total_cycle_en; 
   wire [63:0] 			total_cycle;
   
   //assign total_cycle_en = operand_in[0] ? perf_en : 1'b0;   
	assign total_cycle_en = perf_en;

   perf_total_cycle
     perf_total_cycle (
		       .clk(clk),
		       .rst(rst),
		       .en(total_cycle_en),
		       .perf_start(perf_start),
		       .perf_end(perf_end),
		       .total_cycle(total_cycle)
		       );

   //------------------total num of executed insn--------------------
   
   // control signal 
   wire 			ex_insn_en;
   wire [63:0] 			total_ex_insn;

   //assign ex_insn_en = operand_in[1] ? perf_en : 1'b0;
	assign ex_insn_en = perf_en;

   perf_ex_insn_count
     perf_ex_insn_count(
			.clk(clk),
			.rst(rst),
			.en(ex_insn_en),
			.perf_start(perf_start),
			.perf_end(perf_end),
			.id_freeze(id_freeze),
			.total_count(total_ex_insn)
		       );

   //-------------------data cache and seed cache-----------------
   // comment: the performance counter of data cache and seed cache
   // are in the file or1200_dc_fsm.v
   // It is because the performance counter is easier to implement within
   // the state mache, so it is better to stay in that file
   // But the final output is registered in this file with the performance
   // counters as an input from or1200_dc_fsm.v

   reg [63:0] 			dcache_miss_total_count;
   reg [63:0] 			dcache_hit_total_count;   
   reg [63:0] 			dcache_wb_total_count;   
   reg [63:0] 			dcache_flush_total_count;
   reg [63:0] 			seedcache_access_total_count;   
   reg [63:0] 			seedcache_miss_total_count;   
   reg [63:0] 			seedcache_hit_total_count;   
   reg [63:0] 			seedcache_wb_total_count;

   //assign dcfsm_perf_en = operand_in[2] ? perf_en : 1'b0;
	assign dcfsm_perf_en = perf_en;
   assign dcfsm_perf_start = perf_start;
   
   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	dcache_miss_total_count <= 64'b0;
	dcache_hit_total_count <= 64'b0;	
	dcache_wb_total_count <= 64'b0;
	dcache_flush_total_count <= 64'b0;
	seedcache_access_total_count <= 64'b0;
	seedcache_miss_total_count <= 64'b0;
	seedcache_hit_total_count <= 64'b0;
	seedcache_wb_total_count <= 64'b0;
     end
     else begin
	if (perf_end) begin
	   dcache_miss_total_count <= dcfsm_perf_dcache_miss_count;
	   dcache_hit_total_count <= dcfsm_perf_dcache_hit_count;	
	   dcache_wb_total_count <= dcfsm_perf_dcache_wb_count;
	   dcache_flush_total_count <= dcfsm_perf_dcache_flush_count;
	   seedcache_access_total_count <= dcfsm_perf_seedcache_access_count;
	   seedcache_miss_total_count <= dcfsm_perf_seedcache_miss_count;
	   seedcache_hit_total_count <= dcfsm_perf_seedcache_hit_count;
	   seedcache_wb_total_count <= dcfsm_perf_seedcache_wb_count;
	end
	 if (perf_start) begin
	    dcache_miss_total_count <= 64'b0;
	    dcache_hit_total_count <= 64'b0;	
	    dcache_wb_total_count <= 64'b0;
	    dcache_flush_total_count <= 64'b0;
	    seedcache_access_total_count <= 64'b0;
	    seedcache_miss_total_count <= 64'b0;
	    seedcache_hit_total_count <= 64'b0;
	    seedcache_wb_total_count <= 64'b0;
	 end
     end 

    //-----------delay caused by the en-/decryption stall-----------

   // control signal
   wire 			enc_stall_en;
   wire [31:0] 			load_enc_stall_cycle;
   wire [31:0] 			store_enc_stall_cycle;   
   
 //  assign enc_stall_en = operand_in[3] ? perf_en : 1'b0;   
	assign enc_stall_en = perf_en;
   
   perf_enc_stall
     perf_enc_stall (
		     .clk(clk),
		     .rst(rst),
		     .en(enc_stall_en),
		     .perf_start(perf_start),
		     .perf_end(perf_end),
		     .delayed_ack_load(delayed_ack_load),
		     .delayed_ack_store(delayed_ack_store),
		     .load_enc_stall_cycle(load_enc_stall_cycle),
		     .store_enc_stall_cycle(store_enc_stall_cycle)
		     );   
   
endmodule

