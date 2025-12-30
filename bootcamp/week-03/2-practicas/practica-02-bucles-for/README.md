# 🔄 Práctica 02: Bucles for

> **Dificultad**: ⭐ Básica | **Tiempo estimado**: 25-30 minutos

## 🎯 Objetivos

Al completar esta práctica aprenderás a:

- ✅ Iterar sobre listas de elementos
- ✅ Usar rangos numéricos con `{inicio..fin}`
- ✅ Aplicar el estilo C: `for ((i=0; i<n; i++))`
- ✅ Procesar archivos con patrones glob
- ✅ Recorrer arrays
- ✅ Usar `break` y `continue`

## 📚 Conceptos Clave

![Bucles Bash](../../0-assets/04-bucles-iteracion.svg)

### Sintaxis Básica

```bash
# Sobre una lista
for item in elemento1 elemento2 elemento3; do
    echo "$item"
done

# Con rango
for i in {1..5}; do
    echo "Número: $i"
done

# Estilo C
for ((i=0; i<5; i++)); do
    echo "Índice: $i"
done
```

### Iteración sobre Archivos

```bash
# Todos los archivos .txt
for archivo in *.txt; do
    echo "Procesando: $archivo"
done
```

---

## 📋 Instrucciones

**Abre** [starter/script.sh](starter/script.sh) y sigue los pasos descomentando el código indicado.

```bash
cd starter
chmod +x script.sh
./script.sh
```

---

## Paso 1: Iteración sobre Lista Simple

El bucle for puede iterar sobre una lista de palabras:

```bash
for fruta in manzana naranja plátano; do
    echo "Fruta: $fruta"
done
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

## Paso 2: Rangos Numéricos

Bash permite crear rangos con la sintaxis `{inicio..fin}`:

```bash
for num in {1..5}; do
    echo "Número: $num"
done
```

**Descomenta** la sección del Paso 2.

---

## Paso 3: Rangos con Incremento

Puedes especificar el incremento con `{inicio..fin..paso}`:

```bash
for num in {0..10..2}; do
    echo "Par: $num"
done
```

**Descomenta** la sección del Paso 3.

---

## Paso 4: Estilo C

Para control más preciso, usa la sintaxis estilo C:

```bash
for ((i=0; i<5; i++)); do
    echo "Índice: $i"
done
```

**Descomenta** la sección del Paso 4.

---

## Paso 5: Iteración sobre Arrays

Los arrays se recorren con `${array[@]}`:

```bash
colores=("rojo" "verde" "azul")
for color in "${colores[@]}"; do
    echo "Color: $color"
done
```

**Descomenta** la sección del Paso 5.

---

## Paso 6: Índices de Array

Puedes obtener los índices con `${!array[@]}`:

```bash
for i in "${!colores[@]}"; do
    echo "[$i] = ${colores[$i]}"
done
```

**Descomenta** la sección del Paso 6.

---

## Paso 7: Iteración sobre Archivos

El glob `*` expande a los archivos del directorio:

```bash
for archivo in /etc/*.conf; do
    if [[ -f "$archivo" ]]; then
        echo "Config: $archivo"
    fi
done
```

**Descomenta** la sección del Paso 7.

---

## Paso 8: break - Salir del Bucle

`break` termina el bucle inmediatamente:

```bash
for num in {1..10}; do
    if [[ $num -eq 5 ]]; then
        echo "¡Encontrado 5! Saliendo..."
        break
    fi
    echo "Número: $num"
done
```

**Descomenta** la sección del Paso 8.

---

## Paso 9: continue - Saltar Iteración

`continue` salta a la siguiente iteración:

```bash
for num in {1..5}; do
    if [[ $num -eq 3 ]]; then
        echo "Saltando 3..."
        continue
    fi
    echo "Procesando: $num"
done
```

**Descomenta** la sección del Paso 9.

---

## Paso 10: Bucles Anidados

Puedes anidar bucles para combinaciones:

```bash
for fila in {1..3}; do
    for col in {1..3}; do
        echo -n "[$fila,$col] "
    done
    echo ""  # Nueva línea
done
```

**Descomenta** la sección del Paso 10.

---

## ✅ Verificación

Al completar todos los pasos, tu script debería mostrar:

```
=== Práctica 02: Bucles for ===

--- Paso 1: Lista Simple ---
Fruta: manzana
Fruta: naranja
Fruta: plátano

--- Paso 2: Rangos ---
Número: 1
Número: 2
...

✅ ¡Práctica completada!
```

---

## 🎓 Mejores Prácticas

1. **Siempre usa comillas**: `"${array[@]}"` para evitar problemas con espacios
2. **Verifica archivos**: Usa `[[ -f "$archivo" ]]` antes de procesar
3. **Usa nombres descriptivos**: `for usuario in "${usuarios[@]}"` es más claro que `for i in...`
4. **Evita procesar en bucle**: Si puedes usar una herramienta como `find`, es más eficiente

---

## 🔗 Recursos

- [Bash Manual - Looping Constructs](https://www.gnu.org/software/bash/manual/html_node/Looping-Constructs.html)
- [Bash Arrays](https://www.gnu.org/software/bash/manual/html_node/Arrays.html)

---

## ➡️ Siguiente

Continúa con [Práctica 03: Bucles while/until](../practica-03-bucles-while/README.md)
