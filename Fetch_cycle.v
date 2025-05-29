module fetch_cycle (
    input clk, 
    input rst, 
    input PCSrcE, 
    input [31:0] PCTargetE, 
    output[31:0] InstrD, 
    output[31:0] PCD, 
    output[31:0] PCPlus4D 
);

//Declaring wires?registers
wire[31:0] PC_F, PCF, PCPlus4F;
wire[31:0] InstrF;
reg[31:0] InstrF_reg, PCF_reg, PCPlus4F_reg;

//Inititation of module

Mux PC_Mux(.a(PCPlus4F), .b(PCTargetE), .s(PCSrcE), .out(PC_F));
PC Program_Counter(.clk(clk), .rst(rst), .PC_next(PC_F), .PC(PCF));
Instruction_Memory IMEM(.rst(rst), .A(PCF), .RD(InstrF));
PC_adder PC_add(.a(PCF), .b(32'h00000004), .c(PCPlus4F));

//Latches/Registers between stages IF & ID
always @(posedge clk or negedge rst) begin
    if(~rst) begin
        InstrF_reg <= 32'h00000000;
        PCF_reg <= 32'h00000000;
        PCPlus4F_reg <= 32'h00000000;
    end
    else begin
        InstrF_reg <= InstrF;
        PCF_reg <= PCF;
        PCPlus4F_reg <= PCPlus4F;
    end
end

// Assign reg value to output port
assign  InstrD = (rst) ? InstrF_reg: 32'h00000000;
assign  PCD = (rst) ? PCF_reg : 32'h00000000;
assign  PCPlus4D = (rst) ? PCPlus4F_reg : 32'h00000000;

    
endmodule