#!/bin/bash
# ============================================
# Proyecto Semana 3: Gestor de Tareas CLI
# SOLUCIÓN COMPLETA
# ============================================

# ============================================
# CONFIGURACIÓN
# ============================================

DATA_FILE="${HOME}/.task_manager_data"

declare -a TASK_IDS=()
declare -a TASK_DESCS=()
declare -a TASK_PRIORITIES=()
declare -a TASK_STATUSES=()
declare -a TASK_DATES=()
declare -a TASK_COMPLETED_DATES=()

NEXT_ID=1

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ============================================
# FUNCIONES AUXILIARES
# ============================================

get_current_date() {
    date "+%Y-%m-%d %H:%M"
}

print_colored() {
    local color="$1"
    local text="$2"
    echo -e "${color}${text}${NC}"
}

pause() {
    echo ""
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCIÓN: show_menu
# ============================================
show_menu() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}     ${BOLD}📋 GESTOR DE TAREAS v1.0${NC}          ${CYAN}║${NC}"
    echo -e "${CYAN}╠═══════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}  1. Agregar tarea                     ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  2. Listar tareas                     ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  3. Completar tarea                   ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  4. Eliminar tarea                    ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  5. Buscar tarea                      ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  6. Estadísticas                      ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  7. Exportar                          ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  q. Salir                             ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════╝${NC}"
    echo ""
}

# ============================================
# FUNCIÓN: add_task
# ============================================
add_task() {
    echo ""
    print_colored "$BLUE" "=== ➕ Agregar Nueva Tarea ==="
    echo ""
    
    # Solicitar descripción
    local descripcion=""
    while [[ -z "$descripcion" ]]; do
        read -p "Descripción de la tarea: " descripcion
        if [[ -z "$descripcion" ]]; then
            print_colored "$RED" "Error: La descripción no puede estar vacía"
        fi
    done
    
    # Solicitar prioridad
    local prioridad=""
    while true; do
        read -p "Prioridad (alta/media/baja): " prioridad
        case $prioridad in
            alta|media|baja)
                break
                ;;
            *)
                print_colored "$RED" "Error: Prioridad debe ser: alta, media o baja"
                ;;
        esac
    done
    
    # Agregar a los arrays
    TASK_IDS+=($NEXT_ID)
    TASK_DESCS+=("$descripcion")
    TASK_PRIORITIES+=("$prioridad")
    TASK_STATUSES+=("pendiente")
    TASK_DATES+=("$(get_current_date)")
    TASK_COMPLETED_DATES+=("")
    
    print_colored "$GREEN" "✓ Tarea #$NEXT_ID agregada exitosamente"
    
    ((NEXT_ID++))
    
    pause
}

# ============================================
# FUNCIÓN: list_tasks
# ============================================
list_tasks() {
    echo ""
    print_colored "$BLUE" "=== 📋 Listar Tareas ==="
    echo ""
    
    if [[ ${#TASK_IDS[@]} -eq 0 ]]; then
        print_colored "$YELLOW" "No hay tareas registradas"
        pause
        return
    fi
    
    echo "Filtrar por:"
    echo "  1. Todas"
    echo "  2. Pendientes"
    echo "  3. Completadas"
    read -p "Opción [1]: " filtro
    filtro="${filtro:-1}"
    
    echo ""
    echo "─────────────────────────────────────────────────────────────"
    printf "%-5s %-12s %-10s %-30s %s\n" "ID" "Estado" "Prioridad" "Descripción" "Fecha"
    echo "─────────────────────────────────────────────────────────────"
    
    local encontradas=0
    
    for i in "${!TASK_IDS[@]}"; do
        local mostrar=false
        
        case $filtro in
            1) mostrar=true ;;
            2) [[ "${TASK_STATUSES[$i]}" == "pendiente" ]] && mostrar=true ;;
            3) [[ "${TASK_STATUSES[$i]}" == "completada" ]] && mostrar=true ;;
            *) mostrar=true ;;
        esac
        
        if $mostrar; then
            local estado="${TASK_STATUSES[$i]}"
            local prioridad="${TASK_PRIORITIES[$i]}"
            local desc="${TASK_DESCS[$i]}"
            
            # Truncar descripción si es muy larga
            [[ ${#desc} -gt 28 ]] && desc="${desc:0:25}..."
            
            # Color según estado
            local estado_color=""
            if [[ "$estado" == "completada" ]]; then
                estado_color="${GREEN}✓ completada${NC}"
            else
                estado_color="${YELLOW}○ pendiente ${NC}"
            fi
            
            # Color según prioridad
            local prio_color=""
            case $prioridad in
                alta) prio_color="${RED}$prioridad${NC}" ;;
                media) prio_color="${YELLOW}$prioridad${NC}" ;;
                baja) prio_color="${GREEN}$prioridad${NC}" ;;
            esac
            
            printf "%-5s " "${TASK_IDS[$i]}"
            echo -en "$estado_color  "
            echo -en "$prio_color     "
            printf "%-30s %s\n" "$desc" "${TASK_DATES[$i]}"
            
            ((encontradas++))
        fi
    done
    
    echo "─────────────────────────────────────────────────────────────"
    echo "Total mostradas: $encontradas"
    
    pause
}

