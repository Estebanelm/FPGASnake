
module GameLogic(
							 input uclk,
							 input clk_reduced,
							 input mover,
							 input [10:0] PixelX,
							 input [10:0] PixelY,
							 input rst,
							 input [2:0] accion,
							 output reg [2:0] R,
							 output reg [2:0] G,
							 output reg [1:0] B,
							 output reg reset
							 );
	
	/* ===============================================================================
	 *                             Parameters/Constants
	 * =============================================================================== */
	parameter PLAYER_BOX_WIDTH		  	= 10;
	parameter PLAYER_BOX_WIDTH_HALF	= PLAYER_BOX_WIDTH/2;
	
	parameter INITIAL_START_POS_X 	= 40;
	parameter INITIAL_START_POS_Y 	= 40;
	
	wire [10:0] fruitPositionX;
	wire [10:0] fruitPositionY;
	wire [2:0] Rfruta;
	wire [2:0] Gfruta;
	wire [1:0] Bfruta;
	reg comer;
	
	integer contador40;
	integer i;
	integer j;
	reg obtener;
	
	wire [10:0] posColaX;
	wire [10:0] posColaY;

	reg [10:0] stackX [0:40];
	reg [10:0] stackY [0:40];
	
	reg signed [10:0] UserCurrentPositionX;
	reg signed [10:0] UserCurrentPositionY;

	reg movido = 0;
	reg estaCola;
	reg choque;
	
	integer ptr;
	
	/* ===============================================================================
	 *                          Initial register values
	 * =============================================================================== */
	
	initial begin
			UserCurrentPositionX = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
			UserCurrentPositionY = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
			comer = 0;
			reset = 0;
			obtener = 0;
			i = 0;
			j = 0;
			estaCola = 0;
			choque = 0;
			ptr = -1;
			for ( i = 0; i<=40; i = i + 1)
				begin
					stackX[i] = 0;
					stackY[i] = 0;
				end
	end
	
	/* ===============================================================================
	 *                                   Modules
	 * =============================================================================== */
	 
	 fruta Comida(
	 uclk,
	 comer,
	 reset,
	 fruitPositionX,
	 fruitPositionY,
	 Rfruta,
	 Gfruta,
	 Bfruta
	 );
