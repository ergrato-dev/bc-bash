#!/bin/bash
# ============================================
# Práctica 05: Integración - Analizador de Logs
# Semana 3 - Variables y Control de Flujo
# SOLUCIÓN COMPLETA
# ============================================

echo "=== Práctica 05: Analizador de Logs ==="
echo ""

# ============================================
# PASO 1: Configuración Inicial
# ============================================
echo "--- Paso 1: Configuración ---"

LOG_FILE="/tmp/app.log"
REPORT_DIR="/tmp/reports"

# Crear directorio de reportes si no existe
if [[ ! -d "$REPORT_DIR" ]]; then
    mkdir -p "$REPORT_DIR"
    echo "✓ Directorio de reportes creado: $REPORT_DIR"
else
    echo "✓ Directorio de reportes existe: $REPORT_DIR"
fi

echo ""

# ============================================
# PASO 2: Generar Archivo de Log de Prueba
# ============================================
echo "--- Paso 2: Generando archivo de log ---"

cat > "$LOG_FILE" << 'EOF'
2024-01-15 10:30:15 INFO Starting application
2024-01-15 10:30:16 DEBUG Loading configuration
2024-01-15 10:30:17 INFO Configuration loaded successfully
2024-01-15 10:30:18 DEBUG Connecting to database
2024-01-15 10:30:19 ERROR Failed to connect to database
2024-01-15 10:30:20 WARNING Retrying connection...
2024-01-15 10:30:21 INFO Database connected
2024-01-15 10:30:22 DEBUG Loading user data
2024-01-15 10:30:23 INFO User service started
2024-01-15 10:30:24 WARNING Low memory warning
2024-01-15 10:31:00 INFO Processing request #1001
2024-01-15 10:31:05 DEBUG Request validation passed
2024-01-15 10:31:10 INFO Request completed successfully
2024-01-15 10:32:00 ERROR Invalid input received
2024-01-15 10:32:05 WARNING Rate limit approaching
2024-01-15 10:33:00 INFO New connection established
2024-01-15 10:33:30 CRITICAL System overload detected
2024-01-15 10:33:35 ERROR Service unavailable
2024-01-15 10:34:00 INFO System recovered
2024-01-15 10:35:00 CRITICAL Disk space critical
EOF
echo "✓ Archivo de log creado: $LOG_FILE"
echo "  ($(wc -l < "$LOG_FILE") líneas)"

echo ""

# ============================================
# PASO 3: Función para Mostrar Menú
# ============================================
echo "--- Paso 3: Función de Menú ---"

show_menu() {
    echo ""
    echo "╔═══════════════════════════════════╗"
    echo "║    📊 ANALIZADOR DE LOGS          ║"
    echo "╠═══════════════════════════════════╣"
    echo "║  1. Estadísticas generales        ║"
    echo "║  2. Buscar errores                ║"
    echo "║  3. Buscar por fecha              ║"
    echo "║  4. Generar reporte               ║"
    echo "║  5. Análisis por nivel            ║"
    echo "║  q. Salir                         ║"
    echo "╚═══════════════════════════════════╝"
}
echo "✓ Función show_menu definida"

echo ""

# ============================================
# PASO 4: Función de Estadísticas
# ============================================
echo "--- Paso 4: Función de Estadísticas ---"

show_stats() {
    echo ""
    echo "=== 📈 Estadísticas Generales ==="
    
    local total_lines=$(wc -l < "$LOG_FILE")
    local errors=$(grep -c "ERROR" "$LOG_FILE" 2>/dev/null || echo 0)
    local warnings=$(grep -c "WARNING" "$LOG_FILE" 2>/dev/null || echo 0)
    local criticals=$(grep -c "CRITICAL" "$LOG_FILE" 2>/dev/null || echo 0)
    
    echo "  Total de líneas:  $total_lines"
    echo "  Errores:          $errors"
    echo "  Warnings:         $warnings"
    echo "  Críticos:         $criticals"
    
    # Calcular porcentaje de errores
    if [[ $total_lines -gt 0 ]]; then
        local error_pct=$((errors * 100 / total_lines))
        echo "  Tasa de errores:  ${error_pct}%"
    fi
}
echo "✓ Función show_stats definida"

echo ""

# ============================================
# PASO 5: Buscar Errores
# ============================================
echo "--- Paso 5: Función de Búsqueda de Errores ---"

search_errors() {
    echo ""
    echo "=== 🔴 Errores Encontrados ==="
    
    local count=0
    while IFS= read -r line; do
        ((count++))
        echo "  [$count] $line"
    done < <(grep "ERROR\|CRITICAL" "$LOG_FILE")
    
    if [[ $count -eq 0 ]]; then
        echo "  ✓ No se encontraron errores"
    else
        echo ""
        echo "  Total: $count errores/críticos"
    fi
}
echo "✓ Función search_errors definida"

echo ""

# ============================================
# PASO 6: Buscar por Fecha
# ============================================
echo "--- Paso 6: Función de Búsqueda por Fecha ---"

