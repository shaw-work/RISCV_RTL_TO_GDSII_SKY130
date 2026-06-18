module control_unit(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg reg_write,
    output reg [2:0] alu_sel,
    output reg alu_src
);

always @(*) begin
    case (opcode)

        // R-type instructions (ADD, SUB, AND, OR)
        7'b0110011: begin
            reg_write = 1'b1;
            alu_src   = 1'b0; // use register

            case ({funct7, funct3})
                10'b0000000_000: alu_sel = 3'b000; // ADD
                10'b0100000_000: alu_sel = 3'b001; // SUB
                10'b0000000_111: alu_sel = 3'b010; // AND
                10'b0000000_110: alu_sel = 3'b011; // OR
                default:         alu_sel = 3'b000;
            endcase
        end

        // I-type (ADDI)
        7'b0010011: begin // ADDI
    reg_write = 1'b1;
    alu_src   = 1'b1;
    alu_sel   = 3'b000;
end

        default: begin
    reg_write = 1'b0;
    alu_src   = 1'b0;
    alu_sel   = 3'b000;
end

    endcase
end

endmodule