#!/bin/bash
# ============================================
# Ejemplo de script para probar DebugKit
# ============================================

set -euo pipefail

# Función de ejemplo
suma() {
    local a="$1"
    local b="$2"
    echo $((a + b))
}

resta() {
    local a="$1"
    local b="$2"
    echo $((a - b))
}

multiplica() {
    local a="$1"
    local b="$2"
    echo $((a * b))
}

# Main
main() {
    echo "Calculadora simple"
    echo ""
    
    local x=10
    local y=5
    
    echo "x=$x, y=$y"
    echo "Suma: $(suma $x $y)"
    echo "Resta: $(resta $x $y)"
    echo "Multiplicación: $(multiplica $x $y)"
}

# Ejecutar si es el script principal
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
