`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module body_stack (
							input clk,
							input reset,
							input[11:0] posEntX,
							input[11:0] posEntY,
							output reg [11:0] posX,
							output reg [11:0] posY,
							input push,
							input pop,
							input obtener
							);
							
	reg [500:0] ptr;//puntero de la pila
   reg [11:0] stackX [0:500];
	reg [11:0] stackY [0:500];
	integer i = 0;
	integer j = 0;

	initial begin 
		ptr = 0;
		stackX[0] = 0;
		stackY[0] = 0;
	end
	
	always @ (posedge clk)//La idea es que por cada push o pop, sume o reste para saber el indice de la pila
		begin
			if (reset) 
				begin
					ptr <= 0;
				end 
			else if (push)
				begin
					ptr <= ptr + 1;
				end 
		end


	always @(posedge clk) begin//la idea es que en stack[ptr] sea la pos donde va el cuerpo
		if (push) begin
			stackX[ptr] = posEntX;
			stackY[ptr] = posEntY;
		end
		if (pop) begin
			for (i = 0; i <= 500; i = i+1)
				begin
					if (i==500)	begin
						stackX[i]=0;
						stackY[i]=0;
					end else
						begin
							stackX[i]=stackX[i+1];
							stackY[i]=stackY[i+1];
						end 
				end
			stackX[ptr] = posEntX;
			stackY[ptr] = posEntY;
		end
	end
	
	always @(posedge clk)
		if (obtener)
			begin
				posX = stackX[j];
				posY = stackY[j];
				if (j == 500)
					j=0;
				else
					j=j+1;
			end

endmodule