`include "if/controlUnit.v"
`include "if/twoIssueDecide.v"
`include "if/immGen.v"
`include "if/pcReg.v"
`include "id/compareUnit.v"
`include "id/jmpMux.v"
`include "id/regFile.v"
`include "id/IF_ID_reg.v"
`include "ex/ALU.v"
`include "ex/ALUSource.v"
`include "ex/ID_EX_reg.v"
`include "hazard/flush.v"
`include "hazard/IF_ID_ForwardingUnit.v"
`include "hazard/ID_EX_ForwardingUnit.v"
`include "hazard/stall.v"
`include "mem/cpu2Mem.v"
`include "mem/EX_MEM_reg.v"
`include "wb/wbMux.v"
`include "wb/MEM_WB_reg.v"

module SCPU(
        input clk,
        input reset, //reset
        input MIO_ready, //not used

        input [31:0] inst_in_1, //instruction bus [31:0]
        input [31:0] inst_in_2, //instruction bus [31:0]
        input [31:0] Data_in_1, //data in [31:0]
        input [31:0] Data_in_2,

       // output [3:0] mem_w, //memory read/write control
        output mem_w_1,
        output [3:0] wea_1,
        output mem_w_2,
        output [3:0] wea_2,

        output [31:0] PC_out_1, //PC [31:0]
        output [31:0] PC_out_2,
        output [31:0] Addr_out_1, //data address [31:0]
        output [31:0] Data_out_1, //data out [31:0]
        output [31:0] Addr_out_2,
        output [31:0] Data_out_2,

        output [31:0] CPU_MIO, //not used

        input INT // interrupt TODO
    );

    wire IF_flush, ID_stall;

    wire [31:0] pc;
    
    wire [31:0] imm_1;
    wire [31:0] jmp_data_1;

    wire [31:0] imm_2;
    wire [31:0] jmp_data_2;

    wire pc_src_1;
    //wire is_sb_type;
    //wire is_jalr_ins;

    wire is_r_type_1;
    wire is_ri_type_1;
    wire is_load_type_1;
    wire is_s_type_1;
    wire is_sb_type_1;
    wire is_jalr_ins_1;
    wire is_jal_ins_1;
    wire is_auipc_ins_1;
    wire is_lui_ins_1;

    wire pc_src_2;
    //wire is_sb_type;
    //wire is_jalr_ins;

    wire is_r_type_2;
    wire is_ri_type_2;
    wire is_load_type_2;
    wire is_s_type_2;
    wire is_sb_type_2;
    wire is_jalr_ins_2;
    wire is_jal_ins_2;
    wire is_auipc_ins_2;
    wire is_lui_ins_2;

    wire [31:0] ins_1 = inst_in_1;
    wire [31:0] ins_2 = inst_in_2;

    wire [2:0] imm_op_1;

    wire [4:0] rs1_1;
    wire [4:0] rs2_1;
    wire [4:0] rd_1;

    wire [2:0] compu_op_1;

    wire [1:0] alu_src1_1;
    wire [1:0] alu_src2_1;
    wire [2:0] alu_op_1;
    wire alu_op_chosen_1;

    wire mem_read_1;
    wire mem_write_1;
    wire [2:0] mem_op_1;

    wire reg_write_1;
    wire mem_2_reg_1;

    wire ex_finish_1;
    wire mem_finish_1;
    //wire is_s_type;

    wire [2:0] imm_op_2;

    wire [4:0] rs1_2;
    wire [4:0] rs2_2;
    wire [4:0] rd_2;

    wire [2:0] compu_op_2;

    wire [1:0] alu_src1_2;
    wire [1:0] alu_src2_2;
    wire [2:0] alu_op_2;
    wire alu_op_chosen_2;

    wire mem_read_2;
    wire mem_write_2;
    wire [2:0] mem_op_2;

    wire reg_write_2;
    wire mem_2_reg_2;

    wire ex_finish_2;
    wire mem_finish_2;

    wire two_issue;

    wire IF_ID_two_issue_1;
    wire [31:0] IF_ID_imm_1;
    wire IF_ID_reg_write_1;
    wire [2:0] IF_ID_compu_op_1;
    wire [1:0] IF_ID_alu_src1_1;
    wire [1:0] IF_ID_alu_src2_1;
    wire [2:0] IF_ID_alu_op_1;
    wire IF_ID_alu_op_chosen_1;
    wire IF_ID_mem_write_1;
    wire IF_ID_mem_read_1;
    wire [2:0] IF_ID_mem_op_1;
    wire IF_ID_mem_2_reg_1;
    wire IF_ID_is_sb_type_1;
    wire IF_ID_is_jalr_ins_1;
    wire IF_ID_ex_finish_1;
    wire IF_ID_mem_finish_1;
    wire IF_ID_is_s_type_1;
    wire [4:0] IF_ID_rs1_1;
    wire [4:0] IF_ID_rs2_1;
    wire [4:0] IF_ID_rd_1;
    wire [31:0] IF_ID_pc_1;

    wire IF_ID_two_issue_2;
    wire [31:0] IF_ID_imm_2;
    wire IF_ID_reg_write_2;
    wire [2:0] IF_ID_compu_op_2;
    wire [1:0] IF_ID_alu_src1_2;
    wire [1:0] IF_ID_alu_src2_2;
    wire [2:0] IF_ID_alu_op_2;
    wire IF_ID_alu_op_chosen_2;
    wire IF_ID_mem_write_2;
    wire IF_ID_mem_read_2;
    wire [2:0] IF_ID_mem_op_2;
    wire IF_ID_mem_2_reg_2;
    wire IF_ID_is_sb_type_2;
    wire IF_ID_is_jalr_ins_2;
    wire IF_ID_ex_finish_2;
    wire IF_ID_mem_finish_2;
    wire IF_ID_is_s_type_2;
    wire [4:0] IF_ID_rs1_2;
    wire [4:0] IF_ID_rs2_2;
    wire [4:0] IF_ID_rd_2;
    wire [31:0] IF_ID_pc_2;

    wire [31:0] rs1_data_in_1;
    wire [31:0] rs2_data_in_1;
    wire [31:0] rs1_data_in_2;
    wire [31:0] rs2_data_in_2;

    wire [31:0] rs1_data_out_1;
    wire [31:0] rs2_data_out_1;
    wire [31:0] rs1_data_out_2;
    wire [31:0] rs2_data_out_2;

    wire ID_EX_reg_write_1;
    wire [1:0] ID_EX_alu_src1_1;
    wire [1:0] ID_EX_alu_src2_1;
    wire [2:0] ID_EX_alu_op_1;
    wire ID_EX_alu_op_chosen_1;
    wire ID_EX_mem_write_1, ID_EX_mem_read_1;
    wire [2:0] ID_EX_mem_op_1;
    wire ID_EX_mem_2_reg_1;
    wire ID_EX_ex_finish_1, ID_EX_mem_finish_1;
    wire [31:0] ID_EX_rs1_data_1;
    wire [4:0] ID_EX_rs2_1;
    wire [31:0] ID_EX_rs2_data_1;
    wire [4:0] ID_EX_rd_1;
    wire [31:0] ID_EX_pc_1;
    wire [31:0] ID_EX_imm_1;

    wire ID_EX_reg_write_2;
    wire [1:0] ID_EX_alu_src1_2;
    wire [1:0] ID_EX_alu_src2_2;
    wire [2:0] ID_EX_alu_op_2;
    wire ID_EX_alu_op_chosen_2;
    wire ID_EX_mem_write_2, ID_EX_mem_read_2;
    wire [2:0] ID_EX_mem_op_2;
    wire ID_EX_mem_2_reg_2;
    wire ID_EX_ex_finish_2, ID_EX_mem_finish_2;
    wire [31:0] ID_EX_rs1_data_2;
    wire [4:0] ID_EX_rs2_2;
    wire [31:0] ID_EX_rs2_data_2;
    wire [4:0] ID_EX_rd_2;
    wire [31:0] ID_EX_pc_2;
    wire [31:0] ID_EX_imm_2;

    wire zero_1;
    wire zero_2;

    wire [31:0] alu_in1_1, alu_in2_1; 
    wire [31:0] alu_out_1;
    wire [31:0] alu_in1_2, alu_in2_2; 
    wire [31:0] alu_out_2;

    wire [31:0] ID_EX_rs2_data_fresh_1;
    wire [31:0] ID_EX_rs2_data_fresh_2;

    wire EX_MEM_reg_write_1;
    wire EX_MEM_mem_write_1, EX_MEM_mem_read_1;
    wire [2:0] EX_MEM_mem_op_1;
    wire EX_MEM_mem_2_reg_1;
    wire EX_MEM_ex_finish_1;
    wire EX_MEM_mem_finish_1;
    wire [31:0] EX_MEM_rs2_data_1;
    wire [4:0] EX_MEM_rd_1;
    wire [31:0] EX_MEM_alu_data_1;

    wire EX_MEM_reg_write_2;
    wire EX_MEM_mem_write_2, EX_MEM_mem_read_2;
    wire [2:0] EX_MEM_mem_op_2;
    wire EX_MEM_mem_2_reg_2;
    wire EX_MEM_ex_finish_2;
    wire EX_MEM_mem_finish_2;
    wire [31:0] EX_MEM_rs2_data_2;
    wire [4:0] EX_MEM_rd_2;
    wire [31:0] EX_MEM_alu_data_2;
 
    wire [31:0] mem_data_1;
    wire [31:0] mem_data_2;

    wire MEM_WB_reg_write_1;
    wire MEM_WB_mem_2_reg_1;
    wire [4:0] MEM_WB_rd_1;
    wire [31:0] MEM_WB_alu_data_1;
    wire [31:0] MEM_WB_mem_data_1;

    wire MEM_WB_reg_write_2;
    wire MEM_WB_mem_2_reg_2;
    wire [4:0] MEM_WB_rd_2;
    wire [31:0] MEM_WB_alu_data_2;
    wire [31:0] MEM_WB_mem_data_2;

    wire [31:0] rd_data_1;
    wire [31:0] rd_data_2;

    pcReg pcReg(
        .clk(clk),
        .rst(reset),
        
        .IF_flush(IF_flush),
        .ID_stall(ID_stall),
        .two_issue(two_issue),
        .IF_ID_two_issue(IF_ID_two_issue_2),
 
        .jmp_data_1(jmp_data_1),
        .jmp_data_2(jmp_data_2),

        .pc_src_1(pc_src_1),
        .pc_src_2(pc_src_2),

        .imm_1(imm_1),
        .imm_2(imm_2),

        .pc(pc)
    );
    
    assign PC_out_1 = pc;
    assign PC_out_2 = pc + 32'd4;
    
    controlUnit controlUnit_1(
        .opcode(ins_1[6:0]),
        .func3(ins_1[14:12]),
        .func7(ins_1[31:25]),
        .rs1_in(ins_1[19:15]),
        .rs2_in(ins_1[24:20]),
        .rd_in(ins_1[11:7]),

        .imm_op(imm_op_1),
 
        .rs1_out(rs1_1),
        .rs2_out(rs2_1),
        .rd_out(rd_1),

        .compu_op(compu_op_1),

        .alu_src1(alu_src1_1),
        .alu_src2(alu_src2_1),
        .alu_op(alu_op_1),
        .alu_op_chosen(alu_op_chosen_1),

        .mem_read(mem_read_1),
        .mem_write(mem_write_1),
        .mem_op(mem_op_1),
        
        .reg_write(reg_write_1),
        .mem_2_reg(mem_2_reg_1),

        .pc_src(pc_src_1),
        .is_r_type(is_r_type_1),
        .is_ri_type(is_ri_type_1),
        .is_load_type(is_load_type_1),
        .is_s_type(is_s_type_1),
        .is_sb_type(is_sb_type_1),
        .is_jalr_ins(is_jalr_ins_1),
        .is_jal_ins(is_jal_ins_1),
        .is_auipc_ins(is_auipc_ins_1),
        .is_lui_ins(is_lui_ins_1),

        .ex_finish(ex_finish_1),
        .mem_finish(mem_finish_1)
        //.is_s_type(is_s_type)
    );
   
    controlUnit controlUnit_2(
        .opcode(ins_2[6:0]),
        .func3(ins_2[14:12]),
        .func7(ins_2[31:25]),
        .rs1_in(ins_2[19:15]),
        .rs2_in(ins_2[24:20]),
        .rd_in(ins_2[11:7]),

        .imm_op(imm_op_2),
 
        .rs1_out(rs1_2),
        .rs2_out(rs2_2),
        .rd_out(rd_2),

        .compu_op(compu_op_2),

        .alu_src1(alu_src1_2),
        .alu_src2(alu_src2_2),
        .alu_op(alu_op_2),
        .alu_op_chosen(alu_op_chosen_2),

        .mem_read(mem_read_2),
        .mem_write(mem_write_2),
        .mem_op(mem_op_2),
        
        .reg_write(reg_write_2),
        .mem_2_reg(mem_2_reg_2),

        .pc_src(pc_src_2),
        .is_r_type(is_r_type_2),
        .is_ri_type(is_ri_type_2),
        .is_load_type(is_load_type_2),
        .is_s_type(is_s_type_2),
        .is_sb_type(is_sb_type_2),
        .is_jalr_ins(is_jalr_ins_2),
        .is_jal_ins(is_jal_ins_2),
        .is_auipc_ins(is_auipc_ins_2),
        .is_lui_ins(is_lui_ins_2),

        .ex_finish(ex_finish_2),
        .mem_finish(mem_finish_2)
        //.is_s_type(is_s_type)
    );

    twoIssueDecide twoIssueDecide(
        .clk(clk),
        .is_r_type_1(is_r_type_1),
        .is_ri_type_1(is_ri_type_1),
        .is_load_type_1(is_load_type_1),
        .is_s_type_1(is_s_type_1),
        .is_sb_type_1(is_sb_type_1),
        .is_jalr_ins_1(is_jalr_ins_1),
        .is_jal_ins_1(is_jal_ins_1),
        .is_auipc_ins_1(is_auipc_ins_1),
        .is_lui_ins_1(is_lui_ins_1),

        .is_r_type_2(is_r_type_2),
        .is_ri_type_2(is_ri_type_2),
        .is_load_type_2(is_load_type_2),
        .is_s_type_2(is_s_type_2),
        .is_sb_type_2(is_sb_type_2),
        .is_jalr_ins_2(is_jalr_ins_2),
        .is_jal_ins_2(is_jal_ins_2),
        .is_auipc_ins_2(is_auipc_ins_2),
        .is_lui_ins_2(is_lui_ins_2),

        .rd_1(rd_1),
        .rs1_2(rs1_2),
        .rs2_2(rs2_2),

        .two_issue(two_issue)
    );

    immGen immGen_1(
        .imm_op(imm_op_1),
        .instruction(ins_1[31:0]),
        .imm(imm_1)
    );
    
    immGen immGen_2(
        .imm_op(imm_op_2),
        .instruction(ins_2[31:0]),
        .imm(imm_2)
    );

    IF_ID_reg IF_ID_reg_1(
        .clk(clk),
        .rst(reset),
        
        .ID_stall(ID_stall),
        .IF_flush(IF_flush),
        .two_issue(1'b1),

        .imm(imm_1),

        .reg_write(reg_write_1),
        .compu_op(compu_op_1),

        .alu_src1(alu_src1_1),
        .alu_src2(alu_src2_1),
        .alu_op(alu_op_1),
        .alu_op_chosen(alu_op_chosen_1),

        .mem_write(mem_write_1),
        .mem_read(mem_read_1),
        .mem_op(mem_op_1),

        .mem_2_reg(mem_2_reg_1),

        .is_sb_type(is_sb_type_1),
        .is_jalr_ins(is_jalr_ins_1),

        .ex_finish(ex_finish_1),
        .mem_finish(mem_finish_1),
        .is_s_type(is_s_type_1),

        .rs1(rs1_1),
        .rs2(rs2_1),
        .rd(rd_1),
        .pc(pc),

        .two_issue_out(IF_ID_two_issue_1),

        .imm_out(IF_ID_imm_1),

        .reg_write_out(IF_ID_reg_write_1),
        .compu_op_out(IF_ID_compu_op_1),
        
        .alu_src1_out(IF_ID_alu_src1_1),
        .alu_src2_out(IF_ID_alu_src2_1),
        .alu_op_out(IF_ID_alu_op_1),
        .alu_op_chosen_out(IF_ID_alu_op_chosen_1),
        
        .mem_write_out(IF_ID_mem_write_1),
        .mem_read_out(IF_ID_mem_read_1),
        .mem_op_out(IF_ID_mem_op_1),

        .mem_2_reg_out(IF_ID_mem_2_reg_1),
        
        .is_sb_type_out(IF_ID_is_sb_type_1),
        .is_jalr_ins_out(IF_ID_is_jalr_ins_1),

        .ex_finish_out(IF_ID_ex_finish_1),
        .mem_finish_out(IF_ID_mem_finish_1),
        .is_s_type_out(IF_ID_is_s_type_1),

        .rs1_out(IF_ID_rs1_1),
        .rs2_out(IF_ID_rs2_1),
        .rd_out(IF_ID_rd_1),
        .pc_out(IF_ID_pc_1)
    );

    IF_ID_reg IF_ID_reg_2(
        .clk(clk),
        .rst(reset),
        
        .ID_stall(ID_stall),
        .IF_flush(IF_flush),
        .two_issue(two_issue),

        .imm(imm_2),

        .reg_write(reg_write_2),
        .compu_op(compu_op_2),

        .alu_src1(alu_src1_2),
        .alu_src2(alu_src2_2),
        .alu_op(alu_op_2),
        .alu_op_chosen(alu_op_chosen_2),

        .mem_write(mem_write_2),
        .mem_read(mem_read_2),
        .mem_op(mem_op_2),

        .mem_2_reg(mem_2_reg_2),

        .is_sb_type(is_sb_type_2),
        .is_jalr_ins(is_jalr_ins_2),

        .ex_finish(ex_finish_2),
        .mem_finish(mem_finish_2),
        .is_s_type(is_s_type_2),

        .rs1(rs1_2),
        .rs2(rs2_2),
        .rd(rd_2),
        .pc(pc + 32'd4),

        .two_issue_out(IF_ID_two_issue_2),

        .imm_out(IF_ID_imm_2),

        .reg_write_out(IF_ID_reg_write_2),
        .compu_op_out(IF_ID_compu_op_2),
        
        .alu_src1_out(IF_ID_alu_src1_2),
        .alu_src2_out(IF_ID_alu_src2_2),
        .alu_op_out(IF_ID_alu_op_2),
        .alu_op_chosen_out(IF_ID_alu_op_chosen_2),
        
        .mem_write_out(IF_ID_mem_write_2),
        .mem_read_out(IF_ID_mem_read_2),
        .mem_op_out(IF_ID_mem_op_2),

        .mem_2_reg_out(IF_ID_mem_2_reg_2),
        
        .is_sb_type_out(IF_ID_is_sb_type_2),
        .is_jalr_ins_out(IF_ID_is_jalr_ins_2),

        .ex_finish_out(IF_ID_ex_finish_2),
        .mem_finish_out(IF_ID_mem_finish_2),
        .is_s_type_out(IF_ID_is_s_type_2),

        .rs1_out(IF_ID_rs1_2),
        .rs2_out(IF_ID_rs2_2),
        .rd_out(IF_ID_rd_2),
        .pc_out(IF_ID_pc_2)
    );

    regFile regFile(
        .clk(clk),
        .rst(reset),

        .reg_write_1(MEM_WB_reg_write_1),
        .reg_write_2(MEM_WB_reg_write_2),

        .rs1_1(IF_ID_rs1_1),
        .rs2_1(IF_ID_rs2_1),
        .rs1_2(IF_ID_rs1_2),
        .rs2_2(IF_ID_rs2_2),

        .rs1_data_1(rs1_data_in_1),
        .rs2_data_1(rs2_data_in_1),
        .rs1_data_2(rs1_data_in_2),
        .rs2_data_2(rs2_data_in_2),

        .rd_1(MEM_WB_rd_1),
        .rd_data_1(rd_data_1),
        .rd_2(MEM_WB_rd_2),
        .rd_data_2(rd_data_2)
    ); 

    IF_ID_ForwardingUnit IF_ID_ForwardingUnit(
        .IF_ID_rs1_1(IF_ID_rs1_1),
        .IF_ID_rs2_1(IF_ID_rs2_1),
        .ID_EX_rd_1(ID_EX_rd_1),
        .EX_MEM_rd_1(EX_MEM_rd_1),
        .MEM_WB_rd_1(MEM_WB_rd_1),
        .ex_alu_data_1(alu_out_1),
        .mem_alu_data_1(EX_MEM_alu_data_1),
        .mem_data_1(mem_data_1),
        .rd_data_1(rd_data_1),
        .rs1_data_in_1(rs1_data_in_1),
        .rs2_data_in_1(rs2_data_in_1),
        .ex_ex_finish_1(ID_EX_ex_finish_1),
        .mem_ex_finish_1(EX_MEM_ex_finish_1),
        .mem_mem_finish_1(EX_MEM_mem_finish_1),
        .IF_ID_rs1_2(IF_ID_rs1_2),
        .IF_ID_rs2_2(IF_ID_rs2_2),
        .ID_EX_rd_2(ID_EX_rd_2),
        .EX_MEM_rd_2(EX_MEM_rd_2),
        .MEM_WB_rd_2(MEM_WB_rd_2),
        .ex_alu_data_2(alu_out_2),
        .mem_alu_data_2(EX_MEM_alu_data_2),
        .mem_data_2(mem_data_2),
        .rd_data_2(rd_data_2),
        .rs1_data_in_2(rs1_data_in_2),
        .rs2_data_in_2(rs2_data_in_2),
        .ex_ex_finish_2(ID_EX_ex_finish_2),
        .mem_ex_finish_2(EX_MEM_ex_finish_2),
        .mem_mem_finish_2(EX_MEM_mem_finish_2),

        .rs1_data_out_1(rs1_data_out_1),
        .rs2_data_out_1(rs2_data_out_1),
        .rs1_data_out_2(rs1_data_out_2),
        .rs2_data_out_2(rs2_data_out_2)
    );

    compareUnit compareUnit_1(
        .is_sb_type(IF_ID_is_sb_type_1),
        .compu_op(IF_ID_compu_op_1),

        .rs1_data(rs1_data_out_1),
        .rs2_data(rs2_data_out_1),

        .zero(zero_1)
    );

    compareUnit compareUnit_2(
        .is_sb_type(IF_ID_is_sb_type_2),
        .compu_op(IF_ID_compu_op_2),

        .rs1_data(rs1_data_out_2),
        .rs2_data(rs2_data_out_2),

        .zero(zero_2)
    );

    jmpMux jmpMux_1(
        .pc(IF_ID_pc_1),
        .imm(IF_ID_imm_1),
        .rs1(rs1_data_out_1),
        .is_sb_type(IF_ID_is_sb_type_1),
        .zero(zero_1),

        .jmp_data(jmp_data_1)
    );

    jmpMux jmpMux_2(
        .pc(IF_ID_pc_2),
        .imm(IF_ID_imm_2),
        .rs1(rs1_data_out_2),
        .is_sb_type(IF_ID_is_sb_type_2),
        .zero(zero_2),

        .jmp_data(jmp_data_2)
    );

    flush flush(
        .is_jalr_ins_1(IF_ID_is_jalr_ins_1),
        .is_sb_type_1(IF_ID_is_sb_type_1),
        .zero_1(zero_1),
        .is_jalr_ins_2(IF_ID_is_jalr_ins_2),
        .is_sb_type_2(IF_ID_is_sb_type_2),
        .zero_2(zero_2),

        .two_issue(IF_ID_two_issue_2),

        .IF_flush(IF_flush)
    );

    stall stall(
        .IF_ID_rs1_1(IF_ID_rs1_1),
        .IF_ID_rs2_1(IF_ID_rs2_1),
        .ID_EX_rd_1(ID_EX_rd_1),
        .ex_mem_finish_1(ID_EX_mem_finish_1),
        .IF_ID_is_s_type_1(IF_ID_is_s_type_1),
        .IF_ID_rs1_2(IF_ID_rs1_2),
        .IF_ID_rs2_2(IF_ID_rs2_2),
        .ID_EX_rd_2(ID_EX_rd_2),
        .ex_mem_finish_2(ID_EX_mem_finish_2),
        .IF_ID_is_s_type_2(IF_ID_is_s_type_2),

        .ID_stall(ID_stall)
    ); 

    ID_EX_reg ID_EX_reg_1(
        .clk(clk),
        .rst(reset),

        .ID_stall(ID_stall),

        .reg_write(IF_ID_reg_write_1),

        .alu_src1(IF_ID_alu_src1_1),
        .alu_src2(IF_ID_alu_src2_1),
        .alu_op(IF_ID_alu_op_1),
        .alu_op_chosen(IF_ID_alu_op_chosen_1),

        .mem_write(IF_ID_mem_write_1),
        .mem_read(IF_ID_mem_read_1),
        .mem_op(IF_ID_mem_op_1),

        .mem_2_reg(IF_ID_mem_2_reg_1),

        .ex_finish(IF_ID_ex_finish_1),
        .mem_finish(IF_ID_mem_finish_1),

        .rs1_data(rs1_data_out_1),
        .rs2(IF_ID_rs2_1),
        .rs2_data(rs2_data_out_1),
        .rd(IF_ID_rd_1),
        .pc(IF_ID_pc_1),
        .imm(IF_ID_imm_1),

        .reg_write_out(ID_EX_reg_write_1),

        .alu_src1_out(ID_EX_alu_src1_1),
        .alu_src2_out(ID_EX_alu_src2_1),
        .alu_op_out(ID_EX_alu_op_1),
        .alu_op_chosen_out(ID_EX_alu_op_chosen_1),

        .mem_write_out(ID_EX_mem_write_1),
        .mem_read_out(ID_EX_mem_read_1),
        .mem_op_out(ID_EX_mem_op_1),

        .mem_2_reg_out(ID_EX_mem_2_reg_1),

        .ex_finish_out(ID_EX_ex_finish_1),
        .mem_finish_out(ID_EX_mem_finish_1),

        .rs1_data_out(ID_EX_rs1_data_1),
        .rs2_out(ID_EX_rs2_1),
        .rs2_data_out(ID_EX_rs2_data_1),
        .rd_out(ID_EX_rd_1),
        .pc_out(ID_EX_pc_1),
        .imm_out(ID_EX_imm_1)
    );

    ID_EX_reg ID_EX_reg_2(
        .clk(clk),
        .rst(reset),

        .ID_stall(ID_stall),

        .reg_write(IF_ID_reg_write_2),

        .alu_src1(IF_ID_alu_src1_2),
        .alu_src2(IF_ID_alu_src2_2),
        .alu_op(IF_ID_alu_op_2),
        .alu_op_chosen(IF_ID_alu_op_chosen_2),

        .mem_write(IF_ID_mem_write_2),
        .mem_read(IF_ID_mem_read_2),
        .mem_op(IF_ID_mem_op_2),

        .mem_2_reg(IF_ID_mem_2_reg_2),

        .ex_finish(IF_ID_ex_finish_2),
        .mem_finish(IF_ID_mem_finish_2),

        .rs1_data(rs1_data_out_2),
        .rs2(IF_ID_rs2_2),
        .rs2_data(rs2_data_out_2),
        .rd(IF_ID_rd_2),
        .pc(IF_ID_pc_2),
        .imm(IF_ID_imm_2),

        .reg_write_out(ID_EX_reg_write_2),

        .alu_src1_out(ID_EX_alu_src1_2),
        .alu_src2_out(ID_EX_alu_src2_2),
        .alu_op_out(ID_EX_alu_op_2),
        .alu_op_chosen_out(ID_EX_alu_op_chosen_2),

        .mem_write_out(ID_EX_mem_write_2),
        .mem_read_out(ID_EX_mem_read_2),
        .mem_op_out(ID_EX_mem_op_2),

        .mem_2_reg_out(ID_EX_mem_2_reg_2),

        .ex_finish_out(ID_EX_ex_finish_2),
        .mem_finish_out(ID_EX_mem_finish_2),

        .rs1_data_out(ID_EX_rs1_data_2),
        .rs2_out(ID_EX_rs2_2),
        .rs2_data_out(ID_EX_rs2_data_2),
        .rd_out(ID_EX_rd_2),
        .pc_out(ID_EX_pc_2),
        .imm_out(ID_EX_imm_2)
    );

    ALUSource ALUSource_1(
        .alu_src1(ID_EX_alu_src1_1),
        .alu_src2(ID_EX_alu_src2_1),

        .rs1_data(ID_EX_rs1_data_1),
        .pc(ID_EX_pc_1),

        .rs2_data(ID_EX_rs2_data_1),
        .imm(ID_EX_imm_1),

        .alu_in1(alu_in1_1),
        .alu_in2(alu_in2_1)
    );

    ALUSource ALUSource_2(
        .alu_src1(ID_EX_alu_src1_2),
        .alu_src2(ID_EX_alu_src2_2),

        .rs1_data(ID_EX_rs1_data_2),
        .pc(ID_EX_pc_2),

        .rs2_data(ID_EX_rs2_data_2),
        .imm(ID_EX_imm_2),

        .alu_in1(alu_in1_2),
        .alu_in2(alu_in2_2)
    );

    ALU ALU_1(
        .alu_op(ID_EX_alu_op_1),
        .alu_op_chosen(ID_EX_alu_op_chosen_1),
        .alu_in1(alu_in1_1),
        .alu_in2(alu_in2_1),
        .alu_out(alu_out_1)
    );
    ALU ALU_2(
        .alu_op(ID_EX_alu_op_2),
        .alu_op_chosen(ID_EX_alu_op_chosen_2),
        .alu_in1(alu_in1_2),
        .alu_in2(alu_in2_2),
        .alu_out(alu_out_2)
    );

    ID_EX_ForwardingUnit ID_EX_ForwardingUnit(
        .ID_EX_rs2_1(ID_EX_rs2_1),
        .ID_EX_rs2_2(ID_EX_rs2_2),

        .ID_EX_rd_1(ID_EX_rd_1),
        .EX_MEM_rd_1(EX_MEM_rd_1),
        .EX_MEM_rd_2(EX_MEM_rd_2),
        .MEM_WB_rd_1(MEM_WB_rd_1),
        .MEM_WB_rd_2(MEM_WB_rd_2),

        .alu_out_1(alu_out_1),
        .EX_MEM_alu_data_1(EX_MEM_alu_data_1),
        .EX_MEM_alu_data_2(EX_MEM_alu_data_2),
        .mem_data_1(mem_data_1),
        .mem_data_2(mem_data_2),
        .rd_data_1(rd_data_1),
        .rd_data_2(rd_data_2),
        .rs2_data_in_1(ID_EX_rs2_data_1),
        .rs2_data_in_2(ID_EX_rs2_data_2),

        .ex_ex_finish_1(ID_EX_ex_finish_1),
        .mem_ex_finish_1(EX_MEM_ex_finish_1),
        .mem_ex_finish_2(EX_MEM_ex_finish_2),
        .mem_mem_finish_1(EX_MEM_mem_finish_1),
        .mem_mem_finish_2(EX_MEM_mem_finish_2),

        .rs2_data_fresh_1(ID_EX_rs2_data_fresh_1),
        .rs2_data_fresh_2(ID_EX_rs2_data_fresh_2)
    );

    EX_MEM_reg EX_MEM_reg_1(
        .clk(clk),
        .rst(reset),

        .reg_write(ID_EX_reg_write_1),
        
        .mem_write(ID_EX_mem_write_1),
        .mem_read(ID_EX_mem_read_1),
        .mem_op(ID_EX_mem_op_1),

        .mem_2_reg(ID_EX_mem_2_reg_1),

        .ex_finish(ID_EX_ex_finish_1),
        .mem_finish(ID_EX_mem_finish_1),

        .rs2_data(ID_EX_rs2_data_fresh_1),
        .rd(ID_EX_rd_1),

        .alu_data(alu_out_1),

        .reg_write_out(EX_MEM_reg_write_1),

        .mem_write_out(EX_MEM_mem_write_1),
        .mem_read_out(EX_MEM_mem_read_1),
        .mem_op_out(EX_MEM_mem_op_1),

        .mem_2_reg_out(EX_MEM_mem_2_reg_1),

        .ex_finish_out(EX_MEM_ex_finish_1),
        .mem_finish_out(EX_MEM_mem_finish_1),

        .rs2_data_out(EX_MEM_rs2_data_1),
        .rd_out(EX_MEM_rd_1),

        .alu_data_out(EX_MEM_alu_data_1)
    );

    EX_MEM_reg EX_MEM_reg_2(
        .clk(clk),
        .rst(reset),

        .reg_write(ID_EX_reg_write_2),
        
        .mem_write(ID_EX_mem_write_2),
        .mem_read(ID_EX_mem_read_2),
        .mem_op(ID_EX_mem_op_2),

        .mem_2_reg(ID_EX_mem_2_reg_2),

        .ex_finish(ID_EX_ex_finish_2),
        .mem_finish(ID_EX_mem_finish_2),

        .rs2_data(ID_EX_rs2_data_fresh_2),
        .rd(ID_EX_rd_2),

        .alu_data(alu_out_2),

        .reg_write_out(EX_MEM_reg_write_2),

        .mem_write_out(EX_MEM_mem_write_2),
        .mem_read_out(EX_MEM_mem_read_2),
        .mem_op_out(EX_MEM_mem_op_2),

        .mem_2_reg_out(EX_MEM_mem_2_reg_2),

        .ex_finish_out(EX_MEM_ex_finish_2),
        .mem_finish_out(EX_MEM_mem_finish_2),

        .rs2_data_out(EX_MEM_rs2_data_2),
        .rd_out(EX_MEM_rd_2),

        .alu_data_out(EX_MEM_alu_data_2)
    );

    cpu2Mem cpu2Mem_1(
        .mem_read(EX_MEM_mem_read_1),
        .mem_write(EX_MEM_mem_write_1),
        .mem_op(EX_MEM_mem_op_1),

        .mem_addr_in(EX_MEM_alu_data_1),
        .mem_data_in(EX_MEM_rs2_data_1),

       // .mem_w(mem_w_1),
        .mem_w(mem_w_1),
        .wea(wea_1),
        .mem_addr_out(Addr_out_1),
        .mem_data_out(Data_out_1),

        .data_from_mem_in(Data_in_1),
        .data_from_mem_out(mem_data_1)
    );

    cpu2Mem cpu2Mem_2(
        .mem_read(EX_MEM_mem_read_2),
        .mem_write(EX_MEM_mem_write_2),
        .mem_op(EX_MEM_mem_op_2),

        .mem_addr_in(EX_MEM_alu_data_2),
        .mem_data_in(EX_MEM_rs2_data_2),

       // .mem_w(mem_w_2),
        .mem_w(mem_w_2),
        .wea(wea_2),
        .mem_addr_out(Addr_out_2),
        .mem_data_out(Data_out_2),

        .data_from_mem_in(Data_in_2),
        .data_from_mem_out(mem_data_2)
    );

    MEM_WB_reg MEM_WB_reg_1(
        .clk(clk),
        .rst(reset),

        .reg_write(EX_MEM_reg_write_1),
        
        .mem_2_reg(EX_MEM_mem_2_reg_1),

        .rd(EX_MEM_rd_1),

        .alu_data(EX_MEM_alu_data_1),
        .mem_data(mem_data_1),

        .reg_write_out(MEM_WB_reg_write_1),

        .mem_2_reg_out(MEM_WB_mem_2_reg_1),

        .rd_out(MEM_WB_rd_1),

        .alu_data_out(MEM_WB_alu_data_1),
        .mem_data_out(MEM_WB_mem_data_1)
    );

    MEM_WB_reg MEM_WB_reg_2(
        .clk(clk),
        .rst(reset),

        .reg_write(EX_MEM_reg_write_2),
        
        .mem_2_reg(EX_MEM_mem_2_reg_2),

        .rd(EX_MEM_rd_2),

        .alu_data(EX_MEM_alu_data_2),
        .mem_data(mem_data_2),

        .reg_write_out(MEM_WB_reg_write_2),

        .mem_2_reg_out(MEM_WB_mem_2_reg_2),

        .rd_out(MEM_WB_rd_2),

        .alu_data_out(MEM_WB_alu_data_2),
        .mem_data_out(MEM_WB_mem_data_2)
    );

    wbMux wbMux_1(
        .mem_2_reg(MEM_WB_mem_2_reg_1),
        .alu_data(MEM_WB_alu_data_1),
        .mem_data(MEM_WB_mem_data_1),
        .rd_data(rd_data_1)
    );

    wbMux wbMux_2(
        .mem_2_reg(MEM_WB_mem_2_reg_2),
        .alu_data(MEM_WB_alu_data_2),
        .mem_data(MEM_WB_mem_data_2),
        .rd_data(rd_data_2)
    );

endmodule
