# 📖 Glosario - Semana 01

Términos clave de la semana sobre fundamentos de terminal y Bash.

---

## A

### Argumento

Valor que se pasa a un comando o script. Ejemplo: en `ls -la /home`, tanto `-la` como `/home` son argumentos.

### Absolute Path (Ruta Absoluta)

Ruta completa desde la raíz del sistema. Siempre empieza con `/`. Ejemplo: `/home/usuario/documentos`.

---

## B

### Bash

**B**ourne **A**gain **Sh**ell. Intérprete de comandos y lenguaje de scripting predeterminado en la mayoría de distribuciones Linux.

### Built-in

Comando integrado directamente en el shell, no es un programa externo. Ejemplos: `cd`, `echo`, `pwd`.

---

## C

### cd

**C**hange **D**irectory. Comando para cambiar de directorio. `cd ~` va al home, `cd ..` sube un nivel.

### chmod

**Ch**ange **Mod**e. Comando para cambiar permisos de archivos. Ejemplo: `chmod 755 script.sh`.

### CLI

**C**ommand **L**ine **I**nterface. Interfaz de línea de comandos, modo de interacción con el sistema mediante texto.

### cp

**C**o**p**y. Comando para copiar archivos o directorios. Usar `-r` para copiar recursivamente.

---

## D

### Directorio

Contenedor de archivos, equivalente a "carpeta" en interfaces gráficas. En Linux todo es un archivo, incluso los directorios.

---

## E

### echo

Comando para mostrar texto en la terminal. Ejemplo: `echo "Hola mundo"`.

### Ejecutable

Archivo con permiso de ejecución (`x`). Los scripts necesitan este permiso para ejecutarse con `./script.sh`.

### Extensión

Sufijo del nombre de archivo que indica su tipo. Ejemplo: `.sh` para scripts, `.txt` para texto.

---

## F

### find

Comando para buscar archivos en el sistema de archivos. Ejemplo: `find /home -name "*.txt"`.

### Flag

Opción que modifica el comportamiento de un comando. Ejemplo: `-l` en `ls -l` activa el listado largo.

---

## G

### GNU

**G**NU's **N**ot **U**nix. Proyecto de software libre que incluye las herramientas de línea de comandos de Linux.

### grep

**G**lobal **R**egular **E**xpression **P**rint. Comando para buscar patrones en texto.

---

## H

### Hidden File (Archivo Oculto)

Archivo cuyo nombre empieza con punto (`.`). No se muestra con `ls` normal, usar `ls -a`.

### Home Directory

Directorio personal del usuario. Representado por `~`. Ruta típica: `/home/usuario`.

---

## L

### ls

**L**i**s**t. Comando para listar contenidos de un directorio. Opciones comunes: `-l`, `-a`, `-la`.

---

## M

### man

**Man**ual. Comando para ver la documentación de otros comandos. Ejemplo: `man ls`.

### mkdir

**M**a**k**e **Dir**ectory. Comando para crear directorios. Usar `-p` para crear padres si no existen.

### mv

**M**o**v**e. Comando para mover o renombrar archivos y directorios.

---

## O

### Octal (Notación)

Sistema numérico base 8 usado para permisos. 7=rwx, 6=rw-, 5=r-x, 4=r--, 0=---. Ejemplo: `chmod 755`.

---

## P

### Path (Ruta)

Ubicación de un archivo o directorio en el sistema de archivos. Puede ser absoluta o relativa.

### Permiso

Atributo que controla acceso a archivos: **r**ead (lectura), **w**rite (escritura), **x** (ejecución).

### Pipe (|)

Operador que conecta la salida de un comando con la entrada de otro. Ejemplo: `ls | grep txt`.

### pwd

**P**rint **W**orking **D**irectory. Muestra el directorio actual.

---

## R

### Relative Path (Ruta Relativa)

Ruta desde el directorio actual. No empieza con `/`. Usa `.` (actual) y `..` (padre).

### rm

**R**e**m**ove. Comando para eliminar archivos. Usar `-r` para directorios, `-f` para forzar.

### Root (/)

Directorio raíz del sistema de archivos, el nivel más alto. También usuario administrador.

---

## S

### Shebang (#!)

Primera línea de un script que indica el intérprete. Ejemplo: `#!/bin/bash`.

### Shell

Programa que interpreta comandos y actúa como interfaz entre el usuario y el sistema operativo.

### stdout / stderr

**St**andard **Out**put / **St**andard **Err**or. Salida estándar y salida de errores de un comando.

---

## T

### Terminal

Aplicación que proporciona una interfaz de texto para interactuar con el shell.

### touch

Comando para crear archivos vacíos o actualizar la fecha de modificación de archivos existentes.

---

## W

### Wildcard (Comodín)

Caracteres especiales para patrones: `*` (cualquier cosa), `?` (un carácter), `[]` (rango).

### Working Directory

Directorio actual donde se ejecutan los comandos. Se muestra con `pwd`.

---

## Símbolos Especiales

| Símbolo | Significado                     |
| ------- | ------------------------------- |
| `~`     | Directorio home del usuario     |
| `.`     | Directorio actual               |
| `..`    | Directorio padre                |
| `/`     | Separador de directorios / Raíz |
| `*`     | Comodín: cualquier cadena       |
| `?`     | Comodín: un carácter            |
| `>`     | Redirección (sobrescribir)      |
| `>>`    | Redirección (añadir)            |
| `\|`    | Pipe (tubería)                  |
| `&`     | Ejecutar en segundo plano       |

---

## 📚 Referencias

- [GNU Bash Manual - Definitions](https://www.gnu.org/software/bash/manual/bash.html#Definitions)
- [Linux Filesystem Hierarchy](https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/)

---

[← Volver a Recursos](../4-recursos/) | [Volver a Week-01 →](../README.md)
