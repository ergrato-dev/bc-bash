#!/bin/bash
# ============================================
# GESTOR DE INVENTARIO - SOLUCION COMPLETA
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
    local new_id
    new_id=$(printf "P%03d" "$NEXT_ID")
    ((NEXT_ID++))
    echo "$new_id"
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
    if [[ "$value" =~ ^[0-9]+\.?[0-9]*$ ]]; then
        return 0
    fi
    return 1
}

# ============================================
# FUNCION: is_positive
# Valida si un valor es positivo
# Parametros:
#   $1 - Valor a validar
# Retorna: 0 si es positivo, 1 si no
# ============================================
is_positive() {
    local value="$1"
    if is_numeric "$value"; then
        if (( $(echo "$value > 0" | bc -l) )); then
            return 0
        fi
    fi
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
    local i
    
    for i in "${!PRODUCTOS_ID[@]}"; do
        if [[ "${PRODUCTOS_ID[$i]}" == "$search_id" ]]; then
            echo "$i"
            return 0
        fi
    done
    
    echo "-1"
    return 1
}

# ============================================
# FUNCION: add_product
# Agrega un nuevo producto al inventario
# ============================================
add_product() {
    local nombre precio cantidad categoria new_id
    
    show_header
    echo -e "${GREEN}AGREGAR PRODUCTO${NC}"
    echo "-----------------------------"
    echo ""
    
    # Solicitar nombre
    while true; do
        read -p "Nombre del producto: " nombre
        if [[ -n "$nombre" ]]; then
            break
        fi
        echo -e "${RED}Error: El nombre no puede estar vacio${NC}"
    done
    
    # Solicitar precio
    while true; do
        read -p "Precio: " precio
        if is_positive "$precio"; then
            break
        fi
        echo -e "${RED}Error: Ingresa un precio numerico positivo${NC}"
    done
    
    # Solicitar cantidad
    while true; do
        read -p "Cantidad: " cantidad
        if [[ "$cantidad" =~ ^[0-9]+$ ]] && [[ "$cantidad" -gt 0 ]]; then
            break
        fi
        echo -e "${RED}Error: Ingresa una cantidad entera positiva${NC}"
    done
    
    # Solicitar categoria
    while true; do
        read -p "Categoria: " categoria
        if [[ -n "$categoria" ]]; then
            break
        fi
        echo -e "${RED}Error: La categoria no puede estar vacia${NC}"
    done
    
    # Generar ID y agregar a arrays
    new_id=$(generate_id)
    PRODUCTOS_ID+=("$new_id")
    PRODUCTOS_NOMBRE+=("$nombre")
    PRODUCTOS_PRECIO+=("$precio")
    PRODUCTOS_CANTIDAD+=("$cantidad")
    PRODUCTOS_CATEGORIA+=("$categoria")
    
    echo ""
    echo -e "${GREEN}Producto agregado exitosamente!${NC}"
    echo "ID asignado: $new_id"
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: list_products
# Lista todos los productos en formato tabla
# ============================================
list_products() {
    local i total_value product_value
    
    show_header
    echo -e "${BLUE}LISTADO DE PRODUCTOS${NC}"
    echo "-----------------------------"
    echo ""
    
    if [[ ${#PRODUCTOS_ID[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No hay productos en el inventario${NC}"
    else
        # Encabezado de tabla
        printf "%-6s | %-20s | %-10s | %-8s | %-15s\n" \
            "ID" "NOMBRE" "PRECIO" "CANT" "CATEGORIA"
        printf "%s\n" "----------------------------------------------------------------------"
        
        total_value=0
        for i in "${!PRODUCTOS_ID[@]}"; do
            printf "%-6s | %-20s | %-10s | %-8s | %-15s\n" \
                "${PRODUCTOS_ID[$i]}" \
                "${PRODUCTOS_NOMBRE[$i]:0:20}" \
                "\$${PRODUCTOS_PRECIO[$i]}" \
                "${PRODUCTOS_CANTIDAD[$i]}" \
                "${PRODUCTOS_CATEGORIA[$i]:0:15}"
            
            product_value=$(echo "${PRODUCTOS_PRECIO[$i]} * ${PRODUCTOS_CANTIDAD[$i]}" | bc)
            total_value=$(echo "$total_value + $product_value" | bc)
        done
        
        printf "%s\n" "----------------------------------------------------------------------"
        echo ""
        echo -e "Total productos: ${GREEN}${#PRODUCTOS_ID[@]}${NC}"
        echo -e "Valor total inventario: ${GREEN}\$${total_value}${NC}"
    fi
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: search_product
# Busca productos por nombre o categoria
# ============================================
search_product() {
    local search_option search_term found i
    
    show_header
    echo -e "${CYAN}BUSCAR PRODUCTO${NC}"
    echo "-----------------------------"
    echo ""
    
    if [[ ${#PRODUCTOS_ID[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No hay productos en el inventario${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    echo "Buscar por:"
    echo "  1) Nombre"
    echo "  2) Categoria"
    echo ""
    read -p "Selecciona opcion: " search_option
    
    case $search_option in
        1)
            read -p "Ingresa nombre a buscar: " search_term
            ;;
        2)
            read -p "Ingresa categoria a buscar: " search_term
            ;;
        *)
            echo -e "${RED}Opcion no valida${NC}"
            sleep 1
            return
            ;;
    esac
    
    echo ""
    echo "Resultados encontrados:"
    printf "%s\n" "----------------------------------------------------------------------"
    
    found=0
    for i in "${!PRODUCTOS_ID[@]}"; do
        local match=false
        
        if [[ "$search_option" == "1" ]]; then
            # Buscar por nombre (insensible a mayusculas)
            if [[ "${PRODUCTOS_NOMBRE[$i],,}" == *"${search_term,,}"* ]]; then
                match=true
            fi
        else
            # Buscar por categoria
            if [[ "${PRODUCTOS_CATEGORIA[$i],,}" == *"${search_term,,}"* ]]; then
                match=true
            fi
        fi
        
        if [[ "$match" == true ]]; then
            printf "ID: %-6s | Nombre: %-20s | Precio: \$%-8s | Cant: %-5s | Cat: %s\n" \
                "${PRODUCTOS_ID[$i]}" \
                "${PRODUCTOS_NOMBRE[$i]}" \
                "${PRODUCTOS_PRECIO[$i]}" \
                "${PRODUCTOS_CANTIDAD[$i]}" \
                "${PRODUCTOS_CATEGORIA[$i]}"
            ((found++))
        fi
    done
    
    printf "%s\n" "----------------------------------------------------------------------"
    
    if [[ $found -eq 0 ]]; then
        echo -e "${YELLOW}No se encontraron productos${NC}"
    else
        echo -e "${GREEN}Se encontraron $found producto(s)${NC}"
    fi
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: update_stock
# Actualiza la cantidad de un producto
# ============================================
update_stock() {
    local product_id idx operation amount new_quantity
    
    show_header
    echo -e "${YELLOW}ACTUALIZAR STOCK${NC}"
    echo "-----------------------------"
    echo ""
    
    if [[ ${#PRODUCTOS_ID[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No hay productos en el inventario${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    read -p "Ingresa ID del producto: " product_id
    idx=$(find_product_index "$product_id")
    
    if [[ "$idx" == "-1" ]]; then
        echo -e "${RED}Producto no encontrado${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    echo ""
    echo "Producto encontrado:"
    echo "  Nombre: ${PRODUCTOS_NOMBRE[$idx]}"
    echo "  Stock actual: ${PRODUCTOS_CANTIDAD[$idx]}"
    echo ""
    
    echo "Que deseas hacer?"
    echo "  1) Aumentar stock"
    echo "  2) Disminuir stock"
    read -p "Selecciona opcion: " operation
    
    read -p "Cantidad a modificar: " amount
    
    if ! [[ "$amount" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Cantidad debe ser un numero entero${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    if [[ "$operation" == "1" ]]; then
        new_quantity=$((PRODUCTOS_CANTIDAD[$idx] + amount))
    elif [[ "$operation" == "2" ]]; then
        new_quantity=$((PRODUCTOS_CANTIDAD[$idx] - amount))
        if [[ $new_quantity -lt 0 ]]; then
            echo -e "${RED}Error: El stock no puede ser negativo${NC}"
            read -p "Presiona Enter para continuar..."
            return
        fi
    else
        echo -e "${RED}Opcion no valida${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    PRODUCTOS_CANTIDAD[$idx]=$new_quantity
    
    echo ""
    echo -e "${GREEN}Stock actualizado exitosamente!${NC}"
    echo "Nuevo stock: $new_quantity"
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: delete_product
# Elimina un producto del inventario
# ============================================
delete_product() {
    local product_id idx confirm
    
    show_header
    echo -e "${RED}ELIMINAR PRODUCTO${NC}"
    echo "-----------------------------"
    echo ""
    
    if [[ ${#PRODUCTOS_ID[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No hay productos en el inventario${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    read -p "Ingresa ID del producto a eliminar: " product_id
    idx=$(find_product_index "$product_id")
    
    if [[ "$idx" == "-1" ]]; then
        echo -e "${RED}Producto no encontrado${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    echo ""
    echo "Producto a eliminar:"
    echo "  ID: ${PRODUCTOS_ID[$idx]}"
    echo "  Nombre: ${PRODUCTOS_NOMBRE[$idx]}"
    echo "  Precio: \$${PRODUCTOS_PRECIO[$idx]}"
    echo "  Cantidad: ${PRODUCTOS_CANTIDAD[$idx]}"
    echo "  Categoria: ${PRODUCTOS_CATEGORIA[$idx]}"
    echo ""
    
    read -p "Estas seguro de eliminar este producto? (s/n): " confirm
    
    if [[ "${confirm,,}" == "s" ]]; then
        # Eliminar de todos los arrays
        unset 'PRODUCTOS_ID[idx]'
        unset 'PRODUCTOS_NOMBRE[idx]'
        unset 'PRODUCTOS_PRECIO[idx]'
        unset 'PRODUCTOS_CANTIDAD[idx]'
        unset 'PRODUCTOS_CATEGORIA[idx]'
        
        # Reindexar arrays
        PRODUCTOS_ID=("${PRODUCTOS_ID[@]}")
        PRODUCTOS_NOMBRE=("${PRODUCTOS_NOMBRE[@]}")
        PRODUCTOS_PRECIO=("${PRODUCTOS_PRECIO[@]}")
        PRODUCTOS_CANTIDAD=("${PRODUCTOS_CANTIDAD[@]}")
        PRODUCTOS_CATEGORIA=("${PRODUCTOS_CATEGORIA[@]}")
        
        echo ""
        echo -e "${GREEN}Producto eliminado exitosamente!${NC}"
    else
        echo ""
        echo -e "${YELLOW}Operacion cancelada${NC}"
    fi
    
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: show_statistics
# Muestra estadisticas del inventario
# ============================================
show_statistics() {
    local i total_products total_value
    local max_price max_price_name max_stock max_stock_name
    local product_value
    declare -A categories
    
    show_header
    echo -e "${CYAN}ESTADISTICAS${NC}"
    echo "-----------------------------"
    echo ""
    
    if [[ ${#PRODUCTOS_ID[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No hay productos para mostrar estadisticas${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    total_products=${#PRODUCTOS_ID[@]}
    total_value=0
    max_price=0
    max_price_name=""
    max_stock=0
    max_stock_name=""
    
    for i in "${!PRODUCTOS_ID[@]}"; do
        # Valor total
        product_value=$(echo "${PRODUCTOS_PRECIO[$i]} * ${PRODUCTOS_CANTIDAD[$i]}" | bc)
        total_value=$(echo "$total_value + $product_value" | bc)
        
        # Producto mas caro
        if (( $(echo "${PRODUCTOS_PRECIO[$i]} > $max_price" | bc -l) )); then
            max_price="${PRODUCTOS_PRECIO[$i]}"
            max_price_name="${PRODUCTOS_NOMBRE[$i]}"
        fi
        
        # Producto con mas stock
        if [[ "${PRODUCTOS_CANTIDAD[$i]}" -gt "$max_stock" ]]; then
            max_stock="${PRODUCTOS_CANTIDAD[$i]}"
            max_stock_name="${PRODUCTOS_NOMBRE[$i]}"
        fi
        
        # Contar por categoria
        local cat="${PRODUCTOS_CATEGORIA[$i]}"
        if [[ -v "categories[$cat]" ]]; then
            ((categories[$cat]++))
        else
            categories[$cat]=1
        fi
    done
    
    echo "RESUMEN GENERAL"
    echo "-----------------------------"
    echo "Total de productos: $total_products"
    echo "Valor total inventario: \$$total_value"
    echo ""
    
    echo "DESTACADOS"
    echo "-----------------------------"
    echo "Producto mas caro: $max_price_name (\$$max_price)"
    echo "Mayor stock: $max_stock_name ($max_stock unidades)"
    echo ""
    
    echo "PRODUCTOS POR CATEGORIA"
    echo "-----------------------------"
    for cat in "${!categories[@]}"; do
        echo "  $cat: ${categories[$cat]} producto(s)"
    done
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: export_csv
# Exporta el inventario a archivo CSV
# ============================================
export_csv() {
    local i
    
    show_header
    echo -e "${GREEN}EXPORTAR A CSV${NC}"
    echo "-----------------------------"
    echo ""
    
    if [[ ${#PRODUCTOS_ID[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No hay productos para exportar${NC}"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    # Crear archivo con encabezados
    echo "ID,Nombre,Precio,Cantidad,Categoria" > "$EXPORT_FILE"
    
    # Agregar datos
    for i in "${!PRODUCTOS_ID[@]}"; do
        echo "${PRODUCTOS_ID[$i]},${PRODUCTOS_NOMBRE[$i]},${PRODUCTOS_PRECIO[$i]},${PRODUCTOS_CANTIDAD[$i]},${PRODUCTOS_CATEGORIA[$i]}" >> "$EXPORT_FILE"
    done
    
    echo -e "${GREEN}Datos exportados exitosamente!${NC}"
    echo "Archivo: $(pwd)/$EXPORT_FILE"
    echo ""
    echo "Vista previa:"
    echo "-----------------------------"
    head -6 "$EXPORT_FILE"
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

# ============================================
# FUNCION: load_sample_data
# Carga datos de ejemplo para pruebas
# ============================================
load_sample_data() {
    # Limpiar datos existentes
    PRODUCTOS_ID=()
    PRODUCTOS_NOMBRE=()
    PRODUCTOS_PRECIO=()
    PRODUCTOS_CANTIDAD=()
    PRODUCTOS_CATEGORIA=()
    NEXT_ID=1
    
    # Datos de ejemplo
    local nombres=("Laptop HP" "Mouse Logitech" "Teclado Mecanico" "Monitor 24" "Webcam HD" "Audifonos BT" "USB Hub" "SSD 500GB")
    local precios=(899.99 29.99 79.99 249.99 59.99 49.99 19.99 69.99)
    local cantidades=(15 50 30 20 25 40 100 35)
    local categorias=("Computadoras" "Accesorios" "Accesorios" "Monitores" "Accesorios" "Audio" "Accesorios" "Almacenamiento")
    
    local i
    for i in "${!nombres[@]}"; do
        local new_id
        new_id=$(generate_id)
        PRODUCTOS_ID+=("$new_id")
        PRODUCTOS_NOMBRE+=("${nombres[$i]}")
        PRODUCTOS_PRECIO+=("${precios[$i]}")
        PRODUCTOS_CANTIDAD+=("${cantidades[$i]}")
        PRODUCTOS_CATEGORIA+=("${categorias[$i]}")
    done
    
    echo -e "${GREEN}Datos de ejemplo cargados (${#PRODUCTOS_ID[@]} productos)${NC}"
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
