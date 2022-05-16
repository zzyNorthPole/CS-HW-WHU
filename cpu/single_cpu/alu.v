`define addop 3'b000
`define sllop 3'b001
`define sltop 3'b010
`define sltuop 3'b011
`define xorop 3'b100
`define srop 3'b101
`define orop 3'b110
`define andop 3'b111

`define beqop 3'b000
`define bneop 3'b001
`define bltop 3'b100
`define bgeop 3'b101
`define bltuop 3'b110
`define bgeuop 3'b111

module ALU(
    input signed [31:0] a,
    input signed [31:0] b,
    input [31:0] pc,
    input branch_arth_chosen, // 1 branch 0 arth (opcode first bit)
    input [2:0] aluop,
    input add_sr_chosen,

    output signed reg [31:0] c,
    output zero
);
    
    always (*) begin
        if (branch_arth_chosen) begin
            case (aluop)
            `beqop: 
                c = {31'b0, (a == b)};
            `bneop:
                c = {31'b0, (a != b)};
            `bltop:
                c = {31'b0, (a < b)};
            `bgeop:
                c = {31'b0, (a >= b)};
            `bltuop:
                c = {31'b0, ($unsigned(a) < $unsigned(b))};
            `bgeuop:
                c = {31'b0, ($unsigned(a) >= $unsigned(b))};
            default:
                c = {32'b0};
            endcase
        end
        else begin
            case (aluop)
            `addop:
                c = (add_sr_chosen ? a - b : a + b);
            `sllop:
                c = (a << b);
            `sltop:
                c = {31'b0, (a < b)};
            `sltuop:
                c = {31'b0, ($unsigned(a) < $unsigned(b))};
            `xorop:
                c = (a ^ b);
            `srop:
                c = (branch_arth_chosen ? a >>> b : a >> b);
            `orop:
                c = (a | b);
            `andop:
                c = (a & b);
            endcase
        end
    end

    assign Zero = c[0];

endmodule