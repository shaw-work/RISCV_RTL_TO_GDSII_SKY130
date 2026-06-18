module ex_mem_reg(
    input clk,
    input rst,

    // Control
    input reg_write_in,

    // Data
    input [31:0] alu_result_in,
    input [2:0] rd_in,

    // Outputs
    output reg reg_write_out,
    output reg [31:0] alu_result_out,
    output reg [2:0] rd_out
);

always @(posedge clk) begin
    if (rst) begin
        reg_write_out <= 0;
        alu_result_out <= 0;
        rd_out <= 0;
    end
    else begin
        reg_write_out <= reg_write_in;
        alu_result_out <= alu_result_in;
        rd_out <= rd_in;
    end
end

endmodule