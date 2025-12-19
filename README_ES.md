# Libasm — Assembly yourself! (español)

Este repositorio implementa la asignación Libasm: reescribir un conjunto de
funciones estándar de C en ensamblador x86_64 (NASM, sintaxis Intel) y
proporcionar una biblioteca estática `libasm.a` junto con un programa de
pruebas que demuestre el funcionamiento.

Resumen
-------
- Parte obligatoria: implementar en `.s` (NASM) las funciones: `ft_strlen`,
	`ft_strcpy`, `ft_strcmp`, `ft_write`, `ft_read`, `ft_strdup`.
- Parte bonus: funciones adicionales en `libasm_bonus/` (archivos `*_bonus.s`).
- No usar `-no-pie`. Para generar ejecutables PIE-friendly se usan pequeños
	wrappers en ensamblador GAS (`.S`) compilados con `gcc -c` y enlazados solo
	en el binario de pruebas.

¿Por qué existe este repositorio?
--------------------------
El objetivo es educativo: aprender programación en ensamblador de 64 bits y 
la convención de llamada, las llamadas al sistema y el comportamiento de enlace 
en Linux x86_64. El proyecto también practica el empaquetado de código 
ensamblador como una biblioteca estática (`.a`) y la producción de un 
ejecutable de prueba que lo enlaza.

Estructura del repositorio
--------------------------
- `libasm/` 		— fuentes obligatorias en NASM (`*.s`).
- `libasm_bonus/` 	— fuentes bonus en NASM (`*_bonus.s`).
- `src/` 			— `main.c` (harness) y wrappers en ensamblador GAS (`*.S`).
- `includes/` 		— cabeceras usadas por los tests.
- `obj/` 			— objetos generados durante la compilación.
- `Makefile` 		— reglas: `all`, `bonus`, `test`, `test_bonus`, `run_mandatory`,
	                  `run_bonus`, `clean`, `fclean`, `re`.

Requisitos para compilar
------------------------
- `nasm` (ensamblador para `.s`)
- `gcc` (para ensamblar `.S` y enlazar el ejecutable de prueba)
- `make`

Compilar y ejecutar (comandos)
------------------------------
```bash
make            	# construye libasm.a con las funciones obligatorias
make bonus      	# añade objetos bonus a libasm.a
make test       	# construye el ejecutable de pruebas (solo mandatory)
make test_bonus 	# construye ejecutable de pruebas con las pruebas bonus
make run_mandatory 	# construye y ejecuta pruebas mandatory
make run_bonus      # construye y ejecuta pruebas bonus
make fclean     	# limpia archivos generados
```

Si ejecuta `make test` o `make test_bonus`, se creará el binario `test` y podrá 
ejecutarse (`./test`). `test_bonus` primero ejecuta la regla `bonus`, por lo que 
los objetos de bonificación se incluyen en `libasm.a` antes de vincularlos.

Wrappers y compatibilidad PIE (detallado)
----------------------------------------
Problema:

- Las llamadas directas a funciones de libc (como `malloc`, `free`,
	`__errno_location`) desde archivos NASM puros pueden generar relocalizaciones
	(por ejemplo `R_X86_64_PC32`) que no son válidas para objetos PIE. Esto
	provoca errores de enlace al crear binarios PIE.

Solución aplicada:

- Implementar pequeños *wrappers* en ensamblador GAS (`src/*.S`) que llamen
	a `malloc@PLT`, `free@PLT` o `__errno_location@PLT`. Estos wrappers son
	ensamblados con `gcc -c` produciendo objetos con relocaciones PLT/GOT
	adecuadas para PIE.
- Los wrappers solo se enlazan en el ejecutable `test` y no se incluyen en
	`libasm.a`. Así `libasm.a` queda formado por objetos NASM con la
	implementación de las funciones obligatorias.
- IMPORTANTE: Los wrappers se compilan y enlazan únicamente en el ejecutable `test` 
	(ver las reglas del `Makefile`). No se incluyen en `libasm.a`. Esto preserva 
	`libasm.a` como una colección de objetos compilados por NASM que contienen las 
	implementaciones requeridas por el sujeto.

Archivos que implementan wrappers (ejemplos):
- `utils/malloc_wrapper.S` — proporciona `malloc_wrapper(size_t)` y
	`free_wrapper(void *)` y reenvía a `malloc@PLT` / `free@PLT`.
- `utils/errno_helper.S` — proporciona `set_errno_and_return_minus_one(int)` y
	escribe en `__errno_location@PLT`.

Este enfoque es aceptable para la tarea porque las implementaciones requeridas 
(funciones ft_*) están escritas en ensamblador `.s`. Los wrappers están documentados
y se utilizan únicamente para producir un ejecutable de prueba compatible con PIE.

Auditoría breve de los bonus (estado actual)
-------------------------------------------
- `ft_atoi_base_bonus.s` 		— puro ASM, sin dependencias externas.
- `ft_list_size_bonus.s` 		— puro ASM.
- `ft_list_sort_bonus.s` 		— puro ASM (usa función de comparación por puntero).
- `ft_list_push_front_bonus.s` 	— ASM que llama a `malloc_wrapper`.
- `ft_list_remove_if_bonus.s` 	— ASM que llama a `free_wrapper`.

Notas:
- Los `malloc_wrapper` y `free_wrapper` utilizados por algunas fuentes adicionales se 
	implementan en `utils/malloc_wrapper.S` (ensamblador), no en C. Por lo tanto, no se 
	depende de los archivos fuente en C para compilar el ejecutable de prueba.
- Si se requiere un requisito más estricto de que el binario final no llame a libc, 
	se deberá cambiar la API (los llamadores asignan memoria) o implementar un 
	asignador/liberador en ensamblador.

Cómo demostrar cumplimiento en la defensa
----------------------------------------
Comandos útiles para mostrar la estructura y símbolos:

```bash
ar -t libasm.a                        		# listar entradas en la librería
nm -u obj/*.o | sort -u               		# símbolos indefinidos en objetos
readelf -r obj/ft_list_push_front_bonus.o  	# relocaciones de un objeto
readelf -d test | sed -n '1,120p'     		# NEEDED / PLT info del ejecutable
nm -C libasm.a | sed -n '1,200p'      		# símbolos exportados por la librería
```

Guion corto para la defensa:
1. `make fclean all` 	— mostrar `libasm.a` creado.
2. `make test` 			— explicar por qué los wrappers se compilan con `gcc -c`.
3. `./test` 			— ejecutar y mostrar resultados.
4. `nm -A libasm.a`		— lista los miembros del archivo y sus símbolos; úsalo para
   						  verificar que las funciones obligatorias (p. ej. `ft_strlen`, 
						  `ft_read`) están definidas dentro de `libasm.a` y que los 
						  helpers (`src/*.S`) no se han incluido accidentalmente en 
						  la biblioteca estática.
5. `nm -u obj/*.o` 		— explicar que los wrappers son los adaptadores a libc.
6. Si se le pregunta sobre PIC vs. no PIC en NASM, explique el problema de 
   reubicación y muestre un pequeño ejemplo o convierta una función en vivo a 
   PIC-ASM si lo desea.

Notas y solución de problemas
-----------------------------
- Si aparece un error sobre relocaciones `R_X86_64_PC32`, comprueba que los
	wrappers estén compilados con `gcc -c` (reglas del `Makefile`).
- Si hay segfault en tests, usa `gdb` o `valgrind` para localizar el fallo;
	revisa la convención de llamadas y la alineación de pila en ASM.

Licencia
-------
Este repositorio es educativo. 
