# The purpose of this testbench is to explicitly demonstrate Split-cache optimization vs. Unified-cache and/or no-cache


#The following 3 lines are implemented repeatedly to avoid data hazard, as it has not been implemented
#add $0, $0, $0
#add $0, $0, $0
#add $0, $0, $0
#so far we are at 4I & 4D. Target is 16I & 16D.

#Target ~equal instruction calls to data calls

#Assign Register values to test with
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $1, $0, 1  #R1 = 1
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
add $2, $1, $1 #R2 = 2
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $3, $3, 1 #R3 = 3
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $4, $4, 3
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
sub $4, $0, $0
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
mult $2, $2 #R4 = 4
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
mflo $4
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
add $16, $0, $0
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
sll $6, $5, 1 # R6 = 12
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
srl $7, $6, 2 # R7 = 3
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
sra $8, $1, 4 # R8 = 0xF0000000
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
sub $9, $8, $1 # R9 = 0xEFFFFFFF
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
lui $10, 44221 #R10 = 0xACBD0000 . 44221 = 0xACBD
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0

beq $1, $1, Divide
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0 #should never be accessed
#
PostDivide: add $0, $0, $0
			add $0, $0, $0
			add $0, $0, $0
 			bne $0, $1, Next

Next: slt $13, $0, $1 #R13 = 1 because 0<1
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0
	slti $14, $0, 1 #R14 = 0 because 0!<1
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0
	addi $15, $0, 2
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0
	addi $16, $16, 1 #R16 ++
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0
	beq $16, $4, exit #Should loop 4 times
	j Divide

Divide: add $0, $0, $0
		add $0, $0, $0
		add $0, $0, $0
		div $5, $4 #6/4 = 1 R2
		add $0, $0, $0
		add $0, $0, $0
		add $0, $0, $0
		mfhi $11 #R11 = 2 --it takes the remainder
		add $0, $0, $0
		add $0, $0, $0
		add $0, $0, $0
		mflo $12 #R12 = 1 --it takes the quotient
		add $0, $0, $0
		add $0, $0, $0
		add $0, $0, $0
		j PostDivide

exit: add $0, $0, $0

# Test:
# #beq $16, $4, Leaver
# add $0, $0, $0
# add $0, $0, $0
# add $0, $0, $0
#j Divide

# Leaver:
# add $0, $0, $0
# add $0, $0, $0
# add $0, $0, $0

#so far we are at 16I & 16D. Target is 16I & 16D.
#add Y
#sub Y
#addi Y
#mult Y

#div Y
#slt Y
#slti Y
#mfhi Y

#mflo Y
#sll Y
#srl Y
#sra Y

#lui Y
#and
#or
#nor
#xor
#andi
#ori
#xori
#beq Y
#bne Y
#j Y
