//------------------------------
// Module name: aes_cipher_wrapper_lowAesFreq.v
// Function: a wrapper interface that allows AES engine and 
// control FSM operating at different frequency
// Creator:  Bony Chen
// Version:  1.0
// Date:     23 Aug 2015
//------------------------------

`include "or1200_defines.v"

// the ratio of aes_clk over clk
// used to extend the enc done signal 
// so that it can be read by a slower clk

`define IDLE    1'b0
`define LOOP  1'b1

module aes_cipher_wrapper_lowaesfreq(
			  aes_clk,
			  clk, rst,
			  ld, done,
			  key, text_in, text_buf
			  );

   parameter clk_ratio = 2; // clk/aes_clk 
   parameter cntr_width = 4;  // log2(ENC_CLK_RATIO)
   
   input aes_clk;
   input clk;
   input rst;

   input ld;
   output done;

   input [127:0] key;
   input [127:0] text_in;
   output [127:0] text_buf;

   wire [127:0] 	  text_out;
   wire 		  done_extend;
   reg 			  cache_done;
   wire 		  enc_done;
   
   reg 			  ld_pulse;
   
   reg [127:0] 	  text_buf;
   reg [127:0] 	  text_in_cache;   
   reg 		  state;
   reg 		  state_ldpulse;		  
   reg [cntr_width:0] cnt;

   //assign done = cache_done;   

   always @(negedge clk)
     if (enc_done)
       text_buf <= text_out;

   // FSM to extend the enc done signal
   always @(negedge clk or `OR1200_RST_EVENT rst)
      if (rst == `OR1200_RST_VALUE) begin
	 cache_done <= 0;
	 state <= `IDLE;	 
      end
      else begin
	 case (state)
	   
	   `IDLE: begin
	      cache_done <=0;
	      if (enc_done) begin
		 cache_done <= 1;
		 state <= `LOOP;		 
	      end
	      else
		state <= `IDLE;
	   end // case: IDLE	   		 	    

	   `LOOP: begin
	      if (!ld) begin
		 cache_done <= 1;	 
		 state <= `LOOP;
	      end
	      else begin
		 cache_done <= 0;		 
		 state <= `IDLE;
	      end
	   end // case: LOOP	        

	   endcase
      end

   // FSM to generate ld_pulse to aes_cipher_top
   always @(negedge clk or `OR1200_RST_EVENT rst)
      if (rst == `OR1200_RST_VALUE) begin
	 cnt <= clk_ratio;
	 text_in_cache <= 128'b0;	 
	 state_ldpulse <= `IDLE;
      end else begin
	 case (state_ldpulse)

	   `IDLE:
	      if (ld) begin
		 ld_pulse <= 1;
		 text_in_cache <= text_in;		 
		 cnt <= cnt-1;		 
		 state_ldpulse <= `LOOP;
	      end else begin
		 ld_pulse <= 0;
		 cnt <= clk_ratio;		 
		 state_ldpulse <= `IDLE;
	      end	      

	   `LOOP:
	      if (|cnt) begin
		 ld_pulse <= 1;
		 cnt <= cnt-1;
		 state_ldpulse <= `LOOP;
	      end else begin
		 ld_pulse <= 0;
		 cnt <= clk_ratio;
		 state_ldpulse <= `IDLE;		 
	      end
	 endcase
      end // else: !if(rst == `OR1200_RST_VALUE)   

 	

      aes_cipher_top 
	aes_cipher_top (
			.clk(aes_clk), 
			.rst(!rst),
			.ld(ld_pulse),
			.done(enc_done),
			.key(key),
			.text_in(text_in_cache),
			.text_out(text_out)
			);

   or1200_pulse_gen
     done_pulse_gen (
		     .clk(clk),
		     .rst(rst),
		     .in(cache_done),
		     .pulse(done)
		     );
   
endmodule
