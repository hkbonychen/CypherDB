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
			     aes_clk, clk, rst,
			     // seed Input
			     seedRead, seedIn, seedAddr, seedImm,
			     // encryption data and control I/O
			     enc_key, enc_pad, enc_pad_buf, enc_done,
			     // Control signals
			     unstall, shifted_value
			     );

   input aes_clk;				   
   input clk;
   input rst;

   // Seed Input and control
   input seedRead;
   input [31:0] seedIn;
   input [4:0] 	seedAddr;
   input [10:0] seedImm;

   // encryption key input
   input [127:0] enc_key;
   output [127:0] enc_pad;
	output [127:0] enc_pad_buf;
   output 	  enc_done;
   input [7:0] 	  shifted_value;

   // encryption data and control I/O
   wire 	  enc_start;
   wire 	  enc_done;
   wire [127:0]   enc_key;  // key
   wire [127:0]   enc_seed; // input
   wire [127:0]   enc_pad;  // output	
	
	wire ofb_start;
   
   // Control signals
   output 	  unstall;

`ifdef equal_aes_freq 
	reg [127:0] enc_pad_buf;
`endif
	
   // internal seed register
   reg [31:0] 	  row;
   reg [15:0] 	  col;
   reg [15:0] 	  tb;
   reg [7:0] 	  db;
   reg [15:0] 	  cntr;
   
   reg 		  stall;
   reg 		  fsm_unstall;

   reg 		  state;

   // Instantiation of the 128 bits AES encryption engine
   // ld: start encryption; done: finish encryption
   // But the engines will generate an output for each cycle
	
`ifdef high_aes_freq
   aes_cipher_insn_wrapper
     aes_insn_cipher_highaesfreq (
   		      .aes_clk(aes_clk),
   		      .clk(clk), 
   		      .rst(rst),
   		      .ld(enc_start | ofb_start),
   		      .done(enc_done),
   		      .key(enc_key),
   		      .text_in(enc_start ? enc_seed : enc_pad_buf),
   		      .text_buf(enc_pad_buf)
   		      );
`endif

`ifdef low_aes_freq
   aes_cipher_wrapper_lowaesfreq
     aes_insn_cipher_lowaesfreq(
   		      .aes_clk(aes_clk),
   		      .clk(clk), 
   		      .rst(rst),
   		      .ld(enc_start | ofb_start),
   		      .done(enc_done),
   		      .key(enc_key),
   		      .text_in(enc_start ? enc_seed : enc_pad_buf),
   		      .text_buf(enc_pad_buf)
   		      );
`endif
  
`ifdef equal_aes_freq 
   aes_cipher_top 
     aes_cipher_128 (
   		     .clk(clk), 
   		     .rst(!rst),
   		     .ld(enc_start | ofb_start), //enc_start | (shifted_value == 8'h08)
   			  //.ld(enc_start),
   		     .done(enc_done),
   		     .key(enc_key),
   		     .text_in(enc_start ? enc_seed : enc_pad_buf),
   		     .text_out(enc_pad)
   		     );
`endif

	
   // Instantiation of a pulse generator
   // It is used to generate a pulse (a clock period wide) to start the encryption
   or1200_pulse_gen 
     or1200_start_pulse_gen(
			    .clk(clk),
			    .rst(rst),
			    .in(seedImm[0]),
			    .pulse(enc_start)
			    );
				 
	or1200_pulse_gen 
     or1200_ofb_pulse_gen(
			    .clk(clk),
			    .rst(rst),
			    .in(shifted_value >= 8'h80),
			    .pulse(ofb_start)
			    );


   parameter SETUP_SEED = 1'b0;
   parameter WAIT_ENC = 1'b1;

   assign enc_seed = {40'b0, cntr, db, tb, col, row};	

   //assign dataOut = dataIn;
   //assign unstall = enc_done | fsm_unstall;
   assign unstall = fsm_unstall;
   
`ifdef equal_aes_freq 
    always @(posedge clk or `OR1200_RST_EVENT rst)
      if (rst == `OR1200_RST_VALUE)
        enc_pad_buf <= 0;
      else if (enc_done) 
        enc_pad_buf <= enc_pad;
`endif
	
   // FSM states
   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	state <= SETUP_SEED;
	fsm_unstall <= 1;
     end
     else begin
	
	case (state)
	  
	  SETUP_SEED:  begin
	    //if (seedImm[0]) state <= WAIT_ENC;
	    if (enc_start | ofb_start) begin
	       fsm_unstall <= 0;	    
	       state <= WAIT_ENC;
	    end
	    else begin
	       fsm_unstall <= 1;	  
	       state <= SETUP_SEED;
	    end
	  end

	  WAIT_ENC: begin
	    if (enc_done) begin
	       fsm_unstall <= 1;	       
	       state <= SETUP_SEED;
	    end else begin
	       fsm_unstall <= 0;	     
	       state <= WAIT_ENC;
	    end
	  end
	  
	endcase
     end // else: !if(rst == `OR1200_RST_VALUE)

   //
   // to setup encryption seed by reading the l.seed operand
   //
   
   reg seedRead_delay;	
   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	row <= 32'b0;
	col <= 16'b0;
	tb <= 16'b0;
	db <= 8'b0;
	cntr <= 16'b0;	
     end
     else begin
	if (seedRead) begin
	   case(seedImm[9:6])
	     5'b0001: row[4:0] <= seedAddr;
	     5'b0010: col[4:0] <= seedAddr;
	     5'b0100: tb[4:0] <= seedAddr;
	     5'b1000: db[4:0] <= seedAddr;
	   endcase	
	
	 case (seedImm[5:1])
	     5'b00001: row <= seedIn;
	     5'b00010: col <= seedIn[15:0];
	     5'b00100: tb <= seedIn[15:0];
	     5'b01000: db <= seedIn[7:0];
	     5'b10000: cntr <= seedIn[15:0];
	   endcase
	end
	
     end // else: !if(rst == `OR1200_RST_VALUE)
   
endmodule
