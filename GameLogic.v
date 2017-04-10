
module GameLogic(
							 input uclk,
							 input clk_reduced,
							 input mover,
							 input [10:0] PixelX,
							 input [10:0] PixelY,
							 input reset,
							 input BtnLeft,
							 input BtnRight,
							 input BtnTop,
							 input BtnBottom,
							 input [2:0] accion,
							 output reg [2:0] R,
							 output reg [2:0] G,
							 output reg [1:0] B
							 );
	
	/* ===============================================================================
	 *                             Parameters/Constants
	 * =============================================================================== */
	parameter PLAYER_BOX_WIDTH		  	= 10;
	parameter PLAYER_BOX_WIDTH_HALF	= PLAYER_BOX_WIDTH/2;
	
	parameter INITIAL_START_POS_X 	= 40;
	parameter INITIAL_START_POS_Y 	= 40;
	
	reg arriba;
	reg abajo;
	reg derecha;
	reg izquierda;
	
	
	/* ===============================================================================
	 *                              Level selector
	 * =============================================================================== */
	
	//reg [3:0] CurrentLevel;	
	
	/* ===============================================================================
	 *                          Initial register values
	 * =============================================================================== */
	
	initial begin
			UserCurrentPositionX = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
			UserCurrentPositionY = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
			arriba = UserCurrentPositionY - PLAYER_BOX_WIDTH_HALF;
			abajo = UserCurrentPositionY + PLAYER_BOX_WIDTH_HALF;
			izquierda = UserCurrentPositionX - PLAYER_BOX_WIDTH_HALF;
			derecha = UserCurrentPositionX + PLAYER_BOX_WIDTH_HALF;
	end
	
	
	/* ===============================================================================
	 *                                Position variables
	 * =============================================================================== */
	
	reg [11:0] UserCurrentPositionX;
	reg [11:0] UserCurrentPositionY;
	reg movido = 0;
	
	
	/* ===============================================================================
	 *                                Collision Detection
	 * =============================================================================== */
	/*
	
	wire [2:0] CollisionDetect_XRight_R, CollisionDetect_XLeft_R, CollisionDetect_YTop_R, CollisionDetect_YBottom_R;
	wire [2:0] CollisionDetect_XRight_G, CollisionDetect_XLeft_G, CollisionDetect_YTop_G, CollisionDetect_YBottom_G;
	wire [1:0] CollisionDetect_XRight_B, CollisionDetect_XLeft_B, CollisionDetect_YTop_B, CollisionDetect_YBottom_B;
	
	assign FlagCollisionDetected_Right  = (CollisionDetect_XRight_R == 3'b000 &&
													   CollisionDetect_XRight_G == 3'b000 &&
													   CollisionDetect_XRight_B == 2'b00);
													  
	assign FlagCollisionDetected_Left   = (CollisionDetect_XLeft_R == 3'b000 &&
													   CollisionDetect_XLeft_G == 3'b000 &&
													   CollisionDetect_XLeft_B == 2'b00);
													  
	assign FlagCollisionDetected_Top    = (CollisionDetect_YTop_R == 3'b000 &&
													   CollisionDetect_YTop_G == 3'b000 &&
													   CollisionDetect_YTop_B == 2'b00);
														
	assign FlagCollisionDetected_Bottom = (CollisionDetect_YBottom_R == 3'b000 &&
													   CollisionDetect_YBottom_G == 3'b000 &&
													   CollisionDetect_YBottom_B == 2'b00);
	*/														
			
	
	/* ===============================================================================
	 *                                  Game logic
	 * =============================================================================== */
	
	
	always @(posedge uclk)
		begin
	
	
		if (reset == 1)
			begin
				UserCurrentPositionX = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
				UserCurrentPositionY = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
			end
		else
			begin
				if (mover == 0) begin
					movido = 1;
				end else
					if (movido == 1)
						begin
							movido = 0;
							arriba = UserCurrentPositionY - PLAYER_BOX_WIDTH_HALF;
							abajo = UserCurrentPositionY + PLAYER_BOX_WIDTH_HALF;
							izquierda = UserCurrentPositionX - PLAYER_BOX_WIDTH_HALF;
							derecha = UserCurrentPositionX + PLAYER_BOX_WIDTH_HALF;
				
							if (accion == 2 && abajo <= 599) begin
								UserCurrentPositionY = UserCurrentPositionY + PLAYER_BOX_WIDTH;
							end
							
							if (accion == 1 && arriba >= 1) begin
								UserCurrentPositionY = UserCurrentPositionY - PLAYER_BOX_WIDTH;
							end
							
							if (accion == 4 && derecha <= 799) begin
								UserCurrentPositionX = UserCurrentPositionX + PLAYER_BOX_WIDTH;
							end
							
							if (accion == 3 && izquierda >= 1) begin
								UserCurrentPositionX = UserCurrentPositionX - PLAYER_BOX_WIDTH;
							end
							/*
						
							if ($signed(UserCurrentPositionY) < $signed(0)) begin
									UserCurrentPositionY = $signed(0);
							end
							if ($signed(UserCurrentPositionY) > $signed(600)) begin
									UserCurrentPositionY = $signed(600);
							end
							if ($signed(UserCurrentPositionX) < $signed(0)) begin
									UserCurrentPositionX = $signed(0);
							end
							if ($signed(UserCurrentPositionX) > $signed(800)) begin
									UserCurrentPositionX = $signed(800);
							end
							*/
						end
			end
	
	
	end
	
	
	/* ===============================================================================
	 *                          Graphics output 
	 * =============================================================================== */
	
	always @(posedge uclk)
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
		else
		begin
			R[2:0] = 3'b111;
			G[2:0] = 3'b111;
			B[1:0] = 2'b11;
		end
		
	end											
	

endmodule
