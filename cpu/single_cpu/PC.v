module PC(
    input clk,
    input rst,
    input [31:0] npc,
    
    output reg [31:0] pc
);
    always @(posedge clk) begin
        if (rst) pc <= 32'b0;
        else pc <= npc;
    end
endmodule