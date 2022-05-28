#include <stdio.h>
#include <string.h>

#define lui_op 0x37
#define auipc_op 0x17
#define jal_op 0x6f
#define jalr_op 0x67
#define branch_op 0x63
#define load_op 0x3
#define store_op 0x23
#define ri_op 0x13
#define r_op 0x33

int cmp(char *a, char *b) {
    int lena = strlen(a), lenb = strlen(b);
    if (lena != lenb) return 0;
    for (int i = 0; i < lena; ++i) {
        if (a[i] != b[i]) return 0;
    }
    return 1;
}

#define lui_auipc_imm(imm) (imm << 12)
#define jal_imm(imm) (((imm >> 20) << 31) | (((imm >> 1) & 0x3ff) << 21) | (((imm >> 11) & 0x1) << 20) | (((imm >> 12) & 0xff) << 12))
#define jalr_load_ri_imm(imm) (imm << 20)
#define store_imm_1(imm) ((imm >> 5) << 25)
#define store_imm_2(imm) ((imm & 0x1f) << 7)
#define branch_imm_1(imm) (((imm >> 12) << 31) | (((imm >> 5) & 0x3f) << 25))
#define branch_imm_2(imm) ((((imm >> 1) & 0xf) << 8) | (((imm >> 11) & 0x1) << 7))
#define slli_srli_srai_imm(imm) ((imm & 0x1f) << 20)

#define rd_op(rd) (rd << 7)
#define rs1_op(rs1) (rs1 << 15)
#define rs2_op(rs2) (rs2 << 20)
#define func3_op(func3) (func3 << 12)
#define func7_op(func7) (func7 << 25)

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

