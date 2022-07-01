`include "if/controlUnit.v"
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

        input [31:0] inst_in, //instruction bus [31:0]
        input [31:0] Data_in, //data in [31:0]

       // output [3:0] mem_w, //memory read/write control
        output mem_w,
        output [3:0] wea,
        output [31:0] PC_out, //PC [31:0]
        output [31:0] Addr_out, //data address [31:0]
        output [31:0] Data_out, //data out [31:0]

        output [31:0] CPU_MIO, //not used

        input INT // interrupt TODO
    );

    wire IF_flush, ID_stall;

    wire [31:0] pc;
    
    wire [31:0] imm;
    wire [31:0] jmp_data;

    wire pc_src;
    wire is_sb_type;
    wire is_jalr_ins;

    wire [31:0] ins = inst_in;
    
    wire [2:0] imm_op;

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    wire [2:0] compu_op;

    wire [1:0] alu_src1;
    wire [1:0] alu_src2;
    wire [2:0] alu_op;
    wire alu_op_chosen;

    wire mem_read;
    wire mem_write;
    wire [2:0] mem_op;

    wire reg_write;
    wire mem_2_reg;

    wire ex_finish;
    wire mem_finish;
    wire is_s_type;

    wire [31:0] IF_ID_imm;
    wire IF_ID_reg_write;
    wire [2:0] IF_ID_compu_op;
    wire [1:0] IF_ID_alu_src1;
    wire [1:0] IF_ID_alu_src2;
    wire [2:0] IF_ID_alu_op;
    wire IF_ID_alu_op_chosen;
    wire IF_ID_mem_write;
    wire IF_ID_mem_read;
    wire [2:0] IF_ID_mem_op;
    wire IF_ID_mem_2_reg;
    wire IF_ID_is_sb_type;
    wire IF_ID_is_jalr_ins;
    wire IF_ID_ex_finish;
    wire IF_ID_mem_finish;
    wire IF_ID_is_s_type;
    wire [4:0] IF_ID_rs1;
    wire [4:0] IF_ID_rs2;
    wire [4:0] IF_ID_rd;
    wire [31:0] IF_ID_pc;

    wire [31:0] rs1_data_in;
    wire [31:0] rs2_data_in;

    wire [31:0] rs1_data_out;
    wire [31:0] rs2_data_out;

    wire ID_EX_reg_write;
    wire [1:0] ID_EX_alu_src1;
    wire [1:0] ID_EX_alu_src2;
    wire [2:0] ID_EX_alu_op;
    wire ID_EX_alu_op_chosen;
    wire ID_EX_mem_write, ID_EX_mem_read;
    wire [2:0] ID_EX_mem_op;
    wire ID_EX_mem_2_reg;
    wire ID_EX_ex_finish, ID_EX_mem_finish;
    wire [31:0] ID_EX_rs1_data;
    wire [4:0] ID_EX_rs2;
    wire [31:0] ID_EX_rs2_data;
    wire [4:0] ID_EX_rd;
    wire [31:0] ID_EX_pc;
    wire [31:0] ID_EX_imm;

    wire zero;

    wire [31:0] alu_in1, alu_in2; 
    wire [31:0] alu_out;

    wire [31:0] ID_EX_rs2_data_fresh;

    wire EX_MEM_reg_write;
    wire EX_MEM_mem_write, EX_MEM_mem_read;
    wire [2:0] EX_MEM_mem_op;
    wire EX_MEM_mem_2_reg;
    wire EX_MEM_ex_finish;
    wire EX_MEM_mem_finish;
    wire [31:0] EX_MEM_rs2_data;
    wire [4:0] EX_MEM_rd;
    wire [31:0] EX_MEM_alu_data;
 
    wire [31:0] mem_data;

    wire MEM_WB_reg_write;
    wire MEM_WB_mem_2_reg;
    wire [4:0] MEM_WB_rd;
    wire [31:0] MEM_WB_alu_data;
    wire [31:0] MEM_WB_mem_data;

    wire [31:0] rd_data;
    pcReg pcReg(
        .clk(clk),
        .rst(reset),
        
        .IF_flush(IF_flush),
        .ID_stall(ID_stall),
        .jmp_data(jmp_data),

        .pc_src(pc_src),
        .imm(imm),

        .pc(pc)
    );
    
    assign PC_out = pc;
    
    controlUnit controlUnit(
        .opcode(ins[6:0]),
        .func3(ins[14:12]),
        .func7(ins[31:25]),
        .rs1_in(ins[19:15]),
        .rs2_in(ins[24:20]),
        .rd_in(ins[11:7]),

        .imm_op(imm_op),
 
        .rs1_out(rs1),
        .rs2_out(rs2),
        .rd_out(rd),

        .compu_op(compu_op),

        .alu_src1(alu_src1),
        .alu_src2(alu_src2),
        .alu_op(alu_op),
        .alu_op_chosen(alu_op_chosen),

        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_op(mem_op),
        
        .reg_write(reg_write),
        .mem_2_reg(mem_2_reg),

        .pc_src(pc_src),
        .is_sb_type(is_sb_type),
        .is_jalr_ins(is_jalr_ins),

        .ex_finish(ex_finish),
        .mem_finish(mem_finish),
        .is_s_type(is_s_type)
    );
   
    immGen immGen(
        .imm_op(imm_op),
        .instruction(ins[31:0]),
        .imm(imm)
    );
    
    IF_ID_reg IF_ID_reg(
        .clk(clk),
        .rst(reset),
        
        .ID_stall(ID_stall),
        .IF_flush(IF_flush),

        .imm(imm),

        .reg_write(reg_write),
        .compu_op(compu_op),

        .alu_src1(alu_src1),
        .alu_src2(alu_src2),
        .alu_op(alu_op),
        .alu_op_chosen(alu_op_chosen),

        .mem_write(mem_write),
        .mem_read(mem_read),
        .mem_op(mem_op),

        .mem_2_reg(mem_2_reg),

        .is_sb_type(is_sb_type),
        .is_jalr_ins(is_jalr_ins),

        .ex_finish(ex_finish),
        .mem_finish(mem_finish),
        .is_s_type(is_s_type),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .pc(pc),

        .imm_out(IF_ID_imm),

        .reg_write_out(IF_ID_reg_write),
        .compu_op_out(IF_ID_compu_op),
        
        .alu_src1_out(IF_ID_alu_src1),
        .alu_src2_out(IF_ID_alu_src2),
        .alu_op_out(IF_ID_alu_op),
        .alu_op_chosen_out(IF_ID_alu_op_chosen),
        
        .mem_write_out(IF_ID_mem_write),
        .mem_read_out(IF_ID_mem_read),
        .mem_op_out(IF_ID_mem_op),

        .mem_2_reg_out(IF_ID_mem_2_reg),
        
        .is_sb_type_out(IF_ID_is_sb_type),
        .is_jalr_ins_out(IF_ID_is_jalr_ins),

        .ex_finish_out(IF_ID_ex_finish),
        .mem_finish_out(IF_ID_mem_finish),
        .is_s_type_out(IF_ID_is_s_type),

        .rs1_out(IF_ID_rs1),
        .rs2_out(IF_ID_rs2),
        .rd_out(IF_ID_rd),
        .pc_out(IF_ID_pc)
    );

    regFile regFile(
        .clk(clk),
        .rst(reset),

        .reg_write(MEM_WB_reg_write),

        .rs1(IF_ID_rs1),
        .rs2(IF_ID_rs2),

        .rs1_data(rs1_data_in),
        .rs2_data(rs2_data_in),

        .rd(MEM_WB_rd),
        .rd_data(rd_data)
    ); 

    IF_ID_ForwardingUnit IF_ID_ForwardingUnit(
        .IF_ID_rs1(IF_ID_rs1),
        .IF_ID_rs2(IF_ID_rs2),
        .ID_EX_rd(ID_EX_rd),
        .EX_MEM_rd(EX_MEM_rd),
        .MEM_WB_rd(MEM_WB_rd),
        .ex_alu_data(alu_out),
        .mem_alu_data(EX_MEM_alu_data),
        .mem_data(mem_data),
        .rd_data(rd_data),
        .rs1_data_in(rs1_data_in),
        .rs2_data_in(rs2_data_in),
        .ex_ex_finish(ID_EX_ex_finish),
        .mem_ex_finish(EX_MEM_ex_finish),
        .mem_mem_finish(EX_MEM_mem_finish),

        .rs1_data_out(rs1_data_out),
        .rs2_data_out(rs2_data_out)
    );

    compareUnit compareUnit(
        .is_sb_type(IF_ID_is_sb_type),
        .compu_op(IF_ID_compu_op),

        .rs1_data(rs1_data_out),
        .rs2_data(rs2_data_out),

        .zero(zero)
    );

    jmpMux jmpMux(
        .pc(IF_ID_pc),
        .imm(IF_ID_imm),
        .rs1(rs1_data_out),
        .is_sb_type(IF_ID_is_sb_type),
        .zero(zero),

        .jmp_data(jmp_data)
    );

    flush flush(
        .is_jalr_ins(IF_ID_is_jalr_ins),
        .is_sb_type(IF_ID_is_sb_type),
        .zero(zero),

        .IF_flush(IF_flush)
    );

    stall stall(
        .IF_ID_rs1(IF_ID_rs1),
        .IF_ID_rs2(IF_ID_rs2),
        .ID_EX_rd(ID_EX_rd),
        .ex_mem_finish(ID_EX_mem_finish),
        .IF_ID_is_s_type(IF_ID_is_s_type),

        .ID_stall(ID_stall)
    ); 

    ID_EX_reg ID_EX_reg(
        .clk(clk),
        .rst(reset),

        .ID_stall(ID_stall),

        .reg_write(IF_ID_reg_write),

        .alu_src1(IF_ID_alu_src1),
        .alu_src2(IF_ID_alu_src2),
        .alu_op(IF_ID_alu_op),
        .alu_op_chosen(IF_ID_alu_op_chosen),

        .mem_write(IF_ID_mem_write),
        .mem_read(IF_ID_mem_read),
        .mem_op(IF_ID_mem_op),

        .mem_2_reg(IF_ID_mem_2_reg),

        .ex_finish(IF_ID_ex_finish),
        .mem_finish(IF_ID_mem_finish),

        .rs1_data(rs1_data_out),
        .rs2(IF_ID_rs2),
        .rs2_data(rs2_data_out),
        .rd(IF_ID_rd),
        .pc(IF_ID_pc),
        .imm(IF_ID_imm),

        .reg_write_out(ID_EX_reg_write),

        .alu_src1_out(ID_EX_alu_src1),
        .alu_src2_out(ID_EX_alu_src2),
        .alu_op_out(ID_EX_alu_op),
        .alu_op_chosen_out(ID_EX_alu_op_chosen),

        .mem_write_out(ID_EX_mem_write),
        .mem_read_out(ID_EX_mem_read),
        .mem_op_out(ID_EX_mem_op),

        .mem_2_reg_out(ID_EX_mem_2_reg),

        .ex_finish_out(ID_EX_ex_finish),
        .mem_finish_out(ID_EX_mem_finish),

        .rs1_data_out(ID_EX_rs1_data),
        .rs2_out(ID_EX_rs2),
        .rs2_data_out(ID_EX_rs2_data),
        .rd_out(ID_EX_rd),
        .pc_out(ID_EX_pc),
        .imm_out(ID_EX_imm)
    );

    ALUSource ALUSource(
        .alu_src1(ID_EX_alu_src1),
        .alu_src2(ID_EX_alu_src2),

        .rs1_data(ID_EX_rs1_data),
        .pc(ID_EX_pc),

        .rs2_data(ID_EX_rs2_data),
        .imm(ID_EX_imm),

        .alu_in1(alu_in1),
        .alu_in2(alu_in2)
    );

    ALU ALU(
        .alu_op(ID_EX_alu_op),
        .alu_op_chosen(ID_EX_alu_op_chosen),
        .alu_in1(alu_in1),
        .alu_in2(alu_in2),
        .alu_out(alu_out)
    );

    ID_EX_ForwardingUnit ID_EX_ForwardingUnit(
        .ID_EX_rs2(ID_EX_rs2),
        .EX_MEM_rd(EX_MEM_rd),
        .MEM_WB_rd(MEM_WB_rd),
        .alu_data(EX_MEM_alu_data),
        .mem_data(mem_data),
        .rd_data(rd_data),
        .rs2_data_in(ID_EX_rs2_data),
        .mem_ex_finish(EX_MEM_ex_finish),
        .mem_mem_finish(EX_MEM_mem_finish),

        .rs2_data_fresh(ID_EX_rs2_data_fresh)
    );

    EX_MEM_reg EX_MEM_reg(
        .clk(clk),
        .rst(reset),

        .reg_write(ID_EX_reg_write),
        
        .mem_write(ID_EX_mem_write),
        .mem_read(ID_EX_mem_read),
        .mem_op(ID_EX_mem_op),

        .mem_2_reg(ID_EX_mem_2_reg),

        .ex_finish(ID_EX_ex_finish),
        .mem_finish(ID_EX_mem_finish),

        .rs2_data(ID_EX_rs2_data_fresh),
        .rd(ID_EX_rd),

        .alu_data(alu_out),

        .reg_write_out(EX_MEM_reg_write),

        .mem_write_out(EX_MEM_mem_write),
        .mem_read_out(EX_MEM_mem_read),
        .mem_op_out(EX_MEM_mem_op),

        .mem_2_reg_out(EX_MEM_mem_2_reg),

        .ex_finish_out(EX_MEM_ex_finish),
        .mem_finish_out(EX_MEM_mem_finish),

        .rs2_data_out(EX_MEM_rs2_data),
        .rd_out(EX_MEM_rd),

        .alu_data_out(EX_MEM_alu_data)
    );

    cpu2Mem cpu2Mem(
        .mem_read(EX_MEM_mem_read),
        .mem_write(EX_MEM_mem_write),
        .mem_op(EX_MEM_mem_op),

        .mem_addr_in(EX_MEM_alu_data),
        .mem_data_in(EX_MEM_rs2_data),

       // .mem_w(mem_w),
        .mem_w(mem_w),
        .wea(wea),
        .mem_addr_out(Addr_out),
        .mem_data_out(Data_out),

        .data_from_mem_in(Data_in),
        .data_from_mem_out(mem_data)
    );

    MEM_WB_reg MEM_WB_reg(
        .clk(clk),
        .rst(reset),

        .reg_write(EX_MEM_reg_write),
        
        .mem_2_reg(EX_MEM_mem_2_reg),

        .rd(EX_MEM_rd),

        .alu_data(EX_MEM_alu_data),
        .mem_data(mem_data),

        .reg_write_out(MEM_WB_reg_write),

        .mem_2_reg_out(MEM_WB_mem_2_reg),

        .rd_out(MEM_WB_rd),

        .alu_data_out(MEM_WB_alu_data),
        .mem_data_out(MEM_WB_mem_data)
    );

    wbMux wbMux(
        .mem_2_reg(MEM_WB_mem_2_reg),
        .alu_data(MEM_WB_alu_data),
        .mem_data(MEM_WB_mem_data),
        .rd_data(rd_data)
    );

endmodule
