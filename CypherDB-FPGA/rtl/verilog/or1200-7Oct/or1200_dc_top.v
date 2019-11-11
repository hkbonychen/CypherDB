//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's Data Cache top level                               ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://opencores.org/project,or1k                           ////
////                                                              ////
////  Description                                                 ////
////  Instantiation of all DC blocks.                             ////
////                                                              ////
////  To Do:                                                      ////
////   - Test error during line read or write                     ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////      - Julius Baxter, julius@opencores.org                   ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000, 2010 Authors and OPENCORES.ORG           ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
//
// $Log: or1200_dc_top.v,v $
// Revision 2.0  2010/06/30 11:00:00  ORSoC
// Minor update: 
// Bugs fixed. 
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

//
// Data cache
//
module or1200_dc_top(
		     // Rst, clk and clock control
		     aes_clk, clk, rst,

		     // virtual address output from or1200
		     dcpu_vadr,

		     // External i/f
		     dcsb_dat_o, dcsb_adr_o, dcsb_cyc_o, dcsb_stb_o, dcsb_we_o, dcsb_sel_o, 
		     dcsb_cab_o, dcsb_dat_i, dcsb_ack_i, dcsb_err_i,

		     // Internal i/f
		     dc_en,
		     dcqmem_adr_i, dcqmem_cycstb_i, dcqmem_ci_i,
		     dcqmem_we_i, dcqmem_sel_i, dcqmem_tag_i, dcqmem_dat_i,
		     dcqmem_dat_o, dcqmem_ack_o, dcqmem_rty_o, dcqmem_err_o, dcqmem_tag_o,

		     dc_no_writethrough,

`ifdef OR1200_BIST
		     // RAM BIST
		     mbist_si_i, mbist_so_o, mbist_ctrl_i,
`endif

		     // SPRs
		     spr_cs, spr_write, spr_dat_i, spr_addr, mtspr_dc_done,

		     // control signal to cl enc module		    		    
		     secure_exec, stack_top, heap_top
		     );

   parameter dw = `OR1200_OPERAND_WIDTH;
   parameter aw = `OR1200_OPERAND_WIDTH;
   
   //
   // I/O
   //

   //
   // Clock and reset
   //
   input aes_clk;   
   input				clk;
   input				rst;

   // virtual address from cpu
   input [31:0] 			dcpu_vadr;

   //
   // External I/F
   //
   output [dw-1:0] 			dcsb_dat_o;
   output [31:0] 			dcsb_adr_o;
   output				dcsb_cyc_o;
   output				dcsb_stb_o;
   output				dcsb_we_o;
   output [3:0] 			dcsb_sel_o;
   output				dcsb_cab_o;
   input [dw-1:0] 			dcsb_dat_i;
   input				dcsb_ack_i;
   input				dcsb_err_i;

   //
   // Internal I/F
   //
   input				dc_en;
   input [31:0] 			dcqmem_adr_i;
   input				dcqmem_cycstb_i;
   input				dcqmem_ci_i;
   input				dcqmem_we_i;
   input [3:0] 				dcqmem_sel_i;
   input [3:0] 				dcqmem_tag_i;
   input [dw-1:0] 			dcqmem_dat_i;
   output [dw-1:0] 			dcqmem_dat_o;
   output				dcqmem_ack_o;
   output				dcqmem_rty_o;
   output				dcqmem_err_o;
   output [3:0] 			dcqmem_tag_o;

   input 				dc_no_writethrough;
   
`ifdef OR1200_BIST
   //
   // RAM BIST
   //
   input 				mbist_si_i;
   input [`OR1200_MBIST_CTRL_WIDTH - 1:0] mbist_ctrl_i;
   output 				  mbist_so_o;
