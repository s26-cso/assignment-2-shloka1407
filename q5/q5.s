.section .data
filename: .asciz "input.txt"
yes: .asciz "Yes\n"
no: .asciz "No\n"

.section .bss
buf1: .space 1
buf2: .space 1

.section .text
.globl _start

_start:

# open file (fd -> s0)
li a7,1024
la a0,filename
li a1,0
ecall
mv s0,a0

# get file size using lseek (size -> s1)
li a7,62
mv a0,s0
li a1,0
li a2,2
ecall
mv s1,a0

# initialize left and right pointers
li s2,0
addi s3,s1,-1

loop:
# stop if pointers cross
bge s2,s3,palindrome

# seek to left and read 1 byte
li a7,62
mv a0,s0
mv a1,s2
li a2,0
ecall

li a7,63
mv a0,s0
la a1,buf1
li a2,1
ecall

# seek to right and read 1 byte
li a7,62
mv a0,s0
mv a1,s3
li a2,0
ecall

li a7,63
mv a0,s0
la a1,buf2
li a2,1
ecall

# compare characters
lb t0,buf1
lb t1,buf2
bne t0,t1,not_pal

# move inward
addi s2,s2,1
addi s3,s3,-1
j loop

palindrome:
# print "Yes"
li a7,64
li a0,1
la a1,yes
li a2,4
ecall
j exit

not_pal:
# print "No"
li a7,64
li a0,1
la a1,no
li a2,3
ecall

exit:
# exit program
li a7,93
li a0,0
ecall