module dataMemory (
	input logic clk, reset, memWrite, memRead
	, input logic [31:0] address
	, input logic [31:0] writeData
	, output logic [31:0] readData
	);
	
	reg [31:0] dataMem [0:63];
	integer i;
	
	always @(posedge clk) begin
		if (reset) begin
			for (i = 1; i<64; i++) begin
				dataMem[i] <= 0;
			end
		end
		else begin
			if (memWrite) begin
				dataMem[address] <= writeData;
			end
			else if (memRead) begin
				readData <= dataMem[address];
			end
		end
	end
	
endmodule

module dataMemoryTestBench;
// Parameters
  localparam CLK_PERIOD = 10;  // Clock period in time units

  // Signals
  logic clk;
  logic reset;
  logic memWrite;
  logic memRead;
  logic [31:0] address;
  logic [31:0] writeData;
  logic [31:0] readData;

  // Instantiate dataMemory module
  dataMemory dut (
    .clk(clk),
    .reset(reset),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(address),
    .writeData(writeData),
    .readData(readData)
  );

  // Clock Generation
  initial begin
    clk = 0;
    forever #CLK_PERIOD clk = ~clk;
  end

  // Test Scenario
  initial begin
    // Initialize signals
    reset = 1;
    memWrite = 0;
    memRead = 0;
    address = 0;
    writeData = 0;

    // Apply reset
    #2 reset = 0;

    // Test Case 1: Write to memory and read back
    memWrite = 1;
    address = 8;
    writeData = 32'hABCD_1234;
    #20;
    memWrite = 0;
    memRead = 1;
    #10;
    assert(readData == 32'hABCD_1234) else $fatal("Test Case 1 failed!");

    // Test Case 2: Read from memory without write
    memRead = 1;
    address = 8;
    #10;
    assert(readData == 32'hABCD_1234) else $fatal("Test Case 2 failed!");

    // Test Case 3: Write to memory without read
    memWrite = 1;
    address = 16;
    writeData = 32'h5678_9ABC;
    #20;
    memWrite = 0;
    #10;

    // Add more test cases as needed

    // End simulation
    $stop;
  end



endmodule