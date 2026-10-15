<<<<<<< HEAD
.globl app
app:
	//---------------- Inicialización GPIO --------------------

	mov w20, PERIPHERAL_BASE + GPIO_BASE     // Dirección de los GPIO.		
	
	// Configurar GPIO 17 como input:
	mov X21,#0
	str w21,[x20,GPIO_GPFSEL1] 		// Coloco 0 en Function Select 1 (base + 4)   	
	
	//---------------- Main code --------------------
	// X0 contiene la dirección base del framebuffer (NO MODIFICAR)
	
	mov w3, 0xF800    	// 0xF800 = ROJO	
	add x10, x0, 0		// X10 contiene la dirección base del framebuffer
loop2:
	mov x2,512         	// Tamaño en Y
loop1:
	mov x1,512         	// Tamaño en X
loop0:
	sturh w3,[x10]	   	// Setear el color del pixel N
	add x10,x10,2	   	// Siguiente pixel
	sub x1,x1,1	   		// Decrementar el contador X
	cbnz x1,loop0	   	// Si no terminó la fila, saltar
	sub x2,x2,1	   		// Decrementar el contador Y
	cbnz x2,loop1	  	// Si no es la última fila, saltar
	
	// --- Delay loop ---
	movz x11, 0x10, lsl #16
delay1: 
	sub x11,x11,#1
	cbnz x11, delay1
	// ------------------
		
	bl inputRead		// Leo el GPIO17 y lo guardo en x21
	mov w3, 0x001F    	// 0x001F = AZUL	
	add x10, x0, 0		// X10 contiene la dirección base del framebuffer
	cbz X22, loop2
	mov w3, 0x07E0    	// 0x07E0 = VERDE			
	b loop2
	
	// --- Infinite Loop ---	
InfLoop: 
	b InfLoop
	
=======
.text
.global app

// ------------------------------------------------------------
// Ejercicio 1 - Laberinto estatico 512x512, RGB565
// X0 contiene la base del framebuffer. No se modifica main.s.
// Cada pared y elemento se dibuja mediante rectangulos de pixeles.
// ------------------------------------------------------------

