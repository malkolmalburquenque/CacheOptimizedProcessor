# The purpose of this testbench is to explicitly demonstrate Unified-cache optimization vs. Split-cache and/or no-cache


#The following 3 lines are implemented repeatedly to avoid data hazard, as it has not been implemented
#add $0, $0, $0
#add $0, $0, $0
#add $0, $0, $0


#Target all instruction calls, no data calls
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $1, $0, 1
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $31, $0, 8
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
j Loop

Loop: add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $1, $1, 1  # R1 final value: 5
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $2, $1, 1   # R2 final value: 6
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $3, $2, 1   # R3 final value: 7
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $4, $3, 1   # R4 final value: 8
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $5, $4, 1   # R5 final value: 9
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $6, $5, 1   # R6 final value: 10
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $7, $6, 1   # R7 final value: 11
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $8, $7, 1   # R8 final value: 12
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $9, $8, 1   # R9 final value: 13
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $10, $9, 1  # R10 final value: 14
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $11, $10, 1 # R11 final value: 15
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $12, $11, 1 # R12 final value: 16
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $13, $12, 1 # R13 final value: 17
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $14, $13, 1 # R14 final value: 18
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $15, $14, 1 # R15 final value: 19
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $16, $15, 1 # R16 final value: 20
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $17, $16, 1 # R17 final value: 21
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $18, $17, 1 # R18 final value: 22
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $19, $18, 1 # R19 final value: 23
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $20, $19, 1 # R20 final value: 24
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $21, $20, 1 # R21 final value: 25
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $22, $21, 1 # R22 final value: 26
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $23, $22, 1 # R23 final value: 27
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $24, $23, 1 # R24 final value: 28
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $25, $24, 1 # R25 final value: 29
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $26, $25, 1 # R26 final value: 30
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $27, $26, 1 # R27 final value: 31
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $28, $27, 1 # R28 final value: 32
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $29, $28, 1 # R29 final value: 33
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $30, $29, 1 # R30 final value: 34
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
beq $31, $4, End # R31 final value: 8
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
j Loop

End: add $0, $0, $0
