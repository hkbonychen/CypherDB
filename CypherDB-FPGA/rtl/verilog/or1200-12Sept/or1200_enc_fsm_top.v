//------------------------------
// Module name: or1200_enc_fsm_top
// Function: the top module that wraps the fsm and encryption
// engines for load and store path
// unit to/from the cache memory
// Creator:  Bony Chen
// Version:  1.0
// Date:     18 Jan 2015
//------------------------------

// README:
// In the current version, the seed instruction has to be issued in advanced (several
// instructions ahead of the secure store). It is because issuing seed instruction immediately
// before secure store has to delay the cycstb signal so that the store can occur ONLY AFTER the
// seed encryption is completed. This delay is not implemented yet. Therefore, issuing it in
// advance can avoid this problem.
// It remains a problem to be solved....

`include "or1200_defines.v"

module or1200_enc_fsm_top(
			  clk, rst,
			  // input of encryption seed, seedRead
			  seedIn, seedAddr, seedImm, seed_read,
			  // input of shift control of encryption pad
			  shiftRa, shiftRb, shiftImm, shift_read,
			  ex_op,
			  // output of shifted encryption pad
			  enc_pad_shifted_load, enc_pad_shifted_store,
			  // control signal
			  unstall_load, unstall_store,
			  // data cache delayed ack input
			  load_ack_i, store_ack_i,
			  // or1200 pipeline stall control signal
			  xor_stall_load, xor_stall_store
			  );
   
   input clk;
   input rst;

   // Seed Input and control
   input [31:0] seedIn;
   input [4:0] 	seedAddr;
   input [10:0] seedImm;
   input 	seed_read;

   // Shift Input and control
   input [4:0] 	shiftRa;
   input [4:0] 	shiftRb;
   input [10:0] shiftImm;
   input 	shift_read;

   input [`shift_op_size-1:0] ex_op;

   // output of shifted encryption pad
   output [31:0] 	      enc_pad_shifted_load;
   output [31:0] 	      enc_pad_shifted_store;

   // encryption data and control I/O
   output 		      unstall_load;
   output 		      unstall_store;

   input 		      load_ack_i;
   input 		      store_ack_i;

   output 		      xor_stall_load;
   output 		      xor_stall_store;	 

   // common registeres and wires for LOAD and STORE
   wire [127:0] 	      encryption_key;
   
   // internal registers and wires for LOAD
   wire [31:0] 		      seedIn_load;
   wire [4:0] 		      seedAddr_load;
   wire [10:0] 		      seedImm_load;
   
   // internal registers and wires for STORE
   wire [31:0] 		      seedIn_store;
   wire [4:0] 		      seedAddr_store;
   wire [10:0] 		      seedImm_store;

   // internal wire to shift module
   wire [127:0] 	      enc_pad_load;
   wire [127:0] 	      enc_pad_store;
	
   wire [127:0] 	      enc_pad_buf_load;
   wire [127:0] 	      enc_pad_buf_store;
   
   wire 		      enc_done_load;
   wire 		      enc_done_store;

   wire [31:0] 		      enc_pad_shifted_load;
   wire [31:0] 		      enc_pad_shifted_store;

   wire 		      xor_stall_load;
   wire 		      xor_stall_store;
   
   assign encryption_key = 128'h202122232425262728292a2b2c2d2e2f;
 
   // Instantiation of LOAD fsm and encryption engines
   or1200_encryption_fsm
     or1200_enc_load_fsm(
			 .clk(clk),
			 .rst(rst),
			 .seedRead(seedRead_load),
			 .seedIn(seedIn_load),
			 .seedAddr(seedAddr_load),
			 .seedImm(seedImm_load),
			 .enc_key(encryption_key),
			 .enc_pad(enc_pad_load),
			 .enc_pad_buf(enc_pad_buf_load),		 
			 .enc_done(enc_done_load),
			 .unstall(unstall_load),
			 .shifted_value(shifted_value_load),
			 .ack_i(load_ack_i)
			 );

   or1200_encryption_fsm
     or1200_enc_store_fsm(
			  .clk(clk),
			  .rst(rst),
			  .seedRead(seedRead_store),
			  .seedIn(seedIn_store),
			  .seedAddr(seedAddr_store),
			  .seedImm(seedImm_store),
			  .enc_key(encryption_key),
			  .enc_pad(enc_pad_store),		
			  .enc_pad_buf(enc_pad_buf_store),		  
			  .enc_done(enc_done_store),	  
			  .unstall(unstall_store),
			  .shifted_value(shifted_value_store),
			  .ack_i(store_ack_i)
			  );

	assign seedRead_load = (!seedImm[10] & seed_read) ? seed_read : 1'b0;
   assign seedImm_load = (!seedImm[10] & seed_read) ? seedImm : 11'b0;
   assign seedIn_load = (!seedImm[10] & seed_read) ? seedIn : 32'b0;
   assign seedAddr_load = (!seedImm[10] & seed_read) ? seedAddr : 5'b0;

	assign seedRead_store = (seedImm[10] & seed_read) ? seed_read : 1'b0;
   assign seedImm_store = (seedImm[10] & seed_read) ? seedImm : 11'b0;
   assign seedIn_store = (seedImm[10] & seed_read) ? seedIn : 32'b0;
   assign seedAddr_store = (seedImm[10] & seed_read) ? seedAddr : 5'b0;

   wire [`shift_op_size-1:0]  ex_op_load;
   wire [`shift_op_size-1:0]  ex_op_store;

   wire 		      shift_read_load;
   wire 		      shift_read_store;

   wire [7:0] 		      shifted_value_load;
   wire [7:0] 		      shifted_value_store;

   // store the ex_op into two buffers according to the most significant bit
   assign ex_op_load = ex_op[`shift_op_size-1] ? 0 : {1'b0, ex_op[`shift_op_size-2:0]};
   assign ex_op_store = ex_op[`shift_op_size-1] ? {1'b0, ex_op[`shift_op_size-2:0]} : 0;

   assign shift_read_load = shiftImm[10] ? 0 : shift_read;
   assign shift_read_store = shiftImm[10] ? shift_read : 0;

   //
   // Instantiation of the encryption pad shifting module
   //

   or1200_enc_pad_shift
     or1200_shift_load(
		       .clk(clk),
		       .rst(rst),
		       .shift_ra(shiftRa),
		       .shift_rb(shiftRb),
		       .shift_imm(shiftImm),
		       .shift_read(shift_read_load),
		       .enc_pad_in(enc_pad_buf_load),
		       .to_shift(ex_op_load),
		       .enc_pad_out(enc_pad_shifted_load),
		       .ack_i(load_ack_i),
		       .unstall(unstall_load | enc_done_load),
		       .shift_done(xor_stall_load),
		       .enc_done(enc_done_load),
		       .shifted_value(shifted_value_load),
		       .seed_init(seed_init_load)
		       );

   or1200_enc_pad_shift
     or1200_shift_store(
			.clk(clk),
			.rst(rst),
			.shift_ra(shiftRa),
			.shift_rb(shiftRb),
			.shift_imm(shiftImm),
			.shift_read(shift_read_store),
			.enc_pad_in(enc_pad_buf_store),
			.to_shift(ex_op_store),
			.enc_pad_out(enc_pad_shifted_store),
			.ack_i(store_ack_i),
			.unstall(unstall_store | enc_done_store),
			.shift_done(xor_stall_store),
			.enc_done(enc_done_store),
			.shifted_value(shifted_value_store),
			.seed_init(seed_init_store)
			);

   wire 		      seed_init_load;
   wire 		      seed_init_store;

   //
   // Instantiation of the first encryption pad detector
   //
   or1200_first_enc_pad_detector
     or1200_detect_new_seed_load(
				 .clk(clk),
				 .rst(rst),
				 .seed_read(seedRead_load),
				 .enc_done(enc_done_load),
				 .new_data_seed(seed_init_load)
				 );

   or1200_first_enc_pad_detector
     or1200_detect_new_seed_store(
				  .clk(clk),
				  .rst(rst),
				  .seed_read(seedRead_store),
				  .enc_done(enc_done_store),
				  .new_data_seed(seed_init_store)
				 );

   wire [127:0] 	      ofb_pad_load;
   wire [127:0] 	      enc_pad_reg_load;
	 wire [127:0] 	      ofb_pad_store;
   wire [127:0] 	      enc_pad_reg_store;

   reg 			      enc_done_buf_load;
	reg 			      enc_done_buf_store;
   
   //
   // load encryption path
   //

   always @(posedge clk) begin
      enc_done_buf_load <= enc_done_load;
   end

   or1200_reg_ce
     or1200_enc_pad_load(
			 .clk(clk),
			 .rst(rst),
			 .ce((shifted_value_load >= 8'h80) | seed_init_load),
			 .in(seed_init_load ? enc_pad_buf_load : ofb_pad_load),
			 .out(enc_pad_reg_load)
			 );

   or1200_reg_ce
     or1200_ofb_pad_load(
			 .clk(clk),
			 .rst(rst),
			 .ce(enc_done_buf_load & !seed_init_load),
			 .in(enc_pad_buf_load),
			 .out(ofb_pad_load)
			 );
			 
   //
   // store encryption path
   //

   always @(posedge clk) begin
      enc_done_buf_store <= enc_done_store;
   end

   or1200_reg_ce
     or1200_enc_pad_store(
			 .clk(clk),
			 .rst(rst),
			 .ce((shifted_value_store >= 8'h80) | seed_init_store),
			 .in(seed_init_store ? enc_pad_buf_store : ofb_pad_store),
			 .out(enc_pad_reg_store)
			 );

   or1200_reg_ce
     or1200_ofb_pad_store(
			 .clk(clk),
			 .rst(rst),
			 .ce(enc_done_buf_store & !seed_init_store),
			 .in(enc_pad_buf_store),
			 .out(ofb_pad_store)
			 );

endmodule
