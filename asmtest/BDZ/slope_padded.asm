# Slope of a line defined by two points: (x1, y1) and (x2, y2)
# Slope is floored because the return type is int.
.text

main:
	# load parameter values into function call parameter registers
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, 3
	addi $a3, $zero, 6

  # Move the stack pointer.
	addi $sp, $sp, -20
	sw $ra, 16($sp)

  # Store the arguments into the stack.
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	sw $a3, 0($sp)

  # Call our slope method.
	jal slope

  # Return and restore the stack.
  lw $ra, 16($sp)
	addi $sp, $sp, 20
  j end:

slope:
	# loading contents at parameter addresses into volatile memory
	lw $t4, 12($sp)
	lw $t5, 8($sp)
	lw $t6, 4($sp)
	lw $t7, 0($sp)

	# calculating numerator and denominator
	sub $t0, $t7, $t5 # numerator
	sub $t1, $t6, $t4 # denominator

	divloop:
		# dividing numerator / denominator
		sub $t0, $t0, $t1 # subtracting the den from the num
		slt $t4, $t0, $zero # check if num < 0
		bne $zero, $t4, endloop # branch if num < 0
		addi $v0, $v0, 1 # add to division counter
		j divloop
	endloop:
	j $ra

end: # answer is stored in $v0
  syscall

.data
