#!/bin/bash
# ============================================
# Proyecto Semana 3: Gestor de Tareas CLI
# ============================================
# Este proyecto integra todos los conceptos:
# - Variables y arrays
# - Condicionales if/elif/else
# - Bucles for y while
# - Estructura case
# - Funciones
# ============================================

# ============================================
# CONFIGURACIÓN
# ============================================

# Archivo de datos
DATA_FILE="${HOME}/.task_manager_data"

# Arrays para almacenar tareas
declare -a TASK_IDS=()
declare -a TASK_DESCS=()
declare -a TASK_PRIORITIES=()
declare -a TASK_STATUSES=()
declare -a TASK_DATES=()

# Contador de ID
NEXT_ID=1

# Colores (opcional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# ============================================
# FUNCIÓN: show_menu
# Muestra el menú principal
# ============================================
show_menu() {
    clear
    echo "╔═══════════════════════════════════════╗"
    echo "║     📋 GESTOR DE TAREAS v1.0          ║"
    echo "╠═══════════════════════════════════════╣"
    echo "║  1. Agregar tarea                     ║"
    echo "║  2. Listar tareas                     ║"
    echo "║  3. Completar tarea                   ║"
    echo "║  4. Eliminar tarea                    ║"
    echo "║  5. Buscar tarea                      ║"
    echo "║  6. Estadísticas                      ║"
    echo "║  7. Exportar                          ║"
    echo "║  q. Salir                             ║"
    echo "╚═══════════════════════════════════════╝"
    echo ""
}

# ============================================
# FUNCIÓN: get_current_date
# Retorna la fecha actual formateada
# ============================================
get_current_date() {
    # TODO: Implementar
    # Retornar fecha en formato: YYYY-MM-DD HH:MM
    echo ""
}

# ============================================
# FUNCIÓN: add_task
# Agrega una nueva tarea al sistema
# ============================================
add_task() {
    echo ""
    echo "=== Agregar Nueva Tarea ==="
    echo ""
    
    # TODO: Implementar
    # 1. Solicitar descripción (read -p)
    # 2. Validar que no esté vacía
    # 3. Solicitar prioridad (alta/media/baja)
    # 4. Validar prioridad válida
    # 5. Agregar a los arrays:
    #    - TASK_IDS+=($NEXT_ID)
    #    - TASK_DESCS+=("$descripcion")
    #    - TASK_PRIORITIES+=("$prioridad")
    #    - TASK_STATUSES+=("pendiente")
    #    - TASK_DATES+=($(get_current_date))
    # 6. Incrementar NEXT_ID
    # 7. Mostrar confirmación
    
    echo "TODO: Implementar add_task"
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCIÓN: list_tasks
# Muestra las tareas según filtro
# ============================================
list_tasks() {
    echo ""
    echo "=== Listar Tareas ==="
    echo ""
    
    # TODO: Implementar
    # 1. Preguntar filtro: todas/pendientes/completadas
    # 2. Usar case para procesar la opción
    # 3. Iterar sobre los arrays con for
    # 4. Aplicar filtro según selección
    # 5. Mostrar cada tarea con formato:
    #    [ID] [Estado] [Prioridad] Descripción (Fecha)
    # 6. Manejar caso de lista vacía
    
    echo "TODO: Implementar list_tasks"
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCIÓN: complete_task
# Marca una tarea como completada
# ============================================
complete_task() {
    echo ""
    echo "=== Completar Tarea ==="
    echo ""
    
    # TODO: Implementar
    # 1. Mostrar tareas pendientes
    # 2. Solicitar ID de la tarea
    # 3. Buscar el índice en TASK_IDS usando for
    # 4. Verificar que exista
    # 5. Verificar que no esté ya completada
    # 6. Cambiar TASK_STATUSES[indice]="completada"
    # 7. Mostrar confirmación
    
    echo "TODO: Implementar complete_task"
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCIÓN: delete_task
# Elimina una tarea del sistema
# ============================================
delete_task() {
    echo ""
    echo "=== Eliminar Tarea ==="
    echo ""
    
    # TODO: Implementar
    # 1. Mostrar todas las tareas
    # 2. Solicitar ID de la tarea
    # 3. Buscar el índice
    # 4. Confirmar eliminación (s/n)
    # 5. Eliminar de todos los arrays usando unset
    # 6. Re-indexar arrays (opcional)
    # 7. Mostrar confirmación
    
    echo "TODO: Implementar delete_task"
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCIÓN: search_task
# Busca tareas por texto
# ============================================
search_task() {
    echo ""
    echo "=== Buscar Tarea ==="
    echo ""
    
    # TODO: Implementar
    # 1. Solicitar texto a buscar
    # 2. Iterar sobre TASK_DESCS con for
    # 3. Usar [[ "$desc" == *"$busqueda"* ]] para coincidencias
    # 4. Mostrar tareas que coincidan
    # 5. Mostrar mensaje si no hay coincidencias
    
    echo "TODO: Implementar search_task"
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCIÓN: show_stats
# Muestra estadísticas del sistema
# ============================================
show_stats() {
    echo ""
    echo "=== Estadísticas ==="
    echo ""
    
    # TODO: Implementar
    # 1. Calcular total de tareas: ${#TASK_IDS[@]}
    # 2. Contar pendientes usando for y condicional
    # 3. Contar completadas
    # 4. Contar por prioridad (alta, media, baja)
    # 5. Calcular tasa de completación
    # 6. Mostrar con formato
    
    echo "TODO: Implementar show_stats"
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCIÓN: export_tasks
# Exporta las tareas a un archivo
# ============================================
export_tasks() {
    echo ""
    echo "=== Exportar Tareas ==="
    echo ""
    
    # TODO: Implementar
    # 1. Definir nombre de archivo con fecha
    # 2. Crear encabezado del archivo
    # 3. Iterar sobre tareas y escribir al archivo
    # 4. Usar redirección > y >>
    # 5. Mostrar ruta del archivo creado
    
    echo "TODO: Implementar export_tasks"
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCIÓN: save_data
# Guarda los datos en archivo (EXTRA)
# ============================================
save_data() {
    # TODO (EXTRA): Implementar persistencia
    # Guardar arrays en $DATA_FILE
    :
}

# ============================================
# FUNCIÓN: load_data
# Carga los datos desde archivo (EXTRA)
# ============================================
load_data() {
    # TODO (EXTRA): Implementar carga de datos
    # Leer $DATA_FILE y poblar arrays
    :
}

# ============================================
# PROGRAMA PRINCIPAL
# ============================================

# Cargar datos existentes (si implementaste persistencia)
# load_data

# Bucle principal del menú
# TODO: Implementar el bucle principal
# while true; do
#     show_menu
#     read -p "Selecciona una opción: " choice
#     
#     case $choice in
#         1) add_task ;;
#         2) list_tasks ;;
#         3) complete_task ;;
#         4) delete_task ;;
#         5) search_task ;;
#         6) show_stats ;;
#         7) export_tasks ;;
#         q|Q)
#             echo "¡Hasta luego!"
#             # save_data  # Si implementaste persistencia
#             exit 0
#             ;;
#         *)
#             echo "Opción no válida"
#             sleep 1
#             ;;
#     esac
# done

# Mientras desarrollas, muestra el menú una vez
show_menu
echo "El bucle principal está comentado."
echo "Descomenta la sección 'PROGRAMA PRINCIPAL' cuando"
echo "hayas implementado las funciones."
