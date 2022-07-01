module EX_MEM_reg(
    input clk,
    input rst,

    input reg_write,

    input mem_write, mem_read,
    input [2:0] mem_op,

    input mem_2_reg,

    input ex_finish,
    input mem_finish,

    input [31:0] rs2_data,
    input [4:0] rd,

    input [31:0] alu_data,
    
    output reg_write_out,
    
    output mem_write_out, 
    output mem_read_out,
    output [2:0] mem_op_out,

    output mem_2_reg_out,

    output ex_finish_out,
    output mem_finish_out,

    output [31:0] rs2_data_out,
    output [4:0] rd_out,

    output [31:0] alu_data_out
);

    reg reg_write_reg;
    
    reg mem_write_reg; 
    reg mem_read_reg;
    reg [2:0] mem_op_reg;

    reg mem_2_reg_reg;

    reg ex_finish_reg;
    reg mem_finish_reg;

    reg [31:0] rs2_data_reg;
    reg [4:0] rd_reg;

    reg [31:0] alu_data_reg;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            reg_write_reg <= 0; 

            mem_write_reg <= 0;
            mem_read_reg <= 0;
            mem_op_reg <= 0;

            mem_2_reg_reg <= 0;

            ex_finish_reg <= 0;
            mem_finish_reg <= 0;

            rs2_data_reg <= 0;
            rd_reg <= 0;
            
            alu_data_reg <= 0;
        end
        else begin 
            reg_write_reg <= reg_write; 

            mem_write_reg <= mem_write;
            mem_read_reg <= mem_read;
            mem_op_reg <= mem_op;

            mem_2_reg_reg <= mem_2_reg;

            ex_finish_reg <= ex_finish;
            mem_finish_reg <= mem_finish;

            rs2_data_reg <= rs2_data;
            rd_reg <= rd;

            alu_data_reg <= alu_data;
        end
    end        

    assign reg_write_out = reg_write_reg;
    
    assign mem_write_out = mem_write_reg; 
    assign mem_read_out = mem_read_reg;
    assign mem_op_out = mem_op_reg;

    assign mem_2_reg_out = mem_2_reg_reg;

    assign ex_finish_out = ex_finish_reg;
    assign mem_finish_out = mem_finish_reg;

    assign rs2_data_out = rs2_data_reg;
    assign rd_out = rd_reg;

    assign alu_data_out = alu_data_reg;

endmodule
