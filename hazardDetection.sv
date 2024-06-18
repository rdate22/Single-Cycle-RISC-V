/*
This module is a hazard detection unit for a pipeline CPU. It identifies hazards between instructions in the pipeline and controls signals accordingly to resolve these hazards. The primary purpose is to ensure correct data dependencies and control flow within the CPU pipeline.

The inputs to this module are:
- IFID_instr: Instruction in the instruction fetch/decode stage.
- IDEX_instr: Instruction in the instruction decode/execute stage.
- IDEX_M: Control signals related to memory access in the execute/memory stage.

The outputs from this module are:
- select_mux: Selects the appropriate input for the multiplexer in the pipeline.
- PCWrite: Controls whether the Program Counter should be written to.
- IFID_write: Controls whether the instruction in the instruction fetch/decode stage should be written to.

The internal signals used are:
- IDEX_MemRead: Indicates whether memory is being read in the execute/memory stage.
- IFID_rs1: Extracted register destination from the instruction in the instruction fetch/decode stage.
- IFID_rs2: Extracted register source from the instruction in the instruction fetch/decode stage.
- IDEX_rd: Extracted register destination from the instruction in the instruction decode/execute stage.

The hazard detection logic operates as follows:
- It extracts register sources and destinations from instructions and control signals.
- If there is a hazard (i.e., a read after write hazard), where an instruction in the execute/memory stage is trying to read from a register that is being written to by a previous instruction, it sets select_mux, PCWrite, and IFID_write to 0 to stall the pipeline until the hazard is resolved.
- Otherwise, it allows normal operation by setting select_mux, PCWrite, and IFID_write to 1.

This module is essential for maintaining correct execution order and data dependencies in the pipeline CPU, ensuring instructions are executed in the correct sequence without conflicts.
*/

module hazardDetection #(parameter addrWidth=32) (
    input logic [addrWidth-1:0] ifidInstr,
    input logic [addrWidth-1:0] idexInstr,
    input logic [2:0] idexM,
    output logic selectMux,
    output logic pcWrite,
    output logic ifidWrite
);

    logic idexMemRead;
    logic [4:0] ifidRs1;
    logic [4:0] ifidRs2;
    logic [4:0] idexRd;
    
    always_comb begin
        // Extract relevant parts from instructions and control signals
        ifidRs1 = ifidInstr[19:15];
        ifidRs2 = ifidInstr[24:20];
        idexMemRead = idexM[2];
        idexRd = idexInstr[11:7];
        
        // Hazard detection logic
        if (idexMemRead && ((idexRd == ifidRs1) || (idexRd == ifidRs2))) begin
            // Stall pipeline if hazard detected
            selectMux = 1'b0;
            pcWrite = 1'b0;
            ifidWrite = 1'b0;
        end else begin 
            // Allow normal operation if no hazard detected
            selectMux = 1'b1;
            pcWrite = 1'b1;
            ifidWrite = 1'b1;
        end
    end
endmodule

module hazardDetectionUnitTestBench();

    logic [31:0] ifidInstr, idexInstr;
    logic [2:0] idexM;
    logic selectMux, pcWrite, ifidWrite;
    
    hazardDetectionUnit dut (.*);
    
    parameter clockPeriod = 100;
    logic clk;
    
    initial begin
        clk = 0;
        forever #(clockPeriod/2) clk = ~clk;
    end
    
    initial begin
        ifidInstr = 32'h1; idexInstr = 32'h2; idexM = 3'b111; @(posedge clk);
        @(posedge clk);
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