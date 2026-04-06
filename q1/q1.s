.text
.globl make_node
make_node:
    addi    sp, sp, -16
    sd      ra, 8(sp)
    sd      s0, 0(sp)

    mv      s0, a0              # s0 = val, saved across malloc call

    li      a0, 24              # allocate 24 bytes
    call    malloc

    sw      s0, 0(a0)           # node->val   = val
    sd      zero, 8(a0)         # node->left  = NULL
    sd      zero, 16(a0)        # node->right = NULL

    ld      ra, 8(sp)
    ld      s0, 0(sp)
    addi    sp, sp, 16
    ret

.globl insert
insert:
    addi    sp, sp, -32
    sd      ra, 24(sp)
    sd      s0, 16(sp)          # s0 = root
    sd      s1, 8(sp)           # s1 = val

    mv      s0, a0
    mv      s1, a1

    beq     s0, zero, insert_new    # if root == NULL

    lw      t0, 0(s0)           # t0 = root->val
    beq     s1, t0, insert_done # val already exists

    blt     s1, t0, insert_go_left     # go left if val < root->val

insert_go_right:
    ld      a0, 16(s0)          # a0 = root->right
    mv      a1, s1
    call    insert
    sd      a0, 16(s0)          # root->right = returned node
    mv      a0, s0
    j       insert_done

insert_go_left:
    ld      a0, 8(s0)           # a0 = root->left
    mv      a1, s1
    call    insert
    sd      a0, 8(s0)           # root->left = returned node
    mv      a0, s0              # return root
    j       insert_done

insert_new:
    mv      a0, s1              # create new node
    call    make_node

insert_done:
    ld      ra, 24(sp)
    ld      s0, 16(sp)
    ld      s1, 8(sp)
    addi    sp, sp, 32
    ret

.globl get
get:
    addi    sp, sp, -32
    sd      ra, 24(sp)
    sd      s0, 16(sp)          # s0 = root
    sd      s1, 8(sp)           # s1 = val
    mv      s0, a0
    mv      s1, a1
    beq     s0, zero, get_null  # root == NULL

    lw      t0, 0(s0)           # root->val
    beq     s1, t0, get_found

    blt     s1, t0, get_go_left

get_go_right:
    ld      a0, 16(s0)          # root->right
    mv      a1, s1
    call    get
    j       get_done

get_go_left:
    ld      a0, 8(s0)           # root->left
    mv      a1, s1
    call    get
    j       get_done

get_found:
    mv      a0, s0              # return node

    j       get_done

get_null:
    li      a0, 0               # return NULL

get_done:
    ld      ra, 24(sp)
    ld      s0, 16(sp)
    ld      s1, 8(sp)
    addi    sp, sp, 32
    ret

.globl getAtMost
getAtMost:
    addi    sp, sp, -32
    sd      ra, 24(sp)
    sd      s0, 16(sp)          # s0 = val
    sd      s1, 8(sp)           # s1 = root

    mv      s0, a0
    mv      s1, a1

    beq     s1, zero, gatm_null  # root == NULL

    lw      t0, 0(s1)           # root->val

    blt     s0, t0, gatm_go_left   # val < root->val then go left

gatm_candidate:
    mv      a0, s0              # root->val <= val then candidate, check right subtree
    ld      a1, 16(s1)          # root->right
    call    getAtMost

    li      t1, -1
    bne     a0, t1, gatm_done   # right found better answer

    lw      a0, 0(s1)           # else use root->val
    j       gatm_done

gatm_go_left:
    mv      a0, s0
    ld      a1, 8(s1)
    call    getAtMost           #root->left
    j       gatm_done 

gatm_null:
    li      a0, -1              # no valid value

gatm_done:
    ld      ra, 24(sp)
    ld      s0, 16(sp)
    ld      s1, 8(sp)
    addi    sp, sp, 32
    ret