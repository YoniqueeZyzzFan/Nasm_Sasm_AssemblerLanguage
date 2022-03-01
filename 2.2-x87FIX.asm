%include "io64.inc"
%include "io64_float.inc"
section .data
e: dq 2.71828
section .rodata
one: dq 1
three: dq 3
zero: dq 0
section .bss
stepen: resq 1
result: resq 5
rad: resq 5
a: resq 5
y: resq 5                       
section .text                       
global CMAIN
CMAIN:
    mov rbp, rsp; for correct debugging
    ;write your code here 
    READ_DOUBLE rad                        ; rad = x    
    READ_DOUBLE y                    
    READ_DOUBLE a                   
    xor r10,r10                            ; y<ln^3(sin(x)+a)         =>   sqrt3(y) < ln (six(x)+a)
    finit
    fld qword[rad]
    fsin
    fstp qword [result]
    ;PRINT_DOUBLE result                    ; В result = sin(x)
    
    fld qword[result]
    fld qword[a]
    fadd
    fstp qword [result]                    ; В result  = sin(x)+a                                            
    fld qword[result]
    fld qword[zero]
    FCOMI
    ja exception
    fld qword [one]
    fld qword [three]
    fdiv
    fstp qword [stepen]
    ;PRINT_DOUBLE [stepen]                    ;e^(y^1/3)<result
    fld qword[stepen]
    fld qword[y]
    fyl2x ;вычисляем показатель
    fld1 ;загружаем +1.0 в стек
    fld ST1 ;дублируем показатель в стек
    fprem ;получаем дробную часть
    f2xm1 ;возводим в дробную часть показателя
    fadd ;прибавляем 1 из стека
    fscale ;возводим в целую часть и умножаем
    fstp qword [y] ; выталкиваем лишнее из вершины
    ;PRINT_DOUBLE result                      ;   e^(y) < result
    fld qword[y]
    fld qword[e]
    fyl2x ;вычисляем показатель
    fld1 ;загружаем +1.0 в стек
    fld ST1 ;дублируем показатель в стек
    fprem ;получаем дробную часть
    f2xm1 ;возводим в дробную часть показателя
    fadd ;прибавляем 1 из стека
    fscale ;возводим в целую часть и умножаем
    fstp qword [y] ; выталкиваем лишнее из вершины
    ;PRINT_DOUBLE [y]
    NEWLINE
                                          ;      y<result
    fld qword [result]
    fld qword [y]
    fsub
    fstp qword[y]                        ;       0<y
    ;PRINT_DOUBLE [y]       
    fld qword [y]
    fld qword[zero]
    FCOMI
    ja end
    NEWLINE;
    PRINT_STRING "Yes, its fine"
    ret
    end:
    NEWLINE
    PRINT_STRING "No< bad values"
    ret
    exception:
    NEWLINE
    PRINT_STRING "LogX, x<=0 it cant be..."
    ret