# Ayuda, atajos e historial

## Cuatro formas de pedir ayuda

Nadie se sabe todas las opciones. Lo que se aprende es dónde mirarlas.

| Comando | Para qué sirve | Ejemplo |
|---|---|---|
| `type cmd` | dice qué es un comando: programa (y su ruta) o *builtin* de bash | `type cd` |
| `help cmd` | ayuda de los *builtins*: comandos que vienen dentro de bash | `help cd` |
| `cmd --help` | resumen de opciones que traen casi todos los programas | `ls --help` |
| `man cmd` | el manual completo de un programa | `man ls` |

Un **builtin** es un comando que bash ejecuta él mismo, sin lanzar otro programa. `cd` tiene que serlo: un programa aparte cambiaría *su* directorio, no el de tu shell. Por eso `man cd` no existe en Ubuntu y `help cd` sí.

## Leer `man`

`man` abre el manual a pantalla completa. Se maneja con el teclado:

| Tecla | Acción |
|---|---|
| flechas, `Espacio`, `b` | bajar línea, bajar página, subir página |
| `/palabra` + `Enter` | buscar `palabra`; `n` va a la siguiente aparición |
| `q` | salir |

Estructura de casi todas las páginas: `NAME` (qué es en una línea), `SYNOPSIS` (cómo se escribe), `DESCRIPTION` (qué hace y sus opciones). En `SYNOPSIS`, lo que va entre `[ ]` es opcional y `...` significa "uno o más".

## Tab: que bash escriba por ti

Pulsa `Tab` a mitad de un nombre y bash lo completa si solo hay una opción. Si hay varias, un segundo `Tab` las lista. Funciona con comandos, carpetas y archivos.

Úsalo siempre: escribes menos, no te equivocas de letra, pone las comillas o `\` a los nombres con espacios, y si `Tab` no completa nada es que el nombre que crees que existe no existe.

## Historial

bash recuerda lo que ejecutas:

| Tecla o comando | Acción |
|---|---|
| `↑` / `↓` | comando anterior / siguiente |
| `Ctrl+R` + texto | busca hacia atrás el último comando que contiene ese texto; `Enter` lo ejecuta, `Ctrl+R` otra vez busca uno más antiguo |
| `history` | lista numerada de los comandos recientes |
| `!!` | repite el último comando |

El historial se guarda en `~/.bash_history` al cerrar la shell. En el laboratorio, `--rm` borra el contenedor y tu home con él, así que cada sesión empieza con el historial vacío.

## Editar la línea

| Tecla | Acción |
|---|---|
| `Ctrl+A` / `Ctrl+E` | ir al principio / al final de la línea |
| `Ctrl+U` | borrar desde el cursor hasta el principio |
| `Ctrl+W` | borrar la palabra anterior |
| `Alt+B` / `Alt+F` | una palabra atrás / adelante |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Crear, copiar, mover, borrar y buscar](03-crear-copiar-mover-borrar.md) | [Índice de labs](../2-practicas/README.md) → |

[↑ Semana 01](../README.md)
