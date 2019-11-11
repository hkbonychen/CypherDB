//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's CPU                                                ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://www.opencores.org/project,or1k                       ////
////                                                              ////
////  Description                                                 ////
////  Instantiation of internal CPU blocks. IFETCH, SPRS, FRZ,    ////
////  ALU, EXCEPT, ID, WBMUX, OPERANDMUX, RF etc.                 ////
////                                                              ////
////  To Do:                                                      ////
////   - make it smaller and faster                               ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
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
// $Log: or1200_cpu.v,v $
// Revision 2.0  2010/06/30 11:00:00  ORSoC
// Major update: 
// Structure reordered and bugs fixed. 

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

module or1200_cpu(
		  // Clk & Rst
		  aes_clk, clk, rst,

		  // Insn interface
		  ic_en,
		  icpu_adr_o, icpu_cycstb_o, icpu_sel_o, icpu_tag_o,
		  icpu_dat_i, icpu_ack_i, icpu_rty_i, icpu_err_i, icpu_adr_i, icpu_tag_i,
		  immu_en,

		  // Debug unit
		  id_void, id_insn, ex_void, 
		  ex_insn, ex_freeze, wb_insn, wb_freeze, id_pc, ex_pc, wb_pc, branch_op,
		  spr_dat_npc, rf_dataw, ex_flushpipe, 
		  du_stall, du_addr, du_dat_du, du_read, du_write, du_except_stop, 
		  du_except_trig, du_dsr, du_dmr1, du_hwbkpt, du_hwbkpt_ls_r, du_dat_cpu,
		  du_lsu_store_dat, du_lsu_load_dat, 
		  abort_mvspr, abort_ex,

		  // Data interface
		  dc_en,
		  dcpu_adr_o, dcpu_cycstb_o, dcpu_we_o, dcpu_sel_o, dcpu_tag_o, 
		  dcpu_dat_o, dcpu_dat_i, dcpu_ack_i, dcpu_rty_i, dcpu_err_i, dcpu_tag_i,
		  sb_en, dmmu_en, dc_no_writethrough,

		  // SR Interface
		  boot_adr_sel_i,

		  // Interrupt & tick exceptions
		  sig_int, sig_tick,

		  // SPR interface
		  supv, spr_addr, spr_dat_cpu, spr_dat_pic, spr_dat_tt, spr_dat_pm,
		  spr_dat_dmmu, spr_dat_immu, spr_dat_du, spr_cs, spr_we, mtspr_dc_done,

`ifdef CYPHERDB_PERFORMANCE_COUNTER
		  pc_start_o, pc_end_o, pc_en_o, pc_operand_o, perf_id_freeze,
		  perf_delayed_ack_load, perf_delayed_ack_store,
`endif
		  
		  // cypherdb start control signal
		  seed_cache_init_stall, seed_vector_init_stall, seed_init, seed_ram_init, secure_exec, stack_top, heap_top
		  );

   parameter dw = `OR1200_OPERAND_WIDTH;
   parameter aw = `OR1200_REGFILE_ADDR_WIDTH;
   parameter boot_adr = `OR1200_BOOT_ADR;

   //
   // I/O ports
   //

   //
   // Clk & Rst
   //
	input 				aes_clk;
   input 				clk;
   input 				rst;

   //
   // Insn (IC) interface
   //
   output				ic_en;
   output [31:0] 			icpu_adr_o;
   output				icpu_cycstb_o;
   output [3:0] 			icpu_sel_o;
   output [3:0] 			icpu_tag_o;
   input [31:0] 			icpu_dat_i;
   input				icpu_ack_i;
   input				icpu_rty_i;
   input				icpu_err_i;
   input [31:0] 			icpu_adr_i;
   input [3:0] 				icpu_tag_i;

   //
   // Insn (IMMU) interface
   //
   output				immu_en;

   //
   // Debug interface
   //
   output 				id_void;
   output [31:0] 			id_insn;
   output 				ex_void;
   output [31:0] 			ex_insn;
   output				ex_freeze;
   output [31:0] 			wb_insn;
   output				wb_freeze;
   output [31:0] 			id_pc;
   output [31:0] 			ex_pc;
   output [31:0] 			wb_pc;
   output 				ex_flushpipe;
   output [`OR1200_BRANCHOP_WIDTH-1:0] 	branch_op;

   input				du_stall;
   input [dw-1:0] 			du_addr;
   input [dw-1:0] 			du_dat_du;
   input				du_read;
   input				du_write;
   input [`OR1200_DU_DSR_WIDTH-1:0] 	du_dsr;
   input [24:0] 			du_dmr1;
   input				du_hwbkpt;
   input				du_hwbkpt_ls_r;
   output [13:0] 			du_except_trig;
   output [13:0] 			du_except_stop;
   output [dw-1:0] 			du_dat_cpu;
   output [dw-1:0] 			rf_dataw;
   output [dw-1:0] 			du_lsu_store_dat;
   output [dw-1:0] 			du_lsu_load_dat;

   //
   // Data (DC) interface
   //
   output [31:0] 			dcpu_adr_o;
   output				dcpu_cycstb_o;
   output				dcpu_we_o;
   output [3:0] 			dcpu_sel_o;
   output [3:0] 			dcpu_tag_o;
   output [31:0] 			dcpu_dat_o;
   input [31:0] 			dcpu_dat_i;
   input				dcpu_ack_i;
   input				dcpu_rty_i;
   input				dcpu_err_i;
   input [3:0] 				dcpu_tag_i;
   output				dc_en;
   output 				dc_no_writethrough;
   
   //
   // Data (DMMU) interface
   //
   output				sb_en;
   output				dmmu_en;
   output				abort_ex;
   output				abort_mvspr;

   //
   // SR Interface 
   //
   input				boot_adr_sel_i;

   //
   // SPR interface
   //
   output				supv;
   input [dw-1:0] 			spr_dat_pic;
   input [dw-1:0] 			spr_dat_tt;
   input [dw-1:0] 			spr_dat_pm;
   input [dw-1:0] 			spr_dat_dmmu;
   input [dw-1:0] 			spr_dat_immu;
   input [dw-1:0] 			spr_dat_du;
   output [dw-1:0] 			spr_addr;
   output [dw-1:0] 			spr_dat_cpu;
   output [dw-1:0] 			spr_dat_npc;
   output [31:0] 			spr_cs;
   output				spr_we;
   input 				mtspr_dc_done;
   
   //
   // Interrupt exceptions
   //
   input				sig_int;
   input				sig_tick;

`ifdef CYPHERDB_PERFORMANCE_COUNTER
   output 				pc_start_o;
   output 				pc_end_o;
   output 				pc_en_o;
   output [15:0] 			pc_operand_o; 	
   output 				perf_delayed_ack_load;
   output 				perf_delayed_ack_store;		
	output 				perf_id_freeze;
`endif

   //
   // cypherdb start control signal
   //
   input 				seed_cache_init_stall;
   input 				seed_vector_init_stall;   
   output 				seed_init;	
   output 				seed_ram_init;			
   output				secure_exec;
   output reg [31:0] 			stack_top;
   output reg [31:0] 			heap_top;   

   //
   // Internal wires
   //
   wire [31:0] 				if_insn;
   wire 				saving_if_insn;
   wire [31:0] 				if_pc;
   wire [aw-1:0] 			rf_addrw;
   wire [aw-1:0] 			rf_addra;
   wire [aw-1:0] 			rf_addrb;
   wire 				rf_rda;
   wire 				rf_rdb;
   wire [dw-1:0] 			id_simm;
   wire [dw-1:2] 			id_branch_addrtarget;
   wire [dw-1:2] 			ex_branch_addrtarget;
   wire [`OR1200_ALUOP_WIDTH-1:0] 	alu_op;
   wire [`OR1200_ALUOP2_WIDTH-1:0] 	alu_op2;
   wire [`OR1200_COMPOP_WIDTH-1:0] 	comp_op;
   wire [`OR1200_BRANCHOP_WIDTH-1:0] 	pre_branch_op;
   wire [`OR1200_BRANCHOP_WIDTH-1:0] 	branch_op;
   wire [`OR1200_LSUOP_WIDTH-1:0] 	id_lsu_op;
   wire 				genpc_freeze;
   wire 				if_freeze;
   wire 				id_freeze;
   wire 				ex_freeze;
   wire 				wb_freeze;
   wire [`OR1200_SEL_WIDTH-1:0] 	sel_a;
   wire [`OR1200_SEL_WIDTH-1:0] 	sel_b;
   wire [`OR1200_RFWBOP_WIDTH-1:0] 	rfwb_op;
   wire [`OR1200_FPUOP_WIDTH-1:0] 	fpu_op;
   wire [dw-1:0] 			rf_dataw;
   wire [dw-1:0] 			rf_dataa;
   wire [dw-1:0] 			rf_datab;
   wire [dw-1:0] 			muxed_a;
   wire [dw-1:0] 			muxed_b;
   wire [dw-1:0] 			wb_forw;
   wire 				wbforw_valid;
   wire [dw-1:0] 			operand_a;
   wire [dw-1:0] 			operand_b;
   wire [dw-1:0] 			alu_dataout;
   wire [dw-1:0] 			lsu_dataout;
   wire [dw-1:0] 			sprs_dataout;
   wire [dw-1:0] 			fpu_dataout;
   wire 				fpu_done;
   wire [31:0] 				ex_simm;
   wire [`OR1200_MULTICYCLE_WIDTH-1:0] 	multicycle;
   wire [`OR1200_WAIT_ON_WIDTH-1:0] 	wait_on;      
   wire [`OR1200_EXCEPT_WIDTH-1:0] 	except_type;
   wire [4:0] 				cust5_op;
   wire [5:0] 				cust5_limm;
   wire 				if_flushpipe;
   wire 				id_flushpipe;
   wire 				ex_flushpipe;
   wire 				wb_flushpipe;
   wire 				extend_flush;
   wire 				ex_branch_taken;
   wire 				flag;
   wire 				flagforw;
   wire 				flag_we;
   wire 				flagforw_alu;   
   wire 				flag_we_alu;
   wire 				flagforw_fpu;
   wire 				flag_we_fpu;
   wire 				carry;
   wire 				cyforw;
   wire 				cy_we_alu;
   wire 				ovforw;
   wire 				ov_we_alu;
   wire 				ovforw_mult_mac;
   wire 				ov_we_mult_mac;   
   wire 				cy_we_rf;
   wire 				lsu_stall;
   wire 				epcr_we;
   wire 				eear_we;
   wire 				esr_we;
   wire 				pc_we;
   wire [31:0] 				epcr;
   wire [31:0] 				eear;
   wire [`OR1200_SR_WIDTH-1:0] 		esr;
   wire [`OR1200_FPCSR_WIDTH-1:0] 	fpcsr;
   wire 				fpcsr_we;   
   wire 				sr_we;
   wire [`OR1200_SR_WIDTH-1:0] 		to_sr;
   wire [`OR1200_SR_WIDTH-1:0] 		sr;
   wire 				dsx;
   wire 				except_flushpipe;
   wire 				except_start;
   wire 				except_started;
   wire 				fpu_except_started;   
   wire [31:0] 				wb_insn;
   wire 				sig_syscall;
   wire 				sig_trap;
   wire 				sig_range;
   wire 				sig_fp;
   wire [31:0] 				spr_dat_cfgr;
   wire [31:0] 				spr_dat_rf;
   wire [31:0] 				spr_dat_npc;
   wire [31:0] 				spr_dat_ppc;
   wire [31:0] 				spr_dat_mac;
   wire [31:0] 				spr_dat_fpu;
   wire 				mtspr_done;
   wire 				force_dslot_fetch;
   wire 				no_more_dslot;
   wire 				ex_void;
   wire 				ex_spr_read;
   wire 				ex_spr_write;
   wire 				if_stall;
   wire 				id_macrc_op;
   wire 				ex_macrc_op;
   wire [`OR1200_MACOP_WIDTH-1:0] 	id_mac_op;
   wire [`OR1200_MACOP_WIDTH-1:0] 	mac_op;
   wire [31:0] 				mult_mac_result;
   wire 				mult_mac_stall;
   wire [13:0] 				except_trig;
   wire [13:0] 				except_stop;
   wire 				genpc_refetch;
   wire 				rfe;
   wire 				lsu_unstall;
   wire 				except_align;
   wire 				except_dtlbmiss;
   wire 				except_dmmufault;
   wire 				except_illegal;
   wire 				except_itlbmiss;
   wire 				except_immufault;
   wire 				except_ibuserr;
   wire 				except_dbuserr;
   wire 				abort_ex;
   wire 				abort_mvspr;

   //
   // Internal wire from or1200_ctrl to encrypion fsm
   //
   
   wire [4:0] 				seedIn;
   wire [4:0] 				seedAddr;
   wire [10:0] 				seedImm;
   wire 				seed_ce;
   wire [4:0] 				shift_ra;
   wire [4:0] 				shift_rb;
   wire [10:0] 				shift_imm;
   wire 				shift_ce;

    /******************************CypherDB CL encryption enable Instantiation******************************/

   //
   // cypherdb_start (from l.start) and cypherdb_end (from l.end) are from or1200_ctrl 
   // secure_exec are asserted bounded by cypherdb_start and cypherdb_end signal
   // secure_exec is the CL enc enable signal ported to or1200_cl_enc_top.v
   //

   wire					cypherdb_start;
   wire 				cypherdb_end;

   assign seed_init = cypherdb_end;
   assign seed_ram_init = cypherdb_start;   

   or1200_cypherdb_start 
     or1200_cypherdb_secure_exec(
				 .clk(clk),
				 .rst(rst),
				 .ce(1'b1),
				 .start_pulse(cypherdb_start),
				 .end_pulse(cypherdb_end),
				 .secure_exec(secure_exec)
				 );

`ifdef CYPHERDB_PERFORMANCE_COUNTER
   
   wire 				cypherdb_pc_start;
   wire 				cypherdb_pc_end;
   wire 				cypherdb_pc_en;
   wire [15:0] 				cypherdb_pc_operand;

   assign perf_delayed_ack_load = delayed_ack_load;
   assign perf_delayed_ack_store = delayed_ack_store;   

   assign pc_start_o = cypherdb_pc_start;
   assign pc_end_o = cypherdb_pc_end;
   assign pc_en_o = cypherdb_pc_en;
   assign pc_operand_o = cypherdb_pc_operand;   
	assign perf_id_freeze = id_freeze;
   
   or1200_cypherdb_start 
     or1200_cypherdb_pc(
			.clk(clk),
			.rst(rst),
			.ce(1'b1),
			.start_pulse(cypherdb_pc_start),
			.end_pulse(cypherdb_pc_end),
			.secure_exec(cypherdb_pc_en)
			);
`endif
   
   wire 				read_smc_boundary;   
   reg 					write_smc_boundary;
   
   always @(posedge clk) begin
      write_smc_boundary <= read_smc_boundary;
      if (write_smc_boundary) begin
	 stack_top <= rf_dataa;
	 heap_top <= rf_datab;
      end
      if (cypherdb_end) begin
	 stack_top <= 32'b0;
	 heap_top <= 32'b0;
      end
   end   

   /******************************CypherDB CL encryption enable Instantiation******************************/


   //
   // Send exceptions to Debug Unit
   //
   assign du_except_trig = except_trig;
   assign du_except_stop = except_stop;
   assign du_lsu_store_dat = operand_b;
   assign du_lsu_load_dat  = lsu_dataout;

   //
   // Data cache enable
   //
`ifdef OR1200_NO_DC
   assign dc_en = 1'b0;
`else
   assign dc_en = sr[`OR1200_SR_DCE];
`endif

   //
   // Instruction cache enable
   //
`ifdef OR1200_NO_IC
   assign ic_en = 1'b0;
`else
   assign ic_en = sr[`OR1200_SR_ICE];
`endif

   //
   // SB enable
   //
`ifdef OR1200_SB_IMPLEMENTED
   //assign sb_en = sr[`OR1200_SR_SBE]; // SBE not defined  -- jb
	assign sb_en = 1'b1;
`else
   assign sb_en = 1'b0;
`endif

   //
   // DMMU enable
   //
`ifdef OR1200_NO_DMMU
   assign dmmu_en = 1'b0;
`else
   assign dmmu_en = sr[`OR1200_SR_DME];
`endif

   //
   // IMMU enable
   //
`ifdef OR1200_NO_IMMU
   assign immu_en = 1'b0;
`else
   assign immu_en = sr[`OR1200_SR_IME] & ~except_started;
`endif

   //
   // SUPV bit
   //
   assign supv = sr[`OR1200_SR_SM];

   //
   // FLAG write enable
   //
   assign flagforw = (flag_we_alu & flagforw_alu) | (flagforw_fpu & flag_we_fpu);
   assign flag_we = (flag_we_alu | flag_we_fpu) & ~abort_mvspr;

   //
   // Flag for any MTSPR instructions, that must block execution, to indicate done
   //
   assign mtspr_done = mtspr_dc_done;

   //
   // Range exception
   //
   assign sig_range = sr[`OR1200_SR_OV];
   
   
   
   //
   // Instantiation of instruction fetch block
   //
   or1200_genpc #(.boot_adr(boot_adr)) or1200_genpc(
						    .clk(clk),
						    .rst(rst),
						    .icpu_adr_o(icpu_adr_o),
						    .icpu_cycstb_o(icpu_cycstb_o),
						    .icpu_sel_o(icpu_sel_o),
						    .icpu_tag_o(icpu_tag_o),
						    .icpu_rty_i(icpu_rty_i),
						    .icpu_adr_i(icpu_adr_i),

						    .pre_branch_op(pre_branch_op),
						    .branch_op(branch_op),
						    .except_type(except_type),
						    .except_start(except_start),
						    .except_prefix(sr[`OR1200_SR_EPH]),
						    .id_branch_addrtarget(id_branch_addrtarget),
						    .ex_branch_addrtarget(ex_branch_addrtarget),
						    .muxed_b(muxed_b),
						    .operand_b(operand_b),
						    .flag(flag),
						    .flagforw(flagforw),
						    .ex_branch_taken(ex_branch_taken),
						    .epcr(epcr),
						    .spr_dat_i(spr_dat_cpu),
						    .spr_pc_we(pc_we),
						    .genpc_refetch(genpc_refetch),
						    .genpc_freeze(genpc_freeze),
						    .no_more_dslot(no_more_dslot),
						    .lsu_stall(lsu_stall)
						    );

   //
   // Instantiation of instruction fetch block
   //
   or1200_if or1200_if(
		       .clk(clk),
		       .rst(rst),
		       .icpu_dat_i(icpu_dat_i),
		       .icpu_ack_i(icpu_ack_i),
		       .icpu_err_i(icpu_err_i),
		       .icpu_adr_i(icpu_adr_i),
		       .icpu_tag_i(icpu_tag_i),

		       .if_freeze(if_freeze),
		       .if_insn(if_insn),
		       .if_pc(if_pc),
		       .saving_if_insn(saving_if_insn),
		       .if_flushpipe(if_flushpipe),
		       .if_stall(if_stall),
		       .no_more_dslot(no_more_dslot),
		       .genpc_refetch(genpc_refetch),
		       .rfe(rfe),
		       .except_itlbmiss(except_itlbmiss),
		       .except_immufault(except_immufault),
		       .except_ibuserr(except_ibuserr)
		       );

   //
   // Instantiation of instruction decode/control logic
   //

   wire 				sload_flag;
   wire 				sstore_flag; 	 
   wire 				cypherdb_start_stall;   

   or1200_ctrl or1200_ctrl(
			   .clk(clk),
			   .rst(rst),
			   .id_freeze(id_freeze),
			   .ex_freeze(ex_freeze),
			   .wb_freeze(wb_freeze),
			   .if_flushpipe(if_flushpipe),
			   .id_flushpipe(id_flushpipe),
			   .ex_flushpipe(ex_flushpipe),
			   .wb_flushpipe(wb_flushpipe),
			   .extend_flush(extend_flush),
			   .except_flushpipe(except_flushpipe),
			   .abort_mvspr(abort_mvspr),
			   .if_insn(if_insn),
			   .id_insn(id_insn),
			   .ex_insn(ex_insn),
			   .id_branch_op(pre_branch_op),
			   .ex_branch_op(branch_op),
			   .ex_branch_taken(ex_branch_taken),
			   .rf_addra(rf_addra),
			   .rf_addrb(rf_addrb),
			   .rf_rda(rf_rda),
			   .rf_rdb(rf_rdb),
			   .alu_op(alu_op),
			   .alu_op2(alu_op2),			
			   .mac_op(mac_op),
			   .comp_op(comp_op),
			   .rf_addrw(rf_addrw),
			   .rfwb_op(rfwb_op),
			   .fpu_op(fpu_op),			
			   .pc_we(pc_we),
			   .wb_insn(wb_insn),
			   .id_simm(id_simm),
			   .id_branch_addrtarget(id_branch_addrtarget),
			   .ex_branch_addrtarget(ex_branch_addrtarget),
			   .ex_simm(ex_simm),
			   .sel_a(sel_a),
			   .sel_b(sel_b),
			   .id_lsu_op(id_lsu_op),
			   .cust5_op(cust5_op),
			   .cust5_limm(cust5_limm),
			   .id_pc(id_pc),
			   .ex_pc(ex_pc),
			   .multicycle(multicycle),
			   .wait_on(wait_on),			
			   .wbforw_valid(wbforw_valid),
			   .sig_syscall(sig_syscall),
			   .sig_trap(sig_trap),
			   .force_dslot_fetch(force_dslot_fetch),
			   .no_more_dslot(no_more_dslot),
			   .id_void(id_void),
			   .ex_void(ex_void),
			   .ex_spr_read(ex_spr_read),
			   .ex_spr_write(ex_spr_write),
			   .id_mac_op(id_mac_op),
			   .id_macrc_op(id_macrc_op),
			   .ex_macrc_op(ex_macrc_op),
			   .rfe(rfe),
			   .du_hwbkpt(du_hwbkpt),
			   .except_illegal(except_illegal),
			   .dc_no_writethrough(dc_no_writethrough),
			   .sload_flag(sload_flag),
			   .sstore_flag(sstore_flag),
			   .ld_sw_flag(),
			   .cypherdb_rb(seedAddr),
			   .cypherdb_imm(seedImm),
			   .cypherdb_seedr(seed_ce),
			   .cypherdb_shift_ra(shift_ra),
			   .cypherdb_shift_rb(shift_rb),
			   .cypherdb_shift_imm(shift_imm),
			   .cypherdb_shift_ce(shift_ce),
			   .cypherdb_start(cypherdb_start),
			   .cypherdb_end(cypherdb_end),
			   .read_smc_boundary(read_smc_boundary),
			   
`ifdef CYPHERDB_PERFORMANCE_COUNTER
			   .cypherdb_pc_start(cypherdb_pc_start),
			   .cypherdb_pc_end(cypherdb_pc_end),
			   .cypherdb_pc_operand(cypherdb_pc_operand),
`endif

			   .ex_shift_op(ex_shift_op)
			   );
   
   

   // Here is the interesting point of why (dcpu_ack_i & !dcpu_we_o):
   // The observation is that the pipeline is stalled if the ack from the mmu is not received. Since the dcpu_we_o is taken from the most significant bit of ex_lsu_op, dcpu_we_o will keep high for store operation until the corresponding ack from mmu is received. On the contrary, dcpu_we_o will keep low for load operation until the ack is received. Therefore, dcpu_we_o is trickly used as a control signal to identify load/store operation

     
   //
   // On-chip AES encryption engine control module (FSM)
   //

   wire 	delayed_ack_load;
   wire 	delayed_ack_store;	
   wire 	dcpu_enc_ack_i;
   wire 	enc_ack_load;
   wire 	enc_ack_store;

   wire 	dcpu_enc_rty_i;
   
   wire 	enc_unstall_load;
   wire 	enc_unstall_store;
   
   wire [31:0] 	dcpu_cipher_o;
   wire [31:0] 	dcpu_cipher_i;

   wire [`shift_op_size-1:0] ex_shift_op;

   wire 	xor_stall_load;
   wire 	xor_stall_store;
   
   wire [31:0] 	encPad_load;
   wire [31:0] 	encPad_store;
   
   assign enc_key = 128'h0123456789abcdef0123456789abcdef;
   assign dcpu_enc_ack_i =  enc_ack_load | enc_ack_store;

   assign enc_ack_load = (delayed_ack_load & enc_unstall_load)
     | (enc_unstall_load & dcpu_ack_i & !dcpu_we_o);

   assign enc_ack_store = (delayed_ack_store & enc_unstall_store) | (enc_unstall_store & dcpu_ack_i & dcpu_we_o);
   
   assign dcpu_enc_rty_i = ~dcpu_enc_ack_i;
   
   //assign dcpu_enc_ack_i = dcpu_ack_i;  

   or1200_ack_fsm
     or1200_ack_load (
		     .clk(clk),
		     .rst(rst),
		     .ack_i(dcpu_ack_i & !dcpu_we_o),
		     .enc_fsm_unstall(enc_unstall_load),
		     .delayed_ack_o(delayed_ack_load)
		     );

    or1200_ack_fsm
     or1200_ack_store (
		     .clk(clk),
		     .rst(rst),
		     .ack_i(dcpu_ack_i & dcpu_we_o),
		     .enc_fsm_unstall(enc_unstall_store),
		     .delayed_ack_o(delayed_ack_store)
		     );
			  
   wire rf_we_forward;		
   wire [dw-1:0] seedIn_enc;	
   assign seedIn_enc = rf_we_forward? rf_dataw : rf_dataa;
   
   or1200_enc_fsm_top
     or1200_enc_fsm_top (
			 .aes_clk(aes_clk),
			 .clk(clk),
			 .rst(rst),
			 .seedIn(rf_dataa),
			 .seedAddr(seedAddr),
			 .seedImm(seedImm),
			 .seed_read(seed_ce),
			 .shiftRa(shift_ra),
			 .shiftRb(shift_rb),
			 .shiftImm(shift_imm),
			 .shift_read(shift_ce),
			 .ex_op(ex_shift_op),
			 .enc_pad_shifted_load(encPad_load),
			 .enc_pad_shifted_store(encPad_store),
			 .unstall_load(enc_unstall_load),
			 .unstall_store(enc_unstall_store),
			 .load_ack_i(enc_ack_load),
			 .store_ack_i(enc_ack_store),
			 .xor_stall_load(xor_stall_load),
			 .xor_stall_store(xor_stall_store)
			 );
   
   //
   // mux to control the normal data flow and secure data flow between
   // or1200_lsu and memory
   // dcpu_lsu_out: output from lsu
   // or1200_encryption takes dcpu_lsu_out as input and output dcpu_cipher_out
   //
   
   //
   // Instantiation of register file
   //
   or1200_rf or1200_rf(
		       .clk(clk),
		       .rst(rst),
		       .cy_we_i(cy_we_alu),
		       .cy_we_o(cy_we_rf),
		       .supv(sr[`OR1200_SR_SM]),
		       .wb_freeze(wb_freeze),
		       .addrw(rf_addrw),
		       .dataw(rf_dataw),
		       .id_freeze(id_freeze),
		       .we(rfwb_op[0]),
		       .flushpipe(wb_flushpipe),
		       .addra(rf_addra),
		       .rda(rf_rda),
		       .dataa(rf_dataa),
		       .addrb(rf_addrb),
		       .rdb(rf_rdb),
		       .datab(rf_datab),
		       .spr_cs(spr_cs[`OR1200_SPR_GROUP_SYS]),
		       .spr_write(spr_we),
		       .spr_addr(spr_addr),
		       .spr_dat_i(spr_dat_cpu),
		       .spr_dat_o(spr_dat_rf),
		       .du_read(du_read),
		       .rf_we_o(rf_we_forward),
		       .read_smc_boundary(read_smc_boundary)
		       );

   //
   // Instantiation of operand muxes
   //
   or1200_operandmuxes or1200_operandmuxes(
					   .clk(clk),
					   .rst(rst),
					   .id_freeze(id_freeze),
					   .ex_freeze(ex_freeze),
					   .rf_dataa(rf_dataa),
					   .rf_datab(rf_datab),
					   .ex_forw(rf_dataw),
					   .wb_forw(wb_forw),
					   .simm(id_simm),
					   .sel_a(sel_a),
					   .sel_b(sel_b),
					   .operand_a(operand_a),
					   .operand_b(operand_b),
					   .muxed_a(muxed_a),
					   .muxed_b(muxed_b)
					   );

   //
   // Instantiation of CPU's ALU
   //
   or1200_alu or1200_alu(
			 .a(operand_a),
			 .b(operand_b),
			 .mult_mac_result(mult_mac_result),
			 .macrc_op(ex_macrc_op),
			 .alu_op(alu_op),
			 .alu_op2(alu_op2),		      
			 .comp_op(comp_op),
			 .cust5_op(cust5_op),
			 .cust5_limm(cust5_limm),
			 .result(alu_dataout),
			 .flagforw(flagforw_alu),
			 .flag_we(flag_we_alu),
			 .cyforw(cyforw),
			 .cy_we(cy_we_alu),
			 .ovforw(ovforw),
			 .ov_we(ov_we_alu),		      
			 .flag(flag),
			 .carry(carry)
			 );

   
   //
   // FPU's exception is being dealt with
   //    
   assign fpu_except_started = except_started && (except_type == `OR1200_EXCEPT_FLOAT);
   
   //
   // Instantiation of FPU
   //
   or1200_fpu or1200_fpu(
			 .clk(clk),
			 .rst(rst),
			 .ex_freeze(ex_freeze),
			 .a(operand_a),
			 .b(operand_b),
			 .fpu_op(fpu_op),
			 .result(fpu_dataout),
			 .done(fpu_done),
			 .flagforw(flagforw_fpu),
			 .flag_we(flag_we_fpu),
			 .sig_fp(sig_fp),
			 .except_started(fpu_except_started),
			 .fpcsr_we(fpcsr_we),
			 .fpcsr(fpcsr),		      
			 .spr_cs(spr_cs[`OR1200_SPR_GROUP_FPU]),
			 .spr_write(spr_we),
			 .spr_addr(spr_addr),
			 .spr_dat_i(spr_dat_cpu),
			 .spr_dat_o(spr_dat_fpu)
			 );

   
   //
   // Instantiation of CPU's multiply unit
   //
   or1200_mult_mac or1200_mult_mac(
				   .clk(clk),
				   .rst(rst),
				   .ex_freeze(ex_freeze),
				   .id_macrc_op(id_macrc_op),
				   .macrc_op(ex_macrc_op),
				   .a(operand_a),
				   .b(operand_b),
				   .mac_op(mac_op),
				   .alu_op(alu_op),
				   .result(mult_mac_result),
				   .ovforw(ovforw_mult_mac), 
				   .ov_we(ov_we_mult_mac),
				   .mult_mac_stall(mult_mac_stall),
				   .spr_cs(spr_cs[`OR1200_SPR_GROUP_MAC]),
				   .spr_write(spr_we),
				   .spr_addr(spr_addr),
				   .spr_dat_i(spr_dat_cpu),
				   .spr_dat_o(spr_dat_mac)
				   );

   //
   // Instantiation of CPU's SPRS block
   //
   or1200_sprs or1200_sprs(
			   .clk(clk),
			   .rst(rst),
			   .addrbase(operand_a),
			   .addrofs(ex_simm[15:0]),
			   .dat_i(operand_b),
			   .ex_spr_read(ex_spr_read),
			   .ex_spr_write(ex_spr_write),
			   .flagforw(flagforw),
			   .flag_we(flag_we),
			   .flag(flag),
			   .cyforw(cyforw),
			   .cy_we(cy_we_rf),
			   .carry(carry),
			   .ovforw(ovforw | ovforw_mult_mac),
			   .ov_we(ov_we_alu | ov_we_mult_mac),
			   .to_wbmux(sprs_dataout),

			   .du_addr(du_addr),
			   .du_dat_du(du_dat_du),
			   .du_read(du_read),
			   .du_write(du_write),
			   .du_dat_cpu(du_dat_cpu),
			   .boot_adr_sel_i(boot_adr_sel_i),
			   .spr_addr(spr_addr),
			   .spr_dat_pic(spr_dat_pic),
			   .spr_dat_tt(spr_dat_tt),
			   .spr_dat_pm(spr_dat_pm),
			   .spr_dat_cfgr(spr_dat_cfgr),
			   .spr_dat_rf(spr_dat_rf),
			   .spr_dat_npc(spr_dat_npc),
			   .spr_dat_ppc(spr_dat_ppc),
			   .spr_dat_mac(spr_dat_mac),
			   .spr_dat_dmmu(spr_dat_dmmu),
			   .spr_dat_immu(spr_dat_immu),
			   .spr_dat_du(spr_dat_du),
			   .spr_dat_o(spr_dat_cpu),
			   .spr_cs(spr_cs),
			   .spr_we(spr_we),

			   .epcr_we(epcr_we),
			   .eear_we(eear_we),
			   .esr_we(esr_we),
			   .pc_we(pc_we),
			   .epcr(epcr),
			   .eear(eear),
			   .esr(esr),
			   .except_started(except_started),

			   .fpcsr(fpcsr),
			   .fpcsr_we(fpcsr_we),			
			   .spr_dat_fpu(spr_dat_fpu),
      
			   .sr_we(sr_we),
			   .to_sr(to_sr),
			   .sr(sr),
			   .branch_op(branch_op),
			   .dsx(dsx)
			   );

   //
   // Instantiation of load/store unit
   //
   or1200_lsu or1200_lsu(
			 .clk(clk),
			 .rst(rst),
			 .id_addrbase(muxed_a),
			 .id_addrofs(id_simm),
			 .ex_addrbase(operand_a),
			 .ex_addrofs(ex_simm),
			 .id_lsu_op(id_lsu_op),
			 .lsu_datain(operand_b),
			 .lsu_dataout(lsu_dataout),
			 .lsu_stall(lsu_stall),
			 .lsu_unstall(lsu_unstall),
			 .du_stall(du_stall),
			 .except_align(except_align),
			 .except_dtlbmiss(except_dtlbmiss),
			 .except_dmmufault(except_dmmufault),
			 .except_dbuserr(except_dbuserr),
			 .id_freeze(id_freeze),
			 .ex_freeze(ex_freeze),
			 .flushpipe(ex_flushpipe),

			 .dcpu_adr_o(dcpu_adr_o),
			 .dcpu_cycstb_o(dcpu_cycstb_o),
			 .dcpu_we_o(dcpu_we_o),
			 .dcpu_sel_o(dcpu_sel_o),
			 .dcpu_tag_o(dcpu_tag_o),
			 .dcpu_dat_o(dcpu_dat_o),
			 .dcpu_dat_i(dcpu_dat_i),
			 .dcpu_ack_i(dcpu_enc_ack_i),
			 .dcpu_rty_i(dcpu_enc_rty_i),
			 .dcpu_err_i(dcpu_err_i),
			 .dcpu_tag_i(dcpu_tag_i),

			 .sstore_i(sstore_flag),
			 .sstore_o(store_mux),
			 .encryption_cycstb(wb_encryption_control),
			 .ex_shift_op(ex_shift_op),
			 .encPad_load(encPad_load),
			 .encPad_store(encPad_store)
			 );

   //
   // Instantiation of write-back muxes
   //
   or1200_wbmux or1200_wbmux(
			     .clk(clk),
			     .rst(rst),
			     .wb_freeze(wb_freeze),
			     .rfwb_op(rfwb_op),
			     .muxin_a(alu_dataout),
			     .muxin_b(lsu_dataout),
			     .muxin_c(sprs_dataout),
			     .muxin_d(ex_pc),
			     .muxin_e(fpu_dataout),
			     .muxout(rf_dataw),
			     .muxreg(wb_forw),
			     .muxreg_valid(wbforw_valid)
			     );

   //
   // Instantiation of freeze logic
   //
   or1200_freeze or1200_freeze(
			       .clk(clk),
			       .rst(rst),
			       .multicycle(multicycle),
			       .wait_on(wait_on),
			       .fpu_done(fpu_done),
			       .mtspr_done(mtspr_done),
			       .flushpipe(wb_flushpipe),
			       .extend_flush(extend_flush),
			       .lsu_stall(lsu_stall),
			       .if_stall(if_stall),
			       .lsu_unstall(lsu_unstall),
			       .force_dslot_fetch(force_dslot_fetch),
			       .abort_ex(abort_ex),
			       .du_stall(du_stall),
			       .mac_stall(mult_mac_stall),
			       .saving_if_insn(saving_if_insn),
			       .genpc_freeze(genpc_freeze),
			       .if_freeze(if_freeze),
			       .id_freeze(id_freeze),
			       .ex_freeze(ex_freeze),
			       .wb_freeze(wb_freeze),
			       .icpu_ack_i(icpu_ack_i),
			       .icpu_err_i(icpu_err_i),
			       .seed_cache_init_stall(seed_cache_init_stall),
			       .seed_vector_init_stall(seed_vector_init_stall)
			       );

   //
   // Instantiation of exception block
   //
   or1200_except or1200_except(
			       .clk(clk),
			       .rst(rst),
			       .sig_ibuserr(except_ibuserr),
			       .sig_dbuserr(except_dbuserr),
			       .sig_illegal(except_illegal),
			       .sig_align(except_align),
			       .sig_range(sig_range),
			       .sig_dtlbmiss(except_dtlbmiss),
			       .sig_dmmufault(except_dmmufault),
			       .sig_int(sig_int),
			       .sig_syscall(sig_syscall),
			       .sig_trap(sig_trap),
			       .sig_itlbmiss(except_itlbmiss),
			       .sig_immufault(except_immufault),
			       .sig_tick(sig_tick),
			       .sig_fp(sig_fp),
			       .fpcsr_fpee(fpcsr[`OR1200_FPCSR_FPEE]),
			       .ex_branch_taken(ex_branch_taken),
			       .icpu_ack_i(icpu_ack_i),
			       .icpu_err_i(icpu_err_i),
			       .dcpu_ack_i(dcpu_enc_ack_i),
			       .dcpu_err_i(dcpu_err_i),
			       .genpc_freeze(genpc_freeze),
			       .id_freeze(id_freeze),
			       .ex_freeze(ex_freeze),
			       .wb_freeze(wb_freeze),
			       .if_stall(if_stall),
			       .if_pc(if_pc),
			       .id_pc(id_pc),
			       .ex_pc(ex_pc),
			       .wb_pc(wb_pc),
			       .id_flushpipe(id_flushpipe),
			       .ex_flushpipe(ex_flushpipe),
			       .extend_flush(extend_flush),
			       .except_flushpipe(except_flushpipe),
			       .abort_mvspr(abort_mvspr),
			       .except_type(except_type),
			       .except_start(except_start),
			       .except_started(except_started),
			       .except_stop(except_stop),
			       .except_trig(except_trig),
			       .ex_void(ex_void),
			       .spr_dat_ppc(spr_dat_ppc),
			       .spr_dat_npc(spr_dat_npc),

			       .datain(spr_dat_cpu),
			       .branch_op(branch_op),
			       .du_dsr(du_dsr),
			       .du_dmr1(du_dmr1),
			       .du_hwbkpt(du_hwbkpt),
			       .du_hwbkpt_ls_r(du_hwbkpt_ls_r),
			       .epcr_we(epcr_we),
			       .eear_we(eear_we),
			       .esr_we(esr_we),
			       .pc_we(pc_we),
			       .epcr(epcr),
			       .eear(eear),
			       .esr(esr),

			       .lsu_addr(dcpu_adr_o),
			       .sr_we(sr_we),
			       .to_sr(to_sr),
			       .sr(sr),
			       .abort_ex(abort_ex),
			       .dsx(dsx),
			       .ex_dslot(ex_dslot)
			       );

   //
   // Instantiation of configuration registers
   //
   or1200_cfgr or1200_cfgr(
			   .spr_addr(spr_addr),
			   .spr_dat_o(spr_dat_cfgr)
			   );

endmodule
