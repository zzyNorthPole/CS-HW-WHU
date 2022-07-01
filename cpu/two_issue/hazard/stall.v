module stall(
    input [4:0] IF_ID_rs1_1,
    input [4:0] IF_ID_rs2_1,
    input [4:0] ID_EX_rd_1,
    input ex_mem_finish_1,
    input IF_ID_is_s_type_1,
    input [4:0] IF_ID_rs1_2,
    input [4:0] IF_ID_rs2_2,
    input [4:0] ID_EX_rd_2,
    input ex_mem_finish_2,
    input IF_ID_is_s_type_2,

    output ID_stall
);
    assign ID_stall = 
            (ex_mem_finish_1 && ID_EX_rd_1 != 0 && (ID_EX_rd_1 == IF_ID_rs1_1 | ID_EX_rd_1 == IF_ID_rs2_1) && ~IF_ID_is_s_type_1) | 
            (ex_mem_finish_1 && ID_EX_rd_1 != 0 && (ID_EX_rd_1 == IF_ID_rs1_1) && IF_ID_is_s_type_1) |
            (ex_mem_finish_2 && ID_EX_rd_2 != 0 && (ID_EX_rd_2 == IF_ID_rs1_1 | ID_EX_rd_2 == IF_ID_rs2_1) && ~IF_ID_is_s_type_1) | 
            (ex_mem_finish_2 && ID_EX_rd_2 != 0 && (ID_EX_rd_2 == IF_ID_rs1_1) && IF_ID_is_s_type_1) |
            (ex_mem_finish_1 && ID_EX_rd_1 != 0 && (ID_EX_rd_1 == IF_ID_rs1_2 | ID_EX_rd_1 == IF_ID_rs2_2) && ~IF_ID_is_s_type_2) | 
            (ex_mem_finish_1 && ID_EX_rd_1 != 0 && (ID_EX_rd_1 == IF_ID_rs1_2) && IF_ID_is_s_type_2) |
            (ex_mem_finish_2 && ID_EX_rd_2 != 0 && (ID_EX_rd_2 == IF_ID_rs1_2 | ID_EX_rd_2 == IF_ID_rs2_2) && ~IF_ID_is_s_type_2) | 
            (ex_mem_finish_2 && ID_EX_rd_2 != 0 && (ID_EX_rd_2 == IF_ID_rs1_2) && IF_ID_is_s_type_2);
endmodule
