# 🚀 Práctica 04: CI/CD y Git Hooks

> **Objetivo**: Automatizar workflows con Git hooks y Makefile

---

## 🎨 Recurso Visual

![DevOps](../../0-assets/04-devops-cicd.svg)

---

## 📋 Pasos

### Paso 1: Pre-commit Hook

Hook que se ejecuta antes de cada commit:

```bash
# .git/hooks/pre-commit
#!/bin/bash
shellcheck *.sh || exit 1
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Validación de Código

Verificar sintaxis antes de commit:

```bash
bash -n script.sh           # Sintaxis
shellcheck script.sh        # Lint
```

**Descomenta** la sección del Paso 2.

---

### Paso 3: Tests Automatizados

Ejecutar tests en pre-push:

```bash
run_tests() {
    ./tests/run-all.sh || exit 1
}
```

**Descomenta** la sección del Paso 3.

---

### Paso 4: Makefile Básico

Comandos de build con Make:

```makefile
.PHONY: test lint
test:
    ./run-tests.sh
lint:
    shellcheck *.sh
```

**Descomenta** la sección del Paso 4.

---

### Paso 5: Script de Instalación de Hooks

Automatizar setup de hooks:

```bash
install_hooks() {
    cp hooks/* .git/hooks/
    chmod +x .git/hooks/*
}
```

**Descomenta** la sección del Paso 5.

---

### Paso 6: Pipeline CI Local

Simular CI en local:

```bash
ci_pipeline() {
    run_lint && run_tests && run_build
}
```

**Descomenta** la sección del Paso 6.

---

## ✅ Verificación

```bash
chmod +x starter/script.sh
./starter/script.sh
```

---

## 🔗 Navegación

← [Práctica 03](../practica-03-apis/) | [Proyecto →](../../3-proyecto/)
