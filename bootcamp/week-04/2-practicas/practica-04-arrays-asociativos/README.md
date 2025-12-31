# 🎯 Práctica 4: Arrays Asociativos

> **Tiempo estimado**: 30-35 minutos | **Dificultad**: ⭐⭐

## 📋 Objetivo

Dominar los arrays asociativos (diccionarios) que usan claves en lugar de índices numéricos.

## 📚 Conceptos Cubiertos

- Declaración con `declare -A`
- Acceso por clave
- Iterar claves y valores
- Casos de uso prácticos

## 🎯 Instrucciones

1. Abre `starter/script.sh`
2. Descomenta código paso a paso
3. Ejecuta y verifica
4. Compara con `solution/script.sh`

---

## 📝 Tutorial

### Paso 1: Declarar Array Asociativo

**Obligatorio** usar `declare -A`:

```bash
declare -A usuario
usuario[nombre]="Juan"
usuario[edad]=25
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Sintaxis Compacta

Puedes declarar todo en una línea:

```bash
declare -A colores=(
    [rojo]="#FF0000"
    [verde]="#00FF00"
    [azul]="#0000FF"
)
```

**Descomenta** la sección del Paso 2.

---

### Paso 3: Acceder a Valores

Usa la clave para acceder:

```bash
echo ${usuario[nombre]}   # Juan
echo ${usuario[edad]}     # 25
```

**Descomenta** la sección del Paso 3.

---

### Paso 4: Obtener Claves y Valores

`${!array[@]}` devuelve las claves:

```bash
echo ${!usuario[@]}  # claves
echo ${usuario[@]}   # valores
echo ${#usuario[@]}  # cantidad
```

**Descomenta** la sección del Paso 4.

---

### Paso 5: Iterar Array Asociativo

Itera por claves y accede a valores:

```bash
for clave in "${!usuario[@]}"; do
    echo "$clave: ${usuario[$clave]}"
done
```

**Descomenta** la sección del Paso 5.

---

### Paso 6: Verificar si Existe Clave

Usa `-v` para verificar existencia:

```bash
if [[ -v usuario[nombre] ]]; then
    echo "Clave 'nombre' existe"
fi
```

**Descomenta** la sección del Paso 6.

---

### Paso 7: Modificar y Eliminar

Similar a arrays indexados:

```bash
usuario[edad]=26           # modificar
unset 'usuario[temporal]'  # eliminar
```

**Descomenta** la sección del Paso 7.

---

### Paso 8: Caso Práctico - Configuración

Arrays asociativos son ideales para configuraciones:

```bash
declare -A config=(
    [host]="localhost"
    [port]="8080"
    [debug]="true"
)
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

| Operación | Sintaxis              |
| --------- | --------------------- |
| Declarar  | `declare -A arr`      |
| Asignar   | `arr[clave]="valor"`  |
| Acceder   | `${arr[clave]}`       |
| Claves    | `${!arr[@]}`          |
| Valores   | `${arr[@]}`           |
| Existe?   | `[[ -v arr[clave] ]]` |
| Eliminar  | `unset 'arr[clave]'`  |

## 🔗 Siguiente

[Práctica 5: Integración](../practica-05-integracion/README.md)
