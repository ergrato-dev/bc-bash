# 📖 Glosario - Semana 5

## 🎯 Tema: Procesamiento de Texto y Expresiones Regulares

---

## A

### Ancla (Anchor)

Metacarácter que coincide con una posición, no un carácter. `^` (inicio de línea) y `$` (fin de línea).

```bash
grep "^ERROR" file.log    # Líneas que empiezan con ERROR
grep "done$" file.log     # Líneas que terminan con done
```

### awk

Lenguaje de procesamiento de texto orientado a columnas. Divide líneas en campos y permite operaciones complejas.

```bash
awk '{print $1, $3}' file.txt    # Imprime columnas 1 y 3
awk -F':' '{sum+=$2}' file.csv   # Suma columna 2 con delimitador :
```

---

## B

### Backreference

Referencia a un grupo capturado anteriormente en la expresión regular. Se usa `\1`, `\2`, etc.

```bash
sed 's/\(word\)/[\1]/g'    # Captura "word" y lo rodea de corchetes
echo "hello hello" | sed 's/\(.*\) \1/\1/'   # Elimina duplicados
```

### BEGIN (awk)

Bloque especial en awk que se ejecuta antes de procesar cualquier línea de entrada.

```bash
awk 'BEGIN {print "Header"} {print $0}' file.txt
```

---

## C

### Clase de Caracteres

Conjunto de caracteres entre corchetes que coincide con cualquiera de ellos.

```bash
[aeiou]     # Cualquier vocal
[0-9]       # Cualquier dígito
[A-Za-z]    # Cualquier letra
[^0-9]      # Cualquier cosa excepto dígito
```

### Cuantificador

Especifica cuántas veces debe aparecer el elemento anterior.

| Símbolo | Significado         |
| ------- | ------------------- |
| `*`     | 0 o más veces       |
| `+`     | 1 o más veces       |
| `?`     | 0 o 1 vez           |
| `{n}`   | Exactamente n veces |
| `{n,m}` | Entre n y m veces   |

---

## D

### Delimitador

Carácter que separa campos en un archivo. Por defecto espacios en awk.

```bash
awk -F','     # Usa coma como delimitador
awk -F':'     # Usa dos puntos
awk -F'\t'    # Usa tabulador
```

---

## E

### END (awk)

Bloque especial en awk que se ejecuta después de procesar todas las líneas.

```bash
awk '{sum+=$1} END {print "Total:", sum}' file.txt
```

### ERE (Extended Regular Expressions)

Expresiones regulares extendidas. Activan con `grep -E` o `egrep`.

```bash
grep -E "one|two|three"      # Alternancia
grep -E "[0-9]{3}-[0-9]{4}"  # Cuantificadores
```

---

## F

### Field (Campo)

En awk, cada parte de una línea separada por el delimitador. `$1`, `$2`, etc.

```bash
# Para: "Juan 25 Madrid"
# $1 = Juan, $2 = 25, $3 = Madrid, $0 = línea completa
```

### FS (Field Separator)

Variable awk que define el separador de campos de entrada.

```bash
awk 'BEGIN {FS=","} {print $1}'    # Equivale a -F','
```

---

## G

### grep

**G**lobal **R**egular **E**xpression **P**rint. Busca patrones en archivos.

```bash
grep "pattern" file           # Búsqueda básica
grep -i "pattern" file        # Case insensitive
grep -v "pattern" file        # Invertir (líneas sin patrón)
grep -E "regex" file          # Extended regex
grep -r "pattern" dir/        # Recursivo
```

### Greedy (Codicioso)

Comportamiento por defecto de cuantificadores: coinciden lo máximo posible.

```bash
echo "<tag>text</tag>" | sed 's/<.*>//'
# Resultado: "" (elimina todo, es greedy)
```

---

## I

### In-place Editing

Modificar archivo directamente con sed usando `-i`.

```bash
sed -i 's/old/new/g' file.txt         # Modifica directamente
sed -i.bak 's/old/new/g' file.txt     # Crea backup .bak
```

---

## M

### Metacarácter

Carácter con significado especial en regex: `. ^ $ * + ? { } [ ] \ | ( )`

```bash
.      # Cualquier carácter
^      # Inicio de línea
$      # Fin de línea
\      # Escape (literaliza el siguiente)
```

---

## N

### NF (Number of Fields)

Variable awk con el número de campos en la línea actual.

```bash
awk '{print NF}'           # Campos por línea
awk '{print $NF}'          # Último campo
awk '{print $(NF-1)}'      # Penúltimo campo
```

### NR (Number of Records)

Variable awk con el número de línea actual (registro).

```bash
awk '{print NR, $0}'       # Numerar líneas
awk 'NR > 1'               # Saltar encabezado
awk 'NR == 5'              # Solo línea 5
```

---

## O

### OFS (Output Field Separator)

Variable awk que define el separador de campos de salida.

```bash
awk 'BEGIN {OFS=","} {print $1, $2}'    # Salida con comas
```

---

## P

### Pattern (Patrón)

Expresión que describe un conjunto de cadenas a buscar.

### Pipeline (Tubería)

Conexión de comandos donde la salida de uno es entrada del siguiente.

```bash
cat file | grep "error" | sed 's/error/ERROR/' | awk '{print $1}'
```

### POSIX Character Classes

Clases predefinidas portables.

| Clase       | Equivale a    |
| ----------- | ------------- |
| `[:alpha:]` | `[A-Za-z]`    |
| `[:digit:]` | `[0-9]`       |
| `[:alnum:]` | `[A-Za-z0-9]` |
| `[:space:]` | Espacios/tabs |

---

## R

### Regex / RegExp

**Reg**ular **Ex**pression. Patrón que describe conjuntos de cadenas.

### Record (Registro)

En awk, cada línea de entrada es un registro.

---

## S

### sed

**S**tream **Ed**itor. Procesa texto línea por línea aplicando transformaciones.

```bash
sed 's/old/new/'      # Sustituir primera ocurrencia
sed 's/old/new/g'     # Sustituir todas (global)
sed '/pattern/d'      # Eliminar líneas con patrón
sed -n 'p'            # Suprimir salida automática
```

### Substitution

Comando sed más común. Sintaxis: `s/patrón/reemplazo/flags`

```bash
sed 's/cat/dog/'          # Primera ocurrencia
sed 's/cat/dog/g'         # Todas (global)
sed 's/cat/dog/gi'        # Global + case insensitive
```

---

## W

### Word Boundary

Límite de palabra en regex. `\b` en ERE, `\<` y `\>` en BRE.

```bash
grep '\bword\b' file      # "word" como palabra completa
grep '\<the\>' file       # No coincide "there" o "other"
```

---

## 📚 Referencias

- [GNU grep Manual](https://www.gnu.org/software/grep/manual/)
- [GNU sed Manual](https://www.gnu.org/software/sed/manual/)
- [GNU awk Manual](https://www.gnu.org/software/gawk/manual/)
- [regex101.com](https://regex101.com/) - Tester interactivo

---

## 🔗 Navegación

← [Recursos](../4-recursos/) | [README →](../README.md)
