# 📖 Glosario - Semana 7

> **Tema**: Debugging y Optimización

---

## A

### Assert

Verificación que comprueba si una condición es verdadera. Si falla, el programa termina con error. Usado en testing.

### Assertion

Declaración que afirma una condición esperada. Las assertions validan suposiciones en el código.

---

## B

### Benchmark

Proceso de medir el rendimiento de código ejecutándolo múltiples veces y calculando promedios.

### Breakpoint

Punto en el código donde la ejecución se detiene para inspeccionar el estado. En Bash se simula con `read`.

---

## D

### Debug

Proceso de identificar y corregir errores en el código. Incluye técnicas como tracing y logging.

### DEBUG (trap)

Señal especial que se ejecuta antes de cada comando. Útil para tracing detallado.

---

## E

### ERR (trap)

Señal que se dispara cuando un comando falla (exit code != 0). Permite manejo centralizado de errores.

### errexit

Opción (`set -e`) que hace que el script termine cuando un comando falla.

---

## F

### FUNCNAME

Variable especial que contiene el nombre de la función actual. Array con la pila de llamadas.

---

## L

### LINENO

Variable especial que contiene el número de línea actual del script.

### Lint

Análisis estático de código para detectar errores y malas prácticas sin ejecutar el código.

---

## N

### nounset

Opción (`set -u`) que genera error al usar variables no definidas.

---

## P

### Pipe (pipeline)

Secuencia de comandos conectados con `|`. El output de uno es input del siguiente.

### pipefail

Opción (`set -o pipefail`) que hace que un pipeline falle si cualquier comando falla, no solo el último.

### Profiling

Proceso de medir el rendimiento del código para identificar cuellos de botella.

### PS4

Variable que define el prompt usado por `set -x`. Por defecto es `+ `.

---

## S

### SECONDS

Variable especial que contiene los segundos desde que inició el script. Útil para medir tiempo.

### ShellCheck

Herramienta de análisis estático para scripts de shell. Detecta errores comunes y sugiere mejoras.

### Strict Mode

Conjunto de opciones (`set -euo pipefail`) que hacen Bash más estricto y seguro.

---

## T

### Test (testing)

Verificación automatizada de que el código funciona correctamente. Incluye unit tests, integration tests.

### Trace

Seguimiento de la ejecución del script, mostrando cada comando antes de ejecutarlo.

### Trap

Comando que captura señales y ejecuta código cuando ocurren. Usado para cleanup y manejo de errores.

---

## U

### Unit Test

Test que verifica una unidad pequeña de código (función) de forma aislada.

---

## X

### xtrace

Opción (`set -x`) que muestra cada comando antes de ejecutarlo. Fundamental para debugging.

---

## 🔗 Navegación

← [Recursos](../4-recursos/) | [Semana 8 →](../../week-08-proyectos-avanzados-y-automatizacion/)
