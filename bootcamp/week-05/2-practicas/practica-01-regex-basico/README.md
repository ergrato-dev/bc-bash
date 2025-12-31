# Práctica 1: Expresiones Regulares Básicas

## 🎯 Objetivo

Aprender a usar expresiones regulares en Bash con `[[ =~ ]]` y `grep -E`.

## 📚 Conceptos

- Metacaracteres: `^`, `$`, `.`, `*`, `+`, `?`
- Clases de caracteres: `[abc]`, `[a-z]`, `[0-9]`
- Anclas y límites de palabra
- Cuantificadores

## 📋 Pasos

### Paso 1: Metacaracteres Básicos

El punto `.` coincide con cualquier carácter. El asterisco `*` significa "cero o más".

```bash
# . = cualquier carácter
# * = cero o más del anterior
# + = uno o más del anterior
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Anclas de Posición

`^` marca inicio de línea, `$` marca fin de línea.

```bash
# ^patron  = línea que EMPIEZA con patron
# patron$  = línea que TERMINA con patron
# ^patron$ = línea que ES exactamente patron
```

**Descomenta** la sección del Paso 2.

---

### Paso 3: Clases de Caracteres

Los corchetes `[]` definen conjuntos de caracteres válidos.

```bash
# [abc]   = a, b, o c
# [a-z]   = cualquier minúscula
# [0-9]   = cualquier dígito
# [^abc]  = cualquier cosa EXCEPTO a, b, c
```

**Descomenta** la sección del Paso 3.

---

### Paso 4: Cuantificadores

Controlan cuántas veces debe aparecer un patrón.

```bash
# a*     = cero o más 'a'
# a+     = una o más 'a'
# a?     = cero o una 'a'
# a{3}   = exactamente 3 'a'
# a{2,4} = entre 2 y 4 'a'
```

**Descomenta** la sección del Paso 4.

---

### Paso 5: Operador =~ en Bash

Bash permite validar regex con `[[ $var =~ regex ]]`.

```bash
if [[ "$texto" =~ ^[0-9]+$ ]]; then
    echo "Es un número"
fi
```

**Descomenta** la sección del Paso 5.

---

### Paso 6: Grupos y Alternancia

Los paréntesis agrupan, la barra `|` es "o".

```bash
# (foo|bar)  = foo O bar
# (ab)+      = ab, abab, ababab...
```

**Descomenta** la sección del Paso 6.

---

### Paso 7: Patrones Comunes

Expresiones regulares útiles del mundo real.

```bash
# Email:    [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
# IP:       [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}
# Fecha:    [0-9]{4}-[0-9]{2}-[0-9]{2}
```

**Descomenta** la sección del Paso 7.

---

### Paso 8: Función de Validación

Crear funciones reutilizables para validar formatos.

**Descomenta** la sección del Paso 8.

---

## ✅ Verificación

Ejecuta el script completo:

```bash
cd starter
chmod +x script.sh
./script.sh
```

## 🔗 Navegación

[⬅️ Índice](../README.md) | [➡️ Práctica 2](../practica-02-grep-avanzado/README.md)
