# Guía de Contribución

¡Gracias por tu interés en contribuir al Bootcamp Bash! 🎉

## 📋 Tabla de Contenidos

- [Cómo Contribuir](#cómo-contribuir)
- [Proceso de Desarrollo](#proceso-de-desarrollo)
- [Estándares de Código](#estándares-de-código)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Sistema de Commits](#sistema-de-commits)
- [Reporte de Issues](#reporte-de-issues)
- [Pull Requests](#pull-requests)

## 🤝 Cómo Contribuir

Hay muchas formas de contribuir a este proyecto:

### 🐛 Reportar Bugs

- Usa los [templates de issues](.github/ISSUE_TEMPLATE/) para reportar bugs
- Incluye información detallada sobre tu entorno
- Proporciona pasos para reproducir el problema

### 💡 Proponer Nuevas Características

- Abre un issue para discutir la idea antes de implementar
- Explica el caso de uso y el beneficio para la comunidad
- Considera la compatibilidad con los objetivos educativos del proyecto

### 📚 Mejorar Documentación

- Corrige errores tipográficos o de gramática
- Añade ejemplos o clarifica instrucciones
- Traduce contenido a otros idiomas

### 🔧 Contribuir Código

- Mejora ejercicios existentes
- Crea nuevos ejercicios o proyectos
- Optimiza scripts de automatización
- Añade funcionalidades al sistema de auto-commit

## 🔄 Proceso de Desarrollo

### 1. Fork y Clone

```bash
# Fork el repositorio en GitHub, luego:
git clone https://github.com/TU_USUARIO/bc-bash.git
cd bc-bash
```

### 2. Configurar el Entorno

```bash
# Configurar auto-commit (opcional pero recomendado)
./_scripts/setup-auto-commit.sh

# Verificar estructura
for i in {1..8}; do [ -d "modulo$i" ] && echo "✓ modulo$i" || echo "✗ modulo$i"; done
```

### 3. Crear una Rama

```bash
# Usar nomenclatura descriptiva
git checkout -b feature/nuevo-ejercicio-arrays
git checkout -b fix/corregir-permisos-script
git checkout -b docs/actualizar-readme-modulo3
```

### 4. Hacer Cambios

```bash
# Usar el sistema de auto-commit
./_scripts/commit.sh auto

# O hacer commits manuales siguiendo Conventional Commits
git commit -m "feat(module4): add array manipulation exercise"
```

### 5. Enviar Pull Request

- Asegúrate de que todos los tests pasen
- Actualiza la documentación si es necesario
- Incluye una descripción clara de los cambios

## 📝 Estándares de Código

### Shell Scripts

```bash
#!/bin/bash
# Usar shebang estándar
set -euo pipefail  # Manejo de errores estricto

# Funciones documentadas
function process_data() {
    local input_file="$1"
    local output_file="$2"

    # Validación de parámetros
    [[ -f "$input_file" ]] || {
        echo "Error: Archivo no encontrado: $input_file" >&2
        return 1
    }

    # Lógica principal
    # ...
}
```

### Nomenclatura

- **Scripts**: `snake_case.sh`
- **Documentos**: `kebab-case.md`
- **Directorios**: `lowercase` o `snake_case`
- **Variables**: `lowercase_with_underscores`
- **Funciones**: `snake_case`

### Documentación

```bash
#!/bin/bash
# Título: Procesador de Datos CSV
# Autor: [Tu Nombre]
# Fecha: $(date +%Y-%m-%d)
# Descripción: Script para procesar archivos CSV y generar reportes
# Uso: ./process_csv.sh input.csv output.html
# Dependencias: awk, sed, html2text

# ...código...
```

## 🏗️ Estructura del Proyecto

```
bc_bash/
├── _docs/                    # 📚 Documentación
│   ├── templates/           # 📋 Plantillas
│   └── assets/              # 🖼️ Recursos
├── _scripts/                # 🔧 Automatización
├── assets/                  # 🎨 Logos y recursos visuales
├── bootcamp/                # 🎓 Contenido del bootcamp
│   ├── modulo1-8/          # 📖 Módulos educativos
│   │   ├── ejercicios/     # 💪 Ejercicios
│   │   ├── proyectos/      # 🚀 Proyectos
│   │   └── README.md       # 📋 Descripción
└── tests/                   # 🧪 Tests (si aplica)
```

### Reglas de Organización

- **Documentación global** → `_docs/`
- **Scripts de utilidad** → `_scripts/`
- **Contenido educativo** → `bootcamp/moduloX/`
- **Assets compartidos** → `assets/`

## 🔄 Sistema de Commits

Este proyecto usa **Conventional Commits** con auto-detección:

### Tipos de Commit

- `feat`: Nuevas características
- `fix`: Corrección de bugs
- `docs`: Cambios en documentación
- `style`: Formato y estilo
- `refactor`: Reestructuración de código
- `test`: Añadir o modificar tests
- `chore`: Tareas de mantenimiento

### Scopes

- `module1-8`: Cambios específicos por módulo
- `docs`: Documentación en `_docs/`
- `scripts`: Scripts en `_scripts/`
- `exercises`: Ejercicios
- `projects`: Proyectos

### Ejemplos

```bash
feat(module3): add interactive menu exercise
fix(scripts): resolve auto-commit permission issue
docs(module1): update README with new objectives
style(module4): improve code formatting in examples
```

### Uso del Auto-Commit

```bash
# Automático (recomendado)
./_scripts/commit.sh auto

# Interactivo
./_scripts/commit.sh quick

# Ver estado
./_scripts/commit.sh status
```

## 🐛 Reporte de Issues

### Antes de Reportar

1. Busca en issues existentes
2. Verifica que sea reproducible
3. Actualiza a la última versión

### Información Requerida

- **Entorno**: OS, shell, versión de Bash
- **Pasos para reproducir**
- **Comportamiento esperado vs actual**
- **Logs o mensajes de error**
- **Screenshots** (si es relevante)

### Template de Bug Report

```markdown
## 🐛 Descripción del Bug

[Descripción clara y concisa]

## 🔄 Pasos para Reproducir

1. Ir a '...'
2. Ejecutar '...'
3. Ver error

## ✅ Comportamiento Esperado

[Qué debería pasar]

## 📱 Entorno

- OS: [Ubuntu 22.04, macOS 13, etc.]
- Shell: [bash 5.1, zsh 5.8, etc.]
- Versión del proyecto: [commit hash o tag]

## 📝 Información Adicional

[Screenshots, logs, contexto adicional]
```

## 🚀 Pull Requests

### Antes de Enviar

- [ ] Los cambios están en una rama separada
- [ ] Se siguieron los estándares de código
- [ ] La documentación está actualizada
- [ ] Los commits siguen Conventional Commits
- [ ] Se probó en múltiples entornos (si aplica)

### Template de PR

```markdown
## 📋 Descripción

[Descripción clara de los cambios]

## 🔗 Issues Relacionados

Fixes #123
Closes #456

## 🧪 Tipo de Cambio

- [ ] Bug fix
- [ ] Nueva característica
- [ ] Cambio que rompe compatibilidad
- [ ] Documentación

## ✅ Checklist

- [ ] Mi código sigue los estándares del proyecto
- [ ] He realizado auto-review de mi código
- [ ] He comentado código complejo
- [ ] He actualizado la documentación
- [ ] Mis cambios no generan nuevos warnings
```

### Proceso de Review

1. **Automated checks**: CI/CD, linting, tests
2. **Peer review**: Al menos 1 reviewer
3. **Testing**: Verificación en diferentes entornos
4. **Documentation**: Actualización si es necesario
5. **Merge**: Squash commits si es apropiado

## 📚 Recursos Adicionales

### Documentación

- [README Principal](README.md)
- [Documentación Completa](_docs/README.md)
- [Estrategia de Commits](_docs/automation/COMMIT_STRATEGY.md)

### Herramientas

- [ShellCheck](https://www.shellcheck.net/) - Validación de scripts
- [Conventional Commits](https://www.conventionalcommits.org/) - Estándar de commits
- [Markdown Lint](https://github.com/markdownlint/markdownlint) - Validación de Markdown

### Comunidad

- Discusiones en GitHub Discussions
- Issues para bugs y características
- Pull Requests para contribuciones

---

## 🙏 Reconocimientos

¡Gracias por contribuir al Bootcamp Bash! Tu participación ayuda a crear un recurso educativo mejor para toda la comunidad de shell scripting.

### 🎯 Valores del Proyecto

- **Educativo**: Priorizar el aprendizaje efectivo
- **Práctico**: Enfocarse en casos de uso reales
- **Inclusivo**: Accesible para todos los niveles
- **Profesional**: Mantener estándares de calidad altos
- **Colaborativo**: Fomentar la participación comunitaria

¿Tienes preguntas? ¡Abre un issue o únete a nuestras discusiones!
