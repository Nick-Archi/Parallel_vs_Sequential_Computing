// ECE 5367
// Author: Nicholas Archibong
/*
	Description: Simulation of matrix multiplication without parallel computing
		* Each computation of a 2x2 matrix multiplication is broken up into
		* steps that an ideal computer would take to compute the resulting 
		* matrix. 
	
*/

module matrix2x2(a, b, clk, rst, res);

	/*
	 * a & b, 32bit number that for every 8bit is a number for a total of 4 numbers 
	 * clk, clock for computation time
	 * rst, reset signal
	*/
	input[31:0] a, b;
	input clk, rst;
	
	// res, 32bit register that holds the computation of the 2x2 matrix multi
	output reg res;
		
	/*
	 * state, moves through 4 states
	 * flag, signals when the computation is done
	 * a1, b1 & res1, essentially a 2x2 matrix where each element is 8bits
	*/ 
	reg[7:0] a1[0:1][0:1], b1[0:1][0:1];
	reg [7:0] res1[0:1][0:1];	
	reg[3:0] state;
	reg flag;
	
	// indicators for state position	
	parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3, s4 = 4, s5 = 5, s6 = 6, s7 = 7, s8 = 8, s9 = 9;
	
	always@(posedge clk) begin
		if(rst == 0) begin
			state <= 0;
			flag <= 0;
			res <= 32'b0;
			{a1[0][0], a1[0][1], a1[1][0], a1[1][1]} = 0;
			{b1[0][0], b1[0][1], b1[1][0], b1[1][1]} = 0;
			{res1[0][0], res1[0][1], res1[1][0], res1[1][1]} = 0;			
		end
		
		else begin
			case(state)
			
			s0: begin
				{a1[0][0], a1[0][1], a1[1][0], a1[1][1]} = a;
				{b1[0][0], b1[0][1], b1[1][0], b1[1][1]} = b;
				state <= s1;			
			end
			
			s1: begin
				res1[0][0] <= a1[0][0] * b1[0][0]; // (1,1)
				state <= s2;
			end
			
			s2: begin
				res1[0][0] <= res1[0][0] + (a1[0][1] * b1[1][0]); // (1,1)
				state <= s3;
			end
			
			s3: begin
				res1[0][1] <= a1[0][0] * b1[0][1]; // (1,2)
				state <= s4;
			end
			
			s4: begin
				res1[0][1] <= res1[0][1] + (a1[0][1] * b1[1][1]); // (1,2)
				state <= s5;
			end
			
			s5: begin
				res1[1][0] <= a1[1][0] * b1[0][0]; // (2,1)
				state <= s6;
			end
			
			s6: begin
				res1[1][0] <= res1[1][0] + (a1[1][1] * b1[1][0]); // (2,1)
				state <= s7;
			end
			
			s7: begin
				res1[1][1] <= a1[1][0] * b1[0][1]; // (2,2)
				state <= s8;
			end
			
			s8: begin
				res1[1][1] <= res1[1][1] + (a1[1][1] * b1[1][1]); // (2,2)
				state <= s9;
			end
			
			s9: begin
				flag <= 1;
				res <= {res1[0][0], res1[0][1], res1[1][0], res1[1][1]}; // combining of results
			end
			
			default: begin
			state <= 0;
			flag <= 0;
			res <= 32'b0;
			{a1[0][0], a1[0][1], a1[1][0], a1[1][1]} = 0;
			{b1[0][0], b1[0][1], b1[1][0], b1[1][1]} = 0;
			{res1[0][0], res1[0][1], res1[1][0], res1[1][1]} = 0;	
			end
			
			endcase
		end
		
	end


endmodule