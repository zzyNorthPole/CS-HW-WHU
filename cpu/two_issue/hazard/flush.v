module flush(
    input is_jalr_ins_1,
    input is_sb_type_1,
    input zero_1,
    input is_jalr_ins_2,
    input is_sb_type_2,
    input zero_2,
    input two_issue,

    output IF_flush
);
    assign IF_flush = two_issue ? (is_jalr_ins_2 | is_sb_type_2 & ~zero_2) : (is_jalr_ins_1 | is_sb_type_1 & ~zero_1);
endmodule
