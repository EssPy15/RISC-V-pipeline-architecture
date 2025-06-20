`include "ALU.v"
`include "Mux.v"
`include "PC_adder.v"
`include "PC.v"
`include "Instruction_Memory.v"
`include "Control_Unit.v"
`include "Sign_Extend.v"
`include "Register.v"
`include "Data_memory.v"
`include "Fetch_cycle.v"
`include "Decode_cycle.v"
`include "Execute_cycle.v"
`include "Memory_cycle.v"
`include "WriteBack_cycle.v"
`include "Hazard_unit.v"

module processor(
    input clk, rst
);

//Declare wires/registers
wire PCSrcE, RegWriteW, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE, RegWriteM, MemWriteM, ResultSrcM, ResultSrcW;
wire [2:0] ALUControlE;
wire [4:0] RD_E, RD_M, RDW;
wire [31:0] PCTargetE, InstrD, PCD, PCPlus4D, ResultW, RD1_E, RD2_E, Imm_Ext_E, PCE, PCPlus4E, PCPlus4M, WriteDataM, ALU_ResultM;
wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW;
wire [4:0] RS1_E, RS2_E;
wire [1:0] ForwardBE, ForwardAE;

//Fetch Cycle
fetch_cycle Fetch(
    .clk(clk), 
    .rst(rst), 
    .PCSrcE(PCSrcE), 
    .PCTargetE(PCTargetE), 
    .InstrD(InstrD), 
    .PCD(PCD), 
    .PCPlus4D(PCPlus4D)
);

//Decode cycle
Decode_cycle decode(
    .clk(clk), 
    .rst(rst), 
    .InstrD(InstrD), 
    .PCD(PCD), 
    .PCPlus4D(PCPlus4D), 
    .RegWriteW(RegWriteW), 
    .RDW(RDW), 
    .ResultW(ResultW), 
    .RegWriteE(RegWriteE), 
    .ALUSrcE(ALUSrcE), 
    .MemWriteE(MemWriteE), 
    .ResultSrcE(ResultSrcE), 
    .BranchE(BranchE), 
    .ALUControlE(ALUControlE), 
    .RD1_E(RD1_E), 
    .RD2_E(RD2_E), 
    .Imm_Ext_E(Imm_Ext_E), 
    .RD_E(RD_E), 
    .RS1_E(RS1_E), 
    .RS2_E(RS2_E), 
    .PCE(PCE), 
    .PCPlus4E(PCPlus4E)
);

//Exexute cycle
Execute_cycle Execute (
    .clk(clk), 
    .rst(rst), 
    .RegWriteE(RegWriteE), 
    .ALUSrcE(ALUSrcE), 
    .MemWriteE(MemWriteE), 
    .ResultSrcE(ResultSrcE), 
    .BranchE(BranchE), 
    .ALUControlE(ALUControlE), 
    .RD1_E(RD1_E), 
    .RD2_E(RD2_E), 
    .Imm_Ext_E(Imm_Ext_E), 
    .RD_E(RD_E), 
    .PCE(PCE), 
    .PCPlus4E(PCPlus4E), 
    .PCSrcE(PCSrcE), 
    .PCTargetE(PCTargetE), 
    .RegWriteM(RegWriteM), 
    .MemWriteM(MemWriteM), 
    .ResultSrcM(ResultSrcM), 
    .RD_M(RD_M), 
    .PCPlus4M(PCPlus4M), 
    .WriteDataM(WriteDataM), 
    .ALU_ResultM(ALU_ResultM),
    .ResultW(ResultW),
    .ForwardA_E(ForwardAE),
    .ForwardB_E(ForwardBE)
);

//Memory cycle
memory_cycle Memory (
    .clk(clk), 
    .rst(rst), 
    .RegWriteM(RegWriteM), 
    .MemWriteM(MemWriteM), 
    .ResultSrcM(ResultSrcM), 
    .RD_M(RD_M), 
    .PCPlus4M(PCPlus4M), 
    .WriteDataM(WriteDataM), 
    .ALU_ResultM(ALU_ResultM), 
    .RegWriteW(RegWriteW), 
    .ResultSrcW(ResultSrcW), 
    .RD_W(RDW), 
    .PCPlus4W(PCPlus4W), 
    .ALU_ResultW(ALU_ResultW), 
    .ReadDataW(ReadDataW)
);

//Writeback cycle
writeback_cycle WriteBack (
    .clk(clk), 
    .rst(rst), 
    .ResultSrcW(ResultSrcW), 
    .PCPlus4W(PCPlus4W), 
    .ALU_ResultW(ALU_ResultW), 
    .ReadDataW(ReadDataW), 
    .ResultW(ResultW)
);
    
// Hazard Unit
hazard_unit Forwarding(
    .rst(rst), 
    .RegWriteM(RegWriteM), 
    .RegWriteW(RegWriteW), 
    .RD_M(RD_M), 
    .RD_W(RDW), 
    .Rs1_E(RS1_E), 
    .Rs2_E(RS2_E), 
    .ForwardAE(ForwardAE), 
    .ForwardBE(ForwardBE)
);

endmodule