module Register(
    input clk,
    input rst,
    input WE3,
    input [31:0]WD3,
    input [4:0]A1,
    input [4:0]A2,
    input [4:0]A3,
    output [31:0]RD1,
    output [31:0]RD2
);

    reg [31:0] Reg [31:0];

    always @ (posedge clk)
    begin
        if(WE3 & (A3 != 5'h00))
            Reg[A3] <= WD3;
    end

    assign RD1 = (~rst) ? 32'd0 : Reg[A1];
    assign RD2 = (~rst) ? 32'd0 : Reg[A2];

    initial begin
        Reg[0] = 32'h00000000;
    end

endmodule