module id_ex_reg(
    input clk,
    input rst,
    input stall,

    // Control signals
    input reg_write_in,
    input [2:0] alu_sel_in,
    input alu_src_in,

    // Data signals
    input [31:0] read_data1_in,
    input [31:0] read_data2_in,
    input [31:0] imm_in,

    // Register addresses
    input [2:0] rd_in,
    input [2:0] rs1_in,
    input [2:0] rs2_in,

    // Outputs
    output reg reg_write_out,
    output reg [2:0] alu_sel_out,
    output reg alu_src_out,

    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,
    output reg [31:0] imm_out,

    output reg [2:0] rd_out,
    output reg [2:0] rs1_out,
    output reg [2:0] rs2_out
);
always @(posedge clk) begin

    if (rst) begin

        reg_write_out <= 0;
        alu_sel_out   <= 0;
        alu_src_out   <= 0;

        read_data1_out <= 0;
        read_data2_out <= 0;
        imm_out        <= 0;

        rd_out  <= 0;
        rs1_out <= 0;
        rs2_out <= 0;

    end

    // Bubble insertion
    else if (stall) begin

        reg_write_out <= 0;
        alu_sel_out   <= 0;
        alu_src_out   <= 0;

        read_data1_out <= 0;
        read_data2_out <= 0;
        imm_out        <= 0;

        rd_out  <= 0;
        rs1_out <= 0;
        rs2_out <= 0;

    end

    // Normal pipeline operation
    else begin

        reg_write_out <= reg_write_in;
        alu_sel_out   <= alu_sel_in;
        alu_src_out   <= alu_src_in;

        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;
        imm_out        <= imm_in;

        rd_out  <= rd_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;

    end

end 
endmodule