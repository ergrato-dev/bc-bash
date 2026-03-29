# 🎯 Práctica 5: Integración - Biblioteca de Funciones

> **Tiempo estimado**: 35-40 minutos | **Dificultad**: ⭐⭐⭐

## 📋 Objetivo

Crear una biblioteca de funciones reutilizables que use arrays para gestionar una agenda de contactos.

## 📚 Conceptos Integrados

- Funciones con parámetros
- Variables locales
- Arrays indexados y asociativos
- Return y echo
- Validación de entrada

## 🎯 Instrucciones

1. Abre `starter/script.sh`
2. Descomenta cada sección progresivamente
3. Cada paso construye sobre el anterior
4. Al final tendrás una agenda funcional

---

## 📝 Tutorial

### Paso 1: Estructura Base

Definimos las variables globales y la estructura:

```bash
declare -a CONTACTOS_NOMBRES=()
declare -a CONTACTOS_TELEFONOS=()
declare -a CONTACTOS_EMAILS=()
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Función Agregar Contacto

Función para añadir un nuevo contacto:

```bash
agregar_contacto() {
    local nombre="$1"
    local telefono="$2"
    local email="$3"
    # Agregar a los arrays...
}
```

**Descomenta** la sección del Paso 2.

---

### Paso 3: Función Listar Contactos

Mostrar todos los contactos:

```bash
listar_contactos() {
    for i in "${!CONTACTOS_NOMBRES[@]}"; do
        echo "${CONTACTOS_NOMBRES[$i]}"
    done
}
```

**Descomenta** la sección del Paso 3.

---

### Paso 4: Función Buscar Contacto

Buscar por nombre y devolver índice:

```bash
buscar_contacto() {
    local busqueda="$1"
    # Recorrer y buscar...
}
```

**Descomenta** la sección del Paso 4.

---

### Paso 5: Función Mostrar Detalles

Mostrar información completa de un contacto:

```bash
mostrar_contacto() {
    local indice="$1"
    # Mostrar nombre, teléfono, email...
}
```

**Descomenta** la sección del Paso 5.

---

### Paso 6: Función Eliminar Contacto

Eliminar un contacto por índice:

```bash
eliminar_contacto() {
    local indice="$1"
    unset 'CONTACTOS_NOMBRES[$indice]'
    # Eliminar de todos los arrays...
}
```

**Descomenta** la sección del Paso 6.

---

### Paso 7: Función de Estadísticas

Mostrar estadísticas de la agenda:

```bash
estadisticas() {
    echo "Total: ${#CONTACTOS_NOMBRES[@]}"
    # Más estadísticas...
}
```

**Descomenta** la sección del Paso 7.

---

### Paso 8: Menú Interactivo

Unir todo en un menú:

```bash
menu_principal() {
    echo "1. Agregar"
    echo "2. Listar"
    # ...
}
```

**Descomenta** la sección del Paso 8.

---

## ✅ Verificación

```bash
cd starter
chmod +x script.sh
./script.sh
```

Deberías poder:

- Agregar contactos
- Listar todos
- Buscar por nombre
- Ver detalles
- Eliminar contactos

## 🎯 Resumen

Esta práctica integra:

| Concepto   | Aplicación                       |
| ---------- | -------------------------------- |
| Funciones  | Cada operación es una función    |
| Parámetros | Datos del contacto               |
| Arrays     | Almacenar múltiples contactos    |
| Return     | Éxito/error de operaciones       |
| Validación | Verificar datos antes de agregar |

## 🔗 Siguiente

[Proyecto: Gestor de Inventario](../../3-proyecto/README.md)
