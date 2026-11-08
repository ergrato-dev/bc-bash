# Labs — Semana 05: Variables, comillas y expansiones

| # | Lab | Objetivo | Tiempo |
|---|-----|----------|--------|
| 1 | [lab-01-variables](lab-01-variables/README.md) | Guardar y usar valores en variables, y exportarlas a otros programas | ~60 min |
| 2 | [lab-02-comillas](lab-02-comillas/README.md) | Elegir entre comillas simples, dobles, `\` y `$'...'` | ~60 min |
| 3 | [lab-03-word-splitting-y-globbing](lab-03-word-splitting-y-globbing/README.md) | Ver qué hace bash con una variable sin comillas y evitarlo | ~60 min |
| 4 | [lab-04-valores-por-defecto](lab-04-valores-por-defecto/README.md) | Valores por defecto y variables obligatorias con `${var:-}` y `${var:?}` | ~60 min |
| 5 | [lab-05-recortar-y-sustituir](lab-05-recortar-y-sustituir/README.md) | Recortar, sustituir y cambiar a mayúsculas con expansiones de parámetros | ~60 min |
| 6 | [lab-06-aritmetica](lab-06-aritmetica/README.md) | Hacer cuentas con enteros en `$(( ))` sin caer en sus trampas | ~60 min |
| 7 | [lab-07-sustitucion-de-comandos](lab-07-sustitucion-de-comandos/README.md) | Guardar la salida de un comando con `$( )` y citarla bien | ~60 min |

**Total labs: 7 horas**

## Antes de cada lab

- Todo se hace dentro del laboratorio Docker, como `alumno`. Desde la raíz del repositorio en tu equipo: `docker compose run --rm lab`.
- Cada lab empieza con un **paso 0**: el `cd` a su carpeta desde `/bc-bash`, la raíz del repositorio dentro del laboratorio.
- Muchos pasos se escriben directamente en la terminal: las variables que crees duran hasta que salgas del laboratorio. Si un resultado no coincide, puede que una variable de un paso anterior siga ahí: `unset nombre` la borra.
- Lo que crean los labs va a `zona/`, dentro de la carpeta de cada lab. git la ignora y puedes borrarla cuando quieras: `rm -r zona`.

Completa los labs en orden. Después, el [Proyecto semanal](../3-proyecto/README.md).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Aritmética y sustitución de comandos](../1-teoria/04-aritmetica-y-sustitucion-de-comandos.md) | [Lab 01 — Variables](lab-01-variables/README.md) → |

[↑ Semana 05](../README.md)
