`include "ALU_decoder.v"
`include "Main_Decoder.v"

module Control_Unit(
    input [6:0]Op,
    output RegWrite,
    output [1:0]ImmSrc,
    output ALUSrc,
    output MemWrite,
    output ResultSrc,
    output Branch,
    input [2:0]funct3,
    input [6:0]funct7,
    output [2:0]ALUControl
);

wire [1:0]ALUOp;

Main_Decoder Main_Decoder(
            .Op(Op),
            .RegWrite(RegWrite),
            .ImmSrc(ImmSrc),
            .MemWrite(MemWrite),
            .ResultSrc(ResultSrc),
            .Branch(Branch),
            .ALUSrc(ALUSrc),
            .ALUOp(ALUOp)
);

ALU_Decoder ALU_Decoder(
                        .ALUOp(ALUOp),
                        .funct3(funct3),
                        .funct7(funct7),
                        .op(Op),
                        .ALUControl(ALUControl)
);


endmodule