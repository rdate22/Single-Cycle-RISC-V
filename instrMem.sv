module instrMemory (
	input logic [31:0] addr
	, output logic [31:0] instr
	);
	
	reg [31:0] hw1_data [0:40];
	//reg [addr_width-1:0] hw2_data [0:40];

	initial begin
		$readmemb("hw1_instr.txt", hw1_data);
		// $readmemb("hw2_instr", hw2_data);
	end
	
	assign instr = hw1_data[addr];

endmodule