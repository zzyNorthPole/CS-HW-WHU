module CPU(
    input clk,
    input rst,
    
    output [31:0] pc,
    input [31:0] ins,

    output memwrite, memread,
    output [2:0] memop,
    output [8:0] memaddr,
    output [31:0] memdatain,
    input [31:0] memdataout    
);
    
    //Control
    wire regwrite;
    wire [1:0] alusrc1, alusrc2;
    wire [5:0] aluop;
    wire mem2reg;
    wire [1:0] pcsrc;

    //RegFile
    wire [31:0] regdata, regdata1, regdata2;

    //ImmGen
    wire [31:0] imm;

    //MuxRs
    wire [31:0] aludatain1, aludatain2;

    //ALU
    wire [31:0] aludataout;
    wire aluzero;
    
    //NPC
    wire [31:0] npc;

    CTRL Ctrl(
        .opcode(ins[6:0]), .func3(ins[14:12]), .func7(ins[31:25]), 
        .regwrite(regwrite), 
        .alusrc1(alusrc1), .alusrc2(alusrc2), 
        .aluop(aluop), 
        .memwrite(memwrite), .memread(memread), .memop(memop), 
        .mem2reg(mem2reg), 
        .pcsrc(pcsrc)
    );
    
    REGFILE RegFile(
        .clk(clk), .rst(rst), 
        .regwrite(regwrite), .memwrite(memwrite), 
        .rs1(ins[19:15]), .rs2(ins[24:20]), .rd(ins[11:7]), 
        .regdata(regdata), 
        .regdata1(regdata1), .regdata2(regdata2)
    );
    IMMGEN ImmGen(.ins(ins), .imm(imm));

    MUXRS1 MuxRs1(
        .regdata1(regdata1), .pc(pc),
        .alusrc1(alusrc1), 
        .aludatain1(aludatain1)
    );
    MUXRS2 MuxRs2(
        .regdata2(regdata2), .imm(imm), 
        .alusrc2(alusrc2),
        .aludatain2(aludatain2)
    );

    ALU Alu(
        .aludatain1(aludatain1), .aludatain2(aludatain2),
        .aluop(aluop),
        .aludataout(aludataout), .aluzero(aluzero)
    );

    assign memaddr = aludataout[8:0];
    assign memdatain = regdata2;

    MUXREG MuxReg(
        .aludataout(aludataout), .memdataout(memdataout), 
        .mem2reg(mem2reg),
        .regdata(regdata)
    );

    NPC Npc(
        .pc(pc), .imm(imm), .regdata1(regdata1), 
        .pcsrc(pcsrc), .aluzero(aluzero),
        .npc(npc)
    );

    PC Pc(
        .clk(clk), .rst(rst),
        .npc(npc),
        .pc(pc)
    );

endmodule