# Lab 07 — Tablas rotas

⏱ Duración estimada: ~60 min

## Objetivo

Encontrar y arreglar los cuatro fallos típicos de arrays y `printf` en un script, los dos que ve shellcheck y los dos que solo aparecen al mirar la salida.

## Contexto

- `starter/team-table.sh` escribe la tabla de guardias del equipo a partir de `datos/equipo.txt`, con una línea de total y el orden de guardias. Viene **roto a propósito**: cuatro fallos, cada uno marcado con un TODO.
- Los datos tienen lo que rompe los scripts de verdad: un nombre con espacio, letras con tilde y un `%` dentro de un texto.
- Ninguno es un fallo de sintaxis. Están en cómo se expande un array, qué cuenta `${#...}` y qué mide `printf`.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-09-arrays_y_printf/2-practicas/lab-07-tablas-rotas
   ```
   (sin salida).

1. **Los datos y lo que sale.** Abre `starter/team-table.sh` en tu editor y ejecútalo:
   ```bash
   cat datos/equipo.txt
   bash starter/team-table.sh datos/equipo.txt
   ```
   ```text
   Ana María:backend:3
   José:sistemas:5
   Begoña:100% remoto:2
   Luis:frontend:4
   NOMBRE      ROL          GUARDIAS
   Ana María  backend      3
   José       sistemas     5
   starter/team-table.sh: line 24: printf: `r': invalid format character
   Begoña     100
   ```
   Para en la fila de Begoña, a mitad de línea, y el prompt queda pegado a `100`. Y las filas de Ana María y José empiezan a la vez, pero un carácter antes que la cabecera.

2. **Lo que ve shellcheck.**
   ```bash
   shellcheck starter/team-table.sh
   ```
   ```text

   In starter/team-table.sh line 24:
       printf "$line\n" # TODO 1
              ^-------^ SC2059 (info): Don't use variables in the printf format string. Use printf '..%s..' "$foo".


   In starter/team-table.sh line 30:
     for name in ${names[@]}; do # TODO 2
                 ^---------^ SC2068 (error): Double quote array expansions to avoid re-splitting elements.

   For more information:
     https://www.shellcheck.net/wiki/SC2068 -- Double quote array expansions to ...
     https://www.shellcheck.net/wiki/SC2059 -- Don't use variables in the printf...
   ```
   Dos de los cuatro. Los del `TODO 3` y el `TODO 4` no aparecen.

3. **TODO 1: un dato dentro del formato.** `line` lleva `100% remoto`, y `printf` lee `% r` como una instrucción que no existe (lab 06, paso 4). Cambia la línea del `TODO 1` por:
   ```bash
       printf '%s\n' "$line"
   ```
   Prueba:
   ```bash
   bash starter/team-table.sh datos/equipo.txt; echo $?
   ```
   ```text
   NOMBRE      ROL          GUARDIAS
   Ana María  backend      3
   José       sistemas     5
   Begoña     100% remoto  2
   Luis        frontend     4
   9 personas, 14 guardias
   orden de guardias: Ana, María, José, Begoña, Luis
   0
   ```
   Termina. Ahora se ven los otros tres: `9 personas` con cuatro filas, `Ana, María` partida en dos, y solo `Luis` alineado con la cabecera.

4. **TODO 2: el array sin comillas.** `${names[@]}` sin comillas se parte por los espacios (lab 02, paso 1). Es lo que decía `SC2068`. Cambia la línea del `TODO 2` por:
   ```bash
     for name in "${names[@]}"; do
   ```
   Prueba:
   ```bash
   bash starter/team-table.sh datos/equipo.txt | tail -n 2
   ```
   ```text
   9 personas, 14 guardias
   orden de guardias: Ana María, José, Begoña, Luis
   ```

5. **TODO 3: el largo de qué.**
   ```bash
   n="Ana María"
   arr=("Ana María" José)
   echo "${#n} ${#arr} ${#arr[@]}"
   ```
   ```text
   9 9 2
   ```
   `${#arr}` es el largo de `$arr`, que es `${arr[0]}` (lab 01, paso 3): los 9 caracteres de `Ana María`. Cuántos elementos hay es `${#arr[@]}`. Cambia la línea del `TODO 3` por:
   ```bash
     echo "${#names[@]} personas, $total guardias"
   ```
   Prueba:
   ```bash
   bash starter/team-table.sh datos/equipo.txt | tail -n 2
   ```
   ```text
   4 personas, 14 guardias
   orden de guardias: Ana María, José, Begoña, Luis
   ```

6. **TODO 4: `printf` cuenta bytes.** `wc -c` cuenta bytes:
   ```bash
   n=José
   printf '[%-6s]\n' "$n" Jose
   echo "${#n}"
   printf %s "$n" | wc -c
   ```
   ```text
   [José ]
   [Jose  ]
   4
   5
   ```
   `José` son 4 caracteres y 5 bytes: en UTF-8, la `é` ocupa dos. El ancho de `printf` cuenta bytes, y rellena uno de menos por cada tilde o `ñ`. `${#n}` sí cuenta caracteres. En `pad`, cambia la línea del `TODO 4` por:
   ```bash
     # printf cuenta bytes, y una letra con tilde ocupa dos: ${#1} cuenta caracteres.
     printf '%s%*s' "$1" $(($2 - ${#1})) ''
   ```
   Escribe el texto y, detrás, tantos espacios como falten (el `%*s` con un texto vacío del lab 06, paso 8). Prueba:
   ```bash
   bash starter/team-table.sh datos/equipo.txt
   ```
   ```text
   NOMBRE      ROL          GUARDIAS
   Ana María   backend      3
   José        sistemas     5
   Begoña      100% remoto  2
   Luis        frontend     4
   4 personas, 14 guardias
   orden de guardias: Ana María, José, Begoña, Luis
   ```

7. **shellcheck limpio.**
   ```bash
   shellcheck starter/team-table.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué el script paraba en la fila de Begoña (paso 3)
- [ ] Explicas qué contaba `${#names}` y por qué salía `9` (paso 5)
- [ ] Explicas por qué las filas de Ana María y José salían un carácter más cortas (paso 6)
- [ ] `bash starter/team-table.sh datos/equipo.txt` imprime la tabla del paso 6, con todas las filas alineadas
- [ ] `shellcheck starter/team-table.sh` no imprime nada

## Reto extra

`pad` lanza un subshell por celda, porque se llama dentro de `$( )`. Reescríbela como `pad var texto ancho`, con `printf -v` para guardar el resultado en la variable que le digas (`declare -n` de la semana 08 o el propio `-v`). ¿Cuántos subshells ahorras con cuatro personas?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — printf y formatos](../lab-06-printf-y-formatos/README.md) | [Proyecto — bashkit report: el log de bk-run en una tabla](../../3-proyecto/README.md) → |

[↑ Semana 09](../../README.md)