`endif

   //
   // SPR access
   //
   input 				  spr_cs;
   input 				  spr_write;
   input [31:0] 			  spr_dat_i;
   input [aw-1:0] 			  spr_addr;
   output 				  mtspr_dc_done;

   // control signal to cl enc module				  
   input 				  secure_exec;				  
   input [31:0] 			  stack_top;
   input [31:0] 			  heap_top;   
				  

`ifdef OR1200_NO_DC

   // Bypass cache

   // IF to external memory
   assign dcsb_dat_o = dcqmem_dat_i;
   assign dcsb_adr_o = dcqmem_adr_i;
   assign dcsb_cyc_o = dcqmem_cycstb_i;
   assign dcsb_stb_o = dcqmem_cycstb_i;
   assign dcsb_we_o = dcqmem_we_i;
   assign dcsb_sel_o = dcqmem_sel_i;
   assign dcsb_cab_o = 1'b0;

   // IF to internal memory
   assign dcqmem_dat_o = dcsb_dat_i;
   assign dcqmem_ack_o = dcsb_ack_i;
   assign dcqmem_err_o = dcsb_err_i;   
   assign dcqmem_rty_o = ~dcqmem_ack_o;
   assign dcqmem_tag_o = dcqmem_err_o ? `OR1200_DTAG_BE : dcqmem_tag_i;

   assign mtspr_dc_done = 1'b1;

`else   
   
   //
   // Internal wires and regs
   //
   wire 				  tag_v;
   wire [`OR1200_DCTAG_W-2:0] 		  tag;
   wire 				  dirty;
   wire 				  secure_bit;   
   wire [dw-1:0] 			  to_dcram;
   wire [dw-1:0] 			  from_dcram;
   wire [3:0] 				  dcram_we;
   wire 				  dctag_we;
   wire [31:0] 				  dc_addr;
   wire 				  dcfsm_biu_read;
   wire 				  dcfsm_biu_write;
   wire 				  dcfsm_dcram_di_sel;
   wire 				  dcfsm_biu_do_sel;   
   reg 					  tagcomp_miss;
   wire [`OR1200_DCINDXH:`OR1200_DCLS] 	  dctag_addr;
   wire 				  dctag_en;
   wire 				  dctag_v;
   wire 				  dctag_dirty;
   wire 				  dc_secure_bit;
   
   wire 				  dc_block_invalidate;
   wire 				  dc_block_flush;
   wire 				  dc_block_writeback;   
   wire 				  dcfsm_first_hit_ack;
   wire 				  dcfsm_first_miss_ack;
   wire 				  dcfsm_first_miss_err;
   wire 				  dcfsm_burst;
   wire 				  dcfsm_tag_we;
   wire 				  dcfsm_tag_valid;
   wire 				  dcfsm_tag_dirty;

   wire 				  dcfsm_load_miss_ack;

   reg [dw-1:0] 			  cache_dcsb_dat_i;

   /* cl encryption module singals */
   wire 				  cl_enc_eval;	
   wire 				  cl_enc_on;
   wire 				  cl_enc_done;	 
   wire 				  tag_smc_hit;
   wire 				  vaddr_smc_hit;
   wire 				  force_secure_bit_zero;   

   /* cl cntr cache singals */
   wire 				  cl_cntr_eval;
   wire 				  cl_cntr_store;
   wire 				  cl_cntr_done;
   wire 				  cl_cntr_invalid;
   wire [15:0] 				  cntr;
   wire [15:0] 				  cache_cntr;   
   
 `ifdef OR1200_BIST
   //
   // RAM BIST
   //
   wire 				  mbist_ram_so;
   wire 				  mbist_tag_so;
   wire 				  mbist_ram_si = mbist_si_i;
   wire 				  mbist_tag_si = mbist_ram_so;
   assign				mbist_so_o = mbist_tag_so;
 `endif

   // Address out to external bus - always from FSM   
   assign dcsb_adr_o = dc_addr;
   //
   // SPR register decodes
   //
 `ifdef OR1200_DC_WRITETHROUGH
   assign dc_block_invalidate = spr_cs & spr_write & 
				((spr_addr[`OR1200_SPRGRP_DC_ADR_WIDTH-1:0]==`OR1200_SPRGRP_DC_DCBIR) |
				 (spr_addr[`OR1200_SPRGRP_DC_ADR_WIDTH-1:0]==`OR1200_SPRGRP_DC_DCBFR));
   assign dc_block_flush = 0;
   assign dc_block_writeback = 0;
 `else   
   assign dc_block_invalidate = spr_cs & spr_write & 
				(spr_addr[`OR1200_SPRGRP_DC_ADR_WIDTH-1:0]==`OR1200_SPRGRP_DC_DCBIR);
   assign dc_block_flush =    spr_cs & spr_write &
			      (spr_addr[`OR1200_SPRGRP_DC_ADR_WIDTH-1:0]==`OR1200_SPRGRP_DC_DCBFR);
   assign dc_block_writeback =    spr_cs & spr_write &
				  (spr_addr[`OR1200_SPRGRP_DC_ADR_WIDTH-1:0]==`OR1200_SPRGRP_DC_DCBWR);
 `endif // !`ifdef OR1200_DC_WRITETHROUGH
   
   assign dctag_we = dcfsm_tag_we | dc_block_invalidate;
   assign dctag_addr = dc_block_invalidate ? 
		       spr_dat_i[`OR1200_DCINDXH:`OR1200_DCLS] :
		       dc_addr[`OR1200_DCINDXH:`OR1200_DCLS];
   assign dctag_en = dc_block_invalidate | dc_en;

   assign dctag_v = dc_block_invalidate ? 1'b0 : dcfsm_tag_valid;
   assign dctag_dirty = dc_block_invalidate ? 1'b0 : dcfsm_tag_dirty;
   
   //
   // Data to BIU is from DCRAM when bursting lines back into memory
   //
   
