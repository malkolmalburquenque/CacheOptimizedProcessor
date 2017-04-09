# The purpose of this testbench is to explicitly demonstrate Unified-cache optimization vs. Split-cache and/or no-cache


#The following 3 lines are implemented repeatedly to avoid data hazard, as it has not been implemented
#add $0, $0, $0
#add $0, $0, $0
#add $0, $0, $0


#Target all instruction calls, no data calls

addi $1, $0, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $31, $0, 8 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
j Loop

Loop: addi $1, $1, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $2, $1, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $3, $2, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $4, $3, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $5, $4, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $6, $5, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $7, $6, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $8, $7, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $9, $8, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $10, $9, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $11, $10, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $12, $11, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $13, $12, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $14, $13, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $15, $14, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $16, $15, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $17, $16, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $18, $17, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $19, $18, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $20, $19, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $21, $20, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $22, $21, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $23, $22, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $24, $23, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $25, $24, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $26, $25, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $27, $26, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $28, $27, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $29, $28, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $30, $29, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
beq $31, $4, End
j Loop

End: add $0, $0, $0