# ============================================
# FUNCIÓN: complete_task
# ============================================
complete_task() {
    echo ""
    print_colored "$BLUE" "=== ✓ Completar Tarea ==="
    echo ""
    
    # Mostrar pendientes
    local pendientes=0
    for i in "${!TASK_IDS[@]}"; do
        if [[ "${TASK_STATUSES[$i]}" == "pendiente" ]]; then
            echo "  [${TASK_IDS[$i]}] ${TASK_DESCS[$i]}"
            ((pendientes++))
        fi
    done
    
    if [[ $pendientes -eq 0 ]]; then
        print_colored "$YELLOW" "No hay tareas pendientes"
        pause
        return
    fi
    
    echo ""
    read -p "ID de la tarea a completar: " task_id
    
    # Buscar tarea
    local encontrada=false
    for i in "${!TASK_IDS[@]}"; do
        if [[ "${TASK_IDS[$i]}" == "$task_id" ]]; then
            encontrada=true
            if [[ "${TASK_STATUSES[$i]}" == "completada" ]]; then
                print_colored "$YELLOW" "La tarea ya está completada"
            else
                TASK_STATUSES[$i]="completada"
                TASK_COMPLETED_DATES[$i]="$(get_current_date)"
                print_colored "$GREEN" "✓ Tarea #$task_id marcada como completada"
            fi
            break
        fi
    done
    
    if ! $encontrada; then
        print_colored "$RED" "Error: No se encontró tarea con ID $task_id"
    fi
    
    pause
}

