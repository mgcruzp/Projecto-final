; ALGORITMO DE BOOTH

; VARIABLES
variableA: 0b0
Q: 0b01101000
Q_1: 0b0
M: 0b11101001
COUNT: 0x8

; INICIO DEL CICLO
INICIO_LOOP: 
    MOV ACC, COUNT      ; Carga la dirección de COUNT
    MOV DPTR, ACC       ; Mueve la dirección a DPTR
    MOV ACC, [DPTR]     ; Mueve el contenido de Count a ACC
    JZ FIN_LOOP         ; Salta al final del código si COUNT es cero
    JMP PROCESO         ; Salta al procedimiento de multiplicación

; INICIO DEL PROCEDIMIENTO DE MULTIPLICACIÓN
PROCESO: 
    MOV ACC, Q          ; Carga la dirección de Q
    MOV DPTR, ACC       ; Mueve la dirección a DPTR
    MOV ACC, [DPTR]     ; Mueve el contenido de Q a ACC
    MOV A, ACC          ; Mueve lo que hay en ACC al registro A
    MOV ACC, 0X01       ; Carga 1 en ACC
    AND ACC, A          ; Realiza AND entre Q y 1 para obtener el valor del LSB
    JZ CASOS_0          ; Salta si el LSB es 0
    MOV ACC, Q_1        ; Carga la dirección de Q_1
    MOV DPTR, ACC       ; Mueve la dirección a DPTR
    MOV ACC, [DPTR]     ; Mueve el contenido de Q_1 a ACC
    JZ RESTAR           ; Salta al proceso de resta si es el caso 10
    JMP CORR            ; Salta al proceso de corrimiento si es el caso 11

; CASO 0
CASOS_0: 
    MOV ACC, Q_1        ; Carga la dirección de Q_1
    MOV DPTR, ACC       ; Mueve la dirección a DPTR
    MOV ACC, [DPTR]     ; Mueve el contenido de Q_1 a ACC
    JZ CORR             ; Salta al proceso de corrimiento si es 00
    JMP SUMAR           ; Salta al proceso de suma si es 01

; PROCESO DE SUMA
SUMAR:    
REV_M:        
    MOV ACC, M          ; Carga la dirección de M
    MOV DPTR, ACC       ; Mueve la dirección a DPTR
    MOV ACC, [DPTR]     ; Mueve el contenido de M a ACC
    MOV A, ACC          ; Mueve lo que hay en ACC al registro A
    MOV ACC, 0b10000000 ; Carga 10000000 en ACC
    AND ACC, A          ; Identifica si M es negativo o positivo
    JZ S_MPOS           ; Salta al proceso de resta si M es positivo
    
; PROCESO DE SUMA - CASO M NEGATIVO
S_MNEG: 
    MOV ACC, M          ; Carga la dirección de M
    MOV DPTR, ACC       ; Mueve la dirección a DPTR
    MOV ACC, [DPTR]     ; Mueve el contenido de M a ACC
    MOV A, ACC          ; Mueve lo que hay en ACC al registro A
    MOV ACC, 0b10000000 ; Carga 10000000 en ACC
    ADD ACC, A          ; Cambia el signo de M
    MOV A, ACC          ; Mueve lo que hay en ACC al registro A
    MOV ACC, variableA  ; Carga la dirección de variableA
    MOV DPTR, ACC       ; Mueve la dirección a DPTR 
    MOV ACC, [DPTR]     ; Mueve el contenido de variableA a ACC
    ADD ACC, A          ; Realiza la suma variableA + M
    MOV [DPTR], ACC     ; Actualiza el valor de variableA
    JMP CORR            ; Salta al corrimiento de bits

; PROCESO DE SUMA - CASO M POSITIVO
S_MPOS:
    MOV ACC, M          ; Carga la dirección de M
    MOV DPTR, ACC       ; Mueve la dirección a DPTR
    MOV ACC, [DPTR]     ; Mueve el contenido de M a ACC
    MOV A, ACC          ; Mueve lo que hay en ACC al registro A
    MOV ACC, variableA  ; Carga la dirección de variableA
    MOV DPTR, ACC       ; Mueve la dirección a DPTR 
    MOV ACC, [DPTR]     ; Mueve el contenido de variableA a ACC
    ADD ACC, A          ; Realiza la suma variableA + M
    MOV [DPTR], ACC     ; Actualiza el valor de variableA
    JMP CORR            ; Salta al corrimiento de bits

