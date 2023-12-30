module key_to_pitch (
    input clk,
    input reset,
    input [7:0] ps2_code,
    output reg [4:0] pitch
);

always @(posedge clk) begin
    if (!reset) begin
        pitch <= 8'h00; // Reset ASCII code
    end
    else begin
		case (ps2_code)
			8'h1C: pitch <= 8; // 'a'
			8'h32: pitch <= 5; // 'b'
			8'h21: pitch <= 3; // 'c'
			8'h23: pitch <= 10; // 'd'
			8'h24: pitch <= 17; // 'e'
			8'h2B: pitch <= 11; // 'f'
			8'h34: pitch <= 12; // 'g'
			8'h33: pitch <= 13; // 'h'
			8'h3B: pitch <= 14; // 'j'
			8'h3A: pitch <= 7; // 'm'
			8'h31: pitch <= 6; // 'n'
			8'h15: pitch <= 15; // 'q'
			8'h2D: pitch <= 18; // 'r'
			8'h1B: pitch <= 9; // 's'
			8'h2C: pitch <= 19; // 't'
			8'h3C: pitch <= 21; // 'u'
			8'h2A: pitch <= 4; // 'v'
			8'h1D: pitch <= 16; // 'w'
			8'h22: pitch <= 2; // 'x'
			8'h35: pitch <= 20; // 'y'
			8'h1A: pitch <= 1; // 'z'
			default: pitch <= 0; // No valid key or other keys
		endcase
    end
end

endmodule
