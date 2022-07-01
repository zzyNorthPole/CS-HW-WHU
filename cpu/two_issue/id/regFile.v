module regFile (
    input clk,
    input rst,

    input reg_write_1,
    input reg_write_2,

    input [4:0] rs1_1,
    input [4:0] rs2_1,
    input [4:0] rs1_2,
    input [4:0] rs2_2,

    output [31:0] rs1_data_1,
    output [31:0] rs2_data_1,
    output [31:0] rs1_data_2,
    output [31:0] rs2_data_2,

    input [4:0] rd_1,
    input [31:0] rd_data_1,
    input [4:0] rd_2,
    input [31:0] rd_data_2
);

    reg [31:0] reg_array[31:0];

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                reg_array[i] <= 32'b0;
        end
        else begin
            if (reg_write_1 || reg_write_2) begin
                if (reg_write_1 && reg_write_2) begin
                    if (rd_1 == rd_2) begin
                        reg_array[rd_2] <= (rd_2 == 5'b0) ? 32'b0 : rd_data_2;
//                        if (rd_2 != 5'b0) begin
//                            $display("r[%2d] = 0x%8X,", rd_1, rd_data_1);
//                            $display("r[%2d] = 0x%8X,", rd_2, rd_data_2);
//                        end
                    end
                    else begin 
                        reg_array[rd_1] <= (rd_1 == 5'b0) ? 32'b0 : rd_data_1;
                        reg_array[rd_2] <= (rd_2 == 5'b0) ? 32'b0 : rd_data_2;
//                        if (rd_1 != 5'b0)
//                            $display("r[%2d] = 0x%8X,", rd_1, rd_data_1);
//                        if (rd_2 != 5'b0) 
//                            $display("r[%2d] = 0x%8X,", rd_2, rd_data_2);
                    end
                end
                else begin
                    if (reg_write_1) begin 
                        reg_array[rd_1] <= (rd_1 == 5'b0) ? 32'b0 : rd_data_1;
//                        if (rd_1 != 5'b0)
//                            $display("r[%2d] = 0x%8X,", rd_1, rd_data_1);
                    end
                    if (reg_write_2) begin    
                        reg_array[rd_2] <= (rd_2 == 5'b0) ? 32'b0 : rd_data_2;
//                        if (rd_2 != 5'b0)
//                            $display("r[%2d] = 0x%8X,", rd_2, rd_data_2);
                    end
                end
            end
        end
    end

    assign rs1_data_1 = (rs1_1 == 5'b0) ? 32'b0 : reg_array[rs1_1];
    assign rs2_data_1 = (rs2_1 == 5'b0) ? 32'b0 : reg_array[rs2_1];
    assign rs1_data_2 = (rs1_2 == 5'b0) ? 32'b0 : reg_array[rs1_2];
    assign rs2_data_2 = (rs2_2 == 5'b0) ? 32'b0 : reg_array[rs2_2];

endmodule
