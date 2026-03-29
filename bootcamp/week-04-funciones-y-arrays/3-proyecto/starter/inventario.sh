#!/bin/bash
# ============================================
# GESTOR DE INVENTARIO
# Proyecto Semana 4: Funciones y Arrays
# ============================================

set -euo pipefail

# ============================================
# CONFIGURACION
# ============================================
readonly VERSION="1.0.0"
readonly EXPORT_FILE="inventario_export.csv"

# ============================================
# COLORES PARA TERMINAL
# ============================================
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# ============================================
# ARRAYS DE DATOS (Arrays Paralelos)
# ============================================
declare -a PRODUCTOS_ID=()
declare -a PRODUCTOS_NOMBRE=()
declare -a PRODUCTOS_PRECIO=()
declare -a PRODUCTOS_CANTIDAD=()
declare -a PRODUCTOS_CATEGORIA=()

# Contador para generar IDs unicos
NEXT_ID=1

# ============================================
# FUNCION: show_header
# Muestra el encabezado del programa
# ============================================
show_header() {
    clear
    echo -e "${CYAN}"
    echo "========================================"
    echo "       GESTOR DE INVENTARIO            "
    echo "           Version ${VERSION}              "
    echo "========================================"
    echo -e "${NC}"
}

# ============================================
# FUNCION: generate_id
# Genera un ID unico para cada producto
# Retorna: ID como string (ej: "P001")
# ============================================
generate_id() {
    # TODO: Implementar generacion de ID unico
    # Usar NEXT_ID y formatearlo como "P001", "P002", etc.
    # Incrementar NEXT_ID despues de generar
    # Usar printf para formatear con ceros
    echo ""
}

# ============================================
# FUNCION: is_numeric
# Valida si un valor es numerico
# Parametros:
#   $1 - Valor a validar
# Retorna: 0 si es numerico, 1 si no
# ============================================
is_numeric() {
    local value="$1"
    # TODO: Implementar validacion numerica
    # Usar regex para verificar si es numero (entero o decimal)
    return 1
}

# ============================================
# FUNCION: find_product_index
# Busca el indice de un producto por ID
# Parametros:
#   $1 - ID del producto
# Retorna: indice o -1 si no existe
# ============================================
find_product_index() {
    local search_id="$1"
    # TODO: Implementar busqueda por ID
    # Recorrer PRODUCTOS_ID buscando coincidencia
    # Imprimir el indice si se encuentra, -1 si no
    echo "-1"
}

