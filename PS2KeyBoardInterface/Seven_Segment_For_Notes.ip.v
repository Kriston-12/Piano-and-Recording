`default_nettype none

module hexdisplay (
	hex_number,

	hexDisp1,
	hexDisp2,
);

input wire		[7:0]	hex_number;

// Bidirectional

// Outputs
output wire	[6:0]	hexDisp1;
output wire [6:0] hexDisp2;

 			// 21: delay = C3;   // 15 Q
            // 29: delay = D3;   // 1D W
            // 36: delay = E3;   // 24 E
            // 45: delay = F3;   // 2D R
            // 44: delay = G3; // 2C T
            // 53: delay = A3; // 35 Y
            // 60: delay = B3; // 3C U
            // 28: delay = C4; // 1C A
            // 27: delay = D4; // 1B S
            // 35: delay = E4; // 23 D
            // 43: delay = F4; // 2B F
            // 52: delay = G4; // 34 G
            // 51: delay = A4; // 33 H
            // 59: delay = B4; // 3B J
            // 26: delay = C5; // 1A Z
            // 34: delay = D5; // 22 X
            // 33: delay = E5; // 21 C
            // 42: delay = F5; // 2A V
            // 50: delay = G5; // 32 B
            // 49: delay = A5; // 32 N
            // 58: delay = B5; // 3A M


assign hexDisp1 =  // for hex0
		({7{(hex_number == 21)}} & 7'b0110000) |   // 3
		({7{(hex_number == 29)}} & 7'b0110000) |   // 3
		({7{(hex_number == 36)}} & 7'b0110000) | // 3
		({7{(hex_number == 45)}} & 7'b0110000) | // 3
		({7{(hex_number == 44)}} & 7'b0110000) | // 3
		({7{(hex_number == 53)}} & 7'b0110000) | // 
		({7{(hex_number == 60)}} & 7'b0110000) |
		({7{(hex_number == 28)}} & 7'b0011001) |
		({7{(hex_number == 27)}} & 7'b0011001) |
		({7{(hex_number == 35)}} & 7'b0011001) |
		({7{(hex_number == 43)}} & 7'b0011001) |
		({7{(hex_number == 52)}} & 7'b0011001) |
		({7{(hex_number == 51)}} & 7'b0011001) |
		({7{(hex_number == 59)}} & 7'b0011001) |
		({7{(hex_number == 26)}} & 7'b0010010) |
		({7{(hex_number == 34)}} & 7'b0010010) |
		({7{(hex_number == 33)}} & 7'b0010010) |
		({7{(hex_number == 42)}} & 7'b0010010) |
		({7{(hex_number == 50)}} & 7'b0010010) |
		({7{(hex_number == 49)}} & 7'b0010010) |
		({7{(hex_number == 58)}} & 7'b0010010); 

		// 21: delay = C3;   // 15 Q
            // 29: delay = D3;   // 1D W
            // 36: delay = E3;   // 24 E
            // 45: delay = F3;   // 2D R
            // 44: delay = G3; // 2C T
            // 53: delay = A3; // 35 Y
            // 60: delay = B3; // 3C U
            // 28: delay = C4; // 1C A
            // 27: delay = D4; // 1B S
            // 35: delay = E4; // 23 D
            // 43: delay = F4; // 2B F
            // 52: delay = G4; // 34 G
            // 51: delay = A4; // 33 H
            // 59: delay = B4; // 3B J
            // 26: delay = C5; // 1A Z
            // 34: delay = D5; // 22 X
            // 33: delay = E5; // 21 C
            // 42: delay = F5; // 2A V
            // 50: delay = G5; // 32 B
            // 49: delay = A5; // 32 N
            // 58: delay = B5; // 3A M

assign hexDisp2 = 
		({7{(hex_number == 21)}} & 7'b1000110) |  //C
		({7{(hex_number == 29)}} & 7'b0100001) |  //D
		({7{(hex_number == 36)}} & 7'b0000110) |  //E
		({7{(hex_number == 45)}} & 7'b0001110) | // F
		({7{(hex_number == 44)}} & 7'b0010000) | // g
		({7{(hex_number == 53)}} & 7'b0001000) | // A
		({7{(hex_number == 60)}} & 7'b0000011) | // B 
		({7{(hex_number == 28)}} & 7'b0000110) | // C
		({7{(hex_number == 27)}} & 7'b0100001) | // D
		({7{(hex_number == 35)}} & 7'b0000110) | // E
		({7{(hex_number == 43)}} & 7'b0001110) | // F
		({7{(hex_number == 52)}} & 7'b0010000) | // g
		({7{(hex_number == 51)}} & 7'b0001000) |  // a
		({7{(hex_number == 59)}} & 7'b0000011) | // b
		({7{(hex_number == 26)}} & 7'b0000110) | // c
		({7{(hex_number == 34)}} & 7'b0100001) | 
		({7{(hex_number == 33)}} & 7'b0000110) |  // e
		({7{(hex_number == 42)}} & 7'b0001110) |
		({7{(hex_number == 50)}} & 7'b0010000) |  //g
		({7{(hex_number == 49)}} & 7'b0001000) |
		({7{(hex_number == 58)}} & 7'b0000011); 

endmodule

