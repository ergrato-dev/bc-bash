# 🎯 Práctica 04: Case Statement y Menús

> **Dificultad**: ⭐⭐ Media | **Tiempo estimado**: 30-35 minutos

## 🎯 Objetivos

Al completar esta práctica aprenderás a:

- ✅ Usar la sintaxis básica de `case`
- ✅ Aplicar múltiples patrones con `|`
- ✅ Usar wildcards en patrones (`*`, `?`, `[...]`)
- ✅ Crear menús interactivos
- ✅ Validar opciones de comando
- ✅ Combinar case con bucles para menús persistentes

## 📚 Conceptos Clave

### Sintaxis de case

```bash
case $variable in
    patron1)
        # comandos
        ;;
    patron2|patron3)
        # múltiples patrones
        ;;
    *)
        # default (cualquier otro valor)
        ;;
esac
```

### Patrones Disponibles

| Patrón   | Significado         |
| -------- | ------------------- | ----- |
| `texto`  | Coincidencia exacta |
| `a       | b`                  | a O b |
| `*`      | Cualquier cadena    |
| `?`      | Cualquier carácter  |
| `[abc]`  | a, b, o c           |
| `[a-z]`  | Rango de caracteres |
| `[!abc]` | Negación            |

---

## 📋 Instrucciones

**Abre** [starter/script.sh](starter/script.sh) y sigue los pasos descomentando el código indicado.

```bash
cd starter
chmod +x script.sh
./script.sh
```

---

## Paso 1: Case Básico

El case evalúa una variable contra patrones:

```bash
opcion="a"
case $opcion in
    a) echo "Seleccionaste A" ;;
    b) echo "Seleccionaste B" ;;
    *) echo "Opción desconocida" ;;
esac
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

## Paso 2: Múltiples Patrones

Usa `|` para agrupar patrones:

```bash
case $respuesta in
    s|S|si|SI|Si)
        echo "Respondiste SÍ"
        ;;
    n|N|no|NO|No)
        echo "Respondiste NO"
        ;;
esac
```

**Descomenta** la sección del Paso 2.

---

## Paso 3: Wildcards con \*

El `*` coincide con cualquier cadena:

```bash
archivo="imagen.jpg"
case $archivo in
    *.jpg|*.png|*.gif)
        echo "Es una imagen"
        ;;
    *.txt|*.md)
        echo "Es un documento"
        ;;
    *)
        echo "Tipo desconocido"
        ;;
esac
```

**Descomenta** la sección del Paso 3.

---

## Paso 4: Rangos de Caracteres

Usa `[...]` para rangos:

```bash
caracter="5"
case $caracter in
    [0-9])
        echo "Es un dígito"
        ;;
    [a-z])
        echo "Es letra minúscula"
        ;;
    [A-Z])
        echo "Es letra mayúscula"
        ;;
esac
```

**Descomenta** la sección del Paso 4.

---

## Paso 5: Validación de Argumentos

Case es ideal para procesar flags de scripts:

```bash
case $1 in
    -h|--help)
        echo "Mostrar ayuda"
        ;;
    -v|--version)
        echo "Versión 1.0"
        ;;
    -f|--file)
        echo "Archivo: $2"
        ;;
esac
```

**Descomenta** la sección del Paso 5.

---

## Paso 6: Menú Simple

Combina case con echo para crear menús:

```bash
echo "1. Opción A"
echo "2. Opción B"
echo "3. Salir"

case $seleccion in
    1) accion_a ;;
    2) accion_b ;;
    3) exit 0 ;;
esac
```

**Descomenta** la sección del Paso 6.

---

## Paso 7: Menú con Bucle

Para un menú persistente, usa while:

```bash
while true; do
    echo "=== Menú ==="
    read -p "Opción: " opt
    case $opt in
        q|Q) break ;;
        *) echo "Procesando..." ;;
    esac
done
```

**Descomenta** la sección del Paso 7.

---

## Paso 8: Procesador de Comandos

Simula un shell simple:

```bash
case $comando in
    ls) ls -la ;;
    pwd) pwd ;;
    date) date ;;
    exit) break ;;
esac
```

**Descomenta** la sección del Paso 8.

---

## Paso 9: Calculadora con Case

Usa case para operaciones:

```bash
case $operador in
    +) resultado=$((a + b)) ;;
    -) resultado=$((a - b)) ;;
    x|\*) resultado=$((a * b)) ;;
    /) resultado=$((a / b)) ;;
esac
```

**Descomenta** la sección del Paso 9.

---

## Paso 10: Case Anidado

Puedes anidar case statements:

```bash
case $categoria in
    fruta)
        case $item in
            manzana) echo "Roja" ;;
            naranja) echo "Naranja" ;;
        esac
        ;;
esac
```

**Descomenta** la sección del Paso 10.

---

## ✅ Verificación

Al completar todos los pasos, tu script debería mostrar:

```
=== Práctica 04: Case Statement ===

--- Paso 1: Case Básico ---
Seleccionaste opción A

--- Paso 3: Wildcards ---
documento.txt → Es un documento de texto
...

✅ ¡Práctica completada!
```

---

## 🎓 Mejores Prácticas

1. **Siempre incluye default (`*`)**: Maneja casos inesperados
2. **Ordena patrones de específico a general**: Los más específicos primero
3. **Usa `;;&` para fall-through**: Si quieres que continúe evaluando (Bash 4+)
4. **Combina con while para menús**: Mejor experiencia de usuario

---

## 🔗 Recursos

- [Bash Manual - Case](https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html#index-case)
- [Pattern Matching](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html)

---

## ➡️ Siguiente

Continúa con [Práctica 05: Integración](../practica-05-integracion/README.md)
