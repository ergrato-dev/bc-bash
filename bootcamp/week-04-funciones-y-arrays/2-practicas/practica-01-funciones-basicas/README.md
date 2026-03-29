# 🎯 Práctica 1: Funciones Básicas

> **Tiempo estimado**: 25-30 minutos | **Dificultad**: ⭐

## 📋 Objetivo

Aprender a definir y llamar funciones en Bash, entendiendo la sintaxis básica y el flujo de ejecución.

## 📚 Conceptos Cubiertos

- Sintaxis de definición de funciones
- Llamada a funciones
- Variables locales con `local`
- Orden de definición vs ejecución

## 🎯 Instrucciones

1. Abre `starter/script.sh`
2. Lee cada paso y descomenta el código correspondiente
3. Ejecuta el script después de cada paso para ver el resultado
4. Compara tu resultado con `solution/script.sh`

---

## 📝 Tutorial

### Paso 1: Tu Primera Función

Las funciones se definen con `nombre() { comandos; }`:

```bash
saludar() {
    echo "¡Hola desde mi primera función!"
}

# Llamar la función (sin paréntesis)
saludar
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Función con Mensaje Personalizado

Las funciones pueden contener múltiples comandos:

```bash
mostrar_info() {
    echo "=== Información del Sistema ==="
    echo "Usuario: $USER"
    echo "Directorio: $PWD"
    echo "=============================="
}
```

**Descomenta** la sección del Paso 2.

---

### Paso 3: Variables Locales

Usa `local` para variables que solo existen dentro de la función:

```bash
calcular() {
    local resultado=42
    echo "El resultado es: $resultado"
}
# $resultado no existe fuera de calcular()
```

**Descomenta** la sección del Paso 3.

---

### Paso 4: Diferencia entre Local y Global

Sin `local`, las variables son globales:

```bash
variable_global="soy global"

funcion_ejemplo() {
    local var_local="soy local"
    var_sin_local="también soy global"
    echo "Dentro: $var_local"
}
```

**Descomenta** la sección del Paso 4.

---

### Paso 5: Múltiples Funciones

Puedes definir varias funciones y llamarlas en cualquier orden:

```bash
inicio() { echo "Iniciando..."; }
proceso() { echo "Procesando..."; }
fin() { echo "Finalizando..."; }

# Llamar en orden
inicio
proceso
fin
```

**Descomenta** la sección del Paso 5.

---

### Paso 6: Funciones que Llaman Otras Funciones

Las funciones pueden llamar a otras funciones:

```bash
paso_uno() { echo "Paso 1 completado"; }
paso_dos() { echo "Paso 2 completado"; }

ejecutar_todos() {
    paso_uno
    paso_dos
    echo "Todos los pasos completados"
}
```

**Descomenta** la sección del Paso 6.

---

### Paso 7: Orden de Definición

Las funciones deben definirse ANTES de llamarlas:

```bash
# ✅ Correcto: definir primero
mi_funcion() { echo "Funciona"; }
mi_funcion

# ❌ Error: llamar antes de definir
# otra_funcion  # Error: command not found
# otra_funcion() { echo "Tarde"; }
```

**Descomenta** la sección del Paso 7.

---

### Paso 8: Documentar Funciones

Buena práctica: documentar qué hace cada función:

```bash
# Muestra un mensaje de bienvenida
# Uso: bienvenida
bienvenida() {
    echo "================================"
    echo "  Bienvenido al Sistema v1.0"
    echo "================================"
}
```

**Descomenta** la sección del Paso 8.

---

## ✅ Verificación

Ejecuta tu script completo:

```bash
cd starter
chmod +x script.sh
./script.sh
```

Deberías ver la salida de todas las funciones en orden.

## 🎯 Resumen

| Concepto        | Sintaxis                        |
| --------------- | ------------------------------- |
| Definir función | `nombre() { comandos; }`        |
| Llamar función  | `nombre` (sin paréntesis)       |
| Variable local  | `local var="valor"`             |
| Documentar      | Comentarios antes de la función |

## 🔗 Siguiente

[Práctica 2: Parámetros y Retorno](../practica-02-parametros-retorno/README.md)
