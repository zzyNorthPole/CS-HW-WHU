`define lb_func3 3'b000
`define lh_func3 3'b001
`define lw_func3 3'b010
`define lbu_func3 3'b100
`define lhu_func3 3'b101

`define sb_func3 3'b000
`define sh_func3 3'b001
`define sw_func3 3'b010

module cpu2Mem(
    input mem_read, //not_used
    input mem_write,
    input [2:0] mem_op,

    input [31:0] mem_addr_in,
    input [31:0] mem_data_in,

   // output [3:0] mem_w,
    output mem_w,
    output [3:0] wea,

    output [31:0] mem_addr_out,
    output [31:0] mem_data_out,

    input [31:0] data_from_mem_in,
    output [31:0] data_from_mem_out
);
    assign mem_addr_out = mem_addr_in;
    assign mem_data_out = mem_data_in;

   // assign mem_w = mem_write ? 
    assign mem_w = mem_write;
    assign wea = mem_write ? 
                (
                    ({4{mem_op == `sb_func3}} & 4'b0001) |
                    ({4{mem_op == `sh_func3}} & 4'b0011) |
                    ({4{mem_op == `sw_func3}} & 4'b1111)
                ) :
                    4'b0000
                ;
    assign data_from_mem_out =  {32{(mem_op == `lb_func3)}} & {{24{data_from_mem_in[7]}}, data_from_mem_in[7:0]} |
                                {32{(mem_op == `lh_func3)}} & {{16{data_from_mem_in[15]}}, data_from_mem_in[15:0]} |
                                {32{(mem_op == `lw_func3)}} & data_from_mem_in |
                                {32{(mem_op == `lbu_func3)}} & {24'b0, data_from_mem_in[7:0]} |
                                {32{(mem_op == `lhu_func3)}} & {16'b0, data_from_mem_in[15:0]};
endmodule
