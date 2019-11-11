//------------------------------
// Module name: or1200_pulse_gen
// Function: Generate one clock pulse on for every load/store
// instruction
// Creator:  Bony Chen
// Version:  1.0
// Date:     11 Jan 2015
//------------------------------

// This code is modified by the pulse generator that
// generates a clock pulse on every +ve edge input signal

// The tricky point here is that there may have two consecutive
// load/store instruction that a simple pulse generator may
// cause error

// case:
//    consecative load/store
//    load/store but piplined stall, and then load/store again

`include "or1200_defines.v"

module or1200_pulse_gen(
			in,
			rst,
			clk,
			pulse);

   input 			in;		// input, +ve edge to be detected
   input 			clk;		// clock signal
   input 			rst;

   output 			pulse;	// output pulse lasting one clk cycle

   reg 				state;
   reg 				pulse;			
   
   parameter	IDLE = 1'b0;	// state coding for IDLE state
   parameter	WAIT_FOR_TOGGLE = 1'b1;
     
   always @ (posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	pulse <= 0;
	state = IDLE;
     end
     else begin
	pulse <= 0;
	case (state)
	  
	  IDLE: begin
	     if (in == 1) begin
		state <= WAIT_FOR_TOGGLE;
		pulse <= 1;
	     end
	     else begin
	       state <= IDLE;
			 pulse <= 0;
		end
	  end

	  WAIT_FOR_TOGGLE: begin
	     if (in == 1) begin
		pulse <= 0;
		state <= WAIT_FOR_TOGGLE;
	     end
	     
	     else state <= IDLE; // in must be zero
	  end
	  
	  default: state <= IDLE;
	  
	endcase // case (state)
     end
endmodule

