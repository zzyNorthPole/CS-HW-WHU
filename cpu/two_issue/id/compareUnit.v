`define beq_func3 3'b000
`define bne_func3 3'b001
`define blt_func3 3'b100
`define bge_func3 3'b101
`define bltu_func3 3'b110
`define bgeu_func3 3'b111

module compareUnit(
    input is_sb_type,
    input [2:0] compu_op,

    input signed [31:0] rs1_data,
    input signed [31:0] rs2_data,

    output zero
);

    wire beq_ins = is_sb_type & (compu_op == `beq_func3);
    wire bne_ins = is_sb_type & (compu_op == `bne_func3);
    wire blt_ins = is_sb_type & (compu_op == `blt_func3);
    wire bge_ins = is_sb_type & (compu_op == `bge_func3);
    wire bltu_ins = is_sb_type & (compu_op == `bltu_func3);
    wire bgeu_ins = is_sb_type & (compu_op == `bgeu_func3);


    wire beq_ans = (rs1_data == rs2_data);
    wire bne_ans = ~beq_ans;
    wire blt_ans = ($signed(rs1_data) < $signed(rs2_data));
    wire bge_ans = ~blt_ans;
    wire bltu_ans = ($unsigned(rs1_data) < $unsigned(rs2_data));
    wire bgeu_ans = ~bltu_ans;

    assign zero = beq_ins & beq_ans |
                  bne_ins & bne_ans |
                  blt_ins & blt_ans |
                  bge_ins & bge_ans |
                  bltu_ins & bltu_ans |
                  bgeu_ins & bgeu_ans;

endmodule
