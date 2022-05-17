%include "io64.inc"
%include "io64_float.inc" 
section .rodata
str1: dq "iv",0
str2:  dq "it",0
    
section .text
CEXTERN _ZN4hard4var11C6accessENS0_1SE
global CMAIN
CMAIN:
   push rbp
    mov rbp, rsp                                                                                                                                                                    
    sub rsp, 32 ;shadow space
    and rsp, -15

    lea rcx, [rsp+16]
    lea rdx, [rsp+24]

    mov r10, [str1]
    mov qword[rcx], r10
    
    mov r8, [str2]
    mov qword[rdx], r8
    mov dword[rdx+8], __float32__(0.5)
    
    
    call _ZN4hard4var11C6accessENS0_1SE
    xor rax, rax
    leave
    ret
