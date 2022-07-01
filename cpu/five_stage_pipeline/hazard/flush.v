module flush(
    input is_jalr_ins,
    input is_sb_type,
    input zero,

    output IF_flush
);
    assign IF_flush = is_jalr_ins | is_sb_type & ~zero;
endmodule
