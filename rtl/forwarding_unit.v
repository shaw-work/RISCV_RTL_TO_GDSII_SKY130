module forwarding_unit(

    // Source registers from current EX stage
    input [2:0] rs1_ex,
    input [2:0] rs2_ex,

    // Destination register from EX/MEM stage
    input [2:0] rd_mem,
    input reg_write_mem,
    // MEM/WB stage
    input [2:0] rd_wb,
input reg_write_wb,

    // Forward control outputs
    output reg [1:0] forward_a,
    output reg [1:0] forward_b
);

always @(*) begin

    // Safe defaults
    forward_a = 2'b00;
    forward_b = 2'b00;

    // EX/MEM forwarding
    if (reg_write_mem &&
        (rd_mem != 0) &&
        (rd_mem === rs1_ex))
    begin
        forward_a = 2'b01;
    end

    if (reg_write_mem &&
        (rd_mem != 0) &&
        (rd_mem === rs2_ex))
    begin
        forward_b = 2'b01;
    end

    // MEM/WB forwarding
    if (reg_write_wb &&
        (rd_wb != 0) &&
        !(reg_write_mem &&
          (rd_mem != 0) &&
          (rd_mem === rs1_ex)) &&
        (rd_wb === rs1_ex))
    begin
        forward_a = 2'b10;
    end

    if (reg_write_wb &&
        (rd_wb != 0) &&
        !(reg_write_mem &&
          (rd_mem != 0) &&
          (rd_mem === rs2_ex)) &&
        (rd_wb === rs2_ex))
    begin
        forward_b = 2'b10;
    end

end

endmodule
