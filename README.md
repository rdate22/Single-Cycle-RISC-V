# Single-Cycle-RISC-V
A pipelined Single Cycle Risc-V processor
This project involves designing and implementing a 32-bit RISC-V CPU using System Verilog, starting with a Single-Cycle CPU and advancing to a multi-cycle/pipelined version for enhanced performance. The goal is to create a CPU that supports basic arithmetic operations, load/store instructions, and branching, while achieving faster execution through pipelining.

To set up the development environment, tools such as Quartus Prime for FPGA development and synthesis, ModelSim for simulation and testing, and Verilator for Verilog simulation are used. The environment setup involves installing these tools, cloning the repository, and configuring the project in Quartus Prime and ModelSim.

The Single-Cycle RISC-V CPU design includes features like instruction memory for storing binary instructions, data memory for load and store operations, general-purpose registers, an ALU for arithmetic and logic operations, a control unit for decoding instructions and generating control signals, and branching logic for handling conditional and unconditional branches. Testing involves simulating the CPU using ModelSim, running various assembly programs, and verifying functionality through waveforms.

The Multi-Cycle/Pipelined RISC-V CPU design enhances performance by implementing pipelining stages such as Instruction Fetch (IF), Instruction Decode (ID), Execution (EX), Memory Access (MEM), and Write Back (WB). Data hazards are managed using forwarding and stalling techniques, while control hazards are handled through branch prediction or delayed branching. Testing this design also involves simulation with ModelSim, running comprehensive assembly programs, and verifying performance improvements over the Single-Cycle CPU.
