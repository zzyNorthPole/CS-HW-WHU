module IF_ID_reg(
    input clk,
    input rst,
    
    input ID_stall,
    input IF_flush,

    input [31:0] imm,

    input reg_write,
    input [2:0] compu_op,

    input [1:0] alu_src1,
    input [1:0] alu_src2,
    input [2:0] alu_op,
    input alu_op_chosen,

    input mem_write,
    input mem_read,
    input [2:0] mem_op,

    input mem_2_reg,
    
    input is_sb_type,
    input is_jalr_ins,

    input ex_finish,
    input mem_finish,
    input is_s_type,

    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] pc,

    output [31:0] imm_out,

    output reg_write_out,
    output [2:0] compu_op_out,
    
    output [1:0] alu_src1_out,
    output [1:0] alu_src2_out,
    output [2:0] alu_op_out,
    output alu_op_chosen_out,

    output mem_write_out,
    output mem_read_out,
    output [2:0] mem_op_out,

    output mem_2_reg_out,

    output is_sb_type_out,
    output is_jalr_ins_out,
    
    output ex_finish_out,
    output mem_finish_out,
    output is_s_type_out,

    output [4:0] rs1_out,
    output [4:0] rs2_out,
    output [4:0] rd_out,
    output [31:0] pc_out
);

    reg [31:0] imm_reg;

    reg reg_write_reg;
    reg [2:0] compu_op_reg;
    
    reg [1:0] alu_src1_reg;
    reg [1:0] alu_src2_reg;
    reg [2:0] alu_op_reg;
    reg alu_op_chosen_reg;

    reg mem_write_reg;
    reg mem_read_reg;
    reg [2:0] mem_op_reg;

    reg mem_2_reg_reg;

    reg is_sb_type_reg;
    reg is_jalr_ins_reg;
    
    reg ex_finish_reg;
    reg mem_finish_reg;
    reg is_s_type_reg;

    reg [4:0] rs1_reg;
    reg [4:0] rs2_reg;
    reg [4:0] rd_reg;
    reg [31:0] pc_reg;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            imm_reg <= 0;

            reg_write_reg <= 0; 
            compu_op_reg <= 0;
            
            alu_src1_reg <= 0;
            alu_src2_reg <= 0;
            alu_op_reg <= 0;
            alu_op_chosen_reg <= 0;

            mem_write_reg <= 0;
            mem_read_reg <= 0;
            mem_op_reg <= 0;

            mem_2_reg_reg <= 0;
            is_sb_type_reg <= 0;
            is_jalr_ins_reg <= 0;

            ex_finish_reg <= 0;
            mem_finish_reg <= 0;
            is_s_type_reg <= 0;

            rs1_reg <= 0;
            rs2_reg <= 0;
            rd_reg <= 0;
            pc_reg <= 0;
        end
        else if (ID_stall) begin
            
        end
        else if (IF_flush) begin 
            imm_reg <= 0;

            reg_write_reg <= 0; 
            compu_op_reg <= 0;

            alu_src1_reg <= 0;
            alu_src2_reg <= 0;
            alu_op_reg <= 0;
            alu_op_chosen_reg <= 0;

            mem_write_reg <= 0;
            mem_read_reg <= 0;
            mem_op_reg <= 0;

            mem_2_reg_reg <= 0;
            is_sb_type_reg <= 0;
            is_jalr_ins_reg <= 0;

            ex_finish_reg <= 0;
            mem_finish_reg <= 0;
            is_sb_type_reg <= 0;

            rs1_reg <= 0;
            rs2_reg <= 0;
            rd_reg <= 0;
            pc_reg <= 0;
        end
        else begin 
            imm_reg <= imm;

            reg_write_reg <= reg_write; 
            compu_op_reg <= compu_op;

            alu_src1_reg <= alu_src1;
            alu_src2_reg <= alu_src2;
            alu_op_reg <= alu_op;
            alu_op_chosen_reg <= alu_op_chosen;
            mem_write_reg <= mem_write;
            mem_read_reg <= mem_read;
            mem_op_reg <= mem_op;

            mem_2_reg_reg <= mem_2_reg;

            is_sb_type_reg <= is_sb_type;
            is_jalr_ins_reg <= is_jalr_ins;

            ex_finish_reg <= ex_finish;
            mem_finish_reg <= mem_finish;
            is_s_type_reg <= is_s_type;

            rs1_reg <= rs1;
            rs2_reg <= rs2;
            rd_reg <= rd;
            pc_reg <= pc;
        end
    end        
    
    
    assign imm_out = imm_reg;

    assign reg_write_out = reg_write_reg;
    assign compu_op_out = compu_op_reg;
    
    assign alu_src1_out = alu_src1_reg;
    assign alu_src2_out = alu_src2_reg;
    assign alu_op_out = alu_op_reg;
    assign alu_op_chosen_out = alu_op_chosen_reg;

    assign mem_write_out = mem_write_reg;
    assign mem_read_out = mem_read_reg;
    assign mem_op_out = mem_op_reg;

    assign mem_2_reg_out  = mem_2_reg_reg;

    assign is_sb_type_out = is_sb_type_reg;
    assign is_jalr_ins_out = is_jalr_ins_reg;
    
    assign ex_finish_out = ex_finish_reg;
    assign mem_finish_out = mem_finish_reg;
    assign is_s_type_out = is_s_type_reg;

    assign rs1_out = rs1_reg;
    assign rs2_out = rs2_reg;
    assign rd_out = rd_reg;
    assign pc_out = pc_reg;

endmodule
