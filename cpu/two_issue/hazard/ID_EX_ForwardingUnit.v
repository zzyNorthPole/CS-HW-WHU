module ID_EX_ForwardingUnit(
    input [4:0] ID_EX_rs2_1,
    input [4:0] ID_EX_rs2_2,

    input [4:0] ID_EX_rd_1,
    input [4:0] EX_MEM_rd_1,
    input [4:0] EX_MEM_rd_2,
    input [4:0] MEM_WB_rd_1,
    input [4:0] MEM_WB_rd_2,

    input [31:0] alu_out_1,
    input [31:0] EX_MEM_alu_data_1,
    input [31:0] EX_MEM_alu_data_2,
    input [31:0] mem_data_1,
    input [31:0] mem_data_2,
    input [31:0] rd_data_1,
    input [31:0] rd_data_2,
    input [31:0] rs2_data_in_1,
    input [31:0] rs2_data_in_2,

    input ex_ex_finish_1,
    input mem_ex_finish_1,
    input mem_ex_finish_2,
    input mem_mem_finish_1,
    input mem_mem_finish_2,

    output [31:0] rs2_data_fresh_1,
    output [31:0] rs2_data_fresh_2
);
    assign rs2_data_fresh_1 = (
            (ID_EX_rs2_1 != 0 && ID_EX_rs2_1 == EX_MEM_rd_2 && mem_ex_finish_2) ? EX_MEM_alu_data_2 :
            ((ID_EX_rs2_1 != 0 && ID_EX_rs2_1 == EX_MEM_rd_2 && mem_mem_finish_2) ? mem_data_2 :
            ((ID_EX_rs2_1 != 0 && ID_EX_rs2_1 == EX_MEM_rd_1 && mem_ex_finish_1) ? EX_MEM_alu_data_1 :
            ((ID_EX_rs2_1 != 0 && ID_EX_rs2_1 == EX_MEM_rd_1 && mem_mem_finish_1) ? mem_data_1 :
            ((ID_EX_rs2_1 != 0 && ID_EX_rs2_1 == MEM_WB_rd_2) ? rd_data_2 :
            ((ID_EX_rs2_1 != 0 && ID_EX_rs2_1 == MEM_WB_rd_1) ? rd_data_1 :
            rs2_data_in_1)))))
        );
    assign rs2_data_fresh_2 = (
            (ID_EX_rs2_2 != 0 && ID_EX_rs2_2 == ID_EX_rd_1 && ex_ex_finish_1) ? alu_out_1 :
            (ID_EX_rs2_2 != 0 && ID_EX_rs2_2 == EX_MEM_rd_2 && mem_ex_finish_2) ? EX_MEM_alu_data_2 :
            (ID_EX_rs2_2 != 0 && ID_EX_rs2_2 == EX_MEM_rd_2 && mem_mem_finish_2) ? mem_data_2 :
            (ID_EX_rs2_2 != 0 && ID_EX_rs2_2 == EX_MEM_rd_1 && mem_ex_finish_1) ? EX_MEM_alu_data_1 :
            (ID_EX_rs2_2 != 0 && ID_EX_rs2_2 == EX_MEM_rd_1 && mem_mem_finish_1) ? mem_data_1 :
            (ID_EX_rs2_2 != 0 && ID_EX_rs2_2 == MEM_WB_rd_2) ? rd_data_2 :
            (ID_EX_rs2_2 != 0 && ID_EX_rs2_2 == MEM_WB_rd_1) ? rd_data_1 :
            rs2_data_in_2
        );
endmodule
