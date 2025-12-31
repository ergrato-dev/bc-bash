# 🎓 Semana 8: Proyectos Avanzados y Automatización

> **Tema**: Integrar todo lo aprendido en proyectos profesionales de automatización

---

## 🎯 Objetivos de Aprendizaje

Al finalizar esta semana, serás capaz de:

- ✅ Estructurar proyectos de Bash profesionales
- ✅ Implementar pipelines de automatización
- ✅ Integrar con APIs REST usando curl y jq
- ✅ Configurar CI/CD con Git hooks
- ✅ Crear frameworks reutilizables

---

## 📋 Requisitos Previos

- Completar Semanas 1-7 del bootcamp
- Dominio de funciones, arrays y procesamiento de texto
- Experiencia con debugging y optimización

---

## 🗂️ Estructura de la Semana

```
week-08/
├── README.md              # Este archivo
├── 0-assets/              # Recursos visuales (SVGs)
├── 1-teoria/              # Material teórico
├── 2-practicas/           # Ejercicios guiados (4)
├── 3-proyecto/            # AutoDeploy Framework
├── 4-recursos/            # Enlaces y referencias
└── 5-glosario/            # Términos clave
```

---

## 📚 Contenidos

### [1-teoria](./1-teoria/)

| Tema         | Descripción                           |
| ------------ | ------------------------------------- |
| Arquitectura | Estructura de proyectos profesionales |
| Workflows    | Pipelines y orquestación              |
| APIs         | curl, jq, integraciones               |
| CI/CD        | Git hooks, GitHub Actions             |
| Frameworks   | Código reutilizable                   |

### [2-practicas](./2-practicas/)

| Práctica | Tema                 | Duración |
| -------- | -------------------- | -------- |
| 01       | Arquitectura Modular | 35 min   |
| 02       | Pipelines            | 35 min   |
| 03       | APIs con curl        | 35 min   |
| 04       | CI/CD                | 35 min   |

### [3-proyecto](./3-proyecto/)

**AutoDeploy Framework** - Proyecto final que integra:

- CLI con subcomandos
- Sistema de configuración
- Pipeline de deployment
- Integraciones y notificaciones
- Tests automatizados

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

### Estructura de Proyecto

```
proyecto/
├── bin/          # Ejecutables
├── lib/          # Librerías
├── config/       # Configuración
└── tests/        # Tests
```

### curl + jq

```bash
curl -s "$API_URL" | jq '.data[]'
```

### Pipeline

```bash
stages=("lint" "test" "build" "deploy")
for stage in "${stages[@]}"; do
    "stage_$stage" || exit 1
done
```

---

## 📌 Entregables

1. ✅ Ejercicios de prácticas completados
2. ✅ Proyecto AutoDeploy funcional
3. ✅ Scripts con arquitectura profesional

---

## 🏆 Proyecto Final

Esta semana culmina el bootcamp con un **proyecto integrador** que demuestra todas las habilidades adquiridas:

- Semanas 1-2: Fundamentos de Bash
- Semanas 3-4: Control de flujo y funciones
- Semanas 5-6: grep, sed, awk
- Semana 7: Debugging y optimización
- **Semana 8**: Integración en proyecto profesional

---

## 🔗 Navegación

| ← Anterior                         | Actual       | Siguiente →     |
| ---------------------------------- | ------------ | --------------- |
| [Semana 7: Debugging](../week-07/) | **Semana 8** | [Bootcamp](../) |

---

## 📖 Recursos Rápidos

- 📚 [Teoría](./1-teoria/)
- 💻 [Prácticas](./2-practicas/)
- 🚀 [Proyecto](./3-proyecto/)
- 🔗 [Recursos](./4-recursos/)
- 📖 [Glosario](./5-glosario/)
