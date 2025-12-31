# 🐛 Semana 7: Debugging y Optimización

> **Tema**: Técnicas de debugging, profiling y optimización de scripts Bash

---

## 🎯 Objetivos de Aprendizaje

Al finalizar esta semana, serás capaz de:

- ✅ Dominar las opciones de `set` para debugging (-e, -u, -x, -o pipefail)
- ✅ Implementar manejo de errores con `trap`
- ✅ Usar técnicas de profiling para medir rendimiento
- ✅ Optimizar scripts para mejor performance
- ✅ Aplicar metodologías de testing en Bash

---

## 📋 Requisitos Previos

- Completar Semanas 1-6 del bootcamp
- Entender funciones, arrays y procesamiento de texto
- Familiaridad con pipes y redirección

---

## 🗂️ Estructura de la Semana

```
week-07/
├── README.md              # Este archivo
├── 0-assets/              # Recursos visuales (SVGs)
├── 1-teoria/              # Material teórico
├── 2-practicas/           # Ejercicios guiados (4)
├── 3-proyecto/            # DebugKit - Toolkit de debugging
├── 4-recursos/            # Enlaces y referencias
└── 5-glosario/            # Términos clave
```

---

## 📚 Contenidos

### [1-teoria](./1-teoria/)

| Tema                  | Descripción                        |
| --------------------- | ---------------------------------- |
| Técnicas de Debugging | echo, printf, set options          |
| Set Options           | -e, -u, -x, -o pipefail explicados |
| Trap y Signals        | Manejo de errores y cleanup        |
| Profiling             | time, SECONDS, PS4                 |
| Optimización          | Mejores prácticas de rendimiento   |

### [2-practicas](./2-practicas/)

| Práctica | Tema                      | Duración |
| -------- | ------------------------- | -------- |
| 01       | Debugging con set options | 30 min   |
| 02       | Traps y cleanup           | 35 min   |
| 03       | Profiling y benchmarks    | 30 min   |
| 04       | Testing y validación      | 40 min   |

### [3-proyecto](./3-proyecto/)

**DebugKit** - Toolkit de debugging para Bash que incluye:

- Framework de debugging con logging
- Test runner automático
- Profiler de scripts
- Wrapper para ShellCheck

---

## ⏱️ Distribución del Tiempo

| Actividad     | Tiempo       |
| ------------- | ------------ |
| Teoría        | 1.5 horas    |
| Prácticas (4) | 2.5 horas    |
| Proyecto      | 2 horas      |
| **Total**     | **~6 horas** |

---

## 🔧 Conceptos Clave

### Set Options (Strict Mode)

```bash
#!/bin/bash
set -euo pipefail

# -e: Exit on error
# -u: Error on undefined variable
# -x: Trace mode (debug)
# -o pipefail: Detect errors in pipes
```

### Trap para Cleanup

```bash
cleanup() {
    rm -f "$temp_file"
}
trap cleanup EXIT
```

### Profiling Básico

```bash
start=$SECONDS
# ... código ...
echo "Tiempo: $((SECONDS - start))s"
```

---

## 📌 Entregables

1. ✅ Ejercicios de prácticas completados
2. ✅ Proyecto DebugKit funcional
3. ✅ Scripts con debugging implementado

---

## 🔗 Navegación

| ← Anterior                            | Actual       | Siguiente →                        |
| ------------------------------------- | ------------ | ---------------------------------- |
| [Semana 6: AWK Avanzado](../week-06/) | **Semana 7** | [Semana 8: Proyectos](../week-08/) |

---

## 📖 Recursos Rápidos

- 📚 [Teoría](./1-teoria/)
- 💻 [Prácticas](./2-practicas/)
- 🚀 [Proyecto](./3-proyecto/)
- 🔗 [Recursos](./4-recursos/)
- 📖 [Glosario](./5-glosario/)
