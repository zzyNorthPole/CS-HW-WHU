//`define alu_src_1_rs1 2'b10
//`define alu_src_1_pc 2'b11
//`define alu_src_1_zero 2'b00
//`define alu_src_2_rs2 2'b10
//`define alu_src_2_imm 2'b11
//`define alu_src_2_4 2'b01

module MUXRS1(
    input [31:0] regdata1,
    input [31:0] pc,
    input [1:0] alusrc1,

    output [31:0] aludatain1
);
    assign aludatain1 = (alusrc1[1] ? (alusrc1[0] ? pc : regdata1): 32'b0);
endmodule

module MUXRS2(
    input [31:0] regdata2,
    input [31:0] imm,
    input [1:0] alusrc2,

    output [31:0] aludatain2
);
    assign aludatain2 = (alusrc2[1] ? (alusrc2[0] ? imm : regdata2): {29'b0, 3'b100});
endmodule