`define addop 5'b00000
`define subop 5'b00001
`define sllop 5'b00010
`define sltop 5'b00100
`define sltuop 5'b00110
`define xorop 5'b01000
`define srlop 5'b01010
`define sraop 5'b01011
`define orop 5'b01100
`define andop 5'b01110

`define beqop 5'b10000
`define bneop 5'b10010
`define bltop 5'b11000
`define bgeop 5'b11010
`define bltuop 5'b11100
`define bgeuop 5'b11110

module ALU(
    input signed [31:0] aludatain1,
    input signed [31:0] aludatain2,
    input [5:0] aluop,

    output reg [31:0] aludataout,
    output aluzero
);

    always @(*) begin
        case (aluop[4:0])
        `addop:
            aludataout <= aludatain1 + aludatain2;
        `subop:
            aludataout <= aludatain1 - aludatain2;
        `sllop:
            aludataout <= aludatain1 << aludatain2;
        `sltop:
            aludataout <= {31'b0, (aludatain1 < aludatain2)};
        `sltuop:
            aludataout <= {31'b0, ($unsigned(aludatain1) < $unsigned(aludatain2))};
        `xorop:
            aludataout <= aludatain1 ^ aludatain2;
        `srlop:
            aludataout <= aludatain1 >> aludatain2;
        `sraop:
            aludataout <= aludatain1 >>> {2'b00, aludatain2[29:0]};
        `orop:
            aludataout <= aludatain1 | aludatain2;
        `andop:
            aludataout <= aludatain1 & aludatain2;
        `beqop:
            aludataout <= {31'b0, (aludatain1 == aludatain2)};
        `bneop:
            aludataout <= {31'b0, (aludatain1 != aludatain2)};
        `bltop:
            aludataout <= {31'b0, (aludatain1 < aludatain2)};
        `bgeop:
            aludataout <= {31'b0, (aludatain1 >= aludatain2)};
        `bltuop:
            aludataout <= {31'b0, ($unsigned(aludatain1) < $unsigned(aludatain2))};
        `bgeuop:
            aludataout <= {31'b0, ($unsigned(aludatain1) >= $unsigned(aludatain2))};
        default:
            aludataout <= 32'b0;
        endcase
    end

    assign aluzero = aluop[5] | (aludataout[0] & aluop[4]);

endmodule