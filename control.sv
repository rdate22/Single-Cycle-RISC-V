//Control module from figure 4.2
module control (
	input logic [6:0] opcode
	, input logic [2:0] funct3
	, input logic [6:0] funct7
	, output logic branch
	, output logic memRead
	, output logic memtoReg
	, output logic [3:0] aluOp
	, output logic memWrite
	, output logic aluSrc
	, output logic regWrite
	);
	
	//This block is seperated in logical sections, one section for all R-type commands,
	//one for I-type commands, one for S-type commands, and one for J-type commands
	always_comb begin
		case(opcode)
			//assigns each control output 1 bit which is auto set to 0
			//0 = off and 1 = on
			//aluOp has 4 bits since my alu needs 4 bits for each instruction
			branch = 1'b0;
			memRead = 1'b0;
			memtoReg = 1'b0;
			aluOp = 4'b0000;
			memWrite = 1'b0;
			aluSrc = 1'b0;
			regWrite = 1'b0;
			
			// R type
			7'b0110011: begin
				RegWrite = 1'b1;
				case(funct3)
					0x0: 
						case(funct7)
							0x00: aluOp = 4'b0000; //add
							
							0x20: aluOp = 4'b0001; //sub
						endcase
					0x4: aluOp = 4'b0101; //xor
					0x6: aluOp = 4'b1000; //or
					0x7: aluOp = 4'b1001; //and
					0x1: aluOp = 4'b0010; //sll
					0x5:
						case(funct7)
							0x00: 4'b0111; //shift logical right
							0x20: 4'b0110; //shift right arithmetic
					0x2: 4'b0100 //stl
					0x3: 4'b0011 //stlu
				endcase
			end
			
			
			// I type
			7'b0010011, 7'b0000011, 7'b1100111, 7'b1110011: begin
				MemRead = 1'b1;
				MemtoReg = 1'b1;
				aluSrc = 1'b1;
				RegWrite = 1'b1;
				
				case(funct3)
					0x0: aluOp = 4'b0000; //addi
				endcase
			end
			
			// S type
			7'b0100011: begin	
				// MemtoReg = 1'b0; // doesn't matter
				// ALUOp = 2'b00;
				MemWrite = 1'b1;
				ALUSrc = 1'b1;
				
				// base on the funct3, we find out what alu operation do we need
				case(funct3)
					
				endcase
			end
			
			// B type
			7'b1100011: begin
				Branch = 1'b0;
				// MemtoReg = 1'b0; // doesn't matter
				// ALUOp = 2'b00;
			
				// base on the funct3, we find out what alu operation do we need
				case(funct3)
					
				endcase
			end
		endcase
	end
endmodule	