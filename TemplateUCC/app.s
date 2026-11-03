.section .text
.global app

app:

    // ========================================
    // INICIALIZACION
    // ========================================

    // Base de los GPIO
    mov w20, PERIPHERAL_BASE + GPIO_BASE

    // GPIO 14, 15, 17 y 18 como entradas
    mov w21, #0
    str w21, [x20, GPIO_GPFSEL1]

    // Base del framebuffer
    mov x10, x0

    // Coordenadas permanentes del personaje
    mov x28, #70
    mov x29, #42

    // Dibujar escenario inicial
    bl dibujar_laberinto

    mov x1, x28
    mov x2, x29
    bl dibujar_personaje


// ========================================
// BUCLE PRINCIPAL
// ========================================

loop_principal:

    mov w21, #8
    str w21, [x20, #0x28]

    mov w21, #4
    str w21, [x20, #0x1C]
    // Leer pulsadores
    bl inputRead

    // Recuperar posición actual
    mov x1, x28
    mov x2, x29

    // GPIO14: ARRIBA
    tbnz w22, #14, mover_arriba

    // GPIO15: IZQUIERDA
    tbnz w22, #15, mover_izquierda

    // GPIO17: DERECHA
    tbnz w22, #17, mover_derecha

    // GPIO18: ABAJO
    tbnz w22, #18, mover_abajo

    // Ningún pulsador presionado
    bl comprobar_meta

    b loop_principal


// ========================================
// CANCELAR MOVIMIENTO
// ========================================

cancelar_movimiento:
    b loop_principal


// ========================================
// ACTUALIZAR COORDENADAS
// ========================================

mover_arriba:
    sub x2, x2, #5
    b actualizar_personaje

mover_abajo:
    add x2, x2, #5
    b actualizar_personaje

mover_izquierda:
    sub x1, x1, #5
    b actualizar_personaje

mover_derecha:
    add x1, x1, #5
    b actualizar_personaje


// ========================================
// COMPROBAR Y ACEPTAR MOVIMIENTO
// ========================================

actualizar_personaje:

    // ¿El personaje está dentro del ancho de la salida?
    cmp x1, #282
    b.lt verificar_colision

    cmp x1, #321
    b.gt verificar_colision

    // ¿Está llegando al borde inferior?
    add x13, x2, #49
    cmp x13, #487
    b.lt verificar_colision

    // Está en la salida: permitir avanzar
    b aceptar_movimiento

verificar_colision:
    bl detectar_colision
    cbnz w0, cancelar_movimiento

aceptar_movimiento:
    mov x28, x1
    mov x29, x2

    bl dibujar_laberinto

    mov x1, x28
    mov x2, x29
    bl dibujar_personaje

    bl comprobar_meta
    cbnz w0, reiniciar_juego

    b loop_principal

movz x14, #0x4240
movk x14, #0x000F, lsl #16

delay_movimiento:
    subs x14, x14, #1
    b.ne delay_movimiento

    b loop_principal


dibujar_laberinto:
    // Fondo rojo
    mov x18, x30
    mov x1, #0
    mov x2, #0
    mov x3, #512
    mov x4, #512
    movz w5, #0xF800
    bl dibujar_recta

    // Marco exterior azul: entrada superior x=50..100
    movz w5, #0x001F
    mov x1, #15
    mov x2, #15
    mov x3, #178
    mov x4, #10
    bl dibujar_recta
    mov x1, #241
    mov x2, #15
    mov x3, #246
    mov x4, #10
    bl dibujar_recta

    // Bordes laterales
    mov x1, #15
    mov x2, #15
    mov x3, #10
    mov x4, #482
    bl dibujar_recta
    mov x1, #487
    mov x2, #15
    mov x3, #10
    mov x4, #482
    bl dibujar_recta

    // Borde inferior con salida x=300..360
    mov x1, #15
    mov x2, #487
    mov x3, #267
    mov x4, #10
    bl dibujar_recta
    mov x1, #345
    mov x2, #487
    mov x3, #152
    mov x4, #10
    bl dibujar_recta


    // Meta

    movz w5, #0xFFE0 //amarillo
    mov x1, #286
    mov x2, #491
    mov x3, #55
    mov x4, #6
    bl dibujar_recta

    // Muros internos
    // Vertical superior izquierda
    movz w5, #0x001F
    mov x1, #109
    mov x2, #25
    mov x3, #6
    mov x4, #84
    bl dibujar_recta

    // Horizontal superior central-derecha
    mov x1, #172
    mov x2, #103
    mov x3, #315
    mov x4, #6
    bl dibujar_recta

    // Vertical que baja desde el muro superior
    mov x1, #241
    mov x2, #109
    mov x3, #6
    mov x4, #63
    bl dibujar_recta

    // Horizontal izquierda
    mov x1, #25
    mov x2, #166
    mov x3, #157
    mov x4, #6
    bl dibujar_recta

    // Horizontal derecha
    mov x1, #310
    mov x2, #166
    mov x3, #114
    mov x4, #6
    bl dibujar_recta

    // Vertical derecha corta
    mov x1, #418
    mov x2, #172
    mov x3, #6
    mov x4, #84
    bl dibujar_recta

    

    // Horizontal derecha
    mov x1, #282
    mov x2, #250
    mov x3, #142
    mov x4, #6
    bl dibujar_recta

    // Horizontal izquierda
    mov x1, #88
    mov x2, #250
    mov x3, #125
    mov x4, #6
    bl dibujar_recta


    // Vertical central larga hacia la zona inferior
    mov x1, #276
    mov x2, #250
    mov x3, #6
    mov x4, #237
    bl dibujar_recta



    // Vertical de retorno izquierda
    mov x1, #207
    mov x2, #256
    mov x3, #6
    mov x4, #84
    bl dibujar_recta

    // Horizontal inferior izquierda
    mov x1, #25
    mov x2, #334
    mov x3, #188
    mov x4, #6
    bl dibujar_recta

    // Horizontal inferior central
    mov x1, #88
    mov x2, #415
    mov x3, #194
    mov x4, #6
    bl dibujar_recta


    // Zona inferior derecha: recorrido en U
    mov x1, #345
    mov x2, #319
    mov x3, #6
    mov x4, #168
    bl dibujar_recta

    mov x1, #351
    mov x2, #319
    mov x3, #73
    mov x4, #6
    bl dibujar_recta

    mov x1, #418
    mov x2, #325
    mov x3, #6
    mov x4, #99
    bl dibujar_recta

    br x18

dibujar_personaje:
        mov x17, x30
        movz w5, #0xB420

        // sombrero
        bl dibujar_triangulo
        //Cabeza
        movz w5, #0x07E0
        
        add x1, X1, #11
        add x2, x2, #18 
        bl dibujar_circulo
        
        mov x11, x1 
        mov x12, x2

        //ojos
        movz w5, #0x0000
        sub x1, x1, #3
        sub x2, x2, #2
        mov x3, #2
        mov x4, #2
        bl dibujar_recta

        add x1, x1, #8
        bl dibujar_recta



        movz w5, #0x07E0

        mov x1, x11
        mov x2, x12
        //cuello
        sub x1, x1, #3
        add x2, x2, #7
        mov x3, #8
        mov x4, #2
        bl dibujar_recta
        //torso
        sub x1, x1, #4
        add x2, x2, #2
        mov x3, #16
        mov x4, #14 
        bl dibujar_recta

        mov x11, x1
        mov x12, x2

        //Brazos
        sub x1, x1, #4
        add x2, x2, #1
        mov x3, #3
        mov x4, #8
        bl dibujar_recta

        mov x1, x11

        add x1, x1, #17
        mov x3, #3
        mov x4, #10
        bl dibujar_recta

        //piernas

        mov x1, x11
        mov x2, x12

        add x1, x1, #1
        add x2, x2, #15
        mov x3, #4
        mov x4, #8
        bl dibujar_recta

        add x1, x1, #10
        mov x3, #4
        mov x4, #8
        bl dibujar_recta
    
    br x17


// dibujar_recta: X10=base, X1=x, X2=y, X3=ancho, X4=alto, W5=RGB565
dibujar_pixel:
    lsl x6, x2, #9       
    add x6, x6, x1       
    lsl x6, x6, #1       
    add x6, x10, x6      
    sturh w5, [x6]       
    ret

dibujar_recta:
    mov x6, x2
    mov x7, x4
row_loop:
    cbz x7, rect_done
    mov x8, x3
    lsl x9, x6, #9
    add x9, x9, x1
    lsl x9, x9, #1
    add x9, x10, x9
col_loop:
    cbz x8, next_row
    sturh w5, [x9]
    add x9, x9, #2
    sub x8, x8, #1
    b col_loop
next_row:
    add x6, x6, #1
    sub x7, x7, #1
    b row_loop
rect_done:
    ret

// X1 = centro X
// X2 = tope Y

dibujar_triangulo:
    mov x6, #0

tri_fila:
    cmp x6, #11
    b.ge tri_fin

    // Ancho = (fila + 1) * 2
    add x7, x6, #1
    lsl x7, x7, #1

    // Centrar la fila respecto a X1
    mov x8, #10
    sub x8, x8, x6
    add x8, x1, x8

    // Dirección del primer píxel de la fila
    add x9, x2, x6
    lsl x9, x9, #9
    add x9, x9, x8
    lsl x9, x9, #1
    add x9, x10, x9

tri_pixel:
    cbz x7, tri_siguiente
    sturh w5, [x9]
    add x9, x9, #2
    sub x7, x7, #1
    b tri_pixel

tri_siguiente:
    add x6, x6, #1
    b tri_fila

tri_fin:
    ret

dibujar_circulo:

    // Guardar retorno y centro
    mov x16, x30
    mov x19, x1
    mov x21, x2

    // =========================================
    // DIBUJAR HACIA ABAJO
    // =========================================

    mov x23, #0

circulo_abajo:

    mul x24, x23, x23

    mov x25, #8

calcular_ancho_abajo:

    mul x26, x25, x25
    add x27, x26, x24

    cmp x27, #64
    b.le ancho_encontrado_abajo

    sub x25, x25, #1
    b calcular_ancho_abajo

ancho_encontrado_abajo:

    lsl x3, x25, #1
    add x3, x3, #1

    sub x1, x19, x25
    add x2, x21, x23

    mov x4, #1

    bl dibujar_recta

    add x23, x23, #1

    cmp x23, #8
    b.le circulo_abajo


    // =========================================
    // DIBUJAR HACIA ARRIBA
    // =========================================

    mov x23, #1

circulo_arriba:

    mul x24, x23, x23

    mov x25, #8

calcular_ancho_arriba:

    mul x26, x25, x25
    add x27, x26, x24

    cmp x27, #64
    b.le ancho_encontrado_arriba

    sub x25, x25, #1
    b calcular_ancho_arriba

ancho_encontrado_arriba:

    lsl x3, x25, #1
    add x3, x3, #1

    sub x1, x19, x25
    sub x2, x21, x23

    mov x4, #1

    bl dibujar_recta

    add x23, x23, #1

    cmp x23, #8
    b.le circulo_arriba


    // Restaurar coordenadas originales
    mov x1, x19
    mov x2, x21

    // Retornar
    br x16


detectar_colision:

    mov x13, x1
    add x17, x1, #24


    mov x14, x2
    add x18, x2, #50

fila_colision:

    cmp x14, x18
    b.ge sin_colision

    mov x15, x13           // X actual

pixel_colision:

    cmp x15, x17
    b.ge siguiente_fila

    // Dirección del píxel:
    // framebuffer + 2 * (X + Y * 512)

    lsl x16, x14, #9
    add x16, x16, x15
    lsl x16, x16, #1
    add x16, x10, x16

    // Leer color del píxel
    ldrh w16, [x16]

    // ¿Es azul?
    cmp w16, #0x001F
    b.eq hay_colision

    add x15, x15, #1
    b pixel_colision

siguiente_fila:

    add x14, x14, #1
    b fila_colision

reiniciar_juego:
    // Apagar LED rojo (GPIO 3)
    mov w21, #8
    str w21, [x20, #0x1C]

    // Encender LED verde (GPIO 2)
    mov w21, #4
    str w21, [x20, #0x28]

    // Espera de reinicio
    mov x13, #30

espera_externa:

    movz x14, #0x4240
    movk x14, #0x000F, lsl #16

espera_interna:

    subs x14, x14, #1
    b.ne espera_interna

    subs x13, x13, #1
    b.ne espera_externa


    mov x28, #70
    mov x29, #42


    bl dibujar_laberinto

    mov x1, x28
    mov x2, x29
    bl dibujar_personaje

    b loop_principal

hay_colision:

    mov w0, #1
    ret

sin_colision:

    mov w0, #0
    ret



comprobar_meta:


    cmp x28, #282
    b.lt sin_meta

    cmp x28, #321
    b.gt sin_meta

    add x13, x29, #49
    cmp x13, #497
    b.lt sin_meta

    // Victoria
    mov w0, #1
    ret

sin_meta:
    mov w0, #0
    ret



