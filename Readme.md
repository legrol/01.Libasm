## Defensa técnica — decisión sobre wrappers C para enlace PIE

En este proyecto las funciones obligatorias (ft_strlen, ft_strcpy, ft_strcmp,
ft_write, ft_read, ft_strdup) están implementadas en ensamblador 64-bit usando
NASM y la convención de llamadas de x86_64. Para que el binario de pruebas se
compile y enlace de forma segura como PIE (Position Independent Executable),
se han añadido *wrappers* mínimos implementados también en ensamblador (GAS
.S) cuya única finalidad es manejar llamadas a la libc o setear `errno` de
manera portable durante el enlace. Estos wrappers están fuera de `libasm.a`
y solo se utilizan al enlazar el binario de pruebas (`test`).

Motivación técnica:
- Llamadas directas a símbolos externos desde código .s pueden generar
	relocaciones no válidas para PIE (por ejemplo R_X86_64_PC32). Reescribir
	cada .s para emitir código PIC/RIP-relative es posible pero laborioso y
	propenso a errores.
- Los wrappers C son funciones mínimas que no contienen la lógica de las
	funciones obligatorias; solo solucionan incompatibilidades de ABI/enlace
	(p. ej. setear `errno`, invocar `malloc`/`free` de forma segura).

Justificación para la defensa:
- Las funciones requeridas por el subject están implementadas íntegramente en
	ensamblador (.s). Los wrappers (ahora también en ensamblador `.S`) se
	documentan y quedan claramente identificados como auxiliares para el
	enlace PIE y no contienen lógica de negocio.
- Durante la defensa mostraré: los `.s` que implementan la lógica, los
	wrappers C (minimales) y la razón técnica por la que son necesarios. Si el
	tribunal prefiere, puedo convertir una función de ejemplo a PIC 100% en ASM
	durante la sesión para demostrar la alternativa pura en ensamblador.

Archivos relevantes:
- `src/errno_helper.S` — helper en ensamblador para setear `errno` y devolver -1.
- `src/malloc_wrapper.S` — wrapper en ensamblador para `malloc`/`free` cuando sea
	necesario. Ambos son minimos, están en ensamblador y se documentan.

Note about wrappers:
- The wrapper files in `src/*.S` are minimal assembly helpers used only
	for linking the `test` binary as a PIE. They are not included in
	`libasm.a` and do not contain the logic of the mandatory functions.

Detalle de los wrappers y por qué existen:

- `src/errno_helper.S`:
	- Función: `int set_errno_and_return_minus_one(int err)`
	- Propósito: recibir el código errno desde ASM y asignarlo a la variable
		global `errno` en C, devolviendo `-1` para respetar la convención usada por
		`read`/`write` en caso de error. Implementado en ensamblador y usando
		`__errno_location@PLT` internamente (solo en el wrapper).

- `src/malloc_wrapper.S`:
	- Funciones: `void *malloc_wrapper(size_t)`, `void free_wrapper(void *)`
	- Propósito: actuar como símbolos PLT/GOT-friendly que los archivos
		`.s` pueden llamar sin generar relocaciones PC32 inválidas al construir
		un PIE. Los wrappers son mínimos, están implementados en ensamblador y
		hacen una llamada a `malloc@PLT` / `free@PLT`.

Notas para el tribunal:
- Estos wrappers no contienen ninguna lógica de las funciones obligatorias
	(cadena, comparaciones, listas, etc.). Solo resuelven problemas de enlace
	al producir un ejecutable PIE. Si el tribunal exige una versión 100% ASM
	PIC, puedo convertir un ejemplo (o todas las funciones) a código
	RIP-relativo/PLT-compatible en ASM durante la defensa.

Comandos útiles para la defensa:
```
make fclean all
make test
./test
readelf -r libasm.a | head -n 40  # para inspeccionar relocaciones si piden
```

Fin de la explicación técnica breve.

