//------------------------------
// Module name: or1200_encryption
// Function: encrypt/decrpyt the data flowing from/to the load-store 
// unit to/from the cache memory
// Creator:  Bony Chen
// Version:  1.0
// Date:     12 Jan 2015
//------------------------------

`include "or1200_defines.v"

module or1200_encryption_fsm(
			     clk, rst,
			     // seed Input
			     seedIn, seedAddr, seedImm,
			     // encryption data and control I/O
			     enc_key, enc_pad, enc_done,
			     // Control signals
			     unstall
			     );

   input clk;
   input rst;

   // Seed Input and control
   input [31:0]	 seedIn;
   input [4:0]	 seedAddr;
   input [10:0]	 seedImm;

   // encryption key input
   input [127:0] enc_key;
   output [127:0] enc_pad;
   output 	  enc_done;

   // encryption data and control I/O
   wire 	 enc_start;
   wire 	 enc_done;
   wire [127:0]  enc_key;  // key
   wire [127:0]  enc_seed; // input
   wire [127:0]  enc_pad;  // output	 
   
   // Control signals
   output unstall;

   // internal seed register
   reg [31:0] row;
   reg [15:0]  col;
   reg [15:0]  tb;
   reg [7:0]   db;
   reg [15:0]   usr;
  
   reg 	  stall;
   reg 	  fsm_unstall;

   reg 	       state;

   // Instantiation of the 128 bits AES encryption engine
   // ld: start encryption; done: finish encryption
   // But the engines will generate an output for each cycle
   aes_cipher_top 
     aes_cipher_128 (
		     .clk(clk), 
		     .rst(!rst),
		     .ld(enc_start),
		     .done(enc_done),
		     .key(enc_key),
		     .text_in(enc_seed),
		     .text_out(enc_pad)
		     );

   // Instantiation of a pulse generator
   // It is used to generate a pulse (a clock period wide) to start the encryption
   or1200_pulse_gen 
     or1200_start_pulse_gen(
			    .clk(clk),
			    .rst(rst),
			    .in(seedImm[0]),
			    .insn(1'b0),
			    .pulse(enc_start)
			    );

   parameter SETUP_SEED = 1'b0;
   parameter WAIT_ENC = 1'b1;

   assign enc_seed = {40'b0, usr, db, tb, col, row};

   //assign dataOut = dataIn;
   //assign unstall = enc_done | fsm_unstall;
   assign unstall = fsm_unstall;

   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	state <= SETUP_SEED;
	fsm_unstall <= 1;
     end
     else begin
	case (state)
	  
	  SETUP_SEED: begin
	     fsm_unstall <= 1;
	     if (seedImm[0]) 
	       state <= WAIT_ENC;
	     else state <= SETUP_SEED;
	  end

	  WAIT_ENC:
	    if (enc_done) begin
	       state <= SETUP_SEED;
	       fsm_unstall <= 1;
	    end
	    else begin
	       state <= WAIT_ENC;
	       fsm_unstall <= 0;	       
	    end

	endcase
     end // else: !if(rst == `OR1200_RST_VALUE)
   
   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	row <= 32'b0;
	col <= 16'b0;
	tb <= 16'b0;
	db <= 8'b0;
	usr <= 16'b0;	
     end
     else begin
	case (seedImm[5:1])
	  5'b00001: row <= seedIn;
	  5'b00010: col <= seedIn[15:0];
	  5'b00100: tb <= seedIn[15:0];
	  5'b01000: db <= seedIn[7:0];
	  5'b10000: usr <= seedIn[15:0];
	endcase
     end // else: !if(rst == `OR1200_RST_VALUE)
   	         
endmodule
   