module cpu_top #(parameter width=32) (
	input clk
	, input reset
	, output logic ending
);

	logic branch, memRead, memtoReg, memWrite, aluSrc, regWrite;
	logic [1:0] aluOp;
	logic [width-1:0] pc_result;
	

	topMux pc (.pcPlus4(leftmost_out), .branchAddr(Branch_out), .middle_out, .pcut(pc_result));
	logic [width-1:0] instr;
	
	Instr_memory i_m_unit (.addr(pc_result), .instr);
	
	logic [width-1:0] leftmost_out, middle_out;
	
	adder leftmost (.a(1), .b(pc_result), .c(leftmost_out));
	adder middle (.a(pc_result), .b(bottom_mux_out), .c(middle_out));
	
	logic [2:0] funct3;
	logic [6:0] funct7;
	logic [6:0] opcode;
	
	always_comb begin
		funct3 <= instr[14:12];
		funct7 <= instr[31:25];
		opcode <= instr[6:0];
	end
	
	control controller (.*);
	
	
	logic [width-1:0] write_data, read_data1, read_data2;
	
	register_file reg_files (.clk, .read_reg1(instr[19:15]), .read_reg2(instr[24:20]), .write_reg(instr[11:7]), .write_data, .write_enable(RegWrite), .read_data1, .read_data2);
	

	logic [width-1:0] bottom_mux_out;
	
	reg_imm_mux bottom_mux (.reg2Input(read_data2), .imm(instr), .ALUSrc, .result(bottom_mux_out));
	

	logic [width-1:0] alu_out;
	logic zero_flag;
	
	ALU al_unit (.in1(read_data1), .in2(bottom_mux_out), .opcode(ALUOp), .result(alu_out), .zero_flag);
	

	logic [width-1:0] data_mem_out;

	data_memory d_m_unit (.clk, .reset, .MemWrite, .MemRead, .address(alu_out), .write_data(read_data2), .read_data(data_mem_out));
	

	logic [width-1:0] middle_mux_out;
	
	mux2_1 middle_mux (.in1(data_mem_out), .in2(alu_out), .enable(ALUSrc), .out(middle_mux_out));
	
	logic Branch_out;
	branch branch_jump (.zero_flag, .Branch, .Branch_out);
	
	
endmodule
	
	
	
	
module cpu_top_testbench();
	logic clk, reset;
	logic valid;
	logic ending;
	
	cpu_top dut (.*);
	
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 0;								@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
		reset <= 1;								@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
		reset <= 0;								@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
		reset <= 1;								@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
		$stop;
	end
	
endmodule
	
	
	
	
	
	