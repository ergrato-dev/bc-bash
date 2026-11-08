# Crear, copiar, mover, borrar y buscar

## Los seis comandos

| Comando | Qué hace | Opción clave |
|---|---|---|
| `mkdir docs` | crea una carpeta | `-p`: crea las intermedias y no falla si ya existe |
| `touch notas.txt` | crea un archivo vacío (si existe, solo actualiza su fecha) | — |
| `cp a.txt b.txt` | copia un archivo | `-r`: copia una carpeta con todo lo que tiene |
| `mv a.txt docs/` | mueve un archivo o carpeta | `-i`: pregunta antes de sobrescribir |
| `rm a.txt` | borra un archivo | `-r`: borra una carpeta y todo su contenido |
| `rmdir vacia` | borra una carpeta, solo si está vacía | — |

Tres reglas que evitan sustos:

- **El último argumento es el destino.** `cp a.txt b.txt c.txt docs/` copia los tres dentro de `docs/`. Si el destino es una carpeta que existe, el archivo entra dentro; si no existe, el archivo pasa a llamarse así.
- **Renombrar es mover.** `mv viejo.txt nuevo.txt` no copia nada: cambia el nombre. Por eso `mv` es instantáneo aunque el archivo sea enorme (dentro del mismo disco).
- **`cp` y `mv` sobrescriben sin avisar.** Si `docs/a.txt` ya existía, desaparece. Con `-i` preguntan primero.

## `rm` no tiene papelera

Lo que borra `rm` no se puede recuperar. Antes de borrar:

1. Mira qué vas a borrar con `ls` y la misma ruta.
2. Comprueba dónde estás con `pwd`.
3. Usa `rm -i` si dudas: pregunta archivo por archivo (`y` borra, `n` lo deja).

`rm -r` borra una carpeta entera sin preguntar. Nunca la uses con una ruta que no hayas listado antes. En los labs solo se borra dentro de la carpeta `zona/` de cada lab.

## Por qué git no guarda carpetas vacías

git guarda archivos, no carpetas: una carpeta vacía no existe para él. La convención es dejar dentro un archivo oculto vacío llamado `.gitkeep`. No tiene nada especial salvo su nombre, que todo el mundo reconoce.

## Buscar con `find`

`find` recorre un árbol entero y lista lo que encuentra, carpeta a carpeta:

```bash
find docs                  # todo lo que hay dentro de docs, carpetas incluidas
find . -type f             # solo archivos, desde la carpeta actual
find . -type d             # solo carpetas
find . -name '*.txt'       # solo los que terminan en .txt
```

- El primer argumento es **dónde empezar**. Las opciones de después son **filtros**.
- Las rutas que imprime empiezan como la de partida: con `find .` todas empiezan por `./`.
- El orden es el de cómo están guardadas en el disco, no alfabético. Puede cambiar de una máquina a otra.
- Las comillas en `'*.txt'` hacen que el `*` le llegue a `find` tal cual. Sin ellas, bash lo cambiaría antes por los `.txt` de la carpeta actual (lo verás en la semana 05).

## Guardar la salida en un archivo

El símbolo `>` manda la salida de un comando a un archivo en lugar de a la pantalla. Si el archivo existe, **lo reemplaza**:

```bash
find . -type f > docs/inventario.txt
```

La semana 03 explica `>` a fondo. Esta semana te basta con eso.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Sistema de archivos y rutas](02-sistema-de-archivos-y-rutas.md) | [Teoría — Ayuda, atajos e historial](04-ayuda-atajos-e-historial.md) → |

[↑ Semana 01](../README.md)
