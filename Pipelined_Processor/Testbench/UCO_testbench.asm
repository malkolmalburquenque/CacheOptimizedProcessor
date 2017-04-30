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
addi $31, $0, 15
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
j Loop

Loop: add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $1, $1, 1  # R1 final value: 12
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $2, $1, 1   # R2 final value: 13
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $3, $2, 1   # R3 final value: 14
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $4, $3, 1   # R4 final value: 15
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $5, $4, 1   # R5 final value: 16
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
beq $31, $4, End # R31 final value: 15
j Loop

End: add $0, $0, $0
