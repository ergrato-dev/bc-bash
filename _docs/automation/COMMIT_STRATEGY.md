# Commit Automation Strategy

Este proyecto implementa una estrategia completa de commits automáticos con mejores prácticas, generando mensajes en inglés siguiendo la convención de Conventional Commits con mínima intervención del usuario.

## 🚀 Características Principales

- **Detección Automática**: Analiza los archivos modificados y determina el tipo de commit apropiado
- **Conventional Commits**: Sigue el estándar de conventional commits (type(scope): description)
- **Commits Inteligentes**: Divide commits grandes en commits más pequeños y focalizados
- **Mínima Intervención**: Funciona automáticamente con configuración por defecto
- **Mensajes en Inglés**: Todos los commits se generan en inglés profesional
- **Configuración Flexible**: JSON configurable para personalizar comportamiento

## 📁 Estructura de Scripts

```
scripts/
├── commit.sh              # Script principal (punto de entrada único)
├── auto-commit.sh         # Commits automáticos con detección inteligente
├── quick-commit.sh        # Commits interactivos rápidos
├── smart-commit.sh        # Commits con IA (próximamente)
├── setup-auto-commit.sh   # Configuración inicial
├── commit-config.json     # Archivo de configuración
└── README.md             # Documentación detallada
```

## 🎯 Uso Rápido

### Comando Principal

```bash
# Punto de entrada único para todas las operaciones
./scripts/commit.sh [COMMAND]
```

### Comandos Disponibles

```bash
# Commits automáticos (recomendado para uso diario)
./scripts/commit.sh auto

# Commits interactivos
./scripts/commit.sh quick

# Ver estado actual
./scripts/commit.sh status

# Configuración
./scripts/commit.sh config

# Ayuda
./scripts/commit.sh help
```

### Uso Directo de Scripts

```bash
# Automático (sin intervención)
./scripts/auto-commit.sh

# Interactivo (selección manual)
./scripts/quick-commit.sh

# Configuración inicial
./scripts/setup-auto-commit.sh
```

## 🔧 Tipos de Commit Automáticos

El sistema detecta automáticamente el tipo de commit basado en los archivos modificados:

| Tipo de Archivo                  | Tipo de Commit | Ejemplo                                    |
| -------------------------------- | -------------- | ------------------------------------------ |
| `*.md`, `*.txt`, `README*`       | `docs`         | `docs(module1): update README.md`          |
| `*test*`, `*.test.sh`            | `test`         | `test(scripts): add unit tests`            |
| `*.json`, `*.yml`, `.env*`       | `config`       | `config: update project configuration`     |
| `*.sh`, `scripts/*`              | `script`       | `script(scripts): update automation tools` |
| `.gitignore`, `.github/*`        | `ci`           | `ci: update git configuration`             |
| `package.json`, `pnpm-lock.yaml` | `deps`         | `deps: update project dependencies`        |
| `*.css`, `*.scss`                | `style`        | `style: improve component styling`         |
| Otros archivos                   | `feat` o `fix` | `feat(module2): add new exercise solution` |

## 🎨 Ejemplos de Commits Generados

```bash
# Modificar README en módulo 1
feat(module1): update README.md

# Agregar múltiples ejercicios
feat(exercises): add new shell scripting exercises

# Actualizar scripts de automatización
script(scripts): improve commit automation system

# Corregir bugs en ejercicios
fix(module2): resolve syntax errors in exercise files

# Actualizar documentación
docs: update project documentation and examples

# Cambios en configuración
config: update git and project settings
```

## ⚙️ Configuración

### Archivo de Configuración (`scripts/commit-config.json`)

```json
{
  "max_files_per_commit": 10,
  "auto_push": false,
  "commit_patterns": {
    "feat": "add new features and functionality",
    "fix": "resolve bugs and issues",
    "docs": "update documentation"
  },
  "scope_mapping": {
    "week-01": "module1",
    "week-02": "module2",
    "scripts": "scripts",
    "ejercicios": "exercises"
  }
}
```

### Opciones Configurables

- `max_files_per_commit`: Máximo de archivos por commit (default: 10)
- `auto_push`: Push automático después del commit (default: false)
- `commit_patterns`: Plantillas para mensajes de commit
- `scope_mapping`: Mapeo de directorios a scopes
- `file_type_mapping`: Patrones de archivos a tipos de commit

## 🚦 Flujo de Trabajo Recomendado

### 1. Configuración Inicial (Una sola vez)

```bash
# Ejecutar setup
./scripts/commit.sh setup

# Verificar configuración
./scripts/commit.sh config
```

### 2. Uso Diario (Automático)

```bash
# Hacer cambios en archivos
echo "Nueva función" >> week-01/ejercicio.sh

# Commit automático
./scripts/commit.sh auto
# Resultado: feat(module1): update ejercicio.sh
```

### 3. Uso Interactivo (Cuando necesites control)

```bash
# Commit interactivo
./scripts/commit.sh quick
# Te permite seleccionar tipo, scope y descripción
```

### 4. Verificación

```bash
# Ver estado y commits recientes
./scripts/commit.sh status
```

## 🎛️ Características Avanzadas

### División Automática de Commits

```bash
# Si modificas 15 archivos, se crean múltiples commits:
# feat(module1): add exercise solutions (files 1-10)
# feat(module1): add additional exercise solutions (files 11-15)
```

### Detección de Scope Automática

```bash
# Cambios en week-01/ -> scope: module1
# Cambios en scripts/ -> scope: scripts
# Cambios en ejercicios/ -> scope: exercises
```

### Git Hooks Automáticos

- **Pre-commit**: Formateo automático de scripts shell
- **Commit-msg**: Validación de formato de commits (opcional)

## 🔄 Integración con Workflow

### Para Desarrollo Individual

```bash
# Workflow típico
git pull
# hacer cambios...
./scripts/commit.sh auto
git push
```

### Para Equipos

```bash
# Configurar auto-push
./scripts/commit.sh config
# Cambiar "auto_push": true en el JSON
```

## 📚 Mejores Prácticas Implementadas

1. **Commits Pequeños y Focalizados**: División automática de commits grandes
2. **Mensajes Descriptivos**: Generación basada en contexto de archivos
3. **Formato Consistente**: Conventional Commits estándar
4. **Scope Apropiado**: Detección automática basada en estructura del proyecto
5. **Idioma Profesional**: Todos los mensajes en inglés técnico
6. **Configuración Flexible**: Personalizable pero funcional por defecto

## 🛠️ Dependencias Opcionales

```bash
# Para mejor funcionalidad
sudo apt install jq      # JSON parsing
sudo apt install shfmt   # Shell script formatting
```

## 🎯 Próximas Características

- **AI Integration**: Commits generados con IA usando GitHub Copilot CLI
- **Semantic Versioning**: Detección automática de version bumps
- **Breaking Changes**: Detección y marcado automático
- **Changelog Generation**: Generación automática de changelogs

## 📖 Documentación Adicional

- `scripts/README.md`: Documentación técnica detallada
- `scripts/commit-config.json`: Configuración actual
- Git hooks en `.git/hooks/`: Automatizaciones adicionales

## 🤝 Contribución

Para modificar o extender el sistema:

1. Editar configuración: `scripts/commit-config.json`
2. Personalizar patrones de detección en `auto-commit.sh`
3. Agregar nuevos tipos de commit en la configuración
4. Probar con `./scripts/commit.sh status` antes de commits reales

---

**Resultado**: Sistema de commits completamente automatizado que requiere **cero configuración** para funcionar y genera commits profesionales en inglés siguiendo mejores prácticas con **mínima intervención del usuario**.
