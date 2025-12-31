# 🎯 Práctica 2: Parámetros y Retorno

> **Tiempo estimado**: 25-30 minutos | **Dificultad**: ⭐⭐

## 📋 Objetivo

Dominar el paso de parámetros a funciones y las diferentes formas de retornar valores.

## 📚 Conceptos Cubiertos

- Parámetros posicionales ($1, $2, $@, $#)
- Valores por defecto
- Return vs echo
- Exit status y $?

## 🎯 Instrucciones

1. Abre `starter/script.sh`
2. Lee cada paso y descomenta el código correspondiente
3. Ejecuta el script después de cada paso
4. Compara con `solution/script.sh`

---

## 📝 Tutorial

### Paso 1: Parámetros Posicionales

Los argumentos se reciben como $1, $2, $3...:

```bash
saludar() {
    echo "Hola $1"
}
saludar "Juan"  # → Hola Juan
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Múltiples Parámetros

Puedes pasar varios argumentos:

```bash
suma() {
    echo $(( $1 + $2 ))
}
suma 5 3  # → 8
```

**Descomenta** la sección del Paso 2.

---

### Paso 3: Valores por Defecto

Usa `${param:-default}` para valores por defecto:

```bash
saludar() {
    local nombre="${1:-Invitado}"
    echo "Hola $nombre"
}
saludar          # → Hola Invitado
saludar "Ana"    # → Hola Ana
```

**Descomenta** la sección del Paso 3.

---

### Paso 4: Todos los Parámetros ($@ y $#)

`$@` contiene todos los argumentos, `$#` el número:

```bash
listar_args() {
    echo "Cantidad: $#"
    for arg in "$@"; do
        echo "  - $arg"
    done
}
```

**Descomenta** la sección del Paso 4.

---

### Paso 5: Return (Código de Salida)

`return` devuelve un código de salida (0-255):

```bash
es_par() {
    (( $1 % 2 == 0 )) && return 0
    return 1
}

if es_par 4; then
    echo "Es par"
fi
```

**Descomenta** la sección del Paso 5.

---

### Paso 6: Echo para Retornar Valores

Para retornar datos, usa echo y captura con $():

```bash
calcular() {
    local resultado=$(( $1 * $2 ))
    echo $resultado
}

valor=$(calcular 5 3)
echo "Resultado: $valor"  # → 15
```

**Descomenta** la sección del Paso 6.

---

### Paso 7: Exit Status ($?)

`$?` contiene el código de salida del último comando:

```bash
archivo_existe() {
    [[ -f "$1" ]]
}

archivo_existe "/etc/passwd"
echo "Exit status: $?"  # → 0 (existe)
```

**Descomenta** la sección del Paso 7.

---

### Paso 8: Combinando Return y Echo

Patrón común: echo para datos, return para éxito/error:

```bash
dividir() {
    [[ $2 -eq 0 ]] && return 1
    echo $(( $1 / $2 ))
    return 0
}

if resultado=$(dividir 10 2); then
    echo "Resultado: $resultado"
else
    echo "Error: división por cero"
fi
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

| Elemento        | Uso                     |
| --------------- | ----------------------- |
| `$1, $2...`     | Parámetros posicionales |
| `$#`            | Número de parámetros    |
| `$@`            | Todos los parámetros    |
| `${1:-default}` | Valor por defecto       |
| `return N`      | Código de salida        |
| `echo valor`    | Retornar datos          |
| `$?`            | Último exit status      |

## 🔗 Siguiente

[Práctica 3: Arrays Indexados](../practica-03-arrays-indexados/README.md)
