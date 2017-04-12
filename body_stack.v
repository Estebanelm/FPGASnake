`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module body_stack (
							input clk,
							input reset,
							input[2:0] posEnt,
							output reg [2:0] posSal,
							input push,
							input pop
							);
							
	initial begin 
		ptr = 0;
		stack = 0;
	end

	reg signed [11:0] ptr;
	reg [11:0] stack;
	
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
			else if (pop)
				begin
					ptr <= ptr - 1;
				end
		end


	always @(posedge clk) begin//este si lo hace, la idea es que en stack[X] la X sea la pos donde va el cuerpo
		if (push) begin
			stack[0] <= posEnt;
		end
		if (pop) begin
			posSal <= stack[0];//hace que posSal sea la posicion stack[X] con X la siguiente 
		end
	end

endmodule

