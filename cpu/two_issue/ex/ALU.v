`define add_func3 3'b000
`define sll_func3 3'b001
`define slt_func3 3'b010
`define sltu_func3 3'b011
`define xor_func3 3'b100
`define sr_func3 3'b101
`define or_func3 3'b110
`define and_func3 3'b111

`define add_func7 7'b0000000
`define sub_func7 7'b0100000
`define srl_func7 7'b0000000
`define sra_func7 7'b0100000

module ALU(
        input [2:0] alu_op,
        input alu_op_chosen,
        input signed [31:0] alu_in1,
        input signed [31:0] alu_in2,

        output [31:0] alu_out
    );

    wire [31:0] add_ins = {32{(alu_op == `add_func3) & ~alu_op_chosen}};
    wire [31:0] sub_ins = {32{(alu_op == `add_func3) & alu_op_chosen}};
    wire [31:0] sll_ins = {32{alu_op == `sll_func3}};
    wire [31:0] slt_ins = {32{alu_op == `slt_func3}};
    wire [31:0] sltu_ins = {32{alu_op == `sltu_func3}};
    wire [31:0] xor_ins = {32{alu_op == `xor_func3}};
    wire [31:0] srl_ins = {32{(alu_op == `sr_func3) & ~alu_op_chosen}};
    wire [31:0] sra_ins = {32{(alu_op == `sr_func3) & alu_op_chosen}};
    wire [31:0] or_ins = {32{alu_op == `or_func3}};
    wire [31:0] and_ins = {32{alu_op == `and_func3}};

    wire [31:0] add_ans = alu_in1 + alu_in2;
    wire [31:0] sub_ans = alu_in1 - alu_in2;
    wire [31:0] sll_ans = alu_in1 << alu_in2[4:0];
    wire [31:0] slt_ans = {31'b0, ($signed(alu_in1) < $signed(alu_in2))};
    wire [31:0] sltu_ans = {31'b0, ($unsigned(alu_in1) < $unsigned(alu_in2))};
    wire [31:0] xor_ans = alu_in1 ^ alu_in2;
    wire [31:0] srl_ans = alu_in1 >> alu_in2[4:0];
    wire [31:0] sra_ans = alu_in1 >>> alu_in2[4:0];
    wire [31:0] or_ans = alu_in1 | alu_in2;
    wire [31:0] and_ans = alu_in1 & alu_in2;
    
    assign alu_out =    (add_ins & add_ans) | 
                        (sub_ins & sub_ans) | 
                        (sll_ins & sll_ans) | 
                        (slt_ins & slt_ans) |
                        (sltu_ins & sltu_ans) |
                        (xor_ins & xor_ans) | 
                        (srl_ins & srl_ans) |
                        (sra_ins & sra_ans) |
                        (or_ins & or_ans) | 
                        (and_ins & and_ans);

endmodule
