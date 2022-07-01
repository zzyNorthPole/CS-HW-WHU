`define r_opcode 7'b0110011
`define ri_opcode 7'b0010011
`define load_opcode 7'b0000011
`define s_opcode 7'b0100011
`define sb_opcode 7'b1100011
`define jalr_opcode 7'b1100111
`define jal_opcode 7'b1101111
`define auipc_opcode 7'b0010111
`define lui_opcode 7'b0110111

module controlUnit (
    input [6:0] opcode,
    input [14:12] func3,
    input [31:25] func7,
    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input [4:0] rd_in,

    output [2:0] imm_op,

    output [4:0] rs1_out,
    output [4:0] rs2_out,
    output [4:0] rd_out,

    output [2:0] compu_op,

    output [1:0] alu_src1,
    output [1:0] alu_src2,
    output [2:0] alu_op,
    output alu_op_chosen,

    output mem_read,
    output mem_write,
    output [2:0] mem_op,

    output reg_write,
    output mem_2_reg,

    output pc_src,
    //output is_sb_type,
    //output is_jalr_type,

    output is_r_type,
    output is_ri_type,
    output is_load_type,
    output is_s_type,
    output is_sb_type,
    output is_jalr_ins,
    output is_jal_ins,
    output is_auipc_ins,
    output is_lui_ins,

    output ex_finish,
    output mem_finish
    //output is_s_type
);

    //Decode
    wire r_type = (opcode == `r_opcode);
    wire ri_type = (opcode == `ri_opcode);
    wire load_type = (opcode == `load_opcode);
    wire s_type = (opcode == `s_opcode);
    wire sb_type = (opcode == `sb_opcode);

    wire jalr_ins = (opcode == `jalr_opcode);
    wire jal_ins = (opcode == `jal_opcode);
    wire auipc_ins = (opcode == `auipc_opcode);
    wire lui_ins = (opcode == `lui_opcode);

    //immgen in IF stage's signal
    assign imm_op = (
            {3{r_type}} & 3'd0 | //0
            {3{ri_type | load_type | jalr_ins}} & 3'd1 | //[31:20] to [11:0]
            {3{s_type}} & 3'd2 | //[31:25], [11:7] to [11:5], [4:0]
            {3{sb_type}} & 3'd3 | //[31:25], [11:7] to [12|10:5], [4:1|11]
            {3{jal_ins}} & 3'd4 | //[31:12] to [20|10:1|11|19:12]
            {3{auipc_ins | lui_ins}} & 3'd5 //[31:12] to [31:12]
        );

    //rs1 rs2 rd in ID stage's signal
    wire rs1_used = r_type | ri_type | load_type | s_type | sb_type | jalr_ins;
    wire rs2_used = r_type | s_type | sb_type;
    wire rd_used = r_type | ri_type | load_type | jalr_ins | jal_ins | auipc_ins | lui_ins;
    assign rs1_out = rs1_used ? rs1_in : 5'b00000;
    assign rs2_out = rs2_used ? rs2_in : 5'b00000;
    assign rd_out = rd_used ? rd_in : 5'b00000;

    //compare unit in ID stage's signal
    assign compu_op = {3{sb_type}} & func3;

    //ALU rs1
    assign alu_src1[0] = jalr_ins | jal_ins | auipc_ins; //imm
    assign alu_src1[1] = sb_type | lui_ins; //0
    //ALU rs2
    assign alu_src2[0] = ri_type | load_type | s_type | auipc_ins | lui_ins; 
    assign alu_src2[1] = jalr_ins | jal_ins;
    //ALU operations
    assign alu_op = (r_type | ri_type) ? func3 : 3'b000;
    assign alu_op_chosen = (
            (r_type && func3 == 3'b000 && func7[30] == 1) | 
            ((r_type | ri_type) && func3 == 3'b101 && func7[30] == 1)
        );

    //memory read and write
    assign mem_read = load_type;
    assign mem_write = s_type;
    assign mem_op = (mem_write | mem_read) ? func3 : 3'b000;

    assign mem_2_reg = load_type;
    assign reg_write = r_type | ri_type | load_type |
           jalr_ins | jal_ins | auipc_ins | lui_ins;

    //PC
    assign pc_src = sb_type | jal_ins;
    //assign is_sb_type = sb_type;
    //assign is_jalr_ins = jalr_ins;

    //decoding output
    assign is_r_type = r_type;
    assign is_ri_type = ri_type;
    assign is_load_type = load_type;
    assign is_s_type = s_type;
    assign is_sb_type = sb_type;
    assign is_jalr_ins = jalr_ins;
    assign is_jal_ins = jal_ins;
    assign is_auipc_ins = auipc_ins;
    assign is_lui_ins = lui_ins;

    //forwarding
    assign ex_finish = r_type | ri_type | jalr_ins | jal_ins | auipc_ins | lui_ins;
    assign mem_finish = load_type;
    //assign is_s_type = s_type;
 
endmodule
