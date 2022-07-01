`define r_imm_op 0
`define i_imm_op 1
`define s_imm_op 2
`define sb_imm_op 3
`define j_imm_op 4
`define u_imm_op 5

module immGen(
    input [2:0] imm_op,
    input [31:0] instruction,

    output [31:0] imm
);

    wire [31:0] r_type = {32{imm_op == `r_imm_op}};
    wire [31:0] i_type = {32{imm_op == `i_imm_op}};
    wire [31:0] s_type = {32{imm_op == `s_imm_op}};
    wire [31:0] sb_type = {32{imm_op == `sb_imm_op}};
    wire [31:0] j_type = {32{imm_op == `j_imm_op}};
    wire [31:0] u_type = {32{imm_op == `u_imm_op}};

    wire [31:0] r_type_imm = 32'b0;
    wire [31:0] i_type_imm = {{20{instruction[31]}}, instruction[31:20]};
    wire [31:0] s_type_imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
    wire [31:0] sb_type_imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
    wire [31:0] j_type_imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
    wire [31:0] u_type_imm = {instruction[31:12], 12'b0};

    assign imm = (r_type & r_type_imm) |
                 (i_type & i_type_imm) |
                 (s_type & s_type_imm) |
                 (sb_type & sb_type_imm) |
                 (j_type & j_type_imm) |
                 (u_type & u_type_imm);

endmodule
