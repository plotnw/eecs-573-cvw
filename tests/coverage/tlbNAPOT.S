///////////////////////////////////////////
// tlbNAPOT.S
//
// Written: mmendozamanriquez@hmc.edu 4 April 2023
//          nlimpert@hmc.edu
// Adapted David_Harris@hmc.edu 8/29/23 to exercise NAPOT huge pages
//
// Purpose: Test coverage for LSU NAPOT
//
// A component of the CORE-V-WALLY configurable RISC-V project.
// 
// Copyright (C) 2021-23 Harvey Mudd College & Oklahoma State University
//
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the “License”); you may not use this file 
// except in compliance with the License, or, at your option, the Apache License version 2.0. You 
// may obtain a copy of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work distributed under the 
// License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
// either express or implied. See the License for the specific language governing permissions 
// and limitations under the License.
////////////////////////////////////////////////////////////////////////////////////////////////

// load code to initalize stack, handle interrupts, terminate

#include "WALLY-init-lib.h"

# run-elf.bash find this in project description
main:
    li t5, 0x1
    slli t5, t5, 62
    csrs menvcfg, t5
    # Page table root address at 0x80010000; SV48
    li t5, 0x9000000000080010  
    csrw satp, t5

    # sfence.vma x0, x0

    # switch to supervisor mode
    li a0, 1   
    ecall

    li t4, 0x200000   # address step size
    li a2, 0x80215240 # Test NAPOT pages
    jal a1, looptest
    li a2, 0xC0215240  # Test ill-formed NAPOT pages
    jal a1, looptest
    li a2, 0x40215240  # Test properly formed pages with 1 in PPN[3] that are not NAPOT
    jal a1, looptest
#    li t4, 0x1000     # address step size
#    li a2, 0x80216000 # Test NAPOT pages
#    jal a1, looptest
    j done

looptest:
    mv t0, a2       # base address
    li t2, 0             # i = 0
    li t3, 35     # Max amount of Loops = 34
    li t5, 0x8082 # return instruction opcode

loop: bge t2, t3, looptesti   # exit loop if i >= loops
    sw t5, 0(t0)   # store a return at this address to exercise DTLB
    lw t1, 0(t0)   # read it back
    fence.i    # synchronize with I$
    jalr ra, t0 # jump to the return statement to exercise the ITLB
    add t0, t0, t4
    addi t2, t2, 1
    j loop

looptesti:
    mv t0, a2       # base address
    li t2, 0             # i = 0
    fence.i    # synchronize with I$
 
# Exercise itlb by jumping to each of the return statements
loopi: bge t2, t3, finished   # exit loop if i >= loops
    jalr ra, t0 # jump to the return statement to exercise the ITLB
    add t0, t0, t4
    addi t2, t2, 1
    j loopi

finished:
    jr a1

.data

.align 16
# root Page table situated at 0x80010000
pagetable: 
    .8byte 0x200044C1 // old page table was 200040 which just pointed to itself! wrong

# next page table at 0x80011000
.align 12
    .8byte 0x0000000000000000 # gigapage at 0x00000000
    .8byte 0x00000000200058C1 # gigapage at 0x40000000 used for non-NAPOT with PPN bit 3 set
    .8byte 0x00000000200048C1 # gigapage at 0x80000000 used for testing NAPOT huge pages
    .8byte 0x00000000200050C1 # gigapage at 0xC0000000 mapped to ill-formed NAPOT with wrong PPN
    

# Next page table at 0x80012000 for gigapage at 0x80000000
.align 12
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1
    .8byte 0x0000000020004CC1

