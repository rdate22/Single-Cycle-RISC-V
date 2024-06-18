//Mux at the top of the diagram that determines jump/branch operations
module topMux (
    input logic [31:0] pcPlus4,        // PC + 4
    input logic [31:0] branchAddr,     // Branch destination address
    input logic zero,                  // Zero output from ALU
    input logic branchControl,        // Branch control signal
    output logic [31:0] muxOutput
);
    assign muxOutput = (zero & branchControl) ? branchAddr : pcPlus4;
endmodule