%include "io64.inc"
section .bss
vec: resd 100
N:resd 100

section .text
global CMAIN
CMAIN:    
    mov rbp, rsp; for correct debugging
GET_UDEC 4, edx
mov[N], edx
mov ecx, 0
loop1: 
    GET_DEC 4, eax
    mov[vec+4*ecx], eax
    inc ecx
    cmp ecx,[N]
    jnz loop1
xor r8,r8
inc r8
xor r10, r10
mov r10, [N]
dec r10
NEWLINE
;PRINT_DEC 4, [vec]
;PRINT_DEC 4, [vec+4]
;PRINT_DEC 4, [vec+8]
;PRINT_DEC 4, [vec+12]
;PRINT_DEC 4, [vec+16]
;NEWLINE
for_i:
    xor r9,r9
        for_j:
        xor rax,rax
        xor r11,r11
        mov eax, [vec+r9*4]
        ;PRINT_DEC 4, rax
        ;PRINT_DEC 4, [vec+r9*4+4]
        cmp eax, [vec+r9*4+4]                   
        jl next_iter                     ; ??? 
        ;PRINT_DEC 4, eax
        ;PRINT_DEC 4, [vec+r9*4+4]
        mov r11d, [vec+r9*4+4]
        mov [vec+r9*4] , r11d
        mov [vec+r9*4+4], eax
        ;xchg rax, [vec+r9*4+4]
        ;mov [vec+r9*4], rax
        NEWLINE
        ;PRINT_DEC 4, [vec+r9*4]
        ;PRINT_DEC 4, [vec+r9*4+4]
        NEWLINE
        next_iter:
        inc r9
        cmp r10, r9
        jne for_j
    inc r8
    cmp [N], r8
    jne for_i
xor r9,r9
NEWLINE
print:
    PRINT_DEC 4, [vec+4*r9]
    PRINT_STRING ' '
    inc r9,
    cmp r9, [N]
    jnz print
ret
