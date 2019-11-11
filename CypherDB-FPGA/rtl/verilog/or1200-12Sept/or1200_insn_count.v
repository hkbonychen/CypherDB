//------------------------------
// Module name: or1200_insn_count
// Function: keep track of the instruction change and toggle the output
// if a new instruction is detected in decoding stage
// Creator:  Bony Chen
// Version:  1.0
// Date:     12 Jan 2015
//------------------------------

`include "or1200_defines.v"

module or1200_insn_count(
			 clk,
			 rst,
			 wb_freeze,
			 wb_insn,
			 except_flushpipe,
			 ex_dslot,
			 insn);

   input clk;
   input rst;
   input wb_freeze;
   input [31:0] wb_insn;
   input except_flushpipe;
   input ex_dslot;
   
   output insn;

   reg 	  insn;
   
   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE)
	insn <= 0;
     else 
       if (!wb_freeze) begin
	if (((wb_insn[31:26] != `OR1200_OR32_NOP) | !wb_insn[16])
	    & !(except_flushpipe & ex_dslot))
	  insn <= ~insn;
	else
	  if (except_flushpipe)
	    insn <= ~insn;
       end
   
 endmodule
   