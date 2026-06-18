module alu(
    input [31:0] a,
    input [31:0] b,
    input [2:0] alu_sel,
    output reg [31:0] result
);

always @(*) begin
    case (alu_sel)
        3'b000: result = a + b;  // ADD
        3'b001: result = a - b;  // SUB
        3'b010: result = a & b;  // AND
        3'b011: result = a | b;  // OR
        default: result = 32'b0;
    endcase
end

endmodule