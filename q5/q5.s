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
li a7,1024              # open file (fd -> s0)
la a0,filename
li a1,0
ecall
mv s0,a0

li a7,62                #get file size 
mv a0,s0
li a1,0
li a2,2
ecall
mv s1,a0

li s2,0                 #initialize left and right pointers
addi s3,s1,-1

loop:
bge s2,s3,palindrome            #stop if pointers cross

li a7,62
mv a0,s0
mv a1,s2
li a2,0
ecall                           #seek to left and read 1 byte

li a7,63
mv a0,s0
la a1,buf1
li a2,1
ecall

li a7,62                    #seek to right and read 1 byte
mv a0,s0
mv a1,s3
li a2,0
ecall

li a7,63
mv a0,s0
la a1,buf2
li a2,1
ecall

lb t0,buf1                  #compare characters
lb t1,buf2
bne t0,t1,not_pal

addi s2,s2,1                #move inward
addi s3,s3,-1
j loop

palindrome:
li a7,64                #print "Yes"
li a0,1
la a1,yes
li a2,4
ecall
j exit

not_pal:
li a7,64                    #print "No"
li a0,1
la a1,no
li a2,3
ecall

exit:
li a7,93                #exit program
li a0,0
ecall