//------------------------------
// Module name: or1200_cypherdb_start
// Function: receive two pulses, one stands for start, one stands for end
// output an asserted signal bounded by these two input pulses
// Creator:  Bony Chen
// Version:  1.0
// Date:     11 Aug 2015
//------------------------------

//  start:           _______|-|_______________________________
//  end:             __________________________________|-|____
//  secure_exec_on:  _________|--------------------------|____
//
//
//


`include "or1200_defines.v"

`define IDLE 1'd0
`define START 1'd1

module or1200_cypherdb_start(
			     clk, rst, ce,
			     start_pulse, end_pulse,
			     secure_exec
			     );

   input clk;
   input rst;
   input ce;

   input start_pulse;
   input end_pulse;

   output secure_exec;

   reg 	  state;
   reg 	  fsm_secure_exec;   
   reg 	  fsm_end_pulse;	  

//   assign secure_exec = fsm_secure_exec | start_pulse | fsm_end_pulse;
      assign secure_exec = fsm_secure_exec | start_pulse;

   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE)
       state <= `IDLE;
     else begin
	if (ce) begin
	   case (state)
	     
	     `IDLE:
	       if (start_pulse)
		 state <= `START;
	       else
		 state <= `IDLE;

	     `START:
	       if (fsm_end_pulse)
		 state <= `IDLE;
	       else
		 state <= `START;

	     default:
	       state <= `IDLE;
	     
	   endcase // case (state)
	end // if (ce)
	else begin
	   state <= `IDLE;	   
	end
     end

   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	fsm_secure_exec <= 0;
	fsm_end_pulse <= 0;
     end
     else begin
	fsm_end_pulse <= end_pulse;
	
	if (ce) begin
	   
	   case (state)

	     `IDLE: 
	       if (start_pulse)
		 fsm_secure_exec <= 1;
	       else fsm_secure_exec <= 0;
	     `START: 
	       if (fsm_end_pulse) begin
		  fsm_secure_exec <= 0;
		  //fsm_end_pulse <= end_pulse;
	       end
	       else begin
		  fsm_secure_exec <= 1;
		  //fsm_end_pulse <= 0;
	       end

	   endcase // case (state)
	end // if (ce)
	else begin
	   fsm_secure_exec <= 0;	   
	end
     end
   
endmodule // or1200_cypherdb_start

	  
	    
