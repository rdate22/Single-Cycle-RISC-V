module alu (
	, input logic [31:0] op1 ,op2
	, input logic [3:0] control
	, output logic [31:0] aluResult
	, output logic zero
	);
	
 
	always_comb begin
		case(control) 
			4'b0000: aluOut <= op1 + op2;
            4'b0001: aluOut <= op1 - op2;
            4'b0010: aluOut <= op1 << op2;
            4'b0011: aluOut <= $signed(op1) < $signed(op2);
            4'b0100: aluOut <= op1 < op2;
            4'b0101: aluOut <= op1 ^ op2;
            4'b0110: aluOut <= $signed(op1) >>> op2;
            4'b0111: aluOut <= op1 >> op2;
            4'b1000: aluOut <= op1 | op2;
            4'b1001: aluOut <= op1 & op2;
            4'b1010: aluOut <= op1 == op2;
            4'b1011: aluOut <= op1 != op2;
            4'b1100: aluOut <= $signed(op1) >= $signed(op2);
            4'b1101: aluOut <= op1 >= op2;
			default: result <= 32'b0; //default case when alu is not being used
		endcase	
		
		
	end
	
	assign zero = ~|aluResult;
endmodule
			