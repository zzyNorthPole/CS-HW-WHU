module MUXRS1(
    input rs1_chosen, //opcode the fourth and the fifth == 00 
    input zero_chosen, //opcode the second and the third == 11
    input [31:0] rs1,
    input [31:0] pc,

    output [31:0] ans1;
);

    assign ans1 = (rs1_chosen ? (zero_chosen ? 0 : pc) : rs1);

endmodule

module MUXRS2(
    input [1:0] four_chosen, // the first and the fifth 11 
    input rs2_chosen, // the second and the third 11
    input [31:0] rs2,
    input [31:0] imm,

    output [31:0] ans2;
);

    always @(*) begin
        case (four_chosen)
        2'b11:
            ans2 <= {29'b0, 3'b100};
        2'b01:
            ans2 <= imm;
        2'b10:
            ans2 <= rs2;
        2'b00:
            ans2 <= (rs2_chosen ? rs2 : imm);
        endcase
    end
    
endmodule