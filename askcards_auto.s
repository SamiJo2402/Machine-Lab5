@author: Mary Kovic

.cpu cortex-a53
.fpu neon-fp-armv8

.data
output: .asciz "\nYou said: Go Fish!(Change Line)\n" 
card_from_deck: .asciz "\nCPU picked from deck: %d(Change Line)\n"
card_from_deck2: .asciz "\nYou picked from deck: %d(Change Line)\n"
nodeck: .asciz "\nNo more cards left on deck.(Change Line)\n"
pairdown2: .asciz "\nCPU lay down a pair of %d.(Change Line)\n"
response2: .asciz "\nYou said: Yes!(Change Line)\n"
cpuPick: .asciz "CPU: Do you have %d?(Change Line)\n"

.text				@header stuff
.align 2			@header stuff
.global askcards_auto		@function askcards_auto
.type askcards_auto, %function	@function askcards_auto

askcards_auto:			
    push {fp, lr}		
    add fp, sp, #4

    push {r4, r5, r6, r7, r8, r9, r10}	@push registers onto the stack
    mov r4, #0				@r4 = 0
    mov r5, #0				@r5 = 0
    mov r6, #0				@r6 = 0
    mov r7, #0				@r7 = 0
    mov r8, #0				@r8 = 0
    mov r9, #0				@r9 = 0
    mov r10, #0				@r10 = 0

    mov r4, r0                 
    mov r5, r1                 
    mov r6, r2                 

    mov r0, #0                  
    bl time
    bl srand

whileLoop1:
    bl rand                    
    mov r1, #13
    bl modulo                  

    add r0, r0, #1
    mov r9, r0

    mov r3, #4
    mul r3, r9, r3 

    add r3, r3, r5
    ldr r9, [r3]                
    cmp r9, #0                 
    beq whileLoop1              
                                

    mov r7, r0                  

    push {r0, r1, r2, r3}
    mov r1, r0
    ldr r0, =cpuPick
    bl printf                  
    pop {r3, r2, r1, r0}

    mov r0, #4
    mul r0, r7, r0
    add r0, r0, r6
    ldr r2, [r0]                
    cmp r2, #0                  
    beq cpuGoFish               

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
    ldr r0, =response2
    bl printf
    pop {r3, r2, r1, r0}

    cmp r1, #0
    beq player_no_card_on_hand     

    mov r9, #1
    b whileLoop2

cpuGoFish:
    push {r0, r1, r2, r3}
    ldr r0, =output
    bl printf                  
    pop {r3, r2, r1, r0}

    mov r0, r4                  
    mov r1, r5                  
    bl draw                     

    cmp r0, #0
    beq no_card_on_deck2

    mov r9, #1                  
    b whileLoop2

no_card_on_deck2:
    push {r0, r1, r2, r3}
    ldr r0, =nodeck
    bl printf                   
    pop {r3, r2, r1, r0}

    mov r9, #1
    b whileLoop2

whileLoop2:
    cmp r9, #14               
    beq endFunction2

    mov r0, #4
    mul r0, r9, r0
    add r0, r0, r5
    ldr r8, [r0]              

    cmp r8, #2                  
    bge playerHasPair2

    add r9, r9, #1             
    b whileLoop2                


playerHasPair2:
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

    push {r0, r1, r2, r3}
    ldr r0, =pairdown2
    mov r1, r9
    bl printf
    pop {r3, r2, r1, r0}

    cmp r10, #0                  
    ble deal_card2

    b whileLoop2

deal_card2:
    mov r9, #0

draw_card_loop3:
    add r9, r9, #1
    cmp r9, #6
    beq draw_card_done2

    push {r0, r1, r2, r3}
    mov r0, r4                  
    mov r1, r5                  
    bl draw                    
    mov r10, r0
    pop {r3, r2, r1, r0}

    cmp r10, #0                 
    beq no_card_on_deck2


    b draw_card_loop3

draw_card_done2:
    mov r9, #1                  
    b whileLoop2

player_no_card_on_hand:         
mov r9, #0
draw_card_loop4:
    add r9, r9, #1
    cmp r9, #6
    beq draw_card_done2

    push {r0, r1, r2, r3}
    mov r0, r4                 
    mov r1, r6                  
    bl draw                   
    mov r10, r0
    pop {r3, r2, r1, r0}

    cmp r10, #0                 
    beq no_card_on_deck2

    push {r0,r1, r2, r3}
    mov r1, r10
    ldr r0, =card_from_deck2
    bl printf                    
    pop {r3, r2, r1, r0}

    b draw_card_loop4

endFunction2:
    pop {r10, r9, r8, r7, r6, r5, r4}

    sub sp, fp, #4              
    pop {fp, lr}                
    bx lr                    
