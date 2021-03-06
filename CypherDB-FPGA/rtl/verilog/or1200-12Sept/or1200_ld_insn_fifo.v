//------------------------------
// Module name: or1200_ld_insn_fifo
// Function: store the secure load or load insn issused from the decoder
// stage. They are to be read when there is data coming in from the memory 
// unit to/from the cache memory
// Creator:  Bony Chen
// Version:  1.0
// Date:     13 Jan 2015
//------------------------------

`include "or1200_defines.v"

module or1200_ld_insn_fifo (
			    clk,
			    rst,
			    // write ports
			    ce_w, din,
			    // read ports
			    ce_r, dout,
			    );

   //
   // Default address and data buses width
   //
   
   parameter aw = 4;
   parameter dw = 1;

   //
   // dual-port FIFO interfaces
   //

   input clk;
   input rst;
   input ce_w;
   input [dw-1:0] din;
   input 	  ce_r;
   output [dw-1:0] dout;
   
   or1200_secure_insn_dpram # 
     ( 
       .aw(aw),
       .dw(dw)
       )
   ld_insn_ram (
		.rst(rst),
		// Port A
		.clk_a(clk),
		.ce_a(ce_r),
		.do_a(dout),
      
		// Port B
		.clk_b(clk),
		.ce_b(ce_w),
		.we_b(ce_w),
		.di_b(din)
		);
	
endmodule