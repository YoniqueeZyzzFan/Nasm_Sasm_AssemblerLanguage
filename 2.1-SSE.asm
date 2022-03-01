%include "io64.inc"
%include "io64_float.inc"
section .data
e: dq 2.71828
pi: dq 3.141592
temp: dq 0
section .rodata
n: db 80
section .text
global CMAIN
CMAIN:
    mov rbp, rsp; for correct debugging
    xor r10,r10
    ;write your code here
    READ_DOUBLE xmm1            ; xmm1 - хранит значение переменной а            cos(ln(x+a)) = b
    READ_DOUBLE xmm2            ; xmm2 - хранит значение переменной b
    movsd xmm3, [pi]            ; храним число pi
    xor r8,r8  
    mov r8,1
    xor r9,r9
    mov r9,-1
    ;Проверка на ввод, т.к. -1<=cos<=1  ( -1<=b<=1)          
    cvtsi2sd xmm4,r9
    cvtsi2sd xmm5,r8
    COMISD xmm2,xmm5
    jbe skip1
    PRINT_STRING"B-value > 1, how... cos>1...."
    ret
    skip1:   
    COMISD xmm4,xmm2
    jbe skip2
    PRINT_STRING"B-value <1, how...    cos<-1"
    ret
    skip2: 
    xor r8,r8
    mov r8,2
    cvtsi2sd xmm4, r8
    divsd xmm3,xmm4             ;xmm3 - будет хранить значение числа pi/2
    
    
    mov r10,1
    cvtsi2sd xmm12,r10
    COMISD xmm12,xmm2
    je skip_all1    
               
    mov r10,-1
    cvtsi2sd xmm12,r10
    COMISD xmm12,xmm2
    je skip_all2                   
    
    
    ; Считаем arccos(b) и запишем результат в xmm3
    xor r8,r8
    xor r13,r13
    mov r13,0
    Cons:
        ; Считаю числитель
        xor r9,r9
        mov r9, 1
        xor r10,r10
        mov r10, r13
        xor rax,rax
        mov rax, r13
        xor rbx,rbx
        mov rbx,2
        mul rbx
        cvtsi2sd xmm6,r9           ; xmm6 - будет хранить b в степени 2(r13)+1
        inc rax
        cvtsi2sd xmm8, rax         ; xmm8 - хранит 2n+1
        dec rax
        xor r12,r12
        mov r12, 2
        cvtsi2sd xmm5, r9
        cvtsi2sd xmm15, r12
        cvtsi2sd xmm7, r9          ; xmm7 - хранит значение в знаменателе,а именно 2 в сетпени 2н
        cmp r9,r13
        jg skip
        Fact:
            cvtsi2sd xmm4, r9      ; xmm4 - перевод числа в вещественное для умножение
            mulsd xmm5, xmm4       ; xmm5 - итоговое значение факториала для числа 
            mulsd xmm6, xmm2       ;xmm6 = хранит b в степени 2н+1
            mulsd xmm7, xmm15
            inc r9
            cmp r9, rax
            jbe Fact
       skip:
       mulsd xmm6, xmm2
       xor r9,r9
       mov r9,1
       cvtsi2sd xmm9, r9
        Fact2:
            cvtsi2sd xmm10, r9
            mulsd xmm9,xmm10
            inc r9
            cmp r9,r13
            jbe Fact2
        movsd xmm10, xmm9
        mulsd xmm10,xmm9              ; xmm10 = (n!)^2
        ;Итоговое значение одного числа из ряда хранится в xmm12 и все последующие будут складываться туда xmm13
        xor r9,r9
        mov r9,1
        cvtsi2sd xmm12, r9
        mulsd xmm12,xmm5
        mulsd xmm12,xmm6
        divsd xmm12,xmm7
        divsd xmm12,xmm10
        divsd xmm12,xmm8
        addsd xmm13, xmm12
     inc r13
     cmp r13, [n]
     jle Cons
    subsd xmm3, xmm13           ;arccosb = pi/2 - arcsinb
    skip5:
    PRINT_DOUBLE xmm3
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    movsd xmm6, [e]
    movsd xmm7,xmm3
    xor r8,r8
    mov r8,1
    cvtsi2sd xmm4, r8
    cvtsi2sd xmm9, r8              ; xmm9 - итоговое число
    xor r13,r13
    mov r13,1
    Cons2:                          ; Cons - ряд тейлора, r13 - является счеткиом внешнего цикла r13 - от 0 до n
        xor r9,r9
        mov r9,1
        cvtsi2sd xmm3, r8           ; xmm3 - записываю 1, т.к факториал считается от единицы
        Fact3:                      ; Подсчет факториала идет от 1(r9) до r13
            cvtsi2sd xmm4, r9      ; xmm4 - перевод числа в вещественное для умножение
            mulsd xmm3, xmm4       ; xmm3 - итоговое значение факториала для числа
            inc r9
            cmp r9d, r13d
            jbe Fact3
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
        jle Cons2
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;            Вывод выглядит как: 1- arccos(b)
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                2- e^(arccos(b))
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                3- e^(arccos(b))-a
    movsd xmm8, xmm1
    NEWLINE
    PRINT_DOUBLE xmm9
    subsd xmm9,xmm8
    NEWLINE
    PRINT_DOUBLE xmm9
    end:
    xor rax, rax
    ret
    
    
    skip_all1:
    xor r10,r10
    cvtsi2sd xmm3, r10
    je skip5
    
    skip_all2:
    movsd xmm15, xmm3
    addsd xmm15, xmm3
    subsd xmm3,xmm15
    je skip5