app:
    mov x19, x0              // Guardar base del framebuffer

    // Fondo blanco
    mov w1, #0
    mov w2, #0
    mov w3, #512
    mov w4, #512
    movz w5, #0xFFFF
    bl draw_rect

    // --------------------------------------------------------
    // Borde exterior negro (conecta todo el recorrido interior)
    // --------------------------------------------------------
    mov w1, #24
    mov w2, #24
    mov w3, #464
    mov w4, #10
    mov w5, #0
    bl draw_rect             // Borde superior

    mov w1, #24
    mov w2, #24
    mov w3, #10
    mov w4, #464
    mov w5, #0
    bl draw_rect             // Borde izquierdo

    mov w1, #478
    mov w2, #24
    mov w3, #10
    mov w4, #464
    mov w5, #0
    bl draw_rect             // Borde derecho

    mov w1, #24
    mov w2, #478
    mov w3, #464
    mov w4, #10
    mov w5, #0
    bl draw_rect             // Borde inferior

    // --------------------------------------------------------
    // Paredes internas. Los huecos entre segmentos son pasos.
    // Se dejan conexiones entre sectores y callejones sin salida.
    // --------------------------------------------------------

    // Zona superior: recorrido en zigzag
    mov w1, #105
    mov w2, #34
    mov w3, #10
    mov w4, #76
    mov w5, #0
    bl draw_rect

    mov w1, #115
    mov w2, #100
    mov w3, #105
    mov w4, #10
    mov w5, #0
    bl draw_rect

    mov w1, #220
    mov w2, #34
    mov w3, #10
    mov w4, #76
    mov w5, #0
    bl draw_rect

    mov w1, #230
    mov w2, #100
    mov w3, #105
    mov w4, #10
    mov w5, #0
    bl draw_rect

    mov w1, #335
    mov w2, #34
    mov w3, #10
    mov w4, #76
    mov w5, #0
    bl draw_rect

    // Pasillo superior derecho: pared con apertura al final
    mov w1, #345
    mov w2, #145
    mov w3, #123
    mov w4, #10
    mov w5, #0
    bl draw_rect

    // Separacion central superior, abierta abajo
    mov w1, #165
    mov w2, #145
    mov w3, #10
    mov w4, #95
    mov w5, #0
    bl draw_rect

    mov w1, #175
    mov w2, #235
    mov w3, #95
    mov w4, #10
    mov w5, #0
    bl draw_rect

    // Zona central izquierda: dos caminos con entradas
    mov w1, #34
    mov w2, #190
    mov w3, #95
    mov w4, #10
    mov w5, #0
    bl draw_rect

    mov w1, #129
    mov w2, #190
    mov w3, #10
    mov w4, #65
    mov w5, #0
    bl draw_rect

    mov w1, #34
    mov w2, #285
    mov w3, #105
    mov w4, #10
    mov w5, #0
    bl draw_rect

    mov w1, #220
    mov w2, #265
    mov w3, #10
    mov w4, #75
    mov w5, #0
    bl draw_rect

    // Zona central derecha: varias bifurcaciones
    mov w1, #285
    mov w2, #190
    mov w3, #105
    mov w4, #10
    mov w5, #0
    bl draw_rect

    mov w1, #380
    mov w2, #200
    mov w3, #10
    mov w4, #75
    mov w5, #0
    bl draw_rect

    mov w1, #285
    mov w2, #265
    mov w3, #105
    mov w4, #10
    mov w5, #0
    bl draw_rect

    // Conexion hacia el sector inferior
    mov w1, #75
    mov w2, #330
    mov w3, #10
    mov w4, #75
    mov w5, #0
    bl draw_rect

    mov w1, #85
    mov w2, #330
    mov w3, #110
    mov w4, #10
    mov w5, #0
    bl draw_rect

    mov w1, #195
    mov w2, #340
    mov w3, #10
    mov w4, #105
    mov w5, #0
    bl draw_rect

    // Sector inferior central: pared en forma de escalon
    mov w1, #265
    mov w2, #315
    mov w3, #10
    mov w4, #85
    mov w5, #0
    bl draw_rect

    mov w1, #275
    mov w2, #390
    mov w3, #75
    mov w4, #10
    mov w5, #0
    bl draw_rect

    mov w1, #350
    mov w2, #335
    mov w3, #10
    mov w4, #65
    mov w5, #0
    bl draw_rect

    // Pequena rama/callejon sin salida, pero con entrada
    mov w1, #410
    mov w2, #300
    mov w3, #10
    mov w4, #65
    mov w5, #0
    bl draw_rect

    mov w1, #365
    mov w2, #300
    mov w3, #55
    mov w4, #10
    mov w5, #0
    bl draw_rect

    // --------------------------------------------------------
    // Personaje azul en la zona de inicio (arriba a la izquierda)
    // --------------------------------------------------------
    mov w1, #48
    mov w2, #48
    mov w3, #24
    mov w4, #24
    movz w5, #0x001F
    bl draw_rect

    // Meta verde con centro amarillo
    mov w1, #435
    mov w2, #435
    mov w3, #30
    mov w4, #30
    movz w5, #0x07E0
    bl draw_rect

    mov w1, #443
    mov w2, #443
    mov w3, #14
    mov w4, #14
    movz w5, #0xFFE0
    bl draw_rect

halt:
    b halt

// ------------------------------------------------------------
// draw_rect
// Entrada:
//   X19 = base del framebuffer
//   W1 = X inicial, W2 = Y inicial
//   W3 = ancho, W4 = alto, W5 = color RGB565
// Calcula: base + 2 * (x + y * 512)
// ------------------------------------------------------------
draw_rect:
    mov w17, w5              // Color
    uxtw x12, w2             // Fila inicial
    uxtw x13, w4             // Alto restante
    uxtw x14, w3             // Ancho
    uxtw x15, w1             // Columna inicial

row_loop:
    cbz x13, rect_done
    mov x16, x14             // Ancho restante
    add x9, x12, xzr
    lsl x9, x9, #9           // y * 512
    add x9, x9, x15          // x + y*512
    lsl x9, x9, #1           // 2 bytes por pixel
    add x9, x19, x9          // Direccion de la fila
col_loop:
    cbz x16, next_row
    strh w17, [x9]
    add x9, x9, #2
    sub x16, x16, #1
    b col_loop
next_row:
    add x12, x12, #1
    sub x13, x13, #1
    b row_loop

rect_done:
    ret
>>>>>>> f83aec6 (Descripción de los cambios)
