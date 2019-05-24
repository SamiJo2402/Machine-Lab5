@author: Mary Kovic

.cpu cortex-a53
.fpu neon-fp-armv8

.data
zero_card: .asciz "\nNo more cards on deck.\n(Change line)"

.extern fscanf

.text
.align 2
.global dealcards
.type dealcards, %function

dealcards:
    push {fp, lr}          
    add fp, sp, #4         

    mov r4, r0             
    mov r5, r1             
    ldr r6, [r5]           
                          
    mov r7, #5             
    mov r8, #0            

    whileLoop:
        cmp r8, r7         
        beq endFunction    

        mov r0, r4        
        mov r1, r5        
        bl draw           

        add r8, r8, #1     
        b whileLoop        

endFunction:
    sub sp, fp, #4         
    pop {fp, lr}           
    bx lr                  