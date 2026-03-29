# 📖 Glosario - Semana 3: Variables y Control de Flujo

## Términos Clave

### A

**Array**
: Estructura de datos que almacena múltiples valores bajo un mismo nombre, accesibles por índice.
```bash
colores=("rojo" "verde" "azul")
echo "${colores[0]}"  # rojo
```

**Argumento**
: Valor pasado a un script o función al momento de su ejecución.
```bash
./script.sh argumento1 argumento2
# $1 = argumento1, $2 = argumento2
```

### B

**break**
: Comando que termina la ejecución de un bucle inmediatamente.
```bash
for i in {1..10}; do
    [[ $i -eq 5 ]] && break
done
```

**Bucle (Loop)**
: Estructura que repite un bloque de código múltiples veces.

### C

**case**
: Estructura condicional que evalúa una variable contra múltiples patrones.
```bash
case $opcion in
    a) echo "Opción A" ;;
    b) echo "Opción B" ;;
    *) echo "Default" ;;
esac
```

**Condicional**
: Estructura que ejecuta código basándose en si una condición es verdadera o falsa.

**continue**
: Comando que salta a la siguiente iteración de un bucle.

### D

**declare**
: Comando para declarar variables con atributos específicos.
```bash
declare -a array    # Array indexado
declare -A hash     # Array asociativo
declare -i numero   # Entero
declare -r constante="valor"  # Solo lectura
```

### E

**elif**
: Abreviatura de "else if", permite evaluar condiciones adicionales.

**esac**
: Palabra clave que cierra una estructura `case` (es "case" al revés).

**Exit Status**
: Código numérico (0-255) que indica el resultado de un comando. 0 = éxito.

**Expansión de Parámetros**
: Manipulación de variables usando sintaxis especial.
```bash
${var:-default}   # Valor por defecto
${var:0:5}        # Substring
${var#pattern}    # Eliminar prefijo
${var%pattern}    # Eliminar sufijo
```

### F

**fi**
: Palabra clave que cierra una estructura `if`.

**for**
: Bucle que itera sobre una lista de elementos.
```bash
for item in lista; do
    echo "$item"
done
```

### G

**Glob Pattern**
: Patrón de coincidencia de archivos usando wildcards.
```bash
*.txt     # Todos los .txt
file?.sh  # file1.sh, fileA.sh, etc.
[abc]*    # Empieza con a, b o c
```

### I

**if**
: Estructura condicional básica.
```bash
if [[ condición ]]; then
    # código
fi
```

**IFS (Internal Field Separator)**
: Variable que define los separadores de campos para división de strings.

### L

**local**
: Declara una variable con alcance local dentro de una función.
```bash
mi_funcion() {
    local variable="valor"
}
```

### O

**Operadores de Comparación**
: Símbolos para comparar valores.
```bash
# Numéricos
-eq  # igual
-ne  # diferente
-lt  # menor que
-le  # menor o igual
-gt  # mayor que
-ge  # mayor o igual

# Strings
==   # igual
!=   # diferente
-z   # cadena vacía
-n   # cadena no vacía
```

**Operadores de Archivo**
: Tests para verificar propiedades de archivos.
```bash
-f  # es archivo regular
-d  # es directorio
-e  # existe
-r  # es legible
-w  # es escribible
-x  # es ejecutable
```

### P

**Pattern Matching**
: Coincidencia de patrones en strings o archivos.

### R

**read**
: Comando para leer entrada del usuario o de archivos.
```bash
read -p "Nombre: " nombre
read -r linea < archivo.txt
```

**return**
: Termina una función y opcionalmente retorna un código de salida.

### S

**Subshell**
: Proceso hijo de la shell actual con su propio entorno.
```bash
(cd /tmp && ls)  # Ejecuta en subshell
```

### T

**test / [[ ]]**
: Comando y sintaxis para evaluar condiciones.
```bash
[[ -f archivo ]] && echo "Existe"
test -d /tmp && echo "Es directorio"
```

**then**
: Palabra clave que indica el inicio del bloque de código en un `if`.

### U

**until**
: Bucle que ejecuta mientras la condición sea falsa.
```bash
until [[ condición ]]; do
    # código
done
```

### V

**Variable**
: Contenedor nombrado que almacena un valor.
```bash
nombre="valor"
echo "$nombre"
```

**Variable de Entorno**
: Variable disponible para procesos hijos.
```bash
export PATH="/nuevo/path:$PATH"
```

### W

**while**
: Bucle que ejecuta mientras la condición sea verdadera.
```bash
while [[ condición ]]; do
    # código
done
```

---

## 📚 Referencias

- [GNU Bash Manual - Shell Parameters](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html)
- [GNU Bash Manual - Conditional Constructs](https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html)
- [TLDP - Test Constructs](https://tldp.org/LDP/abs/html/tests.html)
