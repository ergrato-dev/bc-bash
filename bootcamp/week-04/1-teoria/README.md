# 📚 Teoría - Semana 4: Funciones y Arrays

> **Objetivo**: Organizar código reutilizable y manejar colecciones de datos

## 🎯 ¿Qué son las Funciones y Arrays?

Las **funciones** son bloques de código reutilizables y los **arrays** son colecciones de valores.

## 🤔 ¿Para qué sirven?

### Casos de Uso

- 🔧 **Reutilización**: Escribir una vez, usar muchas veces
- 📦 **Organización**: Código modular y mantenible
- 📊 **Datos Múltiples**: Procesar listas de información
- 🎯 **Bibliotecas**: Crear herramientas compartidas

## 📖 Conceptos Clave

### 1. Funciones

**¿Qué son?** Bloques de código con nombre que ejecutan una tarea específica.

**¿Para qué?** Evitar repetición, organizar lógica, facilitar mantenimiento.

```bash
# Definir función
saludar() {
    echo "Hola $1"
}

# Usar función
saludar "Juan"  # Hola Juan
```

### 2. Funciones con Retorno

**¿Qué son?** Funciones que devuelven un valor.

**¿Para qué?** Calcular resultados, validar condiciones.

```bash
suma() {
    local resultado=$(( $1 + $2 ))
    echo $resultado
}

total=$(suma 5 3)
echo "Resultado: $total"  # 8
```

### 3. Variables Locales

**¿Qué son?** Variables que solo existen dentro de una función.

**¿Para qué?** Evitar conflictos, encapsular lógica.

```bash
mi_funcion() {
    local temporal="valor"
    echo $temporal
}
# $temporal no existe fuera de la función
```

### 4. Arrays (Arreglos)

**¿Qué son?** Variables que contienen múltiples valores.

**¿Para qué?** Almacenar listas, procesar colecciones.

```bash
# Crear array
frutas=("manzana" "pera" "uva")

# Acceder elementos
echo ${frutas[0]}        # manzana
echo ${frutas[@]}        # todos los elementos
echo ${#frutas[@]}       # cantidad: 3

# Agregar elemento
frutas+=("naranja")
```

### 5. Iterar Arrays

**¿Qué es?** Recorrer todos los elementos de un array.

**¿Para qué?** Procesar cada elemento individualmente.

```bash
for fruta in "${frutas[@]}"; do
    echo "Fruta: $fruta"
done
```

### 6. Arrays Asociativos

**¿Qué son?** Arrays indexados por claves (como diccionarios).

**¿Para qué?** Almacenar pares clave-valor.

```bash
# Declarar
declare -A usuario

# Asignar valores
usuario[nombre]="Juan"
usuario[edad]=25

# Acceder
echo ${usuario[nombre]}
```

## 🎨 Ejemplos Prácticos

### 1. Biblioteca de Utilidades

```bash
#!/bin/bash

# Función de validación
validar_archivo() {
    if [ ! -f "$1" ]; then
        echo "Error: $1 no existe"
        return 1
    fi
    return 0
}

# Función de backup
hacer_backup() {
    local origen=$1
    local destino=$2

    if validar_archivo "$origen"; then
        cp "$origen" "$destino"
        echo "Backup completado"
    fi
}
```

### 2. Procesamiento de Lista

```bash
#!/bin/bash

servidores=("web1.com" "web2.com" "web3.com")

verificar_servidor() {
    local servidor=$1
    if ping -c 1 "$servidor" &> /dev/null; then
        echo "✓ $servidor está activo"
    else
        echo "✗ $servidor está caído"
    fi
}

for servidor in "${servidores[@]}"; do
    verificar_servidor "$servidor"
done
```

### 3. Contador con Array Asociativo

```bash
#!/bin/bash

declare -A contador

# Leer archivo y contar palabras
while read linea; do
    for palabra in $linea; do
        ((contador[$palabra]++))
    done
done < archivo.txt

# Mostrar resultados
for palabra in "${!contador[@]}"; do
    echo "$palabra: ${contador[$palabra]}"
done
```

## 🔧 Características Avanzadas

### Argumentos Variables

```bash
sumar_todos() {
    local suma=0
    for num in "$@"; do
        ((suma += num))
    done
    echo $suma
}

resultado=$(sumar_todos 1 2 3 4 5)
```

### Funciones Recursivas

```bash
factorial() {
    if [ $1 -le 1 ]; then
        echo 1
    else
        local temp=$(( $1 - 1 ))
        local result=$(factorial $temp)
        echo $(( $1 * result ))
    fi
}
```

### Exportar Funciones

```bash
# Definir y exportar
mi_funcion() {
    echo "Función exportada"
}
export -f mi_funcion

# Ahora disponible en subshells
```

## 🎓 Mejores Prácticas

1. **Nombres descriptivos**: `calcular_total()` no `ct()`
2. **Una tarea por función**: Funciones cortas y enfocadas
3. **Variables locales**: Usa `local` para evitar conflictos
4. **Documentar funciones**: Comentar propósito y parámetros
5. **Validar parámetros**: Verificar número y tipo de argumentos
6. **Comillas en arrays**: `"${array[@]}"` preserva espacios

## 🔍 Operaciones con Arrays

```bash
# Slice (subcadena)
echo "${array[@]:1:3}"    # Desde índice 1, 3 elementos

# Búsqueda
if [[ " ${array[@]} " =~ " valor " ]]; then
    echo "Encontrado"
fi

# Eliminar elemento
unset array[2]

# Longitud
echo ${#array[@]}
```

## ➡️ Siguiente Paso

- **[ejemplos/](./ejemplos/)**: Código de funciones y arrays
- **[2-practicas](../2-practicas/README.md)**: Práctica con funciones
- **[3-proyecto](../3-proyecto/README.md)**: Gestor de archivos con funciones

---

**💡 Tip**: Las funciones son el camino hacia scripts profesionales. Piensa en ellas como bloques LEGO que puedes combinar de diferentes formas.
