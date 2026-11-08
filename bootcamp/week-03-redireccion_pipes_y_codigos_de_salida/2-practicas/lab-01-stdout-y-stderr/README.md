# Lab 01 — stdout y stderr

⏱ Duración estimada: ~60 min

## Objetivo

Separar la salida normal de un comando de sus mensajes de error, mandando cada una a un archivo o a `/dev/null`.

## Contexto

- Todo programa escribe por dos canales: **stdout** (descriptor 1) para los resultados y **stderr** (descriptor 2) para los errores y avisos. En la terminal los dos se ven mezclados ([teoría](../../1-teoria/01-redireccion-y-descriptores.md)).
- `>` manda stdout a un archivo; `2>` manda stderr. Lo que no rediriges sigue saliendo por pantalla.
- `starter/find-ssl.sh` hace inventario de `/etc/ssl`, una carpeta con una subcarpeta que `alumno` no puede leer: produce resultados y errores a la vez.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-03-redireccion_pipes_y_codigos_de_salida/2-practicas/lab-01-stdout-y-stderr
   mkdir zona
   ```
   (sin salida). `zona/` es tu carpeta de pruebas: git la ignora.

1. **Un comando que acierta y falla a la vez:**
   ```bash
   ls /etc/hostname /no-existe
   echo $?
   ```
   ```text
   /etc/hostname
   ls: cannot access '/no-existe': No such file or directory
   2
   ```
   La primera línea es un resultado (stdout); la segunda, un error (stderr). Se ven iguales, pero van por canales distintos. El `2` es el código de salida: algo falló.

2. **Solo stdout a un archivo:**
   ```bash
   ls /etc/hostname /no-existe > zona/salida.txt
   cat zona/salida.txt
   ```
   ```text
   ls: cannot access '/no-existe': No such file or directory
   /etc/hostname
   ```
   `>` se llevó el resultado al archivo, y el error siguió saliendo por pantalla. `>` es una forma corta de `1>`.

3. **Solo stderr a un archivo:**
   ```bash
   ls /etc/hostname /no-existe 2> zona/errores.txt
   cat zona/errores.txt
   ```
   ```text
   /etc/hostname
   ls: cannot access '/no-existe': No such file or directory
   ```
   Ahora es al revés: el resultado sale por pantalla y el error queda en el archivo. Sin espacio entre el `2` y el `>`.

4. **Cada uno a su archivo:**
   ```bash
   ls /etc/hostname /no-existe > zona/salida.txt 2> zona/errores.txt
   cat zona/salida.txt zona/errores.txt
   ```
   ```text
   /etc/hostname
   ls: cannot access '/no-existe': No such file or directory
   ```
   El `ls` no imprimió nada: todo fue a archivos. `cat` con dos archivos los imprime uno detrás de otro.

5. **Los dos al mismo archivo:**
   ```bash
   ls /etc/hostname /no-existe &> zona/todo.txt
   cat zona/todo.txt
   ```
   ```text
   ls: cannot access '/no-existe': No such file or directory
   /etc/hostname
   ```
   `&>` manda stdout y stderr juntos. En el lab 03 verás la forma que funciona en cualquier shell, `> archivo 2>&1`.

6. **El cubo de basura, `/dev/null`:**
   ```bash
   ls /etc/hostname /no-existe 2> /dev/null
   ls -l /dev/null
   cat /dev/null
   ```
   Algo como (cambia la fecha):
   ```text
   /etc/hostname
   crw-rw-rw- 1 root root 1, 3 Nov  8 05:07 /dev/null
   ```
   `/dev/null` no es un archivo normal: la `c` del principio dice que es un dispositivo. Todo lo que se escribe en él desaparece y leerlo no da nada. Sirve para callar lo que no te interesa.

7. **Escribir tú en stderr.** `>&2` manda la salida de un comando al descriptor 2:
   ```bash
   bash -c 'echo resultado; echo aviso >&2' > /dev/null
   bash -c 'echo resultado; echo aviso >&2' 2> /dev/null
   ```
   ```text
   aviso
   resultado
   ```
   El primer `echo` escribe en stdout y el segundo en stderr. Quien lanza el comando decide qué quiere ver: así funciona un script bien hecho.

8. **El script, sin tocar:**
   ```bash
   bash starter/find-ssl.sh
   ```
   ```text
   find: ‘/etc/ssl/private’: Permission denied
   /etc/ssl/certs/ca-certificates.crt
   /etc/ssl/openssl.cnf
   find: ‘/etc/ssl/private’: Permission denied
   /etc/ssl/certs/ca-certificates.crt
   /etc/ssl/openssl.cnf
   ```
   `find /etc/ssl -type f` lista los archivos (`-type f`) de `/etc/ssl` y avisa de la carpeta `private`, que es solo de root. Lo hace dos veces y todo sale por pantalla.

9. **TODO 1.** Abre `starter/find-ssl.sh` en tu editor. Añade al primer `find` las dos redirecciones: `> zona/ssl.txt` y `2> /dev/null`. Prueba:
   ```bash
   bash starter/find-ssl.sh
   cat zona/ssl.txt
   ```
   ```text
   find: ‘/etc/ssl/private’: Permission denied
   /etc/ssl/certs/ca-certificates.crt
   /etc/ssl/openssl.cnf
   /etc/ssl/certs/ca-certificates.crt
   /etc/ssl/openssl.cnf
   ```
   La pantalla ya solo muestra lo del segundo `find`. El archivo tiene la lista limpia.

10. **TODO 2.** En el segundo `find`, al revés: la lista a `/dev/null` y los avisos a `zona/avisos.txt`. Prueba:
    ```bash
    bash starter/find-ssl.sh
    cat zona/avisos.txt
    ```
    ```text
    find: ‘/etc/ssl/private’: Permission denied
    ```
    El script ya no imprime nada; el aviso queda guardado.

11. **TODO 3.** Bajo el último comentario, un `echo "listo: zona/ssl.txt"` que escriba en stderr (`>&2`). Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/find-ssl.sh
    bash starter/find-ssl.sh 2> /dev/null
    ```
    ```text
    listo: zona/ssl.txt
    ```
    La segunda ejecución no imprime nada: el `listo` es un mensaje para la persona, no un resultado, y quien quiera puede callarlo.

## Criterios de éxito

- [ ] Explicas por qué el error del paso 2 salió por pantalla aunque usaste `>`
- [ ] Explicas qué es `/dev/null` y para qué sirve (paso 6)
- [ ] `bash starter/find-ssl.sh` imprime solo `listo: zona/ssl.txt`, y con `2> /dev/null` nada
- [ ] `zona/ssl.txt` tiene los dos archivos y `zona/avisos.txt` el aviso de `private`

## Reto extra

Ejecuta `bash starter/find-ssl.sh > zona/salida.txt`. ¿Qué tiene `zona/salida.txt`? ¿Por qué? Ahora piensa en un script que escribiera `listo` por stdout: ¿qué problema tendría quien quisiera guardar su salida en un archivo?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — Sobrescribir y añadir](../lab-02-sobrescribir-y-anadir/README.md) → |

[↑ Semana 03](../../README.md)
