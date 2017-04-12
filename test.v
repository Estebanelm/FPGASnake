`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:36:07 04/12/2017
// Design Name:   body_stack
// Module Name:   /media/frander/disk2/Verilog/stack/test.v
// Project Name:  stack
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: body_stack
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	// Inputs
	reg clk;
	reg reset;
	reg [2:0] posEnt;
	reg push;
	reg pop;

	// Outputs
	wire [2:0] posSal;
	wire ptr;
	wire stack;

	// Instantiate the Unit Under Test (UUT)
	body_stack uut (
		.clk(clk), 
		.reset(reset), 
		.posEnt(posEnt), 
		.posSal(posSal), 
		.push(push), 
		.pop(pop)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		posEnt = 0;
		push = 0;
		pop = 0;

		// Wait 100 ns for global reset to finish
		#2 reset = 1;
			//clk = 1;
		
		#10 posEnt = 1;
		push = 1;
		#10 push = 0;
		#10 posEnt = 2;
		push = 1;
		#10 push = 0;
		#10 posEnt = 3;
		push = 1;
		#10 push = 0;
		#10 posEnt = 2;
		push = 1;
		#10 push = 0;		
		#10 pop = 1;
		#10 pop = 0;
		#10 pop = 1;
		#10 pop = 0;

	end
            		
		always
		begin
			#1 clk <=~clk;
		end
		
endmodule

