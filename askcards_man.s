@author: Mary Kovic

.cpu cortex-a53
.fpu neon-fp-armv8

.data
inp1: .asciz "\nPick a card:(Change Line)"
inp2: .asciz "%d"
card_from_deck: .asciz "\nYou picked from deck: %d(Change Line)\n"
card_from_deck2: .asciz "\nCPU picked from deck: %d(Change Line)\n"
nodeck: .asciz "\nNo more cards left on deck.(Change Line)\n"
pairdown: .asciz "\nYou lay down a pair of %d.(Change Line)\n"
response1: .asciz "\nCPU said: Yes!(Change Line)\n"
out1: .asciz "\nCPU says: Go Fish!(Change Line)\n"

.text
.align 2
.global askcards_man
.type askcards_man, %function

askcards_man:
    push {fp, lr}           
    add fp, sp, #4         

    push {r4, r5, r6, r7, r8, r9, r10}
    mov r4, #0
    mov r5, #0
    mov r6, #0
    mov r7, #0
    mov r8, #0
    mov r9, #0
    mov r10, #0

    mov r4, r0              
    mov r5, r1              
    mov r6, r2              

    push {r0, r1, r2, r3}
    ldr r0, =inp1           
    bl printf
    pop {r3, r2, r1, r0}

    ldr r0, =inp2
    sub sp, sp, #4          
    mov r1, sp              
    bl scanf                

    ldr r7, [sp]
    mov r0, #4
    mul r0, r7, r0
    add r0, r0, r6
    ldr r2, [r0]            
    cmp r2, #0              
    beq gofish              

    sub r3, r2, #1
    str r3, [r0]            

    ldr r1, [r6]
    sub r1, r1, #1
    str r1, [r6]            

    mov r0, #4
    mul r0, r7, r0
    add r0, r0, r5
    ldr r8, [r0]          
    add r8, r8, #1         
    str r8, [r0]           

    ldr r8, [r5]           
    add r8, r8, #1         
    str r8, [r5]            

    push {r0, r1, r2, r3}               
    ldr r0, =response1
    bl printf
    pop {r3, r2, r1, r0}

    cmp r1, #0
    beq cpu_no_card_on_hand 

    mov r9, #1
    b whileLoop

gofish:
    push {r0,r1, r2, r3}
    ldr r0, =out1
    bl printf               
    pop {r3, r2, r1, r0}

    mov r0, r4              
    mov r1, r5             
    bl draw                 

    cmp r0, #0
    beq no_card_on_deck

    push {r0,r1, r2, r3}
    mov r1, r0
    ldr r0, =card_from_deck
    bl printf               
    pop {r3, r2, r1, r0}

    mov r9, #1              
    b whileLoop

no_card_on_deck:
    push {r0, r1, r2, r3}
    ldr r0, =nodeck
    bl printf              
    pop {r3, r2, r1, r0}

    mov r9, #1
    b whileLoop

whileLoop:
    cmp r9, #14             
    beq endFunction

    mov r0, #4
    mul r0, r9, r0
    add r0, r0, r5
    ldr r8, [r0]           

    cmp r8, #2             
    bge playerHasPair

    add r9, r9, #1          
    b whileLoop            


playerHasPair:
    ldr r1, [r0]
    sub r1, r1, #2
    str r1, [r0]           

    ldr r0, [r5]
    sub r0, r0, #2          
    str r0, [r5]            
    mov r10, r0

    mov r0, #4
    mov r1, #14
    mul r0, r0, r1
    add r0, r0, r5
    ldr r1, [r0]
    add r1, r1, # 1
    str r1, [r0]         

    push {r0,r1, r2, r3}
    ldr r0, =pairdown
    mov r1, r9
    bl printf
    pop {r3, r2, r1, r0}

    cmp r10, #0             
    ble deal_card

    b whileLoop

deal_card:
    mov r9, #0

draw_card_loop:
    add r9, r9, #1
    cmp r9, #6
    beq draw_card_done

    push {r0,r1, r2, r3}
    mov r0, r4            
    mov r1, r5              
    bl draw                
    mov r10, r0
    pop {r3, r2, r1, r0}

    cmp r10, #0             
    beq no_card_on_deck

    push {r0,r1, r2, r3}
    mov r1, r10
    ldr r0, =card_from_deck
    bl printf               
    pop {r3, r2, r1, r0}

    b draw_card_loop

draw_card_done:
    mov r9, #1             
    b whileLoop

cpu_no_card_on_hand:      
mov r9, #0
draw_card_loop2:
    add r9, r9, #1
    cmp r9, #6
    beq draw_card_done

    push {r0,r1, r2, r3}
    mov r0, r4              
    mov r1, r6              
    bl draw                
    mov r10, r0
    pop {r3, r2, r1, r0}

    cmp r10, #0             
    beq no_card_on_deck

    push {r0,r1, r2, r3}
    mov r1, r10
    ldr r0, =card_from_deck2
    bl printf               
    pop {r3, r2, r1, r0}

    b draw_card_loop2

endFunction:
    pop {r10, r9, r8, r7, r6, r5, r4}

    sub sp, fp, #4          
    pop {fp, lr}            
    bx lr                  