; PROCESO DE RESTA
RESTAR:
REV_M:        
    MOV ACC, M          ; Carga la dirección de M
    MOV DPTR, ACC       ; Mueve la dirección a DPTR
    MOV ACC, [DPTR]     ; Mueve el contenido de M a ACC
    MOV A, ACC          ; Mueve lo que hay en ACC al registro A
    MOV ACC, 0b10000000 ; Carga 10000000 en ACC
    AND ACC, A          ; Identifica si M es negativo o positivo
    JZ R_MPOS           ; Salta al proceso de resta si M es positivo

; PROCESO DE RESTA - CASO M NEGATIVO
R_MNEG:
    MOV ACC, [DPTR]     ; Mueve el contenido de M a ACC
    INV ACC             ; Hace el complemento a 1
    MOV A, ACC          ; Mueve el complemento a 1 de M al registro A
    MOV ACC, 0X01       ; Carga 1 en ACC
    ADD ACC, A          ; Hace el complemento a 2 de M
    MOV A, ACC          ; Mueve el complemento a 2 de M al registro A
    MOV ACC, 0b10000000 ; Carga 10000000 en ACC
    ADD ACC, A          ; Cambia el signo de M
    MOV A, ACC          ; Mueve el resultado al registro A
    MOV ACC, variableA  ; Carga la dirección de variableA
    MOV DPTR, ACC       ; Mueve la dirección a DPTR
    MOV ACC, [DPTR]     ; Mueve el contenido de variableA a ACC
    ADD ACC, A          ; Realiza la resta variableA - M
    MOV [DPTR], ACC     ; Actualiza el valor de variableA después de la resta
    JMP CORR            ; Salta al corrimiento de bits

; PROCESO DE RESTA - CASO M POSITIVO
R_MPOS:
    MOV ACC, M          ; Carga la dirección de M
    MOV DPTR, ACC       ; Mueve la dirección a DPTR
    MOV ACC, [DPTR]     ; Mueve el contenido de M a ACC
    INV ACC             ; Hace el complemento a 1
    MOV A, ACC          ; Mueve el complemento a 1 de M al registro A
    MOV ACC, 0X01       ; Carga 1 en ACC
    ADD ACC, A          ; Hace el complemento a 2 de M
    MOV A, ACC          ; Mueve el complemento a 2 de M al registro A
    MOV ACC, variableA  ; Carga la dirección de variableA
    MOV DPTR, ACC       ; Mueve la dirección a DPTR
    MOV ACC, [DPTR]     ; Mueve el contenido de variableA a ACC
    ADD ACC, A          ; Realiza la resta variableA - M
    MOV [DPTR], ACC     ; Actualiza el valor de variableA después de la resta
    JMP CORR            ; Salta al corrimiento de bits

; PROCESO DE CORRIMIENTO DE BITS
CORR:
Q_Q_1: 
    MOV ACC, Q          ; Carga la dirección de Q
    MOV DPTR, ACC       ; Mueve la dirección a DPTR 
    MOV ACC, [DPTR]     ; Mueve el contenido de Q a ACC
    MOV A, ACC          ; Mueve lo que hay en ACC al registro A
    MOV ACC, 0x01       ; Carga 1 en ACC
    AND ACC, A          ; Realiza AND para obtener el valor del LSB de Q
    MOV A, ACC          ; Mueve el LSB al registro A
    MOV ACC, Q_1        ; Carga la dirección de Q_1
    MOV DPTR, ACC       ; Mueve la dirección a DPTR
    MOV ACC, A          ; Mueve el LSB de Q a ACC
    MOV [DPTR], ACC     ; Guarda el LSB de Q en Q_1

