module MUXREG(
    input [31:0] aludataout,
    input [31:0] memdataout,
    input mem2reg,
    
    output [31:0] regdata
);

    assign regdata = mem2reg ? memdataout : aludataout;

endmodule