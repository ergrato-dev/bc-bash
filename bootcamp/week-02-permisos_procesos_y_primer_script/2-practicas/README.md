# Labs — Semana 02: Permisos, procesos y primer script

| # | Lab | Objetivo | Tiempo |
|---|-----|----------|--------|
| 1 | [lab-01-usuarios-y-grupos](lab-01-usuarios-y-grupos/README.md) | Averiguar tu usuario y tus grupos y leer `/etc/passwd` | ~60 min |
| 2 | [lab-02-leer-permisos](lab-02-leer-permisos/README.md) | Leer quién puede leer, escribir y ejecutar en `ls -l` y `stat` | ~60 min |
| 3 | [lab-03-cambiar-permisos-con-chmod](lab-03-cambiar-permisos-con-chmod/README.md) | Cambiar permisos con `chmod` simbólico y octal y ver qué rompe cada letra que falta | ~60 min |
| 4 | [lab-04-propietarios-y-root](lab-04-propietarios-y-root/README.md) | Cambiar dueño y grupo con `chown` como root y probar los permisos con otro usuario | ~60 min |
| 5 | [lab-05-procesos-y-senales](lab-05-procesos-y-senales/README.md) | Ver procesos con `ps`, manejar trabajos y pararlos con `Ctrl+C` y `kill` | ~60 min |
| 6 | [lab-06-shebang-y-bit-de-ejecucion](lab-06-shebang-y-bit-de-ejecucion/README.md) | Convertir un script en comando con `chmod +x` y el shebang | ~60 min |
| 7 | [lab-07-path-y-variables-de-entorno](lab-07-path-y-variables-de-entorno/README.md) | Ejecutar un script por su nombre con el `PATH` y ver qué variables hereda un hijo | ~60 min |

**Total labs: 7 horas**

## Antes de cada lab

- Todo se hace dentro del laboratorio Docker. Desde la raíz del repositorio en tu equipo: `docker compose run --rm lab`. Al salir (`exit`), el contenedor se borra, pero tus archivos del repositorio se quedan.
- El lab 04 entra **como root** (`docker compose run --rm -u root lab`) y trabaja solo en `/tmp`. El resto, como `alumno`.
- Cada lab empieza con un **paso 0**: el `cd` a su carpeta desde `/bc-bash`, la raíz del repositorio dentro del laboratorio.
- Lo que crean los labs va a `zona/`, dentro de la carpeta de cada lab. git la ignora y puedes borrarla cuando quieras.

Completa los labs en orden. Después, el [Proyecto semanal](../3-proyecto/README.md).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — PATH y variables de entorno](../1-teoria/04-path-y-variables-de-entorno.md) | [Lab 01 — Usuarios y grupos](lab-01-usuarios-y-grupos/README.md) → |

[↑ Semana 02](../README.md)
