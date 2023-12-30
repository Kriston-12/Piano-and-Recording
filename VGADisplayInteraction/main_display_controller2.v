module main_display_controller(
    input iResetn,
    input iLoadX,
    input [7:0] iKeyboardInput, // 8-bit input for keyboard
	input key_pressed,
    input iClock,
    output [8:0] oX,
    output [7:0] oY,
    output [2:0] oColour,
    output oPlot,
	inout wire [3:0]curr_screen,
	inout wire recording_start,
	inout wire [3:0] unit,
	inout wire [1:0] ten,
	output wire privacy,
	output wire [1:0] requser,
	output wire [1:0] song,
	output wire quarter_clk,
	input playing
    );
	
   parameter X_SCREEN_PIXELS = 9'd320;
   parameter Y_SCREEN_PIXELS = 8'd240;
   
	 wire [16:0] counter;
   wire [8:0] fs_x;
   wire [7:0] fs_y;
   wire counter_En;
	wire [2:0] screen_color;
	wire [2:0] record_color;
	wire [2:0] timer_color;
	
	
	screen_manager screen_mgr(
        .iClock(iClock),
        .iResetn(iResetn),
		.counter(counter),
		.key_pressed(key_pressed),
		.iLoadX(iLoadX),
		.recording_start(recording_start),
		.selected_user(requser),
        .iKeyboardInput(iKeyboardInput),
		.current_screen(curr_screen),
		.counter_En(counter_En),
		.oPlot(oPlot),
		.privacy(privacy),
		.quarter_clk(quarter_clk),
		.selected_recording(song)
		
        // ... other signals ...
    );
	
	screen_drawer screen_dwr(
		.iClock(iClock),
        .iResetn(iResetn),
		.curr_screen(curr_screen),
		.counter_En(counter_En),
		.color(screen_color),
		.counter(counter),
		.fs_x(fs_x),
		.fs_y(fs_y),
		.timer_color(timer_color)
	);
	
	/*
	screen_3_manager screen_3_mgr(
	
	);
	*/
	
	/*
	recording_controller recording_ctl(
		.iClock(iClock), 
		.iResetn(iResetn), 
		.key_pressed(key_pressed), 
		.iKeyboardInput(iKeyboardInput), 
		.counter_En(counter_En),
		.recording_start(recording_start),
		.color(record_color),
		.fs_x(fs_x),
		.fs_y(fs_y),
		.counter(counter)
	);
	*/
	
	timer tmr(
		.iClock(iClock),
		.iResetn(iResetn),
		.recording_start(recording_start),
		.counter(counter),
		.iKeyboardInput(iKeyboardInput),
		.color(timer_color),
		.fs_x(fs_x),
		.fs_y(fs_y),
		.unit(unit),
		.ten(ten),
		.quarter_clk(quarter_clk),
		.playing(playing)
	);
	/*
	double_buffer(
		.clk(iClock), // System clock
		.address(counter),
		// Other inputs like data input, control signals, etc.
		.vga_data(oColour) // Data to VGA, for example
	);*/
	
	
	assign oX = fs_x;
    assign oY = fs_y;
    assign oColour = screen_color;
endmodule
	
