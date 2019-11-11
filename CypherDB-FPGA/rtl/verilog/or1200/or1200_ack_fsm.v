//------------------------------
// Module name: or1200_ack_fsm
// Function: the FSM control unit to delay the ack from cache memory 
// in accordance with the unstall signal from the encryption FSM
// Creator:  Bony Chen
// Version:  1.0
// Date:     15 Jan 2015
//------------------------------

`include "or1200_defines.v"

module or1200_ack_fsm(
		      clk, rst,
		      ack_i, enc_fsm_unstall, delayed_ack_o
		      );

   input clk;
   input rst;

   input ack_i;
   input enc_fsm_unstall;

   output delayed_ack_o;

   parameter IDLE = 1'b0;
   parameter WAIT_FOR_UNSTALL = 1'b1;

   reg 	  state;
   reg 	  delayed_ack_o;
   

   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	delayed_ack_o <= 0;	
	state <= IDLE;
     end else begin
	case (state)

	  IDLE:
	    if (ack_i & !enc_fsm_unstall) begin
	       state <= WAIT_FOR_UNSTALL;
	       delayed_ack_o <= 1;      
	    end else begin
	       state <= IDLE;
	       delayed_ack_o <= 0;	       
	    end

	  WAIT_FOR_UNSTALL: 
	     if (enc_fsm_unstall) begin
		delayed_ack_o <= 0;
		state <= IDLE;
	     end else begin
		delayed_ack_o <= 1;
		state <= WAIT_FOR_UNSTALL;
	     end

	endcase // case (state)
     end // else: !if(rst == `OR1200_RST_VALUE)

endmodule