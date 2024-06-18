/*
    Module Name: executeMem
    Description:
        This module represents the Execute-Memory stage in a pipelined processor.
        It takes various inputs related to the execution stage and provides outputs 
        that will be used in the memory stage. It handles control signals for branching,
        memory reads and writes, as well as forwarding data for the next stages.

    Inputs:
        - clk: Clock signal for synchronous operation.
        - reset: Reset signal to initialize the module.
        - zero: Flag indicating whether the result of the ALU operation is zero.
        - writeBack: Write-back control signals (2 bits).
        - mem: Memory control signals (3 bits).
        - pcAdder: Program Counter value for the current instruction.
        - aluOutput: Result of the ALU operation.
        - rd2: Value of register rd2 (second operand).
        - instr: Current instruction.

    Outputs:
        - branch: Signal indicating whether a branch instruction is being executed.
        - memRead: Signal indicating whether a memory read operation is being performed.
        - memWrite: Signal indicating whether a memory write operation is being performed.
        - zeroOut: Output of the zero flag to be used in the next stage.
        - wbOut: Write-back control signals forwarded to the next stage.
        - pcAdderOut: Program Counter value forwarded to the next stage.
        - alu: Result of the ALU operation forwarded to the next stage.
        - rd2Out: Value of register rd2 forwarded to the next stage.
        - instrOut: Current instruction forwarded to the next stage.
*/

module EX_MEM (
    input logic clk, reset, zero,
    input logic [1:0] writeBack,
    input logic [2:0] mem,
    input logic [31:0] pcAdder,
    input logic [31:0] aluOutput,
    input logic [31:0] rd2,
    input logic [31:0] instr,
    
    output logic branch, memRead, memWrite, zeroOut,
    output logic [1:0] wbOut,
    output logic [31:0] pcAdderOut,
    output logic [31:0] alu,
    output logic [31:0] rd2Out,
    output logic [31:0] instrOut
);

    always_ff @(posedge clk) begin
        if (reset) begin
            // Initialize outputs to default values on reset.
            branch <= 1'b0;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            zeroOut <= 1'b0;
            wbOut <= 2'b0;
            pcAdderOut <= 32'b0;
            alu <= 32'b0;
            rd2Out <= 32'b0;
            instrOut <= 32'b0;
        end
        else begin
            // Update outputs with current input values.
            branch <= mem[0];
            memWrite <= mem[1];
            memRead <= mem[2];
            zeroOut <= zero;
            wbOut <= writeBack;
            pcAdderOut <= pcAdder;
            alu <= aluOutput;
            rd2Out <= rd2;
            instrOut <= instr;
        end    
    end
    
endmodule