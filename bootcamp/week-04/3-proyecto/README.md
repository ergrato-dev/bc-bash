# 📦 Proyecto Semana 4: Gestor de Inventario

> **Tiempo estimado**: 1.5-2 horas | **Nivel**: Intermedio

## 🎯 Descripción

Desarrollar un sistema de gestión de inventario por línea de comandos que permita administrar productos usando funciones y arrays.

## 📋 Requisitos Funcionales

### RF1: Agregar Producto

- Solicitar: nombre, precio, cantidad, categoría
- Generar ID único automáticamente
- Validar que precio y cantidad sean numéricos

### RF2: Listar Productos

- Mostrar tabla formateada con todos los productos
- Incluir: ID, nombre, precio, cantidad, categoría
- Mostrar valor total del inventario

### RF3: Buscar Producto

- Buscar por nombre (parcial, insensible a mayúsculas)
- Buscar por categoría
- Mostrar resultados encontrados

### RF4: Actualizar Stock

- Seleccionar producto por ID
- Aumentar o disminuir cantidad
- Validar que no quede stock negativo

### RF5: Eliminar Producto

- Eliminar por ID
- Confirmar antes de eliminar
- Mostrar mensaje de éxito

### RF6: Estadísticas

- Total de productos
- Valor total del inventario
- Producto más caro
- Producto con más stock
- Productos por categoría

### RF7: Exportar Datos

- Exportar a formato CSV
- Incluir encabezados

### RF8: Menú Interactivo

- Menú con todas las opciones
- Validación de entrada
- Opción de salir

## 🏗️ Estructura del Código

```bash
# Arrays para almacenar datos
declare -a PRODUCTOS_ID=()
declare -a PRODUCTOS_NOMBRE=()
declare -a PRODUCTOS_PRECIO=()
declare -a PRODUCTOS_CANTIDAD=()
declare -a PRODUCTOS_CATEGORIA=()

# Funciones requeridas
generar_id()           # Genera ID único
agregar_producto()     # RF1
listar_productos()     # RF2
buscar_producto()      # RF3
actualizar_stock()     # RF4
eliminar_producto()    # RF5
mostrar_estadisticas() # RF6
exportar_csv()         # RF7
menu_principal()       # RF8
```

## 📁 Estructura de Archivos

```
3-proyecto/
├── README.md              # Este archivo
├── starter/
│   └── inventario.sh      # Plantilla con TODOs
└── solution/
    └── inventario.sh      # Solución completa
```

## 🚀 Cómo Empezar

1. Copia el archivo starter:

```bash
cd starter
chmod +x inventario.sh
```

2. Implementa las funciones en orden:

   - Primero la estructura de datos
   - Luego funciones básicas (agregar, listar)
   - Después funciones de búsqueda
   - Finalmente estadísticas y exportación

3. Prueba cada función antes de continuar

## 💡 Consejos

- Usa `local` para todas las variables dentro de funciones
- Valida SIEMPRE la entrada del usuario
- Usa `printf` para formateo de tablas
- Los arrays paralelos mantienen datos relacionados por índice

## ✅ Criterios de Evaluación

| Criterio          | Peso | Descripción                        |
| ----------------- | ---- | ---------------------------------- |
| Funcionalidad     | 40%  | Todas las funciones operativas     |
| Código limpio     | 25%  | Variables locales, nombres claros  |
| Manejo de errores | 20%  | Validaciones, mensajes claros      |
| UX                | 15%  | Menú intuitivo, formateo agradable |

## 📚 Recursos

- [Teoría: Funciones](../1-teoria/README.md)
- [SVG: Funciones](../0-assets/01-funciones-bash.svg)
- [SVG: Arrays](../0-assets/03-arrays-indexados.svg)

## 🔗 Navegación

| ⬅️ Anterior                           | 🏠 Semana               | ➡️ Siguiente                        |
| ------------------------------------- | ----------------------- | ----------------------------------- |
| [Prácticas](../2-practicas/README.md) | [Week 04](../README.md) | [Recursos](../4-recursos/README.md) |
