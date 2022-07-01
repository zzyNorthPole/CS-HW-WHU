/*
    alusrc1:
    rs1 0
    pc  1
    0   2

    alusrc2:
    rs2 0
    imm 1
    4   2
*/
module ALUSource(
        input [1:0] alu_src1,
        input [1:0] alu_src2,

        input [31:0] rs1_data,
        input [31:0] pc,

        input [31:0] rs2_data,
        input [31:0] imm,

        output [31:0] alu_in1,
        output [31:0] alu_in2
    );


    assign alu_in1 = 
            {32{alu_src1 == 2'b00}} & rs1_data |
            {32{alu_src1 == 2'b01}} & pc |
            {32{alu_src1 == 2'b10}} & 32'b0;
    assign alu_in2 = 
            {32{alu_src2 == 2'b00}} & rs2_data | 
            {32{alu_src2 == 2'b01}} & imm |
            {32{alu_src2 == 2'b10}} & 32'd4;

endmodule
