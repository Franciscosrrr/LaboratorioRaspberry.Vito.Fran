.global inputRead

inputRead:

    // Leer el estado de todos los GPIO del banco 0
    ldr w22, [x20, GPIO_GPLEV0]

    // Volver al programa principal
    br x30
	