module IMMGEN(
    input [31:0] ins;
    output [31:0] imm;
);
    
    always (*) begin
        if (ins[3:2] == 2'b00) begin
            if (ins[5]) begin
                if (ins[6])
                    imm <= {20{ins[31]}, ins[7], ins[30:25], ins[11:8], 1'b0};
                else 
                    imm <= {20{ins[31]}, ins[31:25], ins[11:7]};
            end
            else begin
                if (ins[4] && (ins[14:12] == 3'b101))
                    imm <= {27'b0, ins[24:20]};
                else 
                    imm <= {20{ins[31]}, ins[31:20]};
            end
        end
        else begin
            case (ins[4:3])
            2'b00:
                imm <= {20{ins[31]}, ins[31:20]};
            2'b01:
                imm <= {12{ins[31]}, ins[19:12], ins[20], ins[30:21], 1'b0};
            2'b10:
                imm <= {ins[31:12], 12'b0};
            default:
                imm <= 32'b0;
            endcase
        end
    end

endmodule