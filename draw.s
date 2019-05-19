@
@ Student: Dan Mendoza
@ Palomar ID: 006798227
@ Class: CSCI 212
@ Lab 5 - Go Fish Game
@
@ draw.s

.cpu cortex-a53
.fpu neon-fp-armv8

.data
inp: .asciz "%d"
test: .asciz "\nr9 value: %-15d \n\n"
test2: .asciz "\nr10 value: %-15d \n\n"

.extern fscanf

.text
.align 2

.global draw
.type draw, %function

draw:
    push {fp, lr}       @ push lr, fp (calling function) onto stack, updates sp by -8
    add fp, sp, #4      @ point fp (this function) to lr on stack @ -4

    @r0 contains filepointer
    @r1 contains array

    push {r4, r5, r6, r7, r8, r9, r10}

    mov r4, r0          @ file pointer
    mov r5, r1          @ array

    @ scan for next randomized number from "deck.dat" file, that will represent the new card drawn from the deck
    ldr r1, =inp
    sub sp, sp, #4
    mov r2, sp
    bl fscanf

    ldr r9, [sp]        @ load random number stored in sp from fscanf into r9

    cmp r9, #13         @ checks if deck is empty
    bgt emptyDeck

    mov r6, r9          @ store card picked from deck to r0 to be returned

    @ increment card count at the proper card rank location in the array
    mov r0, #4
    mul r0, r0, r9
    add r0, r0, r5
    ldr r9, [r0]
    add r9, r9, #1
    str r9, [r0]

    @ increment total card count for the array stored at arr[0]
    ldr r8, [r5]       @ put element arr[0] (total card count in hand) into r8
    add r8, r8, #1
    str r8, [r5]       @ put result into arr[0] (total card count in hand)

    mov r0, r6         @ store card picked from deck to r0 to be returned
    b draw_done

emptyDeck:
    mov r0, #0

draw_done:
    @ ends function call
    add sp, sp, #4
    pop {r10, r9, r8, r7, r6, r5, r4}

    sub sp, fp, #4      @ place sp at -8 on stack
    pop {fp, lr}        @ pop fp (calling function), pop lr, set sp at 0 on stack
    bx lr               @ branch back to calling function
