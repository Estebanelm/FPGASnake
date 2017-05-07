`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module body_stack (
							input clk,
							input reset,
							input[10:0] posEntX,
							input[10:0] posEntY,
							output reg [10:0] posColaX,
							output reg [10:0] posColaY,
							input push,
							input pop,
							input obtener
							);
							
	reg [5:0] ptr;//puntero de la pila
   reg [10:0] stackX [0:25];
	reg [10:0] stackY [0:25];
	integer i = 0;
	integer j = 0;

	initial begin 
		ptr = 0;
		for ( i = 0; i<=25; i = i + 1)
			begin
				stackX[i] = 0;
				stackY[i] = 0;
			end
	end
	
	always @ (posedge clk)//La idea es que por cada push o pop, sume o reste para saber el indice de la pila
		begin
			if (reset) 
				begin
					ptr = 0;
					for ( i = 0; i<=25; i = i + 1)
						begin
							stackX[i] = 0;
							stackY[i] = 0;
						end

				end 
			else if (push) begin
				stackX[ptr] = posEntX;
				stackY[ptr] = posEntY;
				ptr = ptr + 1;
			end
			else if (pop) begin
				for (i = 0; i <= 25; i = i+1)
					begin
						if (i==25)	begin
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
				posColaX = stackX[j];
				posColaY = stackY[j];
				if (j == 25)
					j=0;
				else
					j=j+1;
			end

endmodule