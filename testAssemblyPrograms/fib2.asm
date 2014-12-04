#initialize stack pointer
li $sp, 0x3ffc

##find 4th fibonacci number
li $a0, 2
jal fibonacci
move $v1, $v0

#exit
li $t1, 1
jal endall
#li $v0, 10
#syscall


fibonacci:
bgt $a0, 1, casegt1
beqz $a0, case0
li $v0, 1
jr $ra

case0:
li $v0, 0
jr $ra

casegt1:
#pushing to stack
add $sp, $sp, -8
sw $ra, 4($sp)
sw $a0, 0($sp)

#finding fibonacci(x-1)
add $a0, $a0, -1
jal fibonacci

#popping from stack
lw $ra, 4($sp)
lw $a0, 0($sp)
add $sp, $sp, 8

#pushing to stack
add $sp, $sp, -12
sw $ra, 8($sp)
sw $a0, 4($sp)
sw $v0, 0($sp)

#finding fibonacci(x-2)
add $a0, $a0, -2
jal fibonacci

#popping from stack
lw $ra, 8($sp)
lw $a0, 4($sp)
lw $t0, 0($sp)
add $sp, $sp, 12

#adding fibonacci(x-1) and fibonacci(x-2)
add $v0, $v0, $t0
jr $ra

endall:
jal endall
