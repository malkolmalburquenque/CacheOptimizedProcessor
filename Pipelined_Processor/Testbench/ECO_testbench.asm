# The purpose of this testbench is to demonstrate the equivalent or similar optimization of both the Unified
# and Split caches over the non-optimized cache implementation


#The following 3 lines are implemented repeatedly to avoid data hazard, as it has not been implemented
#add $0, $0, $0
#add $0, $0, $0
#add $0, $0, $0


#Target: looped memory accesses
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0

addi $10, $0, 6 	#R10 initialized to '10'
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $1, $0, 1 		#R1 initialized to '1'
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
j Loop

Loop: addi $1, $1, 1 	#R1 Final Value: 10
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
sw $1, 4($0)		#Value of R2 stored into given address
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
lw $2, 4($0)		#Value of R3 stored into given address
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
beq $10, $2, End 	#Loop execution terminates after five iterations
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
j Loop

End: add $0, $0, $0

#Values being loaded and stored:

#First Iteration: R2 = 7, R3 = 8, R4 = 9
#Second Iteration: R2 = 8, R3 = 9, R4 = 10
#Third Iteration: R2 = 9, R3 = 10, R4 = 11
#Fourth Iteration: R2 = 10, R3 = 11, R4 = 12
#Fifth and Final Iteration: R2 = 11, R3 = 12, R4 = 13
