`include "opcodes.v"
`include "gate_EX_MEM.v"
`include "gate_MEM_WB.v"
`include "datamemory.v"
`include "mux2Input.v"
`include "instructionmemory.v"
`include "pcReg.v"
`include "addFour.v"

`define AND and #330

module CPU (
  output [31:0] pc,
  input         clk,
  input  [31:0] instruction
);
	
	// MEM - Memory Access ====================================================
	
	wire regWrite_MEM;
	wire memToReg_MEM;
	wire memWrite_MEM;
	wire branch_MEM;

	wire zero_MEM;
	wire [31:0] aluOut_MEM;
	wire [31:0] writeData_MEM;
	wire writeReg_MEM;
	wire [31:0] pcBranch_MEM;

	wire pcSource;

	gate_EX_MEM gate_EX_MEM (
		.clk(clk),
		.regWrite_MEM(regWrite_MEM),
		.memToReg_MEM(memToReg_MEM),
		.memWrite_MEM(memWrite_MEM),
		.branch_MEM(branch_MEM),
		.regWrite_EX(), // need regWrite_EX
		.memToReg_EX(), // need memToReg_EX
		.branch_EX(), // need branch_EX
		.zero_MEM(zero_MEM),
		.aluOut_MEM(aluOut_MEM),
		.writeData_MEM(writeData_MEM),
		.writeReg_MEM(writeReg_MEM),
		.pcBranch_MEM(pcBranch_MEM),
		.zero_EX(), // need zero_EX
		.aluOut_EX(), // need aluOut_EX
		.writeReg_EX(), // need writeReg_EX
		.writeData_EX(), // need writeData_EX
		.pcBranch_EX() // need pcBranch_EX
	);

	`AND (pcSource, branch_MEM, zero_MEM);

	wire [31:0] readData_MEM;

	datamemory datamemory(
		.clk(clk),
		.dataOut(readData_MEM),
		.address(aluOut_MEM),
		.writeEnable(memWrite_MEM),
		.dataIn(writeData_MEM)
	);

	// WB - Register Write Back ====================================================
	
	wire regWrite_WB;
  	wire memToReg_WB;

	wire [31:0] aluOut_WB;
  	wire [31:0] readData_WB;
  	wire writeReg_WB;

	gate_MEM_WB gate_MEM_WB (
		.regWrite_WB(regWrite_WB),
		.memToReg_WB(memToReg_WB),
		.regWrite_MEM(regWrite_MEM),
		.memToReg_MEM(memToReg_MEM),
		.aluOut_WB(aluOut_WB),
		.readData_WB(readData_WB),
		.writeReg_WB(writeReg_WB),
		.aluOut_MEM(aluOut_MEM),
		.readData_MEM(readData_MEM),
		.writeReg_MEM(writeReg_MEM)
	);

	wire [31:0] result_WB;

	mux2Input memToRegMux(
		.out(result_WB),
		.address(memToReg_WB),
		.input0(aluOut_WB),
		.input1(readData_WB)
	);

	wire[31:0] prePC;
	wire[31:0] pcPlus4F;

	mux2Input regWriteMux(
		.out(prePC),
		.address(pcSource),
		.input0(pcPlus4F),
		.input1(pcBranch_MEM)
	);

	pcReg pcReg(
		.clk(clk),
		.pc(pc),
		.prePC(prePC)
	);

	addFour addFour (
		.clk(clk),
		.pcPlus4F(pcPlus4F),
		.pc(pc)
	);

	wire[31:0] instructionMemOut;

	instructionmemory instrmem(
		.clk(clk),
		.address(pc),
		.dataOut(instructionMemOut)
	);

endmodule