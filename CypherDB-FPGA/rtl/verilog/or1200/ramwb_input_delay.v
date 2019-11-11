//------------------------------
// Module name: ramwb_input_delay.v
// Function: this modules is to inject some delay cycles in the sdram
// controller, so as to mimic the actual scenairo
// Because we can't slow down the clock of sdram, due to the minimum
// requirement of operating frequency (DLL operating requirement), we
// inject user-defined delay cycles during sdram transcation
// Creator:  Bony Chen
// Version:  1.0
// Date:     31 Dec 2015
//------------------------------
// Description: it delays the input signals from wishbone bus

`include "or1200_defines.v"

`define IDLE 1'd0
`define DELAY 1'd1

module ramwb_input_delay (
			  clk, rst, en, refresh, ci,
			  
			  // inputs from wishbone bus
			  biu_cyc_i, biu_stb_i, biu_we_i,
			  
			  // output the delayed inputs from wishbone bus
			  delayed_biu_cyc_o, delayed_biu_stb_o,
			  delayed_biu_we_o
			  );

   parameter delay_cycles = 10;   
   parameter cacheLineSize = 7;   
   
   input 			clk;		// clock signal
   input 			rst;
   input 			en;   
   input 			refresh;
   input 			ci;   

   // inputs from wishbone bus
   input 		biu_cyc_i;
   input 		biu_stb_i;
   input 		biu_we_i;   

   // outpus the delayed inputs from wishbone bus
   output reg 			delayed_biu_cyc_o;
   output reg 		delayed_biu_stb_o;
   output reg 		delayed_biu_we_o;

   // reg 		cache_biu_cyc;
   // reg 		cache_biu_stb;
   reg 			cache_biu_we;
   reg 			cache_ci;   

   reg 		state;   
   reg [15:0] 	counter;
   reg [3:0] 	refresh_counter;   


   always @ (posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	state <= `IDLE;
	counter <= delay_cycles;
	refresh_counter <= cacheLineSize;	
   	cache_biu_we <= 1'b0;
	cache_ci <= 1'b0;	
  	delayed_biu_cyc_o <= 0;
   	delayed_biu_stb_o <= 0;
   	delayed_biu_we_o <= 0;
     end
     else begin	
	
	case (state)	  
	  
	  `IDLE: begin
	     state <= `IDLE;	     
	     counter <= delay_cycles;	     
	     refresh_counter <= cacheLineSize;
	     
   	     // cache_biu_cyc <= biu_cyc_i;
    	     // cache_biu_stb <= biu_stb_i;
    	     // cache_biu_we <= biu_we_i;
	     
	     delayed_biu_cyc_o <= 1'b0;
	     delayed_biu_stb_o <= 1'b0;   
	     delayed_biu_we_o <= 1'b0;

	     if (biu_we_i)
	       cache_biu_we <= 1'b1;
	     else 
	       cache_biu_we <= 1'b0;

	     if (ci)
	       cache_ci <= 1'b1;
	     else 
	       cache_ci <= 1'b0;
	     
	     if (en & ((biu_cyc_i) | (biu_stb_i))) begin		
		state <= `DELAY;	      
	     end
	  end

	  `DELAY: 
	     if (|counter)  begin		
		counter <= counter - 1;
		state <= `DELAY;			
	     end else begin
		delayed_biu_cyc_o <= 1'b1;
		delayed_biu_stb_o <= 1'b1;
		delayed_biu_we_o <= cache_biu_we;
		if (refresh) 
		   if (!cache_ci) begin
		      if (|refresh_counter) begin
			 refresh_counter <= refresh_counter - 1;
			 state <= `DELAY;
		      end else begin		     
       			 state <= `IDLE;
			 counter <= delay_cycles;	     
			 refresh_counter <= cacheLineSize;
			 delayed_biu_cyc_o <= 1'b0;
			 delayed_biu_stb_o <= 1'b0;
			 delayed_biu_we_o <= cache_biu_we;	         
		      end		      
		   end else begin		     
		      state <= `IDLE;
		      counter <= delay_cycles;	     
		      refresh_counter <= cacheLineSize;
		      delayed_biu_cyc_o <= 1'b0;
		      delayed_biu_stb_o <= 1'b0;
		      delayed_biu_we_o <= 1'b0;
		   end // else: !if(!ci)		
	     end // else: !if(|counter) 	 	     
	  
	  default: state <= `IDLE;
	  
	endcase // case (state)
     end 
endmodule
