# Filtros de texto: ver, recortar y contar líneas

## Qué es un filtro

En Linux casi todo es texto: la configuración, los logs y la salida de los comandos. Un **filtro** es un comando que lee líneas, hace algo con ellas y escribe el resultado por stdout. Lee de los archivos que le pasas o, si no le pasas ninguno, de su stdin. Por eso funciona igual al final de un pipe:

```bash
wc -l /etc/passwd
wc -l < /etc/passwd
```

```text
20 /etc/passwd
20
```

Con el nombre del archivo, `wc` lo repite en su salida. Leyendo de stdin no sabe de dónde viene el texto y solo imprime el número. Si un script necesita el número solo, usa la segunda forma.

Un filtro no cambia el archivo original: escribe un resultado nuevo. Si lo quieres guardar, lo rediriges (semana 03).

## Ver un archivo

| Comando | Qué hace |
|---|---|
| `cat archivo` | lo imprime entero; `-n` numera las líneas |
| `less archivo` | lo abre en un visor: flechas para moverte, `/texto` para buscar, `q` para salir |
| `head archivo` | las 10 primeras líneas; `head -n 3` o `head -3`, las 3 primeras |
| `tail archivo` | las 10 últimas; `tail -n 2`, las 2 últimas |
| `tail -n +5 archivo` | desde la línea 5 hasta el final |
| `tail -f archivo` | se queda esperando y enseña cada línea nueva que llega; `Ctrl+C` para salir |

```bash
head -3 /etc/passwd
```

```text
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
```

`cat` sirve para archivos cortos. Con uno de miles de líneas, la pantalla se llena y solo ves el final: usa `less`, o `head` y `tail` si solo te interesa el principio o el final. `tail -f` es lo que usarás para mirar un log mientras el servidor escribe en él.

## Un trozo del medio

`head` y `tail` se combinan con un pipe para sacar un rango. Las líneas 10 a 12: primero las 12 primeras y, de esas, las 3 últimas.

```bash
head -12 /etc/passwd | tail -3
```

```text
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
```

## Contar

`wc` (*word count*) cuenta líneas, palabras y bytes. Sin opciones, imprime los tres:

| Opción | Cuenta |
|---|---|
| `-l` | líneas |
| `-w` | palabras (trozos separados por espacios) |
| `-c` | bytes |

`wc -l` al final de un pipe es la forma de preguntar "¿cuántos hay?": cuántas cuentas, cuántos errores en un log, cuántos archivos encontró `find`.

Ojo: `wc -l` cuenta saltos de línea. Si la última línea de un archivo no termina en salto, no la cuenta. Los archivos que generan los comandos siempre terminan en salto; los escritos a mano en algunos editores, no siempre.

## Por qué tantos comandos pequeños

Cada filtro hace una sola cosa. La potencia está en encadenarlos: `grep` elige líneas, `cut` elige columnas, `sort` ordena, `uniq` junta repetidas, `head` recorta y `wc` cuenta. En los siguientes archivos los verás uno a uno y, al final de la semana, juntos en `bk-top-ips`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Semana 04 — Filtros de texto y regex](../README.md) | [Teoría — grep y expresiones regulares](02-grep-y-expresiones-regulares.md) → |

[↑ Semana 04](../README.md)
