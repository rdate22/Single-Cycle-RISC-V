module PCincrement (
	input logic [31:0] currPc 
	, output logic [31:0] nextPc
	);
	
	assign nextPc = currPc + 32'h00000001; //Increments PC by 1 and assigns it to nextPc
	
endmodule
	
	