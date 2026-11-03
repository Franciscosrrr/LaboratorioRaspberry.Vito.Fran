.section .text
.global app


app:
    // Configurar GPIO 2 y GPIO 3 como salidas
    ldr x20, =0x3F200000

    mov w21, #0x240
    str w21, [x20, #0x00]

    // Apagar ambos LED (activos en bajo)
    mov w21, #12
    str w21, [x20, #0x1C]

bucle_semaforo:

    // ENCENDER LED ROJO (GPIO 3)
    mov w21, #8
    str w21, [x20, #0x28]

    bl esperar_1_segundo

    // APAGAR LED ROJO
    mov w21, #8
    str w21, [x20, #0x1C]

    // ENCENDER LED VERDE (GPIO 2)
    mov w21, #4
    str w21, [x20, #0x28]

    bl esperar_1_segundo

    // APAGAR LED VERDE
    mov w21, #4
    str w21, [x20, #0x1C]

    b bucle_semaforo


esperar_1_segundo:
    movz x14, #0x4240
    movk x14, #0x000F, lsl #16

espera:
    subs x14, x14, #1
    b.ne espera

    ret
