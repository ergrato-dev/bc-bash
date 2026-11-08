# Glosario — Semana 03

| Término | Definición en una línea | Ejemplo |
|---------|------------------------|---------|
| **descriptor de archivo** | Número con el que un proceso identifica cada canal abierto | `0`, `1`, `2` |
| **stdin** | Descriptor 0: lo que el programa lee; por defecto, el teclado | `wc -l < notas.txt` |
| **stdout** | Descriptor 1: los resultados; por defecto, la terminal | `ls > lista.txt` |
| **stderr** | Descriptor 2: errores y avisos; por defecto, la terminal | `find /etc 2> /dev/null` |
| **redirección** | Cambiar adónde apunta un descriptor antes de arrancar un comando | `> f`, `>> f`, `2>&1` |
| **/dev/null** | Dispositivo que tira todo lo que se le escribe | `comando > /dev/null` |
| **noclobber** | Opción que impide que `>` pise un archivo existente | `set -o noclobber` |
| **pipe** | Conecta el stdout de un comando con el stdin del siguiente | `getent passwd \| wc -l` |
| **tee** | Copia su entrada a un archivo y a su salida a la vez | `\| tee -a log.txt` |
| **here-doc** | Varias líneas escritas en el script como stdin de un comando | `cat > app.conf <<EOF` |
| **here-string** | Un solo texto como stdin de un comando | `wc -w <<< "uno dos"` |
| **código de salida** | Número (0–255) con el que termina un comando; `0` es éxito | `echo $?` |
| **PIPESTATUS** | Los códigos de cada comando del último pipe | `echo "${PIPESTATUS[@]}"` |
| **&& / \|\|** | Ejecutan lo de la derecha si lo de la izquierda acierta / falla | `mkdir d && cd d` |
| **modo estricto** | `set -euo pipefail`: el script se para en el primer error | `set -euo pipefail` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | — |

[↑ Semana 03](../README.md)
