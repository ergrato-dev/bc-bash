# 📖 Glosario - Semana 4: Funciones y Arrays

## A

### Array (Arreglo)

Estructura de datos que almacena multiples valores bajo un solo nombre.

```bash
declare -a frutas=("manzana" "pera" "uva")
```

### Array Asociativo

Array que usa claves de texto en lugar de indices numericos.

```bash
declare -A usuario
usuario[nombre]="Juan"
usuario[edad]=25
```

### Argumento

Valor pasado a una funcion o script. Accesible via `$1`, `$2`, etc.

---

## D

### declare

Comando built-in para declarar variables con atributos especiales.

```bash
declare -a array    # Array indexado
declare -A hash     # Array asociativo
declare -i numero   # Variable entera
declare -r const    # Variable de solo lectura
```

---

## E

### echo vs return

- `echo`: Imprime texto a stdout (puede capturarse con `$()`)
- `return`: Establece codigo de salida (0-255)

### Exit Status

Codigo numerico (0-255) que indica si un comando fue exitoso (0) o fallo (>0).

---

## F

### Funcion

Bloque de codigo reutilizable que puede recibir parametros.

```bash
mi_funcion() {
    local param="$1"
    echo "Valor: $param"
}
```

---

## I

### Indice

Posicion numerica de un elemento en un array (inicia en 0).

```bash
echo "${array[0]}"   # Primer elemento
echo "${array[-1]}"  # Ultimo elemento
```

---

## K

### Key (Clave)

Identificador de texto usado en arrays asociativos.

```bash
echo "${usuario[nombre]}"  # nombre es la clave
```

---

## L

### local

Keyword para declarar variables con alcance limitado a la funcion.

```bash
mi_funcion() {
    local variable="valor"  # Solo existe dentro de la funcion
}
```

### Length (Longitud)

Numero de elementos en un array.

```bash
echo "${#array[@]}"  # Cantidad de elementos
```

---

## P

### Parametros Posicionales

Variables especiales que contienen argumentos: `$1`, `$2`, `$@`, `$#`.

```bash
$1    # Primer argumento
$@    # Todos los argumentos
$#    # Numero de argumentos
```

---

## R

### return

Comando para salir de una funcion con un codigo de estado.

```bash
is_valid() {
    [[ -n "$1" ]] && return 0 || return 1
}
```

---

## S

### Slice (Rebanada)

Subconjunto de elementos de un array.

```bash
echo "${array[@]:2:3}"  # 3 elementos desde indice 2
```

### Subshell

Proceso hijo de Bash que ejecuta comandos.

```bash
resultado=$(mi_funcion)  # Captura output en subshell
```

---

## U

### unset

Comando para eliminar variables o elementos de array.

```bash
unset array[2]    # Elimina elemento en indice 2
unset array       # Elimina todo el array
```

---

## Simbolos Especiales

### ${array[@]}

Expande a todos los elementos del array como palabras separadas.

### ${array[*]}

Expande a todos los elementos como una sola cadena.

### ${!array[@]}

Retorna todos los indices/claves del array.

### ${#array[@]}

Retorna la cantidad de elementos en el array.

---

## 📚 Referencias

- [GNU Bash - Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)
- [GNU Bash - Functions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions)
- [TLDP - Functions](https://tldp.org/LDP/abs/html/functions.html)
- [TLDP - Arrays](https://tldp.org/LDP/abs/html/arrays.html)

---

## 🔗 Navegacion

| ⬅️ Anterior                         | 🏠 Semana               |
| ----------------------------------- | ----------------------- |
| [Recursos](../4-recursos/README.md) | [Week 04](../README.md) |
