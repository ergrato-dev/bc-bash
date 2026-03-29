# Práctica 4: awk Procesamiento Columnar

## 🎯 Objetivo

Dominar awk para procesar datos estructurados y generar reportes.

## 📚 Conceptos

- Campos: `$1`, `$2`, `$NF`
- Variables: `NR`, `NF`, `FS`, `OFS`
- Bloques: `BEGIN`, `END`
- Condiciones y cálculos

## 📋 Pasos

### Paso 1: Crear Datos de Prueba

Generamos datos CSV y tabulares para procesamiento.

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Imprimir Campos

Acceder a campos específicos con `$n`.

```bash
awk '{print $1}' archivo       # Primer campo
awk '{print $1, $3}' archivo   # Campos 1 y 3
awk '{print $NF}' archivo      # Último campo
```

**Descomenta** la sección del Paso 2.

---

### Paso 3: Separador de Campos

Opción `-F` define el separador de entrada.

```bash
awk -F',' '{print $2}' datos.csv    # CSV
awk -F':' '{print $1}' /etc/passwd  # Dos puntos
```

**Descomenta** la sección del Paso 3.

---

### Paso 4: Variables Built-in

Variables especiales de awk.

```bash
NR = Número de registro (línea)
NF = Número de campos en la línea
FS = Field Separator (entrada)
OFS = Output Field Separator (salida)
```

**Descomenta** la sección del Paso 4.

---

### Paso 5: Filtrar por Condición

Ejecutar acciones solo si se cumple condición.

```bash
awk '$3 > 100 {print $1}' datos     # Si campo3 > 100
awk '/ERROR/ {print}' log           # Si contiene ERROR
awk 'NR > 1 {print}' datos          # Saltar encabezado
```

**Descomenta** la sección del Paso 5.

---

### Paso 6: Cálculos y Acumuladores

Realizar operaciones matemáticas.

```bash
awk '{sum += $2} END {print sum}' datos    # Sumar columna
awk '{print $1, $2 * $3}' datos            # Multiplicar
```

**Descomenta** la sección del Paso 6.

---

### Paso 7: BEGIN y END

Bloques que se ejecutan antes y después del procesamiento.

```bash
awk 'BEGIN {print "Inicio"} {print $1} END {print "Fin"}' archivo
```

**Descomenta** la sección del Paso 7.

---

### Paso 8: Formateo con printf

Control preciso del formato de salida.

```bash
awk '{printf "%-10s %5d\n", $1, $2}' datos
```

**Descomenta** la sección del Paso 8.

---

## ✅ Verificación

```bash
cd starter
chmod +x script.sh
./script.sh
```

## 🔗 Navegación

[⬅️ Práctica 3](../practica-03-sed-transformaciones/README.md) | [➡️ Práctica 5](../practica-05-integracion/README.md)
