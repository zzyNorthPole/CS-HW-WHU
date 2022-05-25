`define byte_op 3'b000
`define halfword_op 3'b001
`define word_op 3'b010
`define byte_unsigned_op 3'b100
`define halfword_unsigned_op 3'b101

module DATAMEM(
    input clk,
    input rst,
    input memwrite,
    input memread,
    input [2:0] memop,
    input [8:0] memaddr,
    input [31:0] memdatain,

    output reg [31:0] memdataout
);
    
    integer i, j;
    reg [7:0] ROM[511:0];
    
    
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 512; i = i + 1)
                ROM[i] <= 8'b0;
        end
        if (memwrite) begin
            case (memop)
            `byte_op: ROM[memaddr] <= memdatain[7:0];
            `halfword_op: {ROM[memaddr + 1], ROM[memaddr]} <= memdatain[15:0];
            `word_op: {ROM[memaddr + 3], ROM[memaddr + 2], ROM[memaddr + 1], ROM[memaddr]} <= memdatain[31:0];
            endcase
            //$display("Mem: %h %h %h", memdatain, memaddr, {ROM[3], ROM[2], ROM[1], ROM[0]});
        end
    end
    always @(*) begin
        if (memread) begin
            case (memop)
            `byte_op: memdataout <= {{24{ROM[memaddr][7]}}, ROM[memaddr]};
            `halfword_op: memdataout <= {{16{ROM[memaddr + 1][7]}}, ROM[memaddr + 1], ROM[memaddr]};
            `word_op: memdataout <= {ROM[memaddr + 3], ROM[memaddr + 2], ROM[memaddr + 1], ROM[memaddr]};
            `byte_unsigned_op: memdataout <= {24'b0, ROM[memaddr]};
            `halfword_unsigned_op: memdataout <= {16'b0, ROM[memaddr + 1], ROM[memaddr]};
            default: memdataout <= 32'b0;
            endcase
        end
        else begin
            memdataout <= 32'b0;
        end
    end
    /*
    reg [31:0] tmp;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 512; i = i + 1)
                ROM[i] <= 8'b0;
        end
        if (memwrite) begin
            case (memop)
            `byte_op: ROM[memaddr] <= memdatain[7:0];
            `halfword_op: {ROM[memaddr + 1], ROM[memaddr]} <= memdatain[15:0];
            `word_op: {ROM[memaddr + 3], ROM[memaddr + 2], ROM[memaddr + 1], ROM[memaddr]} <= memdatain[31:0];
            endcase
            //$display("Mem: %h %h %h", memdatain, memaddr, {ROM[3], ROM[2], ROM[1], ROM[0]});
        end
    end

    assign memdataout = (
        memread ? 
        {
            (memop == `byte_op) ?
            {{24{ROM[memaddr][7]}}, ROM[memaddr]} :
            (memop == `halfword_op) ?
            {{16{ROM[memaddr + 1][7]}}, ROM[memaddr + 1], ROM[memaddr]} :
            (memop == `word_op) ?
            {ROM[memaddr + 3], ROM[memaddr + 2], ROM[memaddr + 1], ROM[memaddr]} :
            (memop == `byte_unsigned_op) ?
            {24'b0, ROM[memaddr]} :
            (memop == `halfword_unsigned_op) ?
            {16'b0, ROM[memaddr + 1], ROM[memaddr]} :
            32'b0
        } :
        32'b0
    );
    */
endmodule