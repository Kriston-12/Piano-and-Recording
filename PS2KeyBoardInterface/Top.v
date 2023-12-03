`default_nettype none

module Top (CLOCK_50, KEY, SW, LEDR, 
        PS2_CLK, PS2_DAT, AUD_XCK,
		  	AUD_ADCDAT,

				// Bidirectionals
				AUD_BCLK,
				AUD_ADCLRCK,
				AUD_DACLRCK,

				FPGA_I2C_SDAT,

				// Outputs
				AUD_XCK,
				AUD_DACDAT,

				FPGA_I2C_SCLK,
				HEX0,
				HEX1);
				
    input  wire  CLOCK_50;   
    input  wire [3: 0] KEY;        
    input  wire [9: 0] SW;         // DE-series switches
    wire  [7: 0] dataToAudio;       // DE-series HEX displays
    
    output wire [ 9: 0] LEDR;       // DE-series LEDs

    inout  wire         PS2_CLK;    // PS/2 Clock
    inout  wire         PS2_DAT;    // PS/2 Data
	 input				AUD_ADCDAT;

	// Bidirectionals
	inout				AUD_BCLK;
	inout				AUD_ADCLRCK;
	inout				AUD_DACLRCK;

	inout				FPGA_I2C_SDAT;

	// Outputs
	output				AUD_XCK;
	output				AUD_DACDAT;
	output [6:0]HEX0;
	output [6:0]HEX1;
	output				FPGA_I2C_SCLK;
		 

    assign LEDR = SW;

    PS2_Comm comm(CLOCK_50, KEY[1:0], SW, PS2_CLK, PS2_DAT, dataToAudio);
	 hexdisplay d1(dataToAudio, HEX0, HEX1); 
	 DE1_SoC_Audio_Example dd1(.CLOCK_50(CLOCK_50),
								.KEY(KEY),

								.AUD_ADCDAT(AUD_ADCDAT),

								// Bidirectionals
								.AUD_BCLK(AUD_BCLK),
								.AUD_ADCLRCK(AUD_ADCLRCK),
								.AUD_DACLRCK(AUD_DACLRCK),

								.FPGA_I2C_SDAT(FPGA_I2C_SDAT),

								// Outputs
								.AUD_XCK(AUD_XCK),
								.AUD_DACDAT(AUD_DACDAT),

								.FPGA_I2C_SCLK(FPGA_I2C_SCLK),
								.SW(dataToAudio));
								
//		DE1_SoC_Audio_Example dd2(.CLOCK_50(CLOCK_50),
//								.KEY(KEY),
//
//								.AUD_ADCDAT(AUD_ADCDAT),
//
//								// Bidirectionals
//								.AUD_BCLK(AUD_BCLK),
//								.AUD_ADCLRCK(AUD_ADCLRCK),
//								.AUD_DACLRCK(AUD_DACLRCK),
//
//								.FPGA_I2C_SDAT(FPGA_I2C_SDAT),
//
//								// Outputs
//								.AUD_XCK(AUD_XCK),
//								.AUD_DACDAT(AUD_DACDAT),
//
//								.FPGA_I2C_SCLK(FPGA_I2C_SCLK),
//								.SW(SW[7:0]));

endmodule

//module Top (CLOCK_50,
//			KEY, 
//			SW, 
//			dataToAudio, 
//			LEDR, 
//			AUD_ADCDAT,
//			
//			// Bidirectionals
//			AUD_BCLK,
//			AUD_ADCLRCK,
//			AUD_DACLRCK,
//
//         PS2_CLK, PS2_DAT);
//		  
//    input  wire         CLOCK_50;   // DE-series 50 MHz clock signal
//    input  wire [ 3: 0] KEY;        // DE-series pushbuttons
//    input  wire [ 9: 0] SW;         // DE-series switches
//	 
//	 
//    output wire [ 7: 0] dataToAudio;       // DE-series HEX displays
//    
//    output wire [ 9: 0] LEDR;       // DE-series LEDs
//
//    inout  wire         PS2_CLK;    // PS/2 Clock
//    inout  wire         PS2_DAT;    // PS/2 Data
//
//    assign LEDR = SW;
//
//    PS2_Comm comm(CLOCK_50, KEY[1:0], SW, PS2_CLK, PS2_DAT, dataToAudio);
//	 
//
//endmodule