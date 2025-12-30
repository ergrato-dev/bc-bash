# 📚 Teoría - Semana 02

## 🎯 Objetivos de la Semana

Al completar esta sección teórica serás capaz de:

- ✅ Dominar pipes y redirección de flujos (stdin, stdout, stderr)
- ✅ Filtrar y buscar texto con grep y expresiones regulares
- ✅ Transformar texto con sed (stream editor)
- ✅ Procesar datos estructurados con awk
- ✅ Construir pipelines de procesamiento de texto

## 📖 Contenidos

### 1. [Pipes y Redirección](01-pipes-redireccion.md)

- Los tres flujos de datos: stdin, stdout, stderr
- Operadores de redirección: `>`, `>>`, `2>`, `&>`
- Pipes: conectar comandos con `|`
- Comandos `tee` y `xargs`

### 2. [grep - Búsqueda y Filtrado](02-grep-filtrado.md)

- Opciones esenciales: `-i`, `-v`, `-n`, `-c`, `-r`
- Expresiones regulares básicas
- grep extendido (`grep -E`)
- Combinaciones útiles con pipes

### 3. [sed - Stream Editor](03-sed-transformacion.md)

- Sustitución con `s/patrón/reemplazo/`
- Flags: `g`, `i`, `p`
- Grupos de captura
- Eliminar e insertar líneas
- Edición in-place con `-i`

### 4. [awk - Procesamiento de Columnas](04-awk-procesamiento.md)

- Campos y separadores
- Patrones y condiciones
- Bloques BEGIN y END
- Variables y cálculos
- Arrays asociativos

## 📁 Ejemplos de Código

La carpeta `ejemplos/` contiene scripts ejecutables que demuestran los conceptos:

| Archivo                                                     | Descripción                        |
| ----------------------------------------------------------- | ---------------------------------- |
| [01-pipes-basicos.sh](ejemplos/01-pipes-basicos.sh)         | Ejemplos de pipes simples          |
| [02-redireccion.sh](ejemplos/02-redireccion.sh)             | Redirección de entrada/salida      |
| [03-grep-ejemplos.sh](ejemplos/03-grep-ejemplos.sh)         | Búsqueda con grep                  |
| [04-sed-ejemplos.sh](ejemplos/04-sed-ejemplos.sh)           | Transformaciones con sed           |
| [05-pipeline-completo.sh](ejemplos/05-pipeline-completo.sh) | Pipeline completo de procesamiento |

## ⏱️ Tiempo Estimado

- **Lectura de teoría**: 1-1.5 horas
- **Experimentar con ejemplos**: 30-45 minutos

## 📊 Orden Recomendado

1. 📖 Lee cada archivo teórico en orden
2. 🧪 Ejecuta los ejemplos de la carpeta `ejemplos/`
3. 💡 Prueba variaciones de los comandos en tu terminal
4. ✅ Completa el checklist de cada sección

## 🔗 Navegación

| ← Anterior                           | Actual        | Siguiente →                  |
| ------------------------------------ | ------------- | ---------------------------- |
| [Semana 01](../../week-01/1-teoria/) | **Semana 02** | [Prácticas](../2-practicas/) |

---

[← Volver al README de la semana](../README.md)