# ============================================
# FUNCION: add_product
# Agrega un nuevo producto al inventario
# ============================================
add_product() {
    show_header
    echo -e "${GREEN}AGREGAR PRODUCTO${NC}"
    echo "-----------------------------"
    echo ""
    
    # TODO: Implementar agregar producto
    # 1. Solicitar nombre (no vacio)
    # 2. Solicitar precio (numerico, positivo)
    # 3. Solicitar cantidad (numerico, entero positivo)
    # 4. Solicitar categoria (no vacia)
    # 5. Generar ID con generate_id
    # 6. Agregar a todos los arrays
    # 7. Mostrar mensaje de confirmacion
    
    echo -e "${YELLOW}Funcion por implementar${NC}"
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: list_products
# Lista todos los productos en formato tabla
# ============================================
list_products() {
    show_header
    echo -e "${BLUE}LISTADO DE PRODUCTOS${NC}"
    echo "-----------------------------"
    echo ""
    
    # TODO: Implementar listado de productos
    # 1. Verificar si hay productos
    # 2. Mostrar encabezado de tabla con printf
    # 3. Recorrer arrays y mostrar cada producto
    # 4. Calcular y mostrar valor total del inventario
    
    if [[ ${#PRODUCTOS_ID[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No hay productos en el inventario${NC}"
    else
        echo -e "${YELLOW}Funcion por implementar${NC}"
    fi
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: search_product
# Busca productos por nombre o categoria
# ============================================
search_product() {
    show_header
    echo -e "${CYAN}BUSCAR PRODUCTO${NC}"
    echo "-----------------------------"
    echo ""
    
    # TODO: Implementar busqueda de productos
    # 1. Mostrar menu: buscar por nombre o categoria
    # 2. Solicitar termino de busqueda
    # 3. Buscar coincidencias (insensible a mayusculas)
    # 4. Mostrar resultados encontrados
    
    echo -e "${YELLOW}Funcion por implementar${NC}"
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: update_stock
# Actualiza la cantidad de un producto
# ============================================
update_stock() {
    show_header
    echo -e "${YELLOW}ACTUALIZAR STOCK${NC}"
    echo "-----------------------------"
    echo ""
    
    # TODO: Implementar actualizacion de stock
    # 1. Solicitar ID del producto
    # 2. Buscar producto con find_product_index
    # 3. Mostrar informacion actual
    # 4. Preguntar si aumentar o disminuir
    # 5. Solicitar cantidad a modificar
    # 6. Validar que no quede negativo
    # 7. Actualizar array y confirmar
    
    echo -e "${YELLOW}Funcion por implementar${NC}"
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: delete_product
# Elimina un producto del inventario
# ============================================
delete_product() {
    show_header
    echo -e "${RED}ELIMINAR PRODUCTO${NC}"
    echo "-----------------------------"
    echo ""
    
    # TODO: Implementar eliminacion de producto
    # 1. Solicitar ID del producto
    # 2. Buscar producto con find_product_index
    # 3. Mostrar informacion del producto
    # 4. Pedir confirmacion
    # 5. Eliminar de todos los arrays (usar unset y reindexar)
    # 6. Confirmar eliminacion
    
    echo -e "${YELLOW}Funcion por implementar${NC}"
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: show_statistics
# Muestra estadisticas del inventario
# ============================================
show_statistics() {
    show_header
    echo -e "${CYAN}ESTADISTICAS${NC}"
    echo "-----------------------------"
    echo ""
    
    # TODO: Implementar estadisticas
    # 1. Total de productos
    # 2. Valor total del inventario (sum precio*cantidad)
    # 3. Producto mas caro
    # 4. Producto con mayor stock
    # 5. Productos por categoria (usar array asociativo temporal)
    
    if [[ ${#PRODUCTOS_ID[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No hay productos para mostrar estadisticas${NC}"
    else
        echo -e "${YELLOW}Funcion por implementar${NC}"
    fi
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: export_csv
# Exporta el inventario a archivo CSV
# ============================================
export_csv() {
    show_header
    echo -e "${GREEN}EXPORTAR A CSV${NC}"
    echo "-----------------------------"
    echo ""
    
    # TODO: Implementar exportacion CSV
    # 1. Verificar que hay productos
    # 2. Crear archivo con encabezados
    # 3. Recorrer arrays y escribir lineas
    # 4. Mostrar ruta del archivo exportado
    
    if [[ ${#PRODUCTOS_ID[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No hay productos para exportar${NC}"
    else
        echo -e "${YELLOW}Funcion por implementar${NC}"
    fi
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: load_sample_data
# Carga datos de ejemplo para pruebas
# ============================================
load_sample_data() {
    # TODO: Implementar carga de datos de ejemplo
    # Agregar 5-10 productos de prueba a los arrays
    # Util para probar las funciones
    
    echo -e "${GREEN}Datos de ejemplo cargados${NC}"
    sleep 1
}

# ============================================
# FUNCION: main_menu
# Muestra el menu principal
# ============================================
main_menu() {
    while true; do
        show_header
        
        echo "Productos en inventario: ${#PRODUCTOS_ID[@]}"
        echo ""
        echo "-----------------------------"
        echo "  1) Agregar producto"
        echo "  2) Listar productos"
        echo "  3) Buscar producto"
        echo "  4) Actualizar stock"
        echo "  5) Eliminar producto"
        echo "  6) Estadisticas"
        echo "  7) Exportar a CSV"
        echo "  8) Cargar datos ejemplo"
        echo "  0) Salir"
        echo "-----------------------------"
        echo ""
        
        read -p "Selecciona una opcion: " option
        
        case $option in
            1) add_product ;;
            2) list_products ;;
            3) search_product ;;
            4) update_stock ;;
            5) delete_product ;;
            6) show_statistics ;;
            7) export_csv ;;
            8) load_sample_data ;;
            0)
                echo -e "${GREEN}Hasta luego!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Opcion no valida${NC}"
                sleep 1
                ;;
        esac
    done
}

# ============================================
# PUNTO DE ENTRADA
# ============================================
main_menu
