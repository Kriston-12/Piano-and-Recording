
module DE1_SoC_Audio_Example (
	// Inputs
	CLOCK_50,
	KEY,

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
	SW
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input				CLOCK_50;
input		[3:0]	KEY;
input		[7:0]	SW;

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

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire				audio_in_available;
wire		[31:0]	left_channel_audio_in;
wire		[31:0]	right_channel_audio_in;
wire				read_audio_in;

wire				audio_out_allowed;
wire		[31:0]	left_channel_audio_out;
wire		[31:0]	right_channel_audio_out;
wire				write_audio_out;

// Internal Registers

reg [19:0] delay_cnt;
reg [19:0] delay;

reg [19:0] delay_cnt2;
reg [19:0] delay2;

reg snd;
reg snd2;


localparam
        A1 =    20'd909091,
        Bb1 =   20'd858068,
        B1 =    20'd809908,
        C2 =    20'd764451,
        Db2 =   20'd721546,
        D2 =    20'd681049,
        Eb2 =   20'd642824,
        E2 =    20'd606745,
        F2 =    20'd572691,
        Gb2 =   20'd540549,
        G2 =    20'd510210,
        Ab2 =   20'd481574,
        A2 =    20'd454545,
        Bb2 =   20'd429034,
        B2 =    20'd404954,
        C3 =    20'd382226,
        Db3 =   20'd360773,
        D3 =    20'd340524,
        Eb3 =   20'd321412,
        E3 =    20'd303373,
        F3 =    20'd286346,
        Gb3 =   20'd270274,
        G3 =    20'd255105,
        Ab3 =   20'd240787,
        A3 =    20'd227273,
        Bb3 =   20'd214517,
        B3 =    20'd202477,
        C4 =    20'd191113,
        Db4 =   20'd180386,
        D4 =    20'd170262,
        Eb4 =   20'd160706,
        E4 =    20'd151686,
        F4 =    20'd143173,
        Gb4 =   20'd135137,
        G4 =    20'd127553,
        Ab4 =   20'd120394,
        A4 =    20'd113636,
        Bb4 =   20'd107258,
        B4 =    20'd101238,
        C5 =    20'd95556,
        Db5 =   20'd90193,
        D5 =    20'd85131,
        Eb5 =   20'd80353,
        E5 =    20'd75843,
        F5 =    20'd71586,
        Gb5 =   20'd67569,
        G5 =    20'd63776,
        Ab5 =   20'd60197,
        A5 =    20'd56818,
        Bb5 =   20'd53629,
        B5 =    20'd50619,
        C6 =    20'd47778,
        Db6 =   20'd45097,
        D6 =    20'd42566,
        Eb6 =   20'd40177,
        E6 =    20'd37922,
        F6 =    20'd35793,
        Gb6 =   20'd33784,
        G6 =    20'd31888,
        Ab6 =   20'd30098,
        A6 =    20'd28409;
// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge CLOCK_50)
	if(delay_cnt == delay) begin
		delay_cnt <= 0;
		snd <= !snd;
	end 
	else delay_cnt <= delay_cnt + 1;

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

 always@(posedge CLOCK_50)
	if (delay_cnt2 == delay2)
	begin
		delay_cnt2 <= 0;
		snd2 <= !snd;
	end
	else delay_cnt2 <= delay_cnt2 + 1;
 
 
//assign delay = {SW[3:0], 15'd3000};


always @(SW)
        begin
        case(SW)
				
            21: delay = C3;   // 15 Q

            29: delay = D3;   // 1D W

            36: delay = E3;   // 24 E
            45: delay = F3;   // 2D R
  
            44: delay = G3; // 2C T

            53: delay = A3; // 35 Y

            60: delay = B3; // 3C U
            28: delay = C4; // 1C A
 
            27: delay = D4; // 1B S

            35: delay = E4; // 23 D
            43: delay = F4; // 2B F

            52: delay = G4; // 34 G

            51: delay = A4; // 33 H

            59: delay = B4; // 3B J
            26: delay = C5; // 1A Z

            34: delay = D5; // 22 X

            33: delay = E5; // 21 C
            42: delay = F5; // 2A V

            50: delay = G5; // 32 B

            49: delay = A5; // 32 N

            58: delay = B5; // 3A M
				
				
            10'd61: delay = 20'd28409; // Assuming this is the last value
            default: delay = 20'd0; // default case if SW doesn't match any of the specified values
        endcase
    end




always @(SW)
        begin
        case(SW)
				
            8'h69: delay2 = Eb4;   
            8'h72: delay2 = Gb4;   

            8'h7A: delay2 = Ab4;   
            8'h6B: delay2 = Bb4;   // 2D R
  
            8'h73: delay2 = Db5; // 2C T

            8'h74: delay2 = Eb5; // 35 Y

            8'h6C: delay2 = Gb5; // 3C U
            8'h75: delay2 = Ab5; // 1C A
 
            8'h7D: delay2 = Bb4; // 1B S
//
////            35: delay2 = E4; // 23 D
////            43: delay2 = F4; // 2B F
////
////            52: delay2 = G4; // 34 G
////
////            51: delay2 = A4; // 33 H
////
////            59: delay2 = B4; // 3B J
////            26: delay2 = C5; // 1A Z
////
////            34: delay2 = D5; // 22 X
////
////            33: delay2 = E5; // 21 C
////            42: delay2 = F5; // 2A V
////
////            50: delay2 = G5; // 32 B
////
////            49: delay2 = A5; // 32 N
////
////            58: delay2 = B5; // 3A M
//				21: delay2 = C3;   // 15 Q
//
//            29: delay2 = D3;   // 1D W
//
//            36: delay2 = E3;   // 24 E
//            45: delay2 = F3;   // 2D R
//  
//            44: delay2 = G3; // 2C T
//
//            53: delay2 = A3; // 35 Y
//
//            60: delay2 = B3; // 3C U
//            28: delay2 = C4; // 1C A
// 
//            27: delay2 = D4; // 1B S
//
//            35: delay2 = E4; // 23 D
//            43: delay2 = F4; // 2B F
//
//            52: delay2 = G4; // 34 G
//
//            51: delay2 = A4; // 33 H
//
//            59: delay2 = B4; // 3B J
//            26: delay2 = C5; // 1A Z
//
//            34: delay2 = D5; // 22 X
//
//            33: delay2 = E5; // 21 C
//            42: delay2 = F5; // 2A V
//
//            50: delay2 = G5; // 32 B
//
//            49: delay2 = A5; // 32 N
//
//            58: delay2 = B5; // 3A M
				
            10'd61: delay2 = 20'd28409;
            default: delay2 = 20'd0; 
        endcase
    end







wire [31:0] sound = (SW == 0) ? 0 : snd ? 32'd10000000 : -32'd10000000;
wire [31:0] sound2 = (SW == 0) ? 0 : snd2 ? 32'd10000000 : -32'd10000000;

assign read_audio_in		= audio_in_available & audio_out_allowed;

assign left_channel_audio_out	= left_channel_audio_in+sound;
assign right_channel_audio_out	= right_channel_audio_in+sound2;
assign write_audio_out			= audio_in_available & audio_out_allowed;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

Audio_Controller Audio_Controller (
	// Inputs
	.CLOCK_50						(CLOCK_50),
	.reset						(~KEY[0]),

	.clear_audio_in_memory		(),
	.read_audio_in				(read_audio_in),
	
	.clear_audio_out_memory		(),
	.left_channel_audio_out		(left_channel_audio_out),
	.right_channel_audio_out	(right_channel_audio_out),
	.write_audio_out			(write_audio_out),

	.AUD_ADCDAT					(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK					(AUD_BCLK),
	.AUD_ADCLRCK				(AUD_ADCLRCK),
	.AUD_DACLRCK				(AUD_DACLRCK),


	// Outputs
	.audio_in_available			(audio_in_available),
	.left_channel_audio_in		(left_channel_audio_in),
	.right_channel_audio_in		(right_channel_audio_in),

	.audio_out_allowed			(audio_out_allowed),

	.AUD_XCK					(AUD_XCK),
	.AUD_DACDAT					(AUD_DACDAT)

);

avconf #(.USE_MIC_INPUT(1)) avc (
	.FPGA_I2C_SCLK					(FPGA_I2C_SCLK),
	.FPGA_I2C_SDAT					(FPGA_I2C_SDAT),
	.CLOCK_50					(CLOCK_50),
	.reset						(~KEY[0])
);

endmodule

