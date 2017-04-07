`timescale 1ns / 1ps

module frequency_divider(output CLK_1Hz, output CLK_2Hz, output CLK_1KHz, input CLK);

	/*
		1s (1Hz) 	= 100 000 000 cicles
		2^(27)		= 134 217 728 cicles
		
		0.5s (2Hz) 	=  50 000 000 cicles
		2^(26)		=  67 108 864 cicles
		
		1ms (1KHz) 	=     100 000 cicles
		2^(17)		=		131 072 cicles
	*/

	reg [26:0] count_1Hz;
	reg [25:0] count_2Hz;
	reg [16:0] count_1KHz;

	initial begin count_1Hz=0; count_2Hz=0; count_1KHz=0; end

	always @ (posedge CLK)
		begin
			count_1Hz = count_1Hz+27'b000000000000000000000000001;
			count_2Hz = count_2Hz+26'b00000000000000000000000001;
			count_1KHz = count_1KHz+17'b00000000000000001;
		end
	
	assign CLK_1Hz = count_1Hz[26];
	assign CLK_2Hz = count_2Hz[25];
	assign CLK_1KHz = count_1KHz[16];

endmodule

	/* 
		MODULE THINGS 
		GREEN LIGHT = YES;
		TESTED = NO;
	*/
