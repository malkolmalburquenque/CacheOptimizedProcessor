#this program checks how many prime numbers there are less than 10000

#The following 3 lines are implemented repeatedly to avoid data hazard, as it has not been implemented
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0

#initialize
add $1, $0, 0 #R1 is our answer
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $2, $0, 1 #R2 is our number we are testing
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $3, $0, 1 #R3 is our testing index
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $4, $0, 1000
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
firstLoop: bne $2, $4, testPrime
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
j quit

incrementNumber: addi $3, $0, 1 #Reset testing index
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
addi $2, $2, 1
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
j firstLoop
testPrime: add $0, $0, $0
beq $3, $2, isPrime
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
j incrementIndex
#
incrementIndex: addi $3, $3, 1 #R3++
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
div $2, $3 #R5 = R2/R3
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
mflo $5 #R5 = quotient
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
mfhi $6 #R6 = remainder
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
#beq $6, $0, incrementNumber
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
j testPrime
#
isPrime:addi $1, $0, 1
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
j incrementNumber

quit: add $0, $0, $0
