`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:46:06 04/05/2017 
// Design Name: 
// Module Name:    VGA_Bitgen 
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
module VGA_Bitgen(
    input bright,
    input [7:0] pixelData,
    input [9:0] hCount,
    input [9:0] vCount,
    output reg [7:0] rgb
    );
	 
	 parameter BLACK = 8'b000_000_00;
	 parameter WHITE = 8'b111_111_11;
	 parameter RED = 8'b111_000_00;
	 parameter GREEN = 8'b000_111_00;
	 parameter BLUE = 8'b000_000_00;
	 
	 always@(*) // paint a white box on a red background
		begin
			if (~bright)
				rgb = BLACK; // force black if not bright
			else if (((hCount >= 100) && (hCount <= 300)) && ((vCount >= 150) && (vCount <= 350)))
				rgb = WHITE; // check to see if you're in the box
			else
				rgb = RED; // background color
		end

endmodule