void as(char *opcode) {
    int Lui = cmp(opcode, "lui");
    int Auipc = cmp(opcode, "auipc");
    int Jal = cmp(opcode, "jal");
    int Jalr = cmp(opcode, "jalr");

    int Beq = cmp(opcode, "beq");
    int Bne = cmp(opcode, "bne");
    int Blt = cmp(opcode, "blt");
    int Bge = cmp(opcode, "bge");
    int Bltu = cmp(opcode, "bltu");
    int Bgeu = cmp(opcode, "bgeu");
    int Branch = Beq | Bne | Blt | Bge | Bltu | Bgeu;

    int Lb = cmp(opcode, "lb");
    int Lh = cmp(opcode, "lh");
    int Lw = cmp(opcode, "lw");
    int Lbu = cmp(opcode, "lbu");
    int Lhu = cmp(opcode, "lhu");
    int Load = Lb | Lh | Lw | Lbu | Lhu;

    int Sb = cmp(opcode, "sb");
    int Sh = cmp(opcode, "sh");
    int Sw = cmp(opcode, "sw");
    int Store = Sb | Sh | Sw;

    int Addi = cmp(opcode, "addi");
    int Slti = cmp(opcode, "slti");
    int Sltiu = cmp(opcode, "sltiu");
    int Xori = cmp(opcode, "xori");
    int Ori = cmp(opcode, "ori");
    int Andi = cmp(opcode, "andi");
    int Slli = cmp(opcode, "slli");
    int Srli = cmp(opcode, "srli");
    int Srai = cmp(opcode, "srai");
    int Ri = Addi | Slti | Sltiu | Xori | Ori | Andi | Slli | Srli | Srai;

    int Add = cmp(opcode, "add");
    int Sub = cmp(opcode, "sub");
    int Sll = cmp(opcode, "sll");
    int Slt = cmp(opcode, "slt");
    int Sltu = cmp(opcode, "sltu");
    int Xor = cmp(opcode, "xor");
    int Srl = cmp(opcode, "srl");
    int Sra = cmp(opcode, "sra");
    int Or = cmp(opcode, "or");
    int And = cmp(opcode, "and");
    int R = Add | Sub | Sll | Slt | Sltu | Xor | Srl | Sra | Or | And;
    
    int ins = 0;
    int rd, rs1, rs2, imm, func3 = 0, func7 = 0;
    if (Lui) {
        scanf(" x%d, %d", &rd, &imm);
        ins = lui_op | rd_op(rd) | lui_auipc_imm(imm);
    }
    else if (Auipc) {
        scanf(" x%d, %d", &rd, &imm);
        ins = auipc_op | rd_op(rd) | lui_auipc_imm(imm);
    }
    else if (Jal) {
        scanf(" x%d, %d", &rd, &imm);
        ins = jal_op | rd_op(rd) | jal_imm(imm);
    }
    else if (Jalr) {
        scanf(" x%d, x%d, %d", &rd, &rs1, &imm);
        ins = jalr_op | rd_op(rd) | rs1_op(rs1) | jalr_load_ri_imm(imm);
    }
    else if (Branch) {
        scanf(" x%d, x%d, %d", &rs1, &rs2, &imm);
        if (Beq) func3 = beq_op;
        else if (Bne) func3 = bne_op;
        else if (Blt) func3 = blt_op;
        else if (Bge) func3 = bge_op;
        else if (Bltu) func3 = bltu_op;
        else if (Bgeu) func3 = bgeu_op;
        ins = branch_op | branch_imm_2(imm) | func3_op(func3) | rs1_op(rs1) | rs2_op(rs2) | branch_imm_1(imm);
    }
    else if (Load) {
        scanf(" x%d, %d(x%d)", &rd, &imm, &rs1);
        if (Lb) func3 = lb_op;
        else if (Lh) func3 = lh_op;
        else if (Lw) func3 = lw_op;
        else if (Lbu) func3 = lbu_op;
        else if (Lhu) func3 = lhu_op;
        ins = load_op | rd_op(rd) | func3_op(func3) | rs1_op(rs1) | jalr_load_ri_imm(imm);
    }
    else if (Store) {
        scanf(" x%d, %d(x%d)", &rs2, &imm, &rs1);
        if (Sb) func3 = sb_op;
        else if (Sh) func3 = sh_op;
        else if (Sw) func3 = sw_op;
        ins = store_op | store_imm_2(imm) | func3_op(func3) | rs1_op(rs1) | rs2_op(rs2) | store_imm_1(imm);
    }
    else if (Ri) {
        scanf(" x%d, x%d, %d", &rd, &rs1, &imm);
        if (Addi) func3 = add_sub_op;
        else if (Slti) func3 = slt_op;
        else if (Sltiu) func3 = sltu_op;
        else if (Xori) func3 = xor_op;
        else if (Ori) func3 = or_op;
        else if (Andi) func3 = and_op;
        else if (Slli) func3 = sll_op;
        else if (Srli) func3 = srl_sra_op;
        else if (Srai) func3 = srl_sra_op, func7 = sub_sra_op;
        if (Slli | Srli | Srai) ins = ri_op | rd_op(rd) | func3_op(func3) | rs1_op(rs1) | slli_srli_srai_imm(imm) | func7_op(func7);
        else ins = ri_op | rd_op(rd) | func3_op(func3) | rs1_op(rs1) | jalr_load_ri_imm(imm);
    }
    else if (R) {
        scanf(" x%d, x%d, x%d", &rd, &rs1, &rs2);
        if (Add) func3 = add_sub_op, func7 = add_srl_op;
        else if (Sub) func3 = add_sub_op, func7 = sub_sra_op;
        else if (Sll) func3 = sll_op;
        else if (Slt) func3 = slt_op;
        else if (Sltu) func3 = sltu_op;
        else if (Xor) func3 = xor_op;
        else if (Srl) func3 = srl_sra_op, func7 = add_srl_op;
        else if (Sra) func3 = srl_sra_op, func7 = sub_sra_op;
        else if (Or) func3 = or_op;
        else if (And) func3 = and_op;
        ins = r_op | rd_op(rd) | func3_op(func3) | rs1_op(rs1) | rs2_op(rs2) | func7_op(func7);
    }
    printf("%x\n", ins);
}

int main() {
    char opcode[6];
    while (scanf("%s", opcode)) as(opcode);
    return 0;
}