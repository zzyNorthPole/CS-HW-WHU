module ID_EX_ForwardingUnit(
    input [4:0] ID_EX_rs2,
    input [4:0] EX_MEM_rd,
    input [4:0] MEM_WB_rd,
    input [31:0] alu_data,
    input [31:0] mem_data,
    input [31:0] rd_data,
    input [31:0] rs2_data_in,
    input mem_ex_finish,
    input mem_mem_finish,

    output [31:0] rs2_data_fresh
);
    assign rs2_data_fresh = (
            (ID_EX_rs2 != 0 && ID_EX_rs2 == EX_MEM_rd && mem_ex_finish) ? alu_data :
            (ID_EX_rs2 != 0 && ID_EX_rs2 == EX_MEM_rd && mem_mem_finish) ? mem_data :
            (ID_EX_rs2 != 0 && ID_EX_rs2 == MEM_WB_rd) ? rd_data :
            rs2_data_in
        );
endmodule
