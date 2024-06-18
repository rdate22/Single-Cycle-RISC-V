module bottomMux (
    input logic [31:0] regInput,  
    input logic [31:0] imm, 
    input logic ALUsrc, // bottom mux enable        
    output logic [31:0] result
);

	 always_comb begin
		case(opcode)

			// R type
			7'b0110011: result <= reg2Input;
			
			// I type
			7'b0010011, 7'b0000011, 7'b1100111, 7'b1110011: result <= imm[31:20];

			// S type
			7'b0100011:	result <= {imm[11:7], imm[31:25]};

			// B type
			7'b1100011: result <= {1'b0, imm[11:8], imm[30:25], imm[7], imm[31]};

		endcase
	end
endmodule