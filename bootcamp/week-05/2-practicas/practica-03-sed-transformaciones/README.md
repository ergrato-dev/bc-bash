# Práctica 3: sed Transformaciones

## 🎯 Objetivo

Aprender a transformar texto con sed: sustitución, eliminación e inserción.

## 📚 Conceptos

- Sustitución: `s/patron/reemplazo/flags`
- Eliminación: `d`
- Rango de líneas: `10,20`
- Edición in-place: `-i`

## 📋 Pasos

### Paso 1: Crear Datos de Prueba

Generamos archivos de configuración y texto para transformar.

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Sustitución Básica

El comando `s` sustituye patrones. Sin flag `g`, solo la primera ocurrencia.

```bash
sed 's/foo/bar/' archivo      # Primera ocurrencia
sed 's/foo/bar/g' archivo     # Todas (global)
```

**Descomenta** la sección del Paso 2.

---

### Paso 3: Flags de Sustitución

Modificadores para controlar la sustitución.

```bash
sed 's/foo/bar/g'   # Global
sed 's/foo/bar/i'   # Ignorar caso
sed 's/foo/bar/2'   # Solo la 2da ocurrencia
```

**Descomenta** la sección del Paso 3.

---

### Paso 4: Eliminar Líneas

El comando `d` elimina líneas que coinciden con un patrón.

```bash
sed '/patron/d' archivo    # Eliminar si contiene patron
sed '/^$/d' archivo        # Eliminar líneas vacías
sed '/^#/d' archivo        # Eliminar comentarios
```

**Descomenta** la sección del Paso 4.

---

### Paso 5: Rangos de Líneas

Operar en rangos específicos de líneas.

```bash
sed -n '5,10p' archivo     # Imprimir líneas 5-10
sed '1,5d' archivo         # Eliminar líneas 1-5
sed '10q' archivo          # Primeras 10 líneas
```

**Descomenta** la sección del Paso 5.

---

### Paso 6: Múltiples Comandos

Encadenar varios comandos sed.

```bash
sed -e 's/foo/bar/' -e 's/baz/qux/' archivo
sed 's/foo/bar/; s/baz/qux/' archivo
```

**Descomenta** la sección del Paso 6.

---

### Paso 7: Edición In-Place

Opción `-i` modifica el archivo directamente.

```bash
sed -i 's/old/new/g' archivo           # Modificar directamente
sed -i.bak 's/old/new/g' archivo       # Con backup
```

**Descomenta** la sección del Paso 7.

---

### Paso 8: Transformaciones Avanzadas

Usar grupos de captura y referencias.

```bash
sed 's/\(.*\)/PREFIX_\1/' archivo     # Agregar prefijo
sed 's/\([0-9]*\)/[\1]/g' archivo     # Encerrar números
```

**Descomenta** la sección del Paso 8.

---

## ✅ Verificación

```bash
cd starter
chmod +x script.sh
./script.sh
```

## 🔗 Navegación

[⬅️ Práctica 2](../practica-02-grep-avanzado/README.md) | [➡️ Práctica 4](../practica-04-awk-columnas/README.md)