/*
	 body_stack Cola(
	 uclk,
	 reset,
	 UserCurrentPositionXant,
	 UserCurrentPositionYant,
	 posColaX,
	 posColaY,
	 push,
	 pop,
	 obtener
	 );
	
	*/
	
	/* ===============================================================================
	 *                                  Game logic
	 * =============================================================================== */
	
	
	always @(posedge uclk)
		begin
	
	
		if (rst)
			begin
				UserCurrentPositionX = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
				UserCurrentPositionY = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
				reset = 1;
				ptr = -1;
				for ( i = 0; i < 41; i = i + 1)
					begin
						stackX[i] = 11'b0;
						stackY[i] = 11'b0;
					end
			end
		else
			begin
				reset = 0;
				if (mover == 0) begin
					movido = 1;
					comer = 0;
					reset = 0;
				end else
					if (movido == 1)
						begin
							movido = 0;
							begin
								if (accion != 0)
									begin
										if (UserCurrentPositionX == fruitPositionX && UserCurrentPositionY == fruitPositionY) 
											begin
												comer = 1;
												if (ptr == 40)
													ptr = 40;
												else
													begin
														ptr = ptr + 1;
														stackX[ptr] = UserCurrentPositionX;
														stackY[ptr] = UserCurrentPositionY;

													end
											end
										else
											begin
												begin
													for (i = 0; i < 41; i = i + 1)
														begin
															if (i==40)	begin
																stackX[i]=0;
																stackY[i]=0;
															end else
																begin
																	stackX[i]=stackX[i+1];
																	stackY[i]=stackY[i+1];
																end 
														end
												end
												if (ptr >= 0)
													begin
														stackX[ptr] = UserCurrentPositionX;
														stackY[ptr] = UserCurrentPositionY;
													end
											end
									end
								end
							if (accion == 2) begin
								UserCurrentPositionY = UserCurrentPositionY + PLAYER_BOX_WIDTH;
							end
							
							if (accion == 1) begin
								UserCurrentPositionY = UserCurrentPositionY - PLAYER_BOX_WIDTH;
							end
							
							if (accion == 4) begin
								UserCurrentPositionX = UserCurrentPositionX + PLAYER_BOX_WIDTH;
							end
							
							if (accion == 3) begin
								UserCurrentPositionX = UserCurrentPositionX - PLAYER_BOX_WIDTH;
							end
							
							choque = 0;
							for (i = 0; i < 41; i = i + 1)
								begin
									if (UserCurrentPositionX == stackX[i] &&
										UserCurrentPositionY == stackY[i])
										begin
											choque = 1;
										end
								end
							if (choque)
								begin
									UserCurrentPositionX = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
									UserCurrentPositionY = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
									reset = 1;
									ptr = -1;
									for ( i = 0; i<41; i = i + 1)
										begin
											stackX[i] = 0;
											stackY[i] = 0;
										end
								end
							if ($signed(UserCurrentPositionY) < $signed(1)) begin
									//UserCurrentPositionY = $signed(0+PLAYER_BOX_WIDTH_HALF);
									reset = 1;
									ptr = -1;
									for ( i = 0; i<41; i = i + 1)
										begin
											stackX[i] = 0;
											stackY[i] = 0;
										end
									UserCurrentPositionX = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
									UserCurrentPositionY = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
							end
							else if ($signed(UserCurrentPositionY) > $signed(599)) begin
									//UserCurrentPositionY = $signed(600-PLAYER_BOX_WIDTH_HALF);
									reset = 1;
									ptr = -1;
									for ( i = 0; i<41; i = i + 1)
										begin
											stackX[i] = 0;
											stackY[i] = 0;
										end
									UserCurrentPositionX = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
									UserCurrentPositionY = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
							end
							else if ($signed(UserCurrentPositionX) < $signed(1)) begin
									//UserCurrentPositionX = $signed(0+PLAYER_BOX_WIDTH_HALF);
									reset = 1;
									ptr = -1;
									for ( i = 0; i<41; i = i + 1)
										begin
											stackX[i] = 0;
											stackY[i] = 0;
										end
									UserCurrentPositionX = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
									UserCurrentPositionY = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
									
							end
							else if ($signed(UserCurrentPositionX) > $signed(799)) begin
									//UserCurrentPositionX = $signed(800-PLAYER_BOX_WIDTH_HALF);
									reset = 1;
									ptr = -1;
									for ( i = 0; i<41; i = i + 1)
										begin
											stackX[i] = 0;
											stackY[i] = 0;
										end
									UserCurrentPositionX = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
									UserCurrentPositionY = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
							end
							


						end
			end
	
	
	end
	
	
	/* ===============================================================================
	 *                          Graphics output 
	 * =============================================================================== */
	
	always @(posedge clk_reduced)
	begin
		if (PixelX >= (UserCurrentPositionX - PLAYER_BOX_WIDTH_HALF) &&
			 PixelX <= (UserCurrentPositionX + PLAYER_BOX_WIDTH_HALF) &&
			 PixelY >= (UserCurrentPositionY - PLAYER_BOX_WIDTH_HALF) &&
			 PixelY <= (UserCurrentPositionY + PLAYER_BOX_WIDTH_HALF))
		begin
			R[2:0] = 3'b000;
			G[2:0] = 3'b000;
			B[1:0] = 2'b11;
		end
		else if (PixelX >= (fruitPositionX - PLAYER_BOX_WIDTH_HALF) &&
			 PixelX <= (fruitPositionX + PLAYER_BOX_WIDTH_HALF) &&
			 PixelY >= (fruitPositionY - PLAYER_BOX_WIDTH_HALF) &&
			 PixelY <= (fruitPositionY + PLAYER_BOX_WIDTH_HALF))
		begin
			R[2:0] = Rfruta;
			G[2:0] = Gfruta;
			B[1:0] = Bfruta;
		end
		else
		begin
			estaCola = 0;
			for ( j = 40; j >= 0 ; j = j - 1)
				begin
					if (estaCola == 0)
						begin
						if (PixelX >= (stackX[j] - PLAYER_BOX_WIDTH_HALF) &&
							 PixelX <= (stackX[j] + PLAYER_BOX_WIDTH_HALF) &&
							 PixelY >= (stackY[j] - PLAYER_BOX_WIDTH_HALF) &&
							 PixelY <= (stackY[j] + PLAYER_BOX_WIDTH_HALF))
							begin
								if (stackX[j] > 0 || stackY[j] > 0)
									begin
										estaCola = 1;
										R[2:0] = 3'b000;
										G[2:0] = 3'b000;
										B[1:0] = 2'b11;
									end
							end
						 end
				end
			if (estaCola == 0)
				begin
					R[2:0] = 3'b111;
					G[2:0] = 3'b111;
					B[1:0] = 2'b11;
				end
		end
		
	end											
	

endmodule
