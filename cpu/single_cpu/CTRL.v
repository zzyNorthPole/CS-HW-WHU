`include "opcode_def.v"

/*
//regwrite
`define reg_write_yes 1'b1
`define reg_write_no 1'b0

//alusrc
`define alu_src_1_rs1 2'b10
`define alu_src_1_pc 2'b11
`define alu_src_1_zero 2'b00
`define alu_src_2_rs2 2'b10
`define alu_src_2_imm 2'b11
`define alu_src_2_4 2'b01

//aluop
`define alu_branch 1'b1
`define alu_arth 1'b0

`define alu_add 3'b000
`define alu_sr 3'b101

`define alu_func7_default 1'b0

//memwrite
`define mem_write_yes 1'b1
`define mem_write_no 1'b0

//memread
`define mem_read_yes 1'b1
`define mem_read_no 1'b0

//memop
`define mem_op_default 3'b000

//mem2reg
`define mem_to_reg_yes 1'b1
`define mem_to_reg_no 1'b0

//pcsrc
`define pc_add_4 2'b00
`define pc_add_imm 2'b01
`define rs1_add_imm 2'b11
*/

module CTRL(
    input [6:0] opcode,
    input [14:12] func3,
    input [31:25] func7,

    output regwrite,
    output [1:0] alusrc1, alusrc2,
    output [5:0] aluop,
    output memwrite, memread,
    output [2:0] memop,
    output mem2reg,
    output [1:0] pcsrc
);

    /*
    reg [17:0] opcode2ctrl;

    always @(*) begin
        case (opcode)
        `r_opcode:
            opcode2ctrl = {`reg_write_yes, `alu_src_1_rs1, `alu_src_2_rs2, `alu_arth, func3, func7[30], `mem_write_no, `mem_read_no, `mem_op_default, `mem_to_reg_no, `pc_add_4};
        `ri_opcode:
            opcode2ctrl = {`reg_write_yes, `alu_src_1_rs1, `alu_src_2_imm, `alu_arth, func3, (func3 == `alu_sr ? func7[30] : `alu_func7_default), `mem_write_no, `mem_read_no, `mem_op_default, `mem_to_reg_no, `pc_add_4};
        `load_opcode:
            opcode2ctrl = {`reg_write_yes, `alu_src_1_rs1, `alu_src_2_imm, `alu_arth, `alu_add, `alu_func7_default, `mem_write_no, `mem_read_yes, func3, `mem_to_reg_yes, `pc_add_4};
        `s_opcode:
            opcode2ctrl = {`reg_write_no, `alu_src_1_rs1, `alu_src_2_imm, `alu_arth, `alu_add, `alu_func7_default, `mem_write_yes, `mem_read_no, func3, `mem_to_reg_no, `pc_add_4};
        `sb_opcode:
            opcode2ctrl = {`reg_write_no, `alu_src_1_rs1, `alu_src_2_rs2, `alu_branch, func3, `alu_func7_default, `mem_write_no, `mem_read_no, `mem_op_default, `mem_to_reg_no, `pc_add_imm};
        `jalr_opcode:
            opcode2ctrl = {`reg_write_yes, `alu_src_1_pc, `alu_src_2_4, `alu_arth, `alu_add, `alu_func7_default, `mem_write_no, `mem_read_no, `mem_op_default, `mem_to_reg_no, `rs1_add_imm};
        `jal_opcode:
            opcode2ctrl = {`reg_write_yes, `alu_src_1_pc, `alu_src_2_4, `alu_arth, `alu_add, `alu_func7_default, `mem_write_no, `mem_read_no, `mem_op_default, `mem_to_reg_no, `pc_add_imm};
        `auipc_opcode:
            opcode2ctrl = {`mem_write_yes, `alu_src_1_pc, `alu_src_2_imm, `alu_arth, `alu_add, `alu_func7_default, `mem_write_no, `mem_read_no, `mem_op_default, `mem_to_reg_no, `pc_add_4};
        `lui_opcode:
            opcode2ctrl = {`mem_write_yes, `alu_src_1_zero, `alu_src_2_imm, `alu_arth, `alu_add, `alu_func7_default, `mem_write_no, `mem_read_no, `mem_op_default, `mem_to_reg_no, `pc_add_4};
        endcase
    end
    
    assign {regwrite, alusrc1, alusrc2, aluop, memwrite, memread, memop, mem2reg, pcsrc} = opcode2ctrl;
    */

    wire rtype, ritype, loadtype, stype, sbtype, jalrtype, jaltype, auipctype, luitype;
    
    assign rtype = (opcode == `r_opcode);
    assign ritype = (opcode == `ri_opcode);
    assign loadtype = (opcode == `load_opcode);
    assign stype = (opcode == `s_opcode);
    assign sbtype = (opcode == `sb_opcode);
    assign jalrtype = (opcode == `jalr_opcode);
    assign jaltype = (opcode == `jal_opcode);
    assign auipctype = (opcode == `auipc_opcode);
    assign luitype = (opcode == `lui_opcode);

    assign regwrite = rtype | ritype | loadtype | jalrtype | jaltype | auipctype | luitype;
    
    assign alusrc1[1] = rtype | ritype | loadtype | stype | sbtype | jalrtype | jaltype | auipctype;
    assign alusrc1[0] = jalrtype | jaltype | auipctype;
    assign alusrc2[1] = rtype | ritype | loadtype | stype | sbtype | auipctype | luitype;
    assign alusrc2[0] = ritype | loadtype | stype | jalrtype | jaltype | auipctype | luitype;

    assign aluop[5] = jalrtype | jaltype;
    assign aluop[4] = sbtype;
    assign aluop[3:1] = ((rtype | ritype | sbtype) ? func3 : 3'b000);
    assign aluop[0] = (rtype | (ritype & (func3 == 3'b101))) & func7[30];

    assign memwrite = stype;
    assign memread = loadtype;
    assign memop = ((loadtype | stype) ? func3 : 3'b000);
    assign mem2reg = loadtype;

    assign pcsrc[1] = jalrtype;
    assign pcsrc[0] = sbtype | jalrtype | jaltype;
    
endmodule