module adder (input logic [31:0] a , b , output logic [31:0] c);

	assign c = a + b;

endmodule


module adder_testbench();

    logic [31:0] a, b;

    // Output
    logic [31:0] c;

    // Instantiate the adder module
    adder dut (
        .a(a),
        .b(b),
        .c(c)
    );

    initial begin
s		  
        a = 101;
        b = 1010;

        //wait for 10 clock cycles
        #10;

        $stop;
    end

endmodule
