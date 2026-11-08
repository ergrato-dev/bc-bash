# Buscar archivos con find

## Dónde, qué y qué hacer

`grep` busca **dentro** de los archivos; `find` busca **archivos**. Recorre una carpeta y todo lo que hay debajo, y se queda con lo que cumple las condiciones que le pongas:

```text
find  dónde  condiciones  acción
```

Sin condiciones, lo imprime todo (lo usaste en la semana 01 para el inventario). Sin acción, la acción es imprimir la ruta.

```bash
find /usr/bin -name 'bash*'
```

```text
/usr/bin/bashbug
/usr/bin/bash
```

`find` no ordena: devuelve los archivos en el orden en que están guardados en el disco. Si el orden importa, pásalo por `sort`.

## Condiciones

| Condición | Se queda con |
|---|---|
| `-name '*.log'` | nombres que encajan con el patrón; `-iname`, sin distinguir mayúsculas |
| `-type f` / `-type d` | archivos normales / carpetas |
| `-size +1M` | más de 1 MiB; `-size -10k`, menos de 10 KiB |
| `-mtime +7` | modificados hace más de 7 días; `-mtime -1`, en el último día |
| `-maxdepth 1` | no baja más de un nivel; va justo después de la carpeta |
| `! -name '*.gz'` | lo contrario de la condición siguiente |

Varias condiciones seguidas se cumplen **todas a la vez**. `-o` significa "o": `-name '*.log' -o -name '*.txt'`.

```bash
find /etc -maxdepth 1 -name '*.conf' -type f | sort | head -4
```

```text
/etc/adduser.conf
/etc/ca-certificates.conf
/etc/debconf.conf
/etc/deluser.conf
```

El patrón de `-name` no es una regex: es un **glob**, el de la semana 01. `*` es "cualquier texto", `?` es "un carácter". Y va **entre comillas**: sin ellas, si en la carpeta actual hay algún `.log`, bash sustituye `*.log` por esos nombres antes de que `find` lo vea, y busca otra cosa. El lab 06 lo provoca a propósito.

## Acciones

| Acción | Qué hace con cada resultado |
|---|---|
| (ninguna) | imprime la ruta |
| `-exec comando {} +` | ejecuta el comando con todos los resultados como argumentos (`{}` es dónde van) |
| `-delete` | lo borra, sin preguntar |

```bash
find /etc/ssl -maxdepth 1 -name '*.cnf' -exec ls -l {} +
```

Algo como (cambian el tamaño y la fecha):

```text
-rw-r--r-- 1 root root 12324 Sep 16 18:47 /etc/ssl/openssl.cnf
```

`-delete` no tiene vuelta atrás. Antes de usarlo, ejecuta el mismo `find` sin `-delete` y lee la lista. En el bootcamp, solo dentro de `zona/`.

## Errores de permiso

Si `find` entra en una carpeta que no puedes leer, avisa por stderr y sigue:

```bash
find /etc/ssl -type d
```

```text
find: ‘/etc/ssl/private’: Permission denied
/etc/ssl
/etc/ssl/private
/etc/ssl/certs
```

Sale con código `1` aunque haya encontrado cosas. Ya sabes callar esos avisos (`2> /dev/null`, semana 03), pero en un script piensa antes si quieres esconderlos: a veces son justo lo que hay que arreglar.

## find y grep juntos

`grep -rl patrón carpeta` (`-l`: solo el nombre del archivo) busca texto en todos los archivos de una carpeta. Cuando además quieres elegir **qué** archivos, `find` los elige y `grep` busca dentro:

```bash
find /etc -maxdepth 1 -type f -name '*.conf' -exec grep -l ssl {} +
```

```text
/etc/ca-certificates.conf
```

Pasar la lista de `find` a un bucle tiene trampas con los nombres que llevan espacios: la semana 07 enseña la forma segura con `-print0`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Cortar, transformar, ordenar y contar](03-cortar-ordenar-y-contar.md) | [Índice de labs](../2-practicas/README.md) → |

[↑ Semana 04](../README.md)
