module hazard_unit(

    input [2:0] id_rs1,
    input [2:0] id_rs2,

    input [2:0] ex_rd,
    input ex_mem_read,

    output reg stall

);

always @(*) begin

    stall = 0;

    // Load-use hazard detection
    if (ex_mem_read &&
        ((ex_rd == id_rs1) ||
         (ex_rd == id_rs2)) &&
        (ex_rd != 0))
    begin
        stall = 1;
    end

end

endmodule