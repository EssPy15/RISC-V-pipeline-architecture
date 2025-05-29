module PC (
    input clk,
    input rst,
    input[31:0] PC_next,
    output[31:0] PC
);

reg [31:0] PC;
always @(posedge clk ) begin
    if(rst) PC <= PC_next;
    else PC = {32{1'b0}};
end    
    
endmodule