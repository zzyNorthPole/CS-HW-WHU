module MUXREG(
    input [31:0] alu_data,
    input [31:0] mem_data,
    input reg_write_type,

    output [31:0] reg_data
);

    assign reg_data = (reg_write_type ? mem_data : alu_data);

endmodule