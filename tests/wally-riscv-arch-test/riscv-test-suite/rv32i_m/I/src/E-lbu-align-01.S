// -----------
// This file was generated by riscv_ctg (https://gitlab.com/incoresemi/riscv-compliance/riscv_ctg)
// version   : 0.5.1
// timestamp : Mon Aug  2 08:58:53 2021 GMT
// usage     : riscv_ctg \
//                  --cgf /home/bilalsakhawat/riscv-ctg/sample_cgfs/dataset.cgf \
//                  --cgf /home/bilalsakhawat/riscv-ctg/sample_cgfs/rv32e.cgf \
//                  --base-isa rv32e \
//                  --randomize
// -----------
//
// -----------
// Copyright (c) 2020. RISC-V International. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// -----------
//
// This assembly file tests the lbu instruction of the RISC-V E extension for the lbu-align covergroup.
// 
#define RVTEST_E
#include "model_test.h"
#include "arch_test.h"
RVTEST_ISA("RV32E")

.section .text.init
.globl rvtest_entry_point
rvtest_entry_point:
RVMODEL_BOOT
RVTEST_CODE_BEGIN

#ifdef TEST_CASE_1

RVTEST_CASE(0,"//check ISA:=regex(.*32.*);check ISA:=regex(.*E.*) ;def RVTEST_E = True;def TEST_CASE_1=True;",lbu-align)

RVTEST_SIGBASE( x1,signature_x1_1)

inst_0:
// rs1 != rd, rs1==x14, rd==x0, ea_align == 0 and (imm_val % 4) == 0, imm_val > 0
// opcode:lbu op1:x14; dest:x0; immval:0x100; align:0
TEST_LOAD(x1,x8,0,x14,x0,0x100,0,lbu,0)

inst_1:
// rs1 == rd, rs1==x13, rd==x13, ea_align == 0 and (imm_val % 4) == 1, imm_val < 0
// opcode:lbu op1:x13; dest:x13; immval:-0x7; align:0
TEST_LOAD(x1,x8,0,x13,x13,-0x7,4,lbu,0)

inst_2:
// rs1==x2, rd==x3, ea_align == 0 and (imm_val % 4) == 2, 
// opcode:lbu op1:x2; dest:x3; immval:0x6; align:0
TEST_LOAD(x1,x8,0,x2,x3,0x6,8,lbu,0)

inst_3:
// rs1==x5, rd==x11, ea_align == 0 and (imm_val % 4) == 3, 
// opcode:lbu op1:x5; dest:x11; immval:-0x9; align:0
TEST_LOAD(x1,x8,0,x5,x11,-0x9,12,lbu,0)

inst_4:
// rs1==x4, rd==x15, ea_align == 1 and (imm_val % 4) == 0, 
// opcode:lbu op1:x4; dest:x15; immval:-0x4; align:1
TEST_LOAD(x1,x8,0,x4,x15,-0x4,16,lbu,1)

inst_5:
// rs1==x6, rd==x9, ea_align == 1 and (imm_val % 4) == 1, 
// opcode:lbu op1:x6; dest:x9; immval:0x1; align:1
TEST_LOAD(x1,x8,0,x6,x9,0x1,20,lbu,1)

inst_6:
// rs1==x9, rd==x7, ea_align == 1 and (imm_val % 4) == 2, 
// opcode:lbu op1:x9; dest:x7; immval:0x6; align:1
TEST_LOAD(x1,x8,0,x9,x7,0x6,24,lbu,1)

inst_7:
// rs1==x10, rd==x8, ea_align == 1 and (imm_val % 4) == 3, 
// opcode:lbu op1:x10; dest:x8; immval:-0x201; align:1
TEST_LOAD(x1,x13,0,x10,x8,-0x201,28,lbu,1)
RVTEST_SIGBASE( x9,signature_x9_0)

inst_8:
// rs1==x11, rd==x1, ea_align == 2 and (imm_val % 4) == 0, 
// opcode:lbu op1:x11; dest:x1; immval:0x4; align:2
TEST_LOAD(x9,x13,0,x11,x1,0x4,0,lbu,2)

inst_9:
// rs1==x3, rd==x4, ea_align == 2 and (imm_val % 4) == 1, 
// opcode:lbu op1:x3; dest:x4; immval:-0x7; align:2
TEST_LOAD(x9,x13,0,x3,x4,-0x7,4,lbu,2)

inst_10:
// rs1==x1, rd==x6, imm_val == 0, 
// opcode:lbu op1:x1; dest:x6; immval:0x0; align:0
TEST_LOAD(x9,x13,0,x1,x6,0x0,8,lbu,0)

inst_11:
// rs1==x8, rd==x10, ea_align == 2 and (imm_val % 4) == 2, 
// opcode:lbu op1:x8; dest:x10; immval:-0x2; align:2
TEST_LOAD(x9,x13,0,x8,x10,-0x2,12,lbu,2)

inst_12:
// rs1==x12, rd==x2, ea_align == 2 and (imm_val % 4) == 3, 
// opcode:lbu op1:x12; dest:x2; immval:-0x401; align:2
TEST_LOAD(x9,x13,0,x12,x2,-0x401,16,lbu,2)

inst_13:
// rs1==x7, rd==x5, ea_align == 3 and (imm_val % 4) == 0, 
// opcode:lbu op1:x7; dest:x5; immval:0x4; align:3
TEST_LOAD(x9,x13,0,x7,x5,0x4,20,lbu,3)

inst_14:
// rs1==x15, rd==x14, ea_align == 3 and (imm_val % 4) == 1, 
// opcode:lbu op1:x15; dest:x14; immval:0x9; align:3
TEST_LOAD(x9,x2,0,x15,x14,0x9,24,lbu,3)
RVTEST_SIGBASE( x1,signature_x1_2)

inst_15:
// rd==x12, ea_align == 3 and (imm_val % 4) == 2, 
// opcode:lbu op1:x14; dest:x12; immval:-0x2; align:3
TEST_LOAD(x1,x2,0,x14,x12,-0x2,0,lbu,3)

inst_16:
// ea_align == 3 and (imm_val % 4) == 3, 
// opcode:lbu op1:x10; dest:x11; immval:-0x5; align:3
TEST_LOAD(x1,x2,0,x10,x11,-0x5,4,lbu,3)
#endif


RVTEST_CODE_END
RVMODEL_HALT

RVTEST_DATA_BEGIN
.align 4
rvtest_data:
.word 0xbabecafe
RVTEST_DATA_END

RVMODEL_DATA_BEGIN


signature_x1_0:
    .fill 0*(XLEN/32),4,0xdeadbeef


signature_x1_1:
    .fill 8*(XLEN/32),4,0xdeadbeef


signature_x9_0:
    .fill 7*(XLEN/32),4,0xdeadbeef


signature_x1_2:
    .fill 2*(XLEN/32),4,0xdeadbeef

#ifdef rvtest_mtrap_routine

mtrap_sigptr:
    .fill 64*(XLEN/32),4,0xdeadbeef

#endif

#ifdef rvtest_gpr_save

gpr_save:
    .fill 32*(XLEN/32),4,0xdeadbeef

#endif

RVMODEL_DATA_END
