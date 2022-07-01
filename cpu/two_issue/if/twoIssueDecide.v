module twoIssueDecide(
    input clk,

    input is_r_type_1,
    input is_ri_type_1,
    input is_load_type_1,
    input is_s_type_1,
    input is_sb_type_1,
    input is_jalr_ins_1,
    input is_jal_ins_1,
    input is_auipc_ins_1,
    input is_lui_ins_1,

    input is_r_type_2,
    input is_ri_type_2,
    input is_load_type_2,
    input is_s_type_2,
    input is_sb_type_2,
    input is_jalr_ins_2,
    input is_jal_ins_2,
    input is_auipc_ins_2,
    input is_lui_ins_2,

    input [4:0] rd_1,
    input [4:0] rs1_2,
    input [4:0] rs2_2,

    output two_issue
);
    assign two_issue = (
                (rd_1 != 5'b0 && (rs1_2 == rd_1 || rs2_2 == rd_1)) ?
                (is_r_type_1 | is_ri_type_1 | is_auipc_ins_1 | is_lui_ins_1) & (is_jal_ins_2 | is_auipc_ins_2 | is_lui_ins_2 | (is_s_type_2 & ~(rs1_2 == rd_1))) |
                is_load_type_1 & (is_jal_ins_2 | is_auipc_ins_2 | is_lui_ins_2) |
                is_s_type_1 & ~is_s_type_2 & ~is_load_type_2: 
                is_r_type_1 | is_ri_type_1 | is_auipc_ins_1 | is_lui_ins_1 | (is_load_type_1 & ~is_s_type_2) | (is_s_type_1 & ~is_s_type_2 & ~is_load_type_2)
            );
endmodule
