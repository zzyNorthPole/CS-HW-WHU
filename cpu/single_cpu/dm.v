module DM(
    input clk,
    input dm_read,
    input dm_write,
    input [14:12] dmop,
    input [8:0] addr,
    input [31:0] din,
    output [31:0] dout    
);

    reg [7:0] dmem[511:0];

    always @(posedge clk) begin
        if (dm_write) begin
            case (dmop)
            3'b000:
                dmem[addr] <= din[7:0];
            3'b001:
                {dmem[addr], dmem[addr + 1]} <= din[15:0];
            3'b010:
                {dmem[addr], dmem[addr + 1], dmem[addr + 2], dmem[addr + 3]} <= din[31:0];
            endcase
            $display("dmem[0x%8X] = 0x%*X,", addr << 2, din);
        end
    end

    always @(posedge clk) begin
        if (dm_read) begin
        case (dmop)
            3'b000:
                dout <= {24{dmem[addr][7]}, dmem[addr]};    
            3'b001:
                dout <= {16{dmem[addr + 1][7]}, dmem[addr + 1], dmem[addr]};
            3'b010:
                dout <= {dmem[addr + 3], dmem[addr + 2], dmem[addr + 1], dmem[addr]};
            3'b100:
                dout <= {24'b0, dmem[addr]};
            3'b101:
                dout <= {12'b0, dmem[addr + 1], dmem[addr]};
            endcase
        end
    end

endmodule