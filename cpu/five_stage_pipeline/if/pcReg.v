module pcReg(
    input clk,
    input rst,

    input IF_flush,
    input ID_stall,
    input [31:0] jmp_data,
    
    input pc_src,
    input [31:0] imm,
    
    output [31:0] pc
);
    
    wire [31:0] npc = IF_flush ? jmp_data : (pc_reg + (pc_src ? imm : 32'd4));

    reg [31:0] pc_reg;

    always @(posedge clk, posedge rst) begin
        if (rst) pc_reg <= 0;
        else if (ID_stall) begin
        end else begin
            pc_reg <= npc;
        end 
    end
    
    assign pc = pc_reg;
endmodule
