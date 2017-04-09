
module GameLogic(input uclk,
							 input [10:0] PixelX,
							 input [10:0] PixelY,
							 input reset,
							 input BtnLeft,
							 input BtnRight,
							 input BtnTop,
							 input BtnBottom,							 
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
	
			clk_reduced = 1;
	end
	
	
	/* ===============================================================================
	 *                                Position variables
	 * =============================================================================== */
	
	reg signed [11:0] UserCurrentPositionX;
	reg signed [11:0] UserCurrentPositionY;		
	
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
	 *                          Reduced clock for movement
	 * =============================================================================== */
	 
	reg [30:0] clk_counter = 0;
	reg clk_reduced;
	
	always @(posedge uclk)
	begin
		clk_counter = clk_counter + 1;
		if (clk_counter == 2000000)
		begin
			clk_counter = 0;
			clk_reduced = ~clk_reduced;		
		end
	
	end
	
	
	/* ===============================================================================
	 *                                  Game logic
	 * =============================================================================== */
	
	
	always @(posedge clk_reduced)
	begin
	
	
		if (reset == 1)
		begin
			UserCurrentPositionX = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
			UserCurrentPositionY = INITIAL_START_POS_X + PLAYER_BOX_WIDTH_HALF;
		end
		else
		begin
			
				if (BtnBottom == 1 && (UserCurrentPositionX + PLAYER_BOX_WIDTH_HALF) <= 599) begin
					UserCurrentPositionY = $signed(UserCurrentPositionY) + PLAYER_BOX_WIDTH;
				end
				
				if (BtnTop == 1 && (UserCurrentPositionY - PLAYER_BOX_WIDTH_HALF) >= 1) begin
					UserCurrentPositionY = $signed(UserCurrentPositionY) - PLAYER_BOX_WIDTH;
				end
				
				if (BtnRight == 1 && (UserCurrentPositionX + PLAYER_BOX_WIDTH_HALF) <= 799) begin
					UserCurrentPositionX = $signed(UserCurrentPositionX) + PLAYER_BOX_WIDTH;
				end
				
				if (BtnLeft == 1 && (UserCurrentPositionX - PLAYER_BOX_WIDTH_HALF) >= 1) begin
					UserCurrentPositionX = $signed(UserCurrentPositionX) - PLAYER_BOX_WIDTH;
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
	
	
	/* ===============================================================================
	 *                          Graphics output 
	 * =============================================================================== */
	
	always @(clk_reduced)
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


	/* ===============================================================================
	 *                               Module instantiations
	 * =============================================================================== */
	 
	 /*defparam isHeldFor4Seconds.SECONDS = 4;
	 IsHeldForXSeconds isHeldFor4Seconds(.uclk(uclk),
													 .reset(1'b0),
													 .btn(reset),
													 .val(reset_held_for_more_than_4_sec));*/												
	

endmodule
