module IM(
    input [8:2] addr,
    output [31:0] ins
);
    
    reg [31:0] ROM[127:0];

    assign ins = ROM[addr];

endmodule