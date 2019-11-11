//------------------------------
// Module name: or1200_enc_pad_shift
// Function: shift the encryption pad generated by the encryption engines
// by feeding it with a seed value. The shift is controlled by:
// - explicitly by a shift instruction which states the shift initially 
//   and the direction of the shift
// - implicitly by the secure load/store instruction
// p.s. shifting instruction has to be executed initially before implicit
// shift occurs
// Creator:  Bony Chen
// Version:  1.0
// Date:     21 Jan 2015
//------------------------------

`include "or1200_defines.v"

`define IDLE 1'd0
`define SHIFT 1'd1

module or1200_enc_pad_shift(
			    clk, rst,
			    // shift value and control inputs
			    shift_ra, shift_rb, shift_imm, shift_read,
			    // enc_fsm_top input
			    enc_pad_in,
			    // or_1200 lsu inputs/outputs
			    to_shift, enc_pad_out,
			    // data cache control inputs and new insn signal
			    ack_i, unstall,
			    // or1200 pipeline stall control signal
			    shift_done, enc_done,
			    // signals used for ofb encryption
			    shifted_value, seed_init
			    );

   input clk;
   input rst;

   input [4:0] shift_ra;
   input [4:0] shift_rb;
   input [10:0] shift_imm;
   input 	shift_read;

   input [127:0] enc_pad_in;
   
   input [`shift_op_size-1:0] to_shift;
   output [31:0] 	      enc_pad_out;

   input 		      ack_i;
   input 		      unstall;

   output 		      shift_done;
   input 		      enc_done;	
   output [7:0] 	      shifted_value;
   input 		      seed_init;

   // internal register
   reg 			      shift_direction;
   reg [7:0] 		      shifted_value;
   reg [127:0] 		      enc_pad_buf;

   reg 			      shift_done;

   reg [10:0] 		      shift_imm_buf;			      
  

   reg 		      state;

   assign enc_pad_out = enc_done ? enc_pad_in[127:96] : enc_pad_buf[127:96];
   
  // assign enc_pad_out = shift_direction ? enc_pad_buf[127:96] : enc_pad_buf[31:0];

  reg enc_done_buf;
  reg [3:0] counter;
	
	always @(posedge clk)
		enc_done_buf <= enc_done;
   
   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	enc_pad_buf <= 0;
	shifted_value <= 0;
	counter <= 0;
	shift_imm_buf <= 0;
     end		     
     else begin
	
	case (state)

	`IDLE: begin

	state <= `IDLE;
	shift_done <= 1'b0;     
	
	if (shift_read) begin
		state <= `SHIFT;
		counter <= shift_imm_buf;
	end else begin
	
	if (seed_init | (shifted_value == 8'h80) | enc_done_buf) begin
	   shifted_value <= 0;
	   enc_pad_buf <= enc_pad_in;
	   if (ack_i) begin
			state <= `IDLE;
			shift_done <= 1;
		   shifted_value <= to_shift;
			if (to_shift == 8'd8) 
				enc_pad_buf <= {enc_pad_in[119:0], 8'b0};
			else if (to_shift == 8'd16)	
				enc_pad_buf <= {enc_pad_in[111:0], 16'b0};			
			else if (to_shift == 8'd32)
				enc_pad_buf <= {enc_pad_in[95:0], 32'b0};
		end
		end 
		else if (ack_i) begin
		  shifted_value <= shifted_value + to_shift;
		  state <= `IDLE;
		  shift_done <= 1;
		  if (to_shift == 8'd8) 
				enc_pad_buf <= {enc_pad_buf[119:0], 8'b0};
			else if (to_shift == 8'd16)	
				enc_pad_buf <= {enc_pad_buf[111:0], 16'b0};			
			else if (to_shift == 8'd32)
				enc_pad_buf <= {enc_pad_buf[95:0], 32'b0};
		end

		end
	end

	`SHIFT: begin
			counter <= counter - 8;
			enc_pad_buf <= {enc_pad_buf[119:0],8'b0};
	      if (!(|counter)) begin
	     	 shift_done <= 1'b1;	  
		    state <= `IDLE;  
	      end  
	    end	
		 
	endcase
     end // else: !if(rst == `OR1200_RST_VALUE)        
   
endmodule	  