`ifdef enc_data_path
   assign dcsb_dat_o = dcfsm_biu_do_sel ? from_dcram_cypherdb : dcqmem_dat_i;
`else
   assign dcsb_dat_o = dcfsm_biu_do_sel ? from_dcram : dcqmem_dat_i;
`endif   


   //
   // Bypases of the DC when DC is disabled
   //
   assign dcsb_cyc_o = (dc_en) ? 
		       dcfsm_biu_read | dcfsm_biu_write : dcqmem_cycstb_i;
   
   assign dcsb_stb_o = (dc_en) ? 
		       dcfsm_biu_read | dcfsm_biu_write : dcqmem_cycstb_i;
   
   assign dcsb_we_o = (dc_en) ? 
		      dcfsm_biu_write : dcqmem_we_i;

   assign dcsb_sel_o = (dc_en & dcfsm_burst) ? 
		       4'b1111 : dcqmem_sel_i;

   assign dcsb_cab_o = dc_en & dcfsm_burst & dcsb_cyc_o;
   assign dcqmem_rty_o = ~dcqmem_ack_o;
   assign dcqmem_tag_o = dcqmem_err_o ? `OR1200_DTAG_BE : dcqmem_tag_i;

   //
   // DC/LSU normal and error termination
   //
   assign dcqmem_ack_o = dc_en ? 
			 dcfsm_first_hit_ack | dcfsm_first_miss_ack : dcsb_ack_i;
   
   assign dcqmem_err_o = dc_en ? dcfsm_first_miss_err : dcsb_err_i;
   
   //
   // Select between input data generated by LSU or by BIU
   //
   assign to_dcram = (dcfsm_dcram_di_sel) ? dcsb_dat_i : dcqmem_dat_i;

   //
   // Select between data generated by DCRAM or passed by BIU
   //

   wire [31:0]				  dcsb_dat_cypherdb_i;

   assign dcsb_dat_cypherdb_i = load_need_cl_enc?
				dcsb_dat_i ^ shift_enc_pad_load:
				dcsb_dat_i;   

`ifdef enc_data_path
    assign dcqmem_dat_o = dcfsm_first_miss_ack | !dc_en ? dcsb_dat_cypherdb_i : from_dcram;
`else
   assign dcqmem_dat_o = dcfsm_first_miss_ack | !dc_en ? dcsb_dat_i : from_dcram;
