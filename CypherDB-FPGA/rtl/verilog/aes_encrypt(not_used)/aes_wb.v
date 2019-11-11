module aes_wb(
	      wb_clk_i, wb_rst_i, wb_dat_i, wb_dat_o, 

	      // WISHBONE slave
	      wb_adr_i, wb_sel_i, wb_we_i, wb_cyc_i, wb_stb_i, wb_ack_o,

	      // encryption reg
	      plaintext_o, ciphertext_i
	      );
   
   // WISHBONE common
   input           wb_clk_i;     // WISHBONE clock
   input           wb_rst_i;     // WISHBONE reset
   input [31:0]    wb_dat_i;     // WISHBONE data input
   output reg [31:0] wb_dat_o;     // WISHBONE data output
   // WISHBONE error output

   // WISHBONE slave
   input [7:0] 	     wb_adr_i;     // WISHBONE address input
   input [3:0] 	     wb_sel_i;     // WISHBONE byte select input
   input 	     wb_we_i;      // WISHBONE write enable input
   input 	     wb_cyc_i;     // WISHBONE cycle input
   input 	     wb_stb_i;     // WISHBONE strobe input

   input [127:0]     ciphertext_i;

   output 	     wb_ack_o;     // WISHBONE acknowledge output
   output reg [127:0] plaintext_o;

   // internal wire/reg
   reg [127:0] 	      plaintext_reg;
   reg [127:0] 	      ciphertext_reg;

   reg [4:0] 	      count;
   reg 		      done;
   reg 		      start;

   //Register Addreses 
`define plain0 8'h00
`define plain1 8'h04
`define plain2 8'h08
`define plain3 8'h0c
`define cipher0 8'h10
`define cipher1 8'h14
`define cipher2 8'h18
`define cipher3 8'h1c
`define encdone 8'h20

   assign wb_ack_o = wb_cyc_i & wb_stb_i;

   initial
     count = 0;

   always @(posedge wb_clk_i or posedge wb_rst_i)
     begin
	
	if ( wb_rst_i )begin
	   plaintext_reg <= 128'b0;
	   ciphertext_reg <= 128'b0;      
	end
	else if ((wb_stb_i  & wb_cyc_i) || wb_ack_o )begin 
	   
	   if (wb_we_i) begin
	      case (wb_adr_i) 
		// MSB first, LSB last
	        `plain0:  begin 
		   plaintext_reg[127:96]  <=  wb_dat_i;
		   start <= 0;
		end
	        `plain1:  plaintext_reg[95:64]  <=  wb_dat_i;
	        `plain2:  plaintext_reg[63:32]  <=  wb_dat_i;
	        `plain3:  begin
		   plaintext_reg[31:0]  <=  wb_dat_i;
		   start <= 1;
		end
	        `cipher0:  ciphertext_reg[127:96]  <=  wb_dat_i;
	        `cipher1:  ciphertext_reg[95:64]  <=  wb_dat_i;
	        `cipher2:  ciphertext_reg[63:32]  <=  wb_dat_i;
	        `cipher3:  ciphertext_reg[31:0]  <=  wb_dat_i;
	      endcase
	   end 
	   plaintext_o <= plaintext_reg;
	   ciphertext_reg <= ciphertext_i;
	end // if ((wb_stb_i  & wb_cyc_i) || wb_ack_o )
	else begin
	   plaintext_o <= plaintext_reg;
	   ciphertext_reg <= ciphertext_i;
	end
     end

   always @(posedge wb_clk_i )begin
      if (wb_stb_i  & wb_cyc_i) begin //CS
	 case (wb_adr_i)
	   `plain0:  wb_dat_o  <=   plaintext_reg[127:96];
	   `plain1:  wb_dat_o  <=   plaintext_reg[95:64];
	   `plain2:  wb_dat_o  <=   plaintext_reg[63:32];
	   `plain3:  wb_dat_o  <=   plaintext_reg[31:0];
	   `cipher0:  wb_dat_o  <=  ciphertext_reg[127:96];
	   `cipher1:  wb_dat_o  <=  ciphertext_reg[95:64];
	   `cipher2:  wb_dat_o  <=  ciphertext_reg[63:32];
	   `cipher3:  wb_dat_o  <=  ciphertext_reg[31:0];	   
	   `encdone:  wb_dat_o  <=  {31'b0, done};
	 endcase
      end 
   end

   always @(posedge wb_clk_i) begin
      if (count >= 5'd21) 
	done <= 1;
      else if (start) begin 
	 count <= count + 1;
	 done <= 0;
      end
      else begin
	 done <= 0;
	 count <= 0;
      end

      if (wb_we_i)
	count <= 5'b0;
   end
   
endmodule
