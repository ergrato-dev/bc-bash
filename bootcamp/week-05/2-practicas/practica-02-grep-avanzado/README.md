# Práctica 2: grep Avanzado

## 🎯 Objetivo

Dominar las opciones avanzadas de grep para búsqueda de patrones en archivos.

## 📚 Conceptos

- Opciones básicas: `-i`, `-v`, `-n`, `-c`
- Opciones avanzadas: `-E`, `-o`, `-A`, `-B`, `-C`
- Búsqueda recursiva: `-r`
- Múltiples patrones

## 📋 Pasos

### Paso 1: Crear Datos de Prueba

Generamos un archivo de log simulado para las prácticas.

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Búsqueda Básica

Opciones `-i` (ignorar caso) y `-n` (número de línea).

```bash
grep -i "error" archivo.log    # Ignorar mayúsculas
grep -n "WARNING" archivo.log  # Mostrar número de línea
```

**Descomenta** la sección del Paso 2.

---

### Paso 3: Contar e Invertir

Opción `-c` cuenta coincidencias, `-v` invierte la búsqueda.

```bash
grep -c "ERROR" archivo.log    # Contar líneas
grep -v "DEBUG" archivo.log    # Todo EXCEPTO DEBUG
```

**Descomenta** la sección del Paso 3.

---

### Paso 4: Extended Regex

Opción `-E` habilita expresiones regulares extendidas.

```bash
grep -E "ERROR|WARNING" log    # Alternancia
grep -E "[0-9]{3}" log         # Cuantificadores
```

**Descomenta** la sección del Paso 4.

---

### Paso 5: Extraer Coincidencias

Opción `-o` muestra solo la parte que coincide.

```bash
grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" log  # Solo IPs
```

**Descomenta** la sección del Paso 5.

---

### Paso 6: Contexto

Opciones `-A` (after), `-B` (before), `-C` (context).

```bash
grep -A 2 "ERROR" log    # 2 líneas después
grep -B 2 "ERROR" log    # 2 líneas antes
grep -C 2 "ERROR" log    # 2 líneas alrededor
```

**Descomenta** la sección del Paso 6.

---

### Paso 7: Búsqueda Recursiva

Buscar en múltiples archivos y directorios.

```bash
grep -r "TODO" src/            # Recursivo
grep -rn "FIXME" --include="*.sh" .  # Con filtro
```

**Descomenta** la sección del Paso 7.

---

### Paso 8: Función de Análisis

Crear función para analizar logs con múltiples criterios.

**Descomenta** la sección del Paso 8.

---

## ✅ Verificación

```bash
cd starter
chmod +x script.sh
./script.sh
```

## 🔗 Navegación

[⬅️ Práctica 1](../practica-01-regex-basico/README.md) | [➡️ Práctica 3](../practica-03-sed-transformaciones/README.md)
