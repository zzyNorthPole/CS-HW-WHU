#include <stdio.h>

#define lui_op 0x37
#define auipc_op 0x17
#define jal_op 0x6f
#define jalr_op 0x67
#define branch_op 0x63
#define load_op 0x3
#define store_op 0x23
#define ri_op 0x13
#define r_op 0x33

#define lui_auipc_imm(ins) ((ins >> 12) & 0xfffff)
#define jal_imm(ins) (((ins >> 31) << 20) | (((ins >> 21) & 0x3ff) << 1) | (((ins >> 20) & 0x1) << 11) | (((ins >> 12) & 0xff) << 12))
#define jalr_load_ri_imm(ins) (ins >> 20)
#define store_imm(ins) (((ins >> 25) << 5) | ((ins >> 7) & 0x1f))
#define branch_imm(ins) (((ins >> 31) << 12) | (((ins >> 25) & 0x3f) << 5) | (((ins >> 8) & 0xf) << 1) | (((ins >> 7) & 0x1) << 11))
#define slli_srli_srai_imm(ins) ((ins >> 20) & 0x1f)

#define beq_op 0
#define bne_op 1
#define blt_op 4
#define bge_op 5
#define bltu_op 6
#define bgeu_op 7

#define lb_op 0
#define lh_op 1
#define lw_op 2
#define lbu_op 4
#define lhu_op 5

#define sb_op 0
#define sh_op 1
#define sw_op 2

#define add_sub_op 0
#define sll_op 1
#define slt_op 2
#define sltu_op 3
#define xor_op 4
#define srl_sra_op 5
#define or_op 6
#define and_op 7
#define add_srl_op 0
#define sub_sra_op 0x20

void objdump(int ins) {
	int opcode, rd, rs1, rs2, func3, func7, imm;
	opcode = ins & 0x7f;
	rd = (ins >> 7) & 0x1f;
	func3 = (ins >> 12) & 0x7;
	rs1 = (ins >> 15) & 0x1f;
	rs2 = (ins >> 20) & 0x1f;
	func7 = (ins >> 25) & 0x7f;
	switch (opcode) {
	case lui_op:
		imm = lui_auipc_imm(ins);
		printf("lui x%d, %d\n", rd, imm);
		break;
	case auipc_op:
		imm = lui_auipc_imm(ins);
		printf("auipc x%d, %d\n", rd, imm);
		break;
	case jal_op:
		imm = jal_imm(ins);
		printf("jal x%d, %d\n", rd, imm);
		break;
	case jalr_op:
		imm = jalr_load_ri_imm(ins);
		printf("jalr x%d, x%d, %d\n", rd, rs1, imm);
		break;
	case branch_op:
		imm = branch_imm(ins);
		switch (func3) {
		case beq_op:
			printf("beq ");
			break;
		case bne_op:
			printf("bne ");
			break;
		case blt_op:
			printf("blt ");
			break;
		case bge_op:
			printf("bge ");
			break;
		case bltu_op:
			printf("bltu ");
			break;
		case bgeu_op:
			printf("bgeu ");
			break;
		}
		printf("x%d, x%d, %d\n", rs1, rs2, imm);
		break;
	case load_op:
		imm = jalr_load_ri_imm(ins);
		switch (func3) {
		case lb_op:
			printf("lb ");
			break;
		case lh_op:
			printf("lh ");
			break;
		case lw_op:
			printf("lw ");
			break;
		case lbu_op:
			printf("lbu ");
			break;
		case lhu_op:
			printf("lhu ");
			break;
		}
		printf("x%d, %d(x%d)\n", rd, imm, rs1);
		break;
	case store_op:
		imm = store_imm(ins);
		switch (func3) {
		case sb_op:
			printf("sb ");
			break;
		case sh_op:
			printf("sh ");
			break;
		case sw_op:
			printf("sw ");
			break;
		}
		printf("x%d, %d(x%d)\n", rs2, imm, rs1);
		break;
	case ri_op:
		imm = (func3 == sll_op || func3 == srl_sra_op) ? slli_srli_srai_imm(ins) : jalr_load_ri_imm(ins);
		switch (func3) {
		case add_sub_op:
			printf("addi ");
			break;
		case slt_op:
			printf("slti ");
			break;
		case sltu_op:
			printf("sltiu ");
			break;
		case xor_op:
			printf("xori ");
			break;
		case or_op:
			printf("ori ");
			break;
		case and_op:
			printf("andi ");
			break;
		case sll_op:
			printf("slli ");
			break;
		case srl_sra_op:
			if (!func7) printf("srli ");
			else printf("srai ");
			break;
		}
		printf("x%d, x%d, %d\n", rd, rs1, imm);
		break;
	case r_op:
		switch (func3) {
		case add_sub_op:
			if (!func7) printf("add ");
			else printf("sub ");
			break;
		case sll_op:
			printf("sll ");
			break;
		case slt_op:
			printf("slt ");
			break;
		case sltu_op:
			printf("sltu ");
			break;
		case xor_op:
			printf("xor ");
			break;
		case srl_sra_op:
			if (!func7) printf("srl ");
			else printf("sra ");
			break;
		case or_op:
			printf("or ");
			break;
		case and_op:
			printf("and ");
			break;
		}
		printf("x%d, x%d, x%d\n", rd, rs1, rs2);
		break;
	}
}

int main() {
	int ins;
	while (scanf("%x", &ins) != EOF) objdump(ins);
	return 0;
}