module screen_manager(
	input iClock, iResetn, iLoadX, quarter_clk,
	input [7:0] iKeyboardInput,
	input key_pressed,
	input [16:0] counter,
	output [3:0] current_screen,
	output recording_start,
	output reg [1:0] selected_user,
	output reg [1:0] selected_recording,
	output reg counter_En,
	output reg oPlot,
	output privacy
);

	// Assuming you have constants for addresses
	//localparam NAME1_ADDR = 8'hXX; // Replace XX with actual address
	//localparam NAME2_ADDR = 8'hYY; // Replace YY with actual address
	//localparam NAME3_ADDR = 8'hZZ; // Replace ZZ with actual address

	// fetch data
	reg [7:0] selected_name_addr;
	reg [7:0] selected_name_data;
	reg [7:0] selected_recording_data;
	reg [7:0] recording_data[3:0]; // Array to store data for recordings
	reg privacy_reg;
	
	localparam DRAW = 3'd0, DONE = 3'd1, WAIT_DRAW = 3'd2, START = 3'd3;
	
	reg [2:0] curr_state = DRAW, next_state;
	
	reg [3:0] curr_screen, next_screen, prev_screen;

	localparam 
		SCREEN1 = 4'd0, 
		SCREEN2 = 4'd1, 
		SCREEN3 = 4'd2, 
		WAIT_SCREEN = 4'd3, 
		WAIT_RECORDING = 4'd4, 
		BEGIN = 4'd5, 
		RECORDING_INI = 4'd6, 
		WAIT_SCREEN2 = 4'd7, 
		SCREEN4 = 4'd8, 
		WAIT_SCREEN3 = 4'd9;
	
	
	initial begin
		selected_user = 2'b00;
		selected_recording = 2'b00; // 00 means no selection
		// ... other initializations ...
	end
	
	always @(posedge iClock) begin
		if (!iResetn) begin
			selected_user <= 2'b00; // Reset on system reset
		end else begin
			if (curr_screen == SCREEN1) begin // Assuming key_pressed is a flag indicating a key press
				case (iKeyboardInput)
					8'h16: begin
						selected_user <= 2'b01;
						//selected_name_addr <= NAME1_ADDR;// '1' pressed
					end
					8'h1E: begin
						selected_user <= 2'b10; 
						//selected_name_addr <= NAME2_ADDR;// '2' pressed
					end
					8'h26: begin
						selected_user <= 2'b11;
						//selected_name_addr <= NAME3_ADDR;// '3' pressed
					end
					// Add more cases if needed
				endcase
				
				// Fetch name data
				//fetch_data_from_memory(selected_name_addr, selected_name_data);

				// Fetch recordings for the selected name
				// This assumes recordings are stored in consecutive memory locations
				//for (integer i = 0; i < 3; i = i + 1) begin
					//fetch_data_from_memory(selected_name_addr + i, recording_data[i]);
				//end
			end else if (current_screen == SCREEN2) begin // Assuming key_pressed is a flag indicating a key press
				case (iKeyboardInput)
					8'h16: selected_recording <= 2'b01; //selected_recording_data <= recording_data[1];// '1' pressed
					8'h1E: selected_recording <= 2'b10; //selected_recording_data <= recording_data[2];// '2' pressed
					8'h26: selected_recording <= 2'b11; //selected_recording_data <= recording_data[3];// '3' pressed
					// Add more cases if needed
				endcase
				// add more memory fetching or manipulation
			end else if (current_screen == SCREEN4) begin // Assuming key_pressed is a flag indicating a key press
				case (iKeyboardInput)
					8'h16: privacy_reg <= 0; //selected_recording_data <= recording_data[1];// '1' pressed
					8'h1E: privacy_reg <= 1; //selected_recording_data <= recording_data[2];// '2' pressed
					// Add more cases if needed
				endcase
				// add more memory fetching or manipulation
			end
		end
	end
		always @(*)
	begin
      case (curr_screen)
		BEGIN: begin 
			next_screen <= SCREEN1;
			prev_screen <= BEGIN;
		end
         SCREEN1: 
         begin
			if(iKeyboardInput==8'hF0) begin
				next_screen <= WAIT_SCREEN2;
				prev_screen <= SCREEN1;
			end
         end
		 WAIT_SCREEN: 
		 begin
			if(iKeyboardInput==8'hF0) begin
				next_screen <= WAIT_SCREEN2;
			end 
		 end
		 WAIT_SCREEN2:
		 begin
			if((iKeyboardInput==8'h16 || iKeyboardInput==8'h1E || iKeyboardInput==8'h26 ) && prev_screen==SCREEN1) begin
				next_screen <= SCREEN2;
			end else if((iKeyboardInput==8'h16 || iKeyboardInput==8'h1E || iKeyboardInput==8'h26 ) && prev_screen==SCREEN2) begin
				next_screen <= SCREEN4;
			end else if (iKeyboardInput==8'h25 && prev_screen == SCREEN2) begin
				next_screen <= SCREEN1;
			end else if(iKeyboardInput==8'h25 && prev_screen == SCREEN3) begin
				next_screen <= SCREEN2;
			end else if((iKeyboardInput==8'h16 || iKeyboardInput==8'h1E) && prev_screen==SCREEN4) begin
				next_screen <= SCREEN3;
			end else begin
				next_screen <= prev_screen;
			end
		 end
         SCREEN2: 
         begin
            if(iKeyboardInput==8'hF0) begin
				prev_screen <= SCREEN2;
				next_screen <= WAIT_SCREEN2;
			end 
         end
		 SCREEN4:
		 begin
            if(iKeyboardInput==8'hF0) begin
				prev_screen <= SCREEN4;
				next_screen <= WAIT_SCREEN2;
			end 
		 end
		 WAIT_SCREEN3:
		 begin
			 if((iKeyboardInput==8'h16 || iKeyboardInput==8'h1E) && prev_screen==SCREEN2) begin
				next_screen <= SCREEN3;
			end
		 end
         SCREEN3: begin
			 if(iKeyboardInput==8'hF0) begin
				next_screen <= WAIT_SCREEN2;
				prev_screen <= SCREEN3;
			end else if(iLoadX) begin
				next_screen <= WAIT_RECORDING;
				prev_screen <= SCREEN3;
			end 
		 end 
		 WAIT_RECORDING: begin
			if (!iLoadX) begin
				if(prev_screen==SCREEN3)
					next_screen <= RECORDING_INI;
				else
					next_screen<= SCREEN3;
			end
		 end
		 RECORDING_INI: begin
			if(iLoadX) begin
				next_screen <= WAIT_RECORDING;
				prev_screen <= RECORDING_INI;
			end
		 end
         default: next_screen <= BEGIN;
      endcase
	end
	
   always @(*)
   begin
      case (curr_state)
         START: next_state = WAIT_DRAW;
         WAIT_DRAW: begin
			if(iKeyboardInput==8'hF0 || !iLoadX || (curr_screen==RECORDING_INI)) begin
				next_state = DRAW;
			end
         end
         DRAW: next_state = (counter == 17'b10010101111111111) ? DONE: DRAW;
         DONE: 
         begin
            next_state = WAIT_DRAW;
         end
         default: next_state = START;
      endcase
   end
	
	always @(posedge iClock) begin
		if (!iResetn) begin
			// Reset logic
			curr_screen<= BEGIN;
			// ... other reset logic ...
		end
		else begin

			// Change screen based on the updated state
			curr_screen <= next_screen;
				// Call function to change to the new screen
				// Example: display_screen(current_screen);
		end
	end
	
	always @(*)
	   begin
		  counter_En = 1'b0;
		  oPlot = 1'b0;

		  case (curr_state)
			 DRAW:
			 begin
				counter_En = 1'b1;
				oPlot = 1'b1;
			 end
			 DONE: oPlot = 1'b0;
		  endcase
	   end
	   

	
	assign current_screen = curr_screen[3:0];
	assign recording_start = (curr_screen == RECORDING_INI) ? 1:0;
	assign privacy = privacy_reg;
endmodule

module screen_drawer(
	input iClock, iResetn, counter_En,
    input [1:0] selected_user, // Passed from the main controller
	input [3:0] curr_screen,
    output reg [2:0] color,
	output [8:0] oX,
	output [7:0] oY,
    output reg [9:0] fs_x,
	output reg [8:0] fs_y,
	output reg [16:0] counter = 17'b0,
	input timer_color
);

	parameter X_SCREEN_PIXELS = 9'd320;
    parameter Y_SCREEN_PIXELS = 8'd240;
	
	localparam 
		SCREEN1 = 4'd0, 
		SCREEN2 = 4'd1, 
		SCREEN3 = 4'd2, 
		WAIT_SCREEN = 4'd3, 
		WAIT_RECORDING = 4'd4, 
		BEGIN = 4'd5, 
		RECORDING_INI = 4'd6, 
		WAIT_SCREEN2 = 4'd7, 
		SCREEN4 = 4'd8, 
		WAIT_SCREEN3 = 4'd9;
		
	localparam WHITE = 3'd111, BLACK = 3'd000;
	
	wire color1;
	wire color2;
	wire color3;
	wire color4;
	
	screen1 s1(counter, iClock, color1);
	screen2 s2(counter, iClock, color2);
	screen3 s3(counter, iClock, color3);
	screen4 s4(counter, iClock, color4);
	
	always @(posedge iClock) begin
		if (!iResetn) begin
			color <= 0;
			
			// ... other reset logic ...
		end else begin
			case (curr_screen)
				SCREEN1: begin
					color <= (color1) ? WHITE:BLACK;
				end
				SCREEN2: begin
					color <= (color2) ? WHITE:BLACK;
				end
				SCREEN3: begin
					color <= (color3) ? WHITE:BLACK;
				end
				SCREEN4: begin
					color <= (color4) ? WHITE:BLACK;
				end
				RECORDING_INI: begin
					color <= (color3) ? WHITE:BLACK;
				end
			endcase
		end
	end
	
	always @(posedge iClock)
	   begin
		  if (iResetn == 0)
		  begin
				counter <= 17'b0;
			 fs_x <= 0;
			 fs_y <= 0;
		  end
		  else begin
		    if (counter_En) begin
				if (counter == 17'b10010101111111111)
				   counter <= 17'b0;
				else
				   counter <= counter + 1;
				if (fs_x == X_SCREEN_PIXELS - 1)
				begin
				   fs_x <= 0;
				   if (fs_y == Y_SCREEN_PIXELS - 1)
					  fs_y <= 0;
				   else
					  fs_y <= fs_y + 1;
				end
				else
				   fs_x <= fs_x + 1;
				end
			end
	   end
	   
	//assign oX = fs_x;
    //assign oY = fs_y;
    //assign oColour = color;
endmodule
/*
module recording_controller(
	input iClock, iResetn, key_pressed, counter_En,
	input recording_start,
	input [7:0] iKeyboardInput,
    output reg [2:0] color,
    input [9:0] fs_x,
	input [8:0] fs_y,
	input [16:0] counter
);	

   parameter X_SCREEN_PIXELS = 9'd320;
   parameter Y_SCREEN_PIXELS = 8'd240;
   
	wire [4:0] pitch;
	reg [3:0] k, q; // Changed from integer to reg for synthesis compatibility
	wire pixel;
	reg drawing2; // Flag to indicate if we're currently drawing a character
    reg [8:0] charXchar = 50; // X coordinate for character display
    reg [7:0] charYchar = 120; // Y coordinate for character display

	always @(posedge iClock) begin
		if (!iResetn) begin
			// Reset logic here
			k <= 0;
			q <= 0;
			drawing2 <= 0;
		end
		else if (key_pressed && !drawing2 && recording_start) begin
			// Start drawing a character
			drawing2 <= 1;
			k <= 0;
			q <= 0;
		end
		else if (drawing2) begin
			// Draw the character pixel by pixel
			if(fs_x == charXchar+q && fs_y == charYchar + k - pitch*4) color <= 3'd111;

			// Move to next pixel
			q <= q + 1;
			if (q == 3) begin
				q <= 0;
				k <= k + 1;
				if (k == 3) begin
					drawing2 <= 0; // Done drawing the character
				end
			end
		end
	end
	key_to_pitch ktp(.clk(iClock), .reset(iResetn), .ps2_code(iKeyboardInput), .pitch(pitch));
endmodule
*/

module timer(
	input iClock, iResetn,
	input recording_start,
    output wire [2:0] color,
    input [8:0] fs_x,
	input [7:0] fs_y,
	input [16:0] counter,
	input [7:0] iKeyboardInput,
	output reg [3:0] unit,
	output reg [1:0] ten,
	output reg quarter_clk,
	input playing
);
	localparam ONE_SECOND_COUNT = 50000000;
	reg [31:0] cycle_counter;
	reg [29:0] quarter_counter;
	reg [4:0] second_counter;
	reg done;
	reg buffer_switch;
	//reg unitdone;
	
	//reg [3:0] i, j; // Changed from integer to reg for synthesis compatibility
	reg [2:0] tColor;
	//wire pixel, tenpixel;

	//reg drawing; // Flag to indicate if we're currently drawing a character
    reg [8:0] charX = 100; // X coordinate for character display
    reg [7:0] charY = 200; // Y coordinate for character display
    reg [8:0] charXten = 80; // X coordinate for character display
    reg [7:0] charYten = 200; // Y coordinate for character display
	
	
	wire [4:0] pitch;
	reg [3:0] k, q; // Changed from integer to reg for synthesis compatibility
	reg drawing2; // Flag to indicate if we're currently drawing a character
    reg [8:0] charXchar = 47; // X coordinate for character display
    reg [7:0] charYchar = 120; // Y coordinate for character display
	wire q1, q2;
	
	
	
	always @ (posedge iClock)
	begin
		if(!recording_start && !playing)
		begin
			cycle_counter<= 0;
			quarter_counter<=0;
			second_counter<=1;
			ten <= 0;
			unit <= 0;
			done<=0;
			buffer_switch <=0;
			quarter_clk <=0;
		end else if(!done && (recording_start||playing)) begin
			if(quarter_counter< ONE_SECOND_COUNT/4 - 1) begin
				quarter_counter<=quarter_counter+1;
				if(quarter_counter< ONE_SECOND_COUNT/8 - 1) begin
					quarter_clk <= 1;
				end else begin
					quarter_clk <= 0;
				end
			end else begin
				quarter_counter <=0;
				buffer_switch <= ~buffer_switch;
			end
		
			if(cycle_counter< ONE_SECOND_COUNT-1) begin
				cycle_counter <= cycle_counter+1;
			end else begin
				cycle_counter<=0;
				if(second_counter<31) begin
					second_counter<= second_counter+1;
					unit <= second_counter%10;
					ten <= second_counter /10;
				end
				if(second_counter==31) begin
					done<=1;
				end
			end
		end
	end
	
	always @(posedge iClock) begin
		if (!iResetn) begin
			// Reset logic here
			//i <= 0;
			//j <= 0;
			//drawing <= 0;
			k <= 0;
			q <= 0;
			drawing2 <= 0;
			charXchar <= 50;
		end
		else if (!drawing2 && recording_start) begin
			// Start drawing a character
			//drawing <= 1;
			//i <= 0;
			//j <= 0;
			drawing2 <= 1;
			k <= 0;
			q <= 0;
			charXchar <= charXchar + 3;
		end
		else if (drawing2) begin
			// Draw the character pixel by pixel
			//if(fs_x == charX+j && fs_y == charY + i) tColor <= pixel;
			//if(fs_x == charXten+j && fs_y == charYten + i) tColor <= tenpixel;
			if(fs_x == charXchar+q && fs_y == charYchar + k - pitch*4) tColor <= 3'b111;
			else tColor <= (buffer_switch == 0 ? (q2? 3'b111: 3'b000)  : (q1? 3'b111: 3'b000));
			// Move to next pixel
			//j <= j + 1;
			//if (j == 12) begin
			//	j <= 0;
			//	i <= i + 1;
			//	if (i == 12) begin
			//		drawing <= 0; // Done drawing the character
			//	end
			//end
			
			q <= q + 1;
			if (q == 3) begin
				q <= 0;
				k <= k + 1;
				if (k == 3) begin
					drawing2 <= 0; // Done drawing the character
				end
			end
		end
	end
	
	
	key_to_pitch ktp(.clk(iClock), .reset(iResetn), .ps2_code(iKeyboardInput), .pitch(pitch));
	
	// Instance of note_bitmap
	/*
	note_bitmap key_char_gen (
		.ascii_code(unit+48),
		.row(i), // Current row
		.col(j), // Current column
		.pixel(pixel) // Pixel value at (row, col)
	);
	*/
	
	/*
	note_bitmap key_char_gen_ten (
		.ascii_code(ten+48),
		.row(i), // Current row
		.col(j), // Current column
		.pixel(tenpixel) // Pixel value at (row, col)
	);
	*/
	
	/*
	ram1 ram1_inst (
    .clock(iClock),
    .address(counter),
    .data(tColor),
    .wren(buffer_switch == 0 ? 1 : 0),
	.q(q1)
    // ... other connections as necessary
);

ram2 ram2_inst (
    .clock(iClock),
    .address(counter),
    .data(tColor),
    .wren(buffer_switch == 1 ? 1 : 0), // Write only if active
	.q(q2)
    // ... other connections as necessary
);
assign color = (buffer_switch == 0 ? (q2? 3'b111: 3'b000)  : (q1? 3'b111: 3'b000));
*/
endmodule

module double_buffer_controller(
    input clk,
    input reset,
    input buffer_switch,     // Signal to switch buffers
    input [16:0] address, // Common address line
    input write_data,        // 1-bit write data
    output [2:0]read_data         // 1-bit read data
);

// Internal signals
reg [16:0] write_address;
reg active_buffer = 0;      // 0 for ram1, 1 for ram2
reg write_enable = 0;       // Enable write operation
wire q1, q2;

// Instantiate RAM modules
ram1 ram1_inst (
    .clock(clk),
    .address(write_address),
    .data(write_data),
    .wren(active_buffer == 0 ? write_enable : 0),
	.q(q1)
    // ... other connections as necessary
);

ram2 ram2_inst (
    .clock(clk),
    .address(write_address),
    .data(write_data),
    .wren(active_buffer == 1 ? write_enable : 0), // Write only if active
	.q(q2)
    // ... other connections as necessary
);

// Logic for double buffering
always @(posedge clk) begin
    if (!reset) begin
        write_address <= 0;
        active_buffer <= 0;
        write_enable <= 0;
    end else begin
           active_buffer <= ~buffer_switch; // Switch buffers

        // Logic to handle write_address and write_enable
        // ...

        // Example: Write input data to current write address
        write_enable <= 1;
        write_address <= address;
		
    end
end

// Read data (assuming immediate read after write for simplicity)
assign read_data = (active_buffer == 0 ? (q2? 3'b111: 3'b000)  : (q1? 3'b111: 3'b000));

endmodule
