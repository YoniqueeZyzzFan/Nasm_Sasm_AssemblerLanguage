%include "io64.inc"
section .rodata
form: db "%i", 0
space: db " ",0
global CMAIN
CEXTERN printf
CEXTERN puts
CEXTERN scanf
CEXTERN malloc
CEXTERN free

section .text
CMAIN:
    mov rbp, rsp; for correct debugging   
push r12                                              ; r12 = кол-во элементов
push r8
push r13                                              ; r13 - хранит указатель нп начало масива  (при вводе меняется)
push r14                                              ; r14 - хранит указатель на массива (начало) НЕ МЕНЯЕТСЯ (при выводе меняется)
push r15                                                ; счетчик цикла
push rsi                                                ; счетчик цикла
push rbp    ;----
mov rbp, rsp; shadow space
sub rsp, 40 ;----                                      
and rsp, -16
lea rcx, [form] 
lea rdx, [rbp-8]
call scanf    
mov r12, [rbp-8]
cmp r15, r12
jz end
mov rax, 8
mov r15,r12
mul r15
mov rdi,rax
call malloc  
mov r13,rax
mov rcx, r13
mov r14, r13
xor r15,r15
Enter_array:                                          
    lea rcx, [form]
    lea rdx, [r13]
    call scanf
    mov r8, [r13]
    mov [r13], r8
    add r13, 8
    inc r15
    cmp r15,r12
    jnz Enter_array
xor r15,r15                                          
inc r15
xor rsi,rsi
mov rsi,r12
dec rsi
mov r13, r14
for_i:
    xor r9,r9
        for_j:
            xor rax,rax
            xor r11,r11
            mov eax, [r13+r9*8]
            cmp eax, [r13+r9*8+8]
            jl next_iter
            mov r11, [r13+r9*8+8]
            mov [r13+r9*8], r11
            mov [r13+r9*8+8], eax
        next_iter:
        inc r9
        cmp rsi, r9
        jne for_j
    inc r15
    cmp r12, r15
    jne for_i
xor r15,r15 
mov r13, r14
print:
    mov rdx, [r14+r15*8]            
    lea rcx, [form]
    call printf
    lea rcx, [space]
    call printf
    inc r15
    cmp r15, r12
    jnz print
    
lea rcx, [r13]
call free

end:
mov rsp, rbp
pop rbp
pop rsi
pop r15
pop r14
pop r13
pop r8
pop r12

ret