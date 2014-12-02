li $a0, 4
jal fibonacci
move $v1, $v0

li $a0, 10
jal fibonacci
add $v1, $v1, $v0

li $v0, 10
syscall


fibonacci:
bgt $a0, 1, end
beqz $a0, case0
li $v0, 1
jr $ra

case0:
li $v0, 0
jr $ra

end:
add $sp, $sp, -8
sw $ra, 4($sp)
sw $a0, 0($sp)

add $a0, $a0, -1
jal fibonacci

lw $ra, 4($sp)
lw $a0, 0($sp)
add $sp, $sp, 8

move $t0, $v0

add $sp, $sp, -12
sw $ra, 8($sp)
sw $a0, 4($sp)
sw $t0, 0($sp)

add $a0, $a0, -2
jal fibonacci

lw $ra, 8($sp)
lw $a0, 4($sp)
lw $t0, 0($sp)
add $sp, $sp, 12

add $v0, $v0, $t0
jr $ra
