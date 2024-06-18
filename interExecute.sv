// This module represents the Intermediate/Execute (ID_EX) stage in a pipelined CPU. It handles forwarding control signals and data to subsequent pipeline stages.
// The control signals are derived from the control unit's output and are forwarded to the next stage, influencing execution. 
// The module also forwards relevant data like program counter (pc_addr), register values (rd1 and rd2), immediate values (imm), and instructions.
// The multiplexer before the WB, M, and EX stages plays a crucial role in selecting appropriate signals based on certain conditions, as illustrated on page 588 of the book.
// Control signals are specified according to the figure on page 567 and its description on page 568.

module interExecute #(parameter width=32) (
    input logic clk, reset,             // Clock and reset signals
    input logic [2:0] EX,               // Control signals for EX stage
    input logic [2:0] M,                // Control signals for M stage
    input logic [1:0] WB,               // Control signals for WB stage
    input logic [width-1:0] pcAddr,     // Program counter address
    input logic [width-1:0] reg1,       // Value of register 1
    input logic [width-1:0] reg2,       // Value of register 2
    input logic [width-1:0] immediate,  // Immediate value
    input logic [width-1:0] instruction, // Instruction value
    
    output logic ALUSrcOut,             // ALU source control signal for the EX stage
    output logic [1:0] ALUOpOut,        // ALU operation control signals for the EX stage
    output logic [2:0] MOut,            // Control signals for the M stage
    output logic [1:0] WBOut,           // Control signals for the WB stage
    output logic [width-1:0] pcAddrOut, // Forwarded program counter address
    output logic [width-1:0] immediateOut, // Forwarded immediate value
    output logic [width-1:0] reg1Out,   // Forwarded value of register 1
    output logic [width-1:0] reg2Out,   // Forwarded value of register 2
    output logic [width-1:0] instructionOut // Forwarded instruction value
    );

    always_ff @(posedge clk) begin
        if (reset) begin
            ALUSrcOut <= 0; 
            ALUOpOut <= 0;
            MOut <= 0;
            WBOut <= 0;
            pcAddrOut <= 0;
            immediateOut <= 0;
            reg1Out <= 0;
            reg2Out <= 0;
            instructionOut <= 0;
        end
        else begin
            ALUSrcOut <= EX[2];
            ALUOpOut <= EX[1:0];
            MOut <= M;
            WBOut <= WB;
            pcAddrOut <= pcAddr;
            immediateOut <= immediate;
            reg1Out <= reg1;
            reg2Out <= reg2;
            instructionOut <= instruction;
        end
    }

endmodule

module idExTestBench();

    logic clk, reset, ALUSrcOut;
    logic [2:0] EX, M, MOut;
    logic [1:0] WB, ALUOpOut, WBOut;
    logic [31:0] pcAddr, reg1, reg2, immediate, instruction, pcAddrOut, immediateOut, reg1Out, reg2Out, instructionOut;

    idExModule dut (.*);
    
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
        EX <= 3'b101; M <= 3'b111; WB <= 2'b11; pcAddr <= 32'h1; reg1 <= 32'h2; reg2 <= 32'h3; immediate <= 32'h4; instruction <= 32'h5; @(posedge clk);
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