`endif

   //
   // Tag comparison
   //
   wire [31:`OR1200_DCTAGL] 		  dcqmem_adr_i_tag;
   assign dcqmem_adr_i_tag = dcqmem_adr_i[31:`OR1200_DCTAGL];
   
   always @(tag or dcqmem_adr_i_tag or tag_v) begin
      if ((tag != dcqmem_adr_i_tag) || !tag_v)
	tagcomp_miss = 1'b1;
      else
	tagcomp_miss = 1'b0;
   end

   //
   // cache the incoming data from the off-chip ram for _early_ ack
   //
   
   always @(posedge clk or `OR1200_RST_EVENT rst) 
      if (rst == `OR1200_RST_VALUE) begin
	cache_dcsb_dat_i <= 0;
      end
      else begin
	if (dcfsm_load_miss_ack)
	  cache_dcsb_dat_i <= dcsb_dat_i;
      end   
   
   
   //
   // Instantiation of DC Finite State Machine
   //
   or1200_dc_fsm or1200_dc_fsm(
			       .clk(clk),
			       .rst(rst),
			       .dc_en(dc_en),
			       .dcqmem_cycstb_i(dcqmem_cycstb_i),
			       .dcqmem_ci_i(dcqmem_ci_i),
			       .dcqmem_we_i(dcqmem_we_i),
			       .dcqmem_sel_i(dcqmem_sel_i),
			       .tagcomp_miss(tagcomp_miss),
			       .tag(tag),
			       .tag_v(tag_v),
			       .dirty(dirty),
			       .biudata_valid(dcsb_ack_i),
			       .biudata_error(dcsb_err_i),
			       .lsu_addr(dcqmem_adr_i),
			       .dcram_we(dcram_we),
			       .biu_read(dcfsm_biu_read),
			       .biu_write(dcfsm_biu_write),
			       .dcram_di_sel(dcfsm_dcram_di_sel),
			       .biu_do_sel(dcfsm_biu_do_sel),
			       .first_hit_ack(dcfsm_first_hit_ack),
			       .first_miss_ack(dcfsm_first_miss_ack),
			       .first_miss_err(dcfsm_first_miss_err),
			       .burst(dcfsm_burst),
			       .tag_we(dcfsm_tag_we),
			       .tag_valid(dcfsm_tag_valid),
			       .tag_dirty(dcfsm_tag_dirty),
			       .dc_addr(dc_addr),
			       .dc_no_writethrough(dc_no_writethrough),
			       .dc_block_flush(dc_block_flush),
			       .dc_block_writeback(dc_block_writeback),
			       .spr_dat_i(spr_dat_i),
			       .mtspr_dc_done(mtspr_dc_done),
			       .spr_cswe(spr_cs & spr_write),
      
			       .cl_enc_eval(cl_enc_eval),
			       .cl_enc_on(cl_enc_on),
			       .cl_enc_done(cl_enc_done),
			       .secure_exec(secure_exec),
			       .cl_cntr_eval(cl_cntr_eval),
			       .cl_cntr_store(cl_cntr_store),
			       .cl_cntr_invalid(cl_cntr_invalid),

				   .load_miss_ack_o(dcfsm_load_miss_ack),
				   .force_secure_bit_zero(force_secure_bit_zero)
			       );

   //
   // Instantiation of DC main memory
   //

   wire [31:0] to_dcram_cypherdb;
   wire [31:0] from_dcram_cypherdb;
   
   wire        load_need_cl_enc;
   wire        store_need_cl_enc;


   // if dmmu is enabled, need to have !dcqmem_ci_i;
   assign load_need_cl_enc = secure_exec & !enc_except & dc_secure_bit & !dcfsm_first_hit_ack & !dcqmem_ci_i;

   // if dmmu is disabled, omit !dcqmem_ci_i;
   //assign load_need_cl_enc = secure_exec & !enc_except & dc_secure_bit & !dcfsm_first_hit_ack;
   
   assign store_need_cl_enc = secure_exec & secure_bit;
 // & !dcqmem_ci_i;   
   
   assign to_dcram_cypherdb = load_need_cl_enc ?
   			      to_dcram ^ shift_enc_pad_load:
   			      to_dcram;

   assign from_dcram_cypherdb = store_need_cl_enc ?
   				from_dcram ^ shift_enc_pad_store:
   				from_dcram;

   // assign to_dcram_cypherdb = need_cl_enc ?
   //  			      to_dcram:
   //  			      to_dcram;

   // assign from_dcram_cypherdb = secure_exec ?
   //  				from_dcram:
   //  				from_dcram;4
	
   or1200_dc_ram or1200_dc_ram(
			       .clk(clk),
			       .rst(rst),
 `ifdef OR1200_BIST
			       // RAM BIST
			       .mbist_si_i(mbist_ram_si),
			       .mbist_so_o(mbist_ram_so),
			       .mbist_ctrl_i(mbist_ctrl_i),
 `endif
			       .addr(dc_addr[`OR1200_DCINDXH:2]),
			       .en(dc_en),
			       .we(dcram_we),
`ifdef enc_data_path			      
			       .datain(to_dcram_cypherdb),
`else
			       .datain(to_dcram),
`endif
			       .dataout(from_dcram)
			       );

   assign dc_secure_bit = dcfsm_first_hit_ack? secure_bit :
			  cache_smc_hit_select? 
			  cache_smc_hit & !force_secure_bit_zero : 
			  vaddr_smc_hit & !force_secure_bit_zero;
   
   //
   // Instantiation of DC TAG memory
   //
   or1200_dc_tag or1200_dc_tag(
			       .clk(clk),
			       .rst(rst),
 `ifdef OR1200_BIST
			       // RAM BIST
			       .mbist_si_i(mbist_tag_si),
			       .mbist_so_o(mbist_tag_so),
			       .mbist_ctrl_i(mbist_ctrl_i),
 `endif
			       .addr(dctag_addr),
			       .en(dctag_en),
			       .we(dctag_we),
			       .datain({dc_addr[31:`OR1200_DCTAGL], dctag_v, dctag_dirty, dc_secure_bit}),
			       .tag_v(tag_v),
			       .tag(tag),
			       .dirty(dirty),
			       .secure_bit(secure_bit)
			       );