# ============================================
# FUNCIÓN: delete_task
# ============================================
delete_task() {
    echo ""
    print_colored "$BLUE" "=== 🗑️  Eliminar Tarea ==="
    echo ""
    
    if [[ ${#TASK_IDS[@]} -eq 0 ]]; then
        print_colored "$YELLOW" "No hay tareas para eliminar"
        pause
        return
    fi
    
    # Mostrar todas
    for i in "${!TASK_IDS[@]}"; do
        echo "  [${TASK_IDS[$i]}] ${TASK_DESCS[$i]} (${TASK_STATUSES[$i]})"
    done
    
    echo ""
    read -p "ID de la tarea a eliminar: " task_id
    
    # Buscar índice
    local indice=-1
    for i in "${!TASK_IDS[@]}"; do
        if [[ "${TASK_IDS[$i]}" == "$task_id" ]]; then
            indice=$i
            break
        fi
    done
    
    if [[ $indice -eq -1 ]]; then
        print_colored "$RED" "Error: No se encontró tarea con ID $task_id"
        pause
        return
    fi
    
    # Confirmar
    read -p "¿Eliminar tarea '${TASK_DESCS[$indice]}'? (s/n): " confirm
    if [[ "$confirm" == "s" || "$confirm" == "S" ]]; then
        # Eliminar de arrays
        unset 'TASK_IDS[indice]'
        unset 'TASK_DESCS[indice]'
        unset 'TASK_PRIORITIES[indice]'
        unset 'TASK_STATUSES[indice]'
        unset 'TASK_DATES[indice]'
        unset 'TASK_COMPLETED_DATES[indice]'
        
        # Re-indexar
        TASK_IDS=("${TASK_IDS[@]}")
        TASK_DESCS=("${TASK_DESCS[@]}")
        TASK_PRIORITIES=("${TASK_PRIORITIES[@]}")
        TASK_STATUSES=("${TASK_STATUSES[@]}")
        TASK_DATES=("${TASK_DATES[@]}")
        TASK_COMPLETED_DATES=("${TASK_COMPLETED_DATES[@]}")
        
        print_colored "$GREEN" "✓ Tarea eliminada"
    else
        echo "Eliminación cancelada"
    fi
    
    pause
}

# ============================================
# FUNCIÓN: search_task
# ============================================
search_task() {
    echo ""
    print_colored "$BLUE" "=== 🔍 Buscar Tarea ==="
    echo ""
    
    read -p "Texto a buscar: " busqueda
    
    if [[ -z "$busqueda" ]]; then
        print_colored "$RED" "Error: Debes ingresar un texto"
        pause
        return
    fi
    
    echo ""
    echo "Resultados para '$busqueda':"
    echo "────────────────────────────"
    
    local encontradas=0
    for i in "${!TASK_IDS[@]}"; do
        if [[ "${TASK_DESCS[$i]}" == *"$busqueda"* ]]; then
            echo "  [${TASK_IDS[$i]}] ${TASK_DESCS[$i]}"
            echo "       Prioridad: ${TASK_PRIORITIES[$i]} | Estado: ${TASK_STATUSES[$i]}"
            ((encontradas++))
        fi
    done
    
    echo "────────────────────────────"
    if [[ $encontradas -eq 0 ]]; then
        print_colored "$YELLOW" "No se encontraron coincidencias"
    else
        echo "Total: $encontradas coincidencia(s)"
    fi
    
    pause
}

# ============================================
# FUNCIÓN: show_stats
# ============================================
show_stats() {
    echo ""
    print_colored "$BLUE" "=== 📊 Estadísticas ==="
    echo ""
    
    local total=${#TASK_IDS[@]}
    local pendientes=0
    local completadas=0
    local alta=0
    local media=0
    local baja=0
    
    for i in "${!TASK_IDS[@]}"; do
        # Por estado
        if [[ "${TASK_STATUSES[$i]}" == "pendiente" ]]; then
            ((pendientes++))
        else
            ((completadas++))
        fi
        
        # Por prioridad
        case "${TASK_PRIORITIES[$i]}" in
            alta) ((alta++)) ;;
            media) ((media++)) ;;
            baja) ((baja++)) ;;
        esac
    done
    
    # Calcular tasa
    local tasa=0
    if [[ $total -gt 0 ]]; then
        tasa=$((completadas * 100 / total))
    fi
    
    echo "┌─────────────────────────────┐"
    echo "│ Total de tareas:    $total"
    echo "│"
    echo "│ Por estado:"
    echo -e "│   ${YELLOW}○ Pendientes:${NC}     $pendientes"
    echo -e "│   ${GREEN}✓ Completadas:${NC}    $completadas"
    echo "│"
    echo "│ Por prioridad:"
    echo -e "│   ${RED}● Alta:${NC}           $alta"
    echo -e "│   ${YELLOW}● Media:${NC}          $media"
    echo -e "│   ${GREEN}● Baja:${NC}           $baja"
    echo "│"
    echo "│ Tasa de completación: ${tasa}%"
    
    # Barra de progreso
    local bar=""
    local filled=$((tasa / 5))
    for ((j=0; j<20; j++)); do
        if [[ $j -lt $filled ]]; then
            bar+="█"
        else
            bar+="░"
        fi
    done
    echo "│ [$bar]"
    echo "└─────────────────────────────┘"
    
    pause
}

# ============================================
# FUNCIÓN: export_tasks
# ============================================
export_tasks() {
    echo ""
    print_colored "$BLUE" "=== 📤 Exportar Tareas ==="
    echo ""
    
    if [[ ${#TASK_IDS[@]} -eq 0 ]]; then
        print_colored "$YELLOW" "No hay tareas para exportar"
        pause
        return
    fi
    
    local filename="tareas_$(date +%Y%m%d_%H%M%S).txt"
    local filepath="${HOME}/$filename"
    
    {
        echo "╔═══════════════════════════════════════════════════════════╗"
        echo "║            REPORTE DE TAREAS - TASK MANAGER               ║"
        echo "╚═══════════════════════════════════════════════════════════╝"
        echo ""
        echo "Fecha de exportación: $(get_current_date)"
        echo "Total de tareas: ${#TASK_IDS[@]}"
        echo ""
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        
        for i in "${!TASK_IDS[@]}"; do
            echo "Tarea #${TASK_IDS[$i]}"
            echo "  Descripción: ${TASK_DESCS[$i]}"
            echo "  Prioridad:   ${TASK_PRIORITIES[$i]}"
            echo "  Estado:      ${TASK_STATUSES[$i]}"
            echo "  Creada:      ${TASK_DATES[$i]}"
            if [[ -n "${TASK_COMPLETED_DATES[$i]}" ]]; then
                echo "  Completada:  ${TASK_COMPLETED_DATES[$i]}"
            fi
            echo ""
        done
        
        echo "═══════════════════════════════════════════════════════════"
        echo "Fin del reporte"
    } > "$filepath"
    
    print_colored "$GREEN" "✓ Tareas exportadas a:"
    echo "  $filepath"
    
    pause
}

# ============================================
# FUNCIÓN: save_data
# ============================================
save_data() {
    {
        echo "NEXT_ID=$NEXT_ID"
        for i in "${!TASK_IDS[@]}"; do
            echo "${TASK_IDS[$i]}|${TASK_DESCS[$i]}|${TASK_PRIORITIES[$i]}|${TASK_STATUSES[$i]}|${TASK_DATES[$i]}|${TASK_COMPLETED_DATES[$i]}"
        done
    } > "$DATA_FILE"
}

# ============================================
# FUNCIÓN: load_data
# ============================================
load_data() {
    if [[ -f "$DATA_FILE" ]]; then
        local first_line=true
        while IFS= read -r line; do
            if $first_line; then
                # Primera línea: NEXT_ID
                NEXT_ID="${line#NEXT_ID=}"
                first_line=false
            else
                # Resto: datos de tareas
                IFS='|' read -r id desc prio status date completed <<< "$line"
                TASK_IDS+=($id)
                TASK_DESCS+=("$desc")
                TASK_PRIORITIES+=("$prio")
                TASK_STATUSES+=("$status")
                TASK_DATES+=("$date")
                TASK_COMPLETED_DATES+=("$completed")
            fi
        done < "$DATA_FILE"
    fi
}

# ============================================
# PROGRAMA PRINCIPAL
# ============================================

# Cargar datos existentes
load_data

# Bucle principal
while true; do
    show_menu
    read -p "Selecciona una opción: " choice
    
    case $choice in
        1) add_task ;;
        2) list_tasks ;;
        3) complete_task ;;
        4) delete_task ;;
        5) search_task ;;
        6) show_stats ;;
        7) export_tasks ;;
        q|Q)
            save_data
            echo ""
            print_colored "$GREEN" "¡Hasta luego! Tus tareas han sido guardadas."
            echo ""
            exit 0
            ;;
        *)
            print_colored "$RED" "Opción no válida"
            sleep 1
            ;;
    esac
done
