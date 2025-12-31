# 🐛 Práctica 01: Debugging con Set

> **Objetivo**: Dominar las opciones de set para debugging y manejo de errores

---

## 📚 Recursos Visuales

![Bash Options](../../0-assets/02-bash-options.svg)

---

## 📋 Contenido

### Paso 1: set -e (errexit)

Exit inmediatamente si un comando retorna error:

```bash
set -e

# Con -e, el script termina si cualquier comando falla
comando_que_falla    # Script termina aquí
echo "Nunca llega"   # No se ejecuta
```

**Abre `starter/script.sh`** y descomenta la sección correspondiente.

---

### Paso 2: set -u (nounset)

Error si se usa una variable no definida:

```bash
set -u

echo "$variable_no_definida"  # Error!
echo "${var:-default}"        # Forma segura con default
```

**Descomenta el Paso 2** en el script.

---

### Paso 3: set -o pipefail

Propaga errores en pipelines:

```bash
set -o pipefail

# Sin pipefail: solo importa el último comando
false | true    # Exit code: 0

# Con pipefail: falla si cualquiera falla
false | true    # Exit code: 1
```

**Descomenta el Paso 3** en el script.

---

### Paso 4: set -x (xtrace)

Muestra cada comando antes de ejecutarlo:

```bash
set -x
var="hello"
echo "$var"
# Salida:
# + var=hello
# + echo hello
# hello
```

**Descomenta el Paso 4** en el script.

---

### Paso 5: Combo set -euo pipefail

La combinación recomendada para scripts robustos:

```bash
#!/bin/bash
set -euo pipefail

# -e: exit on error
# -u: error on undefined vars
# -o pipefail: pipe errors propagate
```

**Descomenta el Paso 5** en el script.

---

### Paso 6: Activar/Desactivar Opciones

Controlar opciones dinámicamente:

```bash
# Activar con guion
set -x

# Desactivar con plus
set +x

# Debug solo una sección
set -x
# código a debuggear
set +x
```

**Descomenta el Paso 6** en el script.

---

## ✅ Verificación

```bash
cd starter && chmod +x script.sh && ./script.sh
```

---

## 🔗 Navegación

← [Índice](../) | [Práctica 02 →](../practica-02-traps/)