search_by_date() {
    local fecha="${1:-2024-01-15}"
    
    echo ""
    echo "=== 📅 Logs del $fecha ==="
    
    local matches=$(grep "$fecha" "$LOG_FILE" | wc -l)
    
    if [[ $matches -gt 0 ]]; then
        grep "$fecha" "$LOG_FILE" | head -10
        if [[ $matches -gt 10 ]]; then
            echo "  ... y $((matches - 10)) más"
        fi
    else
        echo "  No se encontraron logs para $fecha"
    fi
}
echo "✓ Función search_by_date definida"

echo ""

# ============================================
# PASO 7: Generar Reporte
# ============================================
echo "--- Paso 7: Función de Generación de Reportes ---"

generate_report() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local report_file="$REPORT_DIR/report_$timestamp.txt"
    
    echo ""
    echo "=== 📄 Generando Reporte ==="
    
    {
        echo "╔═══════════════════════════════════════════════╗"
        echo "║           REPORTE DE ANÁLISIS DE LOGS         ║"
        echo "╚═══════════════════════════════════════════════╝"
        echo ""
        echo "Fecha de generación: $(date)"
        echo "Archivo analizado:   $LOG_FILE"
        echo ""
        echo "--- Estadísticas ---"
        echo "Total de líneas:  $(wc -l < "$LOG_FILE")"
        echo "INFO:             $(grep -c "INFO" "$LOG_FILE")"
        echo "DEBUG:            $(grep -c "DEBUG" "$LOG_FILE")"
        echo "WARNING:          $(grep -c "WARNING" "$LOG_FILE")"
        echo "ERROR:            $(grep -c "ERROR" "$LOG_FILE")"
        echo "CRITICAL:         $(grep -c "CRITICAL" "$LOG_FILE")"
        echo ""
        echo "--- Errores Detallados ---"
        grep "ERROR\|CRITICAL" "$LOG_FILE"
        echo ""
        echo "--- Fin del Reporte ---"
    } > "$report_file"
    
    echo "  ✓ Reporte guardado en:"
    echo "    $report_file"
}
echo "✓ Función generate_report definida"

echo ""

# ============================================
# PASO 8: Menú Principal con Case (Simulado)
# ============================================
echo "--- Paso 8: Menú Principal ---"

# Simulamos opciones del menú
opciones_demo=("1" "2" "5" "q")

echo "  Demostración del menú (opciones: ${opciones_demo[*]})"
echo ""

for opcion in "${opciones_demo[@]}"; do
    echo "  → Selección: $opcion"
    case $opcion in
        1)
            show_stats
            ;;
        2)
            search_errors
            ;;
        3)
            search_by_date "2024-01-15"
            ;;
        4)
            generate_report
            ;;
        5)
            echo ""
            echo "=== 📊 Análisis por Nivel ==="
            levels=("INFO" "DEBUG" "WARNING" "ERROR" "CRITICAL")
            for level in "${levels[@]}"; do
                count=$(grep -c "$level" "$LOG_FILE" 2>/dev/null || echo 0)
                printf "    %-10s: %d\n" "$level" "$count"
            done
            ;;
        q|Q)
            echo "    Saliendo del menú..."
            break
            ;;
        *)
            echo "    Opción no válida"
            ;;
    esac
    echo ""
done

echo ""

# ============================================
# PASO 9: Validación de Archivo
# ============================================
echo "--- Paso 9: Validación ---"

validate_log_file() {
    if [[ ! -f "$LOG_FILE" ]]; then
        echo "  ✗ Error: Archivo no encontrado: $LOG_FILE"
        return 1
    fi
    
    if [[ ! -r "$LOG_FILE" ]]; then
        echo "  ✗ Error: No se puede leer: $LOG_FILE"
        return 1
    fi
    
    local size=$(stat -c%s "$LOG_FILE" 2>/dev/null || stat -f%z "$LOG_FILE" 2>/dev/null)
    if [[ $size -eq 0 ]]; then
        echo "  ⚠ Warning: El archivo está vacío"
        return 1
    fi
    
    echo "  ✓ Archivo válido: $LOG_FILE ($size bytes)"
    return 0
}

validate_log_file

echo ""

# ============================================
# PASO 10: Análisis por Nivel
# ============================================
echo "--- Paso 10: Análisis por Nivel ---"

analyze_levels() {
    echo ""
    echo "=== 📊 Distribución por Nivel ==="
    
    declare -a levels=("INFO" "DEBUG" "WARNING" "ERROR" "CRITICAL")
    local total=$(wc -l < "$LOG_FILE")
    
    for level in "${levels[@]}"; do
        local count=$(grep -c "$level" "$LOG_FILE" 2>/dev/null || echo 0)
        local pct=0
        if [[ $total -gt 0 ]]; then
            pct=$((count * 100 / total))
        fi
        
        # Barra visual
        local bar=""
        for ((i=0; i<pct/5; i++)); do
            bar+="█"
        done
        
        printf "  %-10s: %3d (%2d%%) %s\n" "$level" "$count" "$pct" "$bar"
    done
}

analyze_levels

echo ""
echo "✅ ¡Práctica de integración completada!"

# Limpieza (opcional)
# rm -f "$LOG_FILE" 2>/dev/null
# rm -rf "$REPORT_DIR" 2>/dev/null
