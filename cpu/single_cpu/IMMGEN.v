`include "opcode_def.v"

module IMMGEN(
    input [31:0] ins,    
    output reg [31:0] imm
);

    always @(*) begin
        case (ins[6:0])
        `r_opcode: imm <= 32'b0;
        `ri_opcode: imm <= ((ins[14:12] == 3'b101) ? {20'b0, ins[24:20]} : {{20{ins[31]}}, ins[31:20]});
        `load_opcode: imm <= {{20{ins[31]}}, ins[31:20]};
        `s_opcode: imm <= {{20{ins[31]}}, ins[31:25], ins[11:7]};
        `sb_opcode: imm <= {{20{ins[31]}}, ins[7], ins[30:25], ins[11:8], 1'b0};
        `jalr_opcode: imm <= {{20{ins[31]}}, ins[31:20]};
        `jal_opcode: imm <= {{12{ins[31]}}, ins[19:12], ins[20], ins[30:21], 1'b0};
        `auipc_opcode: imm <= {ins[31:12], 12'b0};
        `lui_opcode: imm <= {ins[31:12], 12'b0};
        endcase
    end
endmodule