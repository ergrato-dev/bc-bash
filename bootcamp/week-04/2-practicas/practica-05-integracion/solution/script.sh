#!/bin/bash
# ============================================
# Práctica 5: Integración - Agenda de Contactos
# Semana 4 - Funciones y Arrays - SOLUCIÓN
# ============================================

echo "=== Práctica 5: Agenda de Contactos ==="
echo ""

# ============================================
# PASO 1: Estructura Base
# ============================================

declare -a CONTACTOS_NOMBRES=()
declare -a CONTACTOS_TELEFONOS=()
declare -a CONTACTOS_EMAILS=()

echo "Estructura de datos inicializada ✓"

# ============================================
# PASO 2: Función Agregar Contacto
# ============================================

# ----------------------------------------
# Agrega un contacto a la agenda
# Uso: agregar_contacto "nombre" "telefono" "email"
# Retorna: 0 si éxito, 1 si faltan datos
# ----------------------------------------
agregar_contacto() {
    local nombre="$1"
    local telefono="$2"
    local email="${3:-sin-email}"
    
    if [[ -z "$nombre" || -z "$telefono" ]]; then
        echo "Error: nombre y teléfono son obligatorios"
        return 1
    fi
    
    CONTACTOS_NOMBRES+=("$nombre")
    CONTACTOS_TELEFONOS+=("$telefono")
    CONTACTOS_EMAILS+=("$email")
    
    echo "Contacto '$nombre' agregado ✓"
    return 0
}

# ============================================
# PASO 3: Función Listar Contactos
# ============================================

# ----------------------------------------
# Lista todos los contactos
# Uso: listar_contactos
# ----------------------------------------
listar_contactos() {
    local total=${#CONTACTOS_NOMBRES[@]}
    
    if [[ $total -eq 0 ]]; then
        echo "La agenda está vacía"
        return 1
    fi
    
    echo "╔════════════════════════════════════════╗"
    echo "║         AGENDA DE CONTACTOS            ║"
    echo "╠════════════════════════════════════════╣"
    
    for i in "${!CONTACTOS_NOMBRES[@]}"; do
        printf "║ [%d] %-34s ║\n" "$i" "${CONTACTOS_NOMBRES[$i]}"
    done
    
    echo "╚════════════════════════════════════════╝"
    echo "Total: $total contacto(s)"
    return 0
}

# ============================================
# PASO 4: Función Buscar Contacto
# ============================================

# ----------------------------------------
# Busca un contacto por nombre
# Uso: buscar_contacto "nombre"
# Retorna: índice si encuentra, 1 si no
# ----------------------------------------
buscar_contacto() {
    local busqueda="$1"
    
    for i in "${!CONTACTOS_NOMBRES[@]}"; do
        if [[ "${CONTACTOS_NOMBRES[$i],,}" == *"${busqueda,,}"* ]]; then
            echo "$i"
            return 0
        fi
    done
    
    return 1
}

# ============================================
# PASO 5: Función Mostrar Detalles
# ============================================

# ----------------------------------------
# Muestra detalles de un contacto
# Uso: mostrar_contacto indice
# ----------------------------------------
mostrar_contacto() {
    local idx="$1"
    
    if [[ -z "${CONTACTOS_NOMBRES[$idx]}" ]]; then
        echo "Error: contacto no encontrado"
        return 1
    fi
    
    echo "┌──────────────────────────────┐"
    echo "│   DETALLE DEL CONTACTO       │"
    echo "├──────────────────────────────┤"
    echo "│ Nombre:   ${CONTACTOS_NOMBRES[$idx]}"
    echo "│ Teléfono: ${CONTACTOS_TELEFONOS[$idx]}"
    echo "│ Email:    ${CONTACTOS_EMAILS[$idx]}"
    echo "└──────────────────────────────┘"
    return 0
}

# ============================================
# PASO 6: Función Eliminar Contacto
# ============================================

# ----------------------------------------
# Elimina un contacto
# Uso: eliminar_contacto indice
# ----------------------------------------
eliminar_contacto() {
    local idx="$1"
    local nombre="${CONTACTOS_NOMBRES[$idx]}"
    
    if [[ -z "$nombre" ]]; then
        echo "Error: contacto no existe"
        return 1
    fi
    
    unset 'CONTACTOS_NOMBRES[$idx]'
    unset 'CONTACTOS_TELEFONOS[$idx]'
    unset 'CONTACTOS_EMAILS[$idx]'
    
    echo "Contacto '$nombre' eliminado ✓"
    return 0
}

# ============================================
# PASO 7: Función de Estadísticas
# ============================================

# ----------------------------------------
# Muestra estadísticas
# Uso: estadisticas
# ----------------------------------------
estadisticas() {
    local total=${#CONTACTOS_NOMBRES[@]}
    local con_email=0
    
    for email in "${CONTACTOS_EMAILS[@]}"; do
        [[ "$email" != "sin-email" ]] && ((con_email++))
    done
    
    echo "═══════════════════════════════"
    echo "       ESTADÍSTICAS            "
    echo "═══════════════════════════════"
    echo "Total contactos:     $total"
    echo "Con email:           $con_email"
    echo "Sin email:           $((total - con_email))"
    echo "═══════════════════════════════"
}

# ============================================
# PASO 8: Demostración
# ============================================

echo ""
echo "=== DEMOSTRACIÓN DE LA AGENDA ==="
echo ""

# Agregar contactos de prueba
agregar_contacto "Ana García" "612345678" "ana@email.com"
agregar_contacto "Carlos López" "698765432" "carlos@email.com"
agregar_contacto "María Rodríguez" "611223344"
agregar_contacto "Pedro Martínez" "655443322" "pedro@email.com"

echo ""

# Listar todos
listar_contactos

echo ""

# Buscar un contacto
echo "Buscando 'carlos'..."
if idx=$(buscar_contacto "carlos"); then
    mostrar_contacto "$idx"
else
    echo "No encontrado"
fi

echo ""

# Eliminar un contacto
eliminar_contacto 2

echo ""

# Mostrar estadísticas
estadisticas

echo ""

# Listar después de eliminar
listar_contactos

echo ""
echo "=== Práctica 5 Completada ==="
