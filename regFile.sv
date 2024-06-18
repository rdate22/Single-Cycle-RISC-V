module registerFile (
    input logic clk,                   // Clock
    input logic reset,                 // Reset signal
    input logic [4:0] readAddr1,       // Read address for port 1
    input logic [4:0] readAddr2,       // Read address for port 2
    input logic [4:0] writeAddr,       // Write address
    input logic [63:0] writeData,      // Data to be written
    input logic writeEnable,           // Write enable control signal

    output logic [63:0] readData1,     // Data for port 1
    output logic [63:0] readData2      // Data for port 2
);
    reg [63:0] registers [31:0];        // 32 registers, each 64 bits wide

    // Read data for port 1
    assign readData1 = registers[readAddr1];

    // Read data for port 2
    assign readData2 = registers[readAddr2];

    // Write to the register file on the rising edge of the clock if writeEnable is asserted
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset the registers to 0
            registers <= 32'h0;
        end else if (writeEnable) begin
            // Write the data to the specified register
            registers[writeAddr] <= writeData;
        end
    end
endmodule

module registerFileTb;

    // Testbench signals
    logic clk;
    logic reset;
    logic [4:0] readAddr1, readAddr2, writeAddr;
    logic [63:0] writeData;
    logic writeEnable;
    logic [63:0] readData1, readData2;

    // Instantiate the registerFile module
    registerFile reg_file (
        .clk(clk),
        .reset(reset),
        .readAddr1(readAddr1),
        .readAddr2(readAddr2),
        .writeAddr(writeAddr),
        .writeData(writeData),
        .writeEnable(writeEnable),
        .readData1(readData1),
        .readData2(readData2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test scenario
    initial begin
        // Initialize inputs
        reset = 1;
        readAddr1 = 5'b00000;
        readAddr2 = 5'b00001;
        writeAddr = 5'b00010;
        writeData = 64'hABCDEFFEDCBA987;
        writeEnable = 0;

        // Apply reset
        #10 reset = 0;

        // Write data to register 2
        #10 writeEnable = 1;
        #10;

        // Read data from registers 1 and 2
        readAddr1 = 5'b00001;
        readAddr2 = 5'b00010;
        #10;

        // Assertions to check the correctness of read data
        assert(readData1 === 64'h0) else $fatal("Test failed: Incorrect readData1 value");
        assert(readData2 === 64'hABCDEFFEDCBA987) else $fatal("Test failed: Incorrect readData2 value");

        $finish;  // End simulation
    end

endmodule