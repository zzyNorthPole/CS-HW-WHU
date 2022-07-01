module pcReg(
    input clk,
    input rst,

    input IF_flush,
    input ID_stall,
    input two_issue,
    input IF_ID_two_issue,

    input [31:0] jmp_data_1,
    input [31:0] jmp_data_2,
    
    input pc_src_1,
    input pc_src_2,

    input [31:0] imm_1,
    input [31:0] imm_2,

    output [31:0] pc
);
    
    wire [31:0] npc = 
        IF_flush ? 
        (IF_ID_two_issue ? jmp_data_2 : jmp_data_1) :
        (
            two_issue ? 
                (pc_reg + 32'd4 + (pc_src_2 ? imm_2 : 32'd4)) : 
                (pc_reg + (pc_src_1 ? imm_1 : 32'd4))
        );

    reg [31:0] pc_reg;

    always @(posedge clk) begin
        if (rst) pc_reg <= 0;
        else if (ID_stall) begin
        end else begin
            pc_reg <= npc;
        end 
    end
    
    assign pc = pc_reg;
endmodule
