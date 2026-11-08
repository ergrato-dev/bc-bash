# Semana 08 — Funciones, alcance y librerías

## Descripción

Tus scripts ya deciden y repiten; ahora toca ordenarlos. Agruparás el código en funciones con sus argumentos, separarás lo que una función imprime de su código de salida y aislarás sus variables con `local`. Después sacarás lo que comparten los comandos de `bashkit` a una librería, `lib/core.sh`, y escribirás `bin/bashkit`, un solo comando que reparte los subcomandos.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Definir funciones, pasarles argumentos y ordenar un script con `main "$@"` al final
- Devolver un dato por stdout y un sí o no con el código de salida, y distinguir `return` de `exit`
- Aislar las variables de una función con `local` y explicar qué pasa sin él
- Devolver varios valores en variables de quien llama con `declare -n`
- Escribir una librería y cargarla con `source`, buscada junto al script con `BASH_SOURCE`
- Repartir subcomandos con un `case`, un `shift` y `exec`
- Escribir `lib/core.sh` (`log`, `die`, `require`) y el dispatcher `bin/bashkit`

## Prerrequisitos

- [Semana 07](../week-07-bucles_read_y_archivos_seguros/README.md) completada: bucles, `read` y archivos seguros
- El laboratorio funcionando: ver [docs/setup-entorno.md](../../docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-funciones-return-y-salida.md](1-teoria/01-funciones-return-y-salida.md) · [02-alcance-local-y-declare-n.md](1-teoria/02-alcance-local-y-declare-n.md) · [03-source-librerias-y-dispatcher.md](1-teoria/03-source-librerias-y-dispatcher.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-funciones](2-practicas/lab-01-funciones/README.md) | 60 min |
| 2 | Lab | [lab-02-return-y-salida](2-practicas/lab-02-return-y-salida/README.md) | 60 min |
| 3 | Lab | [lab-03-local-y-alcance](2-practicas/lab-03-local-y-alcance/README.md) | 60 min |
| 4 | Lab | [lab-04-declare-n](2-practicas/lab-04-declare-n/README.md) | 60 min |
| 5 | Lab | [lab-05-source-y-librerias](2-practicas/lab-05-source-y-librerias/README.md) | 60 min |
| 6 | Lab | [lab-06-dispatcher](2-practicas/lab-06-dispatcher/README.md) | 60 min |
| 7 | Lab | [lab-07-funciones-rotas](2-practicas/lab-07-funciones-rotas/README.md) | 60 min |
| — | Proyecto | [lib/core.sh y bashkit: un kit, un comando](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (funciones, alcance, source y dispatcher)
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — definir, llamar y main "$@"
[60 min]     lab-02 — stdout frente a código, return frente a exit
[60 min]     lab-03 — local y las variables que se pisan
[60 min]     lab-04 — declare -n para devolver varios valores
[60 min]     lab-05 — librerías, source y BASH_SOURCE
[60 min]     lab-06 — un dispatcher de subcomandos con case
[60 min]     lab-07 — depurar funciones con y sin shellcheck
[3 h 30 min] Proyecto: lib/core.sh y bin/bashkit
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 08
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 16 requisitos verificables de la semana, dentro del laboratorio Docker.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana 07 — Bucles, read y archivos seguros](../week-07-bucles_read_y_archivos_seguros/README.md) | **Semana 08 — Funciones, alcance y librerías** | [Semana 09 — Arrays y printf →](../week-09-arrays_y_printf/README.md) |

[← Volver al índice del bootcamp](../README.md)
