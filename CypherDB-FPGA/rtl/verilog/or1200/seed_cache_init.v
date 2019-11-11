//------------------------------ Module name: seed_cache_init
//Function: initiate the seed cache by setting the valid bit to zero
//for ALL cache entries, this is triggered whenever l.end is detected
//Creator: Bony Chen Version: 1.0 Date: 16 Nov 2015
//------------------------------

`include "or1200_defines.v"

`define IDLE 1'd0
`define COUNT 1'd1

module seed_cache_init (
			clk, rst, seed_tag_addr_out,
			trigger_pulse, done, seed_during_init
			);

   parameter aw = `SEEDBUF_INDXH-`SEEDBUF_LS;
   
   input clk;
   input rst;
   input trigger_pulse;
   
   output [`SEEDBUF_INDXH:`SEEDBUF_LS] seed_tag_addr_out;   
   output reg done;
   output     seed_during_init;   

   reg 	  state;
   reg [`SEEDBUF_INDXH:`SEEDBUF_LS] cnt;   

   assign seed_during_init = (state==`COUNT);   
   
   assign seed_tag_addr_out = cnt;   
   
    always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	state <= `IDLE;
	cnt <= (1 << (aw+1)) - 1;
	done <= 1'b0;	
     end else begin
	case (state)
	  
	  `IDLE: begin
	     state <= `IDLE;
	     done <= 1'b0;	     
	     cnt <= (1 << (aw+1)) - 1 ;
	     if (trigger_pulse)
		state <= `COUNT;
	  end
	  	  
	   `COUNT: begin
	      if (|cnt) begin
		 cnt <= cnt - 1;
		 state <= `COUNT;
	      end else begin
		 done <= 1'b1;
		 cnt <= (1 << (aw+1)) - 1;
		 state <= `IDLE;
	      end

	   end
	     
	     endcase // case (state)
     end // else: !if(rst == `OR1200_RST_VALUE)   
endmodule
   

   

   
   
