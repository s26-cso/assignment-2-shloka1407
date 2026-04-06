# void next_greater(int* arr, int n, int* result)
# a0 = arr, a1 = n, a2 = result

.text
.globl next_greater
next_greater:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)

    sd s1, 40(sp)
    sd s2, 32(sp)
    sd s3, 24(sp)
    sd s4, 16(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    slli t0, s1, 2
    sub sp, sp, t0
    mv s3, sp              # stack base
    li t1, -1              # top = -1

    addi s4, s1, -1        # i = n-1

loop_i:
    blt s4, zero, done

while_loop:
    blt t1, zero, while_done

    slli t2, t1, 2
    add t3, s3, t2
    lw t4, 0(t3)           # idx = stack[top]

    slli t5, t4, 2
    add t6, s0, t5
    lw t5, 0(t6)           # arr[top]

    slli t2, s4, 2
    add t6, s0, t2
    lw t6, 0(t6)           # arr[i]

    blt t5, t6, pop
    beq t5, t6, pop
    j while_done

pop:
    addi t1, t1, -1
    j while_loop

while_done:

    blt t1, zero, set_minus

    slli t2, t1, 2
    add t3, s3, t2
    lw t4, 0(t3)           # index

    slli t5, s4, 2
    add t6, s2, t5
    sw t4, 0(t6)           # result[i] = index
    j push_i

set_minus:
    slli t2, s4, 2
    add t6, s2, t2
    li t4, -1
    sw t4, 0(t6)           # result[i] = -1

push_i:
    addi t1, t1, 1
    slli t2, t1, 2
    add t3, s3, t2
    sw s4, 0(t3)           # push i

    addi s4, s4, -1
    j loop_i

done:
    slli t0, s1, 2
    add sp, sp, t0         # free temp stack

    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    ld s4, 16(sp)

    addi sp, sp, 64
    ret