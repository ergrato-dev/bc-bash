# Bootcamp Bash (bc_bash) - Documentación

## Descripción General

Este es un bootcamp completo de scripting en Bash dividido en 8 semanas progresivas, diseñado para enseñar los fundamentos de shell scripting a través de ejercicios prácticos y proyectos reales.

## Estructura del Proyecto

```text
bc_bash/
├── _docs/                    # 📚 Toda la documentación del proyecto
├── _scripts/                 # 🔧 Scripts de utilidad y automatización
├── _assets/                  # 🎨 Logos y recursos visuales
├── bootcamp/
│   ├── week-01/              # 📖 Semana 1: Fundamentos de Bash
│   │   ├── 0-assets/         # 🖼️ Recursos visuales
│   │   ├── 1-teoria/         # 📚 Material teórico
│   │   ├── 2-practicas/      # 💪 Ejercicios prácticos
│   │   ├── 3-proyecto/       # 🚀 Proyecto semanal
│   │   ├── 4-recursos/       # 📖 Recursos adicionales
│   │   ├── 5-glosario/       # 📖 Glosario de términos
│   │   └── README.md         # 📋 Descripción de la semana
│   ├── week-02/              # 📖 Semana 2: Comandos Avanzados y Pipes
│   ├── week-03/              # 📖 Semana 3: Variables y Control de Flujo
│   ├── week-04/              # 📖 Semana 4: Funciones y Arrays
│   ├── week-05/              # 📖 Semana 5: Operaciones de Archivos y Texto
│   ├── week-06/              # 📖 Semana 6: Manipulación Avanzada de Datos
│   ├── week-07/              # 📖 Semana 7: Optimización y Debugging
│   └── week-08/              # 📖 Semana 8: Proyectos y Automatización
└── README.md                 # 📖 README principal del proyecto
```

## Semanas del Bootcamp

### Semana 1: Fundamentos de Bash

- **Objetivo**: Introducir comandos básicos y sintaxis de Bash
- **Contenido**: Terminal, shell, navegación, permisos de archivos
- **Proyecto**: Sistema de Gestión de Archivos

### Semana 2: Comandos Avanzados y Pipes

- **Objetivo**: Dominar comandos avanzados y procesamiento de texto
- **Contenido**: Pipes, redirección, wildcards, filtros de texto
- **Proyecto**: Procesador de Logs Avanzado

### Semana 3: Variables y Control de Flujo

- **Objetivo**: Manejar variables y estructuras de control
- **Contenido**: Variables, condicionales, bucles, entrada/salida
- **Proyecto**: Sistema de Menús Interactivo

### Semana 4: Funciones y Arrays

- **Objetivo**: Organizar código con funciones y manejar arrays
- **Contenido**: Funciones, arrays, códigos de salida, logging
- **Proyecto**: Gestor Interactivo de Archivos

### Semana 5: Operaciones de Archivos y Texto

- **Objetivo**: Automatizar manipulación avanzada de archivos
- **Contenido**: Expresiones regulares, sed, awk, análisis de datos
- **Proyecto**: Analizador de Logs con Reportes

### Semana 6: Manipulación Avanzada de Datos

- **Objetivo**: Procesamiento sofisticado de datos estructurados
- **Contenido**: CSV, JSON, XML, parsing complejo, transformaciones
- **Proyecto**: Procesador de Datos Empresariales

### Semana 7: Optimización y Debugging

- **Objetivo**: Técnicas de optimización y resolución de problemas
- **Contenido**: Debugging, profiling, optimización, seguridad
- **Proyecto**: Monitor de Sistema Avanzado

### Semana 8: Proyectos Avanzados y Automatización

- **Objetivo**: Integración empresarial y automatización completa
- **Contenido**: APIs, Docker, Git, CI/CD, automatización empresarial
- **Proyecto**: Sistema de Backup y Deploy Automatizado

## Documentación Disponible

### Organización Temática en `_docs/`

#### 🚀 **Setup & Configuración** (`setup/`)

- [`QUICK_SETUP.md`](setup/QUICK_SETUP.md) - Guía rápida de configuración
- [`github-copilot-english-setup.md`](setup/github-copilot-english-setup.md) - Configuración de GitHub Copilot

#### 🤖 **Automatización** (`automation/`)

- [`COMMIT_STRATEGY.md`](automation/COMMIT_STRATEGY.md) - Estrategia de commits automáticos
- [`auto-commit-replication-guide.md`](automation/auto-commit-replication-guide.md) - Guía de replicación
- [`competition-auto-commit-summary.md`](automation/competition-auto-commit-summary.md) - Resumen de competición

