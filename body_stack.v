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
							
	reg [1500:0] ptr;//puntero de la pila
	reg [2:0] stack [0:1500];


	initial begin 
		ptr = 0;
		stack[0] = 0;
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
			else if (pop)
				begin
					ptr <= ptr - 1;
				end
		end


	always @(posedge clk) begin//la idea es que en stack[ptr] sea la pos donde va el cuerpo
		if (push) begin
			stack[ptr] <= posEnt;
		end
		if (pop) begin
			posSal <= stack[ptr];//hace que posSal sea stack[ptr]
		end
	end

endmodule

