module CPU(
    input clk,
    input rst
);
    //pc
    wire [31:0] pc;
    wire [31:0] npc;
    
    //im
    wire [31:0] ins;

    //ctrl
    //npc
    wire pc_plus_4_not;
    wire pc_use;
    wire imm_use;

    //rf
    wire reg_write;
    wire reg_change;

    //alu
    wire branch_arth_chosen; // 1 branch 0 arth (opcode first bit)
    wire [2:0] aluop;
    wire add_sr_chosen;

    //muxrs1
    wire rs1_chosen;
    wire zero_chosen;

    //muxrs2
    wire [1:0] four_chosen;
    wire rs2_chosen;

    //dm
    wire dm_read;
    wire dm_write;
    wire [14:12] dmop;

    //muxreg
    wire reg_write_type;
    //ctrl finish

    //rf
    wire [31:0] rs1, rs2;

    //immgen
    wire [31:0] imm;

    //muxrs
    wire [31:0] ans1, ans2;

    //alu
    wire [31:0] alu_ans;
    wire alu_zero;

    //dm
    wire [31:0] dout;
    
    //muxreg
    wire [31:0] reg_data;

    PC Pc(clk, rst, npc, pc);
    
    IM Im(pc[8:2], ins);

    CTRL Ctrl(
        ins[6:0], ins[14:12], ins[30],
        pc_plus_4_not, pc_use, imm_use,
        reg_write, reg_change, 
        branch_arth_chosen, aluop, add_sr_chosen,
        rs1_chosen, zero_chosen, 
        four_chosen, rs2_chosen,
        dm_read, dm_write, dmop,
        reg_write_type
    );

    RF Rf(
        rst,
        reg_write,
        reg_change,
        ins[19:15], ins[24:20], ins[11:7],
        reg_data,
        rs1, rs2
    );

    IMMGEN Immgen(ins, imm);

    MUXRS1 Muxrs1(rs1_chosen, zero_chosen, rs1, pc, ans1);
    MUXRS2 Muxrs2(four_chosen, rs2_chosen, rs2, imm, ans2);

    ALU Alu(ans1, ans2, pc, branch_arth_chosen, aluop, add_sr_chosen, alu_ans, alu_zero);

    NPC Npc(pc, imm, rs1, pc_plus_4_not, pc_use, imm_use, alu_zero, npc);

    DM Dm(clk, dm_read, dm_write, dmop, alu_ans, rs2, dout);

    MUXREG Muxreg(alu_ans, dout, reg_write_type, reg_data);

endmodule