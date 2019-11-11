//------------------------------
// Module name: cypherdb_start_pulse_gen
// Function: This pulse generator generates the pulse 5 cycles after the rising edge is detected
// Creator:  Bony Chen
// Version:  1.0
// Date:     1 Dec 2015
//------------------------------


`include "or1200_defines.v"

module cypherdb_start_pulse_gen(
				in, rst, clk,
				start_stall, ra, rb,
				pulse, cache_ra, cache_rb);

   input 			in;		// input, +ve edge to be detected
   input 			clk;		// clock signal
   input 			rst;

   output 			start_stall;
   input [4:0] 			ra;
   input [4:0] 			rb;   
   
   output 			pulse;	// output pulse lasting one clk cycle
   output reg [4:0] 		cache_ra;
   output reg [4:0] 		cache_rb;   

   reg [1:0] 			state;
   reg 				pulse;	
   reg [2:0] 			counter;		
   
   parameter IDLE = 2'd0;	// state coding for IDLE state
   parameter DELAY = 2'd1;   
   parameter WAIT_FOR_TOGGLE = 2'd2;

   assign start_stall = (state == DELAY);   
     
   always @ (posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	pulse <= 0;
	state <= IDLE;
	counter <= 3'd5;
	cache_ra <= 5'b0;
	cache_rb <= 5'b0;	
     end
     else begin
	pulse <= 0;

	if (in == 1) begin
	   cache_ra <= ra;
	   cache_rb <= rb;
	end
	
	case (state)
	  
	  IDLE: begin
	     counter <= 3'd5;
	     pulse <= 0;	     
	     if (in == 1) begin
		state <= DELAY;
	     end
	     else begin
		state <= IDLE;
	     end
	  end

	  DELAY: begin
	     if (|counter)  begin		
		counter <= counter - 1;
		state <= DELAY;			
	     end else begin
		state <= WAIT_FOR_TOGGLE;		
	     end
	  end

	  WAIT_FOR_TOGGLE: begin
		pulse <= 1;
		state <= IDLE;	    
	  end
	  
	  default: state <= IDLE;
	  
	endcase // case (state)
     end
endmodule

