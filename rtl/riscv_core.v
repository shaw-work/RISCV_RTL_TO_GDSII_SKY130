module  riscv_core(
    input clk,
    input rst,
    output [31:0] instr_out
);

    // ================= WIRES =================
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] instr;
    wire [31:0] if_id_pc;
    wire [31:0] if_id_instr;
    // Full RISC-V fields
    wire [4:0] rs1_full;
    wire [4:0] rs2_full;
    wire [4:0] rd_full;

    // 3-bit register file addresses
    wire [2:0] rs1;
    wire [2:0] rs2;
    wire [2:0] rd;

    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] alu_result;

    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    wire reg_write;
    wire [2:0] alu_sel;
    wire alu_src;

    wire [31:0] imm;
    wire [31:0] alu_b;
    // ID/EX pipeline wires
    wire id_ex_reg_write;
    wire [2:0] id_ex_alu_sel;
    wire id_ex_alu_src;
    

    wire [31:0] id_ex_read_data1;
    wire [31:0] id_ex_read_data2;
    wire [31:0] id_ex_imm;

    wire [2:0] id_ex_rd;
    // EX/MEM pipeline wires
    wire ex_mem_reg_write;

    wire [31:0] ex_mem_alu_result;

    wire [2:0] ex_mem_rd;
    // MEM/WB pipeline wires
    wire mem_wb_reg_write;

    wire [31:0] mem_wb_alu_result;

    wire [2:0] mem_wb_rd;
    // Forwarding wires
    wire [1:0] forward_a;
    wire [1:0] forward_b;

    wire [31:0] alu_input_a;
    wire [31:0] alu_input_b;
    wire [2:0] id_ex_rs1;
    wire [2:0] id_ex_rs2;
    wire stall;
    wire ex_mem_read;
    // ================= FETCH =================
    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(pc_current)
    );

    instr_mem imem_inst (
        .addr(pc_current),
        .instr(instr)
    );
    if_id_reg if_id_inst (
    .clk(clk),
    .rst(rst),

    .pc_in(pc_current),
    .instr_in(instr),

    .pc_out(if_id_pc),
    .instr_out(if_id_instr),
    .stall(stall)
);
    assign pc_next = stall ? pc_current : (pc_current + 4);
    assign instr_out = instr;

    // ================= DECODE =================
    assign opcode = if_id_instr[6:0];
    assign ex_mem_read = (opcode == 7'b0000011);
assign funct3 = if_id_instr[14:12];
assign funct7 = if_id_instr[31:25];

assign rs1_full = if_id_instr[19:15];
assign rs2_full = if_id_instr[24:20];
assign rd_full  = if_id_instr[11:7];

    // truncate to 3-bit register file
    assign rs1 = rs1_full[2:0];
    assign rs2 = rs2_full[2:0];
    assign rd  = rd_full[2:0];

    // ================= CONTROL =================
    control_unit cu_inst (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .alu_sel(alu_sel),
        .alu_src(alu_src)
    );

    // ================= IMMEDIATE =================
    assign imm = {{20{instr[31]}}, instr[31:20]};

    // ================= REGISTER FILE =================
    register_file rf_inst (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(mem_wb_rd),
        .write_data(mem_wb_alu_result),
        .reg_write(mem_wb_reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    id_ex_reg id_ex_inst (
    .clk(clk),
    .rst(rst),
    .stall(stall),

    // Inputs from ID stage
    .reg_write_in(reg_write),
    .alu_sel_in(alu_sel),
    .alu_src_in(alu_src),
    .rs1_in(rs1),
    .rs2_in(rs2),

    .read_data1_in(read_data1),
    .read_data2_in(read_data2),
    .imm_in(imm),

    .rd_in(rd),

    // Outputs to EX stage
    .reg_write_out(id_ex_reg_write),
    .alu_sel_out(id_ex_alu_sel),
    .alu_src_out(id_ex_alu_src),

    .read_data1_out(id_ex_read_data1),
    .read_data2_out(id_ex_read_data2),
    .imm_out(id_ex_imm),

    .rd_out(id_ex_rd),
    .rs1_out(id_ex_rs1),
    .rs2_out(id_ex_rs2)
);

    // ================= EXECUTION =================
    assign alu_b = (id_ex_alu_src) ? id_ex_imm : id_ex_read_data2;
   
    // ALU input A forwarding mux
//
assign alu_input_a =
    (forward_a === 2'b01) ? ex_mem_alu_result :
    (forward_a === 2'b10) ? mem_wb_alu_result :
                            id_ex_read_data1;

// ALU input B
assign alu_input_b =
    (forward_b === 2'b01) ? ex_mem_alu_result :
    (forward_b === 2'b10) ? mem_wb_alu_result :
                            alu_b;
    alu alu_inst (
    .a(alu_input_a),
    .b(alu_input_b),
    .alu_sel(id_ex_alu_sel),
    .result(alu_result)
    );
    ex_mem_reg ex_mem_inst (
    .clk(clk),
    .rst(rst),

    // Inputs from EX stage
    .reg_write_in(id_ex_reg_write),
    .alu_result_in(alu_result),
    .rd_in(id_ex_rd),

    // Outputs to MEM/WB stage later
    .reg_write_out(ex_mem_reg_write),
    .alu_result_out(ex_mem_alu_result),
    .rd_out(ex_mem_rd)
);
mem_wb_reg mem_wb_inst (
    .clk(clk),
    .rst(rst),

    // Inputs from EX/MEM stage
    .reg_write_in(ex_mem_reg_write),
    .alu_result_in(ex_mem_alu_result),
    .rd_in(ex_mem_rd),

    // Outputs to WB stage
    .reg_write_out(mem_wb_reg_write),
    .alu_result_out(mem_wb_alu_result),
    .rd_out(mem_wb_rd)
);
    forwarding_unit fwd_inst (

    // Current EX stage source registers
    .rs1_ex(id_ex_rs1),
    .rs2_ex(id_ex_rs2),

    // Previous stage destination register
    .rd_mem(ex_mem_rd),
    .reg_write_mem(ex_mem_reg_write),
    .rd_wb(mem_wb_rd),
    .reg_write_wb(mem_wb_reg_write),

    // Outputs
    .forward_a(forward_a),
    .forward_b(forward_b)
);
    hazard_unit hazard_inst (

    .id_rs1(rs1),
    .id_rs2(rs2),

    .ex_rd(id_ex_rd),
    .ex_mem_read(ex_mem_read),

    .stall(stall)
);
endmodule
