// This module represents the Memory/Write-Back (MEM_WB) stage in a pipelined CPU. It handles forwarding control signals and data to the Write-Back stage.
// Control signals are derived from the control unit's output and are forwarded to the next stage, influencing register write and memory write operations.
// The module also forwards relevant data like read data from memory (read_data), ALU result, and the instruction to the Write-Back stage.
// Control signals are specified according to the figure on page 567 and its description on page 568.

module memWb #(parameter width=32) (
    input logic clk, reset,               // Clock and reset signals
    input logic [1:0] WB,                 // Control signals for Write-Back stage
    input logic [width-1:0] readData,     // Data read from memory
    input logic [width-1:0] aluResult,    // Result from ALU operation
    input logic [width-1:0] instruction,  // Instruction value
    
    output logic regWriteOut,             // Control signal indicating register write operation
    output logic memToRegOut,             // Control signal indicating memory to register operation
    output logic [width-1:0] readDataOut, // Forwarded data read from memory
    output logic [width-1:0] aluResultOut, // Forwarded ALU result
    output logic [width-1:0] instructionOut // Forwarded instruction value
    );
    
    always_ff @(posedge clk) begin
        if (reset) begin
            regWriteOut <= 0;
            memToRegOut <= 0;
            readDataOut <= 0;
            aluResultOut <= 0;
            instructionOut <= 0;
        end
        else begin
            regWriteOut <= WB[0];
            memToRegOut <= WB[1];
            readDataOut <= readData;
            aluResultOut <= aluResult;
            instructionOut <= instruction;
        end
    }

endmodule

module memWbTestBench();
    logic clk, reset, regWriteOut, memToRegOut;
    logic [1:0] WB;
    logic [31:0] readData, aluResult, instruction, readDataOut, aluResultOut, instructionOut;

    memWbModule dut (.*);
    
    parameter clockPeriod = 100;
    
    initial begin
        clk <= 0;
        forever #(clockPeriod/2) clk <= ~clk;
    end
    
    initial begin
        reset <= 1; @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        reset <= 0; @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        WB <= 2'b11; readData <= 32'h1; aluResult <= 32'h2; instruction <= 32'h3; @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        $stop;
    end

endmodule