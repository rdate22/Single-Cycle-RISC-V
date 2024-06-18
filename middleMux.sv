module middleMux (
    input logic [31:0] aluOutput,     // Output from ALU
    input logic [31:0] dataMemOutput, // Output from data memory
    input logic useAluOutput,         // Control signal for using ALU output
    output logic [31:0] muxOutput
);
    assign muxOutput = useAluOutput ? aluOutput : dataMemOutput;
endmodule