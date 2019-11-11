//------------------------------
// Module name: seed_vector_init
// Function: initiate the seed ram by writing zero in the memory 
// cell in RAM. It is triggered by l.start instruction
// Creator:  Bony Chen
// Version:  1.0
// Date: 18  Nov 2015
//------------------------------

`include "or1200_defines.v"

`define IDLE 1'd0
`define COUNT 1'd1

module seed_vector_init (
			   clk, rst, 
			   ce, we, seed_addr, seed_vector_out,
			   trigger_pulse, seed_vector_during_init
			   );

   parameter dw = 1;
   parameter aw = `seed_ram_aw;
   
   input clk;
   input rst;
   
   input ce;
   input we;
   input [31:0] seed_addr;
   output [`seed_ram_dw-1:0] seed_vector_out;   

   input trigger_pulse; 
   output     seed_vector_during_init;

   reg [dw-1:0] mem[(1<<aw)-1:0];
   reg [aw-1:0]		addr_reg;		

   reg 	  state;
   reg [31:0] cnt;
   reg 	      done;   

   wire [`seed_ram_aw-`seed_ram_dw_bit:0] seed_vector_addrin;
   wire [`seed_ram_dw-1:0] 		  seed_vector_in;

   assign seed_vector_addrin = seed_vector_during_init ?
			       cnt[`seed_ram_aw:`seed_ram_dw_bit] :
			       seed_addr[`seed_ram_aw:`seed_ram_dw_bit];

   assign seed_vector_in = seed_vector_during_init ?
			   {`seed_ram_dw{1'b0}} :
			   (seed_vector_out | (1 << seed_addr[`seed_ram_dw_bit-1:0]));   

   or1200_spram 
     #(
      .dw(`seed_ram_dw),
      .aw(`seed_ram_aw-`seed_ram_dw_bit+1)
      )
       seed_vector (
		    .clk(clk),
		    .ce(1'b1),
		    .we(seed_vector_during_init | we),
		    .addr(seed_vector_addrin),
		    .di(seed_vector_in),
		    .doq(seed_vector_out)
		    );   
   
   assign seed_vector_during_init = (state==`COUNT);   
   
   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	state <= `IDLE;
	cnt <= `seed_ram_vector_size;	
	done <= 1'b0;	
     end else begin
      case (state)
	
	`IDLE: begin
	   state <= `IDLE;
	   done <= 1'b0;	     
	   cnt <= `seed_ram_vector_size;
	   if (trigger_pulse)
	     state <= `COUNT;
	end
	
	`COUNT: begin
	   if (|cnt) begin
	      cnt <= cnt - (1<<`seed_ram_dw_bit);
	      state <= `COUNT;
	   end else begin
	      done <= 1'b1;
	      cnt <= `seed_ram_vector_size;
	      state <= `IDLE;
	   end

	end
	
      endcase // case (state)
   end // else: !if(rst == `OR1200_RST_VALUE)   
endmodule
   

   

   
   
