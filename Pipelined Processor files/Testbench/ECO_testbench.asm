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

addi $10, $0, 6 	#R10 initialized to '6'
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $1, $0, 1 		#R1 initialized to '1'
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $2, $0, 7		#R2 initialized to '7'
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $3, $0, 8		#R3 initialized to '8'
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $4, $0, 9		#R4 initialized to '9'
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
j Loop

Loop: add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $1, $1, 1 	#R1 Final Value: 6
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
sw $2, 3($9)		#Value of R2 stored into given address
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
sw $3, 4($8)		#Value of R3 stored into given address
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
sw $4, 5($7)		#Value of R4 stored into given address
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
lw $2, 3($9)		#Value of R2 loaded from address it just stored to
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $2, $2, 1		#Value of R2 incremented by 1
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
lw $3, 4($8)		#Value of R3 loaded from address it just stored to
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $3, $3, 1		#Value of R3 incremented by 1
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
lw $4, 5($7)		#Value of R4 loaded from address it just stored to
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $4, $4, 1		#Value of R4 incremented by 1
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
beq $10, $1, End 	#Loop execution terminates after five iterations
j Loop

End: add $0, $0, $0

#Values being loaded and stored:

#First Iteration: R2 = 7, R3 = 8, R4 = 9
#Second Iteration: R2 = 8, R3 = 9, R4 = 10
#Third Iteration: R2 = 9, R3 = 10, R4 = 11
#Fourth Iteration: R2 = 10, R3 = 11, R4 = 12
#Fifth and Final Iteration: R2 = 11, R3 = 12, R4 = 13
