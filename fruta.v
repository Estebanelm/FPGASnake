`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:49:46 04/30/2017 
// Design Name: 
// Module Name:    fruta 
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
module fruta(
	input clk,
	input comer,
	input rst,
	output reg [11:0] fruitPositionX,
	output reg [11:0] fruitPositionY,
	output reg [2:0] Rfruta,
	output reg [2:0] Gfruta,
	output reg [1:0] Bfruta
    );
	 
parameter FRUIT_BOX_WIDTH		  	= 10;
parameter Number_of_locationsX	= 80;
parameter Number_of_locationsY	= 60;

reg [11:0] randomX = 20;
reg [11:0] randomY = 20;

reg[6:0] posicionesX = 5;
reg[5:0] posicionesY = 5;

reg comido = 0;

initial
	begin
		fruitPositionX = 395;
		fruitPositionY = 295;
		Rfruta = 3'b111;
		Gfruta = 3'b000;
		Bfruta = 2'b00;
	end
	
always @ (posedge clk)
	begin
		if (rst)
			begin
				fruitPositionX = randomX;
				fruitPositionY = randomY;
			end
		else
			begin
				if (comer == 0) begin
					comido = 1;
				end else
					begin
						if (comido == 1)
							begin
								comido = 0;
								fruitPositionX = randomX;
								fruitPositionY = randomY;
							end
					end
			end
	end
	
always @ (posedge clk)
	begin
		if (posicionesX < 81)
			posicionesX <= posicionesX + 5;
		else
			posicionesX <= 0;
	end

always @ (posedge clk)
	begin
		if (posicionesY < 61)
			posicionesY <= posicionesY + 3;
		else
			posicionesY <= 0;
	end
	
always @ (posedge clk)
	begin
		if (posicionesX>=80)
			randomX <= 795;
		else if (posicionesX < 1)
			randomX <= 5;
		else
			randomX <= (posicionesX * 10) - 5;
	end

always @ (posedge clk)
	begin
		if (posicionesY>=60)
			randomY <= 595;
		else if (posicionesY < 1)
			randomY <= 5;
		else
			randomY <= (posicionesY * 10) - 5;
	end
	
endmodule
