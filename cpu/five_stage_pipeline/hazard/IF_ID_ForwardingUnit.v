module IF_ID_ForwardingUnit(
    input [4:0] IF_ID_rs1,
    input [4:0] IF_ID_rs2,
    input [4:0] ID_EX_rd,
    input [4:0] EX_MEM_rd,
    input [4:0] MEM_WB_rd,
    input [31:0] ex_alu_data,
    input [31:0] mem_alu_data,
    input [31:0] mem_data,
    input [31:0] rd_data,
    input [31:0] rs1_data_in,
    input [31:0] rs2_data_in,
    input ex_ex_finish,
    input mem_ex_finish,
    input mem_mem_finish,

    output [31:0] rs1_data_out,
    output [31:0] rs2_data_out
);
    assign rs1_data_out = 
            (IF_ID_rs1 != 0 && IF_ID_rs1 == ID_EX_rd && ex_ex_finish) ? ex_alu_data :
            (IF_ID_rs1 != 0 && IF_ID_rs1 == EX_MEM_rd && mem_ex_finish) ? mem_alu_data :
            (IF_ID_rs1 != 0 && IF_ID_rs1 == EX_MEM_rd && mem_mem_finish) ? mem_data :
            (IF_ID_rs1 != 0 && IF_ID_rs1 == MEM_WB_rd) ? rd_data :
            rs1_data_in;

    assign rs2_data_out = 
            (IF_ID_rs2 != 0 && IF_ID_rs2 == ID_EX_rd && ex_ex_finish) ? ex_alu_data :
            (IF_ID_rs2 != 0 && IF_ID_rs2 == EX_MEM_rd && mem_ex_finish) ? mem_alu_data :
            (IF_ID_rs2 != 0 && IF_ID_rs2 == EX_MEM_rd && mem_mem_finish) ? mem_data :
            (IF_ID_rs2 != 0 && IF_ID_rs2 == MEM_WB_rd) ? rd_data :
            rs2_data_in;
endmodule
