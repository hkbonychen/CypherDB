//////////////////////////////////////////////////////////////////////
///                                                               //// 
/// ORPSoC top for de0-nano board                                 ////
///                                                               ////
/// Instantiates modules, depending on ORPSoC defines file        ////
///                                                               ////
/// Julius Baxter, julius@opencores.org                           ////
/// Contributor(s):                                               ////
///   Stefan Kristiansson, stefan.kristiansson@saunalahti.fi      ////
///                                                               ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2009, 2010 Authors and OPENCORES.ORG           ////
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

`include "orpsoc-defines.v"
`include "synthesis-defines.v"
module orpsoc_top
  (
`ifdef GENERIC_JTAG_TAP
    tdo_pad_o, tms_pad_i, tck_pad_i, tdi_pad_i,
`endif
`ifdef VERSATILE_SDRAM
    sdram_ba_pad_o,sdram_a_pad_o,sdram_cs_n_pad_o, sdram_ras_pad_o, 
    sdram_cas_pad_o, sdram_we_pad_o, sdram_dq_pad_io, sdram_dqm_pad_o, 
    sdram_cke_pad_o, sdram_clk_pad_o,
`endif  
`ifdef UART0
    uart0_srx_pad_i, uart0_stx_pad_o, 
`endif
`ifdef SPI0
    spi0_sck_o, spi0_mosi_o, spi0_miso_i,
 `ifdef SPI0_SLAVE_SELECTS
    spi0_ss_o,
 `endif
`endif
`ifdef SPI1
    spi1_sck_o, spi1_mosi_o, spi1_miso_i,
    `ifdef SPI1_SLAVE_SELECTS
    spi1_ss_o,
    `endif
`endif
`ifdef SPI2
    spi2_sck_o, spi2_mosi_o, spi2_miso_i,
    `ifdef SPI2_SLAVE_SELECTS
    spi2_ss_o,
    `endif
`endif
`ifdef I2C0
    i2c0_sda_io, i2c0_scl_io,
`endif    
`ifdef I2C1
    i2c1_sda_io, i2c1_scl_io,
`endif    
`ifdef I2C2
    i2c2_sda_io, i2c2_scl_io,
`endif    
`ifdef I2C3
    i2c3_sda_io, i2c3_scl_io,
`endif    
`ifdef USB0
    usb0dat_pad_io, usb0ctrl_pad_o, usb0fullspeed_pad_o,
`endif
`ifdef USB1
    usb1dat_pad_i, usb1dat_pad_o, usb1ctrl_pad_o, usb1fullspeed_pad_o,
`endif    
`ifdef GPIO0
    gpio0_io,
`endif
  
`ifdef ETH0
 `ifdef SMII0
    eth0_smii_sync_pad_o, eth0_smii_tx_pad_o, eth0_smii_rx_pad_i,
 `else    
    eth0_tx_clk, eth0_tx_data, eth0_tx_en, eth0_tx_er,   
    eth0_rx_clk, eth0_rx_data, eth0_dv, eth0_rx_er,   
    eth0_col, eth0_crs,
 `endif
    eth0_mdc_pad_o, eth0_md_pad_io,
`endif //  `ifdef ETH0
`ifdef ETH0_PHY_RST
    eth0_rst_n_o,
`endif
`ifdef ETH_CLK
    eth_clk_pad_i,   
`endif
`ifdef SDC_CONTROLLER
    sdc_cmd_pad_io , sdc_dat_pad_io ,  sdc_clk_pad_o, 
    //sdc_card_detect_pad_i,
`endif
`ifdef VGA0
    //vga0_rst_n_o,
    //vga0_clk_p_o, 
    vga0_hsync_pad_o, vga0_vsync_pad_o,
    vga0_r_pad_o, vga0_g_pad_o, vga0_b_pad_o,
    //vga0_data_en_o,
`endif
`ifdef PS20
    ps20_clk,
    ps20_dat,
`endif
`ifdef PS21
    ps21_clk,
    ps21_dat,
`endif
`ifdef VERSATILE_SEED_SDRAM
    seed_sdram_dq_pad_io, seed_sdram_dqm_pad_o,
`endif  
`ifdef EINT
	eint_pad_i,
`endif
`ifdef G_SENSOR
    g_sensor_cs_n,
    g_sensor_int,
`endif
    sys_clk_pad_i,

    rst_n_pad_i  

    )/* synthesis syn_global_buffers = 18; */;

`include "orpsoc-params.v"   

`ifdef G_SENSOR
	input g_sensor_int;
   output g_sensor_cs_n;
`endif
   input sys_clk_pad_i;
   
   input rst_n_pad_i;
`ifdef GENERIC_JTAG_TAP
   output tdo_pad_o;
   input  tms_pad_i;
   input  tck_pad_i;
   input  tdi_pad_i;
`endif
`ifdef VERSATILE_SDRAM
   output [1:0] sdram_ba_pad_o;
   output [12:0] sdram_a_pad_o;
   output 	 sdram_cs_n_pad_o;
   output 	 sdram_ras_pad_o;
   output 	 sdram_cas_pad_o;
   output 	 sdram_we_pad_o;
   inout [15:0]  sdram_dq_pad_io;
   output [1:0]  sdram_dqm_pad_o;
   output 	 sdram_cke_pad_o;
   output        sdram_clk_pad_o; 	 
`endif       
`ifdef UART0
   input 	 uart0_srx_pad_i;
   output 	 uart0_stx_pad_o;
`endif
`ifdef SPI0
   output 	 spi0_sck_o;
   output 	 spi0_mosi_o;
 `ifdef SPI0_SLAVE_SELECTS
   output [spi0_ss_width-1:0] spi0_ss_o;
 `endif
   input 		      spi0_miso_i;
`endif
`ifdef SPI1
   output 		      spi1_sck_o;
   output 		      spi1_mosi_o;
 `ifdef SPI1_SLAVE_SELECTS   
   output [spi1_ss_width-1:0] spi1_ss_o;
 `endif   
   input 		      spi1_miso_i;
`endif
`ifdef SPI2
   output 		      spi2_sck_o;
   output 		      spi2_mosi_o;
 `ifdef SPI2_SLAVE_SELECTS
   output [spi2_ss_width-1:0] spi2_ss_o;
 `endif
   input 		      spi2_miso_i;
`endif
`ifdef I2C0
   inout 		      i2c0_sda_io, i2c0_scl_io;
`endif   
`ifdef I2C1
   inout 		      i2c1_sda_io, i2c1_scl_io;
`endif   
`ifdef I2C2
   inout 		      i2c2_sda_io, i2c2_scl_io;
`endif
`ifdef I2C3
   inout 		      i2c3_sda_io, i2c3_scl_io;
`endif   
`ifdef USB0
   inout [1:0] 		      usb0dat_pad_io;
   //   input 		      usb0vbusdetect;
   //output [1:0] 	      usb0dat_pad_o;
   output 		      usb0ctrl_pad_o;
   output 		      usb0fullspeed_pad_o;
`endif
`ifdef USB1
   input [1:0] 		      usb1dat_pad_i;
   //   input 		      usb1vbusdetect;
   output [1:0] 	      usb1dat_pad_o;
   output 		      usb1ctrl_pad_o;
   output 		      usb1fullspeed_pad_o;
`endif   
`ifdef GPIO0
   inout [gpio0_io_width-1:0] gpio0_io;   
`endif 
`ifdef ETH0
 `ifdef SMII0   
   output 		      eth0_smii_sync_pad_o, eth0_smii_tx_pad_o;
   input 		      eth0_smii_rx_pad_i;
 `else
   input 		      eth0_tx_clk;
   output [3:0] 	      eth0_tx_data;
   output 		      eth0_tx_en;
   output 		      eth0_tx_er;
   input 		      eth0_rx_clk;
   input [3:0] 		      eth0_rx_data;
   input 		      eth0_dv;
   input 		      eth0_rx_er;
   input 		      eth0_col;
   input 		      eth0_crs;
 `endif // !`ifdef SMII0
   output 		      eth0_mdc_pad_o;
   inout 		      eth0_md_pad_io;
`endif //  `ifdef ETH0
`ifdef ETH_CLK
   input 		      eth_clk_pad_i;
`endif
`ifdef SDC_CONTROLLER
   inout 		      sdc_cmd_pad_io; 
   //input 		      sdc_card_detect_pad_i;
   inout [3:0] 		      sdc_dat_pad_io ;
   output 		      sdc_clk_pad_o ;
`endif
`ifdef VGA0
   //output 		      vga0_rst_n_o;
   //output 		      vga0_clk_p_o;
   output 		      vga0_hsync_pad_o;
   output 		      vga0_vsync_pad_o;
   //output 		      vga0_data_en_o;
   output [7:4] 	      vga0_r_pad_o;
   output [7:4]		      vga0_g_pad_o;
   output [7:4]		      vga0_b_pad_o;   
`endif
`ifdef PS20
	inout					ps20_clk;
	inout					ps20_dat;
`endif
`ifdef PS21
	inout					ps21_clk;
	inout					ps21_dat;
`endif
`ifdef VERSATILE_SEED_SDRAM
   inout [15:0]  seed_sdram_dq_pad_io;
   output [1:0]  seed_sdram_dqm_pad_o; 
`endif  
`ifdef EINT
   input [30:24] eint_pad_i;
`endif

