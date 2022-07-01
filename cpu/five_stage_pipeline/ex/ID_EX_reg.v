module ID_EX_reg(
    input clk,
    input rst,

    input ID_stall,

    input reg_write,

    input [1:0] alu_src1,
    input [1:0] alu_src2,
    input [2:0] alu_op,
    input alu_op_chosen,

    input mem_write, mem_read,
    input [2:0] mem_op,

    input mem_2_reg,

    input ex_finish,
    input mem_finish,
    
    input [31:0] rs1_data,
    input [4:0] rs2,
    input [31:0] rs2_data,
    input [4:0] rd,
    input [31:0] pc,
    input [31:0] imm,
 
    output reg_write_out,
    
    output [1:0] alu_src1_out,
    output [1:0] alu_src2_out,
    output [2:0] alu_op_out,
    output alu_op_chosen_out,

    output mem_write_out, mem_read_out,
    output [2:0] mem_op_out,

    output mem_2_reg_out,

    output ex_finish_out,
    output mem_finish_out,

    output [31:0] rs1_data_out,
    output [4:0] rs2_out,
    output [31:0] rs2_data_out,
    output [4:0] rd_out,
    output [31:0] pc_out,
    output [31:0] imm_out
);

    reg reg_write_reg;

    reg [1:0] alu_src1_reg;
    reg [1:0] alu_src2_reg;
    reg [2:0] alu_op_reg;
    reg alu_op_chosen_reg;

    reg mem_write_reg;
    reg mem_read_reg;
    reg [2:0] mem_op_reg;

    reg mem_2_reg_reg;

    reg ex_finish_reg;
    reg mem_finish_reg;
    
    reg [31:0] rs1_data_reg;
    reg [4:0] rs2_reg;
    reg [31:0] rs2_data_reg;
    reg [4:0] rd_reg;
    reg [31:0] pc_reg;
    reg [31:0] imm_reg;

    always @(posedge clk, posedge rst) begin
        if (rst | ID_stall) begin
            reg_write_reg <= 0; 
            
            alu_src1_reg <= 0;
            alu_src2_reg <= 0;
            alu_op_reg <= 0;
            alu_op_chosen_reg <= 0;

            mem_write_reg <= 0;
            mem_read_reg <= 0;
            mem_op_reg <= 0;

            mem_2_reg_reg <= 0;

            ex_finish_reg <= 0;
            mem_finish_reg <= 0;

            rs1_data_reg <= 0;
            rs2_reg <= 0;
            rs2_data_reg <= 0;
            rd_reg <= 0;
            pc_reg <= 0;
            imm_reg <= 0;
        end
        else begin 
            reg_write_reg <= reg_write; 

            alu_src1_reg <= alu_src1;
            alu_src2_reg <= alu_src2;
            alu_op_reg <= alu_op;
            alu_op_chosen_reg <= alu_op_chosen;

            mem_write_reg <= mem_write;
            mem_read_reg <= mem_read;
            mem_op_reg <= mem_op;

            mem_2_reg_reg <= mem_2_reg;

            ex_finish_reg <= ex_finish;
            mem_finish_reg <= mem_finish;

            rs1_data_reg <= rs1_data;
            rs2_reg <= rs2;
            rs2_data_reg <= rs2_data;
            rd_reg <= rd;
            pc_reg <= pc;
            imm_reg <= imm;
        end
    end        

    assign reg_write_out = reg_write_reg;

    assign alu_src1_out = alu_src1_reg;
    assign alu_src2_out = alu_src2_reg;
    assign alu_op_out = alu_op_reg;
    assign alu_op_chosen_out = alu_op_chosen_reg;

    assign mem_write_out = mem_write_reg;
    assign mem_read_out = mem_read_reg;
    assign mem_op_out = mem_op_reg;

    assign mem_2_reg_out = mem_2_reg_reg;

    assign ex_finish_out = ex_finish_reg;
    assign mem_finish_out = mem_finish_reg;
    
    assign rs1_data_out = rs1_data_reg;
    assign rs2_out = rs2_reg;
    assign rs2_data_out = rs2_data_reg;
    assign rd_out = rd_reg;
    assign pc_out = pc_reg;
    assign imm_out = imm_reg;


endmodule
