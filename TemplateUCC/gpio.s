.global inputRead


inputRead:

    // GPIO 2 y GPIO 3 como salidas
    mov w21, #0x240
    str w21, [x20, #0x00]

// Apagar ambos LED inicialmente
    mov w21, #12
    str w21, [x20, #0x1C]
    // Leer el estado de todos los GPIO del banco 0
    ldr w22, [x20, GPIO_GPLEV0]

    // Volver al programa principal
    br x30
	