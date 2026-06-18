module instr_mem(
    input  [31:0] addr,
    output [31:0] instr
);

    reg [31:0] memory [0:255];

    integer i;

initial begin
    // Your program
    memory[0] = 32'h00500093;
    memory[1] = 32'h00300113;
    memory[2] = 32'h002081B3;
    memory[3] = 32'h40208233;
    memory[4] = 32'h0020A2B3;
    memory[5] = 32'h0020C333;

    // Fill rest with NOP
    for (i = 6; i < 256; i = i + 1)
        memory[i] = 32'h00000013; // NOP
end

    assign instr = memory[addr[9:2]]; // word aligned

endmodule