module PC(
    input clk;
    input rst;
    input [31:0] npc;
    output [31:0] pc;
);

    always @(posedge clk, posedge rst)
    begin
       if (rst)
            pc <= 32'h00000000;
        else
            pc <= npc; 
    end
    
endmodule