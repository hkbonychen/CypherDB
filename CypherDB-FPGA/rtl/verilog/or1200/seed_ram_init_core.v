//------------------------------
// Module name: seed_vector_init
// Function: initiate the seed ram by writing zero in the memory 
// cell in RAM. It is triggered by l.start instruction
// Creator:  Bony Chen
// Version:  1.0
// Date: 18  Nov 2015
//------------------------------

`include "or1200_defines.v"

`define IDLE 2'd0
`define COUNT 2'd1
`define WAIT 2'd2

module seed_ram_init_core (
		      clk, rst, 
		      seedInit_dat_o, seedInit_adr_o, seedInit_cyc_o, seedInit_stb_o,
		      seedInit_we_o, seedInit_sel_o, seedInit_cab_o, seedInit_ack_i, seedInit_err_i,
		      trigger_pulse, seed_ram_during_init
		      );

   parameter dw = 32;
   parameter aw = 32;
   
   input clk;
   input rst;
   
   output [dw-1:0] seedInit_dat_o;	// input data bus
   output [aw-1:0] seedInit_adr_o;	// address bus
   output 	   seedInit_cyc_o;	// WB cycle
   output 	   seedInit_stb_o;	// WB strobe
   output 	   seedInit_we_o;	// WB write enable
   output 	   seedInit_cab_o;	// CAB input
   output [3:0]    seedInit_sel_o;	// byte selects

   input 	   seedInit_ack_i;	// ack output
   input 	   seedInit_err_i;	// err output

   input 	   trigger_pulse; 
   output 	   seed_ram_during_init;		

   reg [1:0] 	   state;
   reg [31:0] 	   cnt;
   reg 		   done;  
   reg 		   write; 

   assign seedInit_cyc_o = write;
   assign seedInit_stb_o = write;  
   assign seedInit_we_o = write;
   assign seedInit_dat_o = 32'd0;   
   assign seedInit_adr_o = `seed_ram_bottom + cnt;
   assign seedInit_sel_o = 4'b1111;
   assign seedInit_cab_o = 1'b0;   
   assign seed_ram_during_init = (state==`COUNT) | (state == `WAIT);
   
   always @(posedge clk or `OR1200_RST_EVENT rst)
     if (rst == `OR1200_RST_VALUE) begin
	state <= `IDLE;
	cnt <= `seed_ram_size;	
	done <= 1'b0;	
     end else begin
	case (state)
	  
	  `IDLE: begin
	     state <= `IDLE;
	     done <= 1'b0;
	     write <= 1'b0;	
	     cnt <= `seed_ram_size;
	     if (trigger_pulse) begin
		write <= 1'b1;		
		state <= `COUNT;
	     end
	  end
	  
	  `COUNT: begin
	     write <= 1'b1;
	     state <= `COUNT;	     
	     if ((|cnt) & seedInit_ack_i) begin		
		cnt <= cnt - 4;
		write <= 1'b0;		
		state <= `WAIT;
	     end
	     if (!(|cnt)) begin
		done <= 1'b1;
		write <= 1'b1;		
		cnt <= `seed_ram_size;
		state <= `IDLE;
	     end
	  end

	     `WAIT: begin
		state =`COUNT;
		write <= 1'b1;		
	     end	  
	  
	endcase // case (state)
     end // else: !if(rst == `OR1200_RST_VALUE)   
endmodule






