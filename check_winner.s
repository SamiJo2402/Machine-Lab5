@author: Mary Kovic

.cpu cortex-a53
.fpu neon-fp-armv8

.data
header: .asciz "\n====================== GO FISH CARD GAME CURRENT RESULT ========================(Change line)\n\n"
score: .asciz "Player's score: %d\nCPU's score: %d(Change line)\n\n"

.text

.align 2
.global check_winner
.type check_winner, %function

check_winner:
    push {fp, lr}
    add fp, sp, #4
    push {r5, r6, r7, r8, r9}

    mov r4, r0
    mov r5, r1
    ldr r8, [r0]                
    ldr r9, [r1]               

    mov r0, #4
    mov r1, #14
    mul r0, r0, r1
    add r0, r0, r4
    ldr r6, [r0]               
    mov r0, #4
    mov r1, #14
    mul r0, r0, r1
    add r0, r0, r5
    ldr r7, [r0]                
    ldr r0, =header
    bl printf                  

    mov r1, r6
    mov r2, r7
    ldr r0, =score              
    bl printf

    cmp r6, #13               
    bgt player_won

    cmp r7, #13                
    bgt cpu_won

    cmp r8,#0
    beq finish_game

    cmp r9,#0
    beq finish_game2

    mov r0, #0                  
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
    cmp r6, r7                  
    bgt player_won

    cmp r6, r7                  
    blt cpu_won

    b tie                       

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
    sub sp, fp, #4              
    pop {fp, lr}                
    bx lr                      
