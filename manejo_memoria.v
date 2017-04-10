`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:00:43 03/24/2017 
// Design Name: 
// Module Name:    manejo_memoria 
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
module manejo_memoria(
    input clk,
	 input rst,
	 input LE,
	 input [2:0] boton_pres, //boton que se presiona
	 output reg [2:0] memoria //registro con la siguiente instruccion para la maquina de estados
    );

reg [2:0] RAM [0:5];
reg [2:0] indice_encontrado = 7;
integer contador = 0;
reg insertado = 0;
reg obteniendo = 0;
reg encontrado = 0;


initial begin
	RAM[0] = 0;
	RAM[1] = 0;
	RAM[2] = 0;
	RAM[3] = 0;
	RAM[4] = 0;
	RAM[5] = 0;
	memoria = 0;
end
	
always @ (posedge clk)
	begin
		if (rst)
			begin
				memoria = 0;
				RAM[0] = 0;
				RAM[1] = 0;
				RAM[2] = 0;
				RAM[3] = 0;
				RAM[4] = 0;
				RAM[5] = 0;
			end
		else
			if (LE == 1)
				begin
					obteniendo = 1;
					insertado = 0;
					indice_encontrado = 7;
					if (boton_pres == 0)
						RAM[5] = 0;
					else
						for (contador = 5; contador >= 0; contador = contador - 1)
							begin
								if (RAM[contador] == boton_pres)
									begin
										indice_encontrado = contador;
									end
							end
						if (indice_encontrado == 7)
							begin
								for (contador = 5; contador >= 0; contador = contador - 1)
									if ((RAM[contador] == 0) && (insertado == 0))
										begin
											insertado = 1;
											RAM[contador] = boton_pres;
										end
							end
				end
			else
				begin
					if (obteniendo == 1)
						begin
							encontrado = 0;
							obteniendo = 0;
							for (contador = 5; contador >= 0; contador = contador - 1)
								begin
									if (encontrado == 0)
										begin
											if (RAM[contador] == 1) begin
												RAM[contador] = 0;
												encontrado = 1;
												memoria = 1;
											end else if (RAM[contador] == 2) begin
												RAM[contador] = 0;
												encontrado = 1;
												memoria = 2;
											end else if (RAM[contador] == 3) begin
												RAM[contador] = 0;
												encontrado = 1;
												memoria = 3;
											end else if (RAM[contador] == 4) begin
												RAM[contador] = 0;
												encontrado = 1;
												memoria = 4;
											end else if (RAM[contador] == 5) begin
												RAM[contador] = 0;
												encontrado = 1;
												memoria = 5;
											end
										end
								end
							if (encontrado == 0)
								memoria = 0;
						end						
				end
	end
endmodule
