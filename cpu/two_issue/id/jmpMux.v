module jmpMux(
    input [31:0] pc,
    input [31:0] imm,
    input [31:0] rs1,
    input is_sb_type,
    input zero,

    output [31:0] jmp_data
);

    wire jmp_src = is_sb_type & ~zero;
    assign jmp_data = jmp_src ? (pc + 32'd4) : (rs1 + imm);

endmodule
