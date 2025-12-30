# 📚 Teoría - Módulo 3: Variables y Control de Flujo

> **Objetivo**: Crear scripts inteligentes con lógica condicional y bucles

## 🎯 ¿Qué son las Variables y el Control de Flujo?

Las **variables** almacenan datos y el **control de flujo** permite tomar decisiones y repetir acciones.

## 🤔 ¿Para qué sirven?

### Casos de Uso

- 🎯 **Scripts Interactivos**: Menús y opciones de usuario
- 🔄 **Procesamiento Masivo**: Aplicar acciones a múltiples archivos
- ✅ **Validación**: Verificar condiciones antes de ejecutar
- 🤖 **Automatización Inteligente**: Scripts que deciden qué hacer

## 📖 Conceptos Clave

### 1. Variables

**¿Qué son?** Contenedores de datos que pueden cambiar.

**¿Para qué?** Almacenar información temporalmente, configuración, resultados.

```bash
# Variables simples
nombre="Juan"
edad=25
activo=true

# Variables de sistema
echo $HOME    # Directorio home
echo $USER    # Usuario actual
echo $PATH    # Rutas de ejecutables
```

### 2. Expansión de Variables

**¿Qué es?** Formas de acceder y manipular variables.

**¿Para qué?** Extraer partes, reemplazar texto, valores por defecto.

```bash
archivo="documento.txt"
echo ${archivo%.txt}           # documento
echo ${archivo/documento/file} # file.txt
echo ${variable:-"default"}    # Valor por defecto
```

### 3. Condicionales (if)

**¿Qué son?** Estructuras que ejecutan código según condiciones.

**¿Para qué?** Tomar decisiones en el script.

```bash
if [ $edad -ge 18 ]; then
    echo "Es mayor de edad"
else
    echo "Es menor de edad"
fi
```

### 4. Case - Múltiples Opciones

**¿Qué es?** Evalúa una variable contra múltiples patrones.

**¿Para qué?** Menús, procesamiento según tipo de entrada.

```bash
case $opcion in
    1)
        echo "Opción 1 seleccionada"
        ;;
    2)
        echo "Opción 2 seleccionada"
        ;;
    *)
        echo "Opción inválida"
        ;;
esac
```

### 5. Bucle for

**¿Qué es?** Itera sobre una lista de elementos.

**¿Para qué?** Procesar múltiples archivos, números, etc.

```bash
# Iterar sobre archivos
for archivo in *.txt; do
    echo "Procesando: $archivo"
done

# Iterar sobre rango
for i in {1..10}; do
    echo "Número: $i"
done
```

### 6. Bucle while

**¿Qué es?** Ejecuta mientras una condición sea verdadera.

**¿Para qué?** Esperar eventos, lectura de archivos, menús.

```bash
contador=1
while [ $contador -le 5 ]; do
    echo "Iteración: $contador"
    ((contador++))
done
```

### 7. Argumentos del Script

**¿Qué son?** Parámetros pasados al ejecutar el script.

**¿Para qué?** Hacer scripts flexibles y reutilizables.

```bash
# ./script.sh archivo.txt backup/
echo "Archivo: $1"    # Primer argumento
echo "Destino: $2"    # Segundo argumento
echo "Total: $#"      # Número de argumentos
```

## 🎨 Ejemplos Prácticos

### 1. Script con Menú

```bash
#!/bin/bash

while true; do
    echo "=== Menú ==="
    echo "1. Listar archivos"
    echo "2. Crear backup"
    echo "3. Salir"
    read -p "Opción: " opcion

    case $opcion in
        1) ls -la ;;
        2) tar -czf backup.tar.gz * ;;
        3) exit 0 ;;
        *) echo "Opción inválida" ;;
    esac
done
```

### 2. Procesamiento Masivo

```bash
#!/bin/bash

# Procesar todos los logs
for log in /var/log/*.log; do
    if [ -f "$log" ]; then
        echo "Analizando: $log"
        grep "ERROR" "$log" | wc -l
    fi
done
```

### 3. Validación de Entrada

```bash
#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Uso: $0 <archivo>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Error: $1 no existe"
    exit 1
fi

echo "Procesando $1..."
```

## 🔧 Operadores de Comparación

### Números

- `-eq`: Igual
- `-ne`: Diferente
- `-lt`: Menor que
- `-le`: Menor o igual
- `-gt`: Mayor que
- `-ge`: Mayor o igual

### Cadenas

- `=`: Igual
- `!=`: Diferente
- `-z`: Cadena vacía
- `-n`: Cadena no vacía

### Archivos

- `-f`: Es archivo regular
- `-d`: Es directorio
- `-e`: Existe
- `-r`: Es legible
- `-w`: Es escribible
- `-x`: Es ejecutable

## 🎓 Mejores Prácticas

1. **Usa `[[` en vez de `[`**: Más seguro y potente
2. **Comillas en variables**: `"$variable"` previene errores
3. **Valida argumentos**: Siempre verifica entrada del usuario
4. **Manejo de errores**: Usa `set -e` o valida cada paso
5. **Nombres descriptivos**: Variables con nombres claros

## ➡️ Siguiente Paso

- **[demos/](./demos/)**: Ejemplos interactivos para ejecutar
- **[ejemplos/](./ejemplos/)**: Código comentado para estudiar
- **[2-practicas](../2-practicas/README.md)**: Práctica guiada
- **[3-proyecto](../3-proyecto/README.md)**: Sistema de menús completo

---

**💡 Tip**: El control de flujo convierte scripts lineales en programas inteligentes que pueden adaptarse a diferentes situaciones.
