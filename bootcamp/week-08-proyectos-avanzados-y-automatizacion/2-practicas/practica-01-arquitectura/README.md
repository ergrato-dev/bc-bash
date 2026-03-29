# 📦 Práctica 01: Arquitectura Modular

> **Objetivo**: Aprender a estructurar proyectos de Bash profesionales

---

## 🎨 Recurso Visual

![Arquitectura](../../0-assets/01-arquitectura-sistemas.svg)

---

## 📋 Pasos

### Paso 1: Estructura de Directorios

Un proyecto profesional separa código, configuración y recursos:

```
proyecto/
├── bin/          # Ejecutables
├── lib/          # Librerías
├── config/       # Configuraciones
└── tests/        # Tests
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Script Principal con Source

El script principal importa módulos con `source`:

```bash
source "$LIB_DIR/utils.sh"
source "$LIB_DIR/logger.sh"
```

**Descomenta** la sección del Paso 2.

---

### Paso 3: Módulo de Utilidades

Funciones reutilizables en archivos separados:

```bash
# lib/utils.sh
trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo "$var"
}
```

**Descomenta** la sección del Paso 3.

---

### Paso 4: Módulo de Logging

Sistema de logging con niveles:

```bash
log_info()  { echo "[INFO] $*"; }
log_warn()  { echo "[WARN] $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; }
```

**Descomenta** la sección del Paso 4.

---

### Paso 5: Carga de Configuración

Leer configuración de archivos externos:

```bash
config_load() {
    local config_file="$1"
    [[ -f "$config_file" ]] && source "$config_file"
}
```

**Descomenta** la sección del Paso 5.

---

### Paso 6: Función Main con Guard

Patrón para scripts que pueden ser importados o ejecutados:

```bash
main() {
    log_info "Starting application"
    # Lógica principal
}

[[ "${BASH_SOURCE[0]}" == "$0" ]] && main "$@"
```

**Descomenta** la sección del Paso 6.

---

## ✅ Verificación

Ejecuta el script y verifica:

```bash
chmod +x starter/script.sh
./starter/script.sh
```

Deberías ver:

- Estructura de directorios creada
- Módulos cargados correctamente
- Logging funcionando

---

## 🔗 Navegación

← [Prácticas](../) | [Práctica 02 →](../practica-02-pipelines/)
