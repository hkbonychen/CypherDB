//------------------------------
// Module name: smc_check_top.v
// Function: the top module to check the vitual address to check
// if the address is within the SMC
// Creator:  Bony Chen
// Version:  1.0
// Date:     4 Sep 2015
//------------------------------

// README:
// To check whether the memory access is within SMC, it works as follow:
// 1. input the stack_top and heap_top address via l.start instruction
// 2. check the virtual address output from or1200_cpu to see if the memory access is within the bounded value (stack_top -- heap_top)
// 3. if within the boundary, trigger the cl encryption, and vice versa

`include "or1200_defines.v"

module smc_check_top(
			    ce, hit,
			    addr, low_bound, high_bound
			    );

   input ce;   
   input [31:0] addr;
   input [31:0] low_bound;
   input [31:0] high_bound;

   output 	hit;

   reg 		hit;   

   always @(ce or addr)
	 if (ce && (addr >= low_bound) && (addr <= high_bound))
	   hit = 1'b1;
	 else hit = 1'b0;

endmodule	  
   
   
   