`ifdef G_SENSOR
   assign g_sensor_cs_n = 1;
`endif

   ////////////////////////////////////////////////////////////////////////
   //
   // Clock and reset generation module
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire 		      wb_clk /*synthesis keep*/;
	wire           wb_rst;
   wire 		      sdram_clk, sdram_rst;
   wire 		      ddr2_if_clk, ddr2_if_rst;
   wire 		      clk200;
   wire 		      usb_clk;
   wire 		      spw_clk;
   wire 		      eth_smii_clk, eth_smii_rst;
   wire 		      dbg_tck;
   wire 		      vga0_pclk;
	wire 				signaltap_clk;
	wire				aes_clk;

   clkgen clkgen0
     (
      .sys_clk_pad_i             (sys_clk_pad_i),

      .wb_clk_o                  (wb_clk),
      .wb_rst_o                  (wb_rst),
`ifdef GENERIC_JTAG_TAP
      .tck_pad_i                 (tck_pad_i),
      .dbg_tck_o                 (dbg_tck),
`endif
`ifdef VERSATILE_SDRAM      
      .sdram_clk_o               (sdram_clk),
      .sdram_rst_o               (sdram_rst),
`endif
`ifdef ETH_CLK
      .eth_clk_pad_i             (eth_clk_pad_i),
      .eth_clk_o                 (eth_smii_clk),
      .eth_rst_o                 (eth_smii_rst),
`endif
`ifdef USB_CLK     
      .usb_clk_o                 (usb_clk),
`endif
`ifdef VGA0     
      .vga0_clk_o                (vga0_pclk),
`endif

`ifdef SIGNALTAP
		.signaltap_o					(signaltap_clk),
`endif

`ifdef AES_SEP_CLK
		.aes_clk_o						(aes_clk),
`endif

      // Asynchronous active low reset
      .rst_n_pad_i               (rst_n_pad_i)
      );

   
   ////////////////////////////////////////////////////////////////////////
   //
   // Arbiter
   // 
   ////////////////////////////////////////////////////////////////////////
   
   // Wire naming convention:
   // First: wishbone master or slave (wbm/wbs)
   // Second: Which bus it's on instruction or data (i/d)
   // Third: Between which module and the arbiter the wires are
   // Fourth: Signal name
   // Fifth: Direction relative to module (not bus/arbiter!)
   //        ie. wbm_d_or12_adr_o is address OUT from the or1200

   // OR1200 instruction bus wires
   wire [wb_aw-1:0] 	      wbm_i_or12_adr_o;
   wire [wb_dw-1:0] 	      wbm_i_or12_dat_o;
   wire [3:0] 		      wbm_i_or12_sel_o;
   wire 		      wbm_i_or12_we_o;
   wire 		      wbm_i_or12_cyc_o;
   wire 		      wbm_i_or12_stb_o;
   wire [2:0] 		      wbm_i_or12_cti_o;
   wire [1:0] 		      wbm_i_or12_bte_o;
   
   wire [wb_dw-1:0] 	      wbm_i_or12_dat_i;   
   wire 		      wbm_i_or12_ack_i;
   wire 		      wbm_i_or12_err_i;
   wire 		      wbm_i_or12_rty_i;

   // OR1200 data bus wires   
   wire [wb_aw-1:0] 	      wbm_d_or12_adr_o;
   wire [wb_dw-1:0] 	      wbm_d_or12_dat_o;
   wire [3:0] 		      wbm_d_or12_sel_o;
   wire 		      wbm_d_or12_we_o;
   wire 		      wbm_d_or12_cyc_o;
   wire 		      wbm_d_or12_stb_o;
   wire [2:0] 		      wbm_d_or12_cti_o;
   wire [1:0] 		      wbm_d_or12_bte_o;
   
   wire [wb_dw-1:0] 	      wbm_d_or12_dat_i;   
   wire 		      wbm_d_or12_ack_i;
   wire 		      wbm_d_or12_err_i;
   wire 		      wbm_d_or12_rty_i;   

   // Debug interface bus wires   
   wire [wb_aw-1:0] 	      wbm_d_dbg_adr_o;
   wire [wb_dw-1:0] 	      wbm_d_dbg_dat_o;
   wire [3:0] 		      wbm_d_dbg_sel_o;
   wire 		      wbm_d_dbg_we_o;
   wire 		      wbm_d_dbg_cyc_o;
   wire 		      wbm_d_dbg_stb_o;
   wire [2:0] 		      wbm_d_dbg_cti_o;
   wire [1:0] 		      wbm_d_dbg_bte_o;
   
   wire [wb_dw-1:0] 	      wbm_d_dbg_dat_i;   
   wire 		      wbm_d_dbg_ack_i;
   wire 		      wbm_d_dbg_err_i;
   wire 		      wbm_d_dbg_rty_i;

   // Byte bus bridge master signals
   wire [wb_aw-1:0] 	      wbm_b_d_adr_o;
   wire [wb_dw-1:0] 	      wbm_b_d_dat_o;
   wire [3:0] 		      wbm_b_d_sel_o;
   wire 		      wbm_b_d_we_o;
   wire 		      wbm_b_d_cyc_o;
   wire 		      wbm_b_d_stb_o;
   wire [2:0] 		      wbm_b_d_cti_o;
   wire [1:0] 		      wbm_b_d_bte_o;
   
   wire [wb_dw-1:0] 	      wbm_b_d_dat_i;   
   wire 		      wbm_b_d_ack_i;
   wire 		      wbm_b_d_err_i;
   wire 		      wbm_b_d_rty_i;   

   // Instruction bus slave wires //
   
   // rom0 instruction bus wires
   wire [31:0] 		      wbs_i_rom0_adr_i;
   wire [wbs_i_rom0_data_width-1:0] wbs_i_rom0_dat_i;
   wire [3:0] 			    wbs_i_rom0_sel_i;
   wire 			    wbs_i_rom0_we_i;
   wire 			    wbs_i_rom0_cyc_i;
   wire 			    wbs_i_rom0_stb_i;
   wire [2:0] 			    wbs_i_rom0_cti_i;
   wire [1:0] 			    wbs_i_rom0_bte_i;   
   wire [wbs_i_rom0_data_width-1:0] wbs_i_rom0_dat_o;   
   wire 			    wbs_i_rom0_ack_o;
   wire 			    wbs_i_rom0_err_o;
   wire 			    wbs_i_rom0_rty_o;   

   // mc0 instruction bus wires
   wire [31:0] 			    wbs_i_mc0_adr_i;
   wire [wbs_i_mc0_data_width-1:0]  wbs_i_mc0_dat_i;
   wire [3:0] 			    wbs_i_mc0_sel_i;
   wire 			    wbs_i_mc0_we_i;
   wire 			    wbs_i_mc0_cyc_i;
   wire 			    wbs_i_mc0_stb_i;
   wire [2:0] 			    wbs_i_mc0_cti_i;
   wire [1:0] 			    wbs_i_mc0_bte_i;   
   wire [wbs_i_mc0_data_width-1:0]  wbs_i_mc0_dat_o;   
   wire 			    wbs_i_mc0_ack_o;
   wire 			    wbs_i_mc0_err_o;
   wire 			    wbs_i_mc0_rty_o;   
   
   // Data bus slave wires //
   
   // mc0 data bus wires
   wire [31:0] 			    wbs_d_mc0_adr_i;
   wire [wbs_d_mc0_data_width-1:0]  wbs_d_mc0_dat_i;
   wire [3:0] 			    wbs_d_mc0_sel_i;
   wire 			    wbs_d_mc0_we_i;
   wire 			    wbs_d_mc0_cyc_i;
   wire 			    wbs_d_mc0_stb_i;
   wire [2:0] 			    wbs_d_mc0_cti_i;
   wire [1:0] 			    wbs_d_mc0_bte_i;   
   wire [wbs_d_mc0_data_width-1:0]  wbs_d_mc0_dat_o;   
   wire 			    wbs_d_mc0_ack_o;
   wire 			    wbs_d_mc0_err_o;
   wire 			    wbs_d_mc0_rty_o;
   
   // i2c0 wires
   wire [31:0] 			    wbs_d_i2c0_adr_i;
   wire [wbs_d_i2c0_data_width-1:0] wbs_d_i2c0_dat_i;
   wire [3:0] 			    wbs_d_i2c0_sel_i;
   wire 			    wbs_d_i2c0_we_i;
   wire 			    wbs_d_i2c0_cyc_i;
   wire 			    wbs_d_i2c0_stb_i;
   wire [2:0] 			    wbs_d_i2c0_cti_i;
   wire [1:0] 			    wbs_d_i2c0_bte_i;   
   wire [wbs_d_i2c0_data_width-1:0] wbs_d_i2c0_dat_o;   
   wire 			    wbs_d_i2c0_ack_o;
   wire 			    wbs_d_i2c0_err_o;
   wire 			    wbs_d_i2c0_rty_o;   

   // i2c1 wires
   wire [31:0] 			    wbs_d_i2c1_adr_i;
   wire [wbs_d_i2c1_data_width-1:0] wbs_d_i2c1_dat_i;
   wire [3:0] 			    wbs_d_i2c1_sel_i;
   wire 			    wbs_d_i2c1_we_i;
   wire 			    wbs_d_i2c1_cyc_i;
   wire 			    wbs_d_i2c1_stb_i;
   wire [2:0] 			    wbs_d_i2c1_cti_i;
   wire [1:0] 			    wbs_d_i2c1_bte_i;   
   wire [wbs_d_i2c1_data_width-1:0] wbs_d_i2c1_dat_o;   
   wire 			    wbs_d_i2c1_ack_o;
   wire 			    wbs_d_i2c1_err_o;
   wire 			    wbs_d_i2c1_rty_o;

   // i2c2 wires
   wire [31:0] 			    wbs_d_i2c2_adr_i;
   wire [wbs_d_i2c2_data_width-1:0] wbs_d_i2c2_dat_i;
   wire [3:0] 			    wbs_d_i2c2_sel_i;
   wire 			    wbs_d_i2c2_we_i;
   wire 			    wbs_d_i2c2_cyc_i;
   wire 			    wbs_d_i2c2_stb_i;
   wire [2:0] 			    wbs_d_i2c2_cti_i;
   wire [1:0] 			    wbs_d_i2c2_bte_i;   
   wire [wbs_d_i2c2_data_width-1:0] wbs_d_i2c2_dat_o;   
   wire 			    wbs_d_i2c2_ack_o;
   wire 			    wbs_d_i2c2_err_o;
   wire 			    wbs_d_i2c2_rty_o;   
   
   // i2c3 wires
   wire [31:0] 			    wbs_d_i2c3_adr_i;
   wire [wbs_d_i2c3_data_width-1:0] wbs_d_i2c3_dat_i;
   wire [3:0] 			    wbs_d_i2c3_sel_i;
   wire 			    wbs_d_i2c3_we_i;
   wire 			    wbs_d_i2c3_cyc_i;
   wire 			    wbs_d_i2c3_stb_i;
   wire [2:0] 			    wbs_d_i2c3_cti_i;
   wire [1:0] 			    wbs_d_i2c3_bte_i;   
   wire [wbs_d_i2c3_data_width-1:0] wbs_d_i2c3_dat_o;   
   wire 			    wbs_d_i2c3_ack_o;
   wire 			    wbs_d_i2c3_err_o;
   wire 			    wbs_d_i2c3_rty_o;   
   
   // spi0 wires
   wire [31:0] 			    wbs_d_spi0_adr_i;
   wire [wbs_d_spi0_data_width-1:0] wbs_d_spi0_dat_i;
   wire [3:0] 			    wbs_d_spi0_sel_i;
   wire 			    wbs_d_spi0_we_i;
   wire 			    wbs_d_spi0_cyc_i;
   wire 			    wbs_d_spi0_stb_i;
   wire [2:0] 			    wbs_d_spi0_cti_i;
   wire [1:0] 			    wbs_d_spi0_bte_i;   
   wire [wbs_d_spi0_data_width-1:0] wbs_d_spi0_dat_o;   
   wire 			    wbs_d_spi0_ack_o;
   wire 			    wbs_d_spi0_err_o;
   wire 			    wbs_d_spi0_rty_o;   

   // spi1 wires
   wire [31:0] 			    wbs_d_spi1_adr_i;
   wire [wbs_d_spi1_data_width-1:0] wbs_d_spi1_dat_i;
   wire [3:0] 			    wbs_d_spi1_sel_i;
   wire 			    wbs_d_spi1_we_i;
   wire 			    wbs_d_spi1_cyc_i;
   wire 			    wbs_d_spi1_stb_i;
   wire [2:0] 			    wbs_d_spi1_cti_i;
   wire [1:0] 			    wbs_d_spi1_bte_i;   
   wire [wbs_d_spi1_data_width-1:0] wbs_d_spi1_dat_o;   
   wire 			    wbs_d_spi1_ack_o;
   wire 			    wbs_d_spi1_err_o;
   wire 			    wbs_d_spi1_rty_o;   

   // spi2 wires
   wire [31:0] 			    wbs_d_spi2_adr_i;
   wire [wbs_d_spi2_data_width-1:0] wbs_d_spi2_dat_i;
   wire [3:0] 			    wbs_d_spi2_sel_i;
   wire 			    wbs_d_spi2_we_i;
   wire 			    wbs_d_spi2_cyc_i;
   wire 			    wbs_d_spi2_stb_i;
   wire [2:0] 			    wbs_d_spi2_cti_i;
   wire [1:0] 			    wbs_d_spi2_bte_i;   
   wire [wbs_d_spi2_data_width-1:0] wbs_d_spi2_dat_o;   
   wire 			    wbs_d_spi2_ack_o;
   wire 			    wbs_d_spi2_err_o;
   wire 			    wbs_d_spi2_rty_o;

   // uart0 wires
   wire [31:0] 			     wbs_d_uart0_adr_i;
   wire [wbs_d_uart0_data_width-1:0] wbs_d_uart0_dat_i;
   wire [3:0] 			     wbs_d_uart0_sel_i;
   wire 			     wbs_d_uart0_we_i;
   wire 			     wbs_d_uart0_cyc_i;
   wire 			     wbs_d_uart0_stb_i;
   wire [2:0] 			     wbs_d_uart0_cti_i;
   wire [1:0] 			     wbs_d_uart0_bte_i;   
   wire [wbs_d_uart0_data_width-1:0] wbs_d_uart0_dat_o;   
   wire 			     wbs_d_uart0_ack_o;
   wire 			     wbs_d_uart0_err_o;
   wire 			     wbs_d_uart0_rty_o;   
   
   // usb0 wires
   wire [31:0] 			     wbs_d_usb0_adr_i;
   wire [wbs_d_usb0_data_width-1:0]  wbs_d_usb0_dat_i;
   wire [3:0] 			     wbs_d_usb0_sel_i;
   wire 			     wbs_d_usb0_we_i;
   wire 			     wbs_d_usb0_cyc_i;
   wire 			     wbs_d_usb0_stb_i;
   wire [2:0] 			     wbs_d_usb0_cti_i;
   wire [1:0] 			     wbs_d_usb0_bte_i;   
   wire [wbs_d_usb0_data_width-1:0]  wbs_d_usb0_dat_o;   
   wire 			     wbs_d_usb0_ack_o;
   wire 			     wbs_d_usb0_err_o;
   wire 			     wbs_d_usb0_rty_o;

   // usb1 wires
   wire [31:0] 			     wbs_d_usb1_adr_i;
   wire [wbs_d_usb1_data_width-1:0]  wbs_d_usb1_dat_i;
   wire [3:0] 			     wbs_d_usb1_sel_i;
   wire 			     wbs_d_usb1_we_i;
   wire 			     wbs_d_usb1_cyc_i;
   wire 			     wbs_d_usb1_stb_i;
   wire [2:0] 			     wbs_d_usb1_cti_i;
   wire [1:0] 			     wbs_d_usb1_bte_i;   
   wire [wbs_d_usb1_data_width-1:0]  wbs_d_usb1_dat_o;   
   wire 			     wbs_d_usb1_ack_o;
   wire 			     wbs_d_usb1_err_o;
   wire 			     wbs_d_usb1_rty_o;

   // sdcard slave wires
   wire [31:0] 			     wbs_d_sdc_adr_i;
   wire [wbs_d_sdc_data_width-1:0]   wbs_d_sdc_dat_i;
   wire [3:0] 			     wbs_d_sdc_sel_i;
   wire 			     wbs_d_sdc_we_i;
   wire 			     wbs_d_sdc_cyc_i;
   wire 			     wbs_d_sdc_stb_i;
   wire [2:0] 			     wbs_d_sdc_cti_i;
   wire [1:0] 			     wbs_d_sdc_bte_i;   
   wire [wbs_d_sdc_data_width-1:0]   wbs_d_sdc_dat_o;   
   wire 			     wbs_d_sdc_ack_o;
   wire 			     wbs_d_sdc_err_o;
   wire 			     wbs_d_sdc_rty_o;

   // sdcard master wires
   wire [wbm_sdc_addr_width-1:0]     wbm_sdc_adr_o;
   wire [wbm_sdc_data_width-1:0]     wbm_sdc_dat_o;
   wire [3:0] 			     wbm_sdc_sel_o;
   wire 			     wbm_sdc_we_o;
   wire 			     wbm_sdc_cyc_o;
   wire 			     wbm_sdc_stb_o;
   wire [2:0] 			     wbm_sdc_cti_o;
   wire [1:0] 			     wbm_sdc_bte_o;   
   wire [wbm_sdc_data_width-1:0]     wbm_sdc_dat_i;   
   wire 			     wbm_sdc_ack_i;
   wire 			     wbm_sdc_err_i;
   wire 			     wbm_sdc_rty_i;    

   
   // gpio0 wires
   wire [31:0] 			     wbs_d_gpio0_adr_i;
   wire [wbs_d_gpio0_data_width-1:0] wbs_d_gpio0_dat_i;
   wire [3:0] 			     wbs_d_gpio0_sel_i;
   wire 			     wbs_d_gpio0_we_i;
   wire 			     wbs_d_gpio0_cyc_i;
   wire 			     wbs_d_gpio0_stb_i;
   wire [2:0] 			     wbs_d_gpio0_cti_i;
   wire [1:0] 			     wbs_d_gpio0_bte_i;   
   wire [wbs_d_gpio0_data_width-1:0] wbs_d_gpio0_dat_o;   
   wire 			     wbs_d_gpio0_ack_o;
   wire 			     wbs_d_gpio0_err_o;
   wire 			     wbs_d_gpio0_rty_o;
   
   // flashROM wires
   wire [31:0] 				  wbs_d_flashrom_adr_i;
   wire [flashrom_wb_data_width-1:0] 	  wbs_d_flashrom_dat_i;
   wire [3:0] 				  wbs_d_flashrom_sel_i;
   wire 				  wbs_d_flashrom_we_i;
   wire 				  wbs_d_flashrom_cyc_i;
   wire 				  wbs_d_flashrom_stb_i;
   wire [2:0] 				  wbs_d_flashrom_cti_i;
   wire [1:0] 				  wbs_d_flashrom_bte_i;   
   wire [flashrom_wb_data_width-1:0] 	  wbs_d_flashrom_dat_o;   
   wire 				  wbs_d_flashrom_ack_o;
   wire 				  wbs_d_flashrom_err_o;
   wire 				  wbs_d_flashrom_rty_o;

   // eth0 slave wires
   wire [31:0] 				  wbs_d_eth0_adr_i;
   wire [wbs_d_eth0_data_width-1:0] 	  wbs_d_eth0_dat_i;
   wire [3:0] 				  wbs_d_eth0_sel_i;
   wire 				  wbs_d_eth0_we_i;
   wire 				  wbs_d_eth0_cyc_i;
   wire 				  wbs_d_eth0_stb_i;
   wire [2:0] 				  wbs_d_eth0_cti_i;
   wire [1:0] 				  wbs_d_eth0_bte_i;   
   wire [wbs_d_eth0_data_width-1:0] 	  wbs_d_eth0_dat_o;   
   wire 				  wbs_d_eth0_ack_o;
   wire 				  wbs_d_eth0_err_o;
   wire 				  wbs_d_eth0_rty_o;
   // eth0 master wires
   wire [wbm_eth0_addr_width-1:0] 	  wbm_eth0_adr_o;
   wire [wbm_eth0_data_width-1:0] 	  wbm_eth0_dat_o;
   wire [3:0] 				  wbm_eth0_sel_o;
   wire 				  wbm_eth0_we_o;
   wire 				  wbm_eth0_cyc_o;
   wire 				  wbm_eth0_stb_o;
   wire [2:0] 				  wbm_eth0_cti_o;
   wire [1:0] 				  wbm_eth0_bte_o;
   wire [wbm_eth0_data_width-1:0]         wbm_eth0_dat_i;
   wire 				  wbm_eth0_ack_i;
   wire 				  wbm_eth0_err_i;
   wire 				  wbm_eth0_rty_i;

   // vga0 slave wires
   wire [31:0] 				  wbs_d_vga0_adr_i;
   wire [wbs_d_vga0_data_width-1:0] 	  wbs_d_vga0_dat_i;
   wire [3:0] 				  wbs_d_vga0_sel_i;
   wire 				  wbs_d_vga0_we_i;
   wire 				  wbs_d_vga0_cyc_i;
   wire 				  wbs_d_vga0_stb_i;
   wire [2:0] 				  wbs_d_vga0_cti_i;
   wire [1:0] 				  wbs_d_vga0_bte_i;   
   wire [wbs_d_vga0_data_width-1:0] 	  wbs_d_vga0_dat_o;   
   wire 				  wbs_d_vga0_ack_o;
   wire 				  wbs_d_vga0_err_o;
   wire 				  wbs_d_vga0_rty_o;

   // vga0 master wires
   wire [wbm_vga0_addr_width-1:0] 	  wbm_vga0_adr_o;
   wire [wbm_vga0_data_width-1:0] 	  wbm_vga0_dat_o;
   wire [3:0] 				  wbm_vga0_sel_o;
   wire 				  wbm_vga0_we_o;
   wire 				  wbm_vga0_cyc_o;
   wire 				  wbm_vga0_stb_o;
   wire [2:0] 				  wbm_vga0_cti_o;
   wire [1:0] 				  wbm_vga0_bte_o;
   wire [wbm_vga0_data_width-1:0] 	  wbm_vga0_dat_i;
   wire 				  wbm_vga0_ack_i;
   wire 				  wbm_vga0_err_i;
   wire 				  wbm_vga0_rty_i;

   // ps20 slave wires
   wire [31:0] 				  wbs_d_ps20_adr_i;
   wire [wbs_d_ps20_data_width-1:0] 	  wbs_d_ps20_dat_i;
   wire [3:0] 				  wbs_d_ps20_sel_i;
   wire 				  wbs_d_ps20_we_i;
   wire 				  wbs_d_ps20_cyc_i;
   wire 				  wbs_d_ps20_stb_i;
   wire [2:0] 				  wbs_d_ps20_cti_i;
   wire [1:0] 				  wbs_d_ps20_bte_i;   
   wire [wbs_d_ps20_data_width-1:0] 	  wbs_d_ps20_dat_o;   
   wire 				  wbs_d_ps20_ack_o;
   wire 				  wbs_d_ps20_err_o;
   wire 				  wbs_d_ps20_rty_o; 
	
   // ps21 slave wires
   wire [31:0] 				  wbs_d_ps21_adr_i;
   wire [wbs_d_ps21_data_width-1:0] 	  wbs_d_ps21_dat_i;
   wire [3:0] 				  wbs_d_ps21_sel_i;
   wire 				  wbs_d_ps21_we_i;
   wire 				  wbs_d_ps21_cyc_i;
   wire 				  wbs_d_ps21_stb_i;
   wire [2:0] 				  wbs_d_ps21_cti_i;
   wire [1:0] 				  wbs_d_ps21_bte_i;   
   wire [wbs_d_ps21_data_width-1:0] 	  wbs_d_ps21_dat_o;   
   wire 				  wbs_d_ps21_ack_o;
   wire 				  wbs_d_ps21_err_o;
   wire 				  wbs_d_ps21_rty_o; 
	
   // SEED_sdram data bus wires
   wire [31:0] 			    wbs_d_mc1_adr_i;
   wire [wbs_d_mc1_data_width-1:0]  wbs_d_mc1_dat_i;
   wire [3:0] 			    wbs_d_mc1_sel_i;
   wire 			    wbs_d_mc1_we_i;
   wire 			    wbs_d_mc1_cyc_i;
   wire 			    wbs_d_mc1_stb_i;
   wire [2:0] 			    wbs_d_mc1_cti_i;
   wire [1:0] 			    wbs_d_mc1_bte_i;   
   wire [wbs_d_mc1_data_width-1:0]  wbs_d_mc1_dat_o;   
   wire 			    wbs_d_mc1_ack_o;
   wire 			    wbs_d_mc1_err_o;
   wire 			    wbs_d_mc1_rty_o;


   //
   // Wishbone instruction bus arbiter
   //
   
   arbiter_ibus arbiter_ibus0
     (
      // Instruction Bus Master
      // Inputs to arbiter from master
      .wbm_adr_o			(wbm_i_or12_adr_o),
      .wbm_dat_o			(wbm_i_or12_dat_o),
      .wbm_sel_o			(wbm_i_or12_sel_o),
      .wbm_we_o				(wbm_i_or12_we_o),
      .wbm_cyc_o			(wbm_i_or12_cyc_o),
      .wbm_stb_o			(wbm_i_or12_stb_o),
      .wbm_cti_o			(wbm_i_or12_cti_o),
      .wbm_bte_o			(wbm_i_or12_bte_o),
      // Outputs to master from arbiter
      .wbm_dat_i			(wbm_i_or12_dat_i),
      .wbm_ack_i			(wbm_i_or12_ack_i),
      .wbm_err_i			(wbm_i_or12_err_i),
      .wbm_rty_i			(wbm_i_or12_rty_i),
      
      // Slave 0
      // Inputs to slave from arbiter
      .wbs0_adr_i			(wbs_i_rom0_adr_i),
      .wbs0_dat_i			(wbs_i_rom0_dat_i),
      .wbs0_sel_i			(wbs_i_rom0_sel_i),
      .wbs0_we_i			(wbs_i_rom0_we_i),
      .wbs0_cyc_i			(wbs_i_rom0_cyc_i),
      .wbs0_stb_i			(wbs_i_rom0_stb_i),
      .wbs0_cti_i			(wbs_i_rom0_cti_i),
      .wbs0_bte_i			(wbs_i_rom0_bte_i),
      // Outputs from slave to arbiter      
      .wbs0_dat_o			(wbs_i_rom0_dat_o),
      .wbs0_ack_o			(wbs_i_rom0_ack_o),
      .wbs0_err_o			(wbs_i_rom0_err_o),
      .wbs0_rty_o			(wbs_i_rom0_rty_o),

      // Slave 1
      // Inputs to slave from arbiter
      .wbs1_adr_i			(wbs_i_mc0_adr_i),
      .wbs1_dat_i			(wbs_i_mc0_dat_i),
      .wbs1_sel_i			(wbs_i_mc0_sel_i),
      .wbs1_we_i			(wbs_i_mc0_we_i),
      .wbs1_cyc_i			(wbs_i_mc0_cyc_i),
      .wbs1_stb_i			(wbs_i_mc0_stb_i),
      .wbs1_cti_i			(wbs_i_mc0_cti_i),
      .wbs1_bte_i			(wbs_i_mc0_bte_i),
      // Outputs from slave to arbiter
      .wbs1_dat_o			(wbs_i_mc0_dat_o),
      .wbs1_ack_o			(wbs_i_mc0_ack_o),
      .wbs1_err_o			(wbs_i_mc0_err_o),
      .wbs1_rty_o			(wbs_i_mc0_rty_o),

      // Clock, reset inputs
      .wb_clk				(wb_clk),
      .wb_rst				(wb_rst));

   defparam arbiter_ibus0.wb_addr_match_width = ibus_arb_addr_match_width;

   defparam arbiter_ibus0.slave0_adr = ibus_arb_slave0_adr; // FLASH ROM
   defparam arbiter_ibus0.slave1_adr = ibus_arb_slave1_adr; // Main memory

   //
   // Wishbone data bus arbiter
   //
   
   arbiter_dbus arbiter_dbus0
     (
      // Master 0
      // Inputs to arbiter from master
      .wbm0_adr_o			(wbm_d_or12_adr_o),
      .wbm0_dat_o			(wbm_d_or12_dat_o),
      .wbm0_sel_o			(wbm_d_or12_sel_o),
      .wbm0_we_o			(wbm_d_or12_we_o),
      .wbm0_cyc_o			(wbm_d_or12_cyc_o),
      .wbm0_stb_o			(wbm_d_or12_stb_o),
      .wbm0_cti_o			(wbm_d_or12_cti_o),
      .wbm0_bte_o			(wbm_d_or12_bte_o),
      // Outputs to master from arbiter
      .wbm0_dat_i			(wbm_d_or12_dat_i),
      .wbm0_ack_i			(wbm_d_or12_ack_i),
      .wbm0_err_i			(wbm_d_or12_err_i),
      .wbm0_rty_i			(wbm_d_or12_rty_i),

      // Master 0
      // Inputs to arbiter from master
      .wbm1_adr_o			(wbm_d_dbg_adr_o),
      .wbm1_dat_o			(wbm_d_dbg_dat_o),
      .wbm1_we_o			(wbm_d_dbg_we_o),
      .wbm1_cyc_o			(wbm_d_dbg_cyc_o),
      .wbm1_sel_o			(wbm_d_dbg_sel_o),
      .wbm1_stb_o			(wbm_d_dbg_stb_o),
      .wbm1_cti_o			(wbm_d_dbg_cti_o),
      .wbm1_bte_o			(wbm_d_dbg_bte_o),
      // Outputs to master from arbiter      
      .wbm1_dat_i			(wbm_d_dbg_dat_i),
      .wbm1_ack_i			(wbm_d_dbg_ack_i),
      .wbm1_err_i			(wbm_d_dbg_err_i),
      .wbm1_rty_i			(wbm_d_dbg_rty_i),

      // Slaves
      
      .wbs0_adr_i			(wbs_d_mc0_adr_i),
      .wbs0_dat_i			(wbs_d_mc0_dat_i),
      .wbs0_sel_i			(wbs_d_mc0_sel_i),
      .wbs0_we_i			(wbs_d_mc0_we_i),
      .wbs0_cyc_i			(wbs_d_mc0_cyc_i),
      .wbs0_stb_i			(wbs_d_mc0_stb_i),
      .wbs0_cti_i			(wbs_d_mc0_cti_i),
      .wbs0_bte_i			(wbs_d_mc0_bte_i),
      .wbs0_dat_o			(wbs_d_mc0_dat_o),
      .wbs0_ack_o			(wbs_d_mc0_ack_o),
      .wbs0_err_o			(wbs_d_mc0_err_o),
      .wbs0_rty_o			(wbs_d_mc0_rty_o),

      .wbs1_adr_i			(wbs_d_eth0_adr_i),
      .wbs1_dat_i			(wbs_d_eth0_dat_i),
      .wbs1_sel_i			(wbs_d_eth0_sel_i),
      .wbs1_we_i			(wbs_d_eth0_we_i),
      .wbs1_cyc_i			(wbs_d_eth0_cyc_i),
      .wbs1_stb_i			(wbs_d_eth0_stb_i),
      .wbs1_cti_i			(wbs_d_eth0_cti_i),
      .wbs1_bte_i			(wbs_d_eth0_bte_i),
      .wbs1_dat_o			(wbs_d_eth0_dat_o),
      .wbs1_ack_o			(wbs_d_eth0_ack_o),
      .wbs1_err_o			(wbs_d_eth0_err_o),
      .wbs1_rty_o			(wbs_d_eth0_rty_o),

      .wbs2_adr_i			(wbs_d_sdc_adr_i),
      .wbs2_dat_i			(wbs_d_sdc_dat_i),
      .wbs2_sel_i			(wbs_d_sdc_sel_i),
      .wbs2_we_i			(wbs_d_sdc_we_i),
      .wbs2_cyc_i			(wbs_d_sdc_cyc_i),
      .wbs2_stb_i			(wbs_d_sdc_stb_i),
      .wbs2_cti_i			(wbs_d_sdc_cti_i),
      .wbs2_bte_i			(wbs_d_sdc_bte_i),
      .wbs2_dat_o			(wbs_d_sdc_dat_o),
      .wbs2_ack_o			(wbs_d_sdc_ack_o),
      .wbs2_err_o			(wbs_d_sdc_err_o),
      .wbs2_rty_o			(wbs_d_sdc_rty_o),
      
      .wbs3_adr_i			(wbs_d_vga0_adr_i),
      .wbs3_dat_i			(wbs_d_vga0_dat_i),
      .wbs3_sel_i			(wbs_d_vga0_sel_i),
      .wbs3_we_i			(wbs_d_vga0_we_i),
      .wbs3_cyc_i			(wbs_d_vga0_cyc_i),
      .wbs3_stb_i			(wbs_d_vga0_stb_i),
      .wbs3_cti_i			(wbs_d_vga0_cti_i),
      .wbs3_bte_i			(wbs_d_vga0_bte_i),
      .wbs3_dat_o			(wbs_d_vga0_dat_o),
      .wbs3_ack_o			(wbs_d_vga0_ack_o),
      .wbs3_err_o			(wbs_d_vga0_err_o),
      .wbs3_rty_o			(wbs_d_vga0_rty_o),
		
      .wbs4_adr_i			(wbs_d_mc1_adr_i),
      .wbs4_dat_i			(wbs_d_mc1_dat_i),
      .wbs4_sel_i			(wbs_d_mc1_sel_i),
      .wbs4_we_i			(wbs_d_mc1_we_i),
      .wbs4_cyc_i			(wbs_d_mc1_cyc_i),
      .wbs4_stb_i			(wbs_d_mc1_stb_i),
      .wbs4_cti_i			(wbs_d_mc1_cti_i),
      .wbs4_bte_i			(wbs_d_mc1_bte_i),
      .wbs4_dat_o			(wbs_d_mc1_dat_o),
      .wbs4_ack_o			(wbs_d_mc1_ack_o),
      .wbs4_err_o			(wbs_d_mc1_err_o),
      .wbs4_rty_o			(wbs_d_mc1_rty_o),

      .wbs5_adr_i			(wbm_b_d_adr_o),
      .wbs5_dat_i			(wbm_b_d_dat_o),
      .wbs5_sel_i			(wbm_b_d_sel_o),
      .wbs5_we_i			(wbm_b_d_we_o),
      .wbs5_cyc_i			(wbm_b_d_cyc_o),
      .wbs5_stb_i			(wbm_b_d_stb_o),
      .wbs5_cti_i			(wbm_b_d_cti_o),
      .wbs5_bte_i			(wbm_b_d_bte_o),
      .wbs5_dat_o			(wbm_b_d_dat_i),
      .wbs5_ack_o			(wbm_b_d_ack_i),
      .wbs5_err_o			(wbm_b_d_err_i),
      .wbs5_rty_o			(wbm_b_d_rty_i),

      // Clock, reset inputs
      .wb_clk			(wb_clk),
      .wb_rst			(wb_rst));

   // These settings are from top level params file
   defparam arbiter_dbus0.wb_addr_match_width = dbus_arb_wb_addr_match_width;
   defparam arbiter_dbus0.wb_num_slaves = dbus_arb_wb_num_slaves;
   defparam arbiter_dbus0.slave0_adr = dbus_arb_slave0_adr;
   defparam arbiter_dbus0.slave1_adr = dbus_arb_slave1_adr;
   defparam arbiter_dbus0.slave2_adr = dbus_arb_slave2_adr;
   defparam arbiter_dbus0.slave3_adr = dbus_arb_slave3_adr;
	defparam arbiter_dbus0.slave4_adr = dbus_arb_slave4_adr;

   //
   // Wishbone byte-wide bus arbiter
   //   
   
   arbiter_bytebus arbiter_bytebus0
     (

      // Master 0
      // Inputs to arbiter from master
      .wbm0_adr_o			(wbm_b_d_adr_o),
      .wbm0_dat_o			(wbm_b_d_dat_o),
      .wbm0_sel_o			(wbm_b_d_sel_o),
      .wbm0_we_o			(wbm_b_d_we_o),
      .wbm0_cyc_o			(wbm_b_d_cyc_o),
      .wbm0_stb_o			(wbm_b_d_stb_o),
      .wbm0_cti_o			(wbm_b_d_cti_o),
      .wbm0_bte_o			(wbm_b_d_bte_o),
      // Outputs to master from arbiter
      .wbm0_dat_i			(wbm_b_d_dat_i),
      .wbm0_ack_i			(wbm_b_d_ack_i),
      .wbm0_err_i			(wbm_b_d_err_i),
      .wbm0_rty_i			(wbm_b_d_rty_i),

      // Byte bus slaves
      
      .wbs0_adr_i			(wbs_d_uart0_adr_i),
      .wbs0_dat_i			(wbs_d_uart0_dat_i),
      .wbs0_we_i			(wbs_d_uart0_we_i),
      .wbs0_cyc_i			(wbs_d_uart0_cyc_i),
      .wbs0_stb_i			(wbs_d_uart0_stb_i),
      .wbs0_cti_i			(wbs_d_uart0_cti_i),
      .wbs0_bte_i			(wbs_d_uart0_bte_i),
      .wbs0_dat_o			(wbs_d_uart0_dat_o),
      .wbs0_ack_o			(wbs_d_uart0_ack_o),
      .wbs0_err_o			(wbs_d_uart0_err_o),
      .wbs0_rty_o			(wbs_d_uart0_rty_o),

      .wbs1_adr_i			(wbs_d_gpio0_adr_i),
      .wbs1_dat_i			(wbs_d_gpio0_dat_i),
      .wbs1_we_i			(wbs_d_gpio0_we_i),
      .wbs1_cyc_i			(wbs_d_gpio0_cyc_i),
      .wbs1_stb_i			(wbs_d_gpio0_stb_i),
      .wbs1_cti_i			(wbs_d_gpio0_cti_i),
      .wbs1_bte_i			(wbs_d_gpio0_bte_i),
      .wbs1_dat_o			(wbs_d_gpio0_dat_o),
      .wbs1_ack_o			(wbs_d_gpio0_ack_o),
      .wbs1_err_o			(wbs_d_gpio0_err_o),
      .wbs1_rty_o			(wbs_d_gpio0_rty_o),

      .wbs2_adr_i			(wbs_d_usb0_adr_i),
      .wbs2_dat_i			(wbs_d_usb0_dat_i),
      .wbs2_we_i			(wbs_d_usb0_we_i),
      .wbs2_cyc_i			(wbs_d_usb0_cyc_i),
      .wbs2_stb_i			(wbs_d_usb0_stb_i),
      .wbs2_cti_i			(wbs_d_usb0_cti_i),
      .wbs2_bte_i			(wbs_d_usb0_bte_i),
      .wbs2_dat_o			(wbs_d_usb0_dat_o),
      .wbs2_ack_o			(wbs_d_usb0_ack_o),
      .wbs2_err_o			(wbs_d_usb0_err_o),
      .wbs2_rty_o			(wbs_d_usb0_rty_o),

      .wbs3_adr_i			(wbs_d_i2c0_adr_i),
      .wbs3_dat_i			(wbs_d_i2c0_dat_i),
      .wbs3_we_i			(wbs_d_i2c0_we_i),
      .wbs3_cyc_i			(wbs_d_i2c0_cyc_i),
      .wbs3_stb_i			(wbs_d_i2c0_stb_i),
      .wbs3_cti_i			(wbs_d_i2c0_cti_i),
      .wbs3_bte_i			(wbs_d_i2c0_bte_i),
      .wbs3_dat_o			(wbs_d_i2c0_dat_o),
      .wbs3_ack_o			(wbs_d_i2c0_ack_o),
      .wbs3_err_o			(wbs_d_i2c0_err_o),
      .wbs3_rty_o			(wbs_d_i2c0_rty_o),

      .wbs4_adr_i			(wbs_d_i2c1_adr_i),
      .wbs4_dat_i			(wbs_d_i2c1_dat_i),
      .wbs4_we_i			(wbs_d_i2c1_we_i),
      .wbs4_cyc_i			(wbs_d_i2c1_cyc_i),
      .wbs4_stb_i			(wbs_d_i2c1_stb_i),
      .wbs4_cti_i			(wbs_d_i2c1_cti_i),
      .wbs4_bte_i			(wbs_d_i2c1_bte_i),
      .wbs4_dat_o			(wbs_d_i2c1_dat_o),
      .wbs4_ack_o			(wbs_d_i2c1_ack_o),
      .wbs4_err_o			(wbs_d_i2c1_err_o),
      .wbs4_rty_o			(wbs_d_i2c1_rty_o),

      .wbs5_adr_i			(wbs_d_i2c2_adr_i),
      .wbs5_dat_i			(wbs_d_i2c2_dat_i),
      .wbs5_we_i			(wbs_d_i2c2_we_i),
      .wbs5_cyc_i			(wbs_d_i2c2_cyc_i),
      .wbs5_stb_i			(wbs_d_i2c2_stb_i),
      .wbs5_cti_i			(wbs_d_i2c2_cti_i),
      .wbs5_bte_i			(wbs_d_i2c2_bte_i),
      .wbs5_dat_o			(wbs_d_i2c2_dat_o),
      .wbs5_ack_o			(wbs_d_i2c2_ack_o),
      .wbs5_err_o			(wbs_d_i2c2_err_o),
      .wbs5_rty_o			(wbs_d_i2c2_rty_o),

      .wbs6_adr_i			(wbs_d_i2c3_adr_i),
      .wbs6_dat_i			(wbs_d_i2c3_dat_i),
      .wbs6_we_i			(wbs_d_i2c3_we_i),
      .wbs6_cyc_i			(wbs_d_i2c3_cyc_i),
      .wbs6_stb_i			(wbs_d_i2c3_stb_i),
      .wbs6_cti_i			(wbs_d_i2c3_cti_i),
      .wbs6_bte_i			(wbs_d_i2c3_bte_i),
      .wbs6_dat_o			(wbs_d_i2c3_dat_o),
      .wbs6_ack_o			(wbs_d_i2c3_ack_o),
      .wbs6_err_o			(wbs_d_i2c3_err_o),
      .wbs6_rty_o			(wbs_d_i2c3_rty_o),

      .wbs7_adr_i			(wbs_d_spi0_adr_i),
      .wbs7_dat_i			(wbs_d_spi0_dat_i),
      .wbs7_we_i			(wbs_d_spi0_we_i),
      .wbs7_cyc_i			(wbs_d_spi0_cyc_i),
      .wbs7_stb_i			(wbs_d_spi0_stb_i),
      .wbs7_cti_i			(wbs_d_spi0_cti_i),
      .wbs7_bte_i			(wbs_d_spi0_bte_i),
      .wbs7_dat_o			(wbs_d_spi0_dat_o),
      .wbs7_ack_o			(wbs_d_spi0_ack_o),
      .wbs7_err_o			(wbs_d_spi0_err_o),
      .wbs7_rty_o			(wbs_d_spi0_rty_o),

      .wbs8_adr_i			(wbs_d_spi1_adr_i),
      .wbs8_dat_i			(wbs_d_spi1_dat_i),
      .wbs8_we_i			(wbs_d_spi1_we_i),
      .wbs8_cyc_i			(wbs_d_spi1_cyc_i),
      .wbs8_stb_i			(wbs_d_spi1_stb_i),
      .wbs8_cti_i			(wbs_d_spi1_cti_i),
      .wbs8_bte_i			(wbs_d_spi1_bte_i),
      .wbs8_dat_o			(wbs_d_spi1_dat_o),
      .wbs8_ack_o			(wbs_d_spi1_ack_o),
      .wbs8_err_o			(wbs_d_spi1_err_o),
      .wbs8_rty_o			(wbs_d_spi1_rty_o),

      .wbs9_adr_i			(wbs_d_spi2_adr_i),
      .wbs9_dat_i			(wbs_d_spi2_dat_i),
      .wbs9_we_i			(wbs_d_spi2_we_i),
      .wbs9_cyc_i			(wbs_d_spi2_cyc_i),
      .wbs9_stb_i			(wbs_d_spi2_stb_i),
      .wbs9_cti_i			(wbs_d_spi2_cti_i),
      .wbs9_bte_i			(wbs_d_spi2_bte_i),
      .wbs9_dat_o			(wbs_d_spi2_dat_o),
      .wbs9_ack_o			(wbs_d_spi2_ack_o),
      .wbs9_err_o			(wbs_d_spi2_err_o),
      .wbs9_rty_o			(wbs_d_spi2_rty_o),

      .wbs10_adr_i			(wbs_d_flashrom_adr_i),
      .wbs10_dat_i			(wbs_d_flashrom_dat_i),
      .wbs10_we_i			(wbs_d_flashrom_we_i),
      .wbs10_cyc_i			(wbs_d_flashrom_cyc_i),
      .wbs10_stb_i			(wbs_d_flashrom_stb_i),
      .wbs10_cti_i			(wbs_d_flashrom_cti_i),
      .wbs10_bte_i			(wbs_d_flashrom_bte_i),
      .wbs10_dat_o			(wbs_d_flashrom_dat_o),
      .wbs10_ack_o			(wbs_d_flashrom_ack_o),
      .wbs10_err_o			(wbs_d_flashrom_err_o),
      .wbs10_rty_o			(wbs_d_flashrom_rty_o),

      .wbs11_adr_i			(wbs_d_usb1_adr_i),
      .wbs11_dat_i			(wbs_d_usb1_dat_i),
      .wbs11_we_i			(wbs_d_usb1_we_i),
      .wbs11_cyc_i			(wbs_d_usb1_cyc_i),
      .wbs11_stb_i			(wbs_d_usb1_stb_i),
      .wbs11_cti_i			(wbs_d_usb1_cti_i),
      .wbs11_bte_i			(wbs_d_usb1_bte_i),
      .wbs11_dat_o			(wbs_d_usb1_dat_o),
      .wbs11_ack_o			(wbs_d_usb1_ack_o),
      .wbs11_err_o			(wbs_d_usb1_err_o),
      .wbs11_rty_o			(wbs_d_usb1_rty_o),
		
      .wbs12_adr_i			(wbs_d_ps20_adr_i),
      .wbs12_dat_i			(wbs_d_ps20_dat_i),
      .wbs12_we_i			(wbs_d_ps20_we_i),
      .wbs12_cyc_i			(wbs_d_ps20_cyc_i),
      .wbs12_stb_i			(wbs_d_ps20_stb_i),
      .wbs12_cti_i			(wbs_d_ps20_cti_i),
      .wbs12_bte_i			(wbs_d_ps20_bte_i),
      .wbs12_dat_o			(wbs_d_ps20_dat_o),
      .wbs12_ack_o			(wbs_d_ps20_ack_o),
      .wbs12_err_o			(wbs_d_ps20_err_o),
      .wbs12_rty_o			(wbs_d_ps20_rty_o),
		
      .wbs13_adr_i			(wbs_d_ps21_adr_i),
      .wbs13_dat_i			(wbs_d_ps21_dat_i),
      .wbs13_we_i			(wbs_d_ps21_we_i),
      .wbs13_cyc_i			(wbs_d_ps21_cyc_i),
      .wbs13_stb_i			(wbs_d_ps21_stb_i),
      .wbs13_cti_i			(wbs_d_ps21_cti_i),
      .wbs13_bte_i			(wbs_d_ps21_bte_i),
      .wbs13_dat_o			(wbs_d_ps21_dat_o),
      .wbs13_ack_o			(wbs_d_ps21_ack_o),
      .wbs13_err_o			(wbs_d_ps21_err_o),
      .wbs13_rty_o			(wbs_d_ps21_rty_o),

      // Clock, reset inputs
      .wb_clk			(wb_clk),
      .wb_rst			(wb_rst));

   defparam arbiter_bytebus0.wb_addr_match_width = bbus_arb_wb_addr_match_width;
   defparam arbiter_bytebus0.wb_num_slaves = bbus_arb_wb_num_slaves;

   defparam arbiter_bytebus0.slave0_adr = bbus_arb_slave0_adr;
   defparam arbiter_bytebus0.slave1_adr = bbus_arb_slave1_adr;
   defparam arbiter_bytebus0.slave2_adr = bbus_arb_slave2_adr;
   defparam arbiter_bytebus0.slave3_adr = bbus_arb_slave3_adr;
   defparam arbiter_bytebus0.slave4_adr = bbus_arb_slave4_adr;
   defparam arbiter_bytebus0.slave5_adr = bbus_arb_slave5_adr;
   defparam arbiter_bytebus0.slave6_adr = bbus_arb_slave6_adr;
   defparam arbiter_bytebus0.slave7_adr = bbus_arb_slave7_adr;
   defparam arbiter_bytebus0.slave8_adr = bbus_arb_slave8_adr;
   defparam arbiter_bytebus0.slave9_adr = bbus_arb_slave9_adr;
   defparam arbiter_bytebus0.slave10_adr = bbus_arb_slave10_adr;
   defparam arbiter_bytebus0.slave11_adr = bbus_arb_slave11_adr;
	defparam arbiter_bytebus0.slave12_adr = bbus_arb_slave12_adr;
	defparam arbiter_bytebus0.slave13_adr = bbus_arb_slave13_adr;


