module REGFILE(
    input clk, 
    input rst,
    input regwrite,
    input memwrite,
    input [4:0] rs1, rs2, rd,
    input [31:0] regdata,

    output [31:0] regdata1, regdata2
);

    reg [31:0] regf[31:0];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regf[i] <= 32'b0;
        end
        else begin
            if (regwrite && rd) regf[rd] <= regdata;
        end
    end

    assign regdata1 = regf[rs1];
    assign regdata2 = regf[rs2];
    
endmodule