# Leaf page table at 0x80013000 with NAPOT pages
.align 12
    #80000000
    .8byte 0xA0000000200020CF
    .8byte 0xA0000000200020CF
    .8byte 0xA0000000200020CF
    .8byte 0xA0000000200020CF

    .8byte 0xA0000000200020CF
    .8byte 0xA0000000200020CF
    .8byte 0xA0000000200020CF
    .8byte 0xA0000000200020CF

    .8byte 0xA0000000200020CF
    .8byte 0xA0000000200020CF
    .8byte 0xA0000000200020CF
    .8byte 0xA0000000200020CF

    .8byte 0xA0000000200020CF
    .8byte 0xA0000000200020CF
    .8byte 0xA0000000200020CF
    .8byte 0xA0000000200020CF

    .8byte 0x80000000200060CF
    .8byte 0x80000000200060CF
    .8byte 0x80000000200060CF
    .8byte 0x80000000200060CF

    .8byte 0x80000000200060CF
    .8byte 0x80000000200060CF
    .8byte 0x80000000200060CF
    .8byte 0x80000000200060CF

    .8byte 0x80000000200060CF
    .8byte 0x80000000200060CF
    .8byte 0x80000000200060CF
    .8byte 0x80000000200060CF

    .8byte 0x80000000200060CF
    .8byte 0x80000000200060CF
    .8byte 0x80000000200060CF
    .8byte 0x80000000200060CF
    
    .8byte 0x800000002000A0CF
    .8byte 0x800000002000A0CF
    .8byte 0x800000002000A0CF
    .8byte 0x800000002000A0CF

    .8byte 0x800000002000A0CF
    .8byte 0x800000002000A0CF
    .8byte 0x800000002000A0CF
    .8byte 0x800000002000A0CF

    .8byte 0x800000002000A0CF
    .8byte 0x800000002000A0CF
    .8byte 0x800000002000A0CF
    .8byte 0x800000002000A0CF

    .8byte 0x800000002000A0CF
    .8byte 0x800000002000A0CF
    .8byte 0x800000002000A0CF
    .8byte 0x800000002000A0CF

    .8byte 0x800000002000E0CF
    .8byte 0x800000002000E0CF
    .8byte 0x800000002000E0CF
    .8byte 0x800000002000E0CF

    .8byte 0x800000002000E0CF
    .8byte 0x800000002000E0CF

# Next page table at 0x80014000: mega-sized, pointing to malformed NAPOT  for gigapage at 0xC9000000
.align 12
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1
    .8byte 0x00000000200054C1

# Leaf page table at 0x80015000 with malformed NAPOT pages (wrong PPN) starting at 0xC0000000
.align 12
    #80000000
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF

    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF

    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF

    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF

    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF

    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF

    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF

    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF

    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF
    .8byte 0x80000000200000CF


# Next page table at 0x80016000: mega-sized, pointing to properly formed PTE with 1 in PPN bit 3  for gigapage at 0x40000000
.align 12
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1
    .8byte 0x0000000020005CC1

# Leaf page table at 0x80017000 with properly formed PTE with bit 4 of PPN set but no NAPOT
.align 12
    #80000000
    .8byte 0x00000000200020CF
    .8byte 0x00000000200060CF
    .8byte 0x000000002000A0CF
    .8byte 0x000000002000E0CF

    .8byte 0x00000000200020CF
    .8byte 0x00000000200060CF
    .8byte 0x000000002000A0CF
    .8byte 0x000000002000E0CF

    .8byte 0x00000000200020CF
    .8byte 0x00000000200060CF
    .8byte 0x000000002000A0CF
    .8byte 0x000000002000E0CF

    .8byte 0x00000000200020CF
    .8byte 0x00000000200060CF
    .8byte 0x000000002000A0CF
    .8byte 0x000000002000E0CF

    .8byte 0x00000000200020CF
    .8byte 0x00000000200060CF
    .8byte 0x000000002000A0CF
    .8byte 0x000000002000E0CF

    .8byte 0x00000000200020CF
    .8byte 0x00000000200060CF
    .8byte 0x000000002000A0CF
    .8byte 0x000000002000E0CF

    .8byte 0x00000000200020CF
    .8byte 0x00000000200060CF
    .8byte 0x000000002000A0CF
    .8byte 0x000000002000E0CF

    .8byte 0x00000000200020CF
    .8byte 0x00000000200060CF
    .8byte 0x000000002000A0CF
    .8byte 0x000000002000E0CF

    .8byte 0x00000000200020CF
    .8byte 0x00000000200060CF
    .8byte 0x000000002000A0CF
    .8byte 0x000000002000E0CF

