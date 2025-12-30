#!/bin/bash
# ============================================
# Práctica 01: Condicionales if/elif/else
# Semana 3 - Variables y Control de Flujo
# SOLUCIÓN COMPLETA
# ============================================

echo "=== Práctica 01: Condicionales if/elif/else ==="
echo ""

# ============================================
# PASO 1: Comparación Numérica Básica
# ============================================
echo "--- Paso 1: Comparación Numérica ---"

numero=15

if [[ $numero -gt 0 ]]; then
    echo "$numero es un número positivo"
fi

echo ""

# ============================================
# PASO 2: Estructura Completa if/elif/else
# ============================================
echo "--- Paso 2: if/elif/else completo ---"

valor=42

if [[ $valor -gt 0 ]]; then
    echo "$valor es POSITIVO"
elif [[ $valor -lt 0 ]]; then
    echo "$valor es NEGATIVO"
else
    echo "$valor es CERO"
fi

echo ""

# ============================================
# PASO 3: Verificar Existencia de Archivos
# ============================================
echo "--- Paso 3: Verificar Archivos ---"

archivo_sistema="/etc/passwd"

if [[ -f "$archivo_sistema" ]]; then
    echo "✓ $archivo_sistema existe"
else
    echo "✗ $archivo_sistema NO existe"
fi

echo ""

# ============================================
# PASO 4: Verificar Permisos
# ============================================
echo "--- Paso 4: Verificar Permisos ---"

directorio="/tmp"

if [[ -w "$directorio" ]]; then
    echo "✓ $directorio es escribible"
else
    echo "✗ $directorio NO es escribible"
fi

echo ""

# ============================================
# PASO 5: Comparación de Strings
# ============================================
echo "--- Paso 5: Comparación de Strings ---"

usuario="admin"

if [[ "$usuario" == "admin" ]]; then
    echo "¡Bienvenido administrador!"
else
    echo "Usuario regular: $usuario"
fi

echo ""

# ============================================
# PASO 6: Cadenas Vacías
# ============================================
echo "--- Paso 6: Cadenas Vacías ---"

nombre=""
apellido="García"

if [[ -z "$nombre" ]]; then
    echo "✗ El nombre está vacío"
fi

if [[ -n "$apellido" ]]; then
    echo "✓ Apellido definido: $apellido"
fi

echo ""

# ============================================
# PASO 7: Condiciones Múltiples con AND
# ============================================
echo "--- Paso 7: AND lógico ---"

edad=25

if [[ $edad -ge 18 && $edad -le 65 ]]; then
    echo "✓ $edad está en edad laboral (18-65)"
else
    echo "✗ $edad está fuera de edad laboral"
fi

echo ""

# ============================================
# PASO 8: Condiciones con OR
# ============================================
echo "--- Paso 8: OR lógico ---"

dia="sábado"

if [[ "$dia" == "sábado" || "$dia" == "domingo" ]]; then
    echo "✓ ¡Es fin de semana!"
else
    echo "Es día laboral"
fi

echo ""

# ============================================
# PASO 9: Negación de Condiciones
# ============================================
echo "--- Paso 9: Negación ---"

archivo_test="/tmp/archivo_inexistente.txt"

if [[ ! -f "$archivo_test" ]]; then
    echo "✗ $archivo_test NO existe"
else
    echo "✓ $archivo_test existe"
fi

echo ""

# ============================================
# PASO 10: Expresiones Regulares
# ============================================
echo "--- Paso 10: Expresiones Regulares ---"

email="user@example.com"

if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "✓ $email es un email válido"
else
    echo "✗ $email NO es un email válido"
fi

echo ""
echo "✅ ¡Práctica completada!"
