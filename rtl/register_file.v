module register_file(
    input clk,
    input rst,

    input [2:0] rs1,
    input [2:0] rs2,
    input [2:0] rd,

    input [31:0] write_data,
    input reg_write,

    output [31:0] read_data1,
    output [31:0] read_data2
);

    reg [31:0] regs [0:7];
    integer i;

    // Synchronous reset + write
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1)
                regs[i] <= 0;
        end
        else if (reg_write && rd != 0) begin
            regs[rd] <= write_data;
        end
    end

    // Combinational read with x0 protection
    assign read_data1 = (rs1 == 0) ? 32'b0 : regs[rs1];
    assign read_data2 = (rs2 == 0) ? 32'b0 : regs[rs2];

endmodule