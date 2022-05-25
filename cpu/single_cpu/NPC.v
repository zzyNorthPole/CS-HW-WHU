//`define pc_add_4 2'b00
//`define pc_add_imm 2'b01
//`define rs1_add_imm 2'b11

module NPC(
    input [31:0] pc,
    input [31:0] imm,
    input [31:0] regdata1,
    input [1:0] pcsrc,
    input aluzero,

    output [31:0] npc
);
    
    assign npc = (pcsrc[1] ? regdata1 : pc) + ((pcsrc[0] & aluzero) ? imm : 4);

endmodule