`ifdef GENERIC_JTAG_TAP
   ////////////////////////////////////////////////////////////////////////
   //
   // GENERIC JTAG TAP
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire 				  dbg_if_select;   
   wire 				  dbg_if_tdo;
   wire 				  jtag_tap_tdo;
	wire 				  jtag_tap_shift_dr;
	wire 				  jtag_tap_pause_dr;
	wire 				  jtag_tap_update_dr;
	wire 				  jtag_tap_capture_dr;
	wire 				  jtag_tap_shift_dr;
   wire					  test_logic_reset;

   assign test_logic_reset = wb_rst;
   
   //
   // Instantiation
   //

   jtag_tap jtag_tap0
     (
      // Ports to pads
      .tdo_pad_o			(tdo_pad_o),
      .tms_pad_i			(tms_pad_i),
      .tck_pad_i			(dbg_tck),
      .trst_pad_i			(async_rst),
      .tdi_pad_i			(tdi_pad_i),
      
      .tdo_padoe_o			(tdo_padoe_o),
      
      .tdo_o				(jtag_tap_tdo),

      .shift_dr_o			(jtag_tap_shift_dr),
      .pause_dr_o			(jtag_tap_pause_dr),
      .update_dr_o			(jtag_tap_update_dr),
      .capture_dr_o			(jtag_tap_capture_dr),
      
      .extest_select_o			(),
      .sample_preload_select_o		(),
      .mbist_select_o			(),
      .debug_select_o			(dbg_if_select),

      
      .bs_chain_tdi_i			(1'b0),
      .mbist_tdi_i			(1'b0),
      .debug_tdi_i			(dbg_if_tdo)
      
      );
   
   ////////////////////////////////////////////////////////////////////////
`elsif ALTERA_JTAG_TAP
   //
   // Altera virtual jtag tap from adv_debugsys
   //
  
   wire 				  dbg_if_select;   
   wire 				  dbg_if_tdo;
   wire 				  jtag_tap_tdo;   
   wire 				  jtag_tap_shift_dr;
   wire					  jtag_tap_pause_dr;
	wire 				  wirejtag_tap_shift_dr;
   wire 				  jtag_tap_update_dr;
   wire					  jtag_tap_capture_dr;
   wire					  test_logic_reset;
  
   altera_virtual_jtag jtag_tap0
     (
      .tck_o                              (dbg_tck),
      .debug_tdo_i                        (dbg_if_tdo),
      .tdi_o                              (jtag_tap_tdo),
      .test_logic_reset_o                 (test_logic_reset),
      .run_test_idle_o                    (),
      .shift_dr_o                         (jtag_tap_shift_dr),
      .capture_dr_o                       (jtag_tap_capture_dr),
      .pause_dr_o                         (jtag_tap_pause_dr),
      .update_dr_o                        (jtag_tap_update_dr),
      .debug_select_o                     (dbg_if_select)
      );
