%include "io64.inc"
%include "io64_float.inc"
section .rodata
one: dq 1
three: dq 3
n: dd 25
section .bss
y: resq 5
stepen: resq 2
e: resq 2
section .text
global CMAIN
CMAIN:
    ;write your code here             y<ln^3((sin(x)+a))
    READ_DOUBLE xmm1                ; xmm1 = хранит значение x
    READ_DOUBLE y                   ; xmm2 = хранит значение y
    READ_DOUBLE xmm3                ; xmm3 = хранит значение а
    xor r13,r13
    mov r13,1
    xor r8,r8
    mov r8,1                        ; xmm4 - будет хранить значение sin(xmm1)
                                    ; xmm5 - будет хранить факториал
                                    ; xmm6 - хранит число xmm1 в степени
    cvtsi2sd xmm9,r8
    xor r14,r14
    mov r14,1                       ; r14 - отвечает за смену знака 
    Sin:
        xor r9,r9
        mov r9,1
        cvtsi2sd xmm5, r9
        cvtsi2sd xmm6, r9
        Fact:
            cvtsi2sd xmm8, r9
            mulsd xmm5, xmm8
            add r9,1
            cmp r9,r13
            jle Fact
        ;PRINT_DOUBLE xmm5
        xor r9,r9
        mov r9,1
        XinPower:
            mulsd xmm6,xmm1
            inc r9
            cmp r9,r13
            jle XinPower
        ;PRINT_DOUBLE xmm6
        cvtsi2sd xmm9,r8
        mulsd xmm9, xmm6
        divsd xmm9, xmm5
        cvtsi2sd xmm10, r14         ; xmm10 отвечает за смену знака
        mulsd xmm9,xmm10
        neg r14
        addsd xmm4, xmm9
        add r13,2
        cmp r13,50
        jle Sin
    ;PRINT_DOUBLE xmm4               ; y < xmm4+a
                                    ; y < ln^3(xmm4+xmm3)
    addsd xmm4,xmm3                 ; y < ln^3(xmm4)
                                    ;sqrt3(y) < ln xmm4
    finit
    fld qword [one]
    fld qword [three]
    fdiv
    fstp qword [stepen]
    ;PRINT_DOUBLE [stepen]
                                    ; stepen =1/3
    xor r9,r9
    cmp r9,[y]
    je dropIT;-------------------------------------------------------------------------- proverka na ln(0)
    fld qword[stepen]
    fld qword[y]
    fyl2x ;вычисляем показатель
    fstp qword[y]
    PRINT_DOUBLE [y]
    fld1 ;загружаем +1.0 в стек
    fld ST1 ;дублируем показатель в стек
    fprem ;получаем дробную часть
    f2xm1 ;возводим в дробную часть показателя                                      
    fadd ;прибавляем 1 из стека
    fscale ;возводим в целую часть и умножаем
    fstp qword [y] ; выталкиваем лишнее из вершины
    ;PRINT_DOUBLE [y]               ; y = y^stepen
                                   ; y<lnxmm4
                                   ; e^y < xmm4
    dropIT:;---------------------------------------------------------------------------
    NEWLINE
    READ_DOUBLE xmm6                 ;   xmm6 - хранит число экспоненты - 2.71828
    movsd xmm7, [y]             ; xmm7 - хранит степень
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
        Fact2:                      ; Подсчет факториала идет от 1(r9) до r13
            cvtsi2sd xmm4, r9      ; xmm4 - перевод числа в вещественное для умножение
            mulsd xmm3, xmm4       ; xmm3 - итоговое значение факториала для числа
            inc r9
            cmp r9d, r13d
            jbe Fact2
       ; PRINT_DOUBLE xmm3
        xor r10,r10
        mov r10, 1
        ;PRINT_DOUBLE xmm3
        cvtsi2sd xmm8, r8           ; заношу число пользователя(степень) в регистр xmm8
        XinPower2:                    ; Возведение в степень идет от 1(r9) до r13
            mulsd xmm8, xmm7         ; xmm8 -  итого значение для числа возведения в степень
            inc r10
            cmp r10d, r13d
            jbe XinPower2
        divsd xmm8,xmm3
        addsd xmm9,xmm8
        inc r13
        cmp r13d,[n]
        jle Cons2
    ;PRINT_DOUBLE xmm9
                                    ;xmm9 < xmm4                 
    subsd xmm4,xmm9                 ; 0< xmm4- xmm2 =>   0<xmm4
    xor r8,r8
    cvtsi2sd xmm3, r8
    COMISD xmm4,xmm3
    jb end1
    end:
    NEWLINE
    PRINT_STRING "YEEEEES < LEST GOOO"
    ret
    end1:
    NEWLINE
    PRINT_STRING "NOOOOO< WHYYYY"
    xor rax,rax
    ret
    