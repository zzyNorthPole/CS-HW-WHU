module RF(
    input rst,
    input reg_write,
    input reg_change,
    input [4:1] reg1, reg2, reg3,
    input [31:0] data,

    output [31:0] rs1, rs2
);

    reg [31:0] regf[31:0];
    integer i;    

    assign regf[0] = 32'b0;

    always @(*) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regf[i] <= 32'b0;
        end
        else begin
            if (reg_write) regf[reg3] = data;
        end
    end

    assign rs1 = (reg_change ? regf[reg2] : regf[reg1]);
    assign rs2 = (reg_change ? regf[reg1] : regf[reg2]);

endmodule