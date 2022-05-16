//opcode 7 bits
//pc_plus_4_not is the first
//pc_use is the fourth
//imm_use is the fifth

module NPC(
    input [31:0] pc,
    input [31:0] imm,
    input [31:0] rs1,
    
    input pc_plus_4_not,
    input pc_use,
    input imm_use,
    input alu_zero,

    output [31:0] npc
);
    
    always (*) begin
        if (!pc_plus_4_not)
            pc <= pc + 4;
        else
            pc <= (((pc_use ^ imm_use)) ? rs1 : pc) + ((imm_use | alu_zero) ? imm : 4)
    end

endmodule