#### 📋 **Cheatsheets** (`cheatsheets/`)

- [`markdown-cheatsheet.md`](cheatsheets/markdown-cheatsheet.md) - Referencia rápida de Markdown
- [`unix-permissions-cheatsheet.md`](cheatsheets/unix-permissions-cheatsheet.md) - Permisos Unix
- [`comandos_xa_recordar.md`](cheatsheets/comandos_xa_recordar.md) - Comandos para recordar

#### 🛠️ **Desarrollo** (`development/`)

- [`open-source-structure.md`](development/open-source-structure.md) - Estructura open source

#### 📊 **Resúmenes** (`summaries/`)

- [`8-weeks-update-summary.md`](summaries/8-weeks-update-summary.md) - Actualización a 8 semanas
- [`absolute-paths-update.md`](summaries/absolute-paths-update.md) - Actualización de rutas absolutas
- [`open-source-implementation-summary.md`](summaries/open-source-implementation-summary.md) - Implementación open source
- [`svg-logos-implementation-summary.md`](summaries/svg-logos-implementation-summary.md) - Implementación de logos SVG

#### 🔧 **Solución de Problemas** (`troubleshooting/`)

- [`fedora-cron-solution.md`](troubleshooting/fedora-cron-solution.md) - Solución cron para Fedora

#### 📄 **Plantillas** (`templates/`)

- [`ejercicio-template.md`](templates/ejercicio-template.md) - Plantilla para ejercicios

### Por Semana

- Cada semana tiene su propio `README.md` con objetivos específicos
- Ejercicios documentados en `week-XX/2-practicas/README.md`
- Proyectos documentados en `week-XX/3-proyecto/[proyecto]/README.md`

## Scripts de Automatización

El directorio `_scripts/` contiene herramientas para facilitar el desarrollo:

### Sistema de Commits Automáticos

```bash
./_scripts/commit.sh auto      # Commits automáticos con detección inteligente
./_scripts/commit.sh quick     # Commits interactivos
./_scripts/commit.sh status    # Estado actual del repositorio
```

### Utilidades de Desarrollo

```bash
./_scripts/demo.sh            # Demo del sistema de commits
./_scripts/setup-auto-commit.sh  # Configuración inicial
```

## Convenciones de Código

### Scripts de Shell

- Usar `#!/bin/bash` en todos los scripts
- Nombres de archivo en `snake_case.sh`
- Indentación con 4 espacios
- Manejo de errores con `set -euo pipefail`
- Documentación clara en cada función

### Documentación

- Archivos Markdown en `kebab-case.md`
- Headers claros con objetivos de aprendizaje
- Ejemplos de código con salida esperada
- Instrucciones paso a paso

### Estructura de Ejercicios

```bash
#!/bin/bash
# Ejercicio: [Título]
# Módulo: [X]
# Objetivo: [Meta de aprendizaje]
# Instrucciones: [Qué debe hacer el estudiante]

# Tu solución aquí
```

## Progresión del Aprendizaje

### 🎯 Semanas 1-2: Fundamentos Sólidos

1. **Módulo 1**: Conceptos básicos, navegación y permisos
2. **Módulo 2**: Comandos avanzados, pipes y procesamiento de texto

### 🚀 Semanas 3-4: Programación Estructurada

1. **Módulo 3**: Variables, control de flujo e interactividad
2. **Módulo 4**: Funciones, arrays y organización de código

### 💪 Semanas 5-6: Manipulación Avanzada

1. **Módulo 5**: Operaciones de archivos y análisis de texto
2. **Módulo 6**: Procesamiento de datos estructurados y complejos

### 🏆 Semanas 7-8: Maestría Profesional

1. **Módulo 7**: Optimización, debugging y mejores prácticas
2. **Módulo 8**: Automatización empresarial y proyectos avanzados

## Requisitos Previos

- Sistema Linux o macOS (o WSL en Windows)
- Terminal con Bash disponible
- Editor de texto (VS Code recomendado)
- Git para control de versiones

## Recursos Adicionales

- [Manual de Bash](https://www.gnu.org/software/bash/manual/)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
- [ShellCheck](https://www.shellcheck.net/) para validación de scripts

## Contribución

Para contribuir al proyecto:

1. Seguir las convenciones establecidas
2. Usar el sistema de commits automáticos: `./_scripts/commit.sh auto`
3. Documentar todos los cambios apropiadamente
4. Probar scripts en múltiples entornos

---

**¡Bienvenido al Bootcamp de Bash! Comenzando un viaje hacia la maestría en shell scripting.** 🚀
