# Lab 01 — Funciones

⏱ Duración estimada: ~60 min

## Objetivo

Definir funciones, pasarles argumentos y organizar un script con una función `main` que se llama al final.

## Contexto

- Una **función** es un trozo de script con nombre: `nombre() { comandos; }`. Se llama como un comando, `nombre arg1 arg2`, y dentro recibe sus argumentos en `$1`, `$2`, `$#` y `"$@"`, igual que un script (semana 06).
- bash lee el script de arriba abajo: una función solo existe a partir de la línea en la que se define.
- `starter/check-files.sh` comprueba una lista de archivos y dice cuántas líneas tiene cada uno, o que falta. `datos/` tiene dos archivos de configuración.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-08-funciones_alcance_y_librerias/2-practicas/lab-01-funciones
   ```
   (sin salida).

1. **Tu primera función.** Escríbela en la terminal: definirla no ejecuta nada.
   ```bash
   greet() { echo "hola, $1"; }
   ```
   (sin salida). Llámala:
   ```bash
   greet ana
   greet "ana maria"
   ```
   ```text
   hola, ana
   hola, ana maria
   ```
   Las comillas funcionan como con cualquier comando: `"ana maria"` es un solo argumento.

2. **Lo que guarda bash.** `type` dice qué es un nombre: un comando, un builtin o una función.
   ```bash
   type greet
   ```
   ```text
   greet is a function
   greet () 
   { 
       echo "hola, $1"
   }
   ```
   La función vive en tu shell hasta que sales del laboratorio. `unset -f greet` la borra.

3. **Los argumentos de la función no son los del script.** `bash -c '...' bash a b c d` ejecuta el texto en una bash nueva con cuatro argumentos, como un script:
   ```bash
   bash -c 'show_args() { echo "$# argumentos: $*"; echo "primero: $1"; }; show_args uno "dos tres"; echo "en el script: $# argumentos"' bash a b c d
   ```
   ```text
   2 argumentos: uno dos tres
   primero: uno
   en el script: 4 argumentos
   ```
   Dentro de la función, `$#` y `$1` son los de la llamada (`uno` y `dos tres`). Fuera, los del script (`a b c d`).

4. **Primero se define, después se llama.**
   ```bash
   bash -c 'saluda; saluda() { echo hola; }'
   ```
   ```text
   bash: line 1: saluda: command not found
   ```
   Cuando bash llega a `saluda`, todavía no ha leído la definición.

5. **TODO 1: `main`.** Abre `starter/check-files.sh` en tu editor y pruébalo tal cual:
   ```bash
   bash starter/check-files.sh datos/nginx.conf
   ```
   ```text
   sin implementar: datos/nginx.conf
   ```
   Borra el comentario del `TODO 1` y el `echo "sin implementar: $*"`, y escribe al final del archivo:
   ```bash
   main() {
     echo "comprobando $# archivos"
     for f in "$@"; do
       check_file "$f"
     done
   }

   main "$@"
   ```
   `main` agrupa lo que hace el script, y la última línea la llama con los argumentos del script. Cuando bash llega a esa línea ya ha leído **todas** las funciones, así que el orden en que están escritas da igual. Prueba:
   ```bash
   bash starter/check-files.sh datos/nginx.conf datos/app.env "datos/no existe.conf"
   ```
   ```text
   comprobando 3 archivos
   sin implementar: check_file datos/nginx.conf
   sin implementar: check_file datos/app.env
   sin implementar: check_file datos/no existe.conf
   ```
   `check_file` todavía es el borrador. Cambia la última línea a `main` (sin `"$@"`) y repite: imprime `comprobando 0 archivos`. Una función solo recibe lo que le pasas. Vuelve a poner `main "$@"`.

6. **TODO 2: `check_file`.** En `check_file`, borra el comentario del `TODO 2` y el `echo`, y escribe:
   ```bash
     if [[ -f $1 ]]; then
       echo "ok: $1 ($(wc -l < "$1") líneas)"
     else
       echo "falta: $1"
     fi
   ```
   `wc -l < archivo` cuenta las líneas sin imprimir el nombre (semana 04). Prueba:
   ```bash
   bash starter/check-files.sh datos/nginx.conf datos/app.env "datos/no existe.conf"; echo $?
   ```
   ```text
   comprobando 3 archivos
   ok: datos/nginx.conf (3 líneas)
   ok: datos/app.env (2 líneas)
   falta: datos/no existe.conf
   0
   ```

7. **shellcheck.**
   ```bash
   shellcheck starter/check-files.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué `$#` valía `2` dentro de `show_args` y `4` fuera (paso 3)
- [ ] Explicas por qué `main "$@"` va en la última línea del script
- [ ] `bash starter/check-files.sh datos/nginx.conf datos/app.env "datos/no existe.conf"` imprime las cuatro líneas del paso 6
- [ ] `shellcheck starter/check-files.sh` no imprime nada

## Reto extra

Añade una función `usage` que imprima `uso: check-files.sh <archivo>...` en stderr, y haz que `main` la llame y salga con código `2` si no recibe ningún archivo.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — return y salida](../lab-02-return-y-salida/README.md) → |

[↑ Semana 08](../../README.md)
