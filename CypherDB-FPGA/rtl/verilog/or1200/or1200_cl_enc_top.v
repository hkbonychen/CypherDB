//------------------------------
// Module name: or1200_cl_enc_top
// Function: top wrapper module of cache line encryption modules
// includes: enc engine, control fsm
// Creator:  Bony Chen
// Version:  1.0
// Date:     13 Aug 2015
//------------------------------

`include "or1200_defines.v"

module or1200_cl_enc_top(
			 aes_clk,
			 clk, rst,
			 // enable, enc start and enc done enc control signal
			 secure_exec, dcpu_cyc_i, dcpu_we_i, tagcomp_miss, cl_enc_eval, 
			 enc_on, enc_done, 
			 // enc input data: encryption key, encryption seed
			 enc_key, seed_in,
			 // enc output encryption pad
			 enc_pad_1, enc_pad_2			 
			 );

`define  padding 128-64-1

   input clk;
   input aes_clk;   
   input rst;

   input secure_exec;
   input dcpu_cyc_i;
   input dcpu_we_i;
   input tagcomp_miss;
   input cl_enc_eval;

   output enc_on;
   output enc_done;  

   input [127:0] enc_key;
   input [63:0] seed_in;
   
   output [127:0] 	       enc_pad_1;
   output [127:0] 	       enc_pad_2;

   wire [127:0] 	       seed_1;
   wire [127:0] 	       seed_2;
   wire 		       enc_start;
   wire 		       enc_done_1;
   wire 		       enc_done_2;
   
   
   assign seed_1 = {{`padding{1'b0}}, seed_in, 1'b0};
   assign seed_2 = {{`padding{1'b0}}, seed_in, 1'b1};

  // assign enc_start = tagcomp_miss & cl_enc_eval & !dmmu_ci & secure_exec & smc_hit;
   assign enc_start = cl_enc_eval & secure_exec;
//   assign enc_done = enc_done_1 & enc_done_2;
   assign enc_done = enc_done_1;
   

   // to cache the enc_pad output from the encryption engine
   // the data after 'done' is buffered into enc_pad_buf
   // always @(posedge clk or `OR1200_RST_EVENT rst) begin
   //    if (rst == `OR1200_RST_VALUE) begin
   // 	 enc_pad_buf_1 <= 128'b0;
   // 	 enc_pad_buf_2 <= 128'b0;
   //    end
   //    else begin
   // 	 if (enc_done_1)
   // 	   enc_pad_buf_1 <= enc_pad_1;
   // 	 if (enc_done_2)
   // 	   enc_pad_buf_2 <= enc_pad_2;	 
   //    end	    
   // end // always @ (posedge clk or `OR1200_RST_EVENT rst)
   
   // Instantiation of the 128 bits AES encryption engine
   // ld: start encryption; done: finish encryption
   // But the engines will generate an output for each cycle
   cl_aes_cipher_wrapper
     cl_aes_cipher1 (
		     .aes_clk(aes_clk),
			.clk(clk), 
			.rst(rst),
			.ld(enc_start),
			.done(enc_done_1),
			.key(enc_key),
			.text_in(seed_1),
			.text_buf(enc_pad_1)
			);

    cl_aes_cipher_wrapper 
     cl_aes_cipher2 (
		     .aes_clk(aes_clk),
		     .clk(clk),
		     .rst(rst),
		     .ld(enc_start),
		     .done(enc_done_2),
		     .key(enc_key),
		     .text_in(seed_2),
		     .text_buf(enc_pad_2)
		     );

   or1200_cypherdb_start
     cl_enc_indicator(
		      .clk(clk),
		      .rst(rst),
		      .ce(1'b1),
  		      .start_pulse(enc_start), 
		      .end_pulse(enc_done_1),
		      .secure_exec(enc_on)
		      );

endmodule // or1200_cl_enc_top