`endif // !`ifdef OR1200_NO_DC

  /****************CypherDB CL encryption module Instantiation*******************/

   reg [31:0] shift_enc_pad_store;
   reg [31:0] shift_enc_pad_load;   
	
	reg [31:0] cache_shift_enc_pad_load;
	
	always @(posedge clk)
		cache_shift_enc_pad_load <= shift_enc_pad_load;
   
  // always @(dc_addr)
   always @(posedge clk)
      case (dc_addr[4:2])
	3'b000: shift_enc_pad_store  <= enc_pad_1[31:0];
	3'b001: shift_enc_pad_store  <= enc_pad_1[63:32];
	3'b010: shift_enc_pad_store <= enc_pad_1[95:64];
	3'b011: shift_enc_pad_store  <= enc_pad_1[127:96];
	3'b100: shift_enc_pad_store  <= enc_pad_2[31:0];
	3'b101: shift_enc_pad_store  <= enc_pad_2[63:32];
	3'b110: shift_enc_pad_store  <= enc_pad_2[95:64];
	3'b111: shift_enc_pad_store  <= enc_pad_2[127:96];	
      endcase // case (dc_addr[4:2])

      always @(secure_exec or cl_enc_done or dc_addr[4:2])
      case (dc_addr[4:2])
	3'b000: shift_enc_pad_load  = enc_pad_1[31:0];
	3'b001: shift_enc_pad_load  = enc_pad_1[63:32];
	3'b010: shift_enc_pad_load  = enc_pad_1[95:64];
	3'b011: shift_enc_pad_load  = enc_pad_1[127:96];
	3'b100: shift_enc_pad_load  = enc_pad_2[31:0];
	3'b101: shift_enc_pad_load  = enc_pad_2[63:32];
	3'b110: shift_enc_pad_load  = enc_pad_2[95:64];
	3'b111: shift_enc_pad_load  = enc_pad_2[127:96];
      endcase

   wire [127:0] enc_pad_1;
   wire [127:0] enc_pad_2;   
   
   or1200_cl_enc_top or1200_cl_enc_top (
					.aes_clk(aes_clk),
					.clk(clk),
					.rst(rst),

					.secure_exec(secure_exec),
					//.secure_exec(1'b1),
					.dcpu_cyc_i(dcqmem_cycstb_i),
					.dcpu_we_i(dcqmem_we_i),
					.tagcomp_miss(tagcomp_miss),
					.cl_enc_eval(cl_enc_eval & cl_cntr_done),
					.enc_on(cl_enc_on),
					.enc_done(cl_enc_done),

					.enc_key(128'h202122232425262728292a2b2c2d2e2f),
					//	.seed_tag((dc_block_flush | dc_block_writeback) ? 
					//		  spr_dat_cpu[31:`OR1200_DCLS] : qmemdmmu_adr_dmmu[31:`OR1200_DCLS]),
					.seed_tag(dcsb_adr_o[31:`OR1200_DCLS]),
					.enc_pad_1(enc_pad_1),
					.enc_pad_2(enc_pad_2)
					);

   reg 		enc_except;

   always @(posedge clk or `OR1200_RST_EVENT rst)
      if (rst == `OR1200_RST_VALUE) 
	 enc_except <= 1'b0;
     else 
	  if (|cache_cntr)
	    enc_except <= 1'b0;
	  else
	    enc_except <= 1'b1;
   
   cl_cntr_cache_top #
     (
      .cntr_aw(11),
      .cntr_dw(16)
      )
   cl_cntr_cache_top(
		     .clk(clk),
		     . rst(rst),
		     .cntr_eval(cl_cntr_eval), 
		     .cntr_store(cl_cntr_store),
		     .cntr_done(cl_cntr_done),
		     .cntr_invalid(cl_cntr_invalid),
		     .tag_addr(dcsb_adr_o[25:`OR1200_DCLS]),
		     .cntr(cntr),
		     .cache_cntr(cache_cntr)
		     );

   smc_check_top
     smc_check_vaddr(
		   .ce(secure_exec),
		   .addr(dcpu_vadr),
		   .low_bound(heap_top),
		   .high_bound(stack_top),
		   .hit(vaddr_smc_hit)
		   );

   reg cache_smc_hit;
   reg cache_smc_hit_select;   
   
   always @(posedge clk) begin
     if (dcfsm_first_miss_ack) begin
	cache_smc_hit_select <= 1'b1;	
	cache_smc_hit <= vaddr_smc_hit;
     end
     else if (dctag_we) begin
	cache_smc_hit_select <= 1'b0;	
	cache_smc_hit <= 1'b0;
     end
   end        
         
 /****************CypherDB CL encryption module Instantiation*******************/

   
endmodule
