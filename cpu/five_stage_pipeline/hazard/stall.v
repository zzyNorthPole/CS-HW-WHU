module stall(
    input [4:0] IF_ID_rs1,
    input [4:0] IF_ID_rs2,
    input [4:0] ID_EX_rd,
    input ex_mem_finish,
    input IF_ID_is_s_type,

    output ID_stall
);
    assign ID_stall = 
            (ex_mem_finish && ID_EX_rd != 0 && (ID_EX_rd == IF_ID_rs1 | ID_EX_rd == IF_ID_rs2) && ~IF_ID_is_s_type) | 
            (ex_mem_finish && ID_EX_rd != 0 && (ID_EX_rd == IF_ID_rs1) && IF_ID_is_s_type);
endmodule
