//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200 Top Level                                            ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://opencores.org/project,or1k                           ////
////                                                              ////
////  Description                                                 ////
////  OR1200 Top Level                                            ////
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
// CVS Revision History
//
// $Log: or1200_top.v,v $
// Revision 2.0  2010/06/30 11:00:00  ORSoC
// Major update: 
// Structure reordered. 
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

module or1200_top(
		  aes_clk_i,
		  // System
		  clk_i, rst_i, pic_ints_i, clmode_i,

		  // Instruction WISHBONE INTERFACE
		  iwb_clk_i, iwb_rst_i, iwb_ack_i, iwb_err_i, iwb_rty_i, iwb_dat_i,
		  iwb_cyc_o, iwb_adr_o, iwb_stb_o, iwb_we_o, iwb_sel_o, iwb_dat_o,
`ifdef OR1200_WB_CAB
		  iwb_cab_o,
`endif
`ifdef OR1200_WB_B3
		  iwb_cti_o, iwb_bte_o,
`endif
		  // Data WISHBONE INTERFACE
		  dwb_clk_i, dwb_rst_i, dwb_ack_i, dwb_err_i, dwb_rty_i, dwb_dat_i,
		  dwb_cyc_o, dwb_adr_o, dwb_stb_o, dwb_we_o, dwb_sel_o, dwb_dat_o,
`ifdef OR1200_WB_CAB
		  dwb_cab_o,
`endif
`ifdef OR1200_WB_B3
		  dwb_cti_o, dwb_bte_o,
`endif

		  // External Debug Interface
		  dbg_stall_i, dbg_ewt_i,	dbg_lss_o, dbg_is_o, dbg_wp_o, dbg_bp_o,
		  dbg_stb_i, dbg_we_i, dbg_adr_i, dbg_dat_i, dbg_dat_o, dbg_ack_o,

`ifdef OR1200_BIST
		  // RAM BIST
		  mbist_si_i, mbist_so_o, mbist_ctrl_i,
`endif
		  // Power Management
		  pm_cpustall_i,
		  pm_clksd_o, pm_dc_gate_o, pm_ic_gate_o, pm_dmmu_gate_o, 
		  pm_immu_gate_o, pm_tt_gate_o, pm_cpu_gate_o, pm_wakeup_o, pm_lvolt_o

		  ,sig_tick,

		  // secure cl encryption
		  seed_ram_access

		  );

   parameter dw = `OR1200_OPERAND_WIDTH;
   parameter aw = `OR1200_OPERAND_WIDTH;
   parameter ppic_ints = `OR1200_PIC_INTS;
   parameter boot_adr = `OR1200_BOOT_ADR;

   //
   // I/O
   //

   //
   // System
   //
   input 		aes_clk_i;
   input		clk_i;
   input		rst_i;
   input [1:0] 		clmode_i;	// 00 WB=RISC, 01 WB=RISC/2, 10 N/A, 11 WB=RISC/4
   input [ppic_ints-1:0] pic_ints_i;

   //
   // Instruction WISHBONE interface
   //
   input 		 iwb_clk_i;	// clock input
   input 		 iwb_rst_i;	// reset input
   input 		 iwb_ack_i;	// normal termination
   input 		 iwb_err_i;	// termination w/ error
   input 		 iwb_rty_i;	// termination w/ retry
   input [dw-1:0] 	 iwb_dat_i;	// input data bus
   output 		 iwb_cyc_o;	// cycle valid output
   output [aw-1:0] 	 iwb_adr_o;	// address bus outputs
   output 		 iwb_stb_o;	// strobe output
   output 		 iwb_we_o;	// indicates write transfer
   output [3:0] 	 iwb_sel_o;	// byte select outputs
   output [dw-1:0] 	 iwb_dat_o;	// output data bus
`ifdef OR1200_WB_CAB
   output 		 iwb_cab_o;	// indicates consecutive address burst
`endif
`ifdef OR1200_WB_B3
   output [2:0] 	 iwb_cti_o;	// cycle type identifier
   output [1:0] 	 iwb_bte_o;	// burst type extension
`endif

   //
   // Data WISHBONE interface
   //
   input 		 dwb_clk_i;	// clock input
   input 		 dwb_rst_i;	// reset input
   input 		 dwb_ack_i;	// normal termination
   input 		 dwb_err_i;	// termination w/ error
   input 		 dwb_rty_i;	// termination w/ retry
   input [dw-1:0] 	 dwb_dat_i;	// input data bus
   output 		 dwb_cyc_o;	// cycle valid output
   output [aw-1:0] 	 dwb_adr_o;	// address bus outputs
   output 		 dwb_stb_o;	// strobe output
   output 		 dwb_we_o;	// indicates write transfer
   output [3:0] 	 dwb_sel_o;	// byte select outputs
   output [dw-1:0] 	 dwb_dat_o;	// output data bus
`ifdef OR1200_WB_CAB
   output 		 dwb_cab_o;	// indicates consecutive address burst
`endif
`ifdef OR1200_WB_B3
   output [2:0] 	 dwb_cti_o;	// cycle type identifier
   output [1:0] 	 dwb_bte_o;	// burst type extension
`endif

   //
   // External Debug Interface
   //
   input 		 dbg_stall_i;	// External Stall Input
   input 		 dbg_ewt_i;	// External Watchpoint Trigger Input
   output [3:0] 	 dbg_lss_o;	// External Load/Store Unit Status
   output [1:0] 	 dbg_is_o;	// External Insn Fetch Status
   output [10:0] 	 dbg_wp_o;	// Watchpoints Outputs
   output 		 dbg_bp_o;	// Breakpoint Output
   input 		 dbg_stb_i;      // External Address/Data Strobe
   input 		 dbg_we_i;       // External Write Enable
   input [aw-1:0] 	 dbg_adr_i;	// External Address Input
   input [dw-1:0] 	 dbg_dat_i;	// External Data Input
   output [dw-1:0] 	 dbg_dat_o;	// External Data Output
   output 		 dbg_ack_o;	// External Data Acknowledge (not WB compatible)

`ifdef OR1200_BIST
   //
   // RAM BIST
   //
   input 		 mbist_si_i;
   input [`OR1200_MBIST_CTRL_WIDTH - 1:0] mbist_ctrl_i;
   output 				  mbist_so_o;
