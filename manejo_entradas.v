`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:58 03/24/2017 
// Design Name: 
// Module Name:    manejo_entradas 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: maneja las entradas, convirtiendo lo que entra en un registro para
// poder ser usado por el resto del programa.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module manejo_entradas(
	input clk,
	input arriba,
	input abajo,
	input izquierda,
	input derecha,
	input pausa,
	output reg [2:0] boton_pres
    );

reg nuevoboton;

initial begin
	boton_pres = 0;
	nuevoboton = 1;
end

always @ (posedge clk)//posedge piso1 or posedge piso2 or posedge piso3 or posedge piso4 or posedge S1 or posedge B2 or posedge S2 or posedge B3 or posedge S3 or posedge B4)
	begin
		if (~arriba && ~abajo && ~izquierda && ~derecha && ~pausa) begin
			nuevoboton = 1;
			boton_pres = 0;
		end
		else if (nuevoboton == 1) begin
			nuevoboton = 0;
			if (arriba) begin
				boton_pres = 1;
			end else if (abajo) begin
				boton_pres = 2;
			end else if (izquierda) begin
				boton_pres = 3;
			end else if (derecha) begin
				boton_pres = 4;
			end else if (pausa) begin
				boton_pres = 5;
			end else begin
				boton_pres = 0;
				end
		end
	end

endmodule
