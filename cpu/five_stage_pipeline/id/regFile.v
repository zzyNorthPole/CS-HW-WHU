module regFile (
    input clk,
    input rst,

    input reg_write,

    input [4:0] rs1,
    input [4:0] rs2,

    output [31:0] rs1_data,
    output [31:0] rs2_data,

    input [4:0] rd,
    input [31:0] rd_data
);

    reg [31:0] reg_array[31:0];

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                reg_array[i] <= 32'b0;
        end
        else if (reg_write) begin
            reg_array[rd] <= (rd == 5'b0) ? 32'b0 : rd_data;
            if (rd != 5'b0)
                $display("r[%2d] = 0x%8X,", rd, rd_data);
        end
    end

    assign rs1_data = (rs1 == 0) ? 32'b0 : reg_array[rs1];
    assign rs2_data = (rs2 == 0) ? 32'b0 : reg_array[rs2];

endmodule
