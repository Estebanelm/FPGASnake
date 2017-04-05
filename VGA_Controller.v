`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:44:38 04/05/2017 
// Design Name: 
// Module Name:    VGA_Controller 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VGA_Controller(
    input clock,
    input clear,
    output reg hSync,
    output reg vSync,
    output reg bright,
    output reg [9:0] hCount,
    output reg [9:0] vCount
    );

	 // An example of a counter that only counts when En is high.
	 // This particular En is assumed to be high for a single clock
	 // cycle when it's time to count

	 always@(posedge clk100MHz)
		begin
			if (clr)
				count <= 0; // clear count if clr is asserted
			else if (En)
				count <= count + 1; // If En is high, count
										// otherwise, hold previous value (default)
		end

endmodule
