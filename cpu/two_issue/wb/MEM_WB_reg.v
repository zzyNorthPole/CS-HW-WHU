module MEM_WB_reg (
    input clk,
    input rst,

    input reg_write,

    input mem_2_reg,

    input [4:0] rd,

    input [31:0] alu_data,
    input [31:0] mem_data,

    output reg_write_out,

    output mem_2_reg_out,
    
    output [4:0] rd_out,

    output [31:0] alu_data_out,
    output [31:0] mem_data_out
);

    reg reg_write_reg;

    reg mem_2_reg_reg;

    reg [4:0] rd_reg;

    reg [31:0] alu_data_reg;
    reg [31:0] mem_data_reg;

    always @(posedge clk) begin
        if (rst) begin
            reg_write_reg <= 0; 

            mem_2_reg_reg <= 0;

            rd_reg <= 0;
            
            alu_data_reg <= 0;
        end
        else begin 
            reg_write_reg <= reg_write; 

            mem_2_reg_reg <= mem_2_reg;

            rd_reg <= rd;

            alu_data_reg <= alu_data;
            mem_data_reg <= mem_data;
        end
    end        

    
    assign reg_write_out = reg_write_reg;

    assign mem_2_reg_out = mem_2_reg_reg;

    assign rd_out = rd_reg;

    assign alu_data_out = alu_data_reg;
    assign mem_data_out = mem_data_reg;

endmodule
