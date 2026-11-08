# Labs — Semana 08: Funciones, alcance y librerías

| # | Lab | Objetivo | Tiempo |
|---|-----|----------|--------|
| 1 | [lab-01-funciones](lab-01-funciones/README.md) | Definir funciones con argumentos y organizar un script con `main "$@"` | ~60 min |
| 2 | [lab-02-return-y-salida](lab-02-return-y-salida/README.md) | Separar lo que imprime una función de su código de salida, y `return` de `exit` | ~60 min |
| 3 | [lab-03-local-y-alcance](lab-03-local-y-alcance/README.md) | Encontrar las variables que una función pisa y arreglarlas con `local` | ~60 min |
| 4 | [lab-04-declare-n](lab-04-declare-n/README.md) | Devolver varios valores en variables de quien llama, con `declare -n` | ~60 min |
| 5 | [lab-05-source-y-librerias](lab-05-source-y-librerias/README.md) | Cargar una librería con `source`, buscada junto al script | ~60 min |
| 6 | [lab-06-dispatcher](lab-06-dispatcher/README.md) | Repartir subcomandos a funciones con un `case` | ~60 min |
| 7 | [lab-07-funciones-rotas](lab-07-funciones-rotas/README.md) | Encontrar los cuatro fallos típicos de las funciones, con y sin shellcheck | ~60 min |

**Total labs: 7 horas**

## Antes de cada lab

- Todo se hace dentro del laboratorio Docker, como `alumno`. Desde la raíz del repositorio en tu equipo: `docker compose run --rm lab`.
- Cada lab empieza con un **paso 0**: el `cd` a su carpeta desde `/bc-bash`, la raíz del repositorio dentro del laboratorio.
- Las funciones que defines en la terminal se quedan en tu shell hasta que sales del laboratorio. Si una te estorba, `unset -f nombre` la borra.
- El lab 06 crea `notas.txt` en su carpeta; el último paso la borra.
- El lab 07 trae un script **roto a propósito**: ejecútalo tal cual antes de arreglarlo, para ver cómo falla.

Completa los labs en orden. Después, el [Proyecto semanal](../3-proyecto/README.md).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — source, librerías y dispatcher](../1-teoria/03-source-librerias-y-dispatcher.md) | [Lab 01 — Funciones](lab-01-funciones/README.md) → |

[↑ Semana 08](../README.md)
