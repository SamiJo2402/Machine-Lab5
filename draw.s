@author: Mary Kovic

.cpu cortex-a53
.fpu neon-fp-armv8

.data
inp: .asciz "%d"
test: .asciz "\nr9 value: %-15d (Change line)\n\n"
test2: .asciz "\nr10 value: %-15d (Change line)\n\n"

.extern fscanf

.text
.align 2

.global draw
.type draw, %function

draw:
    push {fp, lr}      
    add fp, sp, #4      

 

    push {r4, r5, r6, r7, r8, r9, r10}

    mov r4, r0          
    mov r5, r1          

    ldr r1, =inp
    sub sp, sp, #4
    mov r2, sp
    bl fscanf

    ldr r9, [sp]       

    cmp r9, #13         
    bgt emptyDeck

    mov r6, r9        

  
    mov r0, #4
    mul r0, r0, r9
    add r0, r0, r5
    ldr r9, [r0]
    add r9, r9, #1
    str r9, [r0]

    ldr r8, [r5]      
    add r8, r8, #1
    str r8, [r5]       
    mov r0, r6        
    b draw_done

emptyDeck:
    mov r0, #0

draw_done:
    add sp, sp, #4
    pop {r10, r9, r8, r7, r6, r5, r4}

    sub sp, fp, #4      
    pop {fp, lr}        
    bx lr              