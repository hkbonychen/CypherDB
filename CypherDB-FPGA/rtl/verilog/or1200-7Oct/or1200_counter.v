//------------------------------
// Module name: or1200_counter
// Function: a simple incremental counter
// Creator:  Bony Chen
// Version:  1.0
// Date:     12 Jan 2015
//------------------------------

`include "or1200_defines.v"

module or1200_counter(
		      clk,
		      rst,
		      in,
		      out);

   input clk;
   input rst;
   input in;
   output [3:0] out;

   reg [3:0] 	out;
	 
   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE)
       out <= 0;
     else
       if (in)
	 out <= out + 1;
   
endmodule
	 
		  