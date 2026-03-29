# 🧪 Práctica 04: Testing y Validación

> **Objetivo**: Implementar tests y validación en scripts Bash

---

## 📚 Recursos Visuales

![Testing](../../0-assets/04-testing-validacion.svg)

---

## 📋 Contenido

### Paso 1: Función Assert

Crear assertions para verificar condiciones:

```bash
assert() {
    local msg="$1"; shift
    "$@" || { echo "FAIL: $msg" >&2; return 1; }
}

assert "2+2=4" [ $((2+2)) -eq 4 ]
```

**Abre `starter/script.sh`** y descomenta la sección correspondiente.

---

### Paso 2: Estructura de Tests

Organizar tests como funciones:

```bash
test_mi_funcion() {
    local result=$(mi_funcion "input")
    [[ "$result" == "expected" ]]
}
```

**Descomenta el Paso 2** en el script.

---

### Paso 3: Test Runner

Ejecutar todos los tests automáticamente:

```bash
run_tests() {
    for func in $(declare -F | grep test_); do
        if $func; then echo "✅ $func"
        else echo "❌ $func"; fi
    done
}
```

**Descomenta el Paso 3** en el script.

---

### Paso 4: Validación de Input

Validar argumentos y datos de entrada:

```bash
[[ $# -ge 1 ]] || die "Uso: $0 <archivo>"
[[ -f "$1" ]] || die "No existe: $1"
[[ "$1" =~ ^[0-9]+$ ]] || die "No es número"
```

**Descomenta el Paso 4** en el script.

---

### Paso 5: ShellCheck

Usar análisis estático para encontrar problemas:

```bash
# Instalar: sudo apt install shellcheck
shellcheck script.sh
```

**Descomenta el Paso 5** en el script.

---

### Paso 6: Test Framework Completo

Combinar todo en un mini-framework:

```bash
source ./functions.sh
run_all_tests
```

**Descomenta el Paso 6** en el script.

---

## ✅ Verificación

```bash
cd starter && chmod +x script.sh && ./script.sh
```

---

## 🔗 Navegación

← [Práctica 03](../practica-03-profiling/) | [Proyecto →](../../3-proyecto/)
