// Part 2 skeleton

module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		SW,
		// Your inputs and outputs here
		KEY,							// On Board Keys
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		PS2_CLK,						//keyboard clock signal
		PS2_DAT,						//keyboard data signal
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5,
		LEDR,
		
		  	AUD_ADCDAT,

				// Bidirectionals
				AUD_BCLK,
				AUD_ADCLRCK,
				AUD_DACLRCK,

				FPGA_I2C_SDAT,

				// Outputs
				AUD_XCK,
				AUD_DACDAT,

				FPGA_I2C_SCLK
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;		
	inout wire PS2_CLK;
	inout wire PS2_DAT;
	output [9:0] LEDR;
	 input				AUD_ADCDAT;

	// Bidirectionals
	inout				AUD_BCLK;
	inout				AUD_ADCLRCK;
	inout				AUD_DACLRCK;

	inout				FPGA_I2C_SDAT;

	// Outputs
	output				AUD_XCK;
	output				AUD_DACDAT;
	output				FPGA_I2C_SCLK;
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
    output wire [ 6: 0] HEX0;       // DE-series HEX displays
    output wire [ 6: 0] HEX1;
    output wire [ 6: 0] HEX2;
    output wire [ 6: 0] HEX3;
    output wire [ 6: 0] HEX4;
    output wire [ 6: 0] HEX5;
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	input [9:0] SW;

	wire [2:0] colour;
	wire [8:0] x;
	wire [7:0] y;
	wire writeEn;
	
	wire				key_pressed;
	wire			[7:0]	last_data_received;
	wire [3:0]curr_screen;
	wire recording_start;
	wire [3:0]unit;
	wire [1:0]ten;
	wire [1:0] requser;
	wire [1:0] song;
	wire [7:0] dataToAudio;
	wire quarter_clk;
	wire playing;
	wire [7:0] onote;
	
	
	wire [5:0] noteOffset;
	noteCounter #(50000000) NC (CLOCK_50, recording_start, noteOffset);
	
	reg [1 + $clog2(50000000):0] rateDiv = 0;
	reg writePulse = 1'b0;

	always @(posedge CLOCK_50)
	begin
		if (rateDiv == ((50000000 >> 2) - 1))
			begin
				// writePulse <= writePulse ^ writePulse;
				if (writePulse) 
					begin
					writePulse <= 1'b0;
					end
				else 
					begin
					writePulse <= 1'b1;
					end
				rateDiv <= 0;
			end
		else
			begin
			rateDiv <= rateDiv + 1;
			end
	end

	wire prohibited;

	MemoryControl #(50000000) bryan (.reset(~resetn), .clock(CLOCK_50), .requser(requser - 1'b1), .user(requser - 1'b1), .song(song - 1'b1), .inote(dataToAudio), .writeNote(writePulse & recording_start), .playSong(~KEY[2]), .protectionChange(1'b0), 
					  .noteOffset(noteOffset), .currNote(), .noteValid(playing), .prohibited(prohibited), .onote(onote));
		  
	Hexadecimal_To_Seven_Segment1 Segment1 (
	.hex_number			(onote[3:0]),
	.seven_seg_display	(HEX2)
	);
	Hexadecimal_To_Seven_Segment1 Segment2 (
	.hex_number			(onote[7:4]),
	.seven_seg_display	(HEX3)
	);
	

	assign LEDR[0] = writePulse;
	assign LEDR[1] = writePulse & recording_start;
	// assign LEDR[9:2] = dataToAudio;
	assign LEDR[2] = playing;

	//assign LEDR[4:3] = requser - 1'b1;
	//assign LEDR[6:5] = song - 1'b1;
	//assign LEDR[7] = prohibited;
	
	assign LEDR[8:3] = noteOffset;
	

	wire [9:0] useless;

	Top Kris (CLOCK_50, KEY[1:0], SW, useless, 
        PS2_CLK, PS2_DAT, 
		  	AUD_ADCDAT,

				// Bidirectionals
				AUD_BCLK,
				AUD_ADCLRCK,
				AUD_DACLRCK,
				
				FPGA_I2C_SDAT,
				AUD_XCK,	
				AUD_DACDAT,	
				
		      FPGA_I2C_SCLK,
				HEX0,
				HEX1,
				dataToAudio,				
				onote,
				playing);
	
	PS2_Comm comm(CLOCK_50, resetn, PS2_CLK, PS2_DAT, last_data_received);
	/*
	Hexadecimal_To_Seven_Segment1 Segment1 (
	// Inputs
	.hex_number			(curr_screen),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX2)
);

	Hexadecimal_To_Seven_Segment1 Segment2 (
	// Inputs
	.hex_number			({3'b000, recording_start}),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX3)
);*/

	Hexadecimal_To_Seven_Segment1 Segment3 (
	// Inputs
	.hex_number			({unit}),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX4)
);
	Hexadecimal_To_Seven_Segment1 Segment4 (
	// Inputs
	.hex_number			({ten}),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX5)
);
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "TRUE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "screen1.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	main_display_controller(.iResetn(resetn),.iLoadX(~KEY[3]),.iClock(CLOCK_50),.oX(x),.oY(y),.oColour(colour),.oPlot(writeEn), .iKeyboardInput(last_data_received), .key_pressed(key_pressed), .curr_screen(curr_screen), .recording_start(recording_start),
		.unit(unit),
		.ten(ten), .requser(requser), .song(song), .quarter_clk(quarter_clk), .playing(playing));
endmodule