`endif

   //
   // Power Management
   //
   input 				  pm_cpustall_i;
   output [3:0] 			  pm_clksd_o;
   output 				  pm_dc_gate_o;
   output 				  pm_ic_gate_o;
   output 				  pm_dmmu_gate_o;
   output 				  pm_immu_gate_o;
   output 				  pm_tt_gate_o;
   output 				  pm_cpu_gate_o;
   output 				  pm_wakeup_o;
   output 				  pm_lvolt_o;

   // secure cl encryption
   output 				  seed_ram_access;   


   //
   // Internal wires and regs
   //

   //
   // DC to SB
   //
   wire [dw-1:0] 			  dcsb_dat_dc;
   wire [aw-1:0] 			  dcsb_adr_dc;
   wire 				  dcsb_cyc_dc;
   wire 				  dcsb_stb_dc;
   wire 				  dcsb_we_dc;
   wire [3:0] 				  dcsb_sel_dc;
   wire 				  dcsb_cab_dc;
   wire [dw-1:0] 			  dcsb_dat_sb;
   wire 				  dcsb_ack_sb;
   wire 				  dcsb_err_sb;

   //
   // SB to BIU
   //
   wire [dw-1:0] 			  sbbiu_dat_sb;
   wire [aw-1:0] 			  sbbiu_adr_sb;
   wire 				  sbbiu_cyc_sb;
   wire 				  sbbiu_stb_sb;
   wire 				  sbbiu_we_sb;
   wire [3:0] 				  sbbiu_sel_sb;
   wire 				  sbbiu_cab_sb;
   wire [dw-1:0] 			  sbbiu_dat_biu;
   wire 				  sbbiu_ack_biu;
   wire 				  sbbiu_err_biu;

   //
   // IC to BIU
   //
   wire [dw-1:0] 			  icbiu_dat_ic;
   wire [aw-1:0] 			  icbiu_adr_ic;
   wire [aw-1:0] 			  icbiu_adr_ic_word;
   wire 				  icbiu_cyc_ic;
   wire 				  icbiu_stb_ic;
   wire 				  icbiu_we_ic;
   wire [3:0] 				  icbiu_sel_ic;
   wire [3:0] 				  icbiu_tag_ic;
   wire 				  icbiu_cab_ic;
   wire [dw-1:0] 			  icbiu_dat_biu;
   wire 				  icbiu_ack_biu;
   wire 				  icbiu_err_biu;
   wire [3:0] 				  icbiu_tag_biu;

   //
   // SR Interface (this signal can be connected to the input pin)
   //
   wire 				  boot_adr_sel = `OR1200_SR_EPH_DEF;

   //
   // CPU's SPR access to various RISC units (shared wires)
   //
   wire 				  supv;
   wire [aw-1:0] 			  spr_addr;
   wire [dw-1:0] 			  spr_dat_cpu;
   wire [31:0] 				  spr_cs;
   wire 				  spr_we;
   wire 				  mtspr_dc_done;
   
   //
   // SB
   //
   wire 				  sb_en;

   //
   // DMMU and CPU
   //
   wire 				  dmmu_en;
   wire [31:0] 				  spr_dat_dmmu;

   //
   // DMMU and QMEM
   //
   wire 				  qmemdmmu_err_qmem;
   wire [3:0] 				  qmemdmmu_tag_qmem;
   wire [aw-1:0] 			  qmemdmmu_adr_dmmu;
   wire 				  qmemdmmu_cycstb_dmmu;
   wire 				  qmemdmmu_ci_dmmu;

   //
   // CPU and data memory subsystem
   //
   wire 				  dc_en;
   wire [31:0] 				  dcpu_adr_cpu;
   wire 				  dcpu_cycstb_cpu;
   wire 				  dcpu_we_cpu;
   wire [3:0] 				  dcpu_sel_cpu;
   wire [3:0] 				  dcpu_tag_cpu;
   wire [31:0] 				  dcpu_dat_cpu;
   wire [31:0] 				  dcpu_dat_qmem;
   wire 				  dcpu_ack_qmem;
   wire 				  dcpu_rty_qmem;
   wire 				  dcpu_err_dmmu;
   wire [3:0] 				  dcpu_tag_dmmu;
   wire 				  dc_no_writethrough;
   
   //
   // IMMU and CPU
   //
   wire 				  immu_en;
   wire [31:0] 				  spr_dat_immu;

   //
   // CPU and insn memory subsystem
   //
   wire 				  ic_en;
   wire [31:0] 				  icpu_adr_cpu;
   wire 				  icpu_cycstb_cpu;
   wire [3:0] 				  icpu_sel_cpu;
   wire [3:0] 				  icpu_tag_cpu;
   wire [31:0] 				  icpu_dat_qmem;
   wire 				  icpu_ack_qmem;
   wire [31:0] 				  icpu_adr_immu;
   wire 				  icpu_err_immu;
   wire [3:0] 				  icpu_tag_immu;
   wire 				  icpu_rty_immu;

   //
   // IMMU and QMEM
   //
   wire [aw-1:0] 			  qmemimmu_adr_immu;
   wire 				  qmemimmu_rty_qmem;
   wire 				  qmemimmu_err_qmem;
   wire [3:0] 				  qmemimmu_tag_qmem;
   wire 				  qmemimmu_cycstb_immu;
   wire 				  qmemimmu_ci_immu;

   //
   // QMEM and IC
   //
   wire [aw-1:0] 			  icqmem_adr_qmem;
   wire 				  icqmem_rty_ic;
   wire 				  icqmem_err_ic;
   wire [3:0] 				  icqmem_tag_ic;
   wire 				  icqmem_cycstb_qmem;
   wire 				  icqmem_ci_qmem;
   wire [31:0] 				  icqmem_dat_ic;
   wire 				  icqmem_ack_ic;

   //
   // QMEM and DC
   //
   wire [aw-1:0] 			  dcqmem_adr_qmem;
   wire 				  dcqmem_rty_dc;
   wire 				  dcqmem_err_dc;
   wire [3:0] 				  dcqmem_tag_dc;
   wire 				  dcqmem_cycstb_qmem;
   wire 				  dcqmem_ci_qmem;
   wire [31:0] 				  dcqmem_dat_dc;
   wire [31:0] 				  dcqmem_dat_qmem;
   wire 				  dcqmem_we_qmem;
   wire [3:0] 				  dcqmem_sel_qmem;
   wire 				  dcqmem_ack_dc;

   //
   // Connection between CPU and PIC
   //
   wire [dw-1:0] 			  spr_dat_pic;
   wire 				  pic_wakeup;
   wire 				  sig_int;

   //
   // Connection between CPU and PM
   //
   wire [dw-1:0] 			  spr_dat_pm;

   //
   // CPU and TT
   //
   wire [dw-1:0] 			  spr_dat_tt;
   output wire 				  sig_tick; // jb

   //
   // Debug port and caches/MMUs
   //
   wire [dw-1:0] 			  spr_dat_du;
   wire 				  du_stall;
   wire [dw-1:0] 			  du_addr;
   wire [dw-1:0] 			  du_dat_du;
   wire 				  du_read;
   wire 				  du_write;
   wire [13:0] 				  du_except_trig;
   wire [13:0] 				  du_except_stop;
   wire [`OR1200_DU_DSR_WIDTH-1:0] 	  du_dsr;
   wire [24:0] 				  du_dmr1;
   wire [dw-1:0] 			  du_dat_cpu;
   wire [dw-1:0] 			  du_lsu_store_dat;
   wire [dw-1:0] 			  du_lsu_load_dat;
   wire 				  du_hwbkpt;
   wire 				  du_hwbkpt_ls_r = 1'b0;
   wire 				  flushpipe;
   wire 				  ex_freeze;
   wire 				  wb_freeze;
   wire 				  id_void;
   wire 				  ex_void;
   wire [31:0] 				  id_insn;
   wire [31:0] 				  ex_insn;
   wire [31:0] 				  wb_insn;
   wire [31:0] 				  id_pc;
   wire [31:0] 				  ex_pc;
   wire [31:0] 				  wb_pc;
   wire [`OR1200_BRANCHOP_WIDTH-1:0] 	  branch_op;
   wire [31:0] 				  spr_dat_npc;
   wire [31:0] 				  rf_dataw;
   wire 				  abort_ex;
   wire 				  abort_mvspr;

