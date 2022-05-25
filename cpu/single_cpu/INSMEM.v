module INSMEM(
    input [31:0] pc,
    output [31:0] ins
);

    reg [31:0] ROM[127:0];  

    assign ins = ROM[pc[8:2]];
    
endmodule