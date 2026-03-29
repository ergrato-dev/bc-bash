# 🔧 Práctica 05: Integración - Mini Proyecto

> **Dificultad**: ⭐⭐⭐ Avanzada | **Tiempo estimado**: 35-40 minutos

## 🎯 Objetivos

Esta práctica integra todos los conceptos de la semana:

- ✅ Variables y expansión de parámetros
- ✅ Condicionales `if/elif/else`
- ✅ Bucles `for`, `while`
- ✅ Estructura `case`
- ✅ Validación de entrada
- ✅ Manejo de archivos

## 📚 Proyecto: Analizador de Logs

Construirás un script que analiza archivos de log, extrae información y genera reportes. Este tipo de herramienta es común en administración de sistemas.

### Funcionalidades

1. **Menú interactivo** con opciones
2. **Análisis de archivos** (contar líneas, palabras, errores)
3. **Filtrado por patrones** (buscar errores, warnings)
4. **Generación de reportes**
5. **Validación de entrada**

---

## 📋 Instrucciones

**Abre** [starter/script.sh](starter/script.sh) y sigue los pasos descomentando el código indicado.

```bash
cd starter
chmod +x script.sh
./script.sh
```

El script creará un archivo de log de prueba automáticamente.

---

## Paso 1: Configuración Inicial

Define variables y crea el archivo de prueba:

```bash
LOG_FILE="/tmp/app.log"
REPORT_DIR="/tmp/reports"

# Crear directorio si no existe
[[ -d "$REPORT_DIR" ]] || mkdir -p "$REPORT_DIR"
```

**Descomenta** la sección del Paso 1.

---

## Paso 2: Generar Archivo de Log

Crea un archivo de log con diferentes tipos de mensajes:

```bash
cat > "$LOG_FILE" << 'EOF'
2024-01-15 10:30:15 INFO Starting application
2024-01-15 10:30:16 DEBUG Loading configuration
2024-01-15 10:30:17 ERROR Failed to connect to database
...
EOF
```

**Descomenta** la sección del Paso 2.

---

## Paso 3: Función para Mostrar Menú

Crea una función que muestre las opciones:

```bash
show_menu() {
    echo "=== Analizador de Logs ==="
    echo "1. Estadísticas generales"
    echo "2. Buscar errores"
    echo "3. Buscar por fecha"
    echo "4. Generar reporte"
    echo "5. Salir"
}
```

**Descomenta** la sección del Paso 3.

---

## Paso 4: Función de Estadísticas

Analiza el archivo y muestra estadísticas:

```bash
show_stats() {
    local total_lines=$(wc -l < "$LOG_FILE")
    local errors=$(grep -c "ERROR" "$LOG_FILE")
    local warnings=$(grep -c "WARNING" "$LOG_FILE")

    echo "Total líneas: $total_lines"
    echo "Errores: $errors"
    echo "Warnings: $warnings"
}
```

**Descomenta** la sección del Paso 4.

---

## Paso 5: Buscar Errores

Implementa la búsqueda de errores:

```bash
search_errors() {
    echo "=== Errores encontrados ==="
    grep "ERROR" "$LOG_FILE" | while read line; do
        echo "  → $line"
    done
}
```

**Descomenta** la sección del Paso 5.

---

## Paso 6: Buscar por Fecha

Permite buscar por una fecha específica:

```bash
search_by_date() {
    local fecha="$1"
    if [[ -z "$fecha" ]]; then
        fecha="2024-01-15"  # Default
    fi
    grep "$fecha" "$LOG_FILE"
}
```

**Descomenta** la sección del Paso 6.

---

## Paso 7: Generar Reporte

Crea un archivo de reporte:

```bash
generate_report() {
    local report_file="$REPORT_DIR/report_$(date +%Y%m%d_%H%M%S).txt"
    {
        echo "=== Reporte de Logs ==="
        echo "Fecha: $(date)"
        echo "Archivo: $LOG_FILE"
        echo ""
        show_stats
    } > "$report_file"
    echo "Reporte guardado en: $report_file"
}
```

**Descomenta** la sección del Paso 7.

---

## Paso 8: Menú Principal con Case

Implementa el menú usando case y while:

```bash
while true; do
    show_menu
    read -p "Opción: " choice
    case $choice in
        1) show_stats ;;
        2) search_errors ;;
        3) search_by_date ;;
        4) generate_report ;;
        5) break ;;
        *) echo "Opción inválida" ;;
    esac
done
```

**Descomenta** la sección del Paso 8.

---

## Paso 9: Validación de Archivo

Verifica que el archivo exista antes de procesar:

```bash
if [[ ! -f "$LOG_FILE" ]]; then
    echo "Error: Archivo no encontrado"
    exit 1
fi
```

**Descomenta** la sección del Paso 9.

---

## Paso 10: Análisis por Nivel

Cuenta mensajes por nivel usando for:

```bash
analyze_levels() {
    local levels=("INFO" "DEBUG" "WARNING" "ERROR" "CRITICAL")
    for level in "${levels[@]}"; do
        local count=$(grep -c "$level" "$LOG_FILE" 2>/dev/null || echo 0)
        printf "  %-10s: %d\n" "$level" "$count"
    done
}
```

**Descomenta** la sección del Paso 10.

---

## ✅ Verificación

Al ejecutar el script completo, deberías ver:

```
=== Analizador de Logs ===
1. Estadísticas generales
2. Buscar errores
3. Buscar por fecha
4. Generar reporte
5. Salir
Opción: 1

=== Estadísticas ===
Total líneas: 20
Errores: 3
Warnings: 2
Por nivel:
  INFO      : 10
  DEBUG     : 3
  WARNING   : 2
  ERROR     : 3
  CRITICAL  : 2
```

---

## 🎓 Conceptos Aplicados

| Concepto  | Uso en el Proyecto       |
| --------- | ------------------------ |
| Variables | `LOG_FILE`, `REPORT_DIR` |
| Expansión | `${fecha:-default}`      |
| if/elif   | Validación de archivo    |
| for       | Iterar sobre niveles     |
| while     | Menú persistente         |
| case      | Procesar opciones        |
| Funciones | Modularización           |

---

## 🚀 Extensiones Opcionales

Si completaste todo, intenta agregar:

1. **Filtro por hora**: Buscar logs entre dos horas
2. **Top errores**: Mostrar los errores más frecuentes
3. **Exportar CSV**: Generar reporte en formato CSV
4. **Color**: Agregar colores al output

---

## 🔗 Recursos

- [Log Analysis Best Practices](https://tldp.org/LDP/abs/html/system.html)
- [Bash Functions](https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html)

---

## ➡️ Siguiente

¡Has completado las prácticas! Continúa con el [Proyecto de la Semana](../../3-proyecto/README.md)
