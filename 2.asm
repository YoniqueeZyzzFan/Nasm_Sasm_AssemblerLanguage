%include "io64.inc"
%include "io64_float.inc"
;hardlvl - 3 (exponenta)
section .data
e: dq 2.71828
section .rodata
n: dd 100
section .text
global CMAIN
CMAIN:
    mov rbp, rsp; for correct debugging 
    movsd xmm6,[e]                 ; xmm6 - хранит число экспоненты - 2.71828
    READ_DOUBLE xmm7              ; xmm7 - хранит степень, заданную пользователем
    xor r8,r8
    mov r8,1
    cvtsi2sd xmm4, r8
    cvtsi2sd xmm9, r8              ; xmm9 - итоговое число
    xor r13,r13
    mov r13,1
    Cons:                          ; Cons - ряд , r13 - является счеткиом внешнего цикла r13 - от 0 до n
        xor r9,r9
        mov r9,1
        cvtsi2sd xmm3, r8           ; xmm3 - записываю 1, т.к факториал считается от единицы
        Fact:                      ; Подсчет факториала идет от 1(r9) до r13
            cvtsi2sd xmm4, r9      ; xmm4 - перевод числа в вещественное для умножение
            mulsd xmm3, xmm4       ; xmm3 - итоговое значение факториала для числа
            inc r9
            cmp r9d, r13d
            jbe Fact
        xor r10,r10
        mov r10, 1
        cvtsi2sd xmm8, r8           ; заношу число пользователя(степень) в регистр xmm8
        XinPower:                    ; Возведение в степень идет от 1(r9) до r13
            mulsd xmm8, xmm7         ; xmm8 -  итого значение для числа возведения в степень
            inc r10
            cmp r10d, r13d
            jbe XinPower
        divsd xmm8,xmm3
        addsd xmm9,xmm8
        inc r13
        cmp r13d,[n]
        jle Cons
    PRINT_DOUBLE xmm9
    xor rax,rax
    xor eax,eax
    ret