`ifdef OR1200_BIST
   //
   // RAM BIST
   //
   wire 				  mbist_immu_so;
   wire 				  mbist_ic_so;
   wire 				  mbist_dmmu_so;
   wire 				  mbist_dc_so;
   wire 				  mbist_qmem_so;
   wire 				  mbist_immu_si = mbist_si_i;
   wire 				  mbist_ic_si = mbist_immu_so;
   wire 				  mbist_qmem_si = mbist_ic_so;
   wire 				  mbist_dmmu_si = mbist_qmem_so;
   wire 				  mbist_dc_si = mbist_dmmu_so;
   assign			mbist_so_o = mbist_dc_so;
`endif

   wire [3:0] 				  icqmem_sel_qmem;
   wire [3:0] 				  icqmem_tag_qmem;
   wire [3:0] 				  dcqmem_tag_qmem;

   wire [31:0] 				  stack_top;
   wire [31:0] 				  heap_top;   

   //
   // Instantiation of Instruction WISHBONE BIU
   //
   or1200_wb_biu
   iwb_biu(
	   // RISC clk, rst and clock control
	   .clk(clk_i),
	   .rst(rst_i),
	   .clmode(clmode_i),
	   .bl(1 << (`OR1200_ICLS-2)),
	   
	   // WISHBONE interface
	   .wb_clk_i(iwb_clk_i),
	   .wb_rst_i(iwb_rst_i),
	   .wb_ack_i(iwb_ack_i),
	   .wb_err_i(iwb_err_i),
	   .wb_rty_i(iwb_rty_i),
	   .wb_dat_i(iwb_dat_i),
	   .wb_cyc_o(iwb_cyc_o),
	   .wb_adr_o(iwb_adr_o),
	   .wb_stb_o(iwb_stb_o),
	   .wb_we_o(iwb_we_o),
	   .wb_sel_o(iwb_sel_o),
	   .wb_dat_o(iwb_dat_o),
`ifdef OR1200_WB_CAB
	   .wb_cab_o(iwb_cab_o),
`endif
`ifdef OR1200_WB_B3
	   .wb_cti_o(iwb_cti_o),
	   .wb_bte_o(iwb_bte_o),
`endif

	   // Internal RISC bus
	   .biu_dat_i(insn_diubiu_dat_diu),
	   .biu_adr_i(insn_diubiu_adr_diu),
	   .biu_cyc_i(insn_diubiu_cyc_diu & icbiu_cyc_ic),
	   .biu_stb_i(insn_diubiu_stb_diu & icbiu_stb_ic),
	   .biu_we_i(insn_diubiu_we_diu & icbiu_we_ic),
	   .biu_sel_i(insn_diubiu_sel_diu),
	   .biu_cab_i(insn_diubiu_cab_diu),
	   .biu_dat_o(insn_diubiu_dat_biu),
	   .biu_ack_o(insn_diubiu_ack_biu),
	   .biu_err_o(insn_diubiu_err_biu)
	   
	   );
   assign icbiu_adr_ic_word = {icbiu_adr_ic[31:2], 2'h0};

   //
   // Instantiation of Data WISHBONE BIU
   //

   wire [3:0] 				  bl_select;

   assign bl_select = seed_ram_access ?
		      (1 << (`SEEDBUF_LS-2)) : (1 << (`OR1200_DCLS-2));   
  
   or1200_wb_biu
   dwb_biu(
	   // RISC clk, rst and clock control
	   .clk(clk_i),
	   .rst(rst_i),
	   .clmode(clmode_i),
	   .bl(bl_select),

	   // WISHBONE interface
	   .wb_clk_i(dwb_clk_i),
	   .wb_rst_i(dwb_rst_i),
	   .wb_ack_i(dwb_ack_i),
	   .wb_err_i(dwb_err_i),
	   .wb_rty_i(dwb_rty_i),
	   .wb_dat_i(dwb_dat_i),
	   .wb_cyc_o(dwb_cyc_o),
	   .wb_adr_o(dwb_adr_o),
	   .wb_stb_o(dwb_stb_o),
	   .wb_we_o(dwb_we_o),
	   .wb_sel_o(dwb_sel_o),
	   .wb_dat_o(dwb_dat_o),
`ifdef OR1200_WB_CAB
	   .wb_cab_o(dwb_cab_o),
`endif
`ifdef OR1200_WB_B3
	   .wb_cti_o(dwb_cti_o),
	   .wb_bte_o(dwb_bte_o),
`endif

	   // Internal RISC bus
	   .biu_dat_i(data_diubiu_dat_diu),
	   .biu_adr_i(data_diubiu_adr_diu),
	   .biu_cyc_i(data_diubiu_cyc_diu & sbbiu_cyc_sb),
	   .biu_stb_i(data_diubiu_stb_diu & sbbiu_stb_sb),
	   .biu_we_i(data_diubiu_we_diu & sbbiu_we_sb),
	   .biu_sel_i(data_diubiu_sel_diu),
	   .biu_cab_i(data_diubiu_cab_diu),
	   .biu_dat_o(data_diubiu_dat_biu),
	   .biu_ack_o(data_diubiu_ack_biu),
	   .biu_err_o(data_diubiu_err_biu)	  
	   );

	   

   //
   // Instantiation of IMMU
   //
   or1200_immu_top
     #(.boot_adr(boot_adr))
   or1200_immu_top(
		   // Rst and clk
		   .clk(clk_i),
		   .rst(rst_i),

`ifdef OR1200_BIST
		   // RAM BIST
		   .mbist_si_i(mbist_immu_si),
		   .mbist_so_o(mbist_immu_so),
		   .mbist_ctrl_i(mbist_ctrl_i),
`endif

		   // CPU and IMMU
		   .ic_en(ic_en),
		   .immu_en(immu_en),
		   .supv(supv),
		   .icpu_adr_i(icpu_adr_cpu),
		   .icpu_cycstb_i(icpu_cycstb_cpu),
		   .icpu_adr_o(icpu_adr_immu),
		   .icpu_tag_o(icpu_tag_immu),
		   .icpu_rty_o(icpu_rty_immu),
		   .icpu_err_o(icpu_err_immu),

		   // SR Interface
		   .boot_adr_sel_i(boot_adr_sel),

		   // SPR access
		   .spr_cs(spr_cs[`OR1200_SPR_GROUP_IMMU]),
		   .spr_write(spr_we),
		   .spr_addr(spr_addr),
		   .spr_dat_i(spr_dat_cpu),
		   .spr_dat_o(spr_dat_immu),

		   // QMEM and IMMU
		   .qmemimmu_rty_i(qmemimmu_rty_qmem),
		   .qmemimmu_err_i(qmemimmu_err_qmem),
		   .qmemimmu_tag_i(qmemimmu_tag_qmem),
		   .qmemimmu_adr_o(qmemimmu_adr_immu),
		   .qmemimmu_cycstb_o(qmemimmu_cycstb_immu),
		   .qmemimmu_ci_o(qmemimmu_ci_immu)
		   );

   //
   // Instantiation of Instruction Cache
   //
   or1200_ic_top or1200_ic_top(
			       .clk(clk_i),
			       .rst(rst_i),

`ifdef OR1200_BIST
			       // RAM BIST
			       .mbist_si_i(mbist_ic_si),
			       .mbist_so_o(mbist_ic_so),
			       .mbist_ctrl_i(mbist_ctrl_i),
`endif

			       // IC and QMEM
			       .ic_en(ic_en),
			       .icqmem_adr_i(icqmem_adr_qmem),
			       .icqmem_cycstb_i(icqmem_cycstb_qmem),
			       .icqmem_ci_i(icqmem_ci_qmem),
			       .icqmem_sel_i(icqmem_sel_qmem),
			       .icqmem_tag_i(icqmem_tag_qmem),
			       .icqmem_dat_o(icqmem_dat_ic),
			       .icqmem_ack_o(icqmem_ack_ic),
			       .icqmem_rty_o(icqmem_rty_ic),
			       .icqmem_err_o(icqmem_err_ic),
			       .icqmem_tag_o(icqmem_tag_ic),

			       // SPR access
			       .spr_cs(spr_cs[`OR1200_SPR_GROUP_IC]),
			       .spr_write(spr_we),
			       .spr_dat_i(spr_dat_cpu),
					 
`ifdef CYPHERDB_PERFORMANCE_COUNTER
			       // icache perf counter
			       .icfsm_perf_en(dcfsm_perf_en), //should be icfsm_perf_en
			       .icfsm_perf_start(dcfsm_perf_start),  //should be icfsm_perf_en
			       .icfsm_perf_icache_miss_count(),
			       .icfsm_perf_icache_hit_count(),			       
`endif					 

			       // IC and BIU
			       .icbiu_dat_o(icbiu_dat_ic),
			       .icbiu_adr_o(icbiu_adr_ic),
			       .icbiu_cyc_o(icbiu_cyc_ic),
			       .icbiu_stb_o(icbiu_stb_ic),
			       .icbiu_we_o(icbiu_we_ic),
			       .icbiu_sel_o(icbiu_sel_ic),
			       .icbiu_cab_o(icbiu_cab_ic),
			       .icbiu_dat_i(icbiu_dat_biu),
			       .icbiu_ack_i(icbiu_ack_biu),
			       .icbiu_err_i(icbiu_err_biu)
			       );

   wire 				  secure_exec;
   wire 				  seed_ram_init;   

   //
   // Instantiation of Instruction Cache
   //
   or1200_cpu
     #(.boot_adr(boot_adr))
   or1200_cpu(
			.aes_clk(aes_clk_i),
	      .clk(clk_i),
	      .rst(rst_i),

	      // Connection QMEM and IFETCHER inside CPU
	      .ic_en(ic_en),
	      .icpu_adr_o(icpu_adr_cpu),
	      .icpu_cycstb_o(icpu_cycstb_cpu),
	      .icpu_sel_o(icpu_sel_cpu),
	      .icpu_tag_o(icpu_tag_cpu),
	      .icpu_dat_i(icpu_dat_qmem),
	      .icpu_ack_i(icpu_ack_qmem),
	      .icpu_rty_i(icpu_rty_immu),
	      .icpu_adr_i(icpu_adr_immu),
	      .icpu_err_i(icpu_err_immu),
	      .icpu_tag_i(icpu_tag_immu),

	      // Connection CPU to external Debug port
	      .id_void(id_void),
	      .id_insn(id_insn),
	      .ex_void(ex_void),
	      .ex_insn(ex_insn),
	      .ex_freeze(ex_freeze),
	      .wb_insn(wb_insn),
	      .wb_freeze(wb_freeze),
	      .id_pc(id_pc),
	      .ex_pc(ex_pc),
	      .wb_pc(wb_pc),
	      .branch_op(branch_op),
	      .rf_dataw(rf_dataw),
	      .ex_flushpipe(flushpipe),
	      .du_stall(du_stall),
	      .du_addr(du_addr),
	      .du_dat_du(du_dat_du),
	      .du_read(du_read),
	      .du_write(du_write),
	      .du_except_trig(du_except_trig),
	      .du_except_stop(du_except_stop),
	      .du_dsr(du_dsr),
	      .du_dmr1(du_dmr1),
	      .du_hwbkpt(du_hwbkpt),
	      .du_hwbkpt_ls_r(du_hwbkpt_ls_r),
	      .du_dat_cpu(du_dat_cpu),
	      .du_lsu_store_dat(du_lsu_store_dat),
	      .du_lsu_load_dat(du_lsu_load_dat),
	      .abort_mvspr(abort_mvspr),
	      .abort_ex(abort_ex),

	      // Connection IMMU and CPU internally
	      .immu_en(immu_en),

	      // Connection QMEM and CPU
	      .dc_en(dc_en),
	      .dcpu_adr_o(dcpu_adr_cpu),
	      .dcpu_cycstb_o(dcpu_cycstb_cpu),
	      .dcpu_we_o(dcpu_we_cpu),
	      .dcpu_sel_o(dcpu_sel_cpu),
	      .dcpu_tag_o(dcpu_tag_cpu),
	      .dcpu_dat_o(dcpu_dat_cpu),
              .dcpu_dat_i(dcpu_dat_qmem),
	      .dcpu_ack_i(dcpu_ack_qmem),
	      .dcpu_rty_i(dcpu_rty_qmem),
	      .dcpu_err_i(dcpu_err_dmmu),
	      .dcpu_tag_i(dcpu_tag_dmmu),
	      .dc_no_writethrough(dc_no_writethrough),

	      // Connection DMMU and CPU internally
	      .dmmu_en(dmmu_en),

	      // SR Interface
	      .boot_adr_sel_i(boot_adr_sel),

	      // SB Enable
	      .sb_en(sb_en),

	      // Connection PIC and CPU's EXCEPT
	      .sig_int(sig_int),
	      .sig_tick(sig_tick),

	      // SPRs
	      .supv(supv),
	      .spr_addr(spr_addr),
	      .spr_dat_cpu(spr_dat_cpu),
	      .spr_dat_pic(spr_dat_pic),
	      .spr_dat_tt(spr_dat_tt),
	      .spr_dat_pm(spr_dat_pm),
	      .spr_dat_dmmu(spr_dat_dmmu),
	      .spr_dat_immu(spr_dat_immu),
	      .spr_dat_du(spr_dat_du),
	      .spr_dat_npc(spr_dat_npc),
	      .spr_cs(spr_cs),
	      .spr_we(spr_we),
              .mtspr_dc_done(mtspr_dc_done),

`ifdef CYPHERDB_PERFORMANCE_COUNTER
	      .pc_start_o(perf_start),
	      .pc_end_o(perf_end),
	      .pc_en_o(perf_en),
	      .pc_operand_o(perf_operand),
	      .perf_delayed_ack_load(perf_delayed_ack_load),
	      .perf_delayed_ack_store(perf_delayed_ack_store),
			.perf_id_freeze(perf_id_freeze),
`endif
	      
	      // enable signal to cache line encryption module
	      .seed_cache_init_stall(seed_cache_during_init),
`ifdef onchip_seed_vector     
	      .seed_vector_init_stall(seed_vector_during_init),
`elsif offchip_seed_init
	      .seed_vector_init_stall(seed_ram_during_init),
`endif	      	      
	      .seed_init(seed_init),
	      .seed_ram_init(seed_ram_init),
	      .secure_exec(secure_exec),
	      .stack_top(stack_top),
	      .heap_top(heap_top)
	      );

   wire 				  seed_init;   
   wire 				  seed_init_done;
   wire 				  seed_cache_during_init;
   wire [`SEEDBUF_INDXH:`SEEDBUF_LS] 	  seed_tag_addr_init;   
   
   seed_cache_init seed_cache_init(
				   .clk(clk_i),
				   .rst(rst_i),
				   .seed_tag_addr_out(seed_tag_addr_init),
				   .trigger_pulse(seed_init),
				   .done(seed_init_done),
				   .seed_during_init(seed_cache_during_init)
				   );
   
   //
   // Instantiation of DMMU
   //
   or1200_dmmu_top or1200_dmmu_top(
				   // Rst and clk
				   .clk(clk_i),
				   .rst(rst_i),

`ifdef OR1200_BIST
				   // RAM BIST
				   .mbist_si_i(mbist_dmmu_si),
				   .mbist_so_o(mbist_dmmu_so),
				   .mbist_ctrl_i(mbist_ctrl_i),
`endif

				   // CPU i/f
				   .dc_en(dc_en),
				   .dmmu_en(dmmu_en),
				   .supv(supv),
				   .dcpu_adr_i(dcpu_adr_cpu),
				   .dcpu_cycstb_i(dcpu_cycstb_cpu),
				   .dcpu_we_i(dcpu_we_cpu),
				   .dcpu_tag_o(dcpu_tag_dmmu),
				   .dcpu_err_o(dcpu_err_dmmu),

				   // SPR access
				   .spr_cs(spr_cs[`OR1200_SPR_GROUP_DMMU]),
				   .spr_write(spr_we),
				   .spr_addr(spr_addr),
				   .spr_dat_i(spr_dat_cpu),
				   .spr_dat_o(spr_dat_dmmu),

				   // QMEM and DMMU
				   .qmemdmmu_err_i(qmemdmmu_err_qmem),
				   .qmemdmmu_tag_i(qmemdmmu_tag_qmem),
				   .qmemdmmu_adr_o(qmemdmmu_adr_dmmu),
				   .qmemdmmu_cycstb_o(qmemdmmu_cycstb_dmmu),
				   .qmemdmmu_ci_o(qmemdmmu_ci_dmmu),
				   );

   //
   // Instantiation of Data Cache
   //
   or1200_dc_top or1200_dc_top(
			       .aes_clk(aes_clk_i),
			       .clk(clk_i),
			       .rst(rst_i),

			       .dcpu_vadr(dcpu_adr_cpu),

`ifdef OR1200_BIST
			       // RAM BIST
			       .mbist_si_i(mbist_dc_si),
			       .mbist_so_o(mbist_dc_so),
			       .mbist_ctrl_i(mbist_ctrl_i),
`endif

			       // DC and QMEM
			       .dc_en(dc_en),
			       .dcqmem_adr_i(dcqmem_adr_qmem),
			       .dcqmem_cycstb_i(dcqmem_cycstb_qmem),
			       .dcqmem_ci_i(dcqmem_ci_qmem),
			       .dcqmem_we_i(dcqmem_we_qmem),
			       .dcqmem_sel_i(dcqmem_sel_qmem),
			       .dcqmem_tag_i(dcqmem_tag_qmem),
			       .dcqmem_dat_i(dcqmem_dat_qmem),
			       .dcqmem_dat_o(dcqmem_dat_dc),
			       .dcqmem_ack_o(dcqmem_ack_dc),
			       .dcqmem_rty_o(dcqmem_rty_dc),
			       .dcqmem_err_o(dcqmem_err_dc),
			       .dcqmem_tag_o(dcqmem_tag_dc),

			       .dc_no_writethrough(dc_no_writethrough),

			       // SPR access
			       .spr_cs(spr_cs[`OR1200_SPR_GROUP_DC]),
			       .spr_addr(spr_addr),
			       .spr_write(spr_we),
			       .spr_dat_i(spr_dat_cpu),
			       .mtspr_dc_done(mtspr_dc_done),

			       // DC and BIU
			       .dcsb_dat_o(dcsb_dat_dc),
			       .dcsb_adr_o(dcsb_adr_dc),
			       .dcsb_cyc_o(dcsb_cyc_dc),
			       .dcsb_stb_o(dcsb_stb_dc),
			       .dcsb_we_o(dcsb_we_dc),
			       .dcsb_sel_o(dcsb_sel_dc),
			       .dcsb_cab_o(dcsb_cab_dc),
			       .dcsb_dat_i(dcsb_dat_sb),
			       .dcsb_ack_i(dcsb_ack_sb),
			       .dcsb_err_i(dcsb_err_sb),

			       
`ifdef CYPHERDB_PERFORMANCE_COUNTER
			       // dcache and seedcache perf counter
			       .dcfsm_perf_en(dcfsm_perf_en),
			       .dcfsm_perf_start(dcfsm_perf_start),
			       .dcfsm_perf_dcache_miss_count(dcfsm_perf_dcache_miss_count),
			       .dcfsm_perf_dcache_hit_count(dcfsm_perf_dcache_hit_count),
			       .dcfsm_perf_dcache_wb_count(dcfsm_perf_dcache_wb_count),
			       .dcfsm_perf_dcache_flush_count(dcfsm_perf_dcache_flush_count),
			       .dcfsm_perf_seedcache_access_count(dcfsm_perf_seedcache_access_count),
			       .dcfsm_perf_seedcache_miss_count(dcfsm_perf_seedcache_miss_count),
			       .dcfsm_perf_seedcache_hit_count(dcfsm_perf_seedcache_hit_count),
			       .dcfsm_perf_seedcache_wb_count(dcfsm_perf_seedcache_wb_count),  
`endif

			       // To cl enc module
			       .seed_ram_init(seed_ram_init),
			       .seed_tag_addr_init(seed_tag_addr_init),	
			       .seed_during_init(seed_cache_during_init),
			       .seed_vector_during_init(seed_vector_during_init),
			       .secure_exec(secure_exec),
			       .seed_ram_access(seed_ram_access),
			       .stack_top(stack_top),
			       .heap_top(heap_top)
			       );

   //
   // Instantiation of embedded memory - qmem
   //
   or1200_qmem_top or1200_qmem_top(
				   .clk(clk_i),
				   .rst(rst_i),

`ifdef OR1200_BIST
				   // RAM BIST
				   .mbist_si_i(mbist_qmem_si),
				   .mbist_so_o(mbist_qmem_so),
				   .mbist_ctrl_i(mbist_ctrl_i),
`endif

				   // QMEM and CPU/IMMU
				   .qmemimmu_adr_i(qmemimmu_adr_immu),
				   .qmemimmu_cycstb_i(qmemimmu_cycstb_immu),
				   .qmemimmu_ci_i(qmemimmu_ci_immu),
				   .qmemicpu_sel_i(icpu_sel_cpu),
				   .qmemicpu_tag_i(icpu_tag_cpu),
				   .qmemicpu_dat_o(icpu_dat_qmem),
				   .qmemicpu_ack_o(icpu_ack_qmem),
				   .qmemimmu_rty_o(qmemimmu_rty_qmem),
				   .qmemimmu_err_o(qmemimmu_err_qmem),
				   .qmemimmu_tag_o(qmemimmu_tag_qmem),

				   // QMEM and IC
				   .icqmem_adr_o(icqmem_adr_qmem),
				   .icqmem_cycstb_o(icqmem_cycstb_qmem),
				   .icqmem_ci_o(icqmem_ci_qmem),
				   .icqmem_sel_o(icqmem_sel_qmem),
				   .icqmem_tag_o(icqmem_tag_qmem),
				   .icqmem_dat_i(icqmem_dat_ic),
				   .icqmem_ack_i(icqmem_ack_ic),
				   .icqmem_rty_i(icqmem_rty_ic),
				   .icqmem_err_i(icqmem_err_ic),
				   .icqmem_tag_i(icqmem_tag_ic),

				   // QMEM and CPU/DMMU
				   .qmemdmmu_adr_i(qmemdmmu_adr_dmmu),
				   .qmemdmmu_cycstb_i(qmemdmmu_cycstb_dmmu),
				   .qmemdmmu_ci_i(qmemdmmu_ci_dmmu),
				   .qmemdcpu_we_i(dcpu_we_cpu),
				   .qmemdcpu_sel_i(dcpu_sel_cpu),
				   .qmemdcpu_tag_i(dcpu_tag_cpu),
				   .qmemdcpu_dat_i(dcpu_dat_cpu),
				   .qmemdcpu_dat_o(dcpu_dat_qmem),
				   .qmemdcpu_ack_o(dcpu_ack_qmem),
				   .qmemdcpu_rty_o(dcpu_rty_qmem),
				   .qmemdmmu_err_o(qmemdmmu_err_qmem),
				   .qmemdmmu_tag_o(qmemdmmu_tag_qmem),

				   // QMEM and DC
				   .dcqmem_adr_o(dcqmem_adr_qmem),
				   .dcqmem_cycstb_o(dcqmem_cycstb_qmem),
				   .dcqmem_ci_o(dcqmem_ci_qmem),
				   .dcqmem_we_o(dcqmem_we_qmem),
				   .dcqmem_sel_o(dcqmem_sel_qmem),
				   .dcqmem_tag_o(dcqmem_tag_qmem),
				   .dcqmem_dat_o(dcqmem_dat_qmem),
				   .dcqmem_dat_i(dcqmem_dat_dc),
				   .dcqmem_ack_i(dcqmem_ack_dc),
				   .dcqmem_rty_i(dcqmem_rty_dc),
				   .dcqmem_err_i(dcqmem_err_dc),
				   .dcqmem_tag_i(dcqmem_tag_dc)
				   );

   //
   // MUX to SB
   //
   wire [dw-1:0] 			  dcsb_dat_mux_i;
   wire [aw-1:0] 			  dcsb_adr_mux;
   wire 				  dcsb_cyc_mux;
   wire 				  dcsb_stb_mux;
   wire 				  dcsb_we_mux;
   wire [3:0] 				  dcsb_sel_mux;
   wire 				  dcsb_cab_mux;
   wire [dw-1:0] 			  dcsb_dat_mux_o;
   wire 				  dcsb_ack_mux;
   wire 				  dcsb_err_mux;

   
`ifdef offchip_seed_init

   wire 				  seed_ram_during_init;
   
   wire [dw-1:0] 			  seedInit_dat;
   wire [aw-1:0] 			  seedInit_adr;
   wire 				  seedInit_cyc;
   wire 				  seedInit_stb;
   wire 				  seedInit_we;
   wire [3:0] 				  seedInit_sel;
   wire 				  seedInit_cab;
   wire 				  seedInit_ack;
   wire 				  seedInit_err;

   seed_ram_init_core
     seed_ram_init_core (
		    .clk(clk_i),
		    .rst(rst_i),

		    .seedInit_dat_o(seedInit_dat),
		    .seedInit_adr_o(seedInit_adr),
		    .seedInit_cyc_o(seedInit_cyc),
		    .seedInit_stb_o(seedInit_stb),
		    .seedInit_we_o(seedInit_we),
		    .seedInit_sel_o(seedInit_sel),
		    .seedInit_cab_o(seedInit_cab),
		    .seedInit_ack_i(dcsb_ack_mux),
		    .seedInit_err_i(dcsb_err_mux),

		    .trigger_pulse(seed_ram_init),
		    .seed_ram_during_init(seed_ram_during_init)
		    );   
   
   // SEED_INIT_CORE <-> MUX
   assign dcsb_dat_mux_i = seed_ram_during_init ? 
			   seedInit_dat :dcsb_dat_dc;
   assign dcsb_adr_mux = seed_ram_during_init ?
			 seedInit_adr : dcsb_adr_dc;
   assign dcsb_cyc_mux = seed_ram_during_init ?
			 seedInit_cyc : dcsb_cyc_dc;
   assign dcsb_stb_mux = seed_ram_during_init ?
			 seedInit_stb : dcsb_stb_dc;
   assign dcsb_we_mux = seed_ram_during_init ?
			seedInit_we : dcsb_we_dc;
   assign dcsb_sel_mux = seed_ram_during_init ?
			 seedInit_sel : dcsb_sel_dc;
   assign dcsb_cab_mux =seed_ram_during_init ?
			seedInit_cab :  dcsb_cab_dc;
   assign dcsb_dat_sb = dcsb_dat_mux_o; 
   assign dcsb_ack_sb = seed_ram_during_init ?
			1'b0 : dcsb_ack_mux;
   assign dcsb_err_sb = seed_ram_during_init ?
			1'b0 : dcsb_err_mux;  

`endif
   
 `ifdef onchip_seed_vector
   // DC <-> MUX
   assign dcsb_dat_mux_i = dcsb_dat_dc;
   assign dcsb_adr_mux = dcsb_adr_dc;
   assign dcsb_cyc_mux = dcsb_cyc_dc;
   assign dcsb_stb_mux = dcsb_stb_dc;
   assign dcsb_we_mux = dcsb_we_dc;
   assign dcsb_sel_mux = dcsb_sel_dc;
   assign dcsb_cab_mux = dcsb_cab_dc;
   assign dcsb_dat_sb = dcsb_dat_mux_o; 
   assign dcsb_ack_sb = dcsb_ack_mux;
   assign dcsb_err_sb = dcsb_err_mux;   
`endif   
   
   //
   // Instantiation of Store Buffer
   //
   or1200_sb or1200_sb(
		       // RISC clock, reset
		       .clk(clk_i),
		       .rst(rst_i),

		       // Internal RISC bus (SB)
		       .sb_en(sb_en),

		       // Internal RISC bus (MUX<->SB)
		       .dcsb_dat_i(dcsb_dat_mux_i),
		       .dcsb_adr_i(dcsb_adr_mux),
		       .dcsb_cyc_i(dcsb_cyc_mux),
		       .dcsb_stb_i(dcsb_stb_mux),
		       .dcsb_we_i(dcsb_we_mux),
		       .dcsb_sel_i(dcsb_sel_mux),
		       .dcsb_cab_i(dcsb_cab_mux),
		       .dcsb_dat_o(dcsb_dat_mux_o),
		       .dcsb_ack_o(dcsb_ack_mux),
		       .dcsb_err_o(dcsb_err_mux),

		       // SB and BIU
		       .sbbiu_dat_o(sbbiu_dat_sb),
		       .sbbiu_adr_o(sbbiu_adr_sb),
		       .sbbiu_cyc_o(sbbiu_cyc_sb),
		       .sbbiu_stb_o(sbbiu_stb_sb),
		       .sbbiu_we_o(sbbiu_we_sb),
		       .sbbiu_sel_o(sbbiu_sel_sb),
		       .sbbiu_cab_o(sbbiu_cab_sb),
		       .sbbiu_dat_i(sbbiu_dat_biu),
		       .sbbiu_ack_i(sbbiu_ack_biu),
		       .sbbiu_err_i(sbbiu_err_biu)
		       );

   /**** module for injecting delay to external memory access ***/
   /** description: delay injection unit: diu **/
   /** data cache to RAM **/
   
   wire [dw-1:0] 			  data_diubiu_dat_diu;
   wire [aw-1:0] 			  data_diubiu_adr_diu;
   wire 				  data_diubiu_cyc_diu;
   wire 				  data_diubiu_stb_diu;
   wire 				  data_diubiu_we_diu;
   wire [3:0] 				  data_diubiu_sel_diu;
   wire 				  data_diubiu_cab_diu;
   wire [dw-1:0] 			  data_diubiu_dat_biu;
   wire 				  data_diubiu_ack_biu;
   wire 				  data_diubiu_err_biu;

   assign data_diubiu_dat_diu = sbbiu_dat_sb;   
   assign data_diubiu_adr_diu = sbbiu_adr_sb;
   assign sbbiu_dat_biu = data_diubiu_dat_biu;
   assign data_diubiu_sel_diu = sbbiu_sel_sb;   
   assign data_diubiu_cab_diu = sbbiu_cab_sb;  
   
   assign sbbiu_ack_biu = data_diubiu_ack_biu;
   assign sbbiu_err_biu = data_diubiu_err_biu;   
   
`ifdef DC_RAM_DELAY

   wire 				  dc_diubiu_cyc_diu_load;
   wire 				  dc_diubiu_stb_diu_load;
   wire 				  dc_diubiu_cyc_diu_store;
   wire 				  dc_diubiu_stb_diu_store;
   wire 				  dc_load_delay_en;
   wire 				  dc_store_delay_en;

   wire 				  dc_diubiu_cyc;
   wire 				  dc_diubiu_stb;
   wire 				  seed_diubiu_cyc;
   wire 				  seed_diubiu_stb;

   assign dc_diubiu_cyc = sbbiu_we_sb ? dc_diubiu_cyc_diu_store : dc_diubiu_cyc_diu_load;
   assign dc_diubiu_stb = sbbiu_we_sb ? dc_diubiu_stb_diu_store : dc_diubiu_stb_diu_load;
   assign seed_diubiu_cyc = sbbiu_we_sb? seed_diubiu_cyc_diu_store : seed_diubiu_cyc_diu_load;   
   assign seed_diubiu_stb = sbbiu_we_sb? seed_diubiu_stb_diu_store : seed_diubiu_stb_diu_load;   
   
   assign data_diubiu_cyc_diu = (dc_en & !seed_ram_during_init) ? (seed_ram_access ? seed_diubiu_cyc : dc_diubiu_cyc) : sbbiu_cyc_sb;
   
   assign data_diubiu_stb_diu = (dc_en & !seed_ram_during_init) ? (seed_ram_access ? seed_diubiu_stb : dc_diubiu_stb) : sbbiu_stb_sb;
   
   assign data_diubiu_we_diu = !seed_ram_during_init ? (seed_ram_access ? seed_diubiu_we_diu : dc_diubiu_we_diu) : sbbiu_we_sb;

   assign dc_load_delay_en = !seed_ram_during_init & !seed_ram_access & !sbbiu_we_sb & dc_en;
   assign dc_store_delay_en = !seed_ram_during_init & !seed_ram_access & sbbiu_we_sb & dc_en;   
   
   ramwb_input_delay #(
		       .delay_cycles (`RAM_DELAY_LOAD_CYCLES),
		       .cacheLineSize((1<<(`OR1200_DCLS-2))-1)
		       )
   dc_biu2wb_loadDelay (
			.clk(clk_i),
			.rst(rst_i | seed_ram_access | seed_ram_during_init),
			.en(dc_load_delay_en),
			.refresh(data_diubiu_ack_biu),
			.ci(dcqmem_ci_qmem),
			.biu_cyc_i(sbbiu_cyc_sb), 
			.biu_stb_i(sbbiu_stb_sb), 
			.biu_we_i(1'b0), 
			.delayed_biu_cyc_o(dc_diubiu_cyc_diu_load), 
			.delayed_biu_stb_o(dc_diubiu_stb_diu_load),
			.delayed_biu_we_o()
		   );  

   ramwb_input_delay #(
		       .delay_cycles (`RAM_DELAY_WRITE_CYCLES),
		       .cacheLineSize((1<<(`OR1200_DCLS-2))-1)
		       )
     dc_biu2wb_writeDelay (
			  .clk(clk_i),
			  .rst(rst_i | seed_ram_access | seed_ram_during_init),
			  .en(dc_store_delay_en),
			  .refresh(data_diubiu_ack_biu),
			  .ci(dcqmem_ci_qmem),
			  .biu_cyc_i(sbbiu_cyc_sb), 
			  .biu_stb_i(sbbiu_stb_sb), 
			  .biu_we_i(sbbiu_we_sb), 
			  .delayed_biu_cyc_o(dc_diubiu_cyc_diu_store), 
			  .delayed_biu_stb_o(dc_diubiu_stb_diu_store),
			  .delayed_biu_we_o(dc_diubiu_we_diu)
		   );

   // delay modules for seed access
   
   wire 				  seed_diubiu_cyc_diu_load;
   wire 				  seed_diubiu_stb_diu_load;
   wire 				  seed_diubiu_cyc_diu_store;
   wire 				  seed_diubiu_stb_diu_store;
   wire 				  seed_diubiu_we_diu;   
   wire 				  seed_load_delay_en;
   wire 				  seed_store_delay_en;

   assign seed_load_delay_en = !seed_ram_during_init & seed_ram_access & !sbbiu_we_sb & dc_en;
   assign seed_store_delay_en = !seed_ram_during_init & seed_ram_access & sbbiu_we_sb & dc_en;   

   ramwb_input_delay #(
   		       .delay_cycles (`RAM_DELAY_LOAD_CYCLES),
   		       .cacheLineSize((1<<(`SEEDBUF_LS-2))-1)
   		       )
   seed_biu2wb_loadDelay (
   			  .clk(clk_i),
   			  .rst(rst_i),
   			  .en(seed_load_delay_en),
   			  .refresh(data_diubiu_ack_biu),
   			  .ci(1'b0),
   			  .biu_cyc_i(sbbiu_cyc_sb), 
   			  .biu_stb_i(sbbiu_stb_sb), 
   			  .biu_we_i(1'b0), 
   			  .delayed_biu_cyc_o(seed_diubiu_cyc_diu_load), 
   			  .delayed_biu_stb_o(seed_diubiu_stb_diu_load),
   			  .delayed_biu_we_o()
   			  );

      ramwb_input_delay #(
   		       .delay_cycles (`RAM_DELAY_LOAD_CYCLES),
   		       .cacheLineSize((1<<(`SEEDBUF_LS-2))-1)
   		       )
   seed_biu2wb_writeDelay (
   			  .clk(clk_i),
   			  .rst(rst_i),
   			  .en(seed_store_delay_en),
   			  .refresh(data_diubiu_ack_biu),
   			  .ci(1'b0),
   			  .biu_cyc_i(sbbiu_cyc_sb), 
   			  .biu_stb_i(sbbiu_stb_sb), 
   			  .biu_we_i(sbbiu_we_sb), 
   			  .delayed_biu_cyc_o(seed_diubiu_cyc_diu_store), 
   			  .delayed_biu_stb_o(seed_diubiu_stb_diu_store),
   			  .delayed_biu_we_o(seed_diubiu_we_diu)
   			  );  
`else
   assign data_diubiu_cyc_diu = sbbiu_cyc_sb;
   assign data_diubiu_stb_diu = sbbiu_stb_sb;
   assign data_diubiu_we_diu = sbbiu_we_sb;
`endif // !`ifdef DC_RAM_DELAY

   /** instruction cache to RAM **/
   /** insn cache to biu **/
   wire [dw-1:0] 			  insn_diubiu_dat_diu;
   wire [aw-1:0] 			  insn_diubiu_adr_diu;
   wire 				 insn_diubiu_cyc_diu;
   wire 				  insn_diubiu_stb_diu;
   wire 				  insn_diubiu_we_diu;
   wire [3:0] 				 insn_diubiu_sel_diu;
   wire 				  insn_diubiu_cab_diu;
   wire [dw-1:0] 			  insn_diubiu_dat_biu;
   wire 				  insn_diubiu_ack_biu;
   wire 				  insn_diubiu_err_biu;
   wire 				  ic_delay_en;   
   
   assign insn_diubiu_dat_diu = icbiu_dat_ic;   
   assign insn_diubiu_adr_diu = icbiu_adr_ic;
   assign icbiu_dat_biu = insn_diubiu_dat_biu;
   assign icbiu_ack_biu = insn_diubiu_ack_biu;
   assign icbiu_err_biu = insn_diubiu_err_biu;
   assign insn_diubiu_we_diu = icbiu_we_ic;
   assign insn_diubiu_sel_diu = icbiu_sel_ic;
   assign insn_diubiu_cab_diu = icbiu_cab_ic;

`ifdef IC_RAM_DELAY
   
   assign ic_delay_en = !icbiu_we_ic & ic_en;
   
   assign insn_diubiu_cyc_diu = ic_en ? 
				ic_diubiu_cyc_diu : icbiu_cyc_ic;   
   assign insn_diubiu_stb_diu = ic_en? 
				ic_diubiu_stb_diu : icbiu_cyc_ic; 
   
   ramwb_input_delay #(
		       .delay_cycles (`RAM_DELAY_LOAD_CYCLES),
		       .cacheLineSize((1<<(`OR1200_ICLS-2))-1)
		       )
     ic_biu2wb_delay (
		      .clk(clk_i),
		      .rst(rst_i),
		      .en(ic_delay_en),
		      .refresh(insn_diubiu_ack_biu),
		      .ci(1'b0),
		      .biu_cyc_i(icbiu_cyc_ic), 		      
		      .biu_stb_i(icbiu_stb_ic), 
		      .biu_we_i(icbiu_we_ic), 		      
		      .delayed_biu_cyc_o(ic_diubiu_cyc_diu), 		     
		      .delayed_biu_stb_o(ic_diubiu_stb_diu), 
		      .delayed_biu_we_o()		     
		      );    
   
`else
   assign insn_diubiu_cyc_diu = icbiu_cyc_ic;
   assign insn_diubiu_stb_diu = icbiu_stb_ic;
`endif
   

      /**** module for injecting delay to external memory access ***/

   //
   // Instantiation of Debug Unit
   //
   or1200_du or1200_du(
		       // RISC Internal Interface
		       .clk(clk_i),
		       .rst(rst_i),
		       .dcpu_cycstb_i(dcpu_cycstb_cpu),
		       .dcpu_we_i(dcpu_we_cpu),
		       .dcpu_adr_i(dcpu_adr_cpu),
		       .dcpu_dat_lsu(dcpu_dat_cpu),
		       .dcpu_dat_dc(dcpu_dat_qmem),
		       .icpu_cycstb_i(icpu_cycstb_cpu),
		       .ex_freeze(ex_freeze),
		       .branch_op(branch_op),
		       .ex_insn(ex_insn),
		       .id_pc(id_pc),
		       .du_dsr(du_dsr),
		       .du_dmr1(du_dmr1),

		       // For Trace buffer
		       .spr_dat_npc(spr_dat_npc),
		       .rf_dataw(rf_dataw),

		       // DU's access to SPR unit
		       .du_stall(du_stall),
		       .du_addr(du_addr),
		       .du_dat_i(du_dat_cpu),
		       .du_dat_o(du_dat_du),
		       .du_read(du_read),
		       .du_write(du_write),
		       .du_except_stop(du_except_stop),
		       .du_hwbkpt(du_hwbkpt),

		       // Access to DU's SPRs
		       .spr_cs(spr_cs[`OR1200_SPR_GROUP_DU]),
		       .spr_write(spr_we),
		       .spr_addr(spr_addr),
		       .spr_dat_i(spr_dat_cpu),
		       .spr_dat_o(spr_dat_du),

		       // External Debug Interface
		       .dbg_stall_i(dbg_stall_i),
		       .dbg_ewt_i(dbg_ewt_i),
		       .dbg_lss_o(dbg_lss_o),
		       .dbg_is_o(dbg_is_o),
		       .dbg_wp_o(dbg_wp_o),
		       .dbg_bp_o(dbg_bp_o),
		       .dbg_stb_i(dbg_stb_i),
		       .dbg_we_i(dbg_we_i),
		       .dbg_adr_i(dbg_adr_i),
		       .dbg_dat_i(dbg_dat_i),
		       .dbg_dat_o(dbg_dat_o),
		       .dbg_ack_o(dbg_ack_o)
		       );

   //
   // Programmable interrupt controller
   //
   or1200_pic or1200_pic(
			 // RISC Internal Interface
			 .clk(clk_i),
			 .rst(rst_i),
			 .spr_cs(spr_cs[`OR1200_SPR_GROUP_PIC]),
			 .spr_write(spr_we),
			 .spr_addr(spr_addr),
			 .spr_dat_i(spr_dat_cpu),
			 .spr_dat_o(spr_dat_pic),
			 .pic_wakeup(pic_wakeup),
			 .intr(sig_int), 

			 // PIC Interface
			 .pic_int(pic_ints_i)
			 );

   //
   // Instantiation of Tick timer
   //
   or1200_tt or1200_tt(
		       // RISC Internal Interface
		       .clk(clk_i),
		       .rst(rst_i),
		       .du_stall(du_stall),
		       .spr_cs(spr_cs[`OR1200_SPR_GROUP_TT]),
		       .spr_write(spr_we),
		       .spr_addr(spr_addr),
		       .spr_dat_i(spr_dat_cpu),
		       .spr_dat_o(spr_dat_tt),
		       .intr(sig_tick)
		       );

   //
   // Instantiation of Power Management
   //
   or1200_pm or1200_pm(
		       // RISC Internal Interface
		       .clk(clk_i),
		       .rst(rst_i),
		       .pic_wakeup(pic_wakeup),
		       .spr_write(spr_we),
		       .spr_addr(spr_addr),
		       .spr_dat_i(spr_dat_cpu),
		       .spr_dat_o(spr_dat_pm),

		       // Power Management Interface
		       .pm_cpustall(pm_cpustall_i),
		       .pm_clksd(pm_clksd_o),
		       .pm_dc_gate(pm_dc_gate_o),
		       .pm_ic_gate(pm_ic_gate_o),
		       .pm_dmmu_gate(pm_dmmu_gate_o),
		       .pm_immu_gate(pm_immu_gate_o),
		       .pm_tt_gate(pm_tt_gate_o),
		       .pm_cpu_gate(pm_cpu_gate_o),
		       .pm_wakeup(pm_wakeup_o),
		       .pm_lvolt(pm_lvolt_o)
		       );

`ifdef CYPHERDB_PERFORMANCE_COUNTER

   wire 				  perf_start;
   wire 				  perf_end;
   wire 				  perf_en;
   wire [15:0] 				  perf_operand;

   // input the signal indicating the delay caused by the
   // data en-/decryption 
   wire 				  perf_delayed_ack_load;
   wire 				  perf_delayed_ack_store;   
	wire 				  perf_id_freeze;

   // output the decoded perf counter start & end pulses to dc_fsm
   // input the performance counter from dc_fsm
   wire 				  dcfsm_perf_en;
   wire 				  dcfsm_perf_start;
   wire [63:0] 				  dcfsm_perf_dcache_miss_count;   
   wire [63:0] 			dcfsm_perf_dcache_hit_count;   
   wire [63:0] 			dcfsm_perf_dcache_wb_count;   
   wire [63:0] 			dcfsm_perf_dcache_flush_count;   
   wire [63:0] 			dcfsm_perf_seedcache_access_count;   
   wire [63:0] 			dcfsm_perf_seedcache_miss_count;   
   wire [63:0] 			dcfsm_perf_seedcache_hit_count;   
   wire [63:0] 			dcfsm_perf_seedcache_wb_count;
   
   perf_counter_top
     perf_counter_top (
		       .clk(clk_i),
		       .rst(rst_i),
		       .perf_start(perf_start),
		       .perf_end(perf_end),
		       .perf_en(perf_en),
		       // input selection for perf counter and the output
		       .operand_in(perf_operand),
		       .perf_cntr_out(),
		       // input condition for counting insn executed
		       .id_freeze(perf_id_freeze),
		       // perf counters inputs from dc_fsm
		       // output the decoded perf counter start and end pulses
		       // to dc_fsm
		       .dcfsm_perf_dcache_miss_count(dcfsm_perf_dcache_miss_count),
		       .dcfsm_perf_dcache_hit_count(dcfsm_perf_dcache_hit_count),
		       .dcfsm_perf_dcache_wb_count(dcfsm_perf_dcache_wb_count),
		       .dcfsm_perf_dcache_flush_count(dcfsm_perf_dcache_flush_count),
		       .dcfsm_perf_seedcache_access_count(dcfsm_perf_seedcache_access_count),
		       .dcfsm_perf_seedcache_miss_count(dcfsm_perf_seedcache_miss_count),
		       .dcfsm_perf_seedcache_hit_count(dcfsm_perf_seedcache_hit_count),
		       .dcfsm_perf_seedcache_wb_count(dcfsm_perf_seedcache_wb_count),  
		       .dcfsm_perf_en(dcfsm_perf_en),
		       .dcfsm_perf_start(dcfsm_perf_start),
		       // input the signal indicating the delay caused by the
		       // data en-/decryption
		       .delayed_ack_load(perf_delayed_ack_load),
		       .delayed_ack_store(perf_delayed_ack_store)
		       );
`endif

endmodule