`endif
   ////////////////////////////////////////////////////////////////////////
   //
   // Processor debug wires
   // 
   ////////////////////////////////////////////////////////////////////////
   
   wire [31:0] 				  or1k_dbg_dat_i;
   wire [31:0] 				  or1k_dbg_adr_i;
   wire 				  or1k_dbg_we_i;
   wire 				  or1k_dbg_stb_i;
   wire 				  or1k_dbg_ack_o;
   wire [31:0] 				  or1k_dbg_dat_o;
   
   wire 				  or1k_dbg_stall_i;
   wire 				  or1k_dbg_bp_o;
   wire 				  or1k_dbg_rst;

`ifdef OR1200   
   ////////////////////////////////////////////////////////////////////////
   //
   // OpenRISC processor
   // 
   ////////////////////////////////////////////////////////////////////////

   // 
   // Wires
   // 
   
   wire [31:0] 				  cpu_irq;
   wire 				  or1k_dbg_ewt_i;
   wire [3:0] 				  or1k_dbg_lss_o;
   wire [1:0] 				  or1k_dbg_is_o;
   wire [10:0] 				  or1k_dbg_wp_o;

   wire 				  or1200_clk, or1200_rst;
   wire 				  sig_tick;
   
   //
   // Assigns
   //
   assign or1200_clk = wb_clk;
   assign or1200_rst = wb_rst /* | or1k_dbg_rst*/;

   // 
   // Instantiation
   //    
   or1200_top or1200_top0
       (
	// Instruction bus, clocks, reset
	.iwb_clk_i			(wb_clk),
	.iwb_rst_i			(wb_rst),
	.iwb_ack_i			(wbm_i_or12_ack_i),
	.iwb_err_i			(wbm_i_or12_err_i),
	.iwb_rty_i			(wbm_i_or12_rty_i),
	.iwb_dat_i			(wbm_i_or12_dat_i),
	
	.iwb_cyc_o			(wbm_i_or12_cyc_o),
	.iwb_adr_o			(wbm_i_or12_adr_o),
	.iwb_stb_o			(wbm_i_or12_stb_o),
	.iwb_we_o			(wbm_i_or12_we_o),
	.iwb_sel_o			(wbm_i_or12_sel_o),
	.iwb_dat_o			(wbm_i_or12_dat_o),
	.iwb_cti_o			(wbm_i_or12_cti_o),
	.iwb_bte_o			(wbm_i_or12_bte_o),
	
	// Data bus, clocks, reset            
	.dwb_clk_i			(wb_clk),
	.dwb_rst_i			(wb_rst),
	.dwb_ack_i			(wbm_d_or12_ack_i),
	.dwb_err_i			(wbm_d_or12_err_i),
	.dwb_rty_i			(wbm_d_or12_rty_i),
	.dwb_dat_i			(wbm_d_or12_dat_i),

	.dwb_cyc_o			(wbm_d_or12_cyc_o),
	.dwb_adr_o			(wbm_d_or12_adr_o),
	.dwb_stb_o			(wbm_d_or12_stb_o),
	.dwb_we_o			(wbm_d_or12_we_o),
	.dwb_sel_o			(wbm_d_or12_sel_o),
	.dwb_dat_o			(wbm_d_or12_dat_o),
	.dwb_cti_o			(wbm_d_or12_cti_o),
	.dwb_bte_o			(wbm_d_or12_bte_o),
	
	// Debug interface ports
	.dbg_stall_i			(or1k_dbg_stall_i),
	//.dbg_ewt_i			(or1k_dbg_ewt_i),
	.dbg_ewt_i			(1'b0),
	.dbg_lss_o			(or1k_dbg_lss_o),
	.dbg_is_o			(or1k_dbg_is_o),
	.dbg_wp_o			(or1k_dbg_wp_o),
	.dbg_bp_o			(or1k_dbg_bp_o),

	.dbg_adr_i			(or1k_dbg_adr_i),      
	.dbg_we_i			(or1k_dbg_we_i ), 
	.dbg_stb_i			(or1k_dbg_stb_i),          
	.dbg_dat_i			(or1k_dbg_dat_i),
	.dbg_dat_o			(or1k_dbg_dat_o),
	.dbg_ack_o			(or1k_dbg_ack_o),
	
	.pm_clksd_o			(),
	.pm_dc_gate_o			(),
	.pm_ic_gate_o			(),
	.pm_dmmu_gate_o			(),
	.pm_immu_gate_o			(),
	.pm_tt_gate_o			(),
	.pm_cpu_gate_o			(),
	.pm_wakeup_o			(),
	.pm_lvolt_o			(),

	// Core clocks, resets
	.clk_i				(or1200_clk),
	.rst_i				(or1200_rst),
	.aes_clk_i				(aes_clk),
	
	.clmode_i			(2'b00),
	// Interrupts      
	.pic_ints_i			(cpu_irq),
	.sig_tick(sig_tick),
	/*
	 .mbist_so_o			(),
	 .mbist_si_i			(0),
	 .mbist_ctrl_i			(0),
	 */

	.pm_cpustall_i			(1'b0),
	//.seed_ram_access		(seed_ram_access)

	);
   
   ////////////////////////////////////////////////////////////////////////
`endif //  `ifdef OR1200

`ifdef MOR1KX

   parameter MOR1KX_CPU0_OPTION_CPU = "CAPPUCCINO";
//   parameter MOR1KX_CPU0_OPTION_CPU = "ESPRESSO";

   wire [31:1] 				  cpu_irq;

   mor1kx
     #(
       .FEATURE_DEBUGUNIT("ENABLED"),
       .FEATURE_CMOV("ENABLED"),
//       .FEATURE_FFL1("REGISTERED"),
//       .FEATURE_FFL1("NONE"),
//       .OPTION_SHIFTER("SERIAL"),
       .FEATURE_INSTRUCTIONCACHE("ENABLED"),
       .OPTION_ICACHE_BLOCK_WIDTH(5),
       .OPTION_ICACHE_SET_WIDTH(8),
       .OPTION_ICACHE_WAYS(2),
       .OPTION_ICACHE_LIMIT_WIDTH(32),
       .FEATURE_IMMU("ENABLED"),
       .FEATURE_DATACACHE("ENABLED"),
       .OPTION_DCACHE_BLOCK_WIDTH(5),
       .OPTION_DCACHE_SET_WIDTH(8),
       .OPTION_DCACHE_WAYS(2),
       .OPTION_DCACHE_LIMIT_WIDTH(31),
       .FEATURE_DMMU("ENABLED"),
       .OPTION_PIC_TRIGGER("LATCHED_LEVEL"),

       .IBUS_WB_TYPE("B3_REGISTERED_FEEDBACK"),
       .DBUS_WB_TYPE("B3_REGISTERED_FEEDBACK"),
       .OPTION_CPU0(MOR1KX_CPU0_OPTION_CPU),
       .OPTION_RESET_PC(32'hf0000100)
       )
     mor1kx0
     (
      .iwbm_adr_o(wbm_i_or12_adr_o),
      .iwbm_stb_o(wbm_i_or12_stb_o),
      .iwbm_cyc_o(wbm_i_or12_cyc_o),
      .iwbm_sel_o(wbm_i_or12_sel_o),
      .iwbm_we_o (wbm_i_or12_we_o ),
      .iwbm_cti_o(wbm_i_or12_cti_o),
      .iwbm_bte_o(wbm_i_or12_bte_o),
      .iwbm_dat_o(wbm_i_or12_dat_o),

      .dwbm_adr_o(wbm_d_or12_adr_o),
      .dwbm_stb_o(wbm_d_or12_stb_o),
      .dwbm_cyc_o(wbm_d_or12_cyc_o),
      .dwbm_sel_o(wbm_d_or12_sel_o),
      .dwbm_we_o (wbm_d_or12_we_o ),
      .dwbm_cti_o(wbm_d_or12_cti_o),
      .dwbm_bte_o(wbm_d_or12_bte_o),
      .dwbm_dat_o(wbm_d_or12_dat_o),

      .clk(wb_clk),
      .rst(wb_rst),

      .iwbm_err_i(wbm_i_or12_err_i),
      .iwbm_ack_i(wbm_i_or12_ack_i),
      .iwbm_dat_i(wbm_i_or12_dat_i),
      .iwbm_rty_i(wbm_i_or12_rty_i),

      .dwbm_err_i(wbm_d_or12_err_i),
      .dwbm_ack_i(wbm_d_or12_ack_i),
      .dwbm_dat_i(wbm_d_or12_dat_i),
      .dwbm_rty_i(wbm_d_or12_rty_i),

      .irq_i(cpu_irq),

      .du_addr_i(or1k_dbg_adr_i[15:0]),
      .du_stb_i(or1k_dbg_stb_i),
      .du_dat_i(or1k_dbg_dat_i),
      .du_we_i(or1k_dbg_we_i),
      .du_dat_o(or1k_dbg_dat_o),
      .du_ack_o(or1k_dbg_ack_o),
      .du_stall_i(or1k_dbg_stall_i),
      .du_stall_o(or1k_dbg_bp_o)

      );

`endif

`ifdef LEGACY_DBG_IF
   ////////////////////////////////////////////////////////////////////////
   //
   // OR1200 Debug Interface
   // 
   ////////////////////////////////////////////////////////////////////////
   
   dbg_if dbg_if0
     (
      // OR1200 interface
      .cpu0_clk_i			(wb_clk),
      .cpu0_rst_o			(or1k_dbg_rst),      
      .cpu0_addr_o			(or1k_dbg_adr_i),
      .cpu0_data_o			(or1k_dbg_dat_i),
      .cpu0_stb_o			(or1k_dbg_stb_i),
      .cpu0_we_o			(or1k_dbg_we_i),
      .cpu0_data_i			(or1k_dbg_dat_o),
      .cpu0_ack_i			(or1k_dbg_ack_o),      


      .cpu0_stall_o			(or1k_dbg_stall_i),
      .cpu0_bp_i			(or1k_dbg_bp_o),      
      
      // TAP interface
      .tck_i				(dbg_tck),
      .tdi_i				(jtag_tap_tdo),
      .tdo_o				(dbg_if_tdo),      
      .rst_i				(test_logic_reset),
      .shift_dr_i			(jtag_tap_shift_dr),
      .pause_dr_i			(jtag_tap_pause_dr),
      .update_dr_i			(jtag_tap_update_dr),
      .debug_select_i			(dbg_if_select),

      // Wishbone debug master
      .wb_clk_i				(wb_clk),
      .wb_dat_i				(wbm_d_dbg_dat_i),
      .wb_ack_i				(wbm_d_dbg_ack_i),
      .wb_err_i				(wbm_d_dbg_err_i),
      .wb_adr_o				(wbm_d_dbg_adr_o),
      .wb_dat_o				(wbm_d_dbg_dat_o),
      .wb_cyc_o				(wbm_d_dbg_cyc_o),
      .wb_stb_o				(wbm_d_dbg_stb_o),
      .wb_sel_o				(wbm_d_dbg_sel_o),
      .wb_we_o				(wbm_d_dbg_we_o ),
      .wb_cti_o				(wbm_d_dbg_cti_o),
      .wb_cab_o                         (/*   UNUSED  */),
      .wb_bte_o				(wbm_d_dbg_bte_o)
      );
   
   ////////////////////////////////////////////////////////////////////////   
`elsif ADV_DBG_IF

   adv_dbg_if dbg_if0 
     (
      // OR1200 interface
      .cpu0_clk_i			(wb_clk),
      .cpu0_rst_o			(or1k_dbg_rst),      
      .cpu0_addr_o			(or1k_dbg_adr_i),
      .cpu0_data_o			(or1k_dbg_dat_i),
      .cpu0_stb_o			(or1k_dbg_stb_i),
      .cpu0_we_o			(or1k_dbg_we_i),
      .cpu0_data_i			(or1k_dbg_dat_o),
      .cpu0_ack_i			(or1k_dbg_ack_o),      
      .cpu0_stall_o			(or1k_dbg_stall_i),
      .cpu0_bp_i			(or1k_dbg_bp_o),      

      // TAP interface
      .tck_i				(dbg_tck),
      .tdi_i				(jtag_tap_tdo),
      .tdo_o				(dbg_if_tdo),      
      .rst_i				(test_logic_reset),
      .capture_dr_i 			(jtag_tap_capture_dr),
      .shift_dr_i			(jtag_tap_shift_dr),
      .pause_dr_i			(jtag_tap_pause_dr),
      .update_dr_i			(jtag_tap_update_dr),
      .debug_select_i			(dbg_if_select),

      // Wishbone debug master
      .wb_clk_i				(wb_clk),
      .wb_rst_i				(wb_rst),
      .wb_dat_i				(wbm_d_dbg_dat_i),
      .wb_ack_i				(wbm_d_dbg_ack_i),
      .wb_err_i				(wbm_d_dbg_err_i),
      .wb_adr_o				(wbm_d_dbg_adr_o),
      .wb_dat_o				(wbm_d_dbg_dat_o),
      .wb_cyc_o				(wbm_d_dbg_cyc_o),
      .wb_stb_o				(wbm_d_dbg_stb_o),
      .wb_sel_o				(wbm_d_dbg_sel_o),
      .wb_we_o				(wbm_d_dbg_we_o ),
      .wb_cti_o				(wbm_d_dbg_cti_o),
      .wb_bte_o				(wbm_d_dbg_bte_o)
     );

`else

   assign wbm_d_dbg_adr_o = 0;   
   assign wbm_d_dbg_dat_o = 0;   
   assign wbm_d_dbg_cyc_o = 0;   
   assign wbm_d_dbg_stb_o = 0;   
   assign wbm_d_dbg_sel_o = 0;   
   assign wbm_d_dbg_we_o  = 0;   
   assign wbm_d_dbg_cti_o = 0;   
   assign wbm_d_dbg_bte_o = 0;  

   assign or1k_dbg_adr_i = 0;   
   assign or1k_dbg_dat_i = 0;   
   assign or1k_dbg_stb_i = 0;   
   assign or1k_dbg_we_i = 0;
   assign or1k_dbg_stall_i = 0;
   
   ////////////////////////////////////////////////////////////////////////   
`endif // !`ifdef LEGACY_DBG_IF
   
`ifdef VERSATILE_SDRAM
   ////////////////////////////////////////////////////////////////////////
   //
   // Versatile Memory Controller (SDRAM configured)
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //

   wire [15:0] 				  sdram_dq_i;
   wire [15:0] 				  sdram_dq_o;
   wire 				  			  sdram_dq_oe;
	wire [1:0]					sdram_dqm;
	wire 							seed_ram_access;
   wire 							seed_access;
	wire 				  			seed_access_valid;
   //
   // Assigns
   //
	
   //assign seed_access_valid = seed_ram_access & wbm_d_or12_ack_i;   
	
//	assign seed_access_valid = seed_ram_access;
   
//	assign seed_sdram_dq_pad_io = seed_access_valid ?
//	  							sdram_dq_oe ? sdram_dq_o : {16{1'bz}} :
//									{16{1'bz}};

	//assign seed_access = 1;
  
//   assign seed_sdram_dq_pad_io =	sdram_dq_oe ? sdram_dq_o : {16{1'bz}};									
	
//   assign seed_sdram_dqm_pad_o = seed_access_valid ? sdram_dqm : {2{1'b1}};																		

//   assign sdram_dq_pad_io = (!seed_access_valid) ? 
//									sdram_dq_oe ? sdram_dq_o : {16{1'bz}} :
//									{16{1'bz}};
   //assign sdram_dq_pad_io = sdram_dq_oe ? sdram_dq_o : {16{1'bz}};
  
//	assign sdram_dqm_pad_o = (!seed_access_valid) ? sdram_dqm : {2{1'b1}};

//`ifdef VERSATILE_SEED_SDRAM
 //  assign sdram_dq_i = seed_access_valid ? seed_sdram_dq_pad_io : sdram_dq_pad_io;
//`else
//	assign sdram_dq_i = sdram_dq_pad_io;
//`endif

	assign sdram_dq_i = sdram_dq_pad_io;
   assign sdram_dq_pad_io = sdram_dq_oe ? sdram_dq_o : {16{1'bz}};

   assign sdram_clk_pad_o = sdram_clk;

	

   wb_sdram_ctrl 
     #(
       .TECHNOLOGY			("ALTERA"),
       .CLK_FREQ_MHZ			(100),	// sdram_clk freq in MHZ
       .POWERUP_DELAY			(200),	// power up delay in us
`ifdef VERSATILE_SEED_SDRAM
       .WB_PORTS			(4),	// Number of wishbone ports
`else
       .WB_PORTS			(5),	// Number of wishbone ports
`endif
       .ROW_WIDTH			(13),	// Row width
       .COL_WIDTH			(10),	// Column width
       .BA_WIDTH			(2),	// Ba width
       .tCAC				(2),	// CAS Latency
       .tRAC				(4),	// RAS Latency
       .tRP				(2),	// Command Period (PRE to ACT)
       .tRC				(8),	// Command Period (REF to REF / ACT to ACT)
       .tMRD				(2)	// Mode Register Set To Command Delay time
      )
   wb_sdram_ctrl0
     (
      // External SDRAM interface
      .ba_pad_o				(sdram_ba_pad_o[1:0]),
      .a_pad_o				(sdram_a_pad_o[12:0]),
      .cs_n_pad_o			(sdram_cs_n_pad_o),
      .ras_pad_o			(sdram_ras_pad_o),
      .cas_pad_o			(sdram_cas_pad_o),
      .we_pad_o				(sdram_we_pad_o),
      .dq_i				(sdram_dq_i[15:0]),      
      .dq_o				(sdram_dq_o[15:0]),
      //.dqm_pad_o			(sdram_dqm[1:0]),
		.dqm_pad_o			(sdram_dqm_pad_o[1:0]),
      .dq_oe				(sdram_dq_oe),
      .cke_pad_o			(sdram_cke_pad_o),
      .sdram_clk			(sdram_clk),           
      .sdram_rst                        (sdram_rst),

      .wb_clk				(wb_clk),
      .wb_rst				(wb_rst),

      .wb_adr_i				({
					  wbs_i_mc0_adr_i,
					  wbs_d_mc0_adr_i,
`ifdef VERSATILE_SEED_SDRAM
`else
					  wbm_vga0_adr_o,
`endif
					  wbm_sdc_adr_o,
					  wbm_eth0_adr_o
					  }),
      .wb_stb_i				({
					  wbs_i_mc0_stb_i,
					  wbs_d_mc0_stb_i,
`ifdef VERSATILE_SEED_SDRAM
`else
					  wbm_vga0_stb_o,
`endif
					  wbm_sdc_stb_o,
					  wbm_eth0_stb_o
					  }),
      .wb_cyc_i				({
					  wbs_i_mc0_cyc_i,
					  wbs_d_mc0_cyc_i,
`ifdef VERSATILE_SEED_SDRAM
`else
					  wbm_vga0_cyc_o,
`endif
					  wbm_sdc_cyc_o,
					  wbm_eth0_cyc_o
					  }),
      .wb_cti_i				({
					  wbs_i_mc0_cti_i,
					  wbs_d_mc0_cti_i,
`ifdef VERSATILE_SEED_SDRAM
`else
					  wbm_vga0_cti_o,
`endif
					  wbm_sdc_cti_o,
					  wbm_eth0_cti_o
					  }),
      .wb_bte_i				({
					  wbs_i_mc0_bte_i,
					  wbs_d_mc0_bte_i,
`ifdef VERSATILE_SEED_SDRAM
`else
					  wbm_vga0_bte_o,
`endif
					  wbm_sdc_bte_o,
					  wbm_eth0_bte_o
					  }),
      .wb_we_i				({
					  wbs_i_mc0_we_i,
					  wbs_d_mc0_we_i,
`ifdef VERSATILE_SEED_SDRAM
`else
					  wbm_vga0_we_o,
`endif
					  wbm_sdc_we_o,
					  wbm_eth0_we_o
					  }),
      .wb_sel_i				({
					  wbs_i_mc0_sel_i,
					  wbs_d_mc0_sel_i,
`ifdef VERSATILE_SEED_SDRAM
`else
					  wbm_vga0_sel_o,
`endif
					  wbm_sdc_sel_o,
					  wbm_eth0_sel_o
					  }),
      .wb_dat_i				({
					  wbs_i_mc0_dat_i,
					  wbs_d_mc0_dat_i,
`ifdef VERSATILE_SEED_SDRAM
`else
					  wbm_vga0_dat_o,
`endif
					  wbm_sdc_dat_o,
					  wbm_eth0_dat_o
					  }),      
      .wb_dat_o				({
					  wbs_i_mc0_dat_o,
					  wbs_d_mc0_dat_o,
`ifdef VERSATILE_SEED_SDRAM
`else
					  wbm_vga0_dat_i,
`endif
					  wbm_sdc_dat_i,
					  wbm_eth0_dat_i
					  }),
      .wb_ack_o				({
					  wbs_i_mc0_ack_o,
					  wbs_d_mc0_ack_o,
`ifdef VERSATILE_SEED_SDRAM
`else
					  wbm_vga0_ack_i,
`endif
					  wbm_sdc_ack_i,
					  wbm_eth0_ack_i
					  })
      );
      
      

   assign wbs_i_mc0_err_o = 0;
   assign wbs_i_mc0_rty_o = 0;

   assign wbs_d_mc0_err_o = 0;
   assign wbs_d_mc0_rty_o = 0;

   assign wbm_eth0_err_i = 0;
   assign wbm_eth0_rty_i = 0;

`ifdef VERSATILE_SEED_SDRAM
`else
   assign wbm_vga0_err_i = 0;
   assign wbm_vga0_rty_i = 0;
`endif
   
   ////////////////////////////////////////////////////////////////////////
`endif //  `ifdef VERSATILE_SDRAM

   ////////////////////////////////////////////////////////////////////////
   //
   // ROM
   // 
   ////////////////////////////////////////////////////////////////////////
   
   rom rom0
     (
      .wb_dat_o				(wbs_i_rom0_dat_o),
      .wb_ack_o				(wbs_i_rom0_ack_o),
      .wb_adr_i				(wbs_i_rom0_adr_i[(wbs_i_rom0_addr_width+2)-1:2]),
      .wb_stb_i				(wbs_i_rom0_stb_i),
      .wb_cyc_i				(wbs_i_rom0_cyc_i),
      .wb_cti_i				(wbs_i_rom0_cti_i),
      .wb_bte_i				(wbs_i_rom0_bte_i),
      .wb_clk				(wb_clk),
      .wb_rst				(wb_rst));

   defparam rom0.addr_width = wbs_i_rom0_addr_width;

//   assign wbs_i_rom0_err_o = 0;
//   assign wbs_i_rom0_rty_o = 0;
   
   ////////////////////////////////////////////////////////////////////////

   
`ifdef ACTEL_UFR
   ////////////////////////////////////////////////////////////////////////
   //
   // Flash ROM
   // 
   ////////////////////////////////////////////////////////////////////////
   flashrom flashrom0
     (
      .wb_dat_o				(wbs_d_flashrom_dat_o),
      .wb_ack_o				(wbs_d_flashrom_ack_o),
      .wb_err_o				(wbs_d_flashrom_err_o),
      .wb_rty_o				(wbs_d_flashrom_rty_o),
      .wb_adr_i				(wbs_d_flashrom_adr_i[flashrom_wb_adr_width-1:0]),
      .wb_stb_i				(wbs_d_flashrom_stb_i),
      .wb_cyc_i				(wbs_d_flashrom_cyc_i),
      .wb_clk				(wb_clk),
      .wb_rst				(wb_rst));
`else // !`ifdef ACTEL_UFR0
   assign wbs_d_flashrom_dat_o = 0;
   assign wbs_d_flashrom_ack_o = wbs_d_flashrom_stb_i;   
`endif // !`ifdef ACTEL_UFR0
   
   assign wbs_i_rom0_err_o = 0;
   assign wbs_i_rom0_rty_o = 0;

`ifdef RAM_WB
   ////////////////////////////////////////////////////////////////////////
   //
   // Generic RAM
   // 
   ////////////////////////////////////////////////////////////////////////

   ram_wb ram_wb0
     (
      // Wishbone slave interface 0
      .wbm0_dat_i			(wbs_i_mc0_dat_i),
      .wbm0_adr_i			(wbs_i_mc0_adr_i),
      .wbm0_sel_i			(wbs_i_mc0_sel_i),
      .wbm0_cti_i			(wbs_i_mc0_cti_i),
      .wbm0_bte_i			(wbs_i_mc0_bte_i),
      .wbm0_we_i			(wbs_i_mc0_we_i ),
      .wbm0_cyc_i			(wbs_i_mc0_cyc_i),
      .wbm0_stb_i			(wbs_i_mc0_stb_i),
      .wbm0_dat_o			(wbs_i_mc0_dat_o),
      .wbm0_ack_o			(wbs_i_mc0_ack_o),
      .wbm0_err_o                       (wbs_i_mc0_err_o),
      .wbm0_rty_o                       (wbs_i_mc0_rty_o),
      // Wishbone slave interface 1
      .wbm1_dat_i			(wbs_d_mc0_dat_i),
      .wbm1_adr_i			(wbs_d_mc0_adr_i),
      .wbm1_sel_i			(wbs_d_mc0_sel_i),
      .wbm1_cti_i			(wbs_d_mc0_cti_i),
      .wbm1_bte_i			(wbs_d_mc0_bte_i),
      .wbm1_we_i			(wbs_d_mc0_we_i ),
      .wbm1_cyc_i			(wbs_d_mc0_cyc_i),
      .wbm1_stb_i			(wbs_d_mc0_stb_i),
      .wbm1_dat_o			(wbs_d_mc0_dat_o),
      .wbm1_ack_o			(wbs_d_mc0_ack_o),
      .wbm1_err_o                       (wbs_d_mc0_err_o),
      .wbm1_rty_o                       (wbs_d_mc0_rty_o),
      // Wishbone slave interface 2
      .wbm2_dat_i			(wbm_eth0_dat_o),
      .wbm2_adr_i			(wbm_eth0_adr_o),
      .wbm2_sel_i			(wbm_eth0_sel_o),
      .wbm2_cti_i			(wbm_eth0_cti_o),
      .wbm2_bte_i			(wbm_eth0_bte_o),
      .wbm2_we_i			(wbm_eth0_we_o ),
      .wbm2_cyc_i			(wbm_eth0_cyc_o),
      .wbm2_stb_i			(wbm_eth0_stb_o),
      .wbm2_dat_o			(wbm_eth0_dat_i),
      .wbm2_ack_o			(wbm_eth0_ack_i),
      .wbm2_err_o                       (wbm_eth0_err_i),
      .wbm2_rty_o                       (wbm_eth0_rty_i),
      // Clock, reset
      .wb_clk_i				(wb_clk),
      .wb_rst_i				(wb_rst));

   defparam ram_wb0.aw = wb_aw;
   defparam ram_wb0.dw = wb_dw;
   defparam ram_wb0.mem_size_bytes = internal_sram_mem_span;   
   defparam ram_wb0.mem_adr_width = internal_sram_adr_width_for_span;   
   ////////////////////////////////////////////////////////////////////////
`endif //  `ifdef RAM_WB


`ifdef ETH0

   //
   // Wires
   //
   wire        eth0_irq;
   wire [3:0]  eth0_mtxd;
   wire        eth0_mtxen;
   wire        eth0_mtxerr;
   wire        eth0_mtx_clk;
   wire        eth0_mrx_clk;
   wire [3:0]  eth0_mrxd;
   wire        eth0_mrxdv;
   wire        eth0_mrxerr;
   wire        eth0_mcoll;
   wire        eth0_mcrs;
   wire        eth0_speed;
   wire        eth0_duplex;
   wire        eth0_link;
   // Management interface wires
   wire        eth0_md_i;
   wire        eth0_md_o;
   wire        eth0_md_oe;


   //
   // assigns
 `ifdef SMII0
   smii smii0
     (
      // SMII pads
      .eth_sync_pad_o			(eth0_smii_sync_pad_o),
      .eth_tx_pad_o			(eth0_smii_tx_pad_o),
      .eth_rx_pad_i			(eth0_smii_rx_pad_i),
      
      // MII interface to MAC
      // Transmit
      .mtx_clk				(eth0_mtx_clk),
      .mtxd				(eth0_mtxd[3:0]),
      .mtxen				(eth0_mtxen),
      .mtxerr				(eth0_mtxerr),
      .mrxd				(eth0_mrxd[3:0]),
      // Receive
      .mrxdv				(eth0_mrxdv),
      .mrxerr				(eth0_mrxerr),
      .mrx_clk				(eth0_mrx_clk),
      // Status signals
      .mcoll				(eth0_mcoll),
      .mcrs				(eth0_mcrs),
      .speed				(eth0_speed),
      .duplex				(eth0_duplex),
      .link				(eth0_link),
      
      // Inputs
      .eth_clk				(eth_smii_clk),
      .eth_rst				(eth_smii_rst)
      );

`else // !`ifdef SMII0

   // Hook up MII wires
   assign eth0_mtx_clk   = eth0_tx_clk;
   assign eth0_tx_data   = eth0_mtxd[3:0];
   assign eth0_tx_en     = eth0_mtxen;
   assign eth0_tx_er     = eth0_mtxerr;
   assign eth0_mrxd[3:0] = eth0_rx_data;
   assign eth0_mrxdv     = eth0_dv;
   assign eth0_mrxerr    = eth0_rx_er;
   assign eth0_mrx_clk   = eth0_rx_clk;
   assign eth0_mcoll     = eth0_col;
   assign eth0_mcrs      = eth0_crs;

`endif // !`ifdef SMII0

`ifdef XILINX
   // Xilinx primitive for MDIO tristate
   IOBUF iobuf_phy_smi_data
     (
      // Outputs
      .O                                 (eth0_md_i),
      // Inouts
      .IO                                (eth0_md_pad_io),
      // Inputs
      .I                                 (eth0_md_o),
      .T                                 (!eth0_md_oe));   
`else // !`ifdef XILINX
   
   // Generic technology tristate control for management interface
   assign eth0_md_pad_io = eth0_md_oe ? eth0_md_o : 1'bz;
   assign eth0_md_i = eth0_md_pad_io;
   
`endif // !`ifdef XILINX

`ifdef ETH0_PHY_RST
   assign eth0_rst_n_o = !wb_rst;
`endif
   
   ethmac ethmac0
     (
      // Wishbone Slave interface
      .wb_clk_i		(wb_clk),
      .wb_rst_i		(wb_rst),
      .wb_dat_i		(wbs_d_eth0_dat_i[31:0]),
      .wb_adr_i		(wbs_d_eth0_adr_i[wbs_d_eth0_addr_width-1:2]),
      .wb_sel_i		(wbs_d_eth0_sel_i[3:0]),
      .wb_we_i 		(wbs_d_eth0_we_i),
      .wb_cyc_i		(wbs_d_eth0_cyc_i),
      .wb_stb_i		(wbs_d_eth0_stb_i),
      .wb_dat_o		(wbs_d_eth0_dat_o[31:0]),
      .wb_err_o		(wbs_d_eth0_err_o),
      .wb_ack_o		(wbs_d_eth0_ack_o),
      // Wishbone Master Interface
      .m_wb_adr_o	(wbm_eth0_adr_o[31:0]),
      .m_wb_sel_o	(wbm_eth0_sel_o[3:0]),
      .m_wb_we_o 	(wbm_eth0_we_o),
      .m_wb_dat_o	(wbm_eth0_dat_o[31:0]),
      .m_wb_cyc_o	(wbm_eth0_cyc_o),
      .m_wb_stb_o	(wbm_eth0_stb_o),
      .m_wb_cti_o	(wbm_eth0_cti_o[2:0]),
      .m_wb_bte_o	(wbm_eth0_bte_o[1:0]),
      .m_wb_dat_i	(wbm_eth0_dat_i[31:0]),
      .m_wb_ack_i	(wbm_eth0_ack_i),
      .m_wb_err_i	(wbm_eth0_err_i),

      // Ethernet MII interface
      // Transmit
      .mtxd_pad_o	(eth0_mtxd[3:0]),
      .mtxen_pad_o	(eth0_mtxen),
      .mtxerr_pad_o	(eth0_mtxerr),
      .mtx_clk_pad_i	(eth0_mtx_clk),
      // Receive
      .mrx_clk_pad_i	(eth0_mrx_clk),
      .mrxd_pad_i	(eth0_mrxd[3:0]),
      .mrxdv_pad_i	(eth0_mrxdv),
      .mrxerr_pad_i	(eth0_mrxerr),
      .mcoll_pad_i	(eth0_mcoll),
      .mcrs_pad_i	(eth0_mcrs),
      // Management interface
      .md_pad_i		(eth0_md_i),
      .mdc_pad_o	(eth0_mdc_pad_o),
      .md_pad_o		(eth0_md_o),
      .md_padoe_o	(eth0_md_oe),

      // Processor interrupt
      .int_o		(eth0_irq)
      
      /*
       .mbist_so_o			(),
       .mbist_si_i			(),
       .mbist_ctrl_i			()
       */
      
      );

   assign wbs_d_eth0_rty_o = 0;

`else
   assign wbs_d_eth0_dat_o = 0;
   assign wbs_d_eth0_err_o = 0;
   assign wbs_d_eth0_ack_o = 0;
   assign wbs_d_eth0_rty_o = 0;
   assign wbm_eth0_adr_o = 0;
   assign wbm_eth0_sel_o = 0;
   assign wbm_eth0_we_o = 0;
   assign wbm_eth0_dat_o = 0;
   assign wbm_eth0_cyc_o = 0;
   assign wbm_eth0_stb_o = 0;
   assign wbm_eth0_cti_o = 0;
   assign wbm_eth0_bte_o = 0;
`endif
   
`ifdef UART0
   ////////////////////////////////////////////////////////////////////////
   //
   // UART0
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire        uart0_irq;

   //
   // Assigns
   //
   assign wbs_d_uart0_err_o = 0;
   assign wbs_d_uart0_rty_o = 0;
   
   uart16550 uart16550_0
     (
      // Wishbone slave interface
      .wb_clk_i				(wb_clk),
      .wb_rst_i				(wb_rst),
      .wb_adr_i				(wbs_d_uart0_adr_i[uart0_addr_width-1:0]),
      .wb_dat_i				(wbs_d_uart0_dat_i),
      .wb_we_i				(wbs_d_uart0_we_i),
      .wb_stb_i				(wbs_d_uart0_stb_i),
      .wb_cyc_i				(wbs_d_uart0_cyc_i),
      //.wb_sel_i				(),
      .wb_dat_o				(wbs_d_uart0_dat_o),
      .wb_ack_o				(wbs_d_uart0_ack_o),

      .int_o				(uart0_irq),
      .stx_pad_o			(uart0_stx_pad_o),
      .rts_pad_o			(),
      .dtr_pad_o			(),
      //      .baud_o				(),
      // Inputs
      .srx_pad_i			(uart0_srx_pad_i),
      .cts_pad_i			(1'b0),
      .dsr_pad_i			(1'b0),
      .ri_pad_i				(1'b0),
      .dcd_pad_i			(1'b0));

   ////////////////////////////////////////////////////////////////////////          
`else // !`ifdef UART0
   
   //
   // Assigns
   //
   assign wbs_d_uart0_err_o = 0;   
   assign wbs_d_uart0_rty_o = 0;
   assign wbs_d_uart0_ack_o = 0;
   assign wbs_d_uart0_dat_o = 0;
   
   ////////////////////////////////////////////////////////////////////////       
`endif // !`ifdef UART0
   
`ifdef SPI0   
   ////////////////////////////////////////////////////////////////////////
   //
   // SPI0 controller
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire 			     spi0_irq;

   //
   // Assigns
   //
   assign wbs_d_spi0_err_o = 0;
   assign wbs_d_spi0_rty_o = 0;
   
   
   simple_spi spi0
     (
      // Wishbone slave interface
      .clk_i				(wb_clk),
      .rst_i				(wb_rst),
      .cyc_i				(wbs_d_spi0_cyc_i),
      .stb_i				(wbs_d_spi0_stb_i),
      .adr_i				(wbs_d_spi0_adr_i[spi0_wb_adr_width-1:0]),
      .we_i				(wbs_d_spi0_we_i),
      .dat_i				(wbs_d_spi0_dat_i),
      .dat_o				(wbs_d_spi0_dat_o),
      .ack_o				(wbs_d_spi0_ack_o),
      // SPI IRQ
      .inta_o				(spi0_irq),
      // External SPI interface
      .sck_o				(spi0_sck_o),
 `ifdef SPI0_SLAVE_SELECTS      
      .ss_o                             (spi0_ss_o),
 `else
      .ss_o                             (),
 `endif
      .mosi_o				(spi0_mosi_o),      
      .miso_i				(spi0_miso_i)
      );

   defparam spi0.slave_select_width = spi0_ss_width;
   
   ////////////////////////////////////////////////////////////////////////   
`else // !`ifdef SPI0

   //
   // Assigns
   //
   assign wbs_d_spi0_dat_o = 0;
   assign wbs_d_spi0_ack_o = 0;   
   assign wbs_d_spi0_err_o = 0;
   assign wbs_d_spi0_rty_o = 0;
   
   ////////////////////////////////////////////////////////////////////////
`endif // !`ifdef SPI0   


`ifdef SPI1   
   ////////////////////////////////////////////////////////////////////////
   //
   // SPI1 controller
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire 			     spi1_irq;

   //
   // Assigns
   //
   assign wbs_d_spi1_err_o = 0;
   assign wbs_d_spi1_rty_o = 0;
   
   simple_spi spi1
     (
      // Wishbone slave interface
      .clk_i				(wb_clk),
      .rst_i				(wb_rst),
      .cyc_i				(wbs_d_spi1_cyc_i),
      .stb_i				(wbs_d_spi1_stb_i),
      .adr_i				(wbs_d_spi1_adr_i[spi1_wb_adr_width-1:0]),
      .we_i				(wbs_d_spi1_we_i),
      .dat_i				(wbs_d_spi1_dat_i),
      .dat_o				(wbs_d_spi1_dat_o),
      .ack_o				(wbs_d_spi1_ack_o),
      // SPI IRQ
      .inta_o				(spi1_irq),
      // External SPI interface
      .sck_o				(spi1_sck_o),
`ifdef SPI1_SLAVE_SELECTS      
      .ss_o                             (spi1_ss_o),
`else
      .ss_o                             (),
`endif      
      .mosi_o				(spi1_mosi_o),      
      .miso_i				(spi1_miso_i)
      );

   defparam spi1.slave_select_width = spi1_ss_width;   
   
   ////////////////////////////////////////////////////////////////////////   
`else // !`ifdef SPI1

   //
   // Assigns
   //
   assign wbs_d_spi1_dat_o = 0;
   assign wbs_d_spi1_ack_o = 0;   
   assign wbs_d_spi1_err_o = 0;
   assign wbs_d_spi1_rty_o = 0;
   
   ////////////////////////////////////////////////////////////////////////
`endif // !`ifdef SPI1
   

`ifdef SPI2   
   ////////////////////////////////////////////////////////////////////////
   //
   // SPI2 controller
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire 			     spi2_irq;

   //
   // Assigns
   //
   assign wbs_d_spi2_err_o = 0;
   assign wbs_d_spi2_rty_o = 0;
   
   simple_spi spi2
     (
      // Wishbone slave interface
      .clk_i				(wb_clk),
      .rst_i				(wb_rst),
      .cyc_i				(wbs_d_spi2_cyc_i),
      .stb_i				(wbs_d_spi2_stb_i),
      .adr_i				(wbs_d_spi2_adr_i[spi2_wb_adr_width-1:0]),
      .we_i				(wbs_d_spi2_we_i),
      .dat_i				(wbs_d_spi2_dat_i),
      .dat_o				(wbs_d_spi2_dat_o),
      .ack_o				(wbs_d_spi2_ack_o),
      // SPI IRQ
      .inta_o				(spi2_irq),
      // External SPI interface
      .sck_o				(spi2_sck_o),
`ifdef SPI2_SLAVE_SELECTS      
      .ss_o                             (spi2_ss_o),
`else
      .ss_o                             (),
`endif
      .mosi_o				(spi2_mosi_o),      
      .miso_i				(spi2_miso_i)
      );

   defparam spi2.slave_select_width = spi2_ss_width;   
   
   ////////////////////////////////////////////////////////////////////////   
`else // !`ifdef SPI2

   //
   // Assigns
   //
   assign wbs_d_spi2_dat_o = 0;
   assign wbs_d_spi2_ack_o = 0;   
   assign wbs_d_spi2_err_o = 0;
   assign wbs_d_spi2_rty_o = 0;
   
   ////////////////////////////////////////////////////////////////////////
`endif // !`ifdef SPI2   


`ifdef I2C0
   ////////////////////////////////////////////////////////////////////////
   //
   // i2c controller 0
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire 			     i2c0_irq;
   wire 			     scl0_pad_o;
   wire 			     scl0_padoen_o;
   wire 			     sda0_pad_o;
   wire 			     sda0_padoen_o;
   
  i2c_master_slave
    #
    (
     .DEFAULT_SLAVE_ADDR(HV0_SADR)     
    )
  i2c_master_slave0 
    (
     .wb_clk_i			     (wb_clk),
     .wb_rst_i			     (wb_rst),
     .arst_i			     (wb_rst),
     .wb_adr_i			     (wbs_d_i2c0_adr_i[i2c_0_wb_adr_width-1:0]),
     .wb_dat_i			     (wbs_d_i2c0_dat_i),
     .wb_we_i			     (wbs_d_i2c0_we_i ),
     .wb_cyc_i			     (wbs_d_i2c0_cyc_i),
     .wb_stb_i			     (wbs_d_i2c0_stb_i),    
     .wb_dat_o			     (wbs_d_i2c0_dat_o),
     .wb_ack_o			     (wbs_d_i2c0_ack_o),
     .scl_pad_i		             (i2c0_scl_io     ),
     .scl_pad_o		             (scl0_pad_o	 ),
     .scl_padoen_o		     (scl0_padoen_o	 ),
     .sda_pad_i		             (i2c0_sda_io 	 ),
     .sda_pad_o		             (sda0_pad_o	 ),
     .sda_padoen_o		     (sda0_padoen_o	 ),
      
      // Interrupt
     .wb_inta_o		             (i2c0_irq)
    
      );

   assign wbs_d_i2c0_err_o = 0;
   assign wbs_d_i2c0_rty_o = 0;

   // i2c phy lines
   assign i2c0_scl_io = scl0_padoen_o ? 1'bz : scl0_pad_o;  
   assign i2c0_sda_io = sda0_padoen_o ? 1'bz : sda0_pad_o;  


   ////////////////////////////////////////////////////////////////////////
`else // !`ifdef I2C0

   assign wbs_d_i2c0_dat_o = 0;
   assign wbs_d_i2c0_ack_o = 0;
   assign wbs_d_i2c0_err_o = 0;
   assign wbs_d_i2c0_rty_o = 0;

   ////////////////////////////////////////////////////////////////////////
`endif // !`ifdef I2C0   

`ifdef I2C1
   ////////////////////////////////////////////////////////////////////////
   //
   // i2c controller 1
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire 			     i2c1_irq;
   wire 			     scl1_pad_o;
   wire 			     scl1_padoen_o;
   wire 			     sda1_pad_o;
   wire 			     sda1_padoen_o;

   i2c_master_slave
    #
    (
     .DEFAULT_SLAVE_ADDR(HV1_SADR)     
    )
   i2c_master_slave1 
     (
      .wb_clk_i			     (wb_clk),
      .wb_rst_i			     (wb_rst),
      .arst_i			     (wb_rst),
      .wb_adr_i			     (wbs_d_i2c1_adr_i[i2c_1_wb_adr_width-1:0]),
      .wb_dat_i			     (wbs_d_i2c1_dat_i),
      .wb_we_i			     (wbs_d_i2c1_we_i ),
      .wb_cyc_i			     (wbs_d_i2c1_cyc_i),
      .wb_stb_i			     (wbs_d_i2c1_stb_i),    
      .wb_dat_o			     (wbs_d_i2c1_dat_o),
      .wb_ack_o			     (wbs_d_i2c1_ack_o),
      .scl_pad_i		     (i2c1_scl_io     ),
      .scl_pad_o		     (scl1_pad_o	 ),
      .scl_padoen_o		     (scl1_padoen_o	 ),
      .sda_pad_i		     (i2c1_sda_io 	 ),
      .sda_pad_o		     (sda1_pad_o	 ),
      .sda_padoen_o		     (sda1_padoen_o	 ),
      
      // Interrupt
      .wb_inta_o		     (i2c1_irq)
    
      );

   assign wbs_d_i2c1_err_o = 0;
   assign wbs_d_i2c1_rty_o = 0;

   // i2c phy lines
   assign i2c1_scl_io = scl1_padoen_o ? 1'bz : scl1_pad_o;  
   assign i2c1_sda_io = sda1_padoen_o ? 1'bz : sda1_pad_o;  

   ////////////////////////////////////////////////////////////////////////
`else // !`ifdef I2C1   

   assign wbs_d_i2c1_dat_o = 0;
   assign wbs_d_i2c1_ack_o = 0;
   assign wbs_d_i2c1_err_o = 0;
   assign wbs_d_i2c1_rty_o = 0;

   ////////////////////////////////////////////////////////////////////////
`endif // !`ifdef I2C1   

`ifdef I2C2
   ////////////////////////////////////////////////////////////////////////
   //
   // i2c controller 2
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire 			     i2c2_irq;
   wire 			     scl2_pad_o;
   wire 			     scl2_padoen_o;
   wire 			     sda2_pad_o;
   wire 			     sda2_padoen_o;

   i2c_master_slave
    #
     (
     .DEFAULT_SLAVE_ADDR(HV2_SADR)
      )
   hv_i2c_master_slave2 
     (
      .wb_clk_i				(wb_clk),
      .wb_rst_i				(wb_rst),
      .arst_i				(wb_rst),
      .wb_adr_i				(wbs_d_i2c2_adr_i[i2c_2_wb_adr_width-1:0]),
      .wb_dat_i				(wbs_d_i2c2_dat_i),
      .wb_we_i				(wbs_d_i2c2_we_i ),
      .wb_cyc_i				(wbs_d_i2c2_cyc_i),
      .wb_stb_i				(wbs_d_i2c2_stb_i),    
      .wb_dat_o				(wbs_d_i2c2_dat_o),
      .wb_ack_o				(wbs_d_i2c2_ack_o),
      .scl_pad_i			(i2c2_scl_io     ),
      .scl_pad_o			(scl2_pad_o	 ),
      .scl_padoen_o			(scl2_padoen_o	 ),
      .sda_pad_i			(i2c2_sda_io	 ),
      .sda_pad_o			(sda2_pad_o	 ),
      .sda_padoen_o			(sda2_padoen_o	 ),
      
      // Interrupt
      .wb_inta_o			(i2c2_irq)
    
      );

   assign wbs_d_i2c2_err_o = 0;
   assign wbs_d_i2c2_rty_o = 0;

   // i2c phy lines
   assign i2c2_sda_io = scl2_padoen_o ? 1'bz : scl2_pad_o; 
   assign i2c2_scl_io = sda2_padoen_o ? 1'bz : sda2_pad_o;  

   ////////////////////////////////////////////////////////////////////////   

`else // !`ifdef I2C2   
   
   assign wbs_d_i2c2_dat_o = 0;
   assign wbs_d_i2c2_ack_o = 0;
   assign wbs_d_i2c2_err_o = 0;
   assign wbs_d_i2c2_rty_o = 0;

   ////////////////////////////////////////////////////////////////////////

`endif // !`ifdef I2C2   

`ifdef I2C3
   ////////////////////////////////////////////////////////////////////////
   //
   // i2c controller 3
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire 			     i2c3_irq;
   wire 			     scl3_pad_o;
   wire 			     scl3_padoen_o;
   wire 			     sda3_pad_o;
   wire 			     sda3_padoen_o;

   hv_i2c_master_slave
         #
     (
     .DEFAULT_SLAVE_ADDR(HV3_SADR)
      )
     hv_i2c_master_slave3
     (
      .wb_clk_i				(wb_clk),
      .wb_rst_i				(wb_rst),
      .arst_i				(wb_rst),
      .wb_adr_i				(wbs_d_i2c3_adr_i[i2c_3_wb_adr_width-1:0]),
      .wb_dat_i				(wbs_d_i2c3_dat_i),
      .wb_we_i				(wbs_d_i2c3_we_i ),
      .wb_cyc_i				(wbs_d_i2c3_cyc_i),
      .wb_stb_i				(wbs_d_i2c3_stb_i),    
      .wb_dat_o				(wbs_d_i2c3_dat_o),
      .wb_ack_o				(wbs_d_i2c3_ack_o),
      .scl_pad_i			(i2c3_scl_io     ),
      .scl_pad_o			(scl3_pad_o	 ),
      .scl_padoen_o			(scl3_padoen_o	 ),
      .sda_pad_i			(i2c3_sda_io	 ),
      .sda_pad_o			(sda3_pad_o	 ),
      .sda_padoen_o			(sda3_padoen_o	 ),
      
      // Interrupt
      .wb_inta_o			(i2c3_irq)
    
      );

   assign wbs_d_i2c3_err_o = 0;
   assign wbs_d_i2c3_rty_o = 0;

   // i2c phy lines  
   assign i2c3_sda_io = scl3_padoen_o ? 1'bz : scl3_pad_o; 
   assign i2c3_scl_io = sda3_padoen_o ? 1'bz : sda3_pad_o;  

   ////////////////////////////////////////////////////////////////////////
`else // !`ifdef I2C3

   assign wbs_d_i2c3_dat_o = 0;
   assign wbs_d_i2c3_ack_o = 0;
   assign wbs_d_i2c3_err_o = 0;
   assign wbs_d_i2c3_rty_o = 0;

   ////////////////////////////////////////////////////////////////////////
`endif // !`ifdef I2C3

`ifdef USB0
   ////////////////////////////////////////////////////////////////////////
   //
   // USB Host/Slave controller 0
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire 			     usb0_slavesofrxed_irq;
   wire 			     usb0_slaveresetevent_irq;
   wire 			     usb0_slaveresume_irq;
   wire 			     usb0_slavetransdone_irq;
   wire 			     usb0_slavenaksent_irq;
   wire 			     usb0_slavevbusdet_irq;
   wire 			     usb0_hostSOFSentIntOut;
   wire 			     usb0_hostConnEventIntOut;
   wire 			     usb0_hostResumeIntOut;
   wire 			     usb0_hostTransDoneIntOut;
   wire 			     usb0_host_irq, usb0_slave_irq;
   wire 			     usb0_oe;
   wire [1:0] 			     usb0dat_o_int;
			     

   //
   // Registers
   //
   reg [1:0] 			     usb0_rx_data  /*synthesis syn_useioff=1 syn_allow_retiming=0 */;
   reg [1:0] 			     usb0_tx_data /*synthesis syn_useioff=1 syn_allow_retiming=0 */;
   reg 				     usb0_oe_n  /*synthesis syn_useioff=1 syn_allow_retiming=0 */;

   always @(posedge usb_clk) usb0_rx_data <= usb0dat_pad_io;
   always @(posedge usb_clk) usb0_tx_data <= usb0dat_o_int;
   always @(posedge usb_clk) usb0_oe_n <= ~usb0_oe;
   
   
   //
   // Assigns
   //
   assign usb0dat_pad_io = usb0_oe_n ? 1'bz : usb0_tx_data;
   assign usb0ctrl_pad_o = usb0_oe_n; // Actual oe to transciever
   assign usb0_host_irq = usb0_hostSOFSentIntOut | usb0_hostConnEventIntOut |
			 usb0_hostResumeIntOut | usb0_hostTransDoneIntOut;
   assign usb0_slave_irq = usb0_slavesofrxed_irq | usb0_slaveresetevent_irq | 
			  usb0_slaveresume_irq | usb0_slavetransdone_irq | 
			  usb0_slavenaksent_irq/* | usb0_slavevbusdet_irq */;
   
`ifdef USB0_ONLY_HOST
   usbhost usbhost0
`else
     usbhostslave usbhostslave0
`endif     

     (
      // USB PHY lines
      // In
      .usbClk				(usb_clk), // logic clock,48MHz +/-0.25%
      .USBWireDataIn			(usb0_rx_data), // Diff. data in
      // Out
      .USBWireDataOut			(usb0dat_o_int), // Diff. dat out
      .USBWireCtrlOut			(usb0_oe),     // OE
      .USBFullSpeed			(usb0fullspeed_pad_o),// Full speed en.
      //Debug   
      .USBWireDataOutTick		(), // Debug output
      .USBWireDataInTick		(),  // Debug ouptut

      // Interrupt lines
      // Slave
`ifndef USB0_ONLY_HOST
      .slaveSOFRxedIntOut		(usb0_slavesofrxed_irq),
      .slaveResetEventIntOut		(usb0_slaveresetevent_irq),
      .slaveResumeIntOut		(usb0_slaveresume_irq),
      .slaveTransDoneIntOut		(usb0_slavetransdone_irq),
      .slaveNAKSentIntOut		(usb0_slavenaksent_irq),
      .USBDPlusPullup                   (),
      .USBDMinusPullup                  (),      
      .vBusDetect			(1'b1), // bus detect from phy
`endif      

      // Host
      .hostSOFSentIntOut		(usb0_hostSOFSentIntOut),
      .hostConnEventIntOut		(usb0_hostConnEventIntOut),
      .hostResumeIntOut			(usb0_hostResumeIntOut),
      .hostTransDoneIntOut		(usb0_hostTransDoneIntOut),
      // Wishbone slave interface
      .address_i			(wbs_d_usb0_adr_i[wbs_d_usb0_adr_width-1:0]),
      .data_i				(wbs_d_usb0_dat_i),
      .we_i				(wbs_d_usb0_we_i),
      .strobe_i				(wbs_d_usb0_stb_i),
      .data_o				(wbs_d_usb0_dat_o),
      .ack_o				(wbs_d_usb0_ack_o),
      .clk_i				(wb_clk),
      .rst_i				(wb_rst)

      );
   
   assign wbs_d_usb0_err_o = 0;
   assign wbs_d_usb0_rty_o = 0;

`ifdef USB0_ONLY_HOST
   // Tie off unused IRQs if we're only a host
   assign usb0_slavesofrxed_irq = 0;
   assign usb0_slaveresetevent_irq = 0;
   assign usb0_slaveresume_irq = 0;
   assign usb0_slavetransdone_irq = 0;
   assign usb0_slavenaksent_irq = 0;
   assign usb0_slavevbusdet_irq = 0;
`endif
   
`else
   
   assign wbs_d_usb0_dat_o = 0;
   assign wbs_d_usb0_ack_o = 0;
   assign wbs_d_usb0_err_o = 0;
   assign wbs_d_usb0_rty_o = 0;

`endif // !`ifdef USB0

`ifdef USB1
   ////////////////////////////////////////////////////////////////////////
   //
   // USB Host/Slave controller 1
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire 			     usb1_slavesofrxed_irq;
   wire 			     usb1_slaveresetevent_irq;
   wire 			     usb1_slaveresume_irq;
   wire 			     usb1_slavetransdone_irq;
   wire 			     usb1_slavenaksent_irq;
   wire 			     usb1_slavevbusdet_irq;
   wire 			     usb1_hostSOFSentIntOut;
   wire 			     usb1_hostConnEventIntOut;
   wire 			     usb1_hostResumeIntOut;
   wire 			     usb1_hostTransDoneIntOut;
   wire 			     usb1_host_irq, usb1_slave_irq;
   wire 			     usb1_oe;
   wire [1:0] 			     usb1dat_o_int;
			     

   //
   // Registers
   //
   reg [1:0] 			     usb1_rx_data  /*synthesis syn_useioff=1 syn_allow_retiming=0 */;
   reg [1:0] 			     usb1_tx_data /*synthesis syn_useioff=1 syn_allow_retiming=0 */;
   reg 				     usb1_oe_n  /*synthesis syn_useioff=1 syn_allow_retiming=0 */;

   always @(posedge usb_clk) usb1_rx_data <= usb1dat_pad_i;
   always @(posedge usb_clk) usb1_tx_data <= usb1dat_o_int;
   always @(posedge usb_clk) usb1_oe_n <= ~usb1_oe;
   
   
   //
   // Assigns
   //
   assign usb1dat_pad_o = usb1_tx_data;   
   assign usb1ctrl_pad_o = usb1_oe_n; // Actual oe to transciever
   assign usb1_host_irq = usb1_hostSOFSentIntOut | usb1_hostConnEventIntOut |
			 usb1_hostResumeIntOut | usb1_hostTransDoneIntOut;
   assign usb1_slave_irq = usb1_slavesofrxed_irq | usb1_slaveresetevent_irq | 
			  usb1_slaveresume_irq | usb1_slavetransdone_irq | 
			  usb1_slavenaksent_irq /*| usb1_slavevbusdet_irq*/ ;
   
`ifdef USB1_ONLY_HOST
   usbhost usbhost1
`else
 `ifdef USB1_ONLY_SLAVE
   usbslave usbslave1
 `else
   usbhostslave usbhostslave1
 `endif
`endif
     (
      // USB PHY lines
      // In
      .usbClk				(usb_clk), // logic clock,48MHz +/-0.25%
      .USBWireDataIn			(usb1_rx_data), // Diff. data in
      // Out
      .USBWireDataOut			(usb1dat_o_int), // Diff. dat out
      .USBWireCtrlOut			(usb1_oe),     // OE
      .USBFullSpeed			(usb1fullspeed_pad_o),// Full speed en.
      //Debug   
      .USBWireDataOutTick		(), // Debug output
      .USBWireDataInTick		(),  // Debug ouptut    

      // Interrupt lines
      // Slave
`ifndef USB1_ONLY_HOST
      .slaveSOFRxedIntOut		(usb1_slavesofrxed_irq),
      .slaveResetEventIntOut		(usb1_slaveresetevent_irq),
      .slaveResumeIntOut		(usb1_slaveresume_irq),
      .slaveTransDoneIntOut		(usb1_slavetransdone_irq),
      .slaveNAKSentIntOut		(usb1_slavenaksent_irq),
      .slaveVBusDetIntOut               (usb1_slavevbusdet_irq),
      .USBDPlusPullup                   (),
      .USBDMinusPullup                  (),      
      .vBusDetect			(1'b1), // bus detect from phy
`endif      
`ifndef USB1_ONLY_SLAVE
      // Host
      .hostSOFSentIntOut		(usb1_hostSOFSentIntOut),
      .hostConnEventIntOut		(usb1_hostConnEventIntOut),
      .hostResumeIntOut			(usb1_hostResumeIntOut),
      .hostTransDoneIntOut		(usb1_hostTransDoneIntOut),
`endif      
      // Wishbone slave interface
      .address_i			(wbs_d_usb1_adr_i[wbs_d_usb1_adr_width-1:0]),
      .data_i				(wbs_d_usb1_dat_i),
      .we_i				(wbs_d_usb1_we_i),
      .strobe_i				(wbs_d_usb1_stb_i),
      .data_o				(wbs_d_usb1_dat_o),
      .ack_o				(wbs_d_usb1_ack_o),
      .clk_i				(wb_clk),
      .rst_i				(wb_rst)

      );
   
   assign wbs_d_usb1_err_o = 0;
   assign wbs_d_usb1_rty_o = 0;

`ifdef USB1_ONLY_HOST
   // Tie off unused IRQs if we're only a host
   assign usb1_slavesofrxed_irq = 0;
   assign usb1_slaveresetevent_irq = 0;
   assign usb1_slaveresume_irq = 0;
   assign usb1_slavetransdone_irq = 0;
   assign usb1_slavenaksent_irq = 0;
   assign usb1_slavevbusdet_irq = 0;
`endif
`ifdef USB1_ONLY_SLAVE
   assign usb1_hostSOFSentIntOut  = 0;
   assign usb1_hostConnEventIntOut = 0;
   assign usb1_hostResumeIntOut = 0;
   assign usb1_hostTransDoneIntOut = 0;
`endif   
   
`else
   
   assign wbs_d_usb1_dat_o = 0;
   assign wbs_d_usb1_ack_o = 0;
   assign wbs_d_usb1_err_o = 0;
   assign wbs_d_usb1_rty_o = 0;

`endif // !`ifdef USB1

`ifdef SDC_CONTROLLER
   wire 			     sdc_cmd_oe;
   wire 			     sdc_dat_oe;
   wire 			     sdc_cmdIn;
   wire [3:0] 			     sdc_datIn ;
   wire 			     sdc_irq_a;
   wire 			     sdc_irq_b;

   assign sdc_cmd_pad_io = sdc_cmd_oe ? sdc_cmdIn : 1'bz;
   assign sdc_dat_pad_io = sdc_dat_oe  ? sdc_datIn : 4'bzzzz;
   
   assign wbs_d_sdc_err_o = 0;   
   assign wbs_d_sdc_rty_o= 0;	
    
   assign wbm_sdc_err_i = 0;
   assign wbm_sdc_rty_i = 0;

   sdc_controller sdc_controller_0
	(
	 .wb_clk_i (wb_clk),
	 .wb_rst_i (wb_rst),
	 .wb_dat_i (wbs_d_sdc_dat_i),
	 .wb_dat_o (wbs_d_sdc_dat_o),
	 .wb_adr_i (wbs_d_sdc_adr_i[7:0]),
	 .wb_sel_i (4'hf),
	 .wb_we_i  (wbs_d_sdc_we_i),
	 .wb_stb_i (wbs_d_sdc_stb_i),
	 .wb_cyc_i (wbs_d_sdc_cyc_i),
	 .wb_ack_o (wbs_d_sdc_ack_o),
	 
	 .m_wb_adr_o (wbm_sdc_adr_o),
	 .m_wb_sel_o (wbm_sdc_sel_o),
	 .m_wb_we_o  (wbm_sdc_we_o),
	 .m_wb_dat_o (wbm_sdc_dat_o),
	 .m_wb_dat_i (wbm_sdc_dat_i),
	 .m_wb_cyc_o (wbm_sdc_cyc_o),
	 .m_wb_stb_o (wbm_sdc_stb_o),
	 .m_wb_ack_i (wbm_sdc_ack_i),
	 .m_wb_cti_o (wbm_sdc_cti_o),
	 .m_wb_bte_o (wbm_sdc_bte_o),
	 
	 .sd_cmd_dat_i (sdc_cmd_pad_io),
   	 .sd_cmd_out_o (sdc_cmdIn ),
	 .sd_cmd_oe_o  (sdc_cmd_oe),
	 .sd_dat_dat_i (sdc_dat_pad_io  ),
	 .sd_dat_out_o (sdc_datIn  ) ,
  	 .sd_dat_oe_o  (sdc_dat_oe  ),
	 .sd_clk_o_pad (sdc_clk_pad_o),
	 //.card_detect  (sdc_card_detect_pad_i),
	 //.card_detect  (1'b1),

	 .sd_clk_i_pad (wb_clk),
	
	 .int_cmd (sdc_irq_a),
	 .int_data (sdc_irq_b)
	 );

`else

   assign wbs_sdc_err_o = 0;   
   assign wbs_sdc_rty_o= 0;
   assign wbs_sdc_ack_o = 0;
   assign wbs_sdc_dat_o = 0;

`endif   

`ifdef GPIO0
   ////////////////////////////////////////////////////////////////////////
   //
   // GPIO 0
   // 
   ////////////////////////////////////////////////////////////////////////

   gpio gpio0
     (
      // GPIO bus
      .gpio_io				(gpio0_io[gpio0_io_width-1:0]),
      // Wishbone slave interface
      .wb_adr_i				(wbs_d_gpio0_adr_i[gpio0_wb_adr_width-1:0]),
      .wb_dat_i				(wbs_d_gpio0_dat_i),
      .wb_we_i				(wbs_d_gpio0_we_i),
      .wb_cyc_i				(wbs_d_gpio0_cyc_i),
      .wb_stb_i				(wbs_d_gpio0_stb_i),
      .wb_cti_i				(wbs_d_gpio0_cti_i),
      .wb_bte_i				(wbs_d_gpio0_bte_i),
      .wb_dat_o				(wbs_d_gpio0_dat_o),
      .wb_ack_o				(wbs_d_gpio0_ack_o),
      .wb_err_o				(wbs_d_gpio0_err_o),
      .wb_rty_o				(wbs_d_gpio0_rty_o),
      
      .wb_clk				(wb_clk),
      .wb_rst				(wb_rst)
      );

   defparam gpio0.gpio_io_width = gpio0_io_width;
   defparam gpio0.gpio_dir_reset_val = gpio0_dir_reset_val;
   defparam gpio0.gpio_o_reset_val = gpio0_o_reset_val;

   ////////////////////////////////////////////////////////////////////////
`else // !`ifdef GPIO0
   assign wbs_d_gpio0_dat_o = 0;
   assign wbs_d_gpio0_ack_o = 0;
   assign wbs_d_gpio0_err_o = 0;
   assign wbs_d_gpio0_rty_o = 0;
   ////////////////////////////////////////////////////////////////////////
`endif // !`ifdef GPIO0

`ifdef VGA0
   ////////////////////////////////////////////////////////////////////////
   //
   // VGA
   // 
   ////////////////////////////////////////////////////////////////////////

   wire vga0_irq;
   wire vga0_blank;
   wire vga0_hsync;
   wire vga0_vsync;   
   wire vga0_pclk_o;
	wire [7:0] vga0_r_pad_int;
	wire [7:0] vga0_g_pad_int;
	wire [7:0] vga0_b_pad_int;
   
   assign vga0_data_en_o = ~vga0_blank;
   assign vga0_rst_n_o = ~wb_rst;
   // Invert polarity of hsync and vsync to negative
   assign vga0_hsync_pad_o = ~vga0_hsync;
   assign vga0_vsync_pad_o = ~vga0_vsync;
   assign vga0_clk_p_o = vga0_pclk_o;
	assign vga0_r_pad_o[7:4] = vga0_r_pad_int[7:4];
	assign vga0_g_pad_o[7:4] = vga0_g_pad_int[7:4];
	assign vga0_b_pad_o[7:4] = vga0_b_pad_int[7:4];
   
   vga_enh_top
   #(
    .LINE_FIFO_AWIDTH(10)
    )
   vga0
    (
    .wb_clk_i            (wb_clk), 
    .wb_rst_i            (wb_rst),  
    .rst_i               (1'b1), 
    .wb_inta_o           (vga0_irq),
    .wbs_adr_i           (wbs_d_vga0_adr_i[wbs_d_vga0_addr_width-1:0]),
    .wbs_dat_i           (wbs_d_vga0_dat_i[31:0]), 
    .wbs_dat_o           (wbs_d_vga0_dat_o[31:0]), 
    .wbs_sel_i           (wbs_d_vga0_sel_i[3:0]), 
    .wbs_we_i            (wbs_d_vga0_we_i), 
    .wbs_stb_i           (wbs_d_vga0_stb_i), 
    .wbs_cyc_i           (wbs_d_vga0_cyc_i), 
    .wbs_ack_o           (wbs_d_vga0_ack_o), 
    .wbs_rty_o           (wbs_d_vga0_rty_o), 
    .wbs_err_o           (wbs_d_vga0_err_o),
    .wbm_adr_o           (wbm_vga0_adr_o[31:0]),
    .wbm_dat_i           (wbm_vga0_dat_i[31:0]), 
    .wbm_cti_o           (wbm_vga0_cti_o[2:0]), 
    .wbm_bte_o           (wbm_vga0_bte_o[1:0]), 
    .wbm_sel_o           (wbm_vga0_sel_o[3:0]), 
    .wbm_we_o            (wbm_vga0_we_o), 
    .wbm_stb_o           (wbm_vga0_stb_o), 
    .wbm_cyc_o           (wbm_vga0_cyc_o), 
    .wbm_ack_i           (wbm_vga0_ack_i), 
    .wbm_err_i           (wbm_vga0_err_i),
    .clk_p_i             (vga0_pclk),
`ifdef VGA_12BIT_DVI
    .dvi_pclk_p_o        (), 
    .dvi_pclk_m_o        (), 
    .dvi_hsync_o         (), 
    .dvi_vsync_o         (), 
    .dvi_de_o            (), 
    .dvi_d_o             (),
`endif
    .clk_p_o             (vga0_pclk_o), 
    .hsync_pad_o         (vga0_hsync),
    .vsync_pad_o         (vga0_vsync),
    .csync_pad_o         (), 
    .blank_pad_o         (vga0_blank),
    .r_pad_o             (vga0_r_pad_int), 
    .g_pad_o             (vga0_g_pad_int),
    .b_pad_o             (vga0_b_pad_int)
    );
`endif //  `ifdef VGA0
   assign wbm_vga0_dat_o = 0;
	
`ifdef PS20
   ////////////////////////////////////////////////////////////////////////
   //
   // ps2 controller 0
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire 			     ps20_irq;
   
	ps2_wb ps2_wb0 
	(
		.wb_clk_i			(wb_clk),
		.wb_rst_i			(wb_rst),
		.wb_dat_i			(wbs_d_ps20_dat_i),
		.wb_dat_o			(wbs_d_ps20_dat_o),
		.wb_adr_i			(wbs_d_ps20_adr_i[ps2_0_wb_adr_width-1:0]),
		.wb_stb_i			(wbs_d_ps20_stb_i),
		.wb_we_i				(wbs_d_ps20_we_i ),
		.wb_ack_o			(wbs_d_ps20_ack_o),
		.irq_o				(ps20_irq),
		.ps2_clk				(ps20_clk),
		.ps2_dat				(ps20_dat)
	);

   assign wbs_d_ps20_err_o = 0;
   assign wbs_d_ps20_rty_o = 0;


   ////////////////////////////////////////////////////////////////////////
`else // !`ifdef PS20

   assign wbs_d_ps20_dat_o = 0;
   assign wbs_d_ps20_ack_o = 0;
   assign wbs_d_ps20_err_o = 0;
   assign wbs_d_ps20_rty_o = 0;

   ////////////////////////////////////////////////////////////////////////
`endif // !`ifdef PS20   

`ifdef PS21
   ////////////////////////////////////////////////////////////////////////
   //
   // ps2 controller 1
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire 			     ps21_irq;
   
	ps2_wb ps2_wb1 
	(
		.wb_clk_i			(wb_clk),
		.wb_rst_i			(wb_rst),
		.wb_dat_i			(wbs_d_ps21_dat_i),
		.wb_dat_o			(wbs_d_ps21_dat_o),
		.wb_adr_i			(wbs_d_ps21_adr_i[ps2_1_wb_adr_width-1:0]),
		.wb_stb_i			(wbs_d_ps21_stb_i),
		.wb_we_i				(wbs_d_ps21_we_i ),
		.wb_ack_o			(wbs_d_ps21_ack_o),
		.irq_o				(ps21_irq),
		.ps2_clk				(ps21_clk),
		.ps2_dat				(ps21_dat)
	);

   assign wbs_d_ps21_err_o = 0;
   assign wbs_d_ps21_rty_o = 0;


   ////////////////////////////////////////////////////////////////////////
`else // !`ifdef PS21

   assign wbs_d_ps21_dat_o = 0;
   assign wbs_d_ps21_ack_o = 0;
   assign wbs_d_ps21_err_o = 0;
   assign wbs_d_ps21_rty_o = 0;

   ////////////////////////////////////////////////////////////////////////
`endif // !`ifdef PS21  

   
   ////////////////////////////////////////////////////////////////////////
   //
   // OR1200 Interrupt assignment
   // 
   ////////////////////////////////////////////////////////////////////////
   
   assign cpu_irq[1] = 0; // Non-maskable inside OR1200
`ifdef UART0
   assign cpu_irq[2] = uart0_irq;
`else   
   assign cpu_irq[2] = 0;
`endif
`ifdef UART1
   assign cpu_irq[3] = uart1_irq;
`else   
   assign cpu_irq[3] = 0;
`endif
`ifdef ETH0
   assign cpu_irq[4] = eth0_irq;
`else
   assign cpu_irq[4] = 0;
`endif
`ifdef UART2
   assign cpu_irq[5] = uart2_irq;
`else   
   assign cpu_irq[5] = 0;
`endif
`ifdef SPI0
   assign cpu_irq[6] = spi0_irq;
`else   
   assign cpu_irq[6] = 0;
`endif
`ifdef SPI1
   assign cpu_irq[7] = spi1_irq;
`else   
   assign cpu_irq[7] = 0;
`endif
`ifdef SPI2
   assign cpu_irq[8] = spi2_irq;
`else   
   assign cpu_irq[8] = 0;
`endif
   assign cpu_irq[9] = 0;
`ifdef I2C0
   assign cpu_irq[10] = i2c0_irq;
`else   
   assign cpu_irq[10] = 0;
`endif
`ifdef I2C1
   assign cpu_irq[11] = i2c1_irq;
`else   
   assign cpu_irq[11] = 0;
`endif   
`ifdef I2C2
   assign cpu_irq[12] = i2c2_irq;
`else   
   assign cpu_irq[12] = 0;
`endif   
`ifdef I2C3
   assign cpu_irq[13] = i2c3_irq;
`else   
   assign cpu_irq[13] = 0;
`endif
`ifdef SDC_CONTROLLER
   assign cpu_irq[14] = sdc_irq_a;
   assign cpu_irq[15] = sdc_irq_b;
   assign cpu_irq[16] = 0;
`else   
   assign cpu_irq[14] = 0;
   assign cpu_irq[15] = 0;
   assign cpu_irq[16] = 0;
`endif  
   assign cpu_irq[17] = 0;
   assign cpu_irq[18] = 0;
   assign cpu_irq[19] = 0;
`ifdef USB0
   assign cpu_irq[20] = usb0_host_irq;
   assign cpu_irq[21] = usb0_slave_irq;
`else   
   assign cpu_irq[20] = 0;
   assign cpu_irq[21] = 0;
`endif
`ifdef USB1
   assign cpu_irq[22] = usb1_host_irq;
   assign cpu_irq[23] = usb1_slave_irq;
`else   
   assign cpu_irq[22] = 0;
   assign cpu_irq[23] = 0;
`endif   
`ifdef EINT
   assign cpu_irq[24] = eint_pad_i[24];
   assign cpu_irq[25] = ~eint_pad_i[25];
`else
   assign cpu_irq[24] = 0;
   assign cpu_irq[25] = 0;
`endif
`ifdef G_SENSOR
   assign cpu_irq[26] = g_sensor_int;
`else
	assign cpu_irq[26] = 0;
`endif
`ifdef PS20
   assign cpu_irq[27] = ps20_irq;
`else
   assign cpu_irq[27] = 0;
`endif
`ifdef PS21
   assign cpu_irq[28] = ps21_irq;
`else
   assign cpu_irq[28] = 0;
`endif
   assign cpu_irq[29] = 0;
   assign cpu_irq[30] = 0;
   assign cpu_irq[31] = 0;
   
endmodule // orpsoc_top


