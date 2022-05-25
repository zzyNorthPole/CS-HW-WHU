module CIRCLE(
    input clk,
    input rst
);

    wire [31:0] pc;
    wire [31:0] ins;

    wire memwrite, memread;
    wire [2:0] memop;
    wire [8:0] memaddr;
    wire [31:0] memdatain, memdataout;

    CPU Cpu(
        .clk(clk), .rst(rst), 
        .pc(pc), .ins(ins), 
        .memwrite(memwrite), .memread(memread), .memop(memop),
        .memaddr(memaddr), .memdatain(memdatain), .memdataout(memdataout)
    );
    
    INSMEM InsMem(.pc(pc), .ins(ins));
    
    DATAMEM DataMem(
        .clk(clk), .rst(rst),
        .memwrite(memwrite), .memread(memread), .memop(memop),
        .memaddr(memaddr), .memdatain(memdatain), .memdataout(memdataout)
    );

endmodule