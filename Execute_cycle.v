module Execute_cycle (
    input clk, rst, RegWriteE,ALUSrcE,MemWriteE,ResultSrcE,BranchE,
    input [2:0] ALUControlE,
    input [31:0] RD1_E, RD2_E, Imm_Ext_E,
    input [4:0] RD_E,
    input [31:0] PCE, PCPlus4E,
    input [31:0] ResultW,
    input [1:0] ForwardA_E, ForwardB_E,
    output PCSrcE, RegWriteM, MemWriteM, ResultSrcM,
    output [4:0] RD_M, 
    output [31:0] PCPlus4M, WriteDataM, ALU_ResultM,
    output [31:0] PCTargetE
);

//Declare wires/Registers
wire [31:0] Src_A, Src_B, Src_B_1, ResultE;
wire ZeroE;
reg RegWriteE_r, MemWriteE_r, ResultSrcE_r;
reg[4:0] RD_E_r;
reg[31:0] PCPlus4E_r, RD2_E_r, ResultE_r;

//Declare Modules

Mux_3_by_1 srca_mux (
    .a(RD1_E),
    .b(ResultW),
    .c(ALU_ResultM),
    .s(ForwardA_E),
    .out(Src_A)
);


Mux_3_by_1 srcb_mux (
    .a(RD2_E),
    .b(ResultW),
    .c(ALU_ResultM),
    .s(ForwardB_E),
    .out(Src_B_1)
);

Mux alu_src_mux (
    .a(Src_B_1), 
    .b(Imm_Ext_E), 
    .s(ALUSrcE), 
    .out(Src_B)
); 

ALU alu (
    .A(Src_A), 
    .B(Src_B), 
    .Res(ResultE), 
    .ALUControl(ALUControlE), 
    .OverFlow(), 
    .Carry(), 
    .Zero(ZeroE), 
    .Negative()
);
PC_adder branch_adder (
    .a(PCE), 
    .b(Imm_Ext_E), 
    .c(PCTargetE)
);       
    
// Register Logic
always @(posedge clk or negedge rst) begin
    if(~rst) begin
        RegWriteE_r <= 1'b0; 
        MemWriteE_r <= 1'b0; 
        ResultSrcE_r <= 1'b0;
        RD_E_r <= 5'h00;
        PCPlus4E_r <= 32'h00000000; 
        RD2_E_r <= 32'h00000000; 
        ResultE_r <= 32'h00000000;
    end
    else begin
        RegWriteE_r <= RegWriteE; 
        MemWriteE_r <= MemWriteE; 
        ResultSrcE_r <= ResultSrcE;
        RD_E_r <= RD_E;
        PCPlus4E_r <= PCPlus4E; 
        RD2_E_r <= Src_B_1; 
        ResultE_r <= ResultE;
    end
end

// Output Assignments
assign PCSrcE = ZeroE &  BranchE;
assign RegWriteM = RegWriteE_r;
assign MemWriteM = MemWriteE_r;
assign ResultSrcM = ResultSrcE_r;
assign RD_M = RD_E_r;
assign PCPlus4M = PCPlus4E_r;
assign WriteDataM = RD2_E_r;
assign ALU_ResultM = ResultE_r;

endmodule