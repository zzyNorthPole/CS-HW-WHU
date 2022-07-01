module wbMux(
    input mem_2_reg,
    input [31:0] alu_data,
    input [31:0] mem_data,

    output [31:0] rd_data
);
    
    assign rd_data = mem_2_reg ? mem_data : alu_data;

endmodule
