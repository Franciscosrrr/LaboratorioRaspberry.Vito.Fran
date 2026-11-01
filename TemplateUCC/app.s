.section .text
.global app

app:
    mov x10, x0              // Base del framebuffer

    // Fondo rojo
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

    mov x1, #70
    mov x2, #42


dibujar_personaje:
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
        add x1, x1, #-5
        add x2, x2, #-5
        mov x3, #2
        mov x4, #2
        bl dibujar_recta

        add x1, x1, #10
        bl dibujar_recta



        movz w5, #0x07E0

        mov x1, x11
        mov x2, x12
        //cuello
        add x1, x1, #-4
        add x2, x2, #8
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

        add x1, x1, 17
        mov x3, #3
        mov x4, #10
        bl dibujar_recta

        //piernas

        mov x1, x11
        mov x2, x12

        add x1, x1, #2
        add x2, x2, #15
        mov x3, #4
        mov x4, #8
        bl dibujar_recta

        add x1, x1, #10
        mov x3, #4
        mov x4, #8
        bl dibujar_recta
        


InfLoop:
    b InfLoop

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

    // Guardar registros
    mov x19, x30
    mov x20, x1
    mov x21, x2

    // =========================================
    // DIBUJAR HACIA ABAJO
    // =========================================

    mov x23, #0

circulo_abajo:

    // Y^2
    mul x24, x23, x23

    // Probar semiancho desde 8
    mov x25, #8

calcular_ancho_abajo:

    mul x26, x25, x25
    add x27, x26, x24

    cmp x27, #64
    b.le ancho_encontrado_abajo

    sub x25, x25, #1
    b calcular_ancho_abajo

ancho_encontrado_abajo:

    // Ancho total = 2 * semiancho + 1
    lsl x3, x25, #1
    add x3, x3, #1

    // X inicial
    sub x1, x20, x25

    // Y actual
    add x2, x21, x23

    // Altura = 1
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

    // Y^2
    mul x24, x23, x23

    // Probar semiancho
    mov x25, #8

calcular_ancho_arriba:

    mul x26, x25, x25
    add x27, x26, x24

    cmp x27, #64
    b.le ancho_encontrado_arriba

    sub x25, x25, #1
    b calcular_ancho_arriba

ancho_encontrado_arriba:

    // Ancho total
    lsl x3, x25, #1
    add x3, x3, #1

    // X inicial
    sub x1, x20, x25

    // Y actual
    sub x2, x21, x23

    mov x4, #1

    bl dibujar_recta

    add x23, x23, #1

    cmp x23, #8
    b.le circulo_arriba




    br x19

