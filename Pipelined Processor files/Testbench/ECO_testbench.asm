# The purpose of this testbench is to demonstrate the equivalent or similar optimization of both the Unified 
# and Split caches over the non-optimized cache implementation


#The following 3 lines are implemented repeatedly to avoid data hazard, as it has not been implemented
#add $0, $0, $0
#add $0, $0, $0
#add $0, $0, $0


#Target: looped memory accesses

addi $10, $0, 6 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $1, $0, 1 
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
j Loop

Loop: addi $1, $1, 1 	#R1 Final Value: 6
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
lw $2, 3($9)
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
sw $2, 3($9)
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
lw $3, 4($8)
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
sw $3, 4($8)
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
lw $4, 5($7)
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
sw $4, 5($7)
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
beq $10, $1, End 	   #R10 Final Value: 6
j Loop

End: add $0, $0, $0