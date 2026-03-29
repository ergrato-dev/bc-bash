# 🎯 Práctica 3: Arrays Indexados

> **Tiempo estimado**: 25-30 minutos | **Dificultad**: ⭐⭐

## 📋 Objetivo

Dominar la creación, acceso y manipulación de arrays indexados (numéricos) en Bash.

## 📚 Conceptos Cubiertos

- Declaración de arrays
- Acceso a elementos
- Agregar y eliminar elementos
- Iteración sobre arrays
- Operaciones avanzadas (slice, longitud)

## 🎯 Instrucciones

1. Abre `starter/script.sh`
2. Lee cada paso y descomenta el código
3. Ejecuta para verificar
4. Compara con `solution/script.sh`

---

## 📝 Tutorial

### Paso 1: Crear Arrays

Hay varias formas de crear arrays:

```bash
# Forma directa
frutas=("manzana" "pera" "uva")

# Con declare
declare -a numeros=(1 2 3 4 5)
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Acceder a Elementos

Usa `${array[indice]}` para acceder:

```bash
echo ${frutas[0]}   # primer elemento
echo ${frutas[-1]}  # último elemento
```

**Descomenta** la sección del Paso 2.

---

### Paso 3: Todos los Elementos

`${array[@]}` devuelve todos los elementos:

```bash
echo ${frutas[@]}      # todos
echo ${#frutas[@]}     # cantidad
echo ${!frutas[@]}     # índices
```

**Descomenta** la sección del Paso 3.

---

### Paso 4: Agregar Elementos

Usa `+=` para agregar:

```bash
frutas+=("naranja")
frutas+=("limón" "sandía")
```

**Descomenta** la sección del Paso 4.

---

### Paso 5: Modificar y Eliminar

Modifica por índice, elimina con `unset`:

```bash
frutas[0]="piña"     # modificar
unset 'frutas[1]'    # eliminar
```

**Descomenta** la sección del Paso 5.

---

### Paso 6: Iterar con For

Recorre arrays con for:

```bash
for fruta in "${frutas[@]}"; do
    echo "- $fruta"
done
```

**Descomenta** la sección del Paso 6.

---

### Paso 7: Iterar con Índices

A veces necesitas el índice:

```bash
for i in "${!frutas[@]}"; do
    echo "[$i] ${frutas[$i]}"
done
```

**Descomenta** la sección del Paso 7.

---

### Paso 8: Slice (Subcadena)

Extrae porciones del array:

```bash
# ${array[@]:inicio:cantidad}
echo ${frutas[@]:1:2}  # desde 1, 2 elementos
```

**Descomenta** la sección del Paso 8.

---

## ✅ Verificación

```bash
cd starter
chmod +x script.sh
./script.sh
```

## 🎯 Resumen

| Operación | Sintaxis            |
| --------- | ------------------- |
| Crear     | `arr=("a" "b" "c")` |
| Acceder   | `${arr[0]}`         |
| Todos     | `${arr[@]}`         |
| Cantidad  | `${#arr[@]}`        |
| Índices   | `${!arr[@]}`        |
| Agregar   | `arr+=("d")`        |
| Eliminar  | `unset 'arr[1]'`    |
| Slice     | `${arr[@]:1:2}`     |

## 🔗 Siguiente

[Práctica 4: Arrays Asociativos](../practica-04-arrays-asociativos/README.md)
