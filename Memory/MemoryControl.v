
module MemoryControl (input reset, input clock, input [1:0] requser, input [1:0] user, input [1:0] song, input [7:0] inote,
					  input writeNote, input playSong, input protectionChange, 
					  input [5:0] noteOffset, output [5:0] currNote, output reg noteValid, output reg prohibited, output [7:0] onote);
	parameter CLOCK_FREQUENCY = 100;
	
	// noteOffset will be 0 for first note, 59 for last (60th) note
	// in pchange mode inote will not be a note, but 1 for private and 0 for public
	// requser is the user who's requesting the song to play (when in playSong mode), as opposed to the user who's song we're requesting

	localparam START = 4'd0, WRITENOTE_WAIT = 4'd1, WRITENOTE = 4'd2, PLAY_WAIT = 4'd3, PLAY_CHECK = 4'd4, PLAY_CHECK_WAIT = 4'd5, 
			   PLAY_PROHIBITED = 4'd6, PLAY = 4'd7, PCHANGE_WAIT = 4'd8, PCHANGE = 4'd9;
	reg [3:0] cState = 4'd0, nState;

	reg opAllowed; // 0 for not allowed, 1 for allowed, but not always a valid value
	wire [5:0] notePlaying; // 0 for first note, 59 for last, 60 will be 1 past indicating done 

	always @(*)
	begin
		case (cState)
			START: 
			begin
				if (writeNote) nState = WRITENOTE_WAIT;
				else if (playSong) nState = PLAY_WAIT;
				else if (protectionChange) nState = PCHANGE_WAIT;
				else nState = START;
			end
			WRITENOTE_WAIT: nState = (writeNote) ? WRITENOTE_WAIT : WRITENOTE;
			WRITENOTE: nState = START;
			PLAY_WAIT: nState = (playSong) ? PLAY_WAIT : PLAY_CHECK;
			PLAY_CHECK: nState = PLAY_CHECK_WAIT;
			PLAY_CHECK_WAIT: 
			begin	
				if (opAllowed) nState = PLAY;
				else nState = PLAY_PROHIBITED;
			end
			PLAY_PROHIBITED: // same as START but now we're outputting that it's prohibited
				if (writeNote) nState = WRITENOTE_WAIT;
				else if (playSong) nState = PLAY_WAIT;
				else if (protectionChange) nState = PLAY_WAIT;
				else nState = PLAY_PROHIBITED;
			PLAY: nState = (notePlaying == 6'd60) ? START : PLAY;
			PCHANGE_WAIT: nState = (protectionChange) ? PCHANGE_WAIT : PCHANGE;
			PCHANGE: nState = START; 
		endcase
	end

	reg [9:0] address;
	reg wren;
	wire [7:0] ramOut;
	reg playen;

	always @(*) 
	begin
		opAllowed = 1'b0;
		noteValid = 1'b0; 
		prohibited = 1'b0;
		wren = 1'b0;
		playen = 1'b0;
		address = 10'd0;

		case (cState)
			WRITENOTE:
			begin
				wren = 1'b1;
				address = ((user * 3 + song) * 61) + noteOffset + 1;
			end
			PLAY_CHECK:
			begin
				address = (user * 3 + song) * 61;
			end
			PLAY_CHECK_WAIT:
				// user intervals
				// user 1: 0 - 182
				// user 2: 183 - 366
				// user 3: 367 - 549
				opAllowed = (requser == user) || (~ramOut[0]);
			PLAY_PROHIBITED: 
				prohibited = 1'b1;
			PLAY:
			begin
				noteValid = 1'b1;
				playen = 1'b1;
				address = ((user * 3 + song) * 61) + notePlaying + 1;
			end
			PCHANGE:
			begin
				wren = 1'b1;
				address = ((user * 3 + song) * 61);
			end
		endcase
	end

	always @(posedge clock) 
	begin
		if (reset)
			cState <= START;
		else
			cState <= nState;
	end

	noteCounter #(CLOCK_FREQUENCY) NC (clock, playen, notePlaying);
	ram R (address, clock, inote, wren, ramOut);
	assign onote = ramOut;
	assign currNote = notePlaying;
endmodule

module noteCounter (input clock, input enable, output [5:0] noteNum);
	parameter CLOCK_FREQUENCY = 100;

	reg [1 + $clog2(CLOCK_FREQUENCY):0] rateDiv = 0;
	reg [5:0] counter = 5'd0;

	always @(posedge clock)
	begin
		if (enable)
		begin
			if (rateDiv == ((CLOCK_FREQUENCY >> 1) - 1))
			begin
				rateDiv <= 0;
				if (counter == 60) // unnecessary i believe
					counter <= 0;
				else
					counter <= counter + 1;
			end
			else 
				rateDiv <= rateDiv + 1;
		end
		else
			counter <= 0;
	end

	assign noteNum = counter;
endmodule