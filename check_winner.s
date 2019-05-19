.cpu cortex-a53
.fpu neon-fp-armv8

.data
header: .asciz "\n====================== GO FISH CARD GAME CURRENT RESULT ========================\n\n"
score: .asciz "Player's score: %d\nCPU's score: %d\n\n"

.text

.align 2
.global check_winner
.type check_winner, %function

check_winner:
    push {fp, lr}
    add fp, sp, #4

    @ r0 = player array
    @ r1 = cpu array

    push {r5, r6, r7, r8, r9}

    mov r4, r0
    mov r5, r1
    ldr r8, [r0]                @ player's card count
    ldr r9, [r1]                @ cpu's card count

    mov r0, #4
    mov r1, #14
    mul r0, r0, r1
    add r0, r0, r4
    ldr r6, [r0]                @ retrieve player's score and store it to r6

    mov r0, #4
    mov r1, #14
    mul r0, r0, r1
    add r0, r0, r5
    ldr r7, [r0]                @ retrieve cpu's score and store it to r7

    ldr r0, =header
    bl printf                   @ prints header

    mov r1, r6
    mov r2, r7
    ldr r0, =score              @ prints score
    bl printf

    cmp r6, #13                 @ check if player has greater than 13 points
    bgt player_won

    cmp r7, #13                 @ check if cpu has greater than 13 points
    bgt cpu_won

    cmp r8,#0
    beq finish_game

    cmp r9,#0
    beq finish_game2

    mov r0, #0                  @ otherwise return 0, which means continue playing
    b check_winner_done

finish_game:
    cmp r9, #0
    beq game_done

    mov r0, #0
    b check_winner_done

finish_game2:
    cmp r8, #0
    beq game_done

    mov r0, #0
    b check_winner_done

game_done:
    cmp r6, r7                  @ check if player won
    bgt player_won

    cmp r6, r7                  @ check if cpu won
    blt cpu_won

    b tie                       @ otherwise, it's a tie

player_won:
    mov r0, #1
    b check_winner_done

cpu_won:
    mov r0, #2
    b check_winner_done

tie:
    mov r0, #3

check_winner_done:
    pop {r9, r8, r7, r6, r5}
    sub sp, fp, #4              @ place sp at -8 on stack
    pop {fp, lr}                @ pop fp (calling function), pop lr, set sp at 0 on stack
    bx lr                       @ branch back to calling function