A_Q:    
    MOV ACC, variableA  ; Carga la dirección de variableA
    MOV DPTR, ACC       ; Mueve la dirección a DPTR 
    MOV ACC, [DPTR]     ; Mueve el contenido de VARIABLEA a ACC
    MOV A, ACC          ; Mueve lo que hay en ACC al registro A
    MOV ACC, 0x01       ; Carga 1 en ACC
    AND ACC, A          ; Realiza AND para obtener el valor del LSB de VARIABLEA
    JZ COR_Q0           ; Si el LSB es 0, salta al corrimiento de bits para ese caso

COR_Q1: 
    MOV ACC, Q          ; Carga la dirección de Q
    MOV DPTR, ACC       ; Mueve la dirección a DPTR 
    MOV ACC, [DPTR]     ; Mueve el contenido de Q a ACC 
    RSH ACC, 0x01       ; Desplaza los bits una posición hacia la derecha
    MOV A, ACC          ; Mueve el resultado al registro A
    MOV ACC, 0b10000000 ; Carga 10000000 en ACC
    ADD ACC, A          ; Cambia el MSB a 1 en el resultado del corrimiento
    MOV [DPTR], ACC     ; Guarda el resultado del corrimiento en Q 
    JMP COR_A           ; Salta al corrimiento de A

COR_Q0: 
    MOV ACC, Q          ; Carga la dirección de Q
    MOV DPTR, ACC       ; Mueve la dirección a DPTR 
    MOV ACC, [DPTR]     ; Mueve el contenido de Q a ACC 
    RSH ACC, 0x01       ; Realiza el corrimiento de bits una posición a la derecha
    MOV [DPTR], ACC     ; Guarda el resultado del corrimiento en Q 
    JMP COR_A           ; Salta al corrimiento de A

COR_A: 
    MOV ACC, variableA  ; Carga la dirección de variableA
    MOV DPTR, ACC       ; Mueve la dirección a DPTR 
    MOV ACC, [DPTR]     ; Mueve el contenido de variableA a ACC 
    MOV A, ACC          ; Mueve lo que hay en ACC al registro A
    MOV ACC, 0b10000000 ; Carga 10000000 en ACC
    AND ACC, A          ; Realiza AND para consultar el valor del MSB de variableA
    JZ COR_A0           ; Si es 0, salta al corrimiento para ese caso

COR_A1: 
    MOV ACC, variableA  ; Carga la dirección de variableA
    MOV DPTR, ACC       ; Mueve la dirección a DPTR 
    MOV ACC, [DPTR]     ; Mueve el contenido de variableA a ACC 
    RSH ACC, 0x01       ; Desplaza los bits una posición a la derecha
    MOV A, ACC          ; Mueve el resultado del corrimiento al registro A
    MOV ACC, 0b10000000 ; Carga 10000000 en ACC
    ADD ACC, A          ; Cambia el MSB a 1 en el resultado del corrimiento
    MOV [DPTR], ACC     ; Guarda el resultado final en variableA
    JMP ACTUALIZA_CONT  ; Salta a la actualización del valor de COUNT

COR_A0: 
    MOV ACC, variableA  ; Carga la dirección de variableA
    MOV DPTR, ACC       ; Mueve la dirección a DPTR 
    MOV ACC, [DPTR]     ; Mueve el contenido de variableA a ACC 
    RSH ACC, 0x01       ; Desplaza los bits una posición a la derecha
    MOV [DPTR], ACC     ; Guarda el resultado final en variableA
    JMP ACTUALIZA_CONT  ; Salta a la actualización del valor de COUNT

ACTUALIZA_CONT: 
    MOV ACC, 0xFF       ; Carga -1 en ACC
    MOV A, ACC          ; Mueve lo que hay en ACC al registro A
    MOV ACC, COUNT      ; Carga la dirección de COUNT 
    MOV DPTR, ACC       ; Mueve la dirección a DPTR 
    MOV ACC, [DPTR]     ; Mueve el contenido de COUNT a ACC 
    ADD ACC, A          ; Resta 1 a COUNT
    MOV [DPTR], ACC     ; Guarda el resultado de la resta en COUNT nuevamente
    JMP INICIO_LOOP     ; Salta al inicio del bucle

; FIN DEL CODIGO
FIN_LOOP: 
    HLT                 ; Fin del codigo
