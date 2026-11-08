# Labs — Semana 09: Arrays y printf

| # | Lab | Objetivo | Tiempo |
|---|-----|----------|--------|
| 1 | [lab-01-arrays-indexados](lab-01-arrays-indexados/README.md) | Guardar una lista en un array, leerla por posición y recorrerla con sus índices | ~60 min |
| 2 | [lab-02-arroba-y-asterisco](lab-02-arroba-y-asterisco/README.md) | Pasar los argumentos de un comando en un array con `"${args[@]}"` | ~60 min |
| 3 | [lab-03-huecos-y-slices](lab-03-huecos-y-slices/README.md) | Sacar trozos de un array con slices y recorrer un array con huecos | ~60 min |
| 4 | [lab-04-arrays-asociativos](lab-04-arrays-asociativos/README.md) | Cargar un `clave=valor` en un array asociativo y buscar por nombre | ~60 min |
| 5 | [lab-05-contar-por-clave](lab-05-contar-por-clave/README.md) | Contar por clave sin que `set -e` pare el script al primer conteo | ~60 min |
| 6 | [lab-06-printf-y-formatos](lab-06-printf-y-formatos/README.md) | Escribir una tabla alineada con anchos, números y `printf -v` | ~60 min |
| 7 | [lab-07-tablas-rotas](lab-07-tablas-rotas/README.md) | Encontrar los cuatro fallos típicos de arrays y `printf`, con y sin shellcheck | ~60 min |

**Total labs: 7 horas**

## Antes de cada lab

- Todo se hace dentro del laboratorio Docker, como `alumno`. Desde la raíz del repositorio en tu equipo: `docker compose run --rm lab`.
- Cada lab empieza con un **paso 0**: el `cd` a su carpeta desde `/bc-bash`, la raíz del repositorio dentro del laboratorio.
- Los arrays que creas en la terminal se quedan en tu shell hasta que sales del laboratorio. Si uno te estorba, `unset nombre` lo borra; para cambiar uno indexado por uno asociativo con el mismo nombre, hace falta borrarlo antes.
- El lab 02 crea `copia.tgz` en su carpeta; cada paso que lo crea lo borra después.
- El lab 07 trae un script **roto a propósito**: ejecútalo tal cual antes de arreglarlo, para ver cómo falla.

Completa los labs en orden. Después, el [Proyecto semanal](../3-proyecto/README.md).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — printf y tablas](../1-teoria/03-printf-y-tablas.md) | [Lab 01 — Arrays indexados](lab-01-arrays-indexados/README.md) → |

[↑ Semana 09](../README.md)
