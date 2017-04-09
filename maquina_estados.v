`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module maquina_estados(
	 //0: no hay ningún input
	 //1: arriba
	 //2: abajo
	 //3: izquierda
	 //4: derecha
	 input clk, //clock
	 input rst, //reset
	 input arriba,
	 input abajo,
	 input izquierda,
	 input derecha,
	 input pausa,
	 output hsync,
	 output vsync,
	 output reg [2:0] RED,
	 output reg [2:0] GREEN,
	 output reg [1:0] BLUE
	 );


	reg [2:0] accion; ///salida de la máquina de estados, dice lo que tiene que hacer el cuadro

	parameter Inicio=0, MArr=1, MAba=2, MIzq=3, MDer=4, PArr=5, PAba=6, PDer=7, PIzq= 8; //Estados
	
	reg [3:0] e_actual = Inicio; //estado actual (piso)
	reg [3:0] e_siguiente = Inicio; // estado siguiente
	reg agregar = 0;
	reg obtener = 0;
	wire [2:0] memoria; //registro con la siguiente instruccion para la maquina de estados

	reg [26:0] contador_ciclos = 0;
	//integer memoria_input;
	//wire [3:0] boton_pres1;
	wire [2:0] boton_pres; //entradas donde se guardan todos los botones de los pisos
	//accion //0: nada, 1: arriba, 2: abajo, 3: izquierda, 4: derecha
	reg [3:0] contador_seg = 0;
		
	
	
	//assign boton_pres1 = boton_pres;
	
	reg LE = 1;
	
	reg [1:0] doscicloclk = 0;

/*
	initial 
		begin
			accion = 0;
			contador_seg = 0;
			//memoria_m = 0;
		end
	*/
	
	//Frecuencias de 1kHz y otras
	//(* keep="soft" *)
	//wire CLK_1Hz;
	//(* keep="soft" *)
	//wire CLK_2Hz;
	//wire CLK_1KHz;
	////frequency_divider divisor (CLK_1Hz, CLK_2Hz, CLK_1KHz, clk);

	reg clk_50mhz = 0;
	wire hsync_out;
	wire vsync_out;
	wire vidon;
	
	wire [10:0] PixelX;
	wire [10:0] PixelY;
	
	wire [2:0] RObtenido;
	wire [2:0] GObtenido;
	wire [1:0] BObtenido;
	
	assign hsync = ~hsync_out;
	assign vsync = ~vsync_out;
	/*
	manejo_entradas entradas(
	clk,
	arriba,
	abajo,
	izquierda,
	derecha,
	pausa,
	boton_pres
    );
	 */
	manejo_memoria memoria_movimiento(
   clk,
	rst,
	LE,
	boton_pres, //boton que se presiona
	memoria //registro con la siguiente instruccion para la maquina de estados
    );
	 /*
	 clock50M clockde50MHz(
	 clk,
	 clk_50mhz
	 );
	 */
	 vga_800x600 controlador(
	 .clk(clk_50mhz),
	 .clr(rst),
	 .hsync(hsync_out),
	 .vsync(vsync_out),
	 .PixelX(PixelX),
	 .PixelY(PixelY),
	 .vidon(vidon));
	 
	 GameLogic pintador(
	 clk,
	 PixelX,
	 PixelY,
	 rst,
	 izquierda,
	 derecha,
	 arriba,
	 abajo,
	 RObtenido,
	 GObtenido,
	 BObtenido
	 );
	 
	 
	 always @(posedge clk)
	 begin
			clk_50mhz = ~clk_50mhz;
	 end
	 
	 always @(posedge clk_50mhz)
	 begin
		
		if (vidon)
		begin
			
				RED[2:0] = RObtenido;
				GREEN[2:0] = GObtenido;
				BLUE[1:0] = BObtenido;
		
		end
		else
		begin
			
			RED[2:0] = 3'b000;
			GREEN[2:0] = 3'b000;
			BLUE[1:0] = 2'b00;
		
		end
		
		
	 end
	 
	
	always @ (posedge clk)
	   begin
			if(rst)
			   begin
				   e_actual = Inicio;
					LE = 1;
					contador_seg = 4'b0;
				end
			else			
				begin
					//memoria_m = memoria;
					LE = 1;
					if (contador_ciclos == 100000000)
						begin
							contador_seg = contador_seg + 4'b0001;
						end
					else if (contador_seg == 2)
						begin
							contador_seg = 4'b0;
						   LE = 0;
							#200;
							case(e_actual)
							
				//************ Estado: Piso 1*****************//
								Inicio:begin
									case(memoria)
										0,5: //nada o pausa
											begin
												accion = 0;
												e_siguiente=Inicio;
											end
										1: //arriba
											begin
												accion = 1;
												e_siguiente=MArr;
											end
										2: //abajo
											begin
												accion = 2;
												e_siguiente=MAba;
											end
										3: //izquierda
											begin
												accion = 3;
												e_siguiente=MIzq;
											end
										4: //derecha
											begin
												accion = 4;
												e_siguiente=MDer;
											end
	
										default:e_siguiente=Inicio;
									endcase
								end

				//************ Estado: Piso 2*****************//
								MArr:begin
									case(memoria)
										0,1,2: //nada, arriba o abajo
											begin
												accion = 1; //hacia arriba
												e_siguiente=MArr;
											end
										3: //izquierda
											begin
												accion = 3;
												e_siguiente=MIzq;
											end
										4: //derecha
											begin
												accion = 4;
												e_siguiente=MDer;
											end
										5: //pausa
											begin
												accion = 0; //nada
												e_siguiente=PArr;
											end
										default:e_siguiente=Inicio;
									endcase
									end
									
				//************ Estado: Piso 3*****************//
								MAba:begin
									case(memoria)
										0,1,2: //nada, arriba o abajo
											begin
												accion = 2; //hacia arriba
												e_siguiente=MAba;
											end
										3: //izquierda
											begin
												accion = 3;
												e_siguiente=MIzq;
											end
										4: //derecha
											begin
												accion = 4;
												e_siguiente=MDer;
											end
										5: //pausa
											begin
												accion = 0; //nada
												e_siguiente=PAba;
											end
										default:e_siguiente=Inicio;
									endcase
									end

				//************ Estado: Piso 4*****************//
								MIzq:begin
									case(memoria)
										0,3,4: //nada, izquierda o derecha
											begin
												accion = 3; //hacia arriba
												e_siguiente=MIzq;
											end
										1: //arriba
											begin
												accion = 1;
												e_siguiente=MArr;
											end
										2: //abajo
											begin
												accion = 2;
												e_siguiente=MAba;
											end
										5: //pausa
											begin
												accion = 0; //nada
												e_siguiente=PIzq;
											end
										default:e_siguiente=Inicio;
									endcase
									end
				//************ Estado: Movderecha*****************//
								MDer:begin
									case(memoria)
										0,3,4: //nada, izquierda o derecha
											begin
												accion = 4; //hacia arriba
												e_siguiente=MDer;
											end
										1: //arriba
											begin
												accion = 1;
												e_siguiente=MArr;
											end
										2: //abajo
											begin
												accion = 2;
												e_siguiente=MAba;
											end
										5: //pausa
											begin
												accion = 0; //nada
												e_siguiente=PDer;
											end
										default:e_siguiente=Inicio;
									endcase
									end
				//************ Estado: Parriba*****************//
								PArr:begin
									case(memoria)
										0,1,2,3,4: //nada, izquierda o derecha
											begin
												accion = 0; //hacia arriba
												e_siguiente=PArr;
											end
										5: //arriba
											begin
												accion = 1;
												e_siguiente=MArr;
											end
										default:e_siguiente=Inicio;
									endcase
									end	
				//************ Estado: Parriba*****************//
								PAba:begin
									case(memoria)
										0,1,2,3,4: //nada, izquierda o derecha
											begin
												accion = 0; //hacia arriba
												e_siguiente=PAba;
											end
										5: //arriba
											begin
												accion = 2;
												e_siguiente=MAba;
											end
										default:e_siguiente=Inicio;
									endcase
									end	
				//************ Estado: Parriba*****************//
								PIzq:begin
									case(memoria)
										0,1,2,3,4: //nada, izquierda o derecha
											begin
												accion = 0; //hacia arriba
												e_siguiente=PIzq;
											end
										5: //arriba
											begin
												accion = 3;
												e_siguiente=MIzq;
											end
										default:e_siguiente=Inicio;
									endcase
									end
				//************ Estado: Parriba*****************//
								PDer:begin
									case(memoria)
										0,1,2,3,4: //nada, izquierda o derecha
											begin
												accion = 0; //hacia arriba
												e_siguiente=PDer;
											end
										5: //arriba
											begin
												accion = 4;
												e_siguiente=MDer;
											end
										default:e_siguiente=Inicio;
									endcase
									end	
				//************ Estado: Defecto*****************//					
								default: e_siguiente=Inicio;//por defecto estÃ¡ en el piso 1
							endcase
							e_actual = e_siguiente;
							
						end
				end
		end
		
endmodule
