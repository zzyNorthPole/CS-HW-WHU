module CTRL(
    input [6:0] opcode,
    input [14:12] func3,
    input func7,

    //npc
    output pc_plus_4_not,
    output pc_use,
    output imm_use,

    //rf
    output reg_write,
    output reg_change,

    //alu
    output branch_arth_chosen, // 1 branch 0 arth (opcode first bit)
    output [2:0] aluop,
    output add_sr_chosen,

    //muxrs1
    output rs1_chosen,
    output zero_chosen,

    //muxrs2
    output [1:0] four_chosen,
    output rs2_chosen,

    //dm
    output dm_read,
    output dm_write,
    output [14:12] dmop

    //muxreg
    output reg_write_type
);

    //npc
    assign pc_plus_4_not = opcode[6];
    assign pc_use = opcode[3];
    assign imm_use = opcode[2];

    //rf
    assign reg_write = (opcode[5:2] != 4'b1000 && opcode[6:2] != 5'b11100 && opcode[6:2] != 5'b00011);
    assign reg_change = (opcode[6:2] == 5'b01000);

    //alu
    assign branch_arth_chosen = opcode[6] & (~opcode[2]);
    assign aluop = (opcode[2] ? 3'b000, func3);
    assign add_sr_chosen = func7;

    //muxrs1
    assign rs1_chosen = (opcode[4] & opcode[3]);
    assign zero_chosen = (opcode[6] & opcode[5]);

    //muxrs2
    assign four_chosen = {opcode[6], opcode[2]};
    assign rs2_chosen = (opcode[5] & opcode[4]);

    //dm
    assign dm_read = (opcode[6:2] == 5'b00000);
    assign dm_write = (opcode[6:2] == 5'b01000);
    assign dmop = func3;

    //muxreg
    assign reg_write_type = (op[6:2] == 5'b00000);

endmodule