`timescale 1ns/1ns

module aes_dec_128 (
		    aes_clk_in,
		    aes_rst_in,
			 aes_key_ld,
		    wb_clk_i, wb_rst_i, wb_dat_i, wb_dat_o,
		    wb_adr_i, wb_sel_i, wb_we_i, wb_cyc_i, wb_stb_i, wb_ack_o
		    );

   input aes_clk_in;
   input aes_rst_in;
	input aes_key_ld;
   
   // WISHBONE common
   input wb_clk_i;     // WISHBONE clock
   input wb_rst_i;     // WISHBONE reset
   input [31:0] wb_dat_i;     // WISHBONE data input
   output [31:0] wb_dat_o;     // WISHBONE data output
   // WISHBONE error output

   // WISHBONE slave
   input [7:0] 	 wb_adr_i;     // WISHBONE address input
   input [3:0] 	 wb_sel_i;     // WISHBONE byte select input
   input 	 wb_we_i;      // WISHBONE write enable input
   input 	 wb_cyc_i;     // WISHBONE cycle input
   input 	 wb_stb_i;     // WISHBONE strobe input

   output 	 wb_ack_o;     // WISHBONE acknowledge output
   
   wire [127:0]  plain;  // plaintext
   wire [127:0]  cipher;	  // ciphertext
   wire [127:0]  key;
   
   wire 	 dec_done;
   wire 	 dec_ld;
  
   assign key = 128'h0123456789abcdef0123456789abcdef;
   
   // Instantiate the Unit Under Test (UUT)
   aes_inv_cipher_top aes_decipher_128 
     (
      .clk(aes_clk_in), 
      .rst(aes_rst_in),
      .kld(aes_key_ld),
      .ld(dec_ld),
      .done(dec_done),
      .key(key),
      .text_in(cipher),
      .text_out(plain)
      );	
   
   aes_dec_wb aes_dec_128_wb 
     (
      // wishbone interface
      .wb_clk_i(wb_clk_i),
      .wb_rst_i(wb_rst_i),
      .wb_dat_i(wb_dat_i),
      .wb_dat_o(wb_dat_o),
      .wb_adr_i(wb_adr_i),
      .wb_sel_i(wb_sel_i),
      .wb_we_i(wb_we_i),
      .wb_cyc_i(wb_cyc_i),
      .wb_stb_i(wb_stb_i),
      .wb_ack_o(wb_ack_o),
      // data input/output
      .plaintext_i(plain),
      .ciphertext_o(cipher),
      // control signal
      .dec_cs(dec_ld),
      .dec_done(dec_done)
      );
   